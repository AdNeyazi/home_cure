# admin_email = ENV.fetch("ADMIN_EMAIL", "admin@homecurelab.com")
# admin_password = ENV.fetch("ADMIN_PASSWORD", "Admin@12345")

# admin = User.find_or_initialize_by(email: admin_email)
# admin.role = "admin"
# admin.password = admin_password if admin.new_record?
# admin.password_confirmation = admin_password if admin.new_record?
# admin.save!

# puts "Admin user ready: #{admin.email}"

# [
#   { code: "CBC", name: "Complete Blood Count", price: 350 },
#   { code: "LFT", name: "Liver Function Test", price: 700 },
#   { code: "KFT", name: "Kidney Function Test", price: 750 }
# ].each do |test_attrs|
#   Test.find_or_create_by!(code: test_attrs[:code]) do |test|
#     test.name = test_attrs[:name]
#     test.price = test_attrs[:price]
#   end
# end

# puts "Default tests seeded."

blog_posts = [
  {
    title: "Fasting Blood Test Guide: What to Eat and Avoid",
    slug: "fasting-blood-test-guide",
    category: "Preventive Care",
    author_name: "Dr. Sana Ahmed",
    cover_image_url: "https://images.unsplash.com/photo-1579154204601-01588f351e67?auto=format&fit=crop&w=1400&q=80",
    excerpt: "Everything you need to know before a fasting blood test, including preparation tips and common mistakes.",
    content: <<~CONTENT,
      Fasting blood tests are commonly used for glucose, lipid profile, and other metabolic markers.

      In most cases, you should avoid food for 8 to 12 hours before the sample collection. You can drink plain water, and staying hydrated is recommended.

      Avoid sugary drinks, tea, coffee, and alcohol before the test window. If you take chronic medications, confirm with your doctor whether to continue them before testing.

      Proper preparation improves test accuracy and helps your doctor make better treatment decisions.
    CONTENT
    featured: true,
    published: true,
    published_at: 10.days.ago,
    reviewer_name: "Dr. M. Rahman",
    reviewed_at: 9.days.ago,
    preparation_tips: "Drink plain water before your appointment\nAvoid tea, coffee, and sugary drinks during fasting window\nShare current medications with your doctor",
    faq_items: "Can I drink water while fasting? || Yes, plain water is allowed and recommended.\nCan I take my morning medicine? || Confirm with your doctor before the test.\nHow long should I fast? || Usually 8 to 12 hours, based on your test panel.",
    medical_disclaimer: "This article is for educational awareness. Please consult your physician for diagnosis and treatment advice."
  },
  {
    title: "Thyroid Profile: When You Should Get Tested",
    slug: "thyroid-profile-when-to-test",
    category: "Thyroid",
    author_name: "Dr. R. Menon",
    cover_image_url: "https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&w=1400&q=80",
    excerpt: "Know the common symptoms and risk factors that indicate you may need a thyroid profile test.",
    content: <<~CONTENT,
      Thyroid disorders can present as fatigue, hair fall, weight change, mood swings, and menstrual irregularities.

      A thyroid profile usually includes T3, T4, and TSH values. These markers help identify hypo- or hyper-thyroidism.

      If you have symptoms, family history, pregnancy planning, or existing thyroid treatment, periodic testing is important.
    CONTENT
    featured: false,
    published: true,
    published_at: 8.days.ago,
    reviewer_name: "Dr. Neha Sinha",
    reviewed_at: 7.days.ago,
    preparation_tips: "Carry previous thyroid reports for comparison\nPrefer consistent test timing for follow-up visits\nDiscuss thyroid medicines with your clinician before testing",
    faq_items: "Do thyroid tests require fasting? || Usually no, unless your doctor advises otherwise.\nHow often should I test? || Frequency depends on symptoms and treatment status.\nCan stress affect thyroid values? || Stress can affect symptoms and sometimes influence hormone balance."
  },
  {
    title: "CBC Report Explained in Simple Language",
    slug: "cbc-report-explained",
    category: "Blood Tests",
    author_name: "Lab Education Team",
    cover_image_url: "https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&w=1400&q=80",
    excerpt: "Understand hemoglobin, WBC, RBC, and platelet values without medical jargon.",
    content: <<~CONTENT,
      Complete Blood Count (CBC) is one of the most commonly ordered tests.

      Hemoglobin reflects oxygen-carrying capacity. White blood cells may rise during infection. Platelets support clotting and bleeding control.

      A single abnormal value does not always indicate disease, but it should be reviewed with symptoms and medical history.
    CONTENT
    featured: false,
    published: true,
    published_at: 7.days.ago,
    reviewer_name: "Lab Quality Team",
    reviewed_at: 6.days.ago,
    preparation_tips: "No strict fasting is generally needed for CBC\nStay hydrated before sample collection\nInform staff if you feel dizzy during blood draw",
    faq_items: "Does low hemoglobin always mean severe disease? || Not always; interpretation depends on context.\nCan infection raise WBC count? || Yes, infections commonly raise white cells.\nShould I repeat CBC after treatment? || Your doctor may advise a follow-up CBC."
  },
  {
    title: "Lipid Profile Preparation Checklist",
    slug: "lipid-profile-preparation-checklist",
    category: "Heart Health",
    author_name: "Dr. Pooja Nair",
    cover_image_url: "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?auto=format&fit=crop&w=1400&q=80",
    excerpt: "A quick checklist to prepare for your cholesterol test and get reliable results.",
    content: <<~CONTENT,
      Lipid profile includes total cholesterol, LDL, HDL, and triglycerides.

      Follow your fasting instructions carefully, avoid alcohol prior to test day, and inform your clinician about current medications.

      Lifestyle changes such as diet improvement and activity can significantly improve future lipid values.
    CONTENT
    featured: false,
    published: true,
    published_at: 6.days.ago,
    reviewer_name: "Dr. Arjun Nair",
    reviewed_at: 5.days.ago,
    preparation_tips: "Follow fasting duration exactly as advised\nAvoid heavy meals and alcohol before the test day\nBring your previous lipid reports",
    faq_items: "Can I exercise before lipid test? || Avoid intense exercise right before sampling.\nWhy is fasting advised? || It improves triglyceride accuracy.\nHow soon can lipid values improve? || Improvements may appear in 6 to 12 weeks with lifestyle changes."
  },
  {
    title: "Vitamin D Deficiency: Signs You Should Not Ignore",
    slug: "vitamin-d-deficiency-signs",
    category: "Nutrition",
    author_name: "Lab Education Team",
    cover_image_url: "https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=1400&q=80",
    excerpt: "Low energy, bone pain, and frequent fatigue may be linked to low vitamin D levels.",
    content: <<~CONTENT,
      Vitamin D is essential for bone health, immune function, and muscle strength.

      Deficiency is common in indoor workers and people with low sun exposure.

      A blood test confirms your status, and supplementation should be guided by a clinician.
    CONTENT
    featured: false,
    published: true,
    published_at: 5.days.ago,
    reviewer_name: "Dr. Pooja Nair",
    reviewed_at: 4.days.ago,
    preparation_tips: "Morning sample timing is often preferred\nList any supplements already in use\nAvoid self-medicating without lab confirmation",
    faq_items: "Can low vitamin D cause fatigue? || Yes, persistent fatigue can be associated with low levels.\nShould I start supplements directly? || Confirm deficiency and dose with your doctor.\nHow long to recheck levels? || Commonly after 8 to 12 weeks of treatment."
  },
  {
    title: "Kidney Function Test: What Creatinine and Urea Mean",
    slug: "kidney-function-test-creatinine-urea",
    category: "Kidney Care",
    author_name: "Dr. Arjun Nair",
    cover_image_url: "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1400&q=80",
    excerpt: "A beginner-friendly guide to understanding core markers in your kidney function report.",
    content: <<~CONTENT,
      Kidney function tests evaluate filtration and waste clearance in the body.

      Creatinine, urea, and related calculations help identify early kidney stress.

      People with diabetes, hypertension, or long-term medication use should monitor kidney parameters regularly.
    CONTENT
    featured: false,
    published: true,
    published_at: 4.days.ago,
    reviewer_name: "Dr. R. Menon",
    reviewed_at: 3.days.ago,
    preparation_tips: "Share blood pressure and diabetes history\nBring previous kidney reports if available\nStay hydrated unless your doctor advises fluid restriction",
    faq_items: "Does high creatinine always mean kidney failure? || Not always; it requires clinical interpretation.\nCan dehydration affect urea values? || Yes, dehydration may increase urea.\nWho should monitor KFT regularly? || Patients with diabetes, hypertension, and kidney risks."
  }
]

