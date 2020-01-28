# frozen_string_literal: true

RSpec.describe OpenSSL::SignatureAlgorithm do
  it "has a version number" do
    expect(OpenSSL::SignatureAlgorithm::VERSION).not_to be nil
  end
end
