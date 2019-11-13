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

// <favorite_compiler> -pedantic-errors -Wall -Wextra -Werror -O3 -march=native ../../asm/ext_twisted_ed_add.S example.cpp

#include <iostream>
#include <iomanip>
#include <algorithm>
#include <cmath>

#define NUM_TIMED_RUNS 10000
#define INNER_LOOP     1000

extern "C" {
   void ext_twisted_ed_add_4w(unsigned long long int* a,
                              unsigned long long int* b,
                              unsigned long long int* res);

   void ext_twisted_ed_precomp_4w(unsigned long long int* a,
                                  unsigned long long int* res);
}

inline __attribute__((always_inline)) uint64_t get_tsc() {
   uint64_t count;

   // Read Time-Stamp Counter, Opcode - 0x0F 0x31, EDX:EAX <- TSC
   __asm__ volatile(".byte 15; .byte 49;  \
                     shlq  $32,   %%rdx;  \
                     orq   %%rdx, %%rax;"
                    : "=a" (count)
                    :
                    : "%rdx"
                   );
   return count;
}

// Calculate mean (rounded to int)
uint64_t calc_mean(uint64_t *values, uint64_t length) {
   uint64_t total = 0;

   for (uint64_t i=0; i<length; i++) {
      total += values[i];
   }

   return total/length;
}

// Calculate variance (rounded to int) for standard deviation
uint64_t calc_variance(uint64_t *values, uint64_t length) {
   uint64_t mean = (uint64_t) calc_mean(values, length);
   uint64_t var_sum = 0;

   for (uint64_t i=0; i<length; i++) {
      var_sum += pow(int64_t(values[i]-mean), 2);
   }

   return var_sum / mean;
}

int main() {
   uint64_t i, j;
   uint64_t start, end;
   uint64_t results[NUM_TIMED_RUNS];
   uint64_t std_dev;
   double   cycles_per_inst;

   unsigned long long int P_1[16] = { 0x0000000000000000, 0x0000000000000000,
                                      0x0000000000000000, 0x0000000000000000,
                                      0x00000001fffffffe, 0x5884b7fa00034802,
                                      0x998c4fefecbc4ff5, 0x1824b159acc5056f,
                                      0x0000000000000000, 0x0000000000000000,
                                      0x0000000000000000, 0x0000000000000000,
                                      0x00000001fffffffe, 0x5884b7fa00034802,
                                      0x998c4fefecbc4ff5, 0x1824b159acc5056f
   };

   // Original P2
   unsigned long long int O_2[16] = { 0x2afade0c0a259061, 0x4a7cb2f83b04c850,
                                      0xcc69c91fd7018095, 0x41d95769d5d47c7e,
                                      0x6d12ae13ff0d1d3e, 0x21e632c2cf6edeb9,
                                      0x1fff239360291f8c, 0x4ecdc2f23600af47,
                                      0x0bd0e493d127f4b1, 0x6366fdb78aeb059f,
                                      0x5432095bb20d3e42, 0x3432049b4dc7a3eb,
                                      0x289cb1917310c932, 0xd0293c1f2a2b6dab,
                                      0x164b5c34185c3a44, 0x123889fdb3b9e79f
   };

   // Precomputed P2
   unsigned long long int P_2[16] = { 0x210be8037a73c66f, 0x159391e6ca343934, 
                                      0x4367993dc964bb7e, 0x4071096dc4e4d808,
                                      0x4c06c610849956cf, 0x0c52a0dc053aa585,
                                      0xdc978a5596c4640e, 0x0e5cb984711bd73e,
                                      0xae245a82ad8081b3, 0x68fcc71d81c38d3e,
                                      0x377b223d9eb90395, 0x2d77b058134da243,
                                      0x289cb1917310c932, 0xd0293c1f2a2b6dab,
                                      0x164b5c34185c3a44, 0x123889fdb3b9e79f
   };

   unsigned long long int exp[16] = { 0x43eb5fbbd8506990, 0xb23bc59af20a5413,
                                      0x5a598845d099c943, 0x2d8d2018585a1c66,
                                      0x327be7dedc4642fc, 0xb0ec1558ee8527e8,
                                      0x4bdc4e7acec63b80, 0x68e9646a51fb2120,
                                      0x48ea0d4ce0f5bb7e, 0xa14567ff5bc8af57,
                                      0x0a31a105eab2729e, 0x2d0a8500cc77b0e9,
                                      0x4688123702b19113, 0x0d85e2a740dbed5a,
                                      0xe6c31499f7035526, 0x03b55bfbd6fd84ac
   };

   unsigned long long int result[16];

   unsigned long long int precomputed[16];
   std::cout << "Precomputed Actual" << std::endl;
   ext_twisted_ed_precomp_4w(O_2, precomputed);
   for (i=0; i<16; i++) {
      std::cout << "Actual:   " << std::hex << precomputed[i] << std::endl;
      std::cout << "Expected: " << std::hex << P_2[i] << std::endl;
   }

   ext_twisted_ed_add_4w(P_1, P_2, result);

   std::cout << std::endl << "Num2 Actual" << std::endl;
   for (i=0; i<16; i++) {
      std::cout << "Actual:   " << std::hex << result[i] << std::endl;
      std::cout << "Expected: " << std::hex << exp[i] << std::endl;
   }

   // Warm up
   for (i=0; i<INNER_LOOP; i++) {
      ext_twisted_ed_add_4w(P_1, P_2, result);
   }

   for (j=0; j<NUM_TIMED_RUNS; j++) {
      start = get_tsc();
      for (i=0; i<INNER_LOOP; i++) {
         ext_twisted_ed_add_4w(P_1, P_2, result);
         P_1[0] = result[0];
      }
      end = get_tsc();
      results[j] = end - start;
   }

   std::cout << std::dec << "Min " 
             << *(std::min_element(std::begin(results), std::end(results))) 
             << std::endl;
   std::cout << std::dec << "Max " 
             << *(std::max_element(std::begin(results), std::end(results))) 
             << std::endl;

   std_dev = sqrt(calc_variance(results, NUM_TIMED_RUNS));
   std::cout << std::dec << "Std Dev " << std_dev << std::endl;

   cycles_per_inst = calc_mean(results, NUM_TIMED_RUNS) / (INNER_LOOP);
   std::cout << std::dec << "Cyc/Inst " << cycles_per_inst << std::endl;

   return 0;
}
