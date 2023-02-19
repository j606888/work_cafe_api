class Admin::TagsController < Admin::ApplicationController
  def index
    tags = TagService::QueryAll.call

    render json: tags
  end

  def create
    Tag.create!(name: params.require(:name))

    head :ok
  end

  def update
    tag = Tag.find_by(id: params.require(:id))
    tag.update!(name: params.require(:name))

    head :ok
  end

  def destroy
    tag = Tag.find_by(id: params.require(:id))
    if tag.store_review_tags.count != 0
      render status: 409, json: { reason: 'Tag are in used' }
    else
      tag.destroy
    end

    head :ok
  end
end
