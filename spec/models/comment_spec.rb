# require 'rails_helper'

# RSpec.describe Comment, type: :model do

#   context 'associations' do
#     it { should belong_to(:created_by).class_name('User') }
#     it { should belong_to(:associated_with) }
#   end

#   context 'validations' do
#     it { should validate_presence_of(:description).with_message("can't be empty") }
#     it { should validate_presence_of(:created_by_id) }
#   end

#   context 'valid comment' do
#     let(:user) { create(:user) }
#     let(:medical_record) { create(:medical_record) }

#     it 'is valid with valid attributes' do
#       comment = create(:comment, created_by: user, associated_with: medical_record)
#       expect(comment).to be_valid
#     end

#     it 'is not valid without a description' do
#       comment = build(:comment, description: nil, created_by: user, associated_with: medical_record)
#       expect(comment).not_to be_valid
#       expect(comment.errors[:description]).to include("can't be empty")
#     end

#     it 'is not valid without a created_by user' do
#       comment = build(:comment, created_by: nil, associated_with: medical_record)
#       expect(comment).not_to be_valid
#       expect(comment.errors[:created_by_id]).to include("can't be blank")
#     end

#     it 'is valid with a polymorphic associated_with association' do
#       comment = create(:comment, created_by: user, associated_with: medical_record)
#       expect(comment).to be_valid
#     end
#   end
# end


# spec/models/comment_spec.rb
require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    ActsAsTenant.current_tenant = hospital
  end
  let!(:hospital) { create(:hospital) }
  let(:user) { create(:user) }
  let(:medical_record) { create(:medical_record) }
  
  context 'validations' do
    it 'is valid with valid attributes' do
      comment = build(:comment, created_by: user, associated_with: medical_record,hospital: hospital)
      expect(comment).to be_valid
    end

    it 'is invalid without a description' do
      comment = build(:comment, description: nil, created_by: user, associated_with: medical_record,hospital: hospital)
      expect(comment).not_to be_valid
      expect(comment.errors[:description]).to include("can't be empty")
    end

    it 'is invalid without a created_by_id' do
      comment = build(:comment, created_by: nil, associated_with: medical_record,hospital: hospital)
      expect(comment).not_to be_valid
      expect(comment.errors[:created_by_id]).to include("can't be blank")
    end
  end
end
