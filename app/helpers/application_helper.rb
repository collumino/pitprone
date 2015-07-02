module ApplicationHelper

  def create_or_update_size
    content_tag(:div, class: 'row'){
      Pizza.measures.keys.collect{|size|
        content_tag(:div, class: "col-lg-4 col-md-4 col-sm-4 #{size}_size#{ current_pizza && current_pizza.size == size ? ' selected' : '' }"){
          link_to("<span>#{t(size)} <br/><small>∅ #{Pizza.measures[size]} cm</small></span>".html_safe, '#',
            data: { ref: api_orders_path, http_verb: ( current_pizza ? 'patch' : 'post'), value: size }
          )
        }
      }.join('').html_safe
    }
  end

  def current_pizza
    return nil unless @order
    @order.pizza_in_progress
  end

  def generate_ingredient_link(ingredient, hidden, multiplicator, tooltip_options= { title: '' })
    name = content_tag(:span , class: 'text'){ ingredient.name }
    name += content_tag( :span, class: 'price pull-right' ){ number_to_currency(ingredient.price * multiplicator) }

    if ingredient.owns_add_ons.any?
      title = 'enthält ' + ingredient.owns_add_ons.collect{|sym| I18n.t(sym) }.join(', ')
      tooltip_options.merge!({title: title,  data: { toggle: 'tooltip', placement: 'bottom' }, class: 'info glyphicon glyphicon-info-sign pull-right' })
      name += content_tag( :span , tooltip_options ){}
    end

    if ingredient_is_selected?(ingredient)
      name = content_tag( :span , class: 'glyphicon glyphicon-remove-circle' ){} + name
    end

    link_to( name.html_safe, '#' , class: generate_class_tags(hidden, ingredient))
  end

  def generate_class_tags( hide_requested, ingredient )
    collect = ['selectable']
    collect << 'selected' if ingredient_is_selected?(ingredient)
    collect << 'hidden' if hide_requested && ! ingredient_is_selected?(ingredient)
    collect.join(' ')
  end

  def ingredient_is_selected?(ingredient)
    return false unless current_pizza
    current_pizza.pizza_items.collect{|pit| pit.ingredient }.include?(ingredient)
  end

  def configure_links_to
    current_pizza && current_pizza.size ? { data: { target: '#presenter' , slide: { to: '1' }} } : { class: 'locked' }
  end

  def checkout_links_to
    current_pizza && current_pizza.total > 0 ?  {data: { target: '#presenter' , slide: { to: '2' }}} : { class: 'locked' }
  end

end
