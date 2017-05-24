class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  default_scope -> { order(date: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :date, presence: true, uniqueness: { scope: :user_id,
    message: "１ユーザーが同じ日に複数日報を作成することはできません" }
end
