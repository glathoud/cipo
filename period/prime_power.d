import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.math;
import std.regex;
import std.stdio;
import std.string;

/*
  Prime factorization of non-negative integers.

  Use at your own risk.

  Guillaume Lathoud, 2017
*/

struct PP {
  ulong prime;
  ulong power;

  string toString() const pure
  {
    assert( prime > 0 );
    assert( power > 0 );
    return power == 1  ?  to!string( prime )
      :  to!string( prime ) ~ "^" ~ to!string( power )
      ;
  }

};

alias PPP = PP[];

string PPP_toString( in PPP ppp ) pure
{
  return ppp.length < 1  ?  "1"  :  ppp.map!"a.toString()".join( " * " );
}

  
PPP PPP_of_ulong( in ulong x )
{
  PPP ret;

  ulong remaining = x;

  auto prili = get_prime_list_up_to( x );

  if (prili.length > 0  &&  prili[ $-1 ] == x)
    {
      ret ~= PP( x, 1 );
    }
  else
    {
      foreach( prime; prili )
        {
          ulong power = 0;
          while (0 == remaining % prime)
            {
              remaining /= prime;
              power++;
            }
          
          if (power > 0)
            {
              ret ~= PP( prime, power );
            }
        }
    }
  
  return ret;
}

private ulong   _prime_last_x = 1;
private ulong[] _prime_list;

ulong[] get_prime_list_up_to( in ulong x )
{
  while (_prime_last_x < x)
    {
      ulong next = ++_prime_last_x;

      auto half_next = next >> 1;
      bool is_prime  = true;;
      foreach( prime; _prime_list )
        {
          if (prime > half_next)
            break;

          if (0 == next % prime)
            {
              is_prime = false;
              break;
            }
        }

      if (is_prime)
        _prime_list ~= next;
    }

  auto ind = _prime_list.countUntil!( a => a > x );
  
  return ind < 0  ?  _prime_list  :  _prime_list[ 0 .. ind ];
}
