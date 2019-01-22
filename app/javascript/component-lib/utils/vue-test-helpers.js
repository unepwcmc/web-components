import { mount, shallowMount } from '@vue/test-utils'
const $ = require('jquery')

const generateIntializeWrapper = (PageHelpers, isShallow) => ( ...wrapperOptions) => {
  const wrapper = isShallow ? shallowMount(...wrapperOptions) : mount(...wrapperOptions)

  Object.assign(wrapper, new PageHelpers(wrapper))
  
  return wrapper
}

export default PageHelpers => ({
  shallowInitializeWrapper: generateIntializeWrapper(PageHelpers, true),

  initializeWrapper: generateIntializeWrapper(PageHelpers, false),

  //temp solution to not being able to define props for multiple children in one slot
  addDefaultProp: (Component, props) => {
    const newComp = $.extend(true, {}, Component)
    
    props.forEach(prop => {
      newComp.props[prop[0]] = {
        default: () => prop[1],
        required: false
      }
    })

    return newComp
  }
})