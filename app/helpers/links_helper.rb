module LinksHelper
  def links_for(resource)
    if resource.links.count.positive?
      content_tag :div, class: "links" do
        concat content_tag(:p, 'Links:')
        links_list = content_tag :ul do
          resource.links.each do |link|
            if GistLinkService.link_is_gist?(link)
              concat content_tag :li, link_to_gist(link)
            else
              concat content_tag :li, link_to(link.name, link.url, target: '_blank')
            end
          end
        end
        concat links_list
      end
    end
  end

  def link_to_gist(link)
    content_tag :div, class: 'gist' do
      concat content_tag :h3, link.name
      concat GistLinkService.get_html_gist_from(link).html_safe
    end
  end
end
