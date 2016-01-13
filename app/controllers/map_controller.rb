class MapController < ApplicationController

  @@g = nil

  MOVEMENT_COSTS = { m: 4, f: 2, w: Float::INFINITY, h: 2, g: 1, r: 2 }

  def show
    set_grid
  end

  def compute_movement
    set_at_xy
    unless session[ :movement_started ]
      session[ :movement_started ] = true
      session[ :start_hex ] = [ @hex.q, @hex.r ]
    else
      session[ :movement_started ] = false
      puts session[ :movement_started ].inspect
      second_hex = Hex::Axial.new( session[ :start_hex ][ 0 ], session[ :start_hex ][ 1 ] )
      movements = @@g.compute_movement( second_hex, @hex, MOVEMENT_COSTS )
      movements_xy = movements.map{ |m| @@g.to_xy( m ) }
    end
    render json: movements_xy
  end

  def get_hex_value
    set_at_xy
    render layout: false
  end

  private

  def set_at_xy
    x = params[ :x ].to_i
    y = params[ :y ].to_i

    set_grid

    @hex = @@g.hex_at_xy( x, y )
  end

  def set_grid
    unless @@g

      # Create a grid with a correspondence array from val to color
      @@g = Hex::Grid.new(
        element_to_color_hash: {
          m: :maroon, f: :green, w: :blue, h: :chocolate, g: :limegreen, r: :royalblue
        }
      )

      # Load the same map we used before
      @@g.read_ascii_file( 'app/controllers/map.txt' )

      # Create the pic
      @@g.to_pic( 'public/images/test2.png' )

    end
  end
end