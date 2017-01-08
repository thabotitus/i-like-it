class Like
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :likeable_content
end