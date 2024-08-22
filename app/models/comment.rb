class Comment < ApplicationRecord
  belongs_to :created_by,  class_name: 'User'
  belongs_to :associated_with, polymorphic: true
  acts_as_tenant :hospital
  validates :description, presence: { message: "can't be empty" }
  validates :created_by_id, presence: true
end
