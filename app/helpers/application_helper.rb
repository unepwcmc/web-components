module ApplicationHelper
  def current_uri
    request.env['PATH_INFO']
  end

  def nav_link_class(path)
    link_class = "site-nav__link " 
    link_class += current_uri == path ? "site-nav__link--current" : ''
  end

  def styleguide_class
    "styleguide-#{params[:styleguide] || 'site'}"
  end
end
