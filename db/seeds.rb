user1 = User.where(email: "test1@example.com").first_or_create(password: "password", password_confirmation: "password")
user2 = User.where(email: "test2@example.com").first_or_create(password: "password", password_confirmation: "password")


apartmentsU1 = [
  {
    street: '112 Fade street',
    unit: '3D',
    city: 'NY',
    state: 'NY',
    square_footage: '1300',
    price: '3300',
    bedrooms: 3,
    bathrooms: 3.0,
    pets: 'all pets allowed',
    image: 'https://images.unsplash.com/photo-1619542402915-dcaf30e4e2a1?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXBhcnRtZW50c3xlbnwwfHwwfHx8MA%3D%3D'
  },

  {
    street: '23 Kick It Ave',
    unit: 'C0',
    city: 'LA',
    state: 'CA',
    square_footage: '1500',
    price: '6000',
    bedrooms: 1,
    bathrooms: 0.5,
    pets: 'no pets allowed',
    image: 'https://images.unsplash.com/photo-1551361415-69c87624334f?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGFwYXJ0bWVudHN8ZW58MHx8MHx8fDA%3D'
  }
]

  apartmentsU2 = [
    {
    street: '129 West 81st Street',
    unit: '5A',
    city: 'NY',
    state: 'NY',
    square_footage: '1000',
    price: '2000',
    bedrooms: 2,
    bathrooms: 1.0,
    pets: 'no pets allowed',
    image: 'https://images.unsplash.com/photo-1567684014761-b65e2e59b9eb?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YXBhcnRtZW50c3xlbnwwfHwwfHx8MA%3D%3D'
  },

  {
    street: '123 Hide Your Pockets Blvd',
    unit: '4K',
    city: 'Chicago',
    state: 'Illinois',
    square_footage: '900',
    price: '1500',
    bedrooms: 2,
    bathrooms: 1.5,
    pets: 'pets allowed',
    image: 'https://images.unsplash.com/photo-1515263487990-61b07816b324?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8YXBhcnRtZW50c3xlbnwwfHwwfHx8MA%3D%3D'
  }
]

apartmentsU1.each do |apartment|
  user1.apartments.create(apartment)
  puts "Creating: #{apartment}"
end

apartmentsU2.each do |apartment|
  user2.apartments.create(apartment)
  puts "Creating: #{apartment}"
end
