class Inspection < ApplicationRecord
  belongs_to :restaurant

  def self.worst_restaurant_in_zipcode(zipcode)
    inspections = []
    Restaurant.where("zipcode = ?", zipcode).each{ |restaurant|
        inspections.push(restaurant.inspections.sort{|x, y | y.inspection_date <=> x.inspection_date }[0])
    }
    inspections.sort{ |x,y| y.score <=> x.score }[0 .. 4]
  end

end
