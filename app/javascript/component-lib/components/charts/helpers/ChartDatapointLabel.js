import { DEFAULT_COLOUR } from './chart-constants.js'
import { DEFAULT_FONT } from './chart-constants.js'

export default class ChartDatapointLabel {
  constructor (x, y, text, colourStroke, colourFill, colourText, fontSize, fontWeight) {
    this.x = x
    this.y = y
    this.text = text
    this.colourStroke = colourStroke ? colourStroke : DEFAULT_COLOUR.line
    this.colourFill = colourFill ? colourFill : DEFAULT_COLOUR.fill
    this.colourText = colourText ? colourText : DEFAULT_COLOUR.text
    this.fontSize = fontSize ? fontSize : DEFAULT_FONT.size
    this.fontWeight = fontWeight ? fontWeight : DEFAULT_FONT.weight
  }

  createLabel () {
    return `<circle fill="${this.colourFill}" stroke="${this.colourStroke}" stroke-width="4" r="20"></circle>
     <text 
      fill="${this.colourText}" 
      text-anchor="middle" 
      dominant-baseline="middle" 
      style="font-size: ${this.fontSize}; font-weight: ${this.fontWeight};">
        ${this.text}
    </text>`
  }
}