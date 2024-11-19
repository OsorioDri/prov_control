class Enrollment < ApplicationRecord
  belongs_to :municipality
  belongs_to :provider
end
