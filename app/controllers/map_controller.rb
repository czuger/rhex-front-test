class MapController < ApplicationController

  @@g = nil

  def show
    set_grid
  end

  def get_hex_value

    x = params[ :x ].to_i
    y = params[ :y ].to_i

    set_grid

    @hex_value = @@g.hex_at_xy( x, y ).val

    render layout: false
  end

  private

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