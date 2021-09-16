module LinksHelper
  def links_for(resource)
    if resource.links.count.positive?
      content_tag :div, class: "links" do
        concat content_tag(:p, 'Links:')
        links_list = content_tag :ul do
          resource.links.each do |link|
            if GistLinkService.link_is_gist?(link.url)
              concat link_to_gist(link)
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
    gist_link = GistLinkService.new(link.url)
    response = gist_link.get_gist_files

    if response.success?
      content_tag :div, class: 'gist' do
        concat content_tag :h3, link.name
        response.files.each do |filename, file_attributes|
          concat content_tag :h4, filename
          concat content_tag :text_area, file_attributes[:content]
        end
      end
    end
  end
end
