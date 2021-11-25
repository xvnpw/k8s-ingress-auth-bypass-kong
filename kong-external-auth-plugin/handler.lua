local BasePlugin = require "kong.plugins.base_plugin"
local http = require "resty.http"

local ExternalAuthHandler = BasePlugin:extend()

function ExternalAuthHandler:new()
  ExternalAuthHandler.super.new(self, "external-auth")
end

function ExternalAuthHandler:access(conf)
  ExternalAuthHandler.super.access(self)

  local client = http.new()
  client:set_timeouts(conf.connect_timeout, send_timeout, read_timeout)

  local res, err = client:request_uri(conf.url, {
    method = "GET",
    ssl_verify = false,
    headers = {
      ["X-Original-Uri"] = ngx.var.request_uri,
      ["X-Forwarded-Path"] = kong.request.get_path(),
      ["X-Forwarded-Method"] = kong.request.get_method(),
      ["X-Forwarded-Query"] = kong.request.get_raw_query(),
      ["X-Api-Key"] = kong.request.get_headers()["X-Api-Key"]
    }
  })

  if not res then
    return kong.response.exit(500)
  end

  if res.status ~= 200 then
    return kong.response.exit(401)
  end
end

ExternalAuthHandler.PRIORITY = 900

return ExternalAuthHandler