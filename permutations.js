get_period( 4 );
function get_period( N, verbose )
{
    var permutation = get_permutation( N )
    ,   permute     = get_permute_impl( permutation )

    //  initial: [ 0, 1, 2, ... , N-1 ]
    ,   initial     = Array.apply( null, { length : N } ).map( (_,i) => i )
    ;
    for (var initial_s = initial.join( ',' )
         , i_step = 0, current = initial.slice()
         ;
         i_step === 0  ||  initial_s !== current.join( ',' )
         ;
         i_step++, current = permute( current )
        )
    {
        verbose  &&  console.log('xxx i_step ', i_step, ' current ', ''+current);
    }
    verbose  &&  console.log('xxx period ', i_step, ' current ', ''+current);
    return i_step;
}
function get_permutation( N )
{
    var ret = [];
    for (var i = 0, j = 0;
         i < N;
         i++, j = (j + i) % N)
    {
        ret.push( j );
    }
    return ret;
}
function get_permute_impl( permutation )
{
    return new Function(
        'arr'
        , 'return [' +
            permutation.map( j => 'arr['+j+']' ).join( ', ' ) +
            ']'
    );
}
