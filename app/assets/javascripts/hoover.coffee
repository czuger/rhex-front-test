$(document).ready ->

  $( '#map' ).mousemove ( event ) ->

    pos = $(this).position()
    x = (event.pageX - pos.left)
    y = (event.pageY - pos.top)

    $( "#pos" ).text( "pageX: " + x + ", pageY: " + y )

    $.get "get_hex_value/#{x}/#{y}" , (data) ->
      $( "#ground" ).text( data )