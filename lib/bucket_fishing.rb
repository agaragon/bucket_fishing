# frozen_string_literal: true

require_relative "bucket_fishing/version"

module BucketFishing
  class Error < StandardError; end
  # Your code goes here...
  module_function

  def hello
    "Hello, world!"
  end
end
