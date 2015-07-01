PitProneClient = window.PitProneClient = window.PitProneClient or {}

PitProneClient.visitor = {}

class Navigation
  constructor: ->
    @parent = $('#get_size')

  catchTrigger: ->
    @parent.find('a').on('click', (e) =>
      e.preventDefault()
      @fireRequest($(e.currentTarget))
    )

  fireRequest: (elm) ->
    $.ajax({
      type: elm.data('http-verb'),
      url: elm.data('ref'),
      data:{
        size: elm.data('value')
      },
      beforeSend: (request) ->
        request.setRequestHeader("X-User", PitProneClient.user)
        request.setRequestHeader("X-Token", PitProneClient.token)
      , success: (msg) =>
        @parent.find('.row > div').removeClass('selected')
        @parent.find('.' + elm.data('value') + '_size').addClass('selected')
        $('.carousel-indicators #pizza_size').html(elm.data('value'))
    })

PitProneClient.visitor.init = () ->
  nav = new Navigation()
  nav.catchTrigger()

$ ->
  PitProneClient.visitor.init()


