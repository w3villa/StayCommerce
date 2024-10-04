Mobility.configure do |config|
  config.plugins do
    backend :table
    active_record
    reader
    writer
    backend_reader
    query
    cache
    fallbacks
    locale_accessors
    presence
    dirty
  end

  config.defaults[:fallbacks] = true
end
