class Attendance < ApplicationRecord
  belongs_to :user
  has_many :logapplies, dependent: :destroy
  # accepts_nested_attributes_for :logapplies
  accepts_nested_attributes_for :logapplies, allow_destroy: true

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  


  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 退社時間が存在しない場合、出勤時間は無効
  validate :started_at_is_invalid_without_a_finished_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid

  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_is_invalid_without_a_finished_at
    errors.add(:finished_at, "が必要です") if (Date.current > worked_on) && started_at.present? && finished_at.blank?  
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end

  # def self.search(year_month)
    # byebug
    # @attendance = Attendance.where("worked_on LIKE?", "#{year_month}%")
  #   # @attendance.where(worked_on: search.beginning_of_month..search.end_of_month)
  # year_month.beginning_of_month..year_month.end_of_month
  # end
end
