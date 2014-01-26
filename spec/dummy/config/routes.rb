
Rails.application.routes.draw do
  mount DryAuth::Engine => "/auth"
  mount McpCommon::Engine => "/common"
  root to: McpCommon::Engine
end
