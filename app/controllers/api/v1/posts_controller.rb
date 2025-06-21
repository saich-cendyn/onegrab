module Api
  module V1
    class PostsController < Api::ApiController
      def index
        pagy, posts = pagy(Post.all)
        render json: {
            posts: PostSerializer.new(posts).serializable_hash,
            pagy: pagy_metadata(pagy)
        }
      end
    end
  end
end
