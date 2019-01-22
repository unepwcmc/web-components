export const mixinCarto = {
  data () {
    return {
      layerObject: '',
    }
  },

  methods: {
      createTiles (username, key, {filter, tables}) {
      let tiles = new cartodb.Tiles({
        user_name: username,
        tiler_protocol: 'https',
        tiler_port: '443',
        sublayers: [{
          //change table_name with name of the dataset
          //best to use .env
          sql: this.generateSQL(filter, tables),
          cartocss: this.generateCartocss(tables)
        }],
        extra_params: { map_key: key }
      })

      return tiles
    },

    generateSQL (filter, tables) {
      let sql = ''
      let whereCond = ''

      if(filter !== undefined && filter !== null) {
        whereCond = ' WHERE ' + filter
      }

      let defaultSql = 'SELECT cartodb_id, the_geom, the_geom_webmercator'

      if (tables[0] === 'wdpa_poly') {
        defaultSql += ', name, desig_eng, gov_type, iucn_cat, wdpaid'
      }

      if (tables[0] === 'global_kba_poly') {
        defaultSql += ', intname, ibastatus, azestatus'
      }

      defaultSql += ' FROM '

      tables.forEach((table, index) => {
        sql = sql + defaultSql + table + whereCond

        if (index < tables.length - 1) {
          sql = sql + ' UNION ALL '
        }
      })

      return sql
    },

    generateCartocss(tables) {
      let css = ''

      tables.forEach((table, index) => {
        css = css + '#' + table + '{}'

        if (index < tables.length - 1) {
          css = css + '\n'
        }
      })
      return css
    }
  }
}
