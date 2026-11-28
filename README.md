# Inventra – Inventory Management System

## Project Overview

Inventra is a web-based inventory management application built with Ruby on Rails.

It provides a flexible platform for creating and managing customizable inventories, defining custom fields, organizing items, and collaborating with other users.

Inventra can be used to manage different types of resources, such as office equipment, library books, and company documents.

This project was developed as the final project for a Ruby on Rails course.

## Live Demo

**Live Application:** [https://inventra.ethiodeploy.app/](https://inventra.ethiodeploy.app/)

The application is deployed and publicly accessible.

## Technology Stack

- **Backend:** Ruby on Rails 8.1
- **Programming Language:** Ruby 4.0
- **Database:** PostgreSQL
- **Production Database:** Neon
- **ORM:** ActiveRecord
- **Frontend:** HTML, CSS, JavaScript
- **Version Control:** Git and GitHub
- **Containerization:** Docker
- **Deployment:** EthioDeploy

## Implemented Features

### User Management

- User registration and authentication
- User profiles
- User roles and administrator management
- Public user profiles

### Inventory Management

- Create, edit, and delete inventories
- Inventory categories and tags
- Public and private inventories
- User-based inventory access permissions

### Custom Fields

- Define custom fields for inventory items
- Support different field types
- Reorder custom fields
- Dynamically generate item forms based on field definitions

### Custom Inventory IDs

- Automatically generate sequential inventory IDs
- Ensure database-level uniqueness
- Display custom IDs in inventory views

### Items

- Create, view, edit, and delete inventory items
- Sortable and searchable item listings
- Inventory statistics

### Collaboration

- Inventory discussion boards
- Markdown support
- Like and unlike discussion posts
- Display discussion post like counts
- Discussion updates
- Optimistic locking for concurrent edits

### Search and Dashboard

- Full-text search
- Latest inventories
- Popular inventories
- Tag-based inventory discovery
- Inventory statistics

### User Interface

- Responsive design
- Light and dark themes
- Consistent application-wide design system
- Redesigned forms, tables, profile pages, and navigation
- Improved flash messages, validation feedback, and empty states

## Planned Features

- Google and other external account authentication
- Additional UI language support

## Local Development Setup

### Prerequisites

Make sure the following tools are installed:

- Ruby
- Rails
- Bundler
- PostgreSQL
- Git

### Clone the Repository

```bash
git clone https://github.com/marykhodaparast/inventra.git
cd inventra
```

### Install Dependencies

```bash
bundle install
```

### Configure Local PostgreSQL Credentials

Local database credentials are provided through environment variables.

To enter your PostgreSQL password without displaying it while typing:

```bash
printf "PostgreSQL password: "
read -s INVENTRA_DATABASE_PASSWORD
echo
export INVENTRA_DATABASE_PASSWORD
```

Enter your PostgreSQL password when prompted.

**Important:**

- Run these commands in the same terminal session where you execute Rails database commands.
- The password is stored only in the current shell session.
- Run the commands again when opening a new terminal session.
- Ensure `config/database.yml` reads the password from `INVENTRA_DATABASE_PASSWORD`.
- Never commit database passwords or other sensitive credentials to GitHub.

### Prepare the Database

```bash
bin/rails db:create
bin/rails db:migrate
```

### Start the Rails Server

```bash
bin/rails server
```

Open the application at:

[http://localhost:3000](http://localhost:3000)

## Production Deployment

Inventra is deployed using **EthioDeploy**, with PostgreSQL hosted on **Neon**.

### Docker Configuration

- **Dockerfile Path:** `Dockerfile`
- The project uses its Dockerfile and Docker entrypoint for container initialization.

### Production Start Command

```bash
bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0 -p "${PORT:-3000}"
```

### Production Environment Variables

The following environment variables are configured securely through the deployment platform:

| Variable | Description |
|---|---|
| `RAILS_ENV` | Rails environment (`production`) |
| `RAILS_MASTER_KEY` | Rails credentials encryption key |
| `DATABASE_URL` | PostgreSQL connection URL |
| `RAILS_LOG_TO_STDOUT` | Enables standard output logging |
| `RAILS_SERVE_STATIC_FILES` | Enables static asset serving |

Sensitive environment variable values are never stored in the GitHub repository.

### Database Migrations

The production database is prepared using:

```bash
bundle exec rails db:prepare
```

This command prepares the database and applies pending migrations.

## Testing

The application test suite uses Rails' built-in testing framework.

Run the complete test suite with:

```bash
bin/rails test
```

**Latest test results:**

- 208 runs
- 837 assertions
- 0 failures
- 0 errors
- 0 skips

## Development Progress

### Completed

- [x] Create the Rails application
- [x] Configure local PostgreSQL
- [x] Set up the application homepage
- [x] Configure Neon as the production database
- [x] Configure the production environment
- [x] Configure Docker for deployment
- [x] Deploy the application successfully
- [x] Publish the live application
- [x] Implement user authentication
- [x] Implement user profiles and roles
- [x] Implement inventory management
- [x] Implement custom fields
- [x] Implement custom inventory IDs
- [x] Implement inventory access permissions
- [x] Implement full-text search
- [x] Implement inventory tags and tag-based discovery
- [x] Implement discussion features
- [x] Implement discussion post likes
- [x] Implement dashboard and statistics
- [x] Add responsive UI and themes
- [x] Improve application-wide UI and UX
- [x] Verify production database migrations
- [x] Verify production registration and login
- [x] Run the complete test suite successfully
- [x] Verify the latest production deployment
- [x] Test discussion likes and production UI
- [x] Prepare project documentation
- [x] Complete the final project review

### Upcoming

- [ ] Presentation preparation

## Author

**Maryam Khodaparast**

Ruby on Rails Course – Final Project

GitHub: [https://github.com/marykhodaparast](https://github.com/marykhodaparast)