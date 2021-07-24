require 'csv'

CSV.generate do |csv|
  csv_column_names = %w('日付' '出社' '退社')
  csv << csv_column_names
  @attendances.each do |day|
    if day.edit_superior.present? && (day.instructor == nil || day.instructor == "なし" || day.instructor == "申請中")
       csv_column_values = [ 
        day.worked_on
      ]
    else
      csv_column_values = [ 
        day.worked_on,
        day.started_at,
        day.finished_at,
      ]
    end
    csv << csv_column_values
  end
end
