/*=============================================================================
**
** Source: wsasendtorecvfrom3.c (WSASendTo, WSARecvFrom)
**
** Purpose: This test sends and receives a buffer using wsasendto and 
**          wsasendrecv. The operations are UDP, Non-Blocking and Overlapped.
**          The data transfered is compared at the end of the test.
** 
** Dependencies: PAL_Initialize
**               PAL_Terminate
**               Fail
**               WSAStartup
**               WSACleanup
**               socket
**               memset
**               closesocket
**               GetLastError
**               listen
**               accept
**               CreateEvent
**               WaitForSingleObject
**  
** 
**  Copyright (c) 2002 Microsoft Corporation.  All rights reserved.
** 
**  The use and distribution terms for this software are contained in the file
**  named license.txt, which can be found in the root of this distribution.
**  By using this software in any fashion, you are agreeing to be bound by the
**  terms of this license.
** 
**  You must not remove this notice, or any other, from this software.
** 
**
**===========================================================================*/

#include <palsuite.h>
#include "wsacommon.h"

/**
 * Global variables
 */


const int       listenBacklog   = 1;    /* backlog for listen */
const int       THREAD_FAIL     = 0; /* server port number */
const int       THREAD_SUCCESS  = 1;    /* backlog for listen */
const int       THREAD_UNDEFINED = 2;    /* backlog for listen */
const char      srcString[] = "test for wsasendto and wsarecvfrom";

/* Thread that is used as a client */
void PALAPI Thread_Client(LPVOID lpParam);

/* utility cleanup function */
static int CloseEventHandle(HANDLE Event);
static int CloseThreadHandle(HANDLE thread);
static int WaitForClientThreadToFinish(HANDLE thread);
static int CloseSocket(SOCKET sockList[], int numSockets);
 
/* We use a global variable to keep track of the 
   client thread return value because GetExitCodeThread
   is not supported on PAL
*/
int threadExitCode;

/**
 * main
 * 
 * executable entry point
 */
