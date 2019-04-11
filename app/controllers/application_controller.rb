class ApplicationController < ActionController::Base
  def components
    [
      {
        id: 'accordion',
        name: 'Accordion',
        category_id: 'accordions',
        description: 'A list of items that expand/shrink on selection/deselection.',
        projects: ['ENCORE', 'IBAT']
      },
      {
        id: 'carousel',
        name: 'Carousel',
        category_id: 'carousels',
        projects: ['Protected Planet']
      },
      {
        id: 'chart_area',
        name: 'ChartArea',
        category_id: 'charts',
        projects: ['Protected Planet Live Report']
      },
      {
        id: 'chart_column',
        name: 'ChartColumn',
        category_id: 'charts',
        projects: ['Protected Planet Live Report']
      },
      {
        id: 'chart_line',
        name: 'ChartLine',
        category_id: 'charts',
        projects: ['Protected Planet Live Report']
      },
      {
        id: 'chart_row_stacked',
        name: 'ChartRowStacked',
        category_id: 'charts',
        projects: ['Protected Planet Live Report']
      },
      {
        id: 'chart_row',
        name: 'ChartRow',
        category_id: 'charts',
        projects: ['Protected Planet Live Report']
      },
      {
        id: 'expandable_item',
        name: 'ExpandableItem',
        category_id: 'dropdowns',
        projects: ['ENCORE', 'Style Guide']
      },
      {
        id: 'modal',
        name: 'Modal',
        category_id: 'modals'
      },
      {
        id: 'v_nav',
        name: 'VNav',
        category_id: 'navs',
        projects: ['ENCORE']
      },
      {
        id: 'sticky_bar',
        name: 'StickyBar',
        category_id: 'navs',
        project: ['ENCORE']
      },
      {
        id: 'tabs',
        name: 'Tabs',
        category_id: 'tabs',
        project: ['ENCORE', 'Ocean+ Habitats']
      },
      {
        id: 'tooltip',
        name: 'Tooltip',
        category_id: 'tooltips',
        project: ['ENCORE']
      },
      {
        id: 'v_select',
        name: 'VSelect',
        category_id: 'forms',
        project: ['ENCORE', 'GO-FOX']
      },
      {
        id: 'v_form',
        name: 'VForm',
        category_id: 'forms',
        projects: ['Ocean+ Library']
      },
      {
        id: 'v_map',
        name: 'VMap',
        category_id: 'maps'
      },
    ]
  end

  def categories
    [
      {
        id: 'accordions',
        name: 'Accordions'
      },
      {
        id: 'carousels',
        name: 'Carousels'
      },
      {
        id: 'charts',
        name: 'Charts'
      },
      {
        id: 'dropdowns',
        name: 'Dropdowns'
      },
      {
        id: 'forms',
        name: 'Forms'
      },
      {
        id: 'maps',
        name: 'Maps'
      },
      {
        id: 'modals',
        name: 'Modals'
      },
      {
        id: 'navs',
        name: 'Navs'
      },
      {
        id: 'tabs',
        name: 'Tabs'
      },
      {
        id: 'tooltips',
        name: 'Tooltips'
      },
    ]
  end
end
