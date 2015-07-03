module ApplicationHelper

  def create_or_update_size
    content_tag(:div, class: 'row'){
      Pizza.measures.keys.collect{|size|
        content_tag(:div, class: "col-lg-4 col-md-4 col-sm-4 #{size}_size#{ current_pizza && current_pizza.size == size ? ' selected' : '' }"){
          link_to("<span>#{t(size)} <br/><small>∅ #{Pizza.measures[size]} cm</small></span>".html_safe, '#',
            data: { http_verb: ( current_pizza ? 'patch' : 'post'), value: size }
          )
        }
      }.join('').html_safe
    }
  end

  # def hide_or_live_from_size(size)
  #   return '' if current_pizza.present? && current_pizza.size == size
  #   'hidden'
  # end

  def key_identifier(key)
    key.downcase.gsub(%r{\s+},'_')
  end

  def current_pizza
    return nil unless @order
    @order.pizza_in_progress
  end

  def customize_boxes
    opened_category_key = @ingredients.keys.reverse.first

    Pizza.sizes_and_weights.collect{ |size, weight|
      options= { sizing: size }
      @ingredients.each_with_index.collect{ |( key, list ), index|
        options.merge!({ category: key_identifier(key) , is_open: key == opened_category_key })
        list.each_with_index.collect{ |ingredient, sec_index|
          options.merge!({ tags: ingredient.tags, sibling: "item_#{index}-#{sec_index}" } )
          generate_ingredient_box(ingredient, options , weight)
        }
      }
    }.flatten.join('').html_safe
  end

  def generate_ingredient_box(ingredient, options, weight)
    hide_class = ingredient_is_selected?(ingredient) ? 'hidden' : nil
    hide_style = ( options[:is_open] && current_pizza && current_pizza.size == options[:sizing] ) ? 'display: block' : 'display: none'

    content_tag(:div, class: ['col-lg-3', 'col-md-4', 'col-sm-6', 'col-xs-12', hide_class].compact, data: options , style: hide_style){
      generate_ingredient_link(ingredient, weight)
    }
  end

  def generate_ingredient_link(ingredient, weight)
    name = content_tag(:span , class: 'text'){ ingredient.name }
    name += content_tag( :span, class: 'price pull-right' ){ number_to_currency(ingredient.price * weight) }

    if ingredient.owns_add_ons.any?
      title = 'enthält ' + ingredient.owns_add_ons.collect{|sym| I18n.t(sym) }.join(', ')
      tooltip_options = {title: title,  data: { toggle: 'tooltip', placement: 'bottom' }, class: 'info glyphicon glyphicon-info-sign pull-right' }
      name += content_tag( :span , tooltip_options ){}
    end

    link_to( name.html_safe, '#' )
  end


  # def generate_ingredient_link(ingredient, hidden, multiplicator, tooltip_options= { title: '' })
  #   name = content_tag(:span , class: 'text'){ ingredient.name }
  #   name += content_tag( :span, class: 'price pull-right' ){ number_to_currency(ingredient.price * multiplicator) }
  #
  #   if ingredient.owns_add_ons.any?
  #     title = 'enthält ' + ingredient.owns_add_ons.collect{|sym| I18n.t(sym) }.join(', ')
  #     tooltip_options.merge!({title: title,  data: { toggle: 'tooltip', placement: 'bottom' }, class: 'info glyphicon glyphicon-info-sign pull-right' })
  #     name += content_tag( :span , tooltip_options ){}
  #   end
  #
  #   if ingredient_is_selected?(ingredient)
  #     name = content_tag( :span , class: 'glyphicon glyphicon-remove-circle' ){} + name
  #   end
  #
  #   link_to( name.html_safe, '#' , class: generate_class_tags(hidden, ingredient))
  # end

  # def generate_class_tags( hide_requested, ingredient )
  #   collect = ['selectable']
  #   collect << 'selected' if ingredient_is_selected?(ingredient)
  #   collect << 'hidden' if hide_requested && ! ingredient_is_selected?(ingredient)
  #   collect.join(' ')
  # end

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
