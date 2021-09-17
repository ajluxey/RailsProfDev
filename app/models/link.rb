class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url,  presence: true,
                   format: URI::regexp(%w[http https])
end
