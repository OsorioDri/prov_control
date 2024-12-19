class Municipality < ApplicationRecord
  belongs_to :state, optional: false
  belongs_to :batch, optional: true
  belongs_to :user, optional: true
  has_many :phones, as: :callable
  has_many :emails, as: :emailable
  has_many :enrollments, dependent: :restrict_with_error
  has_many :providers, through: :enrollments

  before_destroy :check_enrollments

  def check_enrollments
    if enrollments.exists?
      errors.add(:base, 'Não é possível deletar um município com enrollments')
      throw(:abort)
    end
  end
end
