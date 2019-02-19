class ComponentController < ApplicationController
  def index
    @components = components
    @categories = categories
  end

  def show
    @component = components.select{ |c| c[:id] == params[:id] }.first
  end
end
