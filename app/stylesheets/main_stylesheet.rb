class MainStylesheet < ApplicationStylesheet
  include ImageUrlCellStylesheet

  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def hello_world(st)
    st.frame = {top: 100, width: 200, height: 18, centered: :horizontal}
    st.text_alignment = :center
    st.color = color.battleship_gray
    st.font = font.medium
    st.text = 'Hello World'
  end

  def select_image_button(st)
    st.frame = { l: 5, t: 10, w: app_width - 10, h: 40 }
    st.color = color.white
    st.background_color = color.tint
    st.font = font.small
    st.text = '画像を選択'
  end

  def image_url_table(st)
    st.frame = { l: 0, t: 50, w: app_width, h: app_height - 50 }
  end

  def overlay(st)
    st.frame = :full
    st.background_color = color.from_rgba(0, 0, 0, 0.7)
  end

  def overlay_image(st)
    st.frame = :full
    st.view.contentMode = UIViewContentModeScaleAspectFit
  end
end
