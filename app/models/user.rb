class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  validates :name, presence: true
end
