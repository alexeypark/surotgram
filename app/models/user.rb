class User < ApplicationRecord
  acts_as_voter
  paginates_per 5

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: '152x152#' }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates :user_name, presence: true, length: { minimum: 4, maximum: 16 }, format: { without: /[.\s]/ }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :active_relationships,  class_name:  "Relationship",
           foreign_key: "follower_id",
           dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
           foreign_key: "followed_id",
           dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
end
