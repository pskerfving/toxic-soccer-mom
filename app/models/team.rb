class Team < ActiveRecord::Base
  belongs_to :group
  has_many :comments, :as => :commentable
  
  after_save :store_flag

  # Build the path to the flag repository
  FLAG_STORE = File.join Rails.root, 'public', 'images', 'flags'

  def flag_filename
    File.join FLAG_STORE, "#{id}.#{flag_extension}"
  end

  def flag_path
    "/images/flags/#{id}.#{flag_extension}"
  end

  def has_flag?
    File.exists? flag_filename
  end

  def flag=(file_data)
    unless file_data.blank?
      @file_data = file_data
      self.flag_extension = file_data.original_filename.split('.').last.downcase
    end
  end
  
  def store_flag
    if @file_data
      FileUtils.mkdir_p FLAG_STORE
      File.open(flag_filename, 'wb') do |f|
        f.write(@file_data.read)
      end
      @file_data = nil
    end
  end

  def name
    return country
  end
  
end
