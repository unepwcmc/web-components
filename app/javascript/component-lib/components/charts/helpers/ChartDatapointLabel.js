import { DEFAULT_COLOUR } from './chart-constants.js'
import { DEFAULT_FONT } from './chart-constants.js'

export default class ChartDatapointLabel {
  constructor ({ 
    x, 
    y, 
    text, 
    colourStroke = DEFAULT_COLOUR.line, 
    colourFill = DEFAULT_COLOUR.fill,
    colourText = DEFAULT_COLOUR.text,
    fontSize = DEFAULT_FONT.size, 
    fontWeight = DEFAULT_FONT.weight, 
    datapointRadius = 4 
  }) {

    this.x = x
    this.y = y
    this.text = text
    this.colourStroke = colourStroke
    this.colourFill = colourFill
    this.colourText = colourText
    this.fontSize = fontSize
    this.fontWeight = fontWeight
    this.datapointRadius = datapointRadius
  }

  createLabel () {
    let html = `<circle fill="${this.colourFill}" stroke="${this.colourStroke}" stroke-width="4" r="${this.datapointRadius}"></circle>`

    if(this.text != undefined) {
      html += `<text 
        fill="${this.colourText}" 
        text-anchor="middle" 
        dominant-baseline="middle" 
        style="font-size: ${this.fontSize}; font-weight: ${this.fontWeight};">
          ${this.text}
      </text>`
    }

    return html
  }
}