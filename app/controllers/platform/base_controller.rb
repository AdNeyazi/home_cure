module Platform
  class BaseController < ApplicationController
    include Admin::CrudResponses

    layout "platform"
    before_action :require_super_admin!
  end
end
