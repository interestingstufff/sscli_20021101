//# ==++== 
//# 
//#   
//#    Copyright (c) 2002 Microsoft Corporation.  All rights reserved.
//#   
//#    The use and distribution terms for this software are contained in the file
//#    named license.txt, which can be found in the root of this distribution.
//#    By using this software in any fashion, you are agreeing to be bound by the
//#    terms of this license.
//#   
//#    You must not remove this notice, or any other, from this software.
//#   
//# 
//# ==--== 
//####################################################################################
@cc_on


import System;

var NULL_DISPATCH = null;
var apGlobalObj;
var apPlatform;
var lFailCount;


var iTestID = 52902;

@cc_on

function verify(sCat, vAct, ob, bugNum)
{
    if (bugNum == null) bugNum = "";

    // checks below assume log(x) is defined for x<0 !?
    // let's take care of that...
    if (ob<0) {
      if (!isNaN(vAct))
        apLogFailInfo( m_scen+(sCat.length?"--"+sCat:"")+" failed","NaN",vAct,bugNum);
      return;
    }

    vAct = Math.exp(vAct);
    var vExp = parseFloat(ob);

    var fFailed = false;
    if (isNaN(vExp))
    {
        if (!isNaN(vAct))
            fFailed = true;
    }
    else
        if ( parseFloat(ob) < 0 ? vAct != 1 :
            Math.abs((vExp-vAct)/vExp) > 6.2204460492503131e-014 )
            fFailed = true;

    if (fFailed)
        apLogFailInfo( m_scen+(sCat.length?"--"+sCat:"")+" failed",vExp,vAct,bugNum);
}

var m_scen = "";

