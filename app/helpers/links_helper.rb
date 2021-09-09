module LinksHelper
  def links_for(resource)
    if resource.links.count.positive?
      content_tag :div, class: "links" do
        concat content_tag(:p, 'Links:')
        links_list = content_tag :ul do
          resource.links.each do |link|
            concat content_tag :li, link_to(link.name, link.url, target: '_blank')
          end
        end
        concat links_list
      end
    end
  end
end
