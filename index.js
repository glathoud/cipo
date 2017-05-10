(function () {

    var d = document
    ,  cE = 'createElement'
    ,  sA = 'setAttribute'
    ,  aC = 'appendChild'
    , arr = [].slice.call( d.querySelectorAll( 'section' ) )
    ,  ul = d[ cE ]( 'ul' )
    ;
    arr.forEach( anchorify_head_from_section );

    var co_arr = [].slice.call( d.querySelectorAll( '.contents-cont' ) );
    co_arr.forEach( paste_contents_table );
    
    function anchorify_head_from_section( s )
    {
        var id = s.id;
        if (id)
        {
            var  h = s.querySelector( 'h1, h2, h3, h4' )
            , html = h.innerHTML.trim()
            ;
            if (html)
            {
                // Anchor
                
                var a = d[ cE ]( 'a' );
                a[ sA ]( 'href', '#' + id );
                a[ sA ]( 'class', 'anchor' )
                a.textContent = '#';

                h[ aC ]( a );

                // Also prepare the table of contents

                if (/^(?:h1|h2)$/i.test( h.tagName ))
                {
                    var entry = d[ cE ]( 'li' );
                    entry.innerHTML = html;
                    
                    var a_entry = d[ cE ]( 'a' );
                    a_entry[ sA ]( 'href', '#' + id );
                    a_entry[ sA ]( 'class', 'content_entry_anchor' );
                    a_entry[ aC ]( entry );
                    
                    ul[ aC ]( a_entry );
                }
            }
        }
    }

    function paste_contents_table( cont )
    {
        cont[ aC ]( ul.cloneNode( true ) );
    }
    
})();
