PitProneClient = window.PitProneClient = window.PitProneClient or {}

PitProneClient.visitor = {}

class Navigation
  constructor: ->
    @size_nav = $('#get_size > .row > div')
    @selection_nav = $('#ingredient_selector > li')
    @selection_filter_nav = $('#ingredient_filter > li')
    @selection_container = $('.ingredient_list > .row > div')

  catchTrigger: ->
    @size_nav.find('a').on('click', (e) => @fireSizeEvent($(e.currentTarget)) )
    @selection_nav.find('a').on('click', (e) => @toggleIngredientView($(e.currentTarget)) )
    @selection_filter_nav.find('a').on('click', (e) => @toggleSelectorFilter($(e.currentTarget)) )

  fireSizeEvent: (elm) ->
    $.ajax({
      type: elm.data('http-verb'),
      url: '/api/orders',
      data:{ size: elm.data('value') },
      beforeSend: (request) ->
        request.setRequestHeader("X-User", PitProneClient.user)
        request.setRequestHeader("X-Token", PitProneClient.token)
    }).success( (msg) =>
      @current_size = elm.data('value')
      @updateSizeNav(elm)
      @updateMasterNav(msg)
      @render()
      $('#presenter').carousel(1)
    )

  updateMasterNav: (msg) ->
    $('.carousel-indicators #pizza_size').html(msg.size)
    $('.carousel-indicators #addon_collector').html(msg.amount || 0)
    $('.carousel-indicators #pizza_price').html(msg.costs)
    @unlockMasterNav()

  updateSizeNav: (active) ->
    @size_nav.removeClass('selected')
    @size_nav.find('a').attr('data-http-verb', 'patch')
    active.parent().addClass('selected')

  updateSelectorNav: (active) ->
    @selection_nav.removeClass('active')
    active.parent().addClass('active')
    active.blur()

  updateFilterNav: (active) ->
    @selection_filter_nav.removeClass('active')
    active.parent().addClass('active')

  toggleSelectorFilter: (choice) ->
    @updateFilterNav(choice)
    @render(choice.data('filter'))

  render: ( filter= null ) ->
    @selection_container.hide()
    if filter?
      @lockFilterMatches(filter)
    @selection_container.filter('div[data-category="' + @currentCat() + '"][data-sizing="' + @currentSize() + '"]').show()

  toggleIngredientView: (choice) ->
    @current_cat = choice.data('ref')
    @updateSelectorNav(choice)
    @render()

  lockFilterMatches: (filter) ->
    @selection_container.removeClass('hidden')
    switch filter
      when 'vegan'
        @selection_container.filter( (index, item) -> $(item).data('tags').indexOf(filter) == -1).addClass('hidden')
      when 'owns_addon'
        @selection_container.filter( (index, item) -> $(item).data('tags').indexOf(filter) > -1 ).addClass('hidden')

  unlockMasterNav: ->
    collect = $('.carousel-indicators #addon_collector').closest('li')
    collect.attr({'data-target':'#presenter', 'data-slide-to': '1'})
    collect.removeClass('locked')

    price = $('.carousel-indicators #pizza_price').closest('li')
    price.attr({'data-target':'#presenter', 'data-slide-to': '2'})
    price.removeClass('locked')

  currentCat: ->
    @current_cat ? @selection_nav.filter('.active').find('a').data('ref')

  currentSize: ->
    @current_size ? @size_nav.filter('.selected').find('a').data('value')

  fitered = (obj, predicate) ->
    res = {}
    res[k] = v for k, v of obj when not predicate k, v
    res

PitProneClient.visitor.init = () ->
  nav = new Navigation()
  nav.catchTrigger()

$ ->
  PitProneClient.visitor.init()
