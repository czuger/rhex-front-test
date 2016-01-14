root = exports ? this

$(document).ready ->

  $( '#outsideWrapper' ).mousemove ( event ) ->

    pos = $(this).position()
    x = (event.pageX - pos.left)
    y = (event.pageY - pos.top)

    $( "#pos" ).text( "pageX: " + x + ", pageY: " + y )

    $.get "get_hex_value/#{x}/#{y}" , (data) ->
      $( "#ground" ).html( data )

  $( '#outsideWrapper' ).click ( event ) ->

    pos = $(this).position()

    unless root.start_recorded
      root.start_recorded = true
      root.start = event
    else
      start_x = (root.start.pageX - pos.left)
      start_y = (root.start.pageY - pos.top)

      end_x = (event.pageX - pos.left)
      end_y = (event.pageY - pos.top)

      root.start_recorded = false

      $.get "compute_movement/#{start_x}/#{start_y}/#{end_x}/#{end_y}" , (data) ->
        # Draw the hexes
        c = $('#coveringCanvas')[0]
        ctx = c.getContext '2d'

        half_width =  parseFloat( $('#half_width').val() )
        quarter_height =  parseFloat( $('#quarter_height').val() )

        ctx.clearRect(0, 0, c.width, c.height);

        for hex in data
          console.log( hex )
          x = parseFloat( hex[ 0 ] )
          y = parseFloat( hex[ 1 ] )
          console.log( x, y )
          console.log( half_width, quarter_height )

          ctx.moveTo( x - half_width, y + quarter_height )
          ctx.lineTo( x, y + 2.0*quarter_height )
          ctx.lineTo( x + half_width, y + quarter_height )
          ctx.lineTo( x + half_width, y - quarter_height )
          ctx.lineTo( x, y - 2.0*quarter_height )
          ctx.lineTo( x - half_width, y - quarter_height )
          ctx.lineTo( x - half_width, y + quarter_height )

#          ctx.fillStyle = "rgba(255,0,0,1)"
#          ctx.fill()
          ctx.strokeStyle = "rgba(255,0,0,1)"
          ctx.stroke()


