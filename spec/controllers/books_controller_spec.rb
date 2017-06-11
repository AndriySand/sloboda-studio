require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @new_book = FactoryGirl.create(:book, created_at: DateTime.now - 1.day, author_id: @user.id)
    @old_book = FactoryGirl.create(:book, created_at: DateTime.now - 9.day)
    @drafted_book = FactoryGirl.create(:book, status: 'draft')
  end

  describe "GET #index" do
    it "returns books which published less than a week ago" do
      get :index
      expect(response.content_type).to eq("text/html")
      expect(response).to render_template(:index)
      expect(assigns(:books)).to eq([@new_book])
    end
  end

  describe "GET #show" do
    it "returns book" do
      get :show, {id: @new_book.id}
      expect(assigns(:book)).to eq(@new_book)
    end
  end

  describe "GET #new" do
    it "renders 'new' template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "renders 'edit' template" do
      get :edit, {id: @new_book.to_param}
      expect(response).to render_template(:edit)
    end
  end

  let(:valid_attributes) { { title: "Some title here", content: "some text here", description: 'some description', status: 'published' } }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Book" do
        expect {
          post :create, book: valid_attributes
        }.to change(Book, :count).by(1)
      end

      it "assigns a newly created book as @new_book" do
        post :create, book: valid_attributes
        expect(assigns(:book)).to be_a(Book)
        expect(assigns(:book)).to be_persisted
      end

      it "redirects to the created book" do
        post :create, book: valid_attributes
        expect(response).to redirect_to(Book.last)
      end
    end

    describe "with invalid params" do
      it "doesn't create new book" do
        expect{
          post :create, book: valid_attributes.merge({ title: "" })
        }.to_not change(Book, :count)
      end

      it "renders the 'new' template" do
        post :create, book: valid_attributes.merge({ title: "" })
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do

    describe "with valid params" do

      before(:each) do
        put :update, id: @new_book.id, book: valid_attributes
        @new_book.reload
      end

      it "updates the requested book" do
        expect(@new_book.title).to eql valid_attributes[:title]
        expect(@new_book.content).to eql valid_attributes[:content]
      end

      it "redirects to 'show' action" do
        expect(response).to redirect_to(@new_book)
      end

      it "cannot update book of another author" do
        put :update, id: @drafted_book.id, book: valid_attributes
        @drafted_book.reload
        expect(response).to redirect_to(books_path)
        expect(@drafted_book.title).to_not eql valid_attributes[:title]
      end

    end

    describe "with invalid params" do

      before(:each) do
        put :update, id: @new_book.id, book: valid_attributes.merge({ title: "" })
        @new_book.reload
      end

      it "doesn't update requested book" do
        expect(@new_book.title).to_not eql ""
      end

      it "renders template 'edit'" do
        expect(response).to render_template("edit")
      end

    end

  end

  describe "DELETE destroy" do

    it "cannot delete book of another author" do
      expect {
        delete :destroy, {id: @drafted_book.id}
      }.to_not change(Book, :count)
    end

    it "destroys the requested book" do
      expect {
        delete :destroy, {id: @new_book.id}
      }.to change(Book, :count).by(-1)
    end

    it "redirects to books 'index' page" do
      delete :destroy, {id: @new_book.id}
      expect(response).to redirect_to(:books)
    end
  end
end
