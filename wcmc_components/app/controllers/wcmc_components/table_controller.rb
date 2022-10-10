module WcmcComponents
  class TableController < ApplicationController


    def list
      @results = model_class.paginate(params.to_json)
      render json: @results
    end

    def download
      send_data model_class.to_csv(params.to_json), {
                  type: "text/csv; charset=utf-8; header=present",
                  disposition: "attachment",
                  filename: "filtered-indicators.csv" }
    end

  end
end
