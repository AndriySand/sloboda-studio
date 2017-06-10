require 'rails_helper'

describe "Users" do

  describe "signup " do

    before(:each) do
      @valid_attributes = {email: 'someone@mail.ua', password: 'password', password_confirmation: 'password', name: 'Peter Pen'}
    end

    describe "failure should not make a new user" do
      it "if email field is empty" do
        expect {
          post '/users', { user: @valid_attributes.merge({email: ''}) }
          expect(response.content_type).to eq("text/html")
          expect(response.body).to include("Email can&#39;t be blank")
        }.to_not change(User, :count)
      end

      it "if name field is empty" do
        expect {
          post '/users', { user: @valid_attributes.merge({name: ''}) }
          expect(response.body).to include("Name can&#39;t be blank")
        }.to_not change(User, :count)
      end

      it "if password field doesn't equal password_confirmation" do
        expect {
          post '/users', { user: @valid_attributes.merge({password_confirmation: 'aaaaaaaa'}) }
          expect(response.body).to include("Password confirmation doesn&#39;t match Password")
        }.to_not change(User, :count)
      end

      it "if email is already taken" do
        user = FactoryGirl.create(:user)
        expect {
          post '/users', { user: @valid_attributes.merge({email: user.email}) }
          expect(response.body).to include("Email has already been taken")
        }.to_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        expect {
          post '/users', { user: @valid_attributes }
          expect(response.content_type).to eq("text/html")
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response).to render_template(:index)
        }.to change(User, :count).by(+1)
      end
    end
  end

  describe "sign in " do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "failure should not sign a user in" do
      it "with wrong email" do
        post '/users/sign_in', { user: {email: 'someone@mail.ua', password: @user.password} }
        expect(response.body).to include("Invalid Email or password.")
        expect(response.content_type).to eq("text/html")
      end

      it "with wrong password" do
        post '/users/sign_in', { user: {email: @user.email, password: 'something'} }
        expect(response.body).to include("Invalid Email or password.")
        expect(response.content_type).to eq("text/html")
      end
    end

    describe "success" do
      it "should sign a user in" do
        post '/users/sign_in', { user: {email: @user.email, password: @user.password} }
        expect(response.content_type).to eq("text/html")
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Signed in successfully')
      end
    end
  end
end