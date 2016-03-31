class Movie < ActiveRecord::Base
# Connect the attributes to the DB
  attr_accessible :title, :rating, :description, :release_date
end
