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
.class public stind_i {
.field public static int32 FOO
.field public static int32 FOO2
.field public static int32 FOO3
.field public static int32 FOO4
.method public static	int32 main(class [mscorlib]System.String[]) {
.entrypoint
.maxstack		20
	ldsflda		int32 stind_i::FOO
	ldc.i4		0x01234567
	stind.i4
	ldsflda		int32 stind_i::FOO
	ldc.i4		0x4
	add
	ldsflda		int32 stind_i::FOO
	ldc.i4		0x8
	add
	stind.i
	ldsflda		int32 stind_i::FOO
	ldc.i4		0x8
	add
	ldc.i4		0x89ABCDEF
	stind.i4
	ldsflda		int32 stind_i::FOO
	ldc.i4		0xC
	add
	ldsflda		int32 stind_i::FOO
	stind.i
	ldc.i4		0x89ABCDEF
	ldsflda		int32 stind_i::FOO
	ldc.i4		0x4
	add
	ldind.i
	ldind.i4
	ceq
	brfalse		FAIL
	ldc.i4		0x01234567
	ldsflda		int32 stind_i::FOO
	ldc.i4		0xC
	add
	ldind.i
	ldind.i4
	ceq
	brfalse		FAIL
PASS:
	ldc.i4	0x0000
	ret
FAIL:
	ldc.i4	0x0001
	ret
}
}
.assembly stind_i.exe{}
