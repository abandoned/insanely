# == Schema Information
#
# Table name: assets
#
#  id                :integer         not null, primary key
#  attachable_id     :integer
#  attachable_type   :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  after_save    { |record| record.attachable.touch if record.attachable_type == 'Task'  }
  after_destroy { |record| record.attachable.touch if record.attachable_type == 'Task'  }
  
  attr_accessible :file
  
  has_attached_file :file,
    :url => ':s3_domain_url',
    :storage => :s3,
    :s3_credentials => {
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
      },
    :s3_permissions => 'authenticated-read',
    :s3_protocol => 'http',
    :bucket => {
     'development' => 'insanely_dev',
     'production'  => 'insanely_production',
    }[RAILS_ENV],
    :path => ':attachment/:id/:style/:basename.:extension',
    :styles => {
      :thumb => '240x240>' }
  before_post_process :image?

  def authenticated_s3_url(style=nil)
    "/assets/#{self.id}" + (style.nil? ? '' : "?style=#{style.to_s}")
  end
  
  def image?
    !(file_content_type =~ /^image.*/).nil?
  end
end
