class Item < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  belongs_to :category
  # has_many :votes, as: :votable
  has_many :comments, class_name: "ItemComment"

  validates :title, presence: true, length: { maximum: 250 }, allow_blank: false, allow_nil: false
  validates :category, presence: true, allow_blank: false, allow_nil: false
  validates :id, uniqueness: true

  validate do
    if category_id.blank?
      errors.add(:category_id, 'Select a category')
    end
    # if content.blank? && url.blank?
    #   errors.add(:url, 'Submit a URL or Content')
    # end
    # if content.present? && url.present?
    #   errors.add(:url, 'Submit a URL or Content but not Both.')
    # end
  end

  # validates :url, url: {allow_nil: true, allow_blank: true}

  def score_votes
    self.get_upvotes.size - self.get_downvotes.size
  end

  scope :active, -> { where(disabled: false) }
  scope :disabled, -> { where(disabled: true) }
  scope :newest, -> { order(score: :desc) }
end
