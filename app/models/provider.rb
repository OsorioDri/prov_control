class Provider < ApplicationRecord
  has_many :phones, as: :callable
  has_many :emails, as: :emailable
  has_many :enrollments
  has_many :municipalities, through: :enrollments
end
