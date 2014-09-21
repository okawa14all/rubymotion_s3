class MainController < UIViewController
  ACCESS_KEY_ID = ''
  SECRET_KEY    = ''
  BUCKET = ''
  BASE_URL = 'https://s3-ap-northeast-1.amazonaws.com/<your_backet>/'
  IMAGE_URL_CELL_ID = 'ImageUrlCell'

  def viewDidLoad
    super

    self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = MainStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    @s3 = AmazonS3Client.alloc.initWithAccessKey(ACCESS_KEY_ID, withSecretKey: SECRET_KEY)

    rmq.append(UIButton, :select_image_button).on(:touch) do |sender|
      open_image_picker_controller
    end

    @tableView = rmq.append(UITableView, :image_url_table).get.tap do |tv|
      tv.delegate = self
      tv.dataSource = self
      tv.setSeparatorInset(UIEdgeInsetsZero)
    end

    load_saved_image_names
  end

  def viewDidAppear(animated)
    @tableView.reloadData
  end

  def init_nav
    self.title = 's3 sample'
  end

  def load_saved_image_names
    @image_names = App::Persistence['image_names'] || []
  end

  def open_image_picker_controller
    picker = UIImagePickerController.new
    picker.delegate = self
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    self.presentModalViewController(picker, animated: true)
  end

  def imagePickerController(picker, didFinishPickingImage:image, editingInfo:editingInfo)
    uploadImage(UIImageJPEGRepresentation(image, 1.0))
    picker.dismissModalViewControllerAnimated(true)
  end

  def uploadImage(image_data)
    SVProgressHUD.show

    image_name = "#{Time.now.to_i}.jpg"
    req = S3PutObjectRequest.alloc.initWithKey(image_name, inBucket: BUCKET).tap do |r|
      r.contentType = "image/jpeg"
      r.data = image_data
      r.cannedACL = S3CannedACL.publicRead
    end

    response = @s3.putObject(req)

    p response

    if response.error
      puts response.error
    else
      puts "#{image_name} uploaded"
      @image_names << image_name
      App::Persistence['image_names'] = @image_names
    end

    SVProgressHUD.dismiss
  end

  # UITableView delegate
  def tableView(table_view, numberOfRowsInSection: section)
    @image_names.length
  end

  def tableView(table_view, heightForRowAtIndexPath: index_path)
    rmq.stylesheet.image_url_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    image_name = @image_names[index_path.row]

    cell = table_view.dequeueReusableCellWithIdentifier(IMAGE_URL_CELL_ID) || begin
      rmq.create(
        ImageUrlCell, :image_url_cell,
        reuse_identifier: IMAGE_URL_CELL_ID,
        cell_style: UITableViewCellStyleDefault
      ).get
    end

    cell.update(image_name)
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath: index_path)
    image_name = @image_names[index_path.row]
    show_image(image_name)
  end

  def show_image(image_name)
    puts "#{BASE_URL}#{image_name}"
    rmq.wrap(rmq.app.window).tap do |o|
      o.append(UIView, :overlay).animations.fade_in.on(:tap) do |sender|
        o.find(sender, :overlay_image).hide.remove
      end
      o.append(UIImageView, :overlay_image).get.url = "#{BASE_URL}#{image_name}"
    end
  end

end
