PitProneClient = window.PitProneClient = window.PitProneClient or {}

PitProneClient.init = () ->
  $('[data-toggle="tooltip"]').tooltip()

  if @user= $('html').data('user')
    $('html').removeAttr('data-user')

  if @token= $('html').data('token')
    $('html').removeAttr('data-token')

$ ->
  PitProneClient.init()

  unless PitProneClient.user? && PitProneClient.token?
    console.log('ajax is locked')


