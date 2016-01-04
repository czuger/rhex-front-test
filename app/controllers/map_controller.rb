class MapController < ApplicationController

  def show

    # Create a grid with a correspondence array from val to color
    g = Hex::Grid.new(
      element_to_color_hash: {
        m: :brown, g: :green, w: :blue
      }
    )

    # Load the same map we used before
    g.read_ascii_file( 'app/controllers/map.txt' )

    # Create the pic
    g.to_pic( 'public/images/test2.png' )

  end

end