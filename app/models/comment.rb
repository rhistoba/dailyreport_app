class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :report
  validates :content, presence: true, length: { maximum: 400 }
  validates :user_id, presence: true
  validates :report_id, presence: true

end
