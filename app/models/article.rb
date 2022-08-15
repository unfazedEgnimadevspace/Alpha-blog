class Article < ApplicationRecord
    belongs_to :user
    has_one_attached :image
    has_many :article_categories
    has_many :categories, through: :article_categories
    validates :title, presence: true, length: { minimum: 6, maximum: 50 }
    validates :description, presence: true, length: { minimum: 3, maximum: 300 }
    validates :image, content_type: { in: %w[image/jpeg, image/jpg, image/png], message: "Must be a valid image type" },
                      size:         { less_than: 5.megabytes, message: "Image file is too big"} 
    
    def display_image
        image.variant(resize_to_limit: [300, 500])
    end    
end