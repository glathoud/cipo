#!/usr/bin/env rdmd

   /*
     Context: "Circular Sets and Powers of Two"
     http://glat.info/cipo

     Task: Compute the length of the cycles composing the permutation
     for N=2^q
     
     Implementation: single pass ; needs less memory than James Waldby 2-pass
     implementation [1].

     Use at your own risk.

     Guillaume Lathoud, June 2017

     [1] https://groups.google.com/forum/#!topic/sci.math/-cUYbGuH6XU
    */

import std.conv;
import std.algorithm;
import std.array;
import std.format;
import std.path;
import std.stdio;

import core.stdc.stdlib;


int main( string[] args )
{
  if (args.length < 2)
    {
      stderr.writeln( "Usage: " ~  baseName( args[ 0 ] ) ~ " <q_begin> [<q_finish> [<q_step>]]" );
      return 1;
    }

  writeln( "ulong.sizeof: ", ulong.sizeof );
  
  ulong q_begin = to!ulong( args[ 1 ] );

  ulong q_finish  = args.length < 3
                                  ?  q_begin
                                  :  to!ulong( args[ 2 ] );
  
  ulong q_step    = args.length < 4
                                  ?  1
                                  :  to!ulong( args[ 3 ] );
  
  writefln( "q_begin: %d  q_finish: %d  q_step: %d"
            , q_begin, q_finish, q_step );

  for (ulong q = q_begin; q <= q_finish; q += q_step)
    {
      ulong N = 1UL << q;

      write( format( "q: %d,  N=2^q: %d: running...", q, N ) );
      stdout.flush();

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

              i = ((i * (i+1)) >> 1UL) % N;
            }
          while (i != i_begin);
          
          cylen_arr ~= cylen;
        }
            
      writefln( "\rq: %d,  N=2^q: %d: done! n_cycle: %d"
                ~ " cycle lengths: %s"
                , q, N
                , cylen_arr.length
                , cylen_arr
                );

      free( done_ubyte );

    } // `q` loop
  
  return 0;
}
