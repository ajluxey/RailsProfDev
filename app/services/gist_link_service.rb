class GistLinkService
  attr_reader :gist, :client
  GIST_URL_REGEX = /gist\.github\.com/
  GIST_ACCESS_TOKEN = Rails.application.credentials.github_gists_token

  GistFiles = Struct.new(:files) do
    def success?
      files.present?
    end
  end

  def self.link_is_gist?(url)
    url =~ GIST_URL_REGEX ? true : false
  end

  def initialize(url)
    if self.class.link_is_gist?(url)
      set_gist(url)
      @client = Octokit::Client.new(access_token: GIST_ACCESS_TOKEN)
    end
  end

  def get_gist_files
    GistFiles.new(@client.gist(@gist.id).files)
  end

  def is_gist?
    @gist.url =~ GIST_URL_REGEX ? true : false
  end

  private

  def set_gist(url)
    @gist = Octokit::Gist.from_url(url)
    @gist.id = @gist.id.partition('/').last
  end
end
