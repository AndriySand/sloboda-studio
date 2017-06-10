class Genre < ActiveRecord::Base
  TYPES = %w(Fiction Comedy Drama Horror Non-fiction Realistic Romantic Satire Tragedy Tragicomedy Fantasy Mythology)
  has_and_belongs_to_many :books
  validates :name, inclusion: { in: TYPES }
end
