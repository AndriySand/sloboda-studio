class Book < ActiveRecord::Base
  STATUSES = %w(published unpublished draft editing)
  belongs_to :author, class_name: 'User'
  has_and_belongs_to_many :genres
  validates :title, :author_id, :description, :content, presence: true
  validates :status, inclusion: { in: STATUSES }
  paginates_per 15

  def genre_names
    genres.map(&:name).join(', ')
  end

  scope :recent, -> { where('created_at > ?', 1.week.ago) }
  scope :not_drafted, -> { where('status <> ?', 'draft') }
end