blog_posts.each do |attrs|
  post = BlogPost.find_or_initialize_by(slug: attrs[:slug])
  post.assign_attributes(attrs)
  post.save!
end

puts "Blog posts seeded: #{blog_posts.count}"

# ---------------------------------------------------------------------------
# Platform super admin + demo lab (idempotent)
# ---------------------------------------------------------------------------

super_email = ENV.fetch("SUPER_ADMIN_EMAIL", "super@homecure.com")
super_password = ENV.fetch("SUPER_ADMIN_PASSWORD", "admin123")

super_admin = User.find_or_initialize_by(email: super_email)
super_admin.role = "super_admin"
super_admin.lab = nil
if super_admin.new_record?
  super_admin.password = super_password
  super_admin.password_confirmation = super_password
end
super_admin.save!
puts "Super admin ready: #{super_admin.email} / #{super_password}"

lab = Lab.find_or_initialize_by(slug: "demo-diagnostics")
lab.assign_attributes(
  name: "Demo Diagnostics",
  status: "active",
  contact_email: "front.desk@demodx.com",
  phone_number: "9800000000",
  address: "100 Demo Street, Pune"
)
lab.save!
Current.lab = lab
puts "Demo lab ready: #{lab.name} (#{lab.slug})"

admin_email = ENV.fetch("ADMIN_EMAIL", "admin@lab.com")
admin_password = ENV.fetch("ADMIN_PASSWORD", "admin123")

