require "cloudcms"

cloudcms = Cloudcms::Cloudcms.new()
platform = cloudcms.connect()

# puts('connected')
# puts(platform.@driver.@config['baseURL'])

RSpec.describe Cloudcms do
  it "has a version number" do
    expect(Cloudcms::VERSION).not_to be nil
  end

  it "established a connection" do
    expect(platform).not_to be nil
  end
end
