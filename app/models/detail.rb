class Detail < ApplicationRecord
  belongs_to :associated_with, polymorphic: true
end