admin = User.find_or_initialize_by(email: admin_email)
admin.role = "lab_owner"
admin.lab = lab
if admin.new_record?
  admin.password = admin_password
  admin.password_confirmation = admin_password
end
admin.save!
puts "Lab owner ready: #{admin.email} / #{admin_password}"

staff_email = ENV.fetch("STAFF_EMAIL", "staff@lab.com")
staff_password = ENV.fetch("STAFF_PASSWORD", "admin123")

staff = User.find_or_initialize_by(email: staff_email)
staff.role = "lab_staff"
staff.lab = lab
if staff.new_record?
  staff.password = staff_password
  staff.password_confirmation = staff_password
end
staff.save!
puts "Lab staff ready: #{staff.email} / #{staff_password}"

tests_data = [
  { code: "CBC", name: "Complete Blood Count", price: 350, description: "Hb, RBC, WBC, platelets" },
  { code: "LFT", name: "Liver Function Test", price: 700, description: "Bilirubin, SGOT, SGPT, ALP" },
  { code: "KFT", name: "Kidney Function Test", price: 750, description: "Creatinine, urea, uric acid" },
  { code: "LIPID", name: "Lipid Profile", price: 650, description: "Cholesterol, LDL, HDL, TG" },
  { code: "TSH", name: "Thyroid Stimulating Hormone", price: 300, description: "0.4 - 4.0 mIU/L" },
  { code: "T3T4", name: "Thyroid Profile (T3, T4, TSH)", price: 550, description: "Full thyroid panel" },
  { code: "HBA1C", name: "HbA1c (Glycated Hemoglobin)", price: 450, description: "Below 5.7% normal" },
  { code: "FBS", name: "Fasting Blood Sugar", price: 150, description: "70 - 100 mg/dL" },
  { code: "VITD", name: "Vitamin D (25-OH)", price: 1200, description: "30 - 100 ng/mL" },
  { code: "VITB12", name: "Vitamin B12", price: 900, description: "200 - 900 pg/mL" },
  { code: "URINE", name: "Urine Routine & Microscopy", price: 200, description: "Physical, chemical, microscopic" },
  { code: "ESR", name: "Erythrocyte Sedimentation Rate", price: 150, description: "0 - 20 mm/hr" }
]

