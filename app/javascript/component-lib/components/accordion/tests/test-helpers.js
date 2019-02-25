export default wrapper => ({  
  accordionItems: () => wrapper.findAll('.accordion-item'),

  accordionItemByIndex(index=0) { return this.accordionItems().at(index) },
  
  itemContent(index) { return this.accordionItemByIndex(index).find('.accordion-item__content') },
  
  itemTitleText(index) { return this.accordionItemByIndex(index).find('.accordion-item__title').text() },

  itemContentWrapper(index) { return this.accordionItemByIndex(index).find('.accordion-item__content-wrapper') },
  
  toggleItem(index) { return this.accordionItemByIndex(index).find('.accordion-item__toggle').trigger('click') },
  
  itemToggleIcon(index) { return this.accordionItemByIndex(index).find('.accordion-item__toggle-icon') }
})