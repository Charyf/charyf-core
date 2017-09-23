RSpec.describe Charyf do
  it "has a version number" do
    expect(Charyf::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end

  it "sig is required" do
    expect(require 'sig').to eq(false)
  end
end
