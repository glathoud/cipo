#!/usr/bin/env rdmd

import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.math;
import std.regex;
import std.stdio;
import std.string;

import prime_power;
import prime_power_lcm;

void main()
{

char[] data = cast( char[] )( std.file.read( "../cycles/cipo_cycles.result.txt" ) );
  writeln( data );

  auto rx = ctRegex!( `^q:\s+(\d+)[^\r\n]+?\[\s*(\d+(?:\s*,\s*\d+)*)\s*\]`, "gm" );
  foreach( one; matchAll( data, rx ) )
    {
      writeln;
      writeln( "." );
      writeln;
      
      // writeln( one );

      ulong   q = to!ulong( one[ 1 ] );
      ulong[] cylen_arr = one[ 2 ]
        .split( "," )
        .map!( `to!ulong( a.strip() )` ).array
        ;
      writeln( "q: ", q );
      writeln( "cylen_arr: ", cylen_arr );

      auto PPP_list = cylen_arr.map!( PPP_of_ulong ).array;
      foreach( i, ppp; PPP_list )
        {
          auto cylen = cylen_arr[ i ];
          assert( ulong_of_PPP( ppp ) == cylen );
          writeln( PPP_toString( ppp ), "    = ", cylen );
        }

      PPP period = PPP_lcm( PPP_list );
      writeln;
      writeln( "period (LCM of cycle lengths): ", PPP_toString( period ) );

      if (q < 13 && false)
        {
          auto period_ul  = ulong_of_PPP( period );
          writeln( "q < 13: quick comparison" );
          writeln( "period (ulong): ", period_ul, ", sanity check: ", PPP_toString( PPP_of_ulong( period_ul ) ) );

          auto to_compare = period_ul - 1;
          auto to_compare_ppp = PPP_of_ulong( to_compare );
          writeln( "to_compare: ", to_compare, " => factorized: ", PPP_toString( to_compare_ppp ) );

          auto to_compare2 = period_ul - 2;
          auto to_compare2_ppp = PPP_of_ulong( to_compare2 );
          writeln( "to_compare2: ", to_compare2, " => factorized: ", PPP_toString( to_compare2_ppp ) );
        }

      
      stdout.flush();
    }



}
