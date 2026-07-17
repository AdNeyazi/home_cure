module ApplicationHelper
  def admin_sidebar_active?(section)
    admin_subnav_active?(section)
  end

  def platform_sidebar_active?(section)
    case section
    when :dashboard
      controller_path == "platform/dashboard"
    when :labs
      controller_path == "platform/labs"
    when :blog_posts
      controller_path == "platform/blog_posts"
    when :contact_inquiries
      controller_path == "platform/contact_inquiries"
    else
      false
    end
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
    when :test_packages
      controller_path == "admin/test_packages"
    when :bills
      controller_path == "admin/bills"
    when :reports
      controller_path == "admin/reports"
    when :referral_reports
      controller_path == "admin/referral_reports"
    when :staff
      controller_path == "admin/staff"
    else
      false
    end
  end

  def admin_breadcrumb_items
    return [] unless controller_path.start_with?("admin/")

    if controller_path == "admin/dashboard"
      return [ { label: "Dashboard", current: true } ]
    end

    section = controller_name
    section_path = admin_section_collection_path(section)
    items = [
      { label: "Dashboard", path: admin_dashboard_path },
      { label: section_breadcrumb_label(section), path: section_path }
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

  def patient_display_id(patient)
    "PAT#{patient.id.to_s.rjust(5, "0")}"
  end

  def report_display_id(report)
    "REP#{report.id.to_s.rjust(5, "0")}"
  end

  def report_status_badge(report)
    if report.file_path.present?
      { label: "Completed", variant: "completed" }
    else
      { label: "In Process", variant: "in-process" }
    end
  end

  def patient_age_gender(patient)
    age = patient.age.presence
    gender = patient.gender.to_s.strip.presence&.downcase
    return "—" if age.blank? && gender.blank?
    return age.to_s if gender.blank?
    return gender if age.blank?

    "#{age} · #{gender}"
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

  def section_breadcrumb_label(section)
    case section
    when "bills" then "Payments"
    when "tests" then "Tests & Packages"
    when "test_packages" then "Packages"
    when "staff" then "Staff"
    else section.titleize
    end
  end

  def admin_section_collection_path(section)
    # Uncountable resources like "staff" expose index as admin_staff_index_path,
    # while admin_staff_path is the member route and requires :id.
    index_helper = "admin_#{section}_index_path"
    return public_send(index_helper) if respond_to?(index_helper)

    public_send("admin_#{section}_path")
  end

  def resource_name_for_breadcrumb(resource, section)
    return "#{section.singularize.titleize} Details" if resource.blank?
    return resource.full_name if resource.respond_to?(:full_name) && resource.full_name.present?
    return resource.name if resource.respond_to?(:name) && resource.name.present?
    return "##{resource.id}" if resource.respond_to?(:id)

    "#{section.singularize.titleize} Details"
  end
end
