class Post < ApplicationRecord
  acts_as_votable
  paginates_per 5
  validates :image, presence: true
  validates :user_id, presence: true

  has_attached_file :image,
                    styles: { medium: "640x", thumb: '100x100>' },
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :image,
                                    :content_type => /\Aimage\/.*\Z/

  belongs_to :user
  has_many :comments, dependent: :destroy
end
