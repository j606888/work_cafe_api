class TagsController < ApplicationController
  def index
    tags = Tag.all

    render 'index', locals: { tags: tags }
  end
end
