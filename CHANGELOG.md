### 0.3.0
1. now supporting filters on columns with multiple values and a legend component.

2. If you are updating from any previous versions - **breaking change**
- filters_to_json method has been replaced with attributes_to_json() which takes one string argument of "filters" or "legends"
- filters_to_json in used in your project controller has to be replaced with `attributes_to_json("filters")` to work with this version.

### 0.1.3
- Get CSV download functionality working.

### 0.1.2

### 0.1.0