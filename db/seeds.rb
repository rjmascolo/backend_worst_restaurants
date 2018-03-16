require 'json'
require 'open-uri'

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

# advertisers = {}
# x = conn.execute("SELECT DISTINCT advertiser_name FROM tmp")
#
# x.each{ |advertiser|
#   advertiser = Advertiser.create(name: advertiser)
#   advertisers[advertiser["name"]] = advertiser["id"]
# }

# advertisers.keys.each{ |name|
#   update_id = "UPDATE tmp SET advertiser_id= #{advertisers[name]} WHERE advertiser_name = '#{name}';"
#   conn.execute(update_id)
# }
#
# sql_put_temp_data_in_main = "
# INSERT INTO products (name, sku, advertiser_id)
# SELECT DISTINCT name, sku, advertiser_id FROM tmp;
# "
# conn.execute(sql_put_temp_data_in_main)
