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
.class public _add {
.method public static	int32 _add(float64,float64,float64) {
.maxstack		20
	ldarg	0
	ldarg	1
	add
	dup
	call	int32 _add::checkfinite(float64)
	ldc.i4		0x0
	ceq
	brtrue		COMPARE
	call	int32 _add::checkfinite(float64)
	ldarg	2
	call	int32 _add::checkfinite(float64)
	ceq
	br			FINISH
COMPARE:
	ldarg	2
	ceq
FINISH:
	ret
}
.method public static	int32 checkfinite(float64) {
.maxstack		3
.locals		(class [mscorlib]System.ArithmeticException)
try_start:
	ldarg	0
	ckfinite
	pop
	leave.s	try_end
try_end:
	ldc.i4		0x0
	br			FINISH
ae:
	isinst		[mscorlib]System.ArithmeticException
	stloc			0x0
	leave			aeEnd
aeEnd:
	ldloc			0x0
	brfalse		FAIL
	ldarg	0
	ldc.r8		float64(0xFF800000)
	ceq
	brtrue		NINF
	ldarg	0
	ldc.r8		float64(0x7F800000)
	ceq
	brtrue		PINF
	br			NaN
NINF:
	ldc.i4		0x00000002
	br			FINISH
PINF:
	ldc.i4		0x00000003
	br			FINISH
NaN:
	ldc.i4		0x00000001
	br			FINISH
FAIL:
	ldc.i4		0xFF
	br			FINISH
FINISH:
	ret
.try try_start to try_end catch [mscorlib]System.ArithmeticException handler ae to aeEnd
}
.method public static	int32 main(class [mscorlib]System.String[]) {
.entrypoint
.maxstack		20
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x0000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0xC000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x0000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x8000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x0000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x8000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x0000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x0000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x4000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x0000000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0xFFF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0xFFEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0xBFF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x8000000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x0000000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x3FF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FEFFFFFFFFFFFFF)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF0000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	ldc.r8	float64(0x7FF8000000000000)
	call	int32 _add::_add(float64,float64,float64)
	brfalse	FAIL
PASS:
	ldc.i4	0x0000
	ret
FAIL:
	ldc.i4	0x0001
	ret
}
}
.assembly add_r8.exe{}
