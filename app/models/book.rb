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
  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ":style/missing.jpg",
    storage: :s3,
    s3_credentials: {
      bucket: ENV.fetch('S3_BUCKET_NAME'),
      access_key_id: ENV.fetch('ACCESS_KEY'),
      secret_access_key: ENV.fetch('SECRET_ACCESS_KEY'),
      s3_region: ENV.fetch('S3_REGION'),
    }
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
end
