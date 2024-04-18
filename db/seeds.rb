user1 = User.where(email: "test1@example.com").first_or_create(password: "password", password_confirmation: "password")
user2 = User.where(email: "test2@example.com").first_or_create(password: "password", password_confirmation: "password")


apartmentsU1 = [
  {
		street: "Baker Street",
		unit: "221B ",
		city: "London",
		state: "England",
		square_footage: 1525,
		price: "3000",
		bedrooms: 2,
		bathrooms: 1.0,
		pets: "Birds",
		image:
			"https://selenestudiesabroad.files.wordpress.com/2014/01/img_7327.jpg",
  },

  {
		street: "Leinster Square",
		unit: "3B",
		city: "London",
		state: "England",
		square_footage: 400,
		price: "2000",
		bedrooms: 1,
		bathrooms: 2.0,
		pets: "Large Pets",
		image:
			"https://plus.unsplash.com/premium_photo-1661315431756-f9870d5ff5a0?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  }
]

  apartmentsU2 = [
    {
      street: "Oaklands Road",
      unit: "9A",
      city: "London",
      state: "England",
      square_footage: 500,
      price: "1800",
      bedrooms: 2,
      bathrooms: 2.0,
      pets: "Medium Pets",
      image:
        "https://images.unsplash.com/photo-1469022563428-aa04fef9f5a2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1173&q=80",
  },

  {
		street: "Hollybush Hill",
		unit: "508",
		city: "London",
		state: "England",
		square_footage: 700,
		price: "2500",
		bedrooms: 2,
		bathrooms: 2.0,
		pets: "Cats",
		image:
			"https://plus.unsplash.com/premium_photo-1673561231809-17f6f9ef09b7?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YXBhcnRtZW50c3xlbnwwfHwwfHx8MA%3D%3D",

  },

  {
		street: "Northchurch Road",
		unit: "415A",
		city: "London",
		state: "England",
		square_footage: 1023,
		price: "2000",
		bedrooms: 1,
		bathrooms: 2.0,
		pets: "Small Dogs",
		image:
			"https://plus.unsplash.com/premium_photo-1661293864119-9c689ca0a1de?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  },

  {
		street: "Brompton Road",
		unit: "52A",
		city: "London",
		state: "England",
		square_footage: 400,
		price: "1800",
		bedrooms: 1,
		bathrooms: 2.0,
		pets: "Reptiles ",
		image:
			"https://images.unsplash.com/photo-1576378839886-48817ce9c383?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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
