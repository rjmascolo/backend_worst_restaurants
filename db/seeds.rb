require 'json'
require 'open-uri'

<<<<<<< HEAD
Restaurant.destroy_all
Inspection.destroy_all

nyc_zipcodes = [11211, 11385, 10456, 10171, 10003, 11102, 10173, 10306, 10057, 11693, 11354, 10281, 10465, 11218, 11377, 11242, 10033, 11694, 11220, 11238, 11209, 11691, 10011, 11230, 10178, 10039, 11366, 10158, 10453, 11104, 11433, 10044, 11217,
  10065,10458, 10038, 11235, 11232, 10270, 11004, 11208, 10461, 10032, 10473, 10040, 11378, 10308, 11216, 10027, 11432, 10107, 11109, 11373, 11001, 11374, 10019, 10010, 11213, 10030, 11214, 11224, 10111, 11375, 10028, 11369,
  11413, 10106, 10459, 10023, 11221, 10176, 11210, 10005, 10154, 11203, 10457, 10466, 11106, 11411, 11201, 11223, 10470, 10302, 11212, 10475, 10020, 10168, 10017, 10118, 10036, 11412, 11429, 10167, 11358, 11372, 11352, 10037,
  10304, 11367, 10024, 11420, 10170, 10271, 11101, 10454, 10029, 11233, 11003, 11215, 11225, 11451, 11427, 10172, 10285, 10301, 10001, 10035, 10165, 11364, 11204, 11103, 10311, 10307, 11229, 10006, 11415, 10175, 10026, 10452,
  11435, 10309, 11236, 11356, 10121, 10104, 10305, 11697, 11361, 10174, 10112, 11379, 10310, 10314, 10022, 10451, 11434, 10468, 11365, 11416, 11207, 10471, 11231, 10119, 10464, 11219, 11419, 11228, 11362, 10303, 11239, 10282,
  11360, 10103, 10007, 10155, 10002, 11426, 10153, 10463, 11206, 10312, 11005, 11414, 11421, 10467, 10469, 11241, 11417, 10025, 11245, 11370, 11423, 11428, 10317, 10034, 10018, 11105, 11371, 10199, 10455, 11226, 10021, 10048,
  10128, 10016, 11430, 11418, 11357, 10110, 10169, 10460, 10152, 10474, 11692, 10004, 10075, 10014, 10069, 10279, 10510, 11234, 11256, 11205, 10472, 11355, 10009, 10031, 11040, 10012, 11222, 10462, 11249, 11237, 10280, 11422, 10013,
  11368, 11436, 10123, 11363, 10105, 10179, 10166]

  def restaurant_params(c)
      {
        name: c["dba"],
        cuisine: c["cuisine"],
        zipcode: c["zipcode"],
        street: c["street"],
        boro: c["boro"],
        building: c["building"],
        phone_number: c["phone"]
      }
  end

  def inspection_params(c, restaurant)
      {
        inspection_date: c["inspection_date"],
        inspection_type: c["inspection_type"],
        restaurant: restaurant,
        score: c["score"],
        grade: c["grade"],
        grade_date: c["grade_date"],
        action: c["action"]
      }
  end

=======
>>>>>>> 1aebfc1... grabs file from nydata and does upload
conn = ActiveRecord::Base.connection
document = open("https://data.cityofnewyork.us/api/views/43nn-pn8j/rows.csv?accessType=DOWNLOAD")
conn.execute("
  CREATE TEMP TABLE tmp (
    camis integer,
    dba text,
    boro text,
    building text,
    street text,
    zipcode text,
    phone text,
    cuisine text,
    inspection_date text,
    action text,
    violation_code text,
    violation_description text,
    critical_flag text,
    score integer,
    grade text,
    grade_date text,
    record_date text,
    inspection_type text
  )"
)

# file = Rails.root.join('lib', 'DOHMH_New_York_City_Restaurant_Inspection_Results.csv')

File.open(document, 'r') do |file|
  conn.raw_connection.copy_data %{copy tmp from stdin with csv header delimiter ',' quote '"'} do
    while line = file.gets do
      conn.raw_connection.put_copy_data line
    end
  end
end
<<<<<<< HEAD

nyc_zipcodes.each{ |zip|
  data = conn.execute("SELECT * FROM tmp WHERE score IS NOT NULL AND zipcode = '#{zip}' ORDER BY score DESC LIMIT 200")
  data.each{ |inspec|
    restaurant = Restaurant.find_or_create_by(restaurant_params(inspec))
    Inspection.find_or_create_by(inspection_params(inspec,restaurant))
  }
}
=======
# begin
#   sql_command = "
#   COPY tmp (camis, dba, boro, building, street, zipcode, phone, cuisine, inspection_date, action, violation_code, violation_description, critical_flag, score, grade, grade_date, record_date, inspection_type)
#   FROM '#{file}' CSV HEADER;"
#   conn.execute(sql_command)
# rescue => e
#   error = e.message
#   puts "CSV file is not formatted correctly. Below is the error
#    #{error}"
# end
#
sql_put_temp_data_in_main = "
INSERT INTO inspections (camis, name, building, street, boro, zipcode, cuisine, inspection_date, score )
SELECT DISTINCT camis, dba, building, street, boro, zipcode, cuisine, inspection_date, score FROM tmp;
"
conn.execute(sql_put_temp_data_in_main)



# restaurants_raw = RestClient.get("https://data.cityofnewyork.us/resource/9w7m-hzhe.json?$limit=100")
# restaurants = JSON.parse(restaurants_raw)
#
# restaurant_data = restaurants.map{ |r|
#   x =
#   "('#{r["camis"]}','#{r["dba"].include? "'" ? r["dba"].tr("'", " ") : r["dba"] }', '#{r["cuisine_description"]}', '#{r["building"]} #{r["street"]}', '#{r["zipcode"]}', '#{r["boro"]}', '#{r["inspection_date"]}', '#{r["score"]}' )"
# }.join(',')
#
#
# conn.execute("INSERT INTO tmp ( restaurant_id, name, cuisine, address, zipcode, boro, inspection_date, score) VALUES #{restaurant_data}")
#
#
# sql_put_temp_data_in_main = "
# INSERT INTO restaurants (restaurant_id, name, cuisine, address, zipcode, boro)
# SELECT DISTINCT restaurant_id, name, cuisine, address, zipcode, boro FROM tmp;
# "
# conn.execute(sql_put_temp_data_in_main)

# Solution for a clean CSV data set
# begin
#   sql_command = "
#   COPY tmp (name, sku, advertiser_name)
#   FROM '#{file}' CSV HEADER;"
#   conn.execute(sql_command)
# rescue => e
#   error = e.message
#   puts "CSV file is not formatted correctly. Below is the error
#    #{error}"
# end
#
# conn.execute("ALTER TABLE tmp ADD advertiser_id integer;")
#
>>>>>>> 1aebfc1... grabs file from nydata and does upload

# data = conn.execute("SELECT dba, building, street, boro, zipcode, cuisine FROM tmp GROUP BY dba, building, street, boro, zipcode, cuisine")
# byebug

# sql_put_temp_data_in_main = "
# INSERT INTO inspections (camis, name, building, street, boro, zipcode, cuisine, inspection_date, score )
# SELECT DISTINCT camis, dba, building, street, boro, zipcode, cuisine, inspection_date, score FROM tmp;
# "
# conn.execute(sql_put_temp_data_in_main)
