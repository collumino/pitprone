PitProneClient = window.PitProneClient = window.PitProneClient or {}

PitProneClient.visitor = {}

class Navigation
  constructor: ->
    @ingredient_collector = []
    @size_parent = $('#get_size')
    @addon_parent = $('.ingredient_list')
    for selected in @addon_parent.find('a.selected')
      if @ingredient_collector.indexOf($(selected).parent().data('refid')) < 0
        @ingredient_collector.push($(selected).parent().data('refid'))

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
        $('.carousel-indicators #pizza_size').html(msg.size)
        $('.carousel-indicators #pizza_price').html(msg.costs)
        $('.ingredient_list > div').addClass('hidden').hide()
        console.log('pricing_' + elm.data('value') )
        $('.ingredient_list > #pricing_' + elm.data('value') ).removeClass('hidden').show()
        $('#presenter').carousel(1)
        @triggerMasterNavigation(true)
    })

  fireAddOnRequest: (elm) ->
    ingredient_name = elm.find('span.text').html()
    my_id = elm.parent().data('refid')
    found_pos = @ingredient_collector.indexOf(elm.parent().data('refid'))
    price_insensitives = @addon_parent.find('[data-refid='  + my_id  + ']')

    if found_pos < 0
      url = '/api/add_ingredient'
      type='PATCH'
    else
      url = '/api/del_ingredient'
      type='DELETE'

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
            for selection in price_insensitives
              $(selection).find('a').addClass('selected')
            $('<span class="glyphicon glyphicon-remove-circle"></span>').insertBefore(price_insensitives.find('span.text'))
            @ingredient_collector.push(my_id)

        if typeof msg.deleted != 'undefined'
          if ingredient_name == msg.deleted.name
            for selection in price_insensitives
              $(selection).find('a').removeClass('selected')
            price_insensitives.find('span.glyphicon-remove-circle').remove()
            @ingredient_collector.splice(found_pos, 1)
        $('.carousel-indicators #pizza_price').html(msg.costs)
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


