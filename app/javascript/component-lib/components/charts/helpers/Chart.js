import SVG from 'svg.js'
import ChartLine from './ChartLine'
const DEFAULT_LINE_COLOUR = {
  line: '#000000',
  text: '#ffffff'
}
export default class Chart {
  constructor({lines, parent, width, height}) {
    this.lines = lines
    this.xMin = this.getMinMax('min', 'x')
    this.xMax = this.getMinMax('max', 'x')
    this.yMin = 0
    this.yMax = this.getMinMax('max', 'y')
    this.width = width
    this.height = height
    this.g = parent.group()
  }

  background (colour="#ffffff") {
    this.g.rect(this.width, this.height).fill(colour)
  }

  xAxis ({tickCount, precision}) {
    const xAxis = this.g.group()
    const xAxisData = this.getAxis({axis: 'x', length: this.width, tickCount, precision})

    xAxisData.forEach(x => {
      addXAxisLabel(x, xAxis)
    })

    return xAxis
  }

  yAxis ({tickCount, precision}) {
    const yAxis = this.g.group()
    const yAxisData = this.getAxis({axis: 'y', length: this.height, tickCount, precision})

    yAxisData.forEach(y => {
      addYAxisLabel(y, yAxis)
    })

    return yAxis
  }

  getMinMax (type, axis) {
    let array = []
  
    this.lines.forEach(line => {
      array.push(Math[type](...line.datapoints.map(t => t[axis])))
    }) 
  
    return Math.max(...array)
  }

  getAxis({axis, length, tickCount, precision}) {
    const incrementor = (this[`${axis}Max`] - this[`${axis}Min`])/ tickCount
    let axisTickLabels = []
    let n = this[`${axis}Min`]
  
    while( n < this[`${axis}Max`] + incrementor) {
      axisTickLabels.push({
        coord: this[`normalise${axis.toUpperCase()}`](n, length),
        labelText: Math.ceil(n/precision)*precision
      })
  
      n += incrementor
    }
  
    return axisTickLabels
  }

  chartLines () {    
    this.lines.forEach((line, index) => { this.chartLine(line, index) })
  }

  chartLine (line, index) {
    const chartLine = this.g.group()

    const chartLinePath = chartLine
      .path(this.getPath(line.datapoints))
      .fill('none')
      .stroke({
        color: this.getLineColourPair(line).line, 
        width: 4,
        linecap: 'round',
        linejoin: 'round'
      })
    
    const lineMarker = chartLine.group()
    
    lineMarker
      .circle(36)
      .fill(this.getLineColourPair(line).line)
  
    lineMarker
      .text(`${index}`)
      .fill(this.getLineColourPair(line).text)
      .center(18,18)
  
    lineMarker.center(...getPathMiddle(chartLinePath))

    return chartLine
  }

  getPath(dataset) {
    let path = ''
    
    dataset.forEach((point, index) => {
      const command = index == 0 ? 'M' : 'L'
  
      path += ` ${command} ${this.normaliseX(point.x)} ${this.normaliseY(point.y)}`
    })
  
    return path
  }

  normaliseX (value) {
    return this.width * (value - this.xMin) / (this.xMax - this.xMin)
  }

  normaliseY (value) {
    return this.height * (1 - (value - this.yMin) / (this.yMax - this.yMin))
  }

  getLineColourPair (line) {
    return line.colour ? line.colour : DEFAULT_LINE_COLOUR
  }
}


const getPathMiddle = path => {
  //used to add circle to a dataset with key used in the legend
  const pathArray = path.array().value
  const middle = pathArray[Math.floor(pathArray.length/2)]

  return middle.slice(1)
}

const addXAxisLabel = (x, xAxis) => xAxis
  .text(`${x.labelText}`)
  .font({ anchor: 'middle' })
  .x(x.coord);


const addYAxisLabel = (y, yAxis) => yAxis
  .text(`${y.labelText}`)
  .font({anchor: 'end'})
  .y(y.coord)

  // if (this.axisLabels) {
  //   draw.text(add => {
  //     this.axisLabels.y.forEach(t => {
  //       add.tspan(t).newLine()
  //     })
  //   }).move(0,0)
  // }