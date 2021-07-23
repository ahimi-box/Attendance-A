class Approval < ApplicationRecord
  belongs_to :attendance,optional: true

  validates :month_superior, presence: true
  # validates :checkbox, acceptance: true

end
