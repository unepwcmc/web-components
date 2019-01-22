export default class AriaListbox extends HTMLElement {
  constructor() {
    // Always call super first in constructor
    super();
  }

  connectedCallback() {
    this.setAttribute('role', 'listbox')
  }
}