export default class ChartLine {
  constructor({lines, parent, width, height}) {
    this.lines = lines
    this.xMin = this.getMinMax('min', 'x')
    this.xMax = this.getMinMax('max', 'x')
    this.yMin = 0
    this.yMax = this.getMinMax('max', 'y')
    this.g = parent.group()
    this.g.rect(width, height).fill('#ffffff')
    this.width = width
    this.height = height
  }
}
