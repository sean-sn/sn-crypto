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

fn main() {
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
        0xc52a0dc053aa585,
        0xdc978a5596c4640e,
        0xe5cb984711bd73e,
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

    let exp = [
        0x43eb5fbbd8506990,
        0xb23bc59af20a5413,
        0x5a598845d099c943,
        0x2d8d2018585a1c66,
        0x327be7dedc4642fc,
        0xb0ec1558ee8527e8,
        0x4bdc4e7acec63b80,
        0x68e9646a51fb2120,
        0x48ea0d4ce0f5bb7e,
        0xa14567ff5bc8af57,
        0x0a31a105eab2729e,
        0x2d0a8500cc77b0e9,
        0x4688123702b19113,
        0x0d85e2a740dbed5a,
        0xe6c31499f7035526,
        0x03b55bfbd6fd84ac,
    ];

    twisted_edwards_jubjub_add::ext_twisted_ed_add_256(&p1, &p2, &mut res);
    println!("Point Addition result");
    println!("{:?}", res);
    assert_eq!(res[0..16], exp[0..16], "\nPoint Addition error\n");

    let p2_orig = [
        0x2afade0c0a259061,
        0x4a7cb2f83b04c850,
        0xcc69c91fd7018095,
        0x41d95769d5d47c7e,
        0x6d12ae13ff0d1d3e,
        0x21e632c2cf6edeb9,
        0x1fff239360291f8c,
        0x4ecdc2f23600af47,
        0x0bd0e493d127f4b1,
        0x6366fdb78aeb059f,
        0x5432095bb20d3e42,
        0x3432049b4dc7a3eb,
        0x289cb1917310c932,
        0xd0293c1f2a2b6dab,
        0x164b5c34185c3a44,
        0x123889fdb3b9e79f,
    ];

    twisted_edwards_jubjub_add::ext_twisted_ed_precomp_256(&p2_orig, &mut res);
    println!("Precomputation result");
    println!("{:?}", res);
    assert_eq!(res[0..16], p2[0..16], "\nPrecomputation error\n");
}
