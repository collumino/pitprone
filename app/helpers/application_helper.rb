module ApplicationHelper
  def create_or_update_size
    content_tag(:div, class: 'row'){
      Pizza.size.keys.collect{|size|
        content_tag(:div, class: "col-lg-4 col-md-4 col-sm-4 #{size}_size#{ pizza_exists && pizza_exists == size ? ' selected' : '' }"){
          link_to("<span>#{t(size)} <br/><small>∅ #{Pizza.size[size]} cm</small></span>".html_safe, '#',
            data: { ref: api_orders_path, http_verb: 'post', value: size }
          )
        }
      }.join('').html_safe
    }
  end

  def present_boolean(bool)
    return content_tag(:span, class: 'glyphicon glyphicon-remove'){} unless bool
    content_tag(:span, class: 'glyphicon glyphicon-ok'){}
  end

  def generate_ingredient_link(ingredient, options = { title: '' })
    name = content_tag(:span , class: 'text'){ ingredient.name }
    name += content_tag( :span, class: 'price pull-right' ){ number_to_currency(ingredient.price) }
    if ingredient.owns_add_ons.any?
      title = 'ethält ' + ingredient.owns_add_ons.collect{|sym| I18n.t(sym) }.join(', ')
      options.merge!({title: title,  data: { toggle: 'tooltip', placement: 'bottom' }, class: 'info glyphicon glyphicon-info-sign pull-right' })
      name += content_tag( :span , options ){}
    end

    link_to( name.html_safe, '#' )
  end

  def ingredient_class(ingredient)
    return 'vegan' if ingredient.vegan
    'owns_addon' if ingredient.owns_add_ons.any?
  end

  def pizza_exists
    if @order.pizza_in_progress.present?
      weight = @order.pizza_in_progress.size_factor
      @actual_pizza = Pizza.size_name(weight)
    end
    @actual_pizza ||= ''
  end

end