function log001() {
 
    apInitTest("log001 ");

    //----------------------------------------------------------------------------
    apInitScenario("1. number, decimal, integer");

    m_scen = "number, decimal, integer";

    verify("pos min", Math.log(1), 1, null);
    verify("pos min < n < VT_UI1 pos max", Math.log(127), 127, null);
    verify("VT_UI1 pos max", Math.log(255), 255, null);
    verify("VT_I2 pos excl-min", Math.log(256), 256, null);
    verify("VT_I2 pos excl-min < n < VT_I2 pos max", Math.log(12869), 12869, null);
    verify("VT_I2 pos max", Math.log(32767), 32767, null);
    verify("VT_I4 pos excl-min", Math.log(32768), 32768, null);
    verify("VT_I4 pos excl-min < n < pos max", Math.log(1143483646), 1143483646, null);
    verify("pos max", Math.log(2147483647), 2147483647, null);

    verify("neg max", Math.log(-1), -1, null);
    verify("neg max > n > VT_UI1 neg min", Math.log(-201), -201, null);
    verify("VT_UI1 neg min", Math.log(-256), -256, null);
    verify("VT_I2 neg excl-max", Math.log(-257), -257, null);
    verify("VT_I2 neg excl-max > n > VT_I2 neg min", Math.log(-12869), -12869, null);
    verify("VT_I2 neg min", Math.log(-32768), -32768, null);
    verify("VT_I4 neg excl-max", Math.log(-32769), -32769, null);
    verify("VT_I4 neg excl-max > n > neg min", Math.log(-1143483646), -1143483646, null);
    verify("neg min", Math.log(-2147483648), -2147483648, null);

    verify("zero", Math.log(0), 0, null);


    //----------------------------------------------------------------------------
    apInitScenario("2. number, hexidecimal");

    m_scen = "number, hexidecimal";

    verify("pos min < n < pos hex excl-min", Math.log(0xabcdef), 0xabcdef, null);
    verify("pos hex excl-min: 0x80000000", Math.log(0x80000000), 0x80000000, null);
    verify("max pos: 0xffffffff", Math.log(0xffffffff), 0xffffffff, null);

    verify("neg max > n > neg hex excl-max", Math.log(-0xabcdef), -0xabcdef, null);
    verify("pos hex excl-min: -0x80000001", Math.log(-0x80000001), -0x80000001, null);
    verify("min neg: -0xffffffff", Math.log(-0xffffffff), -0xffffffff, null);

    verify("zero", Math.log(0x0), 0x0, null);


    //----------------------------------------------------------------------------
    apInitScenario("3. number, octal");

    m_scen = "number, octal";

    verify("pos min < n < pos hex excl-min", Math.log(01234567), 01234567, null);
    verify("pos hex excl-min: 020000000000", Math.log(020000000000), 020000000000, null);
    verify("max pos: 037777777777", Math.log(037777777777), 037777777777, null);

    verify("neg max > n > neg hex excl-max", Math.log(-076543210), -076543210, null);
    verify("pos hex excl-min: -020000000001", Math.log(-020000000001), -020000000001, null);
    verify("min neg: -037777777777", Math.log(-037777777777), -037777777777, null);

    verify("pos zero", Math.log(00), 00, null);

    
    //----------------------------------------------------------------------------
    apInitScenario("4. number, float");

    m_scen = "number, float";

    verify("pos min",Math.log(2.2250738585072014e-308), 2.2250738585072014e-308, null);
    verify("pos min < n < VT_R4 pos max", Math.log(9.87654321e12), 9.87654321e12, null);
    verify("VT_R4 pos max", Math.log(3.402823466e+38), 3.402823466e+38, null);
    verify("VT_R8 pos excl-min", Math.log(3.402823467e+38), 3.402823467e+38, null);
    verify("VT_R8 pos excl-min < n < pos max", Math.log(4.43269743388067e107), 4.43269743388067e107, null);
@if(@_jscript_version >=7)
    verify("pos max", Math.log(1.7976931348000000e308), 1.7976931348000000e308, null);
@else
    verify("pos max", Math.log(1.7976931348623158e308), 1.7976931348623158e308, null);
@end

    verify("neg max", Math.log(-2.2250738585072012595e-308), -2.2250738585072012595e-308, null);
    verify("neg max > n > VT_R4 neg min", Math.log(-6.61005335930233e19), -6.61005335930233e19, null);
    verify("VT_R4 neg min", Math.log(-3.402823466e+38), -3.402823466e+38, null);
    verify("VT_R8 neg excl-max", Math.log(-3.402823467e+38), -3.402823467e+38, null);
    verify("VT_R8 neg excl-max > n > neg min", Math.log(-7.17170763763262e243), -7.17170763763262e243, null);
    verify("neg min", Math.log(-1.797693134862315807e308), -1.797693134862315807e308, null);

    verify("zero", Math.log(0.0), 0.0, null);

    
    //----------------------------------------------------------------------------
    apInitScenario("5. num string, decimal, integer");

    m_scen = "number, decimal, integer";

    verify("pos min",Math.log("1"), "1", null);
    verify("pos min < n < VT_UI1 pos max", Math.log("127"), "127", null);
    verify("VT_UI1 pos max", Math.log("255"), "255", null);
    verify("VT_I2 pos excl-min", Math.log("256"), "256", null);
    verify("VT_I2 pos excl-min < n < VT_I2 pos max", Math.log("12869"), "12869", null);
    verify("VT_I2 pos max", Math.log("32767"), "32767", null);
    verify("VT_I4 pos excl-min", Math.log("32768"), "32768", null);
    verify("VT_I4 pos excl-min < n < pos max", Math.log("1143483646"), "1143483646", null);
    verify("pos max", Math.log("2147483647"), "2147483647", null);

    verify("neg max", Math.log("-1"), "-1", null);
    verify("neg max > n > VT_UI1 neg min", Math.log("-201"), "-201", null);
    verify("VT_UI1 neg min", Math.log("-256"), "-256", null);
    verify("VT_I2 neg excl-max", Math.log("-257"), "-257", null);
    verify("VT_I2 neg excl-max > n > VT_I2 neg min", Math.log("-12869"), "-12869", null);
    verify("VT_I2 neg min", Math.log("-32768"), "-32768", null);
    verify("VT_I4 neg excl-max", Math.log("-32769"), "-32769", null);
    verify("VT_I4 neg excl-max > n > neg min", Math.log("-1143483646"), "-1143483646", null);
    verify("neg min", Math.log("-2147483648"), "-2147483648", null);

    verify("zero", Math.log("0"), "0", null);


    //----------------------------------------------------------------------------
    apInitScenario("7. num string, octal");

    m_scen = "num string, octal";

    verify("pos min < n < pos hex excl-min", Math.log("01234567"), "01234567", null);
    verify("pos hex excl-min: 020000000000", Math.log("020000000000"), "020000000000", null);
    verify("max pos: 037777777777", Math.log("037777777777"), "037777777777", null);

    verify("neg max > n > neg hex excl-max", Math.log("-076543210"), "-076543210", null);
    verify("pos hex excl-min: -020000000001", Math.log("-020000000001"), "-020000000001", null);
    verify("min neg: -037777777777", Math.log("-037777777777"), "-037777777777", null);

    verify("pos zero", Math.log("00"), "00", null);


    //----------------------------------------------------------------------------
    apInitScenario("8. number, float");

    m_scen = "number, float";

    verify("pos min",Math.log("2.2250738585072014e-308"), "2.2250738585072014e-308", null);
    verify("pos min < n < VT_R4 pos max", Math.log("9.87654321e12"), "9.87654321e12", null);
    verify("VT_R4 pos max", Math.log("3.402823466e+38"), "3.402823466e+38", null);
    verify("VT_R8 pos excl-min", Math.log("3.402823467e+38"), "3.402823467e+38", null);
    verify("VT_R8 pos excl-min < n < pos max", Math.log("4.43269743388067e107"), "4.43269743388067e107", null);
@if(@_jscript_version >=7)
    verify("pos max", Math.log(1.7976931348000000e308), 1.7976931348000000e308, null);
@else
    verify("pos max", Math.log("1.7976931348623158e308"), "1.7976931348623158e308", null);
@end

    verify("neg max", Math.log("-2.2250738585072012595e-308"), "-2.2250738585072012595e-308", null);
    verify("neg max > n > VT_R4 neg min", Math.log("-6.61005335930233e19"), "-6.61005335930233e19", null);
    verify("VT_R4 neg min", Math.log("-3.402823466e+38"), "-3.402823466e+38", null);
    verify("VT_R8 neg excl-max", Math.log("-3.402823467e+38"), "-3.402823467e+38", null);
    verify("VT_R8 neg excl-max > n > neg min", Math.log("-7.17170763763262e243"), "-7.17170763763262e243", null);
    verify("neg min", Math.log("-1.797693134862315807e308"), "-1.797693134862315807e308", null);

    verify("zero", Math.log("0.0"), "0.0", null);

    
    //----------------------------------------------------------------------------
    apInitScenario("13. constants");

    m_scen = "constants";

    verify("true",Math.log(true), 1, null);
    verify("false",Math.log(false), 0, null);


    //----------------------------------------------------------------------------
    apInitScenario("14. null");

    m_scen = "null";

    verify("",Math.log(null), 0, null);


    /*****************************************************************************
    // All of the rest cause a runtime error (spec) of 'not a number'

    //----------------------------------------------------------------------------
    // apInitScenario("n. Alpha string");
    

    //----------------------------------------------------------------------------
    // apInitScenario("n. objects, built-in, non-exec");


    //----------------------------------------------------------------------------
    // apInitScenario("n. objects, built-in, exec, not inst");


    //----------------------------------------------------------------------------
    // apInitScenario("n. objects, built-in, exec, inst");


    //----------------------------------------------------------------------------
    // apInitScenario("n. objects, user-def, not inst");


    //----------------------------------------------------------------------------
    // apInitScenario("n. objects, user-def, inst");


    //----------------------------------------------------------------------------
    // apInitScenario("n. undefined");
    *****************************************************************************/    

    apEndTest();

}




