

/*
  Miller-Rabin test for primality. 
  
  Use at your own risk.

  Guillaume Lathoud, 2017
  glat@glat.info
*/

alias DetArr = immutable ulong[];

DetArr det_arr_0 = [ 2 ];
DetArr det_arr_1 = [ 2, 3 ];
DetArr det_arr_2 = [ 31, 73 ];
DetArr det_arr_3 = [ 2, 3, 5 ];

DetArr det_arr_4 = [2, 3, 5, 7];
DetArr det_arr_5 = [2, 7, 61 ];
DetArr det_arr_6 = [ 2, 13, 23, 1662803 ];
DetArr det_arr_7 = [2, 3, 5, 7, 11 ];

DetArr det_arr_8  = [2, 3, 5, 7, 11, 13 ];
DetArr det_arr_9  = [2, 3, 5, 7, 11, 13, 17 ];
DetArr det_arr_10 = [2, 3, 5, 7, 11, 13, 17, 19, 23];
DetArr det_arr_11 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37 ];

bool mrt_get_is_prime( in ulong n, in uint k = 10 )
/*
  Miller-Rabin test for primality. 

  Implementation inspired from:
  
  https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test#Computational_complexity

  https://de.wikipedia.org/wiki/Miller-Rabin-Test

  and turned deterministic (and much faster) for the whole available 64 bits using:

  https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test#Deterministic_variants
*/
{
  pragma( inline, true );
  
  if (0 == (n & 1))
    return false;
    
  ulong nm1 = n - 1;
  ulong   d = nm1 >> 1;

  ulong j = 1;
  while ((d & 1) == 0)  d >>= 1, ++j;

  /*

    https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test#Deterministic_variants

    if n < 2,047, it is enough to test a = 2;
    if n < 1,373,653, it is enough to test a = 2 and 3;
    if n < 9,080,191, it is enough to test a = 31 and 73;
    if n < 25,326,001, it is enough to test a = 2, 3, and 5;
    if n < 3,215,031,751, it is enough to test a = 2, 3, 5, and 7;
    if n < 4,759,123,141, it is enough to test a = 2, 7, and 61;
    if n < 1,122,004,669,633, it is enough to test a = 2, 13, 23, and 1662803;
    if n < 2,152,302,898,747, it is enough to test a = 2, 3, 5, 7, and 11;
    if n < 3,474,749,660,383, it is enough to test a = 2, 3, 5, 7, 11, and 13;
    if n < 341,550,071,728,321, it is enough to test a = 2, 3, 5, 7, 11, 13, and 17.

    Using the work of Feitsma and Galway enumerating all base 2 pseudoprimes in 2010, this was extended (see OEIS A014233), with the first result later shown using different methods in Jiang and Deng:[10]

    if n < 3,825,123,056,546,413,051, it is enough to test a = 2, 3, 5, 7, 11, 13, 17, 19, and 23.
    if n < 18,446,744,073,709,551,616 = 2^64, it is enough to test a = 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, and 37.
  */

  DetArr* det_arr;
  if (n < 25_326_001UL)
    {
      if (n < 2_047UL)
        det_arr = &det_arr_0;

      else if (n < 1_373_653UL)
        det_arr = &det_arr_1;

      else if (n < 9_080_191UL)
        det_arr = &det_arr_2;

      else
        det_arr = &det_arr_3;
    }
  else if (n < 2_152_302_898_747UL)
    {
      if (n < 3_215_031_751UL)
        det_arr = &det_arr_4;

      else if (n < 4_759_123_141UL)
        det_arr = &det_arr_5;

      else if (n < 1_122_004_669_633UL)
        det_arr = &det_arr_6;

      else
        det_arr = &det_arr_7;
    }
  else {

    if (n < 3_474_749_660_383UL)
      det_arr = &det_arr_8;
        
    else if (n < 341_550_071_728_321UL)
      det_arr = &det_arr_9;
        
    else if (n < 3_825_123_056_546_413_051UL)
      det_arr = &det_arr_10;

    else
      det_arr = &det_arr_11;
  }

 mainloop: foreach( a ; *det_arr )
    {
      ulong t = a, p = a;
      ulong d2 = d;
      while (d2 >>= 1) { //square and multiply: a^d mod n
        p = p*p % n;
        if (d2 & 1) t = t*p % n;
      }

      if (t == 1 || t == nm1) continue mainloop; // n ist probably prime

      for (int j2=1 ; j2<j ; ++j2) {
        t = t*t % n;

        if (t == nm1) continue mainloop;
        if (t <= 1) break;
      }
      return false;  // n is not prime
    }

  return true; // because always deterministic
}
