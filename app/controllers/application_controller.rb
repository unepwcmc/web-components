class ApplicationController < ActionController::Base
  def styleguides
    [
      {
        id: 'example',
        name: 'Example',
        component_ids: [
          'carousel'
        ]
      },
      {
        id: 'site',
        name: 'Styleguide Site'
      }
    ]
  end

  def components
    [
      {
        id: 'accordion',
        name: 'Accordion',
        category_id: 'accordions'
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
        category_id: 'selects'
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
      {
        id: 'selects',
        name: 'Selects'
      },
      {
        id: 'maps',
        name: 'Maps'
      },
    ]
  end
end
