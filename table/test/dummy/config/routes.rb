Rails.application.routes.draw do
  mount Table::Engine => "/table"
end
