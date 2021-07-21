class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

# 通知（アソシエーション）
has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

#ここまで

  #いいね
  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end

  #フォロー時の通知
 def create_notification_follow!(current_user)
  temp = Notification.where(["visiter_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
  if temp.blank?
    notification = current_user.active_notifications.new(
      visited_id: id,
      action: 'follow'
    )
    notification.save if notification.valid?
  end
 end
end
