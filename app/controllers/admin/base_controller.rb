module Admin
  class BaseController < ApplicationController
    include CrudResponses

    layout "admin"
    before_action :require_lab_member!
  end
end