INT __cdecl main(INT argc, CHAR **argv)
{
    int     i;
    int     err;    
    struct  sockaddr_in mySockaddr;
    WSADATA wsaData;
    HANDLE  hReadEvent;
    DWORD   waitResult;

    /* Thread variable */
    HANDLE hThreadClient;
    DWORD dwThreadClient;     
    DWORD dwClientParam[2]; 

    HANDLE hThreadEvent; 

    /* Sockets descriptor */
    const int numSockets = 2;    /* number of sockets used in this test */

    SOCKET testSockets[2];

    /* variable for iocltsocket */
    u_long argp;

     /* Variables needed for setsockopt */
    BOOL bReuseAddr = TRUE;    

    /* Variables needed for WSARecv */
    WSABUF        wsaBuf;
    DWORD         dwNbrOfBuf  = 1;
    DWORD         dwNbrOfByteSent;
    DWORD         dwRecvFlags = 0;
    WSAOVERLAPPED wsaRecvOverlapped;
    
    /* Variable used to store transmitted data */
    unsigned char myBuffer[255];
    
    /* Socket DLL version */
    const WORD wVersionRequested = MAKEWORD(2,2);

    /* Sockets initialization to INVALID_SOCKET */
    for( i = 0; i < numSockets; i++ )
    {
        testSockets[i] = INVALID_SOCKET;
    }

    /* PAL initialization */
    if( PAL_Initialize(argc, argv) != 0 )
    {
        return FAIL;
    }

    /* Initialize to use winsock2.dll */
    err = WSAStartup( wVersionRequested,
                      &wsaData);

    if(err != 0)
    {
        Fail( "Server error: Unexpected failure: "
              "WSAStartup(%i) "
              "returned %d\n",
              wVersionRequested, 
              GetLastError() );
    }

    /* Confirm that the WinSock DLL supports 2.2.
       Note that if the DLL supports versions greater    
       than 2.2 in addition to 2.2, it will still return
       2.2 in wVersion since that is the version we      
       requested.                                        
    */
    if ( wsaData.wVersion != wVersionRequested ) 
    {  
        Trace("Server error: Unexpected failure "
              "to find a usable version of WinSock DLL\n");

        /* Do some cleanup */
        DoWSATestCleanup( 0, 0);

        Fail("");
    }

    /* create an overlapped stream socket in AF_INET domain */

    testSockets[0] = WSASocketA( AF_INET, 
                           SOCK_DGRAM, 
                           IPPROTO_UDP,
                           NULL, 
                           0, 
                           WSA_FLAG_OVERLAPPED );


    if( testSockets[0] == INVALID_SOCKET )
    {   
        Trace("Server error: Unexpected failure: "
              "WSASocketA"
              "(AF_INET,SOCK_DGRAM,IPPROTO_UDP,NULL,0,WSA_FLAG_OVERLAPPED)) "
              " returned %d\n",
              GetLastError());

        /* Do some cleanup */
        DoWSATestCleanup( 0, 0);

        Fail("");
    }

    /* Allows the socket to be bound to an address that is already in use. */
    err = setsockopt( testSockets[0],
                      SOL_SOCKET,
                      SO_REUSEADDR,
                      (const char *)&bReuseAddr,
                      sizeof( BOOL ) );

    if( err == SOCKET_ERROR )
    {
        Trace("Server error: Unexpected failure: "
              "setsockopt(.., SOL_SOCKET,SO_REUSEADDR, ..) "
              "returned %d\n",
              GetLastError() );

        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                          numSockets );

        Fail("");
    }

    /* enable non blocking socket */
    argp=1;
    err = ioctlsocket(testSockets[0], FIONBIO, (u_long FAR *)&argp);

    if (err==SOCKET_ERROR )
    {
        Trace("ERROR: Unexpected failure: "
              "ioctlsocket(.., FIONBIO, ..) "
              "returned %d\n",
              GetLastError() );

        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                          numSockets );
        
        Fail("");
    }


    /* prepare the sockaddr structure */
    mySockaddr.sin_family           = AF_INET;
    mySockaddr.sin_port             = getRotorTestPort();
    mySockaddr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");

    memset( &(mySockaddr.sin_zero), 0, 8);

    /* bind local address to a socket */
    err = bind( testSockets[0],
                (struct sockaddr *)&mySockaddr,
                sizeof(struct sockaddr) );


    if( err == SOCKET_ERROR )
    {
        Trace("ERROR: Unexpected failure: "
              "bind() socket with local address "
              "returned %d\n",
              GetLastError() );

        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                          numSockets );

        Fail("");
    }

    /* Create a Event with initial owner. */
    hThreadEvent = CreateEvent( NULL, /* no security   */
                             FALSE,   /* reset type    */
                             FALSE,   /* initial state */
                             "EventClientServer" );  /* object name   */

    if (hThreadEvent == NULL) 
    {        
        /* Check for error. */
        Trace( "Server Error: Unexpected failure: "
              "CreateEvent() "
              "returned NULL\n");

          /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                          numSockets );

        Fail("");
    }    
    
    /* create a client thread */

    hThreadClient = 
        CreateThread( 
                NULL,                        /* no security attributes */
                0,                           /* use default stack size */
                (LPTHREAD_START_ROUTINE)Thread_Client,/* thread function    */
                (LPVOID)&dwClientParam,      /* argument to thread function */
                0,                           /* use default creation flags  */
                &dwThreadClient);            /* returns the thread identifier*/

    if(hThreadClient==NULL)
    {        
        Trace( "Server Error: Unexpected failure: "
              "CreateThread() "
              "returned NULL\n");

        CloseEventHandle(hThreadEvent);        

          /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                          numSockets );

        Fail("");
    }
    
    if(SetEvent(hThreadEvent)==0)
    {
        Trace("Server error: Unexpected failure: "
            "SetEvent has not set hThreadEvent as expected"
            "GetLastError returned = %d.\n",GetLastError());

        WaitForClientThreadToFinish(hThreadClient);

        CloseThreadHandle(hThreadClient);

        CloseEventHandle(hThreadEvent);        

        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                        numSockets );

        Fail("");
    } 

    /* create an event */
    hReadEvent = CreateEvent( NULL, /* no security   */
                             FALSE,   /* reset type    */
                             FALSE,   /* initial state */
                             NULL );  /* object name   */
            
    if( hReadEvent == NULL )
    {            
        Trace("Server error: Unexpected failure: "
              "CreateEvent() "
              "returned %d\n",
              GetLastError());

        WaitForClientThreadToFinish(hThreadClient);        

        CloseThreadHandle(hThreadClient);

        CloseEventHandle(hThreadEvent);

        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                          numSockets );

        Fail("");
        
    }

   /* Initialize the WSABUF structure */
    memset(myBuffer, 0, 255);

    wsaBuf.buf = myBuffer;
    wsaBuf.len = 255;    
    
    /* Initialize the WSAOVERLAPPED to 0 */
    memset(&wsaRecvOverlapped, 0, sizeof(WSAOVERLAPPED));

    /* Specify which event to signal when data is arrived*/
    wsaRecvOverlapped.hEvent = hReadEvent;

        /* reset the buffer used by WSARecv */
    memset(myBuffer, 0, 255);
    
        /* Prepare to receive data */
    err = WSARecvFrom( testSockets[0],
                &wsaBuf,
                dwNbrOfBuf,
                &dwNbrOfByteSent,
                &dwRecvFlags,
                (struct sockaddr*)NULL,
                (int) NULL,
                &wsaRecvOverlapped,
                0 );   

    if( err != SOCKET_ERROR )
    {
        /* If WSARecvFrom returned no error, number of byte 
           received should be 255
        */
        if(dwNbrOfByteSent!=255)
        {
            Trace("Server error: WSARecv() "
                        "returned  %d, SOCKET_ERROR\n",
                        err );
                
            WaitForClientThreadToFinish(hThreadClient);            
            
            CloseThreadHandle(hThreadClient);

            CloseEventHandle(hReadEvent);

            CloseEventHandle(hThreadEvent);
            
            /* Do some cleanup */
            DoWSATestCleanup( testSockets,
                            numSockets );

            Fail("");
        }
    }
    else
    {
        err = GetLastError();
        /* Only WSA_IO_PENDING is expected */
        if(err!=WSA_IO_PENDING)
        {
            Trace("Server error: WSARecv() "
                    "returned %d, expected WSA_IO_PENDING\n",
                    err );
                
            WaitForClientThreadToFinish(hThreadClient);            
            
            CloseThreadHandle(hThreadClient);

            CloseEventHandle(hReadEvent);

            CloseEventHandle(hThreadEvent);
            
            /* Do some cleanup */
            DoWSATestCleanup( testSockets,
                            numSockets );
    
            Fail("");
        }
        /* Wait 10 seconds for ReadEvent to be signaled 
            from the pending operation
        */
        waitResult = WaitForSingleObject( hReadEvent, 
                                            10000 );    
        
        if (waitResult!=WAIT_OBJECT_0)
        {           
            Trace("Server error: Unexpected failure: "
                "WaitForSingleObject has timed out \n");

            WaitForClientThreadToFinish(hThreadClient);                

            CloseThreadHandle(hThreadClient);

            CloseEventHandle(hReadEvent);

            CloseEventHandle(hThreadEvent);

            /* Do some cleanup */
            DoWSATestCleanup( testSockets,
                            numSockets );

            Fail("");
        }
    }    

    /* Verify that the buffer received is not bigger than the 
       the maximum specified in wsaBuf structure
    */
    if(wsaBuf.len<wsaRecvOverlapped.InternalHigh)
    {
        Trace("ERROR: "
                "WSARecv(...) "
                "returned wsaRecvOverlapped with InternalHigh of %d" 
                ", expected value equal ot lower to %d\n",
                wsaRecvOverlapped.InternalHigh, wsaBuf.len);

        WaitForClientThreadToFinish(hThreadClient);                

        CloseThreadHandle(hThreadClient);

        CloseEventHandle(hReadEvent);

        CloseEventHandle(hThreadEvent);

        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                        numSockets );

        Fail("");
    } 

    if(!WaitForClientThreadToFinish(hThreadClient))
    {
        CloseThreadHandle(hThreadClient);

        CloseEventHandle(hReadEvent);

        CloseEventHandle(hThreadEvent);

        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                          numSockets );

        Fail("");
    }

    if(!CloseEventHandle(hThreadEvent)||
        !CloseThreadHandle(hThreadClient)||
       !CloseEventHandle(hReadEvent))
    {
        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                          numSockets );
        Fail("");
    }     

    /* verify that all data in the data array are as expected */
    if(memcmp(srcString,myBuffer, strlen(srcString))!=0)
    {
        Trace("Server Error comparing received with send data");

        /* Do some cleanup */
        DoWSATestCleanup( testSockets,
                            numSockets );

        Fail("");             
    } 
    
    /* Do some cleanup */
    DoWSATestCleanup( testSockets,
                      numSockets );


    PAL_Terminate();
    return PASS;
}

