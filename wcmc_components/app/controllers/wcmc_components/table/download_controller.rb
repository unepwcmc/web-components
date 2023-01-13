module WcmcComponents
  class Table::DownloadController < ApplicationController
    def index
      send_data(
        model_class.to_csv(query_params_with_symbol_keys),
        {
          type: 'text/csv; charset=utf-8; header=present',
          disposition: 'attachment',
          filename: model_class.csv_filename
        }
      )
    end
  end
end
