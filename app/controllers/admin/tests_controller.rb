module Admin
  class TestsController < BaseController
    before_action :set_test, only: %i[edit update destroy]

    def index
      @tab = params[:tab].to_s == "packages" ? "packages" : "tests"
      @q = params[:q].to_s.strip

      tests_scope = Test.all
      tests_scope = tests_scope.search(@q) if @q.present?
      @tests = tests_scope.recent_first
      @tests_count = @q.present? ? @tests.size : Test.count

      packages_scope = TestPackage.includes(:tests)
      packages_scope = packages_scope.search(@q) if @q.present?
      @test_packages = packages_scope.recent_first
      @packages_count = @q.present? ? @test_packages.size : TestPackage.count
    end

    def new
      @test = Test.new
    end

    def create
      @test = Test.new(test_params)
      if @test.save
        redirect_created admin_tests_path, "Test"
      else
        render_form_failure :new
      end
    end

    def edit; end

    def update
      if @test.update(test_params)
        redirect_updated admin_tests_path, "Test"
      else
        render_form_failure :edit
      end
    end

    def destroy
      if @test.destroy
        redirect_deleted admin_tests_path, "Test"
      else
        redirect_with_errors admin_tests_path, @test
      end
    end

    private

    def set_test
      @test = Test.find(params[:id])
    end

    def test_params
      params.require(:test).permit(:code, :name, :description, :price)
    end
  end
end
