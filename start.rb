require_relative 'near_earth_objects'

class Start
  def begin_program
    puts "________________________________________________________________________________________________________________________________"
    puts "Welcome to NEO. Here you will find information about how many meteors, astroids, comets pass by the earth every day. \nEnter a date below to get a list of the objects that have passed by the earth on that day."
    puts "Please enter a date in the following format YYYY-MM-DD."
    print ">>"
    date = gets.chomp
    astroid_output(date)
  end

  def astroid_output(date)
    header = "| #{ column_data(date).map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
    divider = "+-#{column_data(date).map { |_,col| "-"*col[:width] }.join('-+-') }-+"

    formated_date = DateTime.parse(date).strftime("%A %b %d, %Y")
    puts "______________________________________________________________________________"
    puts "On #{formated_date}, there were #{total_number_of_astroids(date)} objects that almost collided with the earth."
    puts "The largest of these was #{largest_astroid(date)} ft. in diameter."
    puts "\nHere is a list of objects with details:"
    puts divider
    puts header
    create_rows(astroid_list(date), column_data(date))
    puts divider
  end

  def astroid_details(date)
    NearEarthObjects.find_neos_by_date(date)
  end

  def astroid_list(date)
    astroid_details(date)[:astroid_list]
  end

  def total_number_of_astroids(date)
    astroid_details(date)[:total_number_of_astroids]
  end

  def largest_astroid(date)
    astroid_details(date)[:biggest_astroid]
  end

  def column_data(date)
    column_labels = { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
    column_labels.each_with_object({}) do |(col, label), hash|
      hash[col] = {
        label: label,
        width: [astroid_list(date).map { |astroid| astroid[col].size }.max, label.size].max}
    end
  end

  def format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end

  def create_rows(astroid_data, column_info)
    astroid_data.each { |astroid| format_row_data(astroid, column_info) }
  end
end