tests_data.each do |attrs|
  test = Test.find_or_initialize_by(code: attrs[:code])
  test.assign_attributes(attrs)
  test.save!
end
puts "Tests seeded: #{Test.count}"

packages_data = [
  { code: "PKG-BASIC", name: "Basic Health Checkup", price: 999,
    description: "Essential screening for routine annual checkups",
    test_codes: %w[CBC FBS URINE ESR] },
  { code: "PKG-DIAB", name: "Diabetes Care Package", price: 799,
    description: "Complete sugar monitoring panel",
    test_codes: %w[FBS HBA1C URINE] },
  { code: "PKG-THYRO", name: "Thyroid Care Package", price: 749,
    description: "Full thyroid function assessment",
    test_codes: %w[T3T4 TSH CBC] },
  { code: "PKG-FULL", name: "Full Body Checkup", price: 2499,
    description: "Comprehensive head-to-toe health screening",
    test_codes: %w[CBC LFT KFT LIPID TSH FBS URINE VITD] }
]

packages_data.each do |attrs|
  pkg = TestPackage.find_or_initialize_by(code: attrs[:code])
  pkg.assign_attributes(attrs.except(:test_codes))
  pkg.test_ids = Test.where(code: attrs[:test_codes]).pluck(:id)
  pkg.save!
end
puts "Test packages seeded: #{TestPackage.count}"

doctors_data = [
  { full_name: "Dr. Anjali Verma", specialization: "Cardiologist", phone_number: "9812345602", email: "anjali.verma@heartline.in" },
  { full_name: "Dr. Rajesh Kumar", specialization: "General Physician", phone_number: "9812345601", email: "rajesh.kumar@citycare.in" },
  { full_name: "Dr. Sameer Iyer", specialization: "Endocrinologist", phone_number: "9812345603", email: "sameer.iyer@mediplus.in" },
  { full_name: "Dr. Shagufta Zarrin", specialization: "Gynecologist", phone_number: "9812345604", email: "shagufta.zarrin@femicare.in" },
  { full_name: "Dr. Pooja Nair", specialization: "Pediatrician", phone_number: "9812345605", email: "pooja.nair@childfirst.in" }
]

doctors_data.each do |attrs|
  doctor = Doctor.find_or_initialize_by(email: attrs[:email])
  doctor.assign_attributes(attrs)
  doctor.save!
end
puts "Doctors seeded: #{Doctor.count}"

doctor_by_email = Doctor.all.index_by(&:email)

