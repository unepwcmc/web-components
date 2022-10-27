class StyleguideController < ApplicationController
  def index
    @styleguides = styleguides
  end

  def show; end
end
