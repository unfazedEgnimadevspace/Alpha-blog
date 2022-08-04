class Category < ApplicationRecord
    validates :name, presence: true, length: { maximum: 25, minimum: 3}
    validates_uniqueness_of :name
    has_many :article_categories
    has_many :articles, through: :article_categories
end