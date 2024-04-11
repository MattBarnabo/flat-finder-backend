require 'rails_helper'

RSpec.describe "Apartments", type: :request do
  let(:user) { User.create(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  }

  describe 'GET #index' do
    it 'returns a list of apartments and http success' do
      apartment = user.apartments.create(
        street: 'Test Street',
        unit: 'Test Unit',
        city: 'Test City',
        state: 'Test State',
        square_footage: 1000,
        price: '$1000',
        bedrooms: 1,
        bathrooms: 1.0,
        pets: 'Test Pets',
        image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg'
      )
      get apartments_path
      expect(response).to have_http_status(200)
      expect(apartment).to be_valid
    end
  end

  describe 'POST #create' do
    it 'creates a valid apartment with http success' do
      post apartments_path, params: {
        apartment: {
          street: 'Test Street',
          unit: 'Test Unit',
          city: 'Test City',
          state: 'Test State',
          square_footage: 1000,
          price: '$1000',
          bedrooms: 1,
          bathrooms: 1.0,
          pets: 'Test Pets',
          image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg',
          user_id: user.id
        }
      }
      apartment = Apartment.where(street: 'Test Street').first
      expect(response).to have_http_status(200)
      expect(apartment).to be_valid
    end
    it 'creates a invalid apartment' do
      post apartments_path, params: {
        apartment: {
          street: nil,
          unit: nil,
          city: nil,
          state: nil,
          square_footage: nil,
          price: nil,
          bedrooms: nil,
          bathrooms: nil,
          pets: nil,
          image: nil,
          user_id: nil
        }
      }
      apartment = Apartment.where(street: nil).first
      expect(response).to have_http_status(422)
      expect(apartment).to eq(nil)
    end
  end

  describe 'Patch #update' do
    it 'updates a valid apartment with http success' do
      post apartments_path, params: {
        apartment: {
          street: 'Test Street',
          unit: 'Test Unit',
          city: 'Test City',
          state: 'Test State',
          square_footage: 1000,
          price: '$1000',
          bedrooms: 1,
          bathrooms: 1.0,
          pets: 'Test Pets',
          image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg',
          user_id: user.id
        }
      }
      apartment = Apartment.where(street: 'Test Street').first
      patch apartment_path(apartment), params: {
        apartment: {
          street: 'Test Street for patch',
          unit: 'Test Unit for patch',
          city: 'Test City for patch',
          state: 'Test State for patch',
          square_footage: 1001,
          price: '$1001',
          bedrooms: 2,
          bathrooms: 1.5,
          pets: 'Test Pets for patch',
          image: 'https://images.unsplash.com/photo-1515263487990-61b07816b324?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          user_id: user.id
        }
      }
      apartment = Apartment.where(street: 'Test Street for patch').first
      expect(apartment.street).to eq('Test Street for patch')
      expect(apartment.unit).to eq('Test Unit for patch')
      expect(apartment.city).to eq('Test City for patch')
      expect(apartment.state).to eq('Test State for patch')
      expect(apartment.square_footage).to eq(1001)
      expect(apartment.price).to eq('$1001')
      expect(apartment.bedrooms).to eq(2)
      expect(apartment.bathrooms).to eq(1.5)
      expect(apartment.pets).to eq('Test Pets for patch')
      expect(apartment.image).to eq('https://images.unsplash.com/photo-1515263487990-61b07816b324?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')
      expect(response).to have_http_status(200)
    end
  it 'updates a invalid apartment' do
    post apartments_path, params: {
        apartment: {
          street: 'Test Street',
          unit: 'Test Unit',
          city: 'Test City',
          state: 'Test State',
          square_footage: 1000,
          price: '$1000',
          bedrooms: 1,
          bathrooms: 1.0,
          pets: 'Test Pets',
          image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg',
          user_id: user.id
        }
      }
      apartment = Apartment.where(street: 'Test Street').first
      patch apartment_path(apartment), params: {
        apartment: {
          street: nil,
          unit: nil,
          city: nil,
          state: nil,
          square_footage: nil,
          price: nil,
          bedrooms: nil,
          bathrooms: nil,
          pets: nil,
          image: nil,
          user_id: nil
        }
      }
      apartment = Apartment.where(street: nil).first
      expect(response).to have_http_status(422)
      expect(apartment).to eq(nil)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes an apartment' do
      apartment = user.apartments.create(
        street: 'Test Street for delete',
        unit: 'Test Unit',
        city: 'Test City',
        state: 'Test State',
        square_footage: 1000,
        price: '$1000',
        bedrooms: 1,
        bathrooms: 1.0,
        pets: 'Test Pets',
        image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg',
        user_id: user.id
      )
      delete apartment_path(apartment)
      apartment = Apartment.where(street: 'Test Street for delete').first
      expect(apartment).to eq(nil)
    end
  end
end