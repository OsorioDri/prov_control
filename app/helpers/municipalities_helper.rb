module MunicipalitiesHelper
  def icons(state)
    if state
      content_tag(:i, nil, class: 'fa-solid fa-square-check text-success')
    else
      content_tag(:i, nil, class: 'fa-solid fa-square-xmark text-danger')
    end
  end
end
