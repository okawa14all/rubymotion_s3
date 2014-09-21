class ImageUrlCell < UITableViewCell

  def rmq_build
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    q = rmq(self.contentView)
    @image_name = q.build(self.textLabel, :cell_label).get
  end

  def update(image_name, &callback)
    @image_name.text = image_name
  end

end
