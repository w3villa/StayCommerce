module Stay
  module Seeds
    class Roles
      def self.call
        Stay::Role.where(name: 'admin').first_or_create!
      end
    end
  end
end

# Create Property Types
entire_property = Stay::PropertyType.where(name: 'Entire Property').first_or_create!
shared_property = Stay::PropertyType.where(name: 'Shared Property').first_or_create!


# Create Room Types
private_room = Stay::RoomType.where(name: 'Private Room', description: 'A room with a single bed').first_or_create!
shared_room = Stay::RoomType.where(name: 'Shared Room', description: 'A room shared with others').first_or_create!

# Create Property Categories
apartment = Stay::PropertyCategory.where(name: 'Apartment',property_type_id: entire_property.id, room_type_id: private_room.id).first_or_create!
dorm = Stay::PropertyCategory.where(name: 'Dorm',property_type_id: shared_property.id, room_type_id: shared_room.id).first_or_create!
host_family = Stay::PropertyCategory.where(name: 'Host Family',property_type_id: shared_property.id, room_type_id: shared_room.id).first_or_create!
student_house = Stay::PropertyCategory.where(name: 'Student House',property_type_id: shared_property.id, room_type_id: shared_room.id).first_or_create!
studio = Stay::PropertyCategory.where(name: 'Studio',property_type_id: shared_property.id, room_type_id: shared_room.id).first_or_create!
student_apartment = Stay::PropertyCategory.where(name: 'Student Apartment',property_type_id: shared_property.id, room_type_id: shared_room.id).first_or_create!

# bed type
single_bed = Stay::BedType.where(name: 'Single Bed (Twin Bed)').first_or_create!
queen_bed = Stay::BedType.where(name: 'Queen Bed').first_or_create!
king_bed = Stay::BedType.where(name: 'King Bed').first_or_create!
bunk_bed = Stay::BedType.where(name: 'Bunk Bed').first_or_create!
sofa_bed = Stay::BedType.where(name: 'Sofa Bed (Pull-Out Bed)').first_or_create!


# amenity category
category = ["general amenities", "other amenities", "safe amenities"]

category.each do |cate|
  Stay::AmenityCategory.where(name: cate).first_or_create!
end


general = Stay::AmenityCategory.find_by(name: "general amenities")

option1.each do |op|
  general.amenities.where(name: op).first_or_create!
end

option1 = ["Wifi",
"Internet",
"TV",
"Air conditioning",
"Fan",
"Private entrance",
"Dryer",
"Heater",
"Washing machine",
"Detergent",
"Clothes dryer",
"Baby cot",
"Desk",
"Fridge",
"Dryer"]


other = Stay::AmenityCategory.find_by(name: "other amenities")

option2.each do |op|
  other.amenities.where(name: op).first_or_create!
end


option2 = [
"Wardrobe",
"Cloth hook",
"Extra cushion",
"Gas stove",
"Toilet paper",
"Free toiletries",
"Makeup table",
"Hot pot",
"Bathroom heaters",
"Kettle",
"Dishwasher",
"BBQ grill",
"Toaster",
"Towel",
"Dining table"]



safe = Stay::AmenityCategory.find_by(name: "safe amenities")
option3.each do |op|
  safe.amenities.where(name: op).first_or_create!
end

option3 = [
"Fire siren",
"Fire extinguisher",
"Anti-theft key",
"Safe vault"
]

# amenity



