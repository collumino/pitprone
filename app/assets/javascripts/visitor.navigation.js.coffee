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

  catchSelectionTrigger: () ->
    @addon_parent.find('a.selectable').on('click', (e) =>
      e.preventDefault()
      @fireAddOnRequest($(e.currentTarget))
      e.stopPropagation()

      @triggerMasterNavigation()
    )

  showIngredientSelection: (choice) ->
    @addon_parent.find('.header').removeClass('selected')
    for selectable_link in @addon_parent.find('a.selectable')
      $(selectable_link).hide() unless $(selectable_link).hasClass('selected')
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
        @triggerMasterNavigation(true)
    })

  fireAddOnRequest: (elm) ->
    ingredient_name = elm.find('span.text').html()

    if elm.data('ref')
      url = elm.data('ref')
      type='DELETE'
    else
      url = @addon_parent.data('ref')
      type='PATCH'


    $.ajax({
      type: type,
      url: url,
      data:{ name: ingredient_name },
      beforeSend: (request) ->
        request.setRequestHeader("X-User", PitProneClient.user)
        request.setRequestHeader("X-Token", PitProneClient.token)
    }).done( (msg) =>
        if typeof msg.added != 'undefined'
          if ingredient_name == msg.added.name
            elm.addClass('selected')
            $('<span class="glyphicon glyphicon-remove-circle"></span>').insertBefore(elm.find('span.text'))
            elm.attr({'data-http-verb': 'delete', 'data-ref': '/api/del_ingredient', 'data-confirm': 'wollen Sie diese Beilage entfernen ?'})

        if typeof msg.deleted != 'undefined'
          if ingredient_name == msg.deleted.name
            elm.removeClass('selected')
            elm.find('span.glyphicon-remove-circle').remove()
            elm.attr('data-http-verb', 'patch')
            elm.removeAttr('data-ref')
            elm.removeAttr('data-confirm')
        $('.carousel-indicators #addon_collector').html(msg.amount)
    )


  triggerMasterNavigation: (free) ->

    collect = $('.carousel-indicators #addon_collector').closest('li')
    price = $('.carousel-indicators #pizza_price').closest('li')
    if free
      collect.attr({'data-target':'#presenter', 'data-slide-to': '1'})
      collect.removeClass('locked')
      console.log(collect)
      price.attr({'data-target':'#presenter', 'data-slide-to': '2'})
      price.removeClass('locked')
      console.log(price)

PitProneClient.visitor.init = () ->
  nav = new Navigation()
  nav.catchTrigger()
  nav.catchSelectionTrigger()

$ ->
  PitProneClient.visitor.init()


