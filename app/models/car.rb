class Car < ActiveRecord::Base
  attr_accessible :license_number, :make, :model, :status
end
