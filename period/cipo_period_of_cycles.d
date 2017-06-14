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

      stdout.flush();
    }



}
