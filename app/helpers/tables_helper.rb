module TablesHelper
  def empty_cell_regex
    %r{<td([^>]*)></td>}
  end

  def html_row(row)
    "<tr>#{row}</tr>"
  end

  def html_header_cell(entry)
    "<th>#{entry}</th>"
  end

  def html_cell(entry, span = 1)
    "<td rowspan=\"#{span}\">#{entry}</td>"
  end

  def html_headers(headers)
    html_row(headers.map { |header| html_header_cell(header) }.join)
  end

  def html_rows(rows, is_rails_array)
    html_rows = ''
    rows.each do |row|
      row = row.attributes.values if is_rails_array
      html_rows += html_row(row.map { |entry| html_cell(entry) }.join)
    end

    html_rows
  end

  def html_table_start(table_class = '', colgroup = '')
    %(
      <div class=\"container--scroll-x\">
        <table class=\"table--min-width #{table_class}\" border=\"1\">
          #{colgroup}
          <tbody>
    )
  end

  def html_table_end
    '</tbody></table></div>'
  end

  def hash_to_htmltable(headers, rows, table_class = '', colgroup = '', is_rails_array = false)
    html = html_table_start(table_class, colgroup)
    html += html_headers(headers)
    html += html_rows(rows, is_rails_array)
    html += html_table_end
  end
end
