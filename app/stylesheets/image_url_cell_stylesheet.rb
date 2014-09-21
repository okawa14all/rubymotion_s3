module ImageUrlCellStylesheet

  def image_url_cell_height
    70
  end

  def image_url_cell(st)
    st.background_color = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def cell_label(st)
    # st.color = color.white
  end

end
