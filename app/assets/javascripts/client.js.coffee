PitProneClient = window.PitProneClient = window.PitProneClient or {}

PitProneClient.init = () ->
  $('[data-toggle="tooltip"]').tooltip()

  if @user= $('#presenter').data('user')
    $('#presenter').removeAttr('data-user')

  if @token= $('#presenter').data('token')
    $('#presenter').removeAttr('data-token')

$ ->
  PitProneClient.init()

  unless PitProneClient.user? && PitProneClient.token?
    console.log('ajax is locked')


