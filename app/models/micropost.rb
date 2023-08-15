class Micropost < ApplicationRecord
    validates :content, presence: true, length: {maximum: 140}
    validates :user_id, presence: true
    belongs_to :user
    has_one_attached :image
end
