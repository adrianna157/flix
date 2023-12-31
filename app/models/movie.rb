class Movie < ApplicationRecord

  before_save :set_slug
  RATINGS = %w(G PG PG-13 R NC-17)

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  has_one_attached :main_image


  validates :title, :released_on, :description, presence: true, uniqueness: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0}
  # validates :image_file_name, format: {
  #   with: /\w+\.(jpg|png)\z/i,
  #   message: "must be a JPG or PNG image"
  # }
  validates :rating, inclusion: { in: RATINGS}
  validate :acceptable_image

  scope :upcoming, -> {where("released_on > ?", Time.now).order(released_on: :desc)}
  scope :released, -> { where("released_on < ?", Time.now).order(released_on: :desc)}
  scope :recent, -> (max=2) { released.limit(max)}
  scope :hits, -> { released.where("total_gross >= 300000000").order(total_gross: :desc)}
  scope :flops, -> { released.where("total_gross < 225000000").order(total_gross: :asc)}


  def flop?
    unless (reviews.count > 50 && average_stars >= 4)
      (total_gross.blank? || total_gross < 225_000_000)
    end
  end

  def average_stars_as_percent
    (self.average_stars / 5.0) * 100
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = title.parameterize
  end

  def acceptable_image
    return unless main_image.attached?

      unless main_image.byte_size <= 10.megabyte
        errors.add(:main_image, "is too big")
      end

      acceptable_types = ["image/jpeg", "image/png"]
      unless acceptable_types.include?(main_image.content_type)
        errors.add(:main_image, "must be a JPEG or PNG")
      end
  end
end
