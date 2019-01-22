// const VECTOR_LAYER = {
//   id: 148,
//   name: "Flood Occurrence",
//   map_type: "Vector",
//   legend: null,
//   tileset: null,
//   carto_filters: ["hfo < 3", "hfo BETWEEN 3 AND 10", "nfo > 10"],
//   carto_table: "flood_occurrence",
//   carto_colors: ["#17CDEA", "#1290A4", "#042F36"]
// };

const VECTOR_DATASET = {
  id: 320,
  name: "Drought Severity - Vector",
  map_type: "Vector",
  legend: null,
  tileset: null,
  carto_filters: ["dro < 20", "dro BETWEEN 20 AND 40", "dro > 40"],
  carto_table: "drought_severity",
  carto_colors: ["#17CDEA", "#1290A4","#042F36"]
};

const VECTOR_LINE_DATASET = {
  id: 171,
  name: "River Quality - VectorLine",
  map_type: "VectorLine",
  legend: null,
  tileset: null,
  carto_filters: ["tds < 307", "tds BETWEEN 307 AND 816", "tds > 816"],
  carto_table: "river_quality_v3",
  carto_colors: ["#A4895D", "#6F5326", "#46300D"]
};

const RASTER_DATASET = {
  id: 139,
  name: "Carbon Stocks - Raster",
  map_type: "Raster",
  legend: ["rgb(58,130,38)", "rgb(228,238,236)", "rgb(157,100,43)"],
  tileset: "unepwcmc.des977oz",
  carto_filters: [],
  carto_table: null,
  carto_colors: null
};

export const EXAMPLE_FILTERS = [
  {
    id: 1,
    name: "Filter 1",
    datasets: [VECTOR_DATASET, VECTOR_LINE_DATASET, RASTER_DATASET]
  },
  {
    id: 2,
    name: "Filter 2",
    datasets: [RASTER_DATASET]
  },
];
