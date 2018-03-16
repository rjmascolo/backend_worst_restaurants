

class InspectionsController < ApplicationController
  def get_worst_restaurant_scores

    inspections = Inspection.where("score IS NOT NULL AND zipcode = ?", params["zipcode"]).order(score: :desc).limit(5)
    new_array = inspections.map { |res|
      address = "#{res['building']} #{res['street']} #{res['zipcode']} #{res['boro']}, NY"
      cords = Geocoder.search(address)
      if cords[0]
        cords = cords[0].geometry["location"]
        res["camis"] = "#{cords["lat"]} #{cords["lng"]} "
      end
      res
     }
    render json: new_array
  end
end
