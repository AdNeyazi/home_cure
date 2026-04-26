module ApplicationHelper
  def admin_sidebar_active?(section)
    admin_subnav_active?(section)
  end

  def admin_subnav_active?(section)
    case section
    when :dashboard
      controller_path == "admin/dashboard"
    when :patients
      controller_path == "admin/patients"
    when :doctors
      controller_path == "admin/doctors"
    when :tests
      controller_path == "admin/tests"
    when :bills
      controller_path == "admin/bills"
    when :reports
      controller_path == "admin/reports"
    when :referral_reports
      controller_path == "admin/referral_reports"
    when :blog_posts
      controller_path == "admin/blog_posts"
    when :contact_inquiries
      controller_path == "admin/contact_inquiries"
    else
      false
    end
  end

  def admin_breadcrumb_items
    return [] unless controller_path.start_with?("admin/")

    if controller_path == "admin/dashboard"
      return [{ label: "Dashboard", current: true }]
    end

    section = controller_name
    section_path = send("admin_#{section}_path")
    items = [
      { label: "Dashboard", path: admin_dashboard_path },
      { label: section.titleize, path: section_path }
    ]

    case action_name
    when "index"
      items.last[:path] = nil
      items.last[:current] = true
    when "new"
      items << { label: "New", current: true }
    when "edit"
      items << { label: "Edit", current: true }
    when "show"
      resource = instance_variable_get("@#{section.singularize}")
      label = resource_name_for_breadcrumb(resource, section)
      items << { label: label, current: true }
    else
      items.last[:path] = nil
      items.last[:current] = true
    end

    items
  end

  def patient_initials(full_name)
    words = full_name.to_s.strip.split(/\s+/)
    letters = words.map { |w| w[0] }.join
    letters = full_name.to_s.strip.gsub(/\s+/, "")[0, 2] if letters.length < 2
    letters.upcase[0, 2]
  end

  def patient_avatar_tone(patient)
    %w[tone-a tone-b tone-c tone-d tone-e][patient.id % 5]
  end

  def patient_bill_status_badge(patient)
    bill = patient.primary_bill
    return { label: "—", variant: "muted" } unless bill

    if bill.status == "pending" && patient.reports.any?
      return { label: "Processing", variant: "info" }
    end

    case bill.status
    when "paid"
      { label: "Completed", variant: "success" }
    when "pending"
      { label: "Pending", variant: "warning" }
    when "cancelled"
      { label: "Cancelled", variant: "muted" }
    else
      { label: bill.status.titleize, variant: "muted" }
    end
  end

  private

  def resource_name_for_breadcrumb(resource, section)
    return "#{section.singularize.titleize} Details" if resource.blank?
    return resource.full_name if resource.respond_to?(:full_name) && resource.full_name.present?
    return resource.name if resource.respond_to?(:name) && resource.name.present?
    return "##{resource.id}" if resource.respond_to?(:id)

    "#{section.singularize.titleize} Details"
  end
end
