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
#![no_std]
#![feature(test)]
extern crate test;
extern crate twisted_edwards_jubjub_add;

use test::Bencher;

#[bench]
fn bench_point_add_256(b: &mut Bencher) {
    let p1 = [
        0x0000000000000000,
        0x0000000000000000,
        0x0000000000000000,
        0x0000000000000000,
        0x00000001fffffffe,
        0x5884b7fa00034802,
        0x998c4fefecbc4ff5,
        0x1824b159acc5056f,
        0x0000000000000000,
        0x0000000000000000,
        0x0000000000000000,
        0x0000000000000000,
        0x00000001fffffffe,
        0x5884b7fa00034802,
        0x998c4fefecbc4ff5,
        0x1824b159acc5056f,
    ];

    let p2 = [
        0x210be8037a73c66f,
        0x159391e6ca343934,
        0x4367993dc964bb7e,
        0x4071096dc4e4d808,
        0x4c06c610849956cf,
        0x0c52a0dc053aa585,
        0xdc978a5596c4640e,
        0x0e5cb984711bd73e,
        0xae245a82ad8081b3,
        0x68fcc71d81c38d3e,
        0x377b223d9eb90395,
        0x2d77b058134da243,
        0x289cb1917310c932,
        0xd0293c1f2a2b6dab,
        0x164b5c34185c3a44,
        0x123889fdb3b9e79f,
    ];

    let mut res: [u64; 16] = [5; 16];

    b.iter(|| {
        twisted_edwards_jubjub_add::ext_twisted_ed_add_256(&p1, &p2, &mut res);
    });
}
