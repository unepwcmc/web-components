class ComponentController < ApplicationController
  def index
    @components = components
  end

  def show
    @component = components.select{ |c| c[:id] == params[:id] }.first
  end
end
