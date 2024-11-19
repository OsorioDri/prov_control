class Municipality < ApplicationRecord
  belongs_to :state, optional: false
  belongs_to :batch, optional: true
  belongs_to :user, optional: true
  has_many :phones, as: :callable
  has_many :emails, as: :emailable
  has_many :enrollments
  has_many :providers, through: :enrollments
end
