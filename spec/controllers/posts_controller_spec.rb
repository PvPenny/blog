require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  
  let(:valid_attributes) {
    {text: 'test_text', published: true, tags: ['test tag 1', 'test tag 2']}
  }

  
  
  before(:context) do
    create_list(:post,10)
  end

  after(:all) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  describe "GET #index" do
    
    it "returns 5 posts" do
      get :index, params: {}
      expect(response).to be_successful
      body = JSON.parse(response.body)
      expect(body.count).to eql 5
    end

    it "order by created_at" do
      get :index, params: {}
      expect(response).to be_successful
      body = JSON.parse(response.body)
      body.each_with_index do |post, index|
        expect(post['date']).to be >= body[index+1]['date'] if body[index+1].present?
      end
    end
    
    it 'return only published posts' do
      create_list(:post, 10, published: false)
      get :index, params: {}
      expect(response).to be_successful
      body = JSON.parse(response.body)
      expect(body.map{|post| post['published']}).to all(be_truthy)
    end

    context 'logged' do
      before do
        @user = User.first
        request.headers.merge!(@user.create_new_auth_token)
      end
      
      it "order by created_at" do
        get :index, params: {user_posts: true}
        expect(response).to be_successful
        body = JSON.parse(response.body)
        body.each do |post|
          expect(post['username']).to eql(@user.nickname)
        end
      end
    end

    end

  describe "GET #show" do
    it "returns a success response" do
      post = Post.last
      get :show, params: {id: post.to_param}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "logged" do
      before do
        @user = User.last
        request.headers.merge!(@user.create_new_auth_token)
      end
      context "with valid params" do
        it "creates a new Post" do
          expect {
            post :create, params: {post: valid_attributes}
          }.to change(Post, :count).by(1)
        end

        it "create tags" do
          expect {
            post :create, params: {post: valid_attributes}
          }.to change(Tag, :count).by(2)
        end
        
        it 'creates post for user' do
          expect {
            post :create, params: {post: valid_attributes}
          }.to change(@user.posts, :count).by(1)
        end
        
        it "renders a JSON response with the new post" do
      
          post :create, params: {post: valid_attributes}
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(post_url(Post.last))
        end
      end
  
      context "with invalid params" do
        let(:invalid_attributes) {
          {text: nil, published: true}
        }
        
        it "renders a JSON response with errors for the new post" do
      
          post :create, params: {post: invalid_attributes}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end
    
    context "unlogged" do
      it "return unauth error" do
        post :create, params: {post: valid_attributes}
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "PUT #update" do
    
    context "logged" do
      before do
        @user = create(:user)
        request.headers.merge!(@user.create_new_auth_token)
      end
      context "with valid params" do
        let(:new_attributes) {
          {text: 'some new text'}
        }
        it "updates the requested post" do
          post = create(:post, user_id: @user.id)
          put :update, params: {id: post.to_param, post: new_attributes}
          post.reload
          expect(post.text).to eq new_attributes[:text]
        end
  
        it "renders a JSON response with the post" do
          post = create(:post, user_id: @user.id)
          put :update, params: {id: post.to_param, post: valid_attributes}
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
        
        it 'raise error when updating not own post' do
          expect{
            put :update, params: {id: Post.first.id, post: valid_attributes}
          }.to raise_error
        end
      end

    
      context "with invalid params" do
        let(:invalid_attributes) {
          {text: nil, published: true}
        }
        it "renders a JSON response with errors for the post" do
          post = create(:post, user_id: @user.id)
          put :update, params: {id: post.to_param, post: invalid_attributes}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end


    context "unlogged" do
      it 'return auth error' do
        put :update, params: {id: Post.last.id}
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "DELETE #destroy" do
    context "logged" do
      
      before do
        @user = create(:user)
        request.headers.merge!(@user.create_new_auth_token)
      end
      
      it "destroys the requested post" do
        post = create(:post, user_id: @user.id)
        expect {
          delete :destroy, params: {id: post.to_param}
        }.to change(Post, :count).by(-1)
      end

      it "raise error when delete not own post" do
        expect{
          delete :destroy, params: {id: Post.first.id, post: valid_attributes}
        }.to raise_error
      end
      
    end
    context "unlogged" do
      it 'return auth_error' do
        delete :destroy, params: {id: Post.first.to_param}
        expect(response).to have_http_status(401)
      end
    end
  end

end
