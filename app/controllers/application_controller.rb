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
        category_id: 'carousels'
      },
      {
        id: 'chart_area',
        name: 'ChartArea',
        category_id: 'charts'
      },
      {
        id: 'chart_column',
        name: 'ChartColumn',
        category_id: 'charts'
      },
      {
        id: 'chart_line',
        name: 'ChartLine',
        category_id: 'charts'
      },
      {
        id: 'chart_row_stacked',
        name: 'ChartRowStacked',
        category_id: 'charts'
      },
      {
        id: 'chart_row',
        name: 'ChartRow',
        category_id: 'charts'
      },
      {
        id: 'expandable_item',
        name: 'ExpandableItem',
        category_id: 'dropdowns'
      },
      {
        id: 'modal',
        name: 'Modal',
        category_id: 'modals'
      },
      {
        id: 'v_nav',
        name: 'VNav',
        category_id: 'navs'
      },
      {
        id: 'sticky_bar',
        name: 'StickyBar',
        category_id: 'navs'
      },
      {
        id: 'tabs',
        name: 'Tabs',
        category_id: 'tabs'
      },
      {
        id: 'tooltip',
        name: 'Tooltip',
        category_id: 'tooltips'
      },
      {
        id: 'v_select',
        name: 'VSelect',
        category_id: 'forms'
      },
      {
        id: 'v_form',
        name: 'VForm',
        category_id: 'forms'
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
