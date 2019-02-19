class ApplicationController < ActionController::Base
  def components
    [
      {
        id: 'accordion',
        name: 'Accordion'
      },
      {
        id: 'carousel',
        name: 'Carousel'
      },
      {
        id: 'chart_area',
        name: 'ChartArea'
      },
      {
        id: 'chart_column',
        name: 'ChartColumn'
      },
      {
        id: 'chart_line',
        name: 'ChartLine'
      },
      {
        id: 'chart_row_stacked',
        name: 'ChartRowStacked'
      },
      {
        id: 'chart_row',
        name: 'ChartRow'
      },
      {
        id: 'expandable_item',
        name: 'ExpandableItem'
      },
      {
        id: 'modal',
        name: 'Modal'
      },
      {
        id: 'v_nav',
        name: 'VNav'
      },
      {
        id: 'sticky_bar',
        name: 'StickyBar'
      },
      {
        id: 'tabs',
        name: 'Tabs'
      },
      {
        id: 'tooltip',
        name: 'Tooltip'
      },
      {
        id: 'v_select',
        name: 'VSelect'
      },
      {
        id: 'v_map',
        name: 'VMap'
      },
    ]
  end
end
