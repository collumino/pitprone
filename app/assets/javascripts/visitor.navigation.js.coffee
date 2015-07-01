PitProneClient = window.PitProneClient = window.PitProneClient or {}

PitProneClient.visitor = {}

class Navigation
  constructor: ->
    @size_parent = $('#get_size')
    @addon_parent = $('.ingredient_list')

  catchTrigger: ->
    @size_parent.find('a').on('click', (e) =>
      e.preventDefault()
      @fireSizeRequest($(e.currentTarget))
    )
    @addon_parent.find('.header > a').on('click', (e) =>
      e.preventDefault()
      @showIngredientSelection($(e.currentTarget))
    )
    @addon_parent.find('a.selectable').on('click', (e) =>
      e.preventDefault()
      @fireAddOnRequest($(e.currentTarget))
    )

  showIngredientSelection: (choice) ->
    @addon_parent.find('.header').removeClass('selected')
    @addon_parent.find('a.selectable').hide()
    choice.closest('.row').find('> div > a').removeClass('hidden').show()
    choice.parent().addClass('selected')

  fireSizeRequest: (elm) ->
    $.ajax({
      type: elm.data('http-verb'),
      url: elm.data('ref'),
      data:{ size: elm.data('value') },
      beforeSend: (request) ->
        request.setRequestHeader("X-User", PitProneClient.user)
        request.setRequestHeader("X-Token", PitProneClient.token)
      , success: (msg) =>
        @size_parent.find('.row > div').removeClass('selected')
        @size_parent.find('.' + elm.data('value') + '_size').addClass('selected')
        $('.carousel-indicators #pizza_size').html(elm.data('value'))
    })

  fireAddOnRequest: (elm) ->
    ingredient_name = elm.find('span.text').html()
    $.ajax({
      type: elm.data('http-verb') || 'patch',
      url: elm.data('ref') || @addon_parent.data('ref'),
      data:{ name: ingredient_name },
      beforeSend: (request) ->
        request.setRequestHeader("X-User", PitProneClient.user)
        request.setRequestHeader("X-Token", PitProneClient.token)
      , success: (msg) =>
        if typeof msg.added != 'undefined'
          if ingredient_name == msg.added.name then elm.addClass('selected')
        if typeof msg.deleted != 'undefined'
          if ingredient_name == msg.deleted.name then elm.removeClass('selected')
        $('.carousel-indicators #addon_collector').html(msg.amount)
    })



PitProneClient.visitor.init = () ->
  nav = new Navigation()
  nav.catchTrigger()

$ ->
  PitProneClient.visitor.init()


