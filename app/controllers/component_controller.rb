class ComponentController < ApplicationController
  include ApplicationHelper

  def index
    @styleguide = styleguides.select { |sg| sg[:id] == styleguide_id }.first
    @components = components.select do |c|
      @styleguide[:component_ids] ? @styleguide[:component_ids].include?(c[:id]) : true
    end

    category_ids = @components.map { |c| c[:category_id] }
    @categories = categories.select { |cat| category_ids.include?(cat[:id]) }
  end

  def show
    @component = components.select { |c| c[:id] == params[:id] }.first
  end
end