patients_data = [
  { full_name: "Priya Patel", age: 34, gender: "female", phone_number: "9820011234", email: "priya@example.com",
    address: "12 MG Road, Pune", doctor_email: "rajesh.kumar@citycare.in",
    package_codes: %w[PKG-BASIC], test_codes: %w[VITD], bill_status: "paid", days_ago: 12, report: :completed },
  { full_name: "Rohan Mehta", age: 45, gender: "male", phone_number: "9820011235", email: "rohan@example.com",
    address: "45 Link Road, Mumbai", doctor_email: "anjali.verma@heartline.in",
    package_codes: %w[PKG-FULL], test_codes: [], bill_status: "paid", days_ago: 10, report: :completed },
  { full_name: "Sunita Rao", age: 62, gender: "female", phone_number: "9820011236", email: "sunita@example.com",
    address: "8 Jayanagar, Bengaluru", doctor_email: "sameer.iyer@mediplus.in",
    package_codes: %w[PKG-DIAB], test_codes: %w[KFT], bill_status: "paid", days_ago: 7, report: :processing },
  { full_name: "Vikram Singh", age: 28, gender: "male", phone_number: "9820011237", email: "vikram@example.com",
    address: "23 Civil Lines, Delhi", doctor_email: nil,
    package_codes: [], test_codes: %w[CBC LIPID], bill_status: "pending", days_ago: 4, report: :processing },
  { full_name: "Aisha Khan", age: 39, gender: "female", phone_number: "9820011238", email: "aisha@example.com",
    address: "67 Banjara Hills, Hyderabad", doctor_email: "shagufta.zarrin@femicare.in",
    package_codes: %w[PKG-THYRO], test_codes: [], bill_status: "paid", days_ago: 3, report: :completed },
  { full_name: "Shabab Quddusi", age: 25, gender: "male", phone_number: "9209255426", email: nil,
    address: "5 Fraser Road, Patna", doctor_email: "rajesh.kumar@citycare.in",
    package_codes: [], test_codes: %w[FBS URINE], bill_status: "pending", days_ago: 2, report: :none },
  { full_name: "Ayesha Siddiqua", age: 32, gender: "female", phone_number: "7447868244", email: nil,
    address: "19 Park Street, Kolkata", doctor_email: "pooja.nair@childfirst.in",
    package_codes: %w[PKG-BASIC], test_codes: %w[VITB12], bill_status: "pending", days_ago: 1, report: :none },
  { full_name: "Arjun Deshmukh", age: 51, gender: "male", phone_number: "9820011240", email: "arjun@example.com",
    address: "31 FC Road, Pune", doctor_email: "anjali.verma@heartline.in",
    package_codes: [], test_codes: %w[LFT KFT], bill_status: "paid", days_ago: 0, report: :processing }
]

patients_data.each do |attrs|
  next if Patient.exists?(phone_number: attrs[:phone_number])

  patient = Patient.new
  doctor = attrs[:doctor_email] && doctor_by_email[attrs[:doctor_email]]

  saved = Patients::SaveWithTests.new(
    patient,
    attributes: {
      full_name: attrs[:full_name],
      age: attrs[:age],
      gender: attrs[:gender],
      phone_number: attrs[:phone_number],
      email: attrs[:email],
      address: attrs[:address],
      doctor_id: doctor&.id
    },
    test_ids: Test.where(code: attrs[:test_codes]).pluck(:id),
    package_ids: TestPackage.where(code: attrs[:package_codes]).pluck(:id)
  ).call

  raise "Failed to seed patient #{attrs[:full_name]}" unless saved

  created_at = attrs[:days_ago].days.ago
  patient.update_columns(created_at: created_at, updated_at: created_at)

  bill = patient.primary_bill
  if bill
    bill.bill_date = created_at.to_date
    bill.status = attrs[:bill_status]
    bill.amount_paid = bill.total_amount if attrs[:bill_status] == "paid"
    bill.save!
  end

  case attrs[:report]
  when :completed
    test = patient.selected_tests.first
    Report.create!(
      patient: patient,
      doctor: doctor,
      test: test,
      reported_on: created_at.to_date + 1.day,
      file_path: "reports/#{patient.full_name.parameterize}-#{test&.code&.downcase || "panel"}.pdf",
      notes: "Report delivered to patient."
    )
  when :processing
    Report.create!(
      patient: patient,
      doctor: doctor,
      test: patient.selected_tests.first,
      reported_on: created_at.to_date,
      file_path: nil,
      notes: "Sample collected, awaiting lab results."
    )
  end
end

puts "Patients seeded: #{Patient.count} (with bills: #{Bill.count}, reports: #{Report.count})"
Current.lab = nil
