/* eslint-disable no-undef */

import Accordion from '../Accordion.vue'
import AccordionItem from '../AccordionItem.vue'
import TestHelpers from '../../../utils/vue-test-helpers'
import PageHelpers from './test-helpers'

const helpers = new TestHelpers(PageHelpers)

describe('Accordion', () => {
  const ACCORDION_ITEM = '<div class="accordion-item"></div>'
  const ACCORDION_ITEM_TEXT = 'Accordion Item Content'
  const ACCORDION_ITEM_HTML_CONTENT = `<div class="accordion-item__slot-content">${ACCORDION_ITEM_TEXT}</div>`

  beforeEach(() => {
    AccordionItem._Ctor = null //FIXME: not a good solution... needs more work!
  })

  test('renders multiple accordion items using slots', () => {
    const wrapper = helpers.shallowInitializeWrapper(Accordion, {
      slots: {
        default: [ACCORDION_ITEM, ACCORDION_ITEM]
      }
    })

    expect(wrapper.accordionItems()).toHaveLength(2)
  })

  test('renders accordion item child in accordion-item__content div', () => {
    const wrapper = helpers.shallowInitializeWrapper(AccordionItem, {
      propsData: {
        id: '1'
      },
      slots: {
        default: [ACCORDION_ITEM_HTML_CONTENT]
      }
    })

    expect(wrapper.itemContent().contains('div')).toBe(true)
    expect(
      wrapper
        .itemContent()
        .find('div')
        .text()
    ).toBe(ACCORDION_ITEM_TEXT)
  }),
  test('renders accordion item child in accordion-item__content div', () => {
    const wrapper = helpers.shallowInitializeWrapper(AccordionItem, {
      propsData: {
        id: '1'
      },
      slots: {
        default: [ACCORDION_ITEM_HTML_CONTENT]
      }
    })

    expect(wrapper.itemContent().contains('div')).toBe(true)
    expect(
      wrapper
        .itemContent()
        .find('div')
        .text()
    ).toBe('Accordion Item Content')
  }),
  test('renders the accordion item title when given as a prop', () => {
    const wrapper = helpers.shallowInitializeWrapper(AccordionItem, {
      propsData: {
        id: '1',
        title: 'Test title'
      }
    })

    expect(wrapper.itemTitleText()).toBe('Test title')
  })

  test('initially does not show the accordion item content', () => {
    const wrapper = helpers.initializeWrapper(Accordion, {
      scopedSlots: {
        default: function() {
          return this.$createElement(AccordionItem, {
            props: {
              id: '1'
            }
          })
        }
      }
    })

    expect(wrapper.itemContentWrapper().isVisible()).toBe(false)
  })

  test('toggles accordion item content when clicking on the item toggle', () => {
    const wrapper = helpers.initializeWrapper(Accordion, {
      scopedSlots: {
        default: function() {
          return this.$createElement(AccordionItem, {
            props: {
              id: '1'
            }
          })
        }
      }
    })

    expect(wrapper.itemContentWrapper().isVisible()).toBe(false)

    wrapper.toggleItem()

    expect(wrapper.itemContentWrapper().isVisible()).toBe(true)
  })

  test('initially shows accordion item content if open prop is true', () => {
    const wrapper = helpers.initializeWrapper(Accordion, {
      scopedSlots: {
        default: function() {
          return this.$createElement(AccordionItem, {
            props: {
              id: '1',
              open: true
            }
          })
        }
      }
    })

    expect(wrapper.itemContentWrapper().isVisible()).toBe(true)
  })

  test('hides accordion item content when clicking on an active item toggle', () => {
    const wrapper = helpers.initializeWrapper(Accordion, {
      scopedSlots: {
        default: function() {
          return this.$createElement(AccordionItem, {
            props: {
              id: '1',
              open: true
            }
          })
        }
      }
    })

    wrapper.toggleItem()

    expect(wrapper.itemContentWrapper().isVisible()).toBe(false)
  })

  test('shows inactive accordion toggle icon when accordion is inactive', () => {
    const wrapper = helpers.initializeWrapper(Accordion, {
      scopedSlots: {
        default: function() {
          return this.$createElement(AccordionItem, {
            props: {
              id: '1'
            }
          })
        }
      }
    })

    expect(wrapper.itemToggleIcon().text()).toBe('+')
  })

  test('shows active accordion toggle icon when accordion is toggled open', () => {
    const wrapper = helpers.initializeWrapper(Accordion, {
      scopedSlots: {
        default: function() {
          return this.$createElement(AccordionItem, {
            props: {
              id: '1'
            }
          })
        }
      }
    })

    wrapper.toggleItem()

    expect(wrapper.itemToggleIcon().text()).toBe('-')
  });

  //FIXME: can't seem to find a way of adding multiple custom components as slots with props.
  // scopedSlots doesn't take arrays and slots doesn't take a function using $createElement
  [
    {
      description:
        'correctly handles toggling when switching between accordion items when one item is open',
      isInitiallyActive1: false,
      isInitiallyActive2: true,
      isFinallyActive1: true,
      isFinallyActive2: false
    },
    {
      description:
        'correctly handles toggling when selecting an item and all items are closed',
      isInitiallyActive1: false,
      isInitiallyActive2: false,
      isFinallyActive1: true,
      isFinallyActive2: false
    },
    {
      description:
        'correctly handles toggling when closing an item and others are closed',
      isInitiallyActive1: true,
      isInitiallyActive2: false,
      isFinallyActive1: false,
      isFinallyActive2: false
    }
  ].forEach(
    ({
      description,
      isInitiallyActive1,
      isInitiallyActive2,
      isFinallyActive1,
      isFinallyActive2
    }) => {
      test(description, () => {
        const AccordionItem1 = helpers.addDefaultProp(AccordionItem, [
          ['id', '1'],
          ['open', isInitiallyActive1]
        ])
        const AccordionItem2 = helpers.addDefaultProp(AccordionItem, [
          ['id', '2'],
          ['open', isInitiallyActive2]
        ])

        const wrapper = helpers.initializeWrapper(Accordion, {
          slots: {
            default: [AccordionItem1, AccordionItem2]
          }
        })

        expect(wrapper.itemContentWrapper(0).isVisible()).toBe(
          isInitiallyActive1
        )
        expect(wrapper.itemContentWrapper(1).isVisible()).toBe(
          isInitiallyActive2
        )

        wrapper.toggleItem(0)

        expect(wrapper.itemContentWrapper(0).isVisible()).toBe(
          isFinallyActive1
        )
        expect(wrapper.itemContentWrapper(1).isVisible()).toBe(
          isFinallyActive2
        )
      })
    }
  )
})
