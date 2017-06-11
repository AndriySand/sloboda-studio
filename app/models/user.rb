class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :books, foreign_key: 'author_id', dependent: :destroy
  validates :name, presence: true
end
