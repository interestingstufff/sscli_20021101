// ==++==
//
//   
//    Copyright (c) 2002 Microsoft Corporation.  All rights reserved.
//   
//    The use and distribution terms for this software are contained in the file
//    named license.txt, which can be found in the root of this distribution.
//    By using this software in any fashion, you are agreeing to be bound by the
//    terms of this license.
//   
//    You must not remove this notice, or any other, from this software.
//   
//
// ==--==
.class public Shr_U4 {
.method public static	int32 _shr(int32,int32,int32) {
.maxstack		20
	ldarg	0
	ldarg	1
	shr.un
	ldarg	2
	ceq
	ret
}
.method public static	int32 main(class [mscorlib]System.String[]) {
.entrypoint
.maxstack		20
	ldc.i4		0x00000000
	ldc.i4		0x00000000
	ldc.i4		0x00000000
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
	ldc.i4		0x00000000
	ldc.i4		0x00000001
	ldc.i4		0x00000000
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
	ldc.i4		0x00000000
	ldc.i4		0x0000001F
	ldc.i4		0x00000000
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
	ldc.i4		0xFFFFFFFF
	ldc.i4		0x00000000
	ldc.i4		0xFFFFFFFF
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
	ldc.i4		0xFFFFFFFF
	ldc.i4		0x00000001
	ldc.i4		0x7FFFFFFF
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
	ldc.i4		0xFFFFFFFF
	ldc.i4		0x0000001F
	ldc.i4		0x00000001
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
	ldc.i4		0x6789ABCD
	ldc.i4		0x00000000
	ldc.i4		0x6789ABCD
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
	ldc.i4		0x6789ABCD
	ldc.i4		0x00000001
	ldc.i4		0x33C4D5E6
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
	ldc.i4		0x6789ABCD
	ldc.i4		0x0000001F
	ldc.i4		0x00000000
	call	int32 Shr_U4::_shr(int32,int32,int32)
	brfalse		FAIL
TRY_START:
	ldc.i4		0x00000000
	ldc.i4		0x00000020
	ldc.i4		0x00000000
	call	int32 Shr_U4::_shr(int32,int32,int32)
	pop
	ldc.i4		0x00000000
	ldc.i4		0x0000003F
	ldc.i4		0x00000000
	call	int32 Shr_U4::_shr(int32,int32,int32)
	pop
	ldc.i4		0xFFFFFFFF
	ldc.i4		0x00000020
	ldc.i4		0xFFFFFFFF
	call	int32 Shr_U4::_shr(int32,int32,int32)
	pop
	ldc.i4		0xFFFFFFFF
	ldc.i4		0x0000003F
	ldc.i4		0x00000001
	call		int32 Shr_U4::_shr(int32,int32,int32)
	pop
	ldc.i4		0x6789ABCD
	ldc.i4		0x00000020
	ldc.i4		0x6789ABCD
	call		int32 Shr_U4::_shr(int32,int32,int32)
	pop
	ldc.i4		0x6789ABCD
	ldc.i4		0x0000003F
	ldc.i4		0x00000000
	call		int32 Shr_U4::_shr(int32,int32,int32)
	pop
	ldc.i4		0x6789ABCD
	ldc.i4		0xFFFFFFFF
	ldc.i4		0x00000000
	call		int32 Shr_U4::_shr(int32,int32,int32)
	pop
	leave.s	TRY_END
TRY_END:
	br		PASS
HANDLER:
	pop		
	leave		END_HANDLER
END_HANDLER:
	br		PASS
PASS:
	ldc.i4	0x0000
	ret
FAIL:
	ldc.i4	0x0001
	ret
.try TRY_START to TRY_END catch [mscorlib]System.Exception handler HANDLER to END_HANDLER
}
}
.assembly shr_u4.exe{}
