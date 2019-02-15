export const compareAlphabeticallyBy = key => (a, b) => {
  if(a[key] < b[key]) { return -1 }
  if(a[key] > b[key]) { return 1 }
  return 0
}