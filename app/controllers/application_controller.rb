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
      abnj: 'ABNJ Deep Seas',
      dar: 'Digital Annual Review',
      tradeview: 'TradeView',
      encore: 'ENCORE',
      gofox: 'GO-FOX',
      ibat: 'IBAT',
      naturemap: 'Nature Map Explorer',
      ocean_plus_habitats: 'Ocean+ Habitats',
      ocean_plus_library: 'Ocean+ Library',
      pp: 'Protected Planet',
      pp_live_report: 'Protected Planet Live Report',
      style_guide: 'Style Guide',
    }
  end

  def components
    [
      {
        id: 'accordion',
        name: 'Accordion',
        category_id: 'accordions',
        description: 'A list of items that expand/shrink on selection/deselection.',
        projects: [
          projects[:encore], 
          projects[:gofox],
          projects[:ibat], 
          projects[:naturemap], 
          projects[:ocean_plus_library], 
      ]
      },
      {
        id: 'carousel',
        name: 'Carousel',
        category_id: 'carousels',
        projects: [
          projects[:abnj],
          projects[:dar],
          projects[:pp], 
        ]
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
        projects: [
          projects[:pp_live_report],
          projects[:tradeview]
        ]
      },
      {
        id: 'chart_line',
        name: 'ChartLine',
        category_id: 'charts',
        projects: [
          projects[:dar],
          projects[:pp],
          projects[:pp_live_report],
          projects[:tradeview],
        ]
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
        projects: [
          projects[:abnj],
          projects[:encore], 
          projects[:style_guide],
        ]
      },
      {
        id: 'fake_tabs',
        name: 'FakeTabs',
        category_id: 'tabs',
        projects: [
          projects[:tradeview],
        ]
      },
      {
        id: 'modal',
        name: 'Modal',
        category_id: 'modals',
        projects: [
          projects[:dar],
          projects[:ibat], 
          projects[:naturemap],
        ]
      },
      {
        id: 'v_nav',
        name: 'VNav',
        category_id: 'navs',
        projects: [
          projects[:abnj],
          projects[:dar],
          projects[:encore],
        ]
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
        projects: [
          projects[:encore],
          projects[:ibat],
          projects[:ocean_plus_habitats]
        ]
      },
      {
        id: 'toggle',
        name: 'Toggle',
        category_id: 'utilities',
        projects: [projects[:naturemap]]
      },
      {
        id: 'tooltip',
        name: 'Tooltip',
        category_id: 'tooltips',
        projects: [
          projects[:encore],
          projects[:ibat],
          projects[:naturemap],
          projects[:tradeview]
        ]
      },
      {
        id: 'v_select',
        name: 'VSelect',
        category_id: 'forms',
        projects: [
          projects[:encore],
          projects[:gofox], 
          projects[:naturemap],
          projects[:pp],
          projects[:tradeview],
        ]
      },
      {
        id: 'v_form',
        name: 'VForm',
        category_id: 'forms',
        projects: [
          projects[:encore],
          projects[:ocean_plus_library],
        ]
      },
      {
        id: 'v_map',
        name: 'VMap',
        category_id: 'maps',
        projects: [
          projects[:encore],
          projects[:naturemap],
          projects[:ocean_plus_library],
        ]
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
      {
        id: 'utilities',
        name: 'Utilities'
      }
    ]
  end
end
