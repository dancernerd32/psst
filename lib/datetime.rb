def split(datetime)
  datetime.split("-")
end

def month(datetime)
  months = {
    "01" => "January",
    "02" => "February",
    "03" => "March",
    "04" => "April",
    "05" => "May",
    "06" => "June",
    "07" => "July",
    "08" => "August",
    "09" => "September",
    "10" => "October",
    "11" => "November",
    "12" => "December",
  }
  months[split(datetime)[1]]
end

def day(datetime)
  split(datetime)[2].split(" ")[0]
end

def year(datetime)
  split(datetime)[0]
end

def time(datetime)
  split_time = split(datetime)[2].split(" ")[1].split(":")
  time = []
  time << split_time[0].to_i % 12
  time << split_time[1]
  if split_time[0].to_i <= 12
    time << "am"
  else
    time << "pm"
  end
  time
end

def format_date(datetime)
  "#{month(datetime)} #{day(datetime)}, #{year(datetime)} at
  #{time(datetime)[0]}:#{time(datetime)[1]}#{time(datetime)[2]}"
end
