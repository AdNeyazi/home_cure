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
