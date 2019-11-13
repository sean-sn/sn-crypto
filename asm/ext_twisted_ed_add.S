/*******************************************************************************
  Copyright 2019 Supranational LLC

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*******************************************************************************/

/*
void ext_twisted_ed_add_4w(unsigned long long int* a,
                           unsigned long long int* b) 
                           unsigned long long int* res)

void ext_twisted_ed_precomp_4w(unsigned long long int* a,
                               unsigned long long int* res)
*/

.macro mul_256 a  b
   xor    %rax,       %rax
   mov    0x00\a,     %rdx
   mulx   0x00\b,     %r8,   %r9
   mulx   0x08\b,     %rbx,  %r10
   adcx   %rbx,       %r9
   mulx   0x10\b,     %rbx,  %r11
   adcx   %rbx,       %r10
   mulx   0x18\b,     %rbx,  %r12
   adcx   %rbx,       %r11
   adcx   %rax,       %r12
   xor    %rax,       %rax
   mov    0x08\a,     %rdx
   mulx   0x00\b,     %rbp,  %rbx
   adcx   %rbp,       %r9
   adox   %rbx,       %r10
   mulx   0x08\b,     %rbp,  %rbx
   adcx   %rbp,       %r10
   adox   %rbx,       %r11
   mulx   0x10\b,     %rbp,  %rbx
   adcx   %rbp,       %r11
   adox   %rbx,       %r12
   mulx   0x18\b,     %rbp,  %r13
   adcx   %rbp,       %r12
   adox   %rax,       %r13
   adcx   %rax,       %r13
   xor    %rax,       %rax
   mov    0x10\a,     %rdx
   mulx   0x00\b,     %rbp,  %rbx
   adcx   %rbp,       %r10
   adox   %rbx,       %r11
   mulx   0x08\b,     %rbp,  %rbx
   adcx   %rbp,       %r11
   adox   %rbx,       %r12
   mulx   0x10\b,     %rbp,  %rbx
   adcx   %rbp,       %r12
   adox   %rbx,       %r13
   mulx   0x18\b,     %rbp,  %r14
   adcx   %rbp,       %r13
   adox   %rax,       %r14
   adcx   %rax,       %r14
   xor    %rax,       %rax
   mov    0x18\a,     %rdx
   mulx   0x00\b,     %rbp,  %rbx
   adcx   %rbp,       %r11
   adox   %rbx,       %r12
   mulx   0x08\b,     %rbp,  %rbx
   adcx   %rbp,       %r12
   adox   %rbx,       %r13
   mulx   0x10\b,     %rbp,  %rbx
   adcx   %rbp,       %r13
   adox   %rbx,       %r14
   mulx   0x18\b,     %rbp,  %r15
   adcx   %rbp,       %r14
   adox   %rax,       %r15
   adcx   %rax,       %r15
.endm

.macro red_256_5w res
   mov    %rsi,        0x200(%rsp)
   lea    .LM(%rip),   %rsi
   mov    %r13,        0x1e8(%rsp)
   mov    %r14,        0x1f0(%rsp)
   mov    %r15,        0x1f8(%rsp)
   xor    %r13,        %r13
   xor    %r14,        %r14
   xor    %r15,        %r15
   xor    %rax,        %rax
   mov    0x300(%rsi), %rdx
   mulx   %r8,         %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r8
   adcx   %rbx,        %r9
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r9
   adcx   %rbx,        %r10
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   adox   %rax,        %r12
   adcx   %rax,        %r13
   adox   %rax,        %r13
   mov    0x300(%rsi), %rdx
   mulx   %r9,         %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r9
   adcx   %rbx,        %r10
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   adox   0x1e8(%rsp), %r13
   adcx   %rax,        %r14
   adox   %rax,        %r14
   mov    0x300(%rsi), %rdx
   mulx   %r10,        %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r13
   adcx   %rbx,        %r14
   adox   0x1f0(%rsp), %r14
   adcx   %rax,        %r15
   adox   %rax,        %r15
   mov    0x300(%rsi), %rdx
   mulx   %r11,        %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r13
   adcx   %rbx,        %r14
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r14
   adcx   %rbx,        %r15
   adox   0x1f8(%rsp), %r15
   adcx   %rax,        %r8
   adox   %rax,        %r8
   mov    0x200(%rsp), %rsi
   mov    %r12,        0x00\res
   mov    %r13,        0x08\res
   mov    %r14,        0x10\res
   mov    %r15,        0x18\res
   mov    %r8,         0x20\res
.endm

