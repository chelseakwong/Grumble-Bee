class Category < ActiveRecord::Base
  has_many :items, dependent: :nullify
  validates :name, uniqueness: true
end