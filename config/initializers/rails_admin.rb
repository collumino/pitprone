RailsAdmin.config do |config|
  require 'i18n'
  I18n.default_locale = :de

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.model 'PizzaItem' do
    visible false
  end

  config.model 'User' do
    visible false
  end

  config.model 'Address' do
    visible false
  end

  config.model 'Pizza' do
    parent Order
  end

  config.model 'Property' do
    navigation_label 'Einstellungen'
  end

  config.model 'Ingredient' do
    navigation_label 'Einstellungen'
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
