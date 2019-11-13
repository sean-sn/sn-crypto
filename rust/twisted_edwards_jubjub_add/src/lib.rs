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
#[cfg(not(target_arch = "x86_64"))]
compile_error!("x86-64 Only");

#[link(name = "sncrypto-twisted", kind = "static")]
extern "C" {
    fn ext_twisted_ed_add_4w(a: &[u64; 16], b: &[u64; 16], res: &mut [u64; 16]);
    fn ext_twisted_ed_precomp_4w(a: &[u64; 16], res: &mut [u64; 16]);
}

#[inline]
pub fn ext_twisted_ed_add_256(a: &[u64; 16], b: &[u64; 16], res: &mut [u64; 16]) {
    unsafe { ext_twisted_ed_add_4w(a, b, res) }
}

#[inline]
pub fn ext_twisted_ed_precomp_256(a: &[u64; 16], res: &mut [u64; 16]) {
    unsafe { ext_twisted_ed_precomp_4w(a, res) }
}
