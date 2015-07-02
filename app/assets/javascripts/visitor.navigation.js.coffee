PitProneClient = window.PitProneClient = window.PitProneClient or {}

PitProneClient.visitor = {}

class Navigation
  constructor: ->
    @ingredient_collector = []
    @size_parent = $('#get_size')
    @addon_nav_parent = $('.ingredient_selector')
    @addon_parent = $('.ingredient_list')
    @addon_filter = $('#ingredient_filter > li')
    @selection_container = $(".selected_items")
    for selected in @addon_parent.find('a.selected')
      if @ingredient_collector.indexOf($(selected).parent().data('refid')) < 0
        @ingredient_collector.push($(selected).parent().data('refid'))

  catchTrigger: ->
    @size_parent.find('a').on('click', (e) =>
      e.preventDefault()
      @fireSizeRequest($(e.currentTarget))
    )
    @addon_nav_parent.find('li > a').on('click', (e) =>
      e.preventDefault()
      @showIngredientSelection($(e.currentTarget))
    )
    @addon_filter.find('a').on('click', (e) =>
      e.preventDefault()
      @updateSelection($(e.currentTarget))
    )

  catchSelectionTrigger: () ->
    @addon_parent.find('div[data-is-open="true"] > a').on('click', (e) =>
      e.preventDefault()
      elm = $(e.currentTarget)
      @fireAddOnRequest(elm)
      @triggerMasterNavigation()
    )

  showIngredientSelection: (choice) ->
    @addon_nav_parent.find('li').removeClass('active')
    for selectable_link in @addon_parent.find('a.selectable')
      $(selectable_link).hide() unless $(selectable_link).hasClass('selected')
    @visibleSector().find(choice.data('ref') + ' > a.selectable').removeClass('hidden').show()
    choice.parent().addClass('active')

  updateSelection: (elm) ->
    list = []
    @addon_filter.removeClass('active')
    $(elm).parent().addClass('active')
    if $(elm).data('filter') == 'vegan'
      for cand in @addon_parent.find('.row > div.vegan')
        list.push($(cand).data('refid'))
      @hideIngredientExcept(list)
    else if $(elm).data('filter') == 'owns_addon'
      for cand in @addon_parent.find('.row > div.owns_addon')
        list.push($(cand).data('refid'))
      @hideIngredientInclude(list)
    else
      @freeAllIngredientLinks()

  freeAllIngredientLinks: ->
    for potential_link in @addon_parent.find('a')
      $(potential_link).addClass('selectable') unless $(potential_link).hasClass('selectable')

  hideIngredientExcept: (list) ->
    @freeAllIngredientLinks()
    for link in @addon_parent.find('a.selectable')
      console.log( list.indexOf($(link).parent().data('refid')) < 0 )
      $(link).removeClass('selectable') unless list.indexOf($(link).parent().data('refid')) < 0

  hideIngredientInclude: (list) ->
    @freeAllIngredientLinks()
    for link in @addon_parent.find('a.selectable')
      console.log( list.indexOf($(link).parent().data('refid')) < 0 )
      $(link).removeClass('selectable') if list.indexOf($(link).parent().data('refid')) < 0

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
              $(selection).addClass('hidden')
            $('<li><a href="#"><b>' + msg.added.name + '</b><br/><small>' +  msg.added.category + '</small></a></li>').appendTo(@selection_container)
            #   $(selection).find('a').addClass('selected')
            # $('<span class="glyphicon glyphicon-remove-circle"></span>').insertBefore(price_insensitives.find('span.text'))
            # @ingredient_collector.push(my_id)
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
    remove_order = $('#finalize > li > a')
    if free
      collect.attr({'data-target':'#presenter', 'data-slide-to': '1'})
      collect.removeClass('locked')
      price.attr({'data-target':'#presenter', 'data-slide-to': '2'})
      price.removeClass('locked')
      remove_order.removeClass('hidden').show()

  visibleSector: ->
    @addon_parent.find('> div:visible')

PitProneClient.visitor.init = () ->
  nav = new Navigation()
  nav.catchTrigger()
  nav.catchSelectionTrigger()

$ ->
  PitProneClient.visitor.init()


