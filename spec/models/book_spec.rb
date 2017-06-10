require 'rails_helper'

RSpec.describe Book, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:book)).to be_valid
  end

  it "is invalid without a title" do
    expect(FactoryGirl.build(:book, title: "")).to_not be_valid
  end

  it "is invalid without a content" do
    expect(FactoryGirl.build(:book, content: "")).to_not be_valid
  end

  it "is invalid without a author_id" do
    expect(FactoryGirl.build(:book, author_id: nil)).to_not be_valid
  end

  it "is invalid without a description" do
    expect(FactoryGirl.build(:book, description: '')).to_not be_valid
  end

  it "displays its genres names" do
    book = FactoryGirl.create(:book)
    genre1 = FactoryGirl.create(:genre)
    genre2 = FactoryGirl.create(:genre)
    book.genres << genre1 << genre2
    expect(book.genre_names).to eq("#{genre1.name}, " + genre2.name)
  end

  it "is sorted by date creation" do
    new_book = FactoryGirl.create(:book, created_at: DateTime.now)
    old_book = FactoryGirl.create(:book, created_at: DateTime.now - 10.days)
    expect(Book.recent).to eq([new_book])
  end

  it "is sorted by status" do
    published_book = FactoryGirl.create(:book, status: 'published')
    drafted_book = FactoryGirl.create(:book, status: 'draft')
    expect(Book.not_drafted).to eq([published_book])
  end

end
