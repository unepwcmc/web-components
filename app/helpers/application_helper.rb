module ApplicationHelper
  def current_uri
    request.env['PATH_INFO']
  end

  def nav_link_class(path)
    link_class = "nav__link " 
    link_class += current_uri == path ? "nav__link--current" : ''
  end
end
