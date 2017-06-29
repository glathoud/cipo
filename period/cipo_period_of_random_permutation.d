#!/usr/bin/env rdmd

import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.math;
import std.random;
import std.regex;
import std.stdio;
import std.string;

import core.stdc.stdlib;

import prime_power;
import prime_power_lcm;

void main()
{
  //uint unpseed = unpredictableSeed;
  uint unpseed = 2820533587;  // fix it, to have reproducable results

  uint REPEAT = 300;
  
  auto urng = Random( unpseed );

  writeln; writeln( "unpseed: ", unpseed );

  ulong Q_END = 30;

  for (ulong q = 0; q < Q_END; ++q)
    {
      writeln; writeln( "q: ", q );

      ulong n_cycle_max = 0;
      
      for (uint R = 0; R < REPEAT; ++R )
        {
      
          ulong N = 1UL << q;
          ulong[] arr;
          arr.reserve( N );

          for (ulong a = 0; a < N; ++a)
            arr ~= a;

          // writeln( arr );
          randomShuffle( arr, urng );
          // writeln( arr );

          //write( format( "q: %d,  N=2^q: %d: running...", q, N ) );
          //stdout.flush();

          ulong  done_ubyte_length = N >> 3;

          ubyte* done_ubyte = cast( ubyte* )( malloc( done_ubyte_length ) );
          for (ulong a = done_ubyte_length; a--;)
            done_ubyte[ a ] = 0;

      
          ulong n_done = 0;
      
          ulong[] cylen_arr;

          for (ulong i_begin = 0;
               i_begin < N  &&  n_done < N;
               ++i_begin
               )
            {
              if (done_ubyte[ i_begin >> 3 ] & (1 << (cast(ubyte)( i_begin % 8 ))))
                continue;
          
              ulong cylen = 0;
              ulong i = i_begin;

              do
                {
                  cylen++;
                  n_done++;

                  done_ubyte[ i >> 3 ] |= (1 << (cast(ubyte)( i % 8 )));

                  i = arr[ i ];
                }
              while (i != i_begin);
          
              cylen_arr ~= cylen;
            }

          ulong n_cycle = cylen_arr.length;

          if (n_cycle > n_cycle_max)
            {
              n_cycle_max = n_cycle;

              auto PPP_list = cylen_arr.map!( PPP_of_ulong ).array;
              PPP period = PPP_lcm( PPP_list );

              writeln;
              writefln( "\rq: %d,  N=2^q: %d: done! n_cycle: %d"
                        ~ " cycle lengths: %s"
                        , q, N
                        , n_cycle
                        , cylen_arr
                        );
              writeln( "period (LCM of cycle lengths): ", PPP_toString( period ) );
              stdout.flush();
              
            }
          

          free( done_ubyte );
        }

      writeln;
      writefln( "q: %d, n_cycle_max: %d (after trying %d random permutations)", q, n_cycle_max, REPEAT );
      stdout.flush();
      
    } // `q` loop
}
