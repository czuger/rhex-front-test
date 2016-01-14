class MapController < ApplicationController

  @@g = nil

  MOVEMENT_COSTS = { m: 4, f: 2, w: Float::INFINITY, h: 2, g: 1, r: 2 }

  def show
    set_grid
    @grid = @@g
  end

  def compute_movement

    start_x = params[ :start_x ].to_i
    start_y = params[ :start_y ].to_i

    end_x = params[ :end_x ].to_i
    end_y = params[ :end_y ].to_i

    start_hex = @@g.hex_at_xy( start_x, start_y )
    end_hex = @@g.hex_at_xy( end_x, end_y )

    movements = @@g.compute_movement( start_hex, end_hex, MOVEMENT_COSTS )
    movements_xy = movements.map{ |m| @@g.to_xy( m ) }

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