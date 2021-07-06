module ApplicationHelper

  def full_title(page_name = "")
    base_title = "Sample"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end

  # 終了予定時間と指定終了時間を指定のフォーマットで返します。
  def over_time(time,time2)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0 - ((time2.hour * 60) + time2.min) / 60.0)
  end 
  
  # 時間外時間で日をまたいだ時 24-指定終了時間+残業時間
  def nextday_overtime(time, time2)
    format("%.2f", (24 - ((time.hour * 60) + time.min) / 60.0) + ((time2.hour * 60) + time2.min) / 60.0)
  end

end