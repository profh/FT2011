module ApplicationHelper
  
  def random_image
    image_files = %w( .jpg .gif .png )
    files = Dir.entries(
      "#{RAILS_ROOT}/public/images/random"
      ).delete_if { |x| !image_files.index(x[-4,4]) }
      files[rand(files.length)]
  end
end