/* DWORD  PALAPI Thread_Client(LPVOID lpParam)  
   This is a client thread started by the main process.
   It simulate a client connecting to a remote server.   
*/
void  PALAPI Thread_Client(LPVOID lpParam)
{     
    int     i;
    int     err;
    struct  sockaddr_in mySockaddr;
    
    /* Sockets descriptor */
    const int numSockets = 1;    /* number of sockets used in this test */

    SOCKET testSockets[1];    
    
    /* Variables for WSASend */

    WSABUF wsaSendBuf;
    DWORD  dwNbrOfByteSent;
    DWORD  dwNbrOfBuf  = 1;
    DWORD  dwSendFlags = 0;
    
    unsigned char   sendBuffer[255];    

    WSAOVERLAPPED wsaOverlapped;

    /* variable for iocltsocket */
    u_long argp;    

    HANDLE  hWriteEvent;
    DWORD   waitResult;
    
    /* Event handle */
    HANDLE hThreadEvent;

    threadExitCode=THREAD_UNDEFINED;

    /* Create a Event with no initial owner. EventClientServer is
       the Event owned by the server.
    */
    hThreadEvent = CreateEvent( NULL, /* no security   */
                             FALSE,   /* reset type    */
                             FALSE,   /* initial state */
                             "EventClientServer" );  /* object name   */

    /* Check for error. */
    if (hThreadEvent == NULL) 
    {        
        Trace( "Client Error: Unexpected failure: "
              "CreateEvent() "
              "returned NULL\n");

        threadExitCode=THREAD_FAIL;

        ExitThread(0);
    }    
    
    /* Wait 10 seconds for EventClientServer to be signaled 
       from the server. It will mean that the server is ready
       to receive data or connection.
    */
    waitResult = WaitForSingleObject( hThreadEvent,
                                      10000 );
            
    if (waitResult!=WAIT_OBJECT_0)
    {
        Trace("Client error: Unexpected failure: "
              "WaitForSingleObject has timed out while "
              "waiting for EventClientServer.\n");

        CloseEventHandle(hThreadEvent);            
        
        threadExitCode=THREAD_FAIL;

        ExitThread(0);
    }

    /* close the thread handle, don't need anymore */
    if(!CloseEventHandle(hThreadEvent))
    {
        /* Do some cleanup */
        CloseSocket( testSockets, numSockets );

        threadExitCode=THREAD_FAIL;

        ExitThread(0);
    }
    
    /* Sockets initialization to INVALID_SOCKET */
    for( i = 0; i < numSockets; i++ )
    {
        testSockets[i] = INVALID_SOCKET;
    } 

    /* create an overlapped stream socket in AF_INET domain */

    testSockets[0] = WSASocketA( AF_INET, 
                                 SOCK_DGRAM, 
                                 IPPROTO_UDP,
                                 NULL, 
                                 0, 
                                 WSA_FLAG_OVERLAPPED ); 


    if( testSockets[0] == INVALID_SOCKET )

    {
        Trace("Client error: Unexpected failure: "
              "WSASocketA"
              "(AF_INET,SOCK_DGRAM,IPPROTO_UDP,NULL,0,WSA_FLAG_OVERLAPPED) "
              " returned %d\n",
              GetLastError());
     
        threadExitCode=THREAD_FAIL;

        ExitThread(0);
    }

    /* enable non blocking socket */
    argp=1;
    err = ioctlsocket(testSockets[0], FIONBIO, (u_long FAR *)&argp);

    if (err==SOCKET_ERROR )
    {
        Trace("ERROR: Unexpected failure: "
              "ioctlsocket(.., FIONBIO, ..) "
              "returned %d\n",
              GetLastError() );

        /* Do some cleanup */
        CloseSocket( testSockets, numSockets );
       
        threadExitCode=THREAD_FAIL;

        ExitThread(0);
    }
    
    /* prepare the sockaddr_in structure */
    mySockaddr.sin_family           = AF_INET;
    mySockaddr.sin_port             = getRotorTestPort();
    mySockaddr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");

    memset( &(mySockaddr.sin_zero), 0, 8);       
   
    /* create events */
    hWriteEvent = CreateEvent( NULL, /* no security   */
                             FALSE,    /* reset type    */
                             FALSE,    /* initial state */
                             NULL );   /* object name   */
            
    if( hWriteEvent == NULL )
    {
        Trace("Client error: Unexpected failure: "
              "CreateEvent() "
              "returned %d\n",
              GetLastError());

        /* Do some cleanup */
        CloseSocket( testSockets, numSockets );

        threadExitCode=THREAD_FAIL;

        ExitThread(0);
    }   
    
    memcpy(sendBuffer, srcString, strlen(srcString));
    /* Set the WSABUF structure */
    wsaSendBuf.len = 255;        
    wsaSendBuf.buf = sendBuffer;
    
    /* Initialize the WSAOVERLAPPED to 0 */
    memset(&wsaOverlapped, 0, sizeof(WSAOVERLAPPED));  
    wsaOverlapped.hEvent = hWriteEvent;

    /* Send some data */
    err = WSASendTo( testSockets[0],
                &wsaSendBuf,
                dwNbrOfBuf,
                &dwNbrOfByteSent,
                dwSendFlags,
                (struct sockaddr FAR *)&mySockaddr,
                sizeof(mySockaddr),
                &wsaOverlapped,
                0 );


    if(err == SOCKET_ERROR )
    {   
        /* Handle the overlapped operation */
        if(GetLastError()!=WSA_IO_PENDING)
        {
            Trace("Client error: Unexpected failure: "
                "WSASend() "
                "returned %d\n",
                GetLastError());
                    
            CloseEventHandle(hWriteEvent);

            /* Do some cleanup */
            CloseSocket( testSockets, numSockets );

            threadExitCode=THREAD_FAIL;

            ExitThread(0);
        }

        /* Wait 10 seconds for hWriteEvent to be signaled 
        for pending operation
        */
        waitResult = WaitForSingleObject( hWriteEvent, 
                                            10000 );            

        if (waitResult!=WAIT_OBJECT_0)
        {  
            Trace("Client Error: Unexpected failure: "
                "WaitForSingleObject has timed out \n");

            CloseEventHandle(hWriteEvent);
    
            /* Do some cleanup */
            CloseSocket( testSockets, numSockets );

            threadExitCode=THREAD_FAIL;
            ExitThread(0);
        }        
    }
    
    /* Verify that the number of bytes sent are the number of byte
        specified in the wsaBuf structure 
    */
    if(wsaSendBuf.len!=wsaOverlapped.InternalHigh)
    {            
        Trace("Server error: Array out of bound "
            "while writing buffer received in myData.\n");

        CloseEventHandle(hWriteEvent);

        /* Do some cleanup */
        CloseSocket( testSockets, numSockets );

        threadExitCode=THREAD_FAIL;
        ExitThread(0);
    }

    /* close the handle to hWriteEvent */
    if(!CloseEventHandle(hWriteEvent))
    {
        /* Do some cleanup */
        CloseSocket( testSockets, numSockets );

        threadExitCode=THREAD_FAIL;

        ExitThread(0);
    }
    

    /* Do some cleanup */
    CloseSocket( testSockets, numSockets );

    threadExitCode=THREAD_SUCCESS;

    ExitThread(0);    
} 

