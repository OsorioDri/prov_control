class Phone < ApplicationRecord
  belongs_to :callable, polymorphic: true
end
