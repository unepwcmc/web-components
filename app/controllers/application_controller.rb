class ApplicationController < ActionController::Base
  def styleguides
    [
      {
        id: 'example-project',
        name: 'Example',
        component_ids: [
          'carousel'
        ]
      },
      {
        id: 'component-library',
        name: 'Component Library'
      }
    ]
  end

  def projects
    {
      encore: 'ENCORE',
      gofox: 'GO-FOX',
      ibat: 'IBAT',
      pp: 'Protected Planet',
      pp_live_report: 'Protected Planet Live Report',
      style_guide: 'Style Guide',
      ocean_plus_habitats: 'Ocean+ Habitats',
      ocean_plus_library: 'Ocean+ Library'
    }
  end

  def components
    [
      {
        id: 'accordion',
        name: 'Accordion',
        category_id: 'accordions',
        description: 'A list of items that expand/shrink on selection/deselection.',
        projects: [projects[:encore], projects[:ibat]]
      },
      {
        id: 'carousel',
        name: 'Carousel',
        category_id: 'carousels',
        projects: [projects[:pp]]
      },
      {
        id: 'chart_area',
        name: 'ChartArea',
        category_id: 'charts',
        projects: [projects[:pp_live_report]]
      },
      {
        id: 'chart_column',
        name: 'ChartColumn',
        category_id: 'charts',
        projects: [projects[:pp_live_report]]
      },
      {
        id: 'chart_line',
        name: 'ChartLine',
        category_id: 'charts',
        projects: [projects[:pp_live_report]]
      },
      {
        id: 'chart_row_stacked',
        name: 'ChartRowStacked',
        category_id: 'charts',
        projects: [projects[:pp_live_report]]
      },
      {
        id: 'chart_row',
        name: 'ChartRow',
        category_id: 'charts',
        projects: [projects[:pp_live_report]]
      },
      {
        id: 'expandable_item',
        name: 'ExpandableItem',
        category_id: 'dropdowns',
        projects: [projects[:encore], projects[:style_guide]]
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
        projects: [projects[:encore]]
      },
      {
        id: 'sticky_bar',
        name: 'StickyBar',
        category_id: 'navs',
        projects: [projects[:encore]]
      },
      {
        id: 'tabs',
        name: 'Tabs',
        category_id: 'tabs',
        projects: [projects[:encore], projects[:ocean_plus_habitats]]
      },
      {
        id: 'tooltip',
        name: 'Tooltip',
        category_id: 'tooltips',
        projects: [projects[:encore]]
      },
      {
        id: 'v_select',
        name: 'VSelect',
        category_id: 'forms',
        projects: [projects[:encore], projects[:gofox], projects[:pp]]
      },
      {
        id: 'v_form',
        name: 'VForm',
        category_id: 'forms',
        projects: [projects[:ocean_plus_library]]
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
