module Admin
  module CrudResponses
    extend ActiveSupport::Concern

    private

    def redirect_created(path, resource_name)
      redirect_to path, notice: "#{resource_name} created successfully."
    end

    def redirect_updated(path, resource_name)
      redirect_to path, notice: "#{resource_name} updated successfully."
    end

    def redirect_deleted(path, resource_name)
      redirect_to path, notice: "#{resource_name} deleted successfully."
    end

    def redirect_with_errors(path, resource)
      redirect_to path, alert: resource.errors.full_messages.to_sentence
    end

    def render_form_failure(template)
      render template, status: :unprocessable_entity
    end
  end
end
