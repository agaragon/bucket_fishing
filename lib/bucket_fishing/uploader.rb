# lib/bucket_fishing/uploader.rb
require 'aws-sdk-s3'

module BucketFishing
  class Uploader
    def initialize(bucket_name, aws_credentials = {})
      @bucket_name = bucket_name
      @s3_client = Aws::S3::Client.new(
        region: aws_credentials[:region] || 'us-east-1',
        credentials: Aws::Credentials.new(
          aws_credentials[:access_key_id] || ENV['AWS_ACCESS_KEY_ID'],
          aws_credentials[:secret_access_key] || ENV['AWS_SECRET_ACCESS_KEY']
        )
      )
    end

    def upload_stream(stream, key, options = {})
      raise ArgumentError, "Stream must be a StringIO object" unless stream.is_a?(StringIO)
      
      # Reset stream position to beginning to ensure we read all content
      stream.rewind
      
      # Set default options
      default_options = {
        content_type: 'application/octet-stream',
        acl: 'private'
      }
      
      upload_options = default_options.merge(options)

      begin
        @s3_client.put_object(
          bucket: @bucket_name,
          key: key,
          body: stream,
          content_type: upload_options[:content_type],
          acl: upload_options[:acl]
        )
        
        # Return the URL of the uploaded object
        "https://#{@bucket_name}.s3.amazonaws.com/#{key}"
      rescue Aws::S3::Errors::ServiceError => e
        raise "Failed to upload to S3: #{e.message}"
      end
    end
  end
end