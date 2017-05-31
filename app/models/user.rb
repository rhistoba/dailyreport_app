class User < ApplicationRecord
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :department, presence: true, length: { maximum: 50 }
  validate :confirm_updatable, on: :update
  before_destroy :confirm_deletable

  scope :working, -> { where(retire: false) }

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def confirm_updatable
    if (self.admin_was && !self.retire_was) &&
        (!self.admin? || self.retire?) &&
        less_working_admin?
      self.errors[:base] << "在職中の管理者は1人以上必要です"
    end
  end

  def confirm_deletable
    if (self.admin? && !self.retire?) && less_working_admin?
      self.errors[:base] << "在職中の管理者は1人以上必要です"
      throw(:abort)
    end
  end

  def less_working_admin?
    User.where(admin: true, retire: false).count <= 1
  end

end
