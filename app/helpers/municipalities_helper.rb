module MunicipalitiesHelper
  def icons(state)
    if state
      content_tag(:i, nil, class: 'fa-solid fa-square-check text-success')
    else
      content_tag(:i, nil, class: 'fa-solid fa-square-xmark text-danger')
    end
  end

  def batch_exist(item) 
    if item.nil? 
      ""
    else
      item.start_date.strftime("%d/%m/%Y")
    end
  end

  def date_exist(item)
    if item.nil?
      ""
    else
      item.strftime("%d/%m/%Y")
    end
  end

  def official_letter_exist(item)
    if item.nil?
      ""
    else
      item.strftime("%d/%m/%Y")
    end
  end
end
