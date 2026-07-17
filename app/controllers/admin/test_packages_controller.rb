module Admin
  class TestPackagesController < BaseController
    before_action :set_test_package, only: %i[edit update destroy]
    before_action :load_tests, only: %i[new create edit update]

    def index
      redirect_to admin_tests_path(tab: "packages", q: params[:q])
    end

    def new
      @test_package = TestPackage.new
    end

    def create
      @test_package = TestPackage.new(test_package_params)
      assign_tests

      if @test_package.save
        redirect_created admin_test_packages_path, "Test package"
      else
        render_form_failure :new
      end
    end

    def edit; end

    def update
      @test_package.assign_attributes(test_package_params)
      assign_tests

      if @test_package.save
        redirect_updated admin_test_packages_path, "Test package"
      else
        render_form_failure :edit
      end
    end

    def destroy
      if @test_package.destroy
        redirect_deleted admin_test_packages_path, "Test package"
      else
        redirect_with_errors admin_test_packages_path, @test_package
      end
    end

    private

    def set_test_package
      @test_package = TestPackage.find(params[:id])
    end

    def test_package_params
      params.require(:test_package).permit(:code, :name, :description, :price)
    end

    def selected_test_ids
      params.fetch(:test_package, {}).fetch(:test_ids, [])
    end

    def assign_tests
      @test_package.test_ids = selected_test_ids.reject(&:blank?)
    end

    def load_tests
      @tests = Test.alphabetical
    end
  end
end