log001();


if(lFailCount >= 0) System.Environment.ExitCode = lFailCount;
else System.Environment.ExitCode = 1;

function apInitTest(stTestName) {
    lFailCount = 0;

    apGlobalObj = new Object();
    apGlobalObj.apGetPlatform = function Funca() { return "Rotor" }
    apGlobalObj.LangHost = function Funcb() { return 1033;}
    apGlobalObj.apGetLangExt = function Funcc(num) { return "EN"; }

    apPlatform = apGlobalObj.apGetPlatform();
    var sVer = "1.0";  //navigator.appVersion.toUpperCase().charAt(navigator.appVersion.toUpperCase().indexOf("MSIE")+5);
    apGlobalObj.apGetHost = function Funcp() { return "Rotor " + sVer; }
    print ("apInitTest: " + stTestName);
}

function apInitScenario(stScenarioName) {print( "\tapInitScenario: " + stScenarioName);}

function apLogFailInfo(stMessage, stExpected, stActual, stBugNum) {
    lFailCount = lFailCount + 1;
    print ("***** FAILED:");
    print ("\t\t" + stMessage);
    print ("\t\tExpected: " + stExpected);
    print ("\t\tActual: " + stActual);
}

function apGetLocale(){ return 1033; }
function apWriteDebug(s) { print("dbg ---> " + s) }
function apEndTest() {}
