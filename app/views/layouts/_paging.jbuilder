json.paging do
  json.current_page resources.current_page
  json.total_pages resources.total_pages
  json.total_count resources.total_count
end
