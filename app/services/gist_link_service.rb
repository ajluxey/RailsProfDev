class GistLinkService
  GIST_URL_REGEX = /gist\.github\.com/
  GIST_ACCESS_TOKEN = Rails.application.credentials.github_gists_token

  def self.link_is_gist?(link)
    link.url.match? GIST_URL_REGEX
  end

  def self.get_html_gist_from(link)
    gist_link = new(link.url)
    gist_link.get_html
  end

  def initialize(url)
    @gist = Octokit::Gist.from_url(url)
    @gist.id = @gist.id.partition('/').last
    @client = Octokit::Client.new(access_token: GIST_ACCESS_TOKEN)
  end

  def get_html
    files = get_gist_files
    gist_html = files&.map{ |name, attributes| file_to_html(name, attributes) }.join
    gist_html ||= 'Something wrong with getting files'
  end

  private

  def get_gist_files
    @client.gist(@gist.id).files
  end

  def file_to_html(name, attributes)
    file_html = "<h4>#{name}</h4>"
    file_html += "<p>#{attributes[:content].split("\n").join('<br>')}</p>"
  end
end
