require 'rails_helper'

RSpec.describe Book, type: :model do
  it 'has a valid factory' do
    expect(build(:book)).to be_valid
  end

  describe 'validations' do
    context "when title is nil" do
      it "is invalid" do
        book = build(:book, title: nil)

        expect(book).not_to be_valid  
      end
    end

    context "when title is an empty string" do
      it "is invalid" do
        book = build(:book, title: '')

        expect(book).not_to be_valid
      end
    end   
  end
end
