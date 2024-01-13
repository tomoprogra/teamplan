class Invitation < ApplicationRecord
  before_create :generate_token
  belongs_to :user
  belongs_to :group

  def generate_token
    self.token = SecureRandom.hex(10) # 例として10文字のランダムな文字列
  end
end
