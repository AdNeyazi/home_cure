module Admin
  class TestsController < BaseController
    before_action :set_test, only: %i[edit update destroy]

    def index
      @tests = Test.recent_first
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
