class Preview < ActiveRecord::Base
  belongs_to :item

  has_attached_file :image, styles: { thumb: "300x200#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
