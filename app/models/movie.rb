class Movie < ActiveRecord::Base
# Connect the attributes to the DB
  attr_accessible :title, :rating, :description, :release_date
  
  def self.all_ratings
      query = select('DISTINCT rating').map(&:rating)
  end
end
