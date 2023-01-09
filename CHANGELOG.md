### 1.0.0

- Refactor filterable module
- Add sorting by custom attribute
- devise SSO gem
- API: an endpoint which returns serialized JSON for one of the host application’s models
- Add editing functionality

BREAKING CHANGES
- When defining associated attributes through a join, the name should be `table_name.attribute_name` when decorating the model with `table_attribute`s
- Attributes do not automatically appear in the csv output. The ````show_in_csv: true``` argument should be passed to the table_attributes method calls in the table model classes.
- ```table_attr``` needs to be changed to ```table_attributes```

### 0.4.0

- Setup linters in repository and lint code
- Record dependency versions in `.node-version` & `.tool-versions`
- Update README.md with information about `WcmcComponents` and its submodules
- Add API functionality
  - new routes
  - new controller
  - new `Filterable` methods to do the work of serving a model's records

### 0.3.1
1. Allows has_many relationships to be imported

### 0.3.0
1. Fixes bug in csv imports
2. Allows displaying methods in tables and csv exports

### 0.2.0
1. now supporting filters on columns with multiple values and a legend component.

2. If you are updating from any previous versions - **breaking change**
- filters_to_json method has been replaced with attributes_to_json() which takes one string argument of "filters" or "legends"
- filters_to_json in used in your project controller has to be replaced with `attributes_to_json("filters")` to work with this version.

### 0.1.3
- Get CSV download functionality working.

### 0.1.2

### 0.1.0