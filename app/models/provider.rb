class Provider < ApplicationRecord
  has_many :phones, as: :callable, dependent: :destroy
  has_many :emails, as: :emailable, dependent: :destroy
  has_many :enrollments
  has_many :municipalities, through: :enrollments
end
