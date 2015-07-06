Pitprone
================

This is a showcase from collumino GmbH, Olten, Switzerland
The app is a single screen application, so the view is rendered exactly one time.
It is mainly developed on firefox browser, so if you want have the best view, you have to use this.


Ruby on Rails
-------------

This application requires:

- Ruby 2.2.1
- Rails 4.2.2


Getting Started
---------------

"rake db:create"
"rake db:migrate"
"rake db:seed" fills the database with initial data, mainly ingredient list with assigned ingredient properties.

"rails server" starts the application on localhost:3000


Documentation
-------------------------

Creating an order has one initial and one final ( placing the order ) server request.
Anything else is done via AJAX calls in the background.

The API is implemented with a slim middelware stack. The API methods itself are based on JSON.
Authentication is done with additional HTTP HEADER fields, no session access here. It is based on a user declaration and an assigned API token.
Syncing data to the actual order happens on a session related instance variable.

The order workflow contains the events
  :build_pizza
  :buy_pizza
  :bake_pizza
  :deliver_pizza

Selecting and filtering ingredients is done inside the client without any database query on server side.


used gems
-------------

- aasm : Workflow engine for orders
- rails_admin: rapid prototyping admin views
- prawn: is used as pdf generating module
- bootstrap & jquery: are the base on UI work
- sass: enables dynamic css generation with variables and more
- haml: get a cleaner markup
- coffescript: scripting javascript generation
- capistrano: does all the deploying stuff
- mysql: preferred database adapter


