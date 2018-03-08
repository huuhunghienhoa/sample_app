class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_length}
  validate :picture_size

  scope :newest, ->{order(created_at: :desc)}
  scope :post_feed, ->(following_ids, id){where "user_id IN (?) OR user_id = ?", following_ids, id}

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    if picture.size > Settings.micropost.max_size.bytes
      errors.add :picture, I18n.t("microposts.micropost.mess_limit_size")
    end
  end
end
