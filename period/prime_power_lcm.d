import prime_power;

import std.algorithm;
import std.array;
import std.math;

/*
  Least Common Multiplier (LCM) of a product of non-negative integers,
  each being represented using by a prime factorization PP_prod.

  Use at your own risk.

  Guillaume Lathoud, 2017
 */

PPP PPP_lcm( in PPP[] pppli )
{
  // The lcm will be the product of multiplying the highest power of
  // each prime number together.
  // 
  // https://en.wikipedia.org/wiki/Least_common_multiple#Finding_least_common_multiples_by_prime_factorization

  ulong[ulong] max_power_of_prime;
  
  foreach( one; pppli )
    {
      foreach( pp; one )
        {
          auto prime = pp.prime;
          auto power = pp.power;
          auto existing = prime in max_power_of_prime;

          max_power_of_prime[ prime ] = max
            (
             power
             , existing  ?  *existing  :  0
             );
        }
    }

  // Now that we have the max power of each prime, build the LCM.

  return max_power_of_prime
    .keys
    .sort!"a < b"
    .map!( prime => PP( prime, max_power_of_prime[ prime ] ) )
    .array
    ;
}