/* int CloseThreadHandle(HANDLE thread)
   This function close a thread handle 
   and return an appropriate message in case of error
*/
int CloseThreadHandle(HANDLE thread)
{   
    if(thread!=NULL)
    {
        if( CloseHandle(thread) == 0 )
        {
            Trace("Server error: Unexpected failure: "
                  "CloseHandle(thread) "
                  "returned %d\n",
                GetLastError());
            return 0;
        }
    }
    return 1;
}

/* int CloseEventHandle(HANDLE Event)
   This function close an Event handle 
   and return an appropriate message in case of error
*/
static int CloseEventHandle(HANDLE Event)
{
    if( CloseHandle(Event) == 0 )
    {
        Trace("Server error: Unexpected failure: "
              "CloseHandle() "
              "returned %d\n",
            GetLastError());
        return 0;
    }    
    return 1;
}

/* int WaitForThreadToFinish(HANDLE thread)
   This function return 0 if the client thread exit code 
   is clientHasFailed and 1 other is the execution was successfull
*/
int WaitForClientThreadToFinish(HANDLE thread)
{
    DWORD   waitResult;   
    
    if(thread==NULL)
    {
        return 0;
    }

    /* Wait for the thread to finish execution */
    waitResult = WaitForSingleObject( thread, 10000 );
            
    if (waitResult!=WAIT_OBJECT_0)
    {   
        Trace("Server error: Unexpected failure: "
              "WaitForSingleObject has timed out waiting for" 
              " the client thread to finish.\n");
        return 0;
    }

    if(threadExitCode==THREAD_SUCCESS)
    {
        return 1;
    }    
    else if(threadExitCode==THREAD_FAIL)
    {
        /* return error, error msg has been handled by the client */
        return 0;
    }
    else
    {
        Trace("Client error: Unexpected failure: "
              "No known error code defined on the client thread.");
        return 0;
    }
}

/* int CloseSocket(SOCKET sockList[], int numSockets)
   This function close sockets contained in sockList parameter.

*/
static int CloseSocket(SOCKET sockList[], int numSockets)
{
    int i;
    int err;

    int bResult=1; /* failure indication */

    if( (sockList != NULL) &&
        (numSockets != 0 ) )
    {
        /* Close the open sockets */
        for( i = 0 ; i < numSockets; i++ )
        {
            if( sockList[i] != INVALID_SOCKET )
            {
                err = closesocket(sockList[i]);
                if( err == SOCKET_ERROR )
                {    
                    Trace("ERROR: Unexpected failure: "
                          "closesocket(%i) returned (%d)\n", 
                          sockList[i],
                          GetLastError());

                    bResult = 0;
                }
            }

        }
    }
    else
    {
        bResult = 0;
    }
    return bResult;
}
