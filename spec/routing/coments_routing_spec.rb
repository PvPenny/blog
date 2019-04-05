require "rails_helper"

RSpec.describe PostsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/posts/1/coment").to route_to("coment#index", post_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/posts/1/coment/1").not_to be_routable
    end


    it "routes to #create" do
      expect(:post => "/posts/1/coment").to route_to("coment#create", post_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/posts/1/coment/1").to route_to("coment#update", post_id: '1', id: "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/posts/1/coment/1").to route_to("coment#update", post_id: '1', id: "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/posts/1/coment/1").to route_to("coment#destroy", post_id: '1', id: "1")
    end
  end
end
