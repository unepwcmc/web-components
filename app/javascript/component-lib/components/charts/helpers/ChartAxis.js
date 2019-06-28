import { normaliseX } from './chart-helpers.js'
import { normaliseY } from './chart-helpers.js'

export default class ChartAxis {
  constructor (axis, min, max, config, length) {
    this.axis = axis,
    this.min = min,
    this.max = max,
    this.length = length,
    this.precision = config.precision,
    this.totalTicks = config.totalTicks 
    this.normaliseX = normaliseX
    this.normaliseY = normaliseY
  }

  createAxis () {
    let axisTickLabels = [], n = this.min
    const incrementor = (this.max - this.min)/(this.totalTicks - 1)
    
    while( n < this.max + incrementor) {
      axisTickLabels.push({
        coord: this[`normalise${this.axis.toUpperCase()}`](n, this.min, this.max, this.length),
        labelText: Math.ceil(n/this.precision)*this.precision
      })

      n += incrementor
    }
    return axisTickLabels
  }
}