.macro red_256 res
   mov    %rsi,        0x200(%rsp)
   lea    .LM(%rip),   %rsi
   mov    %r13,        0x1e8(%rsp)
   mov    %r14,        0x1f0(%rsp)
   mov    %r15,        0x1f8(%rsp)
   xor    %r13,        %r13
   xor    %r14,        %r14
   xor    %r15,        %r15
   xor    %rax,        %rax
   mov    0x300(%rsi), %rdx
   mulx   %r8,         %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r8
   adcx   %rbx,        %r9
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r9
   adcx   %rbx,        %r10
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   adox   %rax,        %r12
   adcx   %rax,        %r13
   adox   %rax,        %r13
   mov    0x300(%rsi), %rdx
   mulx   %r9,         %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r9
   adcx   %rbx,        %r10
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   adox   0x1e8(%rsp), %r13
   adcx   %rax,        %r14
   adox   %rax,        %r14
   mov    0x300(%rsi), %rdx
   mulx   %r10,        %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r10
   adcx   %rbx,        %r11
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r13
   adcx   %rbx,        %r14
   adox   0x1f0(%rsp), %r14
   adcx   %rax,        %r15
   adox   %rax,        %r15
   mov    0x300(%rsi), %rdx
   mulx   %r11,        %rdx,  %rbp
   mulx   0x40(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r11
   adcx   %rbx,        %r12
   mulx   0x48(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r12
   adcx   %rbx,        %r13
   mulx   0x50(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r13
   adcx   %rbx,        %r14
   mulx   0x58(%rsi),  %rbp,  %rbx
   adox   %rbp,        %r14
   adcx   %rbx,        %r15
   adox   0x1f8(%rsp), %r15
   adcx   %rax,        %r8
   adox   %rax,        %r8
   shl    $0x3,        %r8
   sub    0x00(%rsi,%r8,1),  %r12
   sbb    0x08(%r8,%rsi,1),  %r13
   sbb    0x10(%r8,%rsi,1),  %r14
   sbb    0x18(%r8,%rsi,1),  %r15
   mov    0x200(%rsp), %rsi
   mov    %r12,        0x00\res
   mov    %r13,        0x08\res
   mov    %r14,        0x10\res
   mov    %r15,        0x18\res
.endm

.macro mod_mul_256 a b res
   mul_256 \a, \b
   red_256 \res
.endm

.macro mod_mul_256_5w a b res
   mul_256    \a, \b
   red_256_5w \res
.endm

.macro add_5w a b res
   xor    %r12,              %r12
   lea    .LM(%rip),         %rdx
   mov    0x00\a,            %r8
   add    0x00\b,            %r8
   mov    0x08\a,            %r9
   adc    0x08\b,            %r9
   mov    0x10\a,            %r10
   adc    0x10\b,            %r10
   mov    0x18\a,            %r11
   adc    0x18\b,            %r11
   mov    0x20\a,            %r12
   adc    0x20\b,            %r12
   shl    %r12
   mov    %r11,              %r13
   shr    $0x3f,             %r13
   or     %r13,              %r12
   shl    $0x6,              %r12
   sub    0x00(%rdx,%r12,1), %r8
   mov    %r8,               0x00\res
   sbb    0x08(%rdx,%r12,1), %r9
   mov    %r9,               0x08\res
   sbb    0x10(%rdx,%r12,1), %r10
   mov    %r10,              0x10\res
   sbb    0x18(%rdx,%r12,1), %r11
   mov    %r11,              0x18\res
.endm

.macro add_4w a b res
   xor    %r12,              %r12
   lea    .LM(%rip),         %rdx
   mov    0x00\a,            %r8
   add    0x00\b,            %r8
   mov    0x08\a,            %r9
   adc    0x08\b,            %r9
   mov    0x10\a,            %r10
   adc    0x10\b,            %r10
   mov    0x18\a,            %r11
   adc    0x18\b,            %r11
   adc    $0x0,              %r12
   shl    %r12
   mov    %r11,              %r13
   shr    $0x3f,             %r13
   or     %r13,              %r12
   shl    $0x6,              %r12
   sub    0x00(%rdx,%r12,1), %r8
   mov    %r8,               0x00\res
   sbb    0x08(%rdx,%r12,1), %r9
   mov    %r9,               0x08\res
   sbb    0x10(%rdx,%r12,1), %r10
   mov    %r10,              0x10\res
   sbb    0x18(%rdx,%r12,1), %r11
   mov    %r11,              0x18\res
.endm

.macro add_sub_5w a b res
   xor    %r12,              %r12
   lea    .LM(%rip),         %rdx
   mov    0x100(%rdx),       %r8
   add    0x00\a,            %r8
   mov    0x108(%rdx),       %r9
   adc    0x08\a,            %r9
   mov    0x110(%rdx),       %r10
   adc    0x10\a,            %r10
   mov    0x118(%rdx),       %r11
   adc    0x18\a,            %r11
   mov    0x120(%rdx),       %r12
   adc    0x20\a,            %r12
   sub    0x00\b,            %r8
   sbb    0x08\b,            %r9
   sbb    0x10\b,            %r10
   sbb    0x18\b,            %r11
   sbb    0x20\b,            %r12
   shl    %r12
   mov    %r11,              %r13
   shr    $0x3f,             %r13
   or     %r13,              %r12
   shl    $0x6,              %r12
   sub    0x00(%rdx,%r12,1), %r8
   mov    %r8,               0x00\res
   sbb    0x08(%rdx,%r12,1), %r9
   mov    %r9,               0x08\res
   sbb    0x10(%rdx,%r12,1), %r10
   mov    %r10,              0x10\res
   sbb    0x18(%rdx,%r12,1), %r11
   mov    %r11,              0x18\res
.endm

.macro add_sub_4w a b res
   xor    %r12,              %r12
   lea    .LM(%rip),         %rdx
   mov    0xc0(%rdx),        %r8
   add    0x00\a,            %r8
   mov    0xc8(%rdx),        %r9
   adc    0x08\a,            %r9
   mov    0xd0(%rdx),        %r10
   adc    0x10\a,            %r10
   mov    0xd8(%rdx),        %r11
   adc    0x18\a,            %r11
   mov    0xe0(%rdx),        %r12
   adc    $0x0,              %r12
   sub    0x00\b,            %r8
   sbb    0x08\b,            %r9
   sbb    0x10\b,            %r10
   sbb    0x18\b,            %r11
   sbb    $0x0,              %r12
   shl    %r12
   mov    %r11,              %r13
   shr    $0x3f,             %r13
   or     %r13,              %r12
   shl    $0x6,              %r12
   sub    0x00(%rdx,%r12,1), %r8
   mov    %r8,               0x00\res
   sbb    0x08(%rdx,%r12,1), %r9
   mov    %r9,               0x08\res
   sbb    0x10(%rdx,%r12,1), %r10
   mov    %r10,              0x10\res
   sbb    0x18(%rdx,%r12,1), %r11
   mov    %r11,              0x18\res
.endm

.macro red_below_m a name
   mov    0x18\a,             %r12
   shr    $0x38,              %r12
   and    $0xC0,              %r12
   mov    0x00\a,             %r8
   sub    0x200(%rdx,%r12,1), %r8
   mov    0x08\a,             %r9
   sbb    0x208(%rdx,%r12,1), %r9
   mov    0x10\a,             %r10
   sbb    0x210(%rdx,%r12,1), %r10
   mov    0x18\a,             %r11
   sbb    0x218(%rdx,%r12,1), %r11

   jnc    .Lred_done\name

   add    0x240(%rdx),        %r8
   adc    0x248(%rdx),        %r9
   adc    0x250(%rdx),        %r10
   adc    0x258(%rdx),        %r11

.Lred_done\name:
   mov    %r8,                0x00\a
   mov    %r9,                0x08\a
   mov    %r10,               0x10\a
   mov    %r11,               0x18\a
.endm

.text
#ifdef __APPLE__
.global _ext_twisted_ed_add_4w
_ext_twisted_ed_add_4w:
#else
.global ext_twisted_ed_add_4w
ext_twisted_ed_add_4w:
#endif

   // p1     = rdi
   // p2     = rsi
   // result = rdx

   push %rbp
   push %rbx
   push %r12
   push %r13
   push %r14
   push %r15
   sub  $8*65, %rsp

   mov  %rdx,  %rcx  // rcx = result

   // S0 = 3*M + Y1 - X1
   add_sub_4w +8*4(%rdi), (%rdi), +8*5(%rsp)

   // S1 = Y1 + X1
   add_4w +8*4(%rdi), (%rdi), +8*9(%rsp)

   // S8 = S0 * S2'
   mod_mul_256_5w +8*5(%rsp), (%rsi), +8*13(%rsp)

   // S9 = S1 * S3'
   mod_mul_256_5w +8*9(%rsp), +8*4(%rsi), +8*18(%rsp)

   // S10 = Z1 * Z2'
   mod_mul_256_5w +8*12(%rdi), +8*12(%rsi), +8*23(%rsp)

   // S11 = T1 * T2'
   mod_mul_256_5w +8*8(%rdi), +8*8(%rsi), +8*28(%rsp)

   // S12
   add_sub_5w +8*18(%rsp), +8*13(%rsp), +8*5(%rsp)

   // S13
   add_5w +8*13(%rsp), +8*18(%rsp), +8*9(%rsp)

   // S14
   add_sub_5w +8*23(%rsp), +8*28(%rsp), +8*13(%rsp)

   // S15
   add_5w +8*23(%rsp), +8*28(%rsp), +8*17(%rsp)

   // X3
   mod_mul_256 +8*5(%rsp), +8*13(%rsp), (%rcx)

   // Y3
   mod_mul_256 +8*9(%rsp), +8*17(%rsp), +8*4(%rcx)

   // Z3
   mod_mul_256 +8*13(%rsp), +8*17(%rsp), +8*12(%rcx)

   // T3
   mod_mul_256 +8*5(%rsp), +8*9(%rsp), +8*8(%rcx)

   lea    .LM(%rip),          %rdx
   red_below_m (%rcx),      X
   red_below_m +8*4(%rcx),  Y
   red_below_m +8*8(%rcx),  T
   red_below_m +8*12(%rcx), Z

   add  $8*65, %rsp
   pop  %r15
   pop  %r14
   pop  %r13
   pop  %r12
   pop  %rbx
   pop  %rbp
   ret

.LM:
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xffffffff00000001
   .quad 0x53bda402fffe5bfe
   .quad 0x3339d80809a1d805
   .quad 0x73eda753299d7d48
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffe00000002
   .quad 0xa77b4805fffcb7fd
   .quad 0x6673b0101343b00a
   .quad 0xe7db4ea6533afa90
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffd00000003
   .quad 0xfb38ec08fffb13fc
   .quad 0x99ad88181ce5880f
   .quad 0x5bc8f5f97cd877d8
   .quad 0x0000000000000001
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffc00000004
   .quad 0x4ef6900bfff96ffb
   .quad 0xcce7602026876015
   .quad 0xcfb69d4ca675f520
   .quad 0x0000000000000001
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffb00000005
   .quad 0xa2b4340efff7cbfa
   .quad 0x2138283029381a
   .quad 0x43a4449fd0137269
   .quad 0x0000000000000002
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffa00000006
   .quad 0xf671d811fff627f9
   .quad 0x335b103039cb101f
   .quad 0xb791ebf2f9b0efb1
   .quad 0x0000000000000002
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffff900000007
   .quad 0x4a2f7c14fff483f8
   .quad 0x6694e838436ce825
   .quad 0x2b7f9346234e6cf9
   .quad 0x0000000000000003
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xffffffff00000001
   .quad 0x53bda402fffe5bfe
   .quad 0x3339d80809a1d805
   .quad 0x73eda753299d7d48
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffe00000002
   .quad 0xa77b4805fffcb7fd
   .quad 0x6673b0101343b00a
   .quad 0xe7db4ea6533afa90
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffe00000002
   .quad 0xa77b4805fffcb7fd
   .quad 0x6673b0101343b00a
   .quad 0xe7db4ea6533afa90
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0x0000000000000000
   .quad 0xfffffffeffffffff

.LTWOINV:
   .quad 0x00000000ffffffff
   .quad 0xac425bfd0001a401
   .quad 0xccc627f7f65e27fa
   .quad 0x0c1258acd66282b7

.LD:
   .quad 0x2a522455b974f6b0
   .quad 0xfc6cc9ef0d9acab3
   .quad 0x7a08fb94c27628d1
   .quad 0x57f8f6a8fe0e262e

#ifdef __APPLE__
.global _ext_twisted_ed_precomp_4w
_ext_twisted_ed_precomp_4w:
#else
.global ext_twisted_ed_precomp_4w
ext_twisted_ed_precomp_4w:
#endif
   // p      = rdi
   // result = rsi

   push %rbp
   push %rbx
   push %r12
   push %r13
   push %r14
   push %r15
   sub  $8*65, %rsp

   // S2 = 3*M + Y2 - X2
   add_sub_4w +8*4(%rdi), (%rdi), (%rsi)

   // S3 = Y2 + X2
   add_4w +8*4(%rdi), (%rdi), +8*4(%rsi)

   // S2' = S2 * 2^-1 mod M
   lea    .LTWOINV(%rip),     %rcx
   mod_mul_256 (%rcx), (%rsi), (%rsi)

   // S3' = S3 * 2^-1 mod M
   mod_mul_256 (%rcx), +8*4(%rsi), +8*4(%rsi)

   // T2' = T2 * D
   lea    .LD(%rip),          %rcx
   mod_mul_256 (%rcx), +8*8(%rdi), +8*8(%rsi)

   // Z2' = Z2
   mov    0x60(%rdi),         %r8
   mov    %r8,                0x60(%rsi)
   mov    0x68(%rdi),         %r8
   mov    %r8,                0x68(%rsi)
   mov    0x70(%rdi),         %r8
   mov    %r8,                0x70(%rsi)
   mov    0x78(%rdi),         %r8
   mov    %r8,                0x78(%rsi)

   add  $8*65, %rsp
   pop  %r15
   pop  %r14
   pop  %r13
   pop  %r12
   pop  %rbx
   pop  %rbp
   ret
