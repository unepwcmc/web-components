export function normaliseX (value, min, max, width) {
  // subtract the min value incase the axis doesn't start at 0
  return width * (value - min) / (max - min)
} 

export function normaliseY (value, min, max, height) {
  // y origin is at the top so subtract axis value from height
  // subtract the min value incase the axis doesn't start at 0
  return height * (1 - (value - min) / (max - min))
}