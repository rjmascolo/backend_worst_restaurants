

class InspectionsController < ApplicationController
  def get_worst_restaurant_scores
    inspections = Inspection.worst_restaurant_in_zipcode(params["zipcode"])
    inspections.each { |inspec|
      res = Restaurant.find(inspec.restaurant_id)
      if !res["lat"]
        address = "#{res['building']} #{res['street']} #{res['zipcode']} #{res['boro']}, NY"
        cords = Geocoder.search(address)
        if cords[0]
          cords = cords[0].geometry["location"]
          res["lat"] = cords["lat"]
          res["long"] = cords["lng"]
          res.save
        end
      end
     }
    render json: inspections.to_json(include: :restaurant)
  end
end
