require 'rails_helper'

RSpec.describe ComentController, type: :controller do
  
  let(:valid_data) do
    {text: 'some_comment'}
  end
  
  let(:invalid_data) do
    {text: nil}
  end
  
  before do
    @comment = create(:coment)
    @post = @comment.post
  end

  after(:all) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  describe "GET #index" do
    it "returns http success" do
      get :index, params: {post_id: @post.id}
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body).to be_an(Array)
    end
  end
  
  describe "POST #create" do
    context "logged" do
      
      before do
        request.headers.merge!(@comment.user.create_new_auth_token)
      end
      
      context "valid_data" do
        it "returns http success" do
          get :create, params: {post_id: @post.id, comment: valid_data}
          expect(response).to have_http_status(:success)
        end

        it "create new comment" do
          expect{
            get :create, params: {post_id: @post.id, comment: valid_data}
          }.to change(@post.coments, :count).by(1)
        end
      end
     context "unvalid data" do
       it 'return 422 error' do
         get :create, params: {post_id: @post.id, comment: invalid_data}
         expect(response).to have_http_status(:unprocessable_entity)
       end
     end
    end
    
    context "unlogged" do
      it "returns http unauth" do
        get :create, params: {post_id: @post.id, text: 'text'}
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "PUT #update" do
    let(:new_valid_data) do
      {text: 'some new comment text'}
    end
    
    before do
      @new_comment = create(:coment, post_id: @post.id)
    end
    context "own comment" do
      before do
        @new_comment = create(:coment, post_id: @post.id)
        @user = @new_comment.user
        request.headers.merge!(@user.create_new_auth_token)
      end
      
      it "returns http success if create_time < 15 min" do
        put :update, params: {post_id: @new_comment.post.id, id: @new_comment.to_param, comment: new_valid_data}
        expect(response).to have_http_status(:success)
      end

      it "change comment text if create_time < 15 min" do
        put :update, params: {post_id: @new_comment.post.id, id: @new_comment.to_param, comment: new_valid_data}
        expect(response).to have_http_status(:success)
        @new_comment.reload
        expect(@new_comment.text).to eq new_valid_data[:text]
      end

      it "returns http error if create_time > 15 min" do
        @new_comment.update(created_at: (DateTime.now - 16.minutes))
        put :update, params: {post_id: @new_comment.post.id, id: @new_comment.to_param, comment: new_valid_data}
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "not changing user_id" do
        user = create(:user)
        put :update, params: {post_id: @new_comment.post.id, id: @new_comment.to_param, comment: new_valid_data.merge!(user_id: user.id)}
        expect(response).to have_http_status(:success)
        @new_comment.reload
        expect(@new_comment.user).not_to be(@user)
      end
    end
   
    context "not own comment" do
      
      before do
        user = create(:user)
        request.headers.merge!(user.create_new_auth_token)
      end
      
      it "returns http error" do
        expect{
          put :update, params: {post_id: @post.id, id: @new_comment.to_param, comment: new_valid_data}
        }.to raise_error
      end
    end
    
    context "unlogged" do
      it "returns http unauth" do
        put :update, params: {post_id: @post.id, id: @new_comment.to_param, text: 'some_text'}
        expect(response).to have_http_status(401)
      end
    end
  end
  
  describe "DELETE #destroy" do
    before do
      @new_comment = create(:coment, post_id: @post.id)
    end
    context "logged" do
      context "logged by owner" do
        
        before do
          request.headers.merge!(@new_comment.user.create_new_auth_token)
        end
        
        it "returns http success if created at < 15 min" do
          delete :destroy, params: {post_id: @post.id, id: @new_comment.to_param}
          expect(response).to have_http_status(:success)
        end

        it "delete comment" do
          expect{
            delete :destroy, params: {post_id: @post.id, id: @new_comment.to_param}
          }.to change(@post.coments, :count).by(-1)
        end

        it "returns http error if created at > 15 min" do
          @new_comment.update!(created_at: (DateTime.now-16.minutes))
          delete :destroy, params: {post_id: @post.id, id: @new_comment.to_param}
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
      
      context "logged not by owner" do
        before do
          user = create(:user)
          request.headers.merge!(user.create_new_auth_token)
        end

        it "returns http error" do
          expect{
            delete :destroy, params: {post_id: @post.id, id: @new_comment.to_param}
          }.to raise_error
        end
      end
    end
    
    context "unlogged" do
      it "returns http unauth" do
        delete :destroy, params: {post_id: @post.id, id: @new_comment.id}
        expect(response).to have_http_status(401)
      end
    end
  end
end
