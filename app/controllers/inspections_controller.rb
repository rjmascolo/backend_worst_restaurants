

class InspectionsController < ApplicationController
  
  def get_worst_restaurant_scores
    inspections = Inspection.worst_restaurant_in_zipcode(params["zipcode"])
    inspections.each { |inspec|
      res = Restaurant.find(inspec.restaurant_id)
      if !inspec.restaurant["lat"]
        address = "#{res['building']} #{res['street']} #{res['zipcode']} #{res['boro']}, NY"
        cords = Geocoder.search(address)
        if cords[0]
          cords = cords[0].geometry["location"]
          inspec.restaurant["lat"] = cords["lat"]
          inspec.restaurant["long"] = cords["lng"]
          inspec.restaurant.save
        end
      end
     }
    render json: inspections.to_json(include: :restaurant)
  end

end
