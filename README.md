# README Apartment App

## Rails API Configuration

### Add RSpec dependencies✅

```
bundle add rspec-rails
rails generate rspec:install
```

### Create a User model via Devise and add appropriate configurations✅

#### Add devise dependencies

```
bundle add devise
rails generate devise install
rails generate devise User
rails db:migrate
```

#### Add code to config/environments/development.rb

```
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

#### Replace code in config/initializers/devise.rb

```
# find this line:
config.sign_out_via = :delete
# and replace it with this:
config.sign_out_via = :get
```

#### Create registrations and sessions controllers to handle sign ups and logins

```
rails generate devise:controllers users -c registrations sessions
```

#### Replace code in app/controllers/users/registrations_controller.rb

```
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    build_resource(sign_up_params)
    resource.save
    sign_in(resource_name, resource)
    render json: resource
  end
end
```

#### Replace code in app/controllers/users/sessions_controller.rb

```
class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(resource, _opts = {})
    render json: resource
    end
  def respond_to_on_destroy
    render json: { message: "Logged out." }
  end
end
```

#### Update devise routes: config/routes.rb

```
Rails.application.routes.draw do
  devise_for :users,
  path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  end
```

### Configure CORS✅

#### Update config/initializers/cors.rb

```
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'
    resource '*',
    headers: ["Authorization"],
    expose: ["Authorization"],
    methods: [:get, :post, :put, :patch, :delete, :options, :head],
    max_age: 600
  end
end
```

#### Uncomment this from Gemfile

```
gem "rack-cors"
```

### Add JWT dependencies and configurations✅

#### Install dependencies

```
bundle add devise-jwt
```

#### Create Jwt secret key

```
bundle exec rails secret
```

#### Run this command to open the window to add the new secret key

```
EDITOR="code --wait" bin/rails credentials:edit
```

#### Add the secret key below the secret key base using this code

```
jwt_secret_key: <newly-created secret key>
```

#### In the terminal hit 'control + c' to save the file

#### If you get an error saying it didn't save. Manually save the file with 'command + s' in the VScode window

#### Add this to config/initializers/devise.rb

```
config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.jwt_special_key
  jwt.dispatch_requests = [
    ['POST', %r{^/login$}],
  ]
  jwt.revocation_requests = [
    ['DELETE', %r{^/logout$}]
  ]
  jwt.expiration_time = 5.minutes.to_i
end
```

### Add JWT revocation✅

#### Run this in the terminal

```
rails generate model jwt_denylist
```

#### Add this code to the migration: db/migrate/

```
def change
  create_table :jwt_denylist do |t|
    t.string :jti, null: false
    t.datetime :exp, null: false
  end
  add_index :jwt_denylist, :jti
end
```

#### Migrate

```
rails db:migrate
```

#### Replace this in the app/models/user.rb

```
devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
```

## Rails Apartment Model

### Generate Model

#### Generate model in the terminal

```
rails generate resource Apartment street:string unit:string city:string state:string square_footage:integer price:string bedrooms:integer bathrooms:float pets:string image:text user_id:integer
```

#### Define the relationship between Apartment and the User in app/models/user.rb

```
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  has_many :apartments
end
```

#### Define the relationship between Apartment and the User in app/models/apartment.rb

```
class Apartment < ApplicationRecord
  belongs_to :user
end
```

#### Add a global variable for user to allow for easier testing in spec/models/apartment_spec.rb

```
require 'rails_helper'

RSpec.describe Apartment, type: :model do
  let(:user) { User.create(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  }
```

#### Add first test to test for valid attributes

```
it 'is valid with valid attributes' do
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
image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg',
)
expect(apartment).to be_valid
end
```

#### Add test for validating presence of attributes repeat for each data column making sure to update the it statement and the expect statement

```
it 'is not valid without a street attribute' do
apartment = user.apartments.create(
unit: 'Test Unit',
city: 'Test City',
state: 'Test State',
square_footage: 1000,
price: '$1000',
bedrooms: 1,
bathrooms: 1.0,
pets: 'Test Pets',
image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg',
)
expect(apartment).not_to be_valid
expect(apartment.errors[:street].first).to eq("can't be blank")
end
end

```

#### Add validation to app/models/apartment.rb

```

class Apartment < ApplicationRecord
  belongs_to :user
  validates :street, :unit, :city, :state, :square_footage, :price, :bedrooms, :pets, :bathrooms, :image, presence: true
end
```

## API Endpoints

### Testing

#### Add a global user variable for the test file

```
RSpec.describe "Apartments", type: :request do
  let(:user) { User.create(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  }
```

### Add a mock GET request for index

```
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
```

#### Add a mock POST request for create

```
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
```

#### Add a mock PATCH request for update

```
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
```

#### Add a mock DESTORY request for delete

```
describe 'DELETE #destroy' do
      it 'deletes an apartment' do
        apartment = user.apartments.create(
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
    )
    delete apartment_path(apartment)
    apartment = Apartment.where(street: 'Test Street').first
    expect(apartment).to eq(nil)
    end
  end
```

#### test for 422 http error on failed apartment

```
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
end
```

### Controller methods

#### Add index method to app/controllers/apartments_controller.rb

```
class ApartmentsController < ApplicationController
  def index
    apartments = Apartment.all
    render json: apartments
  end
```

#### Add create method to app/controllers/apartments_controller.rb

```
def create
    apartment = Apartment.create(apartment_params)
    if apartment.valid?
      render json: apartment
    else
      render json: apartment.errors, status: 422
    end
  end
```

#### Add update method to app/controllers/apartments_controller.rb

```
def update
    apartment = Apartment.find(params[:id])
    apartment.update(apartment_params)
    if apartment.valid?
      render json: apartment
    else
      render json: apartment.errors, status: 422
    end
  end
```

#### Add destory method to app/controllers/apartments_controller.rb

```
def destroy
    apartment = Apartment.find(params[:id])
    if apartment.destroy
      render json: {}, status: 204
    end
  end
```

#### Add params method in private

```
private
  def apartment_params
    params.require(:apartment).permit(:street, :unit, :city, :state, :square_footage, :price, :bedrooms, :bathrooms, :pets, :image, :user_id)
  end
end
```

##
