class Office < ApplicationRecord
  belongs_to :user

  validates :number, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :category,  presence: true
end
