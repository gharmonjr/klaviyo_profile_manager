# Klaviyo Profile Manager

A small Rails 8 app to manage Klaviyo profiles. Allows admins to:

- View all synced profiles
- Filter by email
- Bulk update engagement levels
- Refresh data from Klaviyo

## Tech Stack

- Ruby 3.2
- Rails 8
- Hotwire (Turbo, Stimulus)
- TailwindCSS
- PostgreSQL
- Solid Queue (for background jobs)
- StandardRB (code style)

## Setup

1. Clone the repo:

   ```bash
   git clone https://github.com/your-org/klaviyo-profile-manager.git
   cd klaviyo-profile-manager
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Setup the database:

   ```bash
   bin/rails db:setup
   ```
   
4. Seed the app:

    ```bash
   bin/rails db:seed 
   ```

5. Start the app:

   ```bash
   bin/dev
   ```

## Running Tests

```bash
bin/rails test
```

## Running StandardRB (lint)

```bash
bundle exec standardrb --no-autocorrect
```

## Continuous Integration

This app uses GitHub Actions for CI. On every push and pull request, it will:

1. Spin up a PostgreSQL container
2. Prepare the database
3. Run StandardRB
4. Run all tests

---

For more info on how profiles are managed or synced, see the `Klaviyo::SyncProfilesJob` and `Klaviyo::UpdateEngagementJob` in `app/jobs/klaviyo/`.
