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

        wrapper = $('#outsideWrapper')[0]
        c.width  = wrapper.offsetWidth
        c.height = wrapper.offsetHeight

        half_width =  parseFloat( $('#half_width').val() )
        quarter_height =  parseFloat( $('#quarter_height').val() )

        ctx = c.getContext '2d'
        ctx.clearRect(0, 0, c.width, c.height);
        ctx.font = '1.4em monospace'
        ctx.textAlign = "center";

        movements_xy = data[ 'movements_xy' ]
        costs = data[ 'costs' ]

        console.log( movements_xy, costs )

        cost_index = 0
        for hex in movements_xy
          x = parseFloat( hex[ 0 ] ) + 1
          y = parseFloat( hex[ 1 ] ) + 1

          ctx.moveTo( x - half_width, y + quarter_height )
          ctx.lineTo( x, y + 2.0*quarter_height )
          ctx.lineTo( x + half_width, y + quarter_height )
          ctx.lineTo( x + half_width, y - quarter_height )
          ctx.lineTo( x, y - 2.0*quarter_height )
          ctx.lineTo( x - half_width, y - quarter_height )
          ctx.lineTo( x - half_width, y + quarter_height )

          ctx.fillText( costs[ cost_index ], x, y+6 );

          cost_index += 1

        ctx.strokeStyle = "rgba(0,0,0,1)"
        ctx.stroke()

#        ctx.fillStyle = "rgba(0,0,0,0.5)"
#        ctx.fill()

