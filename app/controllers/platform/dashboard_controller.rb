module Platform
  class DashboardController < BaseController
    def index
      @labs_count = Lab.count
      @active_labs_count = Lab.active.count
      @users_count = User.where.not(role: "super_admin").count
      @recent_labs = Lab.recent_first.limit(8)
    end
  end
end
