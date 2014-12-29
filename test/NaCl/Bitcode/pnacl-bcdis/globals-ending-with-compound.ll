; Test that we properly handle the globals block correctly, when it ends with
; a compound initializer.

; RUN: llvm-as < %s | pnacl-freeze | pnacl-bcdis | FileCheck %s

@bytes = internal global [7 x i8] c"abcdefg"
@compound = internal global <{ [3 x i8], i32 }> <{ [3 x i8] c"foo", i32 ptrtoint (void ()* @func to i32) }>
declare void @func();

; CHECK:            0:0|<65532, 80, 69, 88, 69, 1, 0,|Magic Number: 'PEXE' (80, 69, 88, 69)
; CHECK-NEXT:          | 8, 0, 17, 0, 4, 0, 2, 0, 0, |PNaCl Version: 2
; CHECK-NEXT:          | 0>                          |
; CHECK-NEXT:      16:0|1: <65535, 8, 2>             |module {  // BlockID = 8
; CHECK-NEXT:      24:0|  3: <1, 1>                  |  version 1;
; CHECK-NEXT:      26:4|  1: <65535, 0, 2>           |  abbreviations {  // BlockID = 0
; CHECK-NEXT:      36:0|    1: <1, 14>               |    valuesymtab:
; CHECK-NEXT:      38:4|    2: <65533, 4, 0, 1, 3, 0,|      @a0 = abbrev <fixed(3), vbr(8), 
; CHECK-NEXT:          |        2, 8, 0, 3, 0, 1, 8> |                   array(fixed(8))>;
; CHECK-NEXT:      43:2|    2: <65533, 4, 1, 1, 0, 2,|      @a1 = abbrev <1, vbr(8), 
; CHECK-NEXT:          |        8, 0, 3, 0, 1, 7>    |                   array(fixed(7))>;
; CHECK-NEXT:      48:0|    2: <65533, 4, 1, 1, 0, 2,|      @a2 = abbrev <1, vbr(8), 
; CHECK-NEXT:          |        8, 0, 3, 0, 4>       |                   array(char6)>;
; CHECK-NEXT:      52:1|    2: <65533, 4, 1, 2, 0, 2,|      @a3 = abbrev <2, vbr(8), 
; CHECK-NEXT:          |        8, 0, 3, 0, 4>       |                   array(char6)>;
; CHECK-NEXT:      56:2|    1: <1, 11>               |    constants:
; CHECK-NEXT:      58:6|    2: <65533, 2, 1, 1, 0, 1,|      @a0 = abbrev <1, fixed(2)>;
; CHECK-NEXT:          |        2>                   |
; CHECK-NEXT:      61:7|    2: <65533, 2, 1, 4, 0, 2,|      @a1 = abbrev <4, vbr(8)>;
; CHECK-NEXT:          |        8>                   |
; CHECK-NEXT:      65:0|    2: <65533, 2, 1, 4, 1, 0>|      @a2 = abbrev <4, 0>;
; CHECK-NEXT:      68:1|    2: <65533, 2, 1, 6, 0, 2,|      @a3 = abbrev <6, vbr(8)>;
; CHECK-NEXT:          |        8>                   |
; CHECK-NEXT:      71:2|    1: <1, 12>               |    function:
; CHECK-NEXT:      73:6|    2: <65533, 4, 1, 20, 0,  |      @a0 = abbrev <20, vbr(6), vbr(4),
; CHECK-NEXT:          |        2, 6, 0, 2, 4, 0, 2, |                   vbr(4)>;
; CHECK-NEXT:          |        4>                   |
; CHECK-NEXT:      79:1|    2: <65533, 4, 1, 2, 0, 2,|      @a1 = abbrev <2, vbr(6), vbr(6), 
; CHECK-NEXT:          |        6, 0, 2, 6, 0, 1, 4> |                   fixed(4)>;
; CHECK-NEXT:      84:4|    2: <65533, 4, 1, 3, 0, 2,|      @a2 = abbrev <3, vbr(6), 
; CHECK-NEXT:          |        6, 0, 1, 2, 0, 1, 4> |                   fixed(2), fixed(4)>;
; CHECK-NEXT:      89:7|    2: <65533, 1, 1, 10>     |      @a3 = abbrev <10>;
; CHECK-NEXT:      91:7|    2: <65533, 2, 1, 10, 0,  |      @a4 = abbrev <10, vbr(6)>;
; CHECK-NEXT:          |        2, 6>                |
; CHECK-NEXT:      95:0|    2: <65533, 1, 1, 15>     |      @a5 = abbrev <15>;
; CHECK-NEXT:      97:0|    2: <65533, 3, 1, 43, 0,  |      @a6 = abbrev <43, vbr(6), 
; CHECK-NEXT:          |        2, 6, 0, 1, 2>       |                   fixed(2)>;
; CHECK-NEXT:     101:2|    2: <65533, 4, 1, 24, 0,  |      @a7 = abbrev <24, vbr(6), vbr(6),
; CHECK-NEXT:          |        2, 6, 0, 2, 6, 0, 2, |                   vbr(4)>;
; CHECK-NEXT:          |        4>                   |
; CHECK-NEXT:     106:5|    1: <1, 19>               |    globals:
; CHECK-NEXT:     109:1|    2: <65533, 3, 1, 0, 0, 2,|      @a0 = abbrev <0, vbr(6), 
; CHECK-NEXT:          |        6, 0, 1, 1>          |                   fixed(1)>;
; CHECK-NEXT:     113:3|    2: <65533, 2, 1, 1, 0, 2,|      @a1 = abbrev <1, vbr(8)>;
; CHECK-NEXT:          |        8>                   |
; CHECK-NEXT:     116:4|    2: <65533, 2, 1, 2, 0, 2,|      @a2 = abbrev <2, vbr(8)>;
; CHECK-NEXT:          |        8>                   |
; CHECK-NEXT:     119:5|    2: <65533, 3, 1, 3, 0, 3,|      @a3 = abbrev <3, array(fixed(8))>
; CHECK-NEXT:          |        0, 1, 8>             |          ;
; CHECK-NEXT:     123:2|    2: <65533, 2, 1, 4, 0, 2,|      @a4 = abbrev <4, vbr(6)>;
; CHECK-NEXT:          |        6>                   |
; CHECK-NEXT:     126:3|    2: <65533, 3, 1, 4, 0, 2,|      @a5 = abbrev <4, vbr(6), vbr(6)>;
; CHECK-NEXT:          |        6, 0, 2, 6>          |
; CHECK-NEXT:     130:5|  0: <65534>                 |  }
; CHECK-NEXT:     132:0|  1: <65535, 17, 3>          |  types {  // BlockID = 17
; CHECK-NEXT:     140:0|    2: <65533, 4, 1, 21, 0,  |    %a0 = abbrev <21, fixed(1), 
; CHECK-NEXT:          |        1, 1, 0, 3, 0, 1, 2> |                  array(fixed(2))>;
; CHECK-NEXT:     144:7|    3: <1, 2>                |    count 2;
; CHECK-NEXT:     147:4|    3: <2>                   |    @t0 = void;
; CHECK-NEXT:     149:3|    4: <21, 0, 0>            |    @t1 = void (); <%a0>
; CHECK-NEXT:     150:7|  0: <65534>                 |  }
; CHECK-NEXT:     152:0|  3: <8, 1, 0, 1, 0>         |  declare external void @f0();
; CHECK-NEXT:     156:6|  1: <65535, 19, 4>          |  globals {  // BlockID = 19
; CHECK-NEXT:     164:0|    3: <5, 2>                |    count 2;
; CHECK-NEXT:     166:6|    4: <0, 0, 0>             |    var @g0, align 0, <@a0>
; CHECK-NEXT:     168:1|    7: <3, 97, 98, 99, 100,  |      { 97,  98,  99, 100, 101, 102, 
; CHECK-NEXT:          |        101, 102, 103>       |       103} <@a3>
; CHECK-NEXT:     176:3|    4: <0, 0, 0>             |    var @g1, align 0, <@a0>
; CHECK-NEXT:     177:6|    5: <1, 2>                |      initializers 2 { <@a1>
; CHECK-NEXT:     179:2|    7: <3, 102, 111, 111>    |        {102, 111, 111} <@a3>
; CHECK-NEXT:     183:4|    8: <4, 0>                |        reloc @f0; <@a4>
; CHECK-NEXT:          |                             |      }
; CHECK-NEXT:     184:6|  0: <65534>                 |  }
; CHECK-NEXT:     188:0|  1: <65535, 14, 3>          |  valuesymtab {  // BlockID = 14
; CHECK-NEXT:     196:0|    6: <1, 2, 99, 111, 109,  |    @g1 : "compound"; <@a2>
; CHECK-NEXT:          |        112, 111, 117, 110,  |
; CHECK-NEXT:          |        100>                 |
; CHECK-NEXT:     204:1|    6: <1, 1, 98, 121, 116,  |    @g0 : "bytes"; <@a2>
; CHECK-NEXT:          |        101, 115>            |
; CHECK-NEXT:     210:0|    6: <1, 0, 102, 117, 110, |    @f0 : "func"; <@a2>
; CHECK-NEXT:          |        99>                  |
; CHECK-NEXT:     215:1|  0: <65534>                 |  }
; CHECK-NEXT:     216:0|0: <65534>                   |}
