# README Apartment App

Luis

## Add RSpec dependencies✅

```
bundle add rspec-rails
rails generate rspec:install
```

## Create a User model via Devise and add appropriate configurations✅

### add devise dependencies

```
bundle add devise
rails generate devise install
rails generate devise User
rails db:migrate
```

### add code to config/environments/development.rb

```
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

### replace code in config/initializers/devise.rb

```
# find this line:
config.sign_out_via = :delete
# and replace it with this:
config.sign_out_via = :get
```

### create registrations and sessions controllers to handle sign ups and logins

```
rails generate devise:controllers users -c registrations sessions
```

### replace code in app/controllers/users/registrations_controller.rb

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

### Replace code in app/controllers/users/sessions_controller.rb

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

### Update devise routes: config/routes.rb

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

Configure CORS✅
Add JWT dependencies and configurations✅
Add JWT revocation✅
Setup a README✅

- Data configurations have been inputed successfully.

```

```
