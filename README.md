# Home Cure Lab

Home Cure Lab is a Rails application for managing a clinical lab workflow. It includes public pages, contact inquiries, admin login, patient records, doctors, lab tests, reports, billing, PDF bill generation, and referral reports.

## Stack

- Ruby on Rails 8.1
- PostgreSQL
- Devise for authentication
- Importmap, Turbo, and Stimulus
- Prawn for PDF bill generation

## Setup

Install dependencies:

```bash
bundle install
```

Prepare the database:

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

Start the app:

```bash
bin/dev
```

Then open:

```text
http://localhost:3000
```

## Useful Commands

Run the Rails console:

```bash
bin/rails console
```

Run the test suite (RSpec):

```bash
bundle exec rspec
```

Run local CI (RuboCop, security scans, RSpec):

```bash
bin/ci
```

Run security checks:

```bash
bin/brakeman
bin/bundler-audit
```

## Main Features

- Public home page and contact form
- Admin dashboard
- Patient, doctor, test, report, and bill management
- Bill PDF download and print view
- Doctor referral report with CSV export
- Blog management for health education content
