class Table::DownloadController < ApplicationController
  def index
    send_data(
      model_class.to_csv(params.to_json),
      {
        type: 'text/csv; charset=utf-8; header=present',
        disposition: 'attachment',
        filename: 'filtered-indicators.csv'
      }
    )
  end
end
