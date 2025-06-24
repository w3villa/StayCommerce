module Stay
  module Api
    module V1
      class CommentsController < ApplicationController
        before_action :set_comment, only: [:show, :update, :destroy]

        # GET /stay/api/v1/comments
        def index
          comments = Comment.where(parent_id: nil).includes(replies: :replies)
          render json: comments.as_json(include: nested_replies), status: :ok
        end

        # GET /stay/api/v1/comments/:id
        def show
          render json: @comment.as_json(include: nested_replies), status: :ok
        end

        # POST /stay/api/v1/comments
        def create
          comment = Comment.new(comment_params)
          if comment.save
            render json: comment, status: :created
          else
            render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PATCH/PUT /stay/api/v1/comments/:id
        def update
          if @comment.update(comment_params)
            render json: @comment, status: :ok
          else
            render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /stay/api/v1/comments/:id
        def destroy
          @comment.destroy
          head :no_content
        end

        private

        def set_comment
          @comment = Comment.find_by(id: params[:id])
          return render json: { error: "Comment not found" }, status: :not_found unless @comment
        end

        def comment_params
          params.require(:comment).permit(:name, :email, :content, :parent_id)
        end

        def nested_replies
          { replies: { include: { replies: { include: :replies } } } }
        end
      end
    end
  end
end
