# Inventra – Inventory Management System

## Project Overview

Inventra is a web-based inventory management application built with Ruby on Rails.

The application allows users to create and manage customizable inventories, define their own fields, and add items based on those field definitions.

The goal is to provide a flexible platform for managing different types of resources, such as office equipment, library books, and company documents.

This project is being developed as the final project for the Ruby on Rails course.

## Live Demo

**Live Application:** [https://inventra-d63b5.containers.snapdeploy.app](https://inventra-d63b5.containers.snapdeploy.app)

The initial version of Inventra is successfully deployed and publicly accessible.

## Technology Stack

- **Backend:** Ruby on Rails
- **Programming Language:** Ruby
- **Database:** PostgreSQL
- **Production Database:** Neon
- **ORM:** ActiveRecord
- **Frontend:** HTML, CSS, JavaScript
- **CSS Framework:** Bootstrap (planned)
- **Version Control:** Git and GitHub
- **Deployment:** SnapDeploy
- **Containerization:** Docker

## Planned Features

### User Management
- User registration and authentication
- Google and other external account authentication
- User roles and administrator management
- User profiles

### Inventory Management
- Create, edit, and delete inventories
- Custom inventory settings
- Inventory categories and tags
- Public and private inventories
- User-based access permissions

### Custom Fields
- Define custom fields for inventory items
- Support text, long text, numeric, document/image link, and boolean fields
- Reorder custom fields
- Dynamically generate item forms based on field definitions

### Custom Inventory IDs
- Automatically generate sequential inventory IDs (e.g. INV-000001)
- Ensure database-level uniqueness
- Display custom IDs in inventory lists and edit pages

### Items
- Create, view, edit, and delete inventory items
- Display items in sortable and filterable tables
- Like items

### Collaboration
- Inventory discussion boards
- Markdown support
- Automatic discussion updates
- Optimistic locking for concurrent edits

### Search and Dashboard
- Full-text search
- Latest inventories
- Most popular inventories
- Tag cloud
- Inventory statistics

### User Interface
- English and a second UI language
- Light and dark themes
- Responsive design for desktop and mobile devices

## Local Development Setup

### Prerequisites

Make sure the following tools are installed:

- Ruby
- Rails
- Bundler
- PostgreSQL
- Git

### Installation

Clone the repository:

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
cd inventra
```

Install dependencies:

```bash
bundle install
```

### Configure Local PostgreSQL Credentials

The local database credentials are provided through environment variables.

To enter your PostgreSQL password without displaying it while typing, run:

```bash
printf "PostgreSQL password: " ; read -s INVENTRA_DATABASE_PASSWORD ; echo ; export INVENTRA_DATABASE_PASSWORD
```

Enter your PostgreSQL password when prompted.

**Important:**
- Run this command in the same terminal session where you will execute Rails database commands.
- The password is stored only in the current shell session.
- Run the command again when opening a new terminal session.
- Make sure `config/database.yml` reads the password from `INVENTRA_DATABASE_PASSWORD`.
- Never commit database passwords or other sensitive credentials to GitHub.

Create and migrate the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

Start the Rails server:

```bash
bin/rails server
```

Open the application in your browser:

[http://localhost:3000](http://localhost:3000)

## Deployment

Inventra is deployed using SnapDeploy, with PostgreSQL hosted on Neon.

### Production Start Command

```bash
./bin/rails server -b 0.0.0.0 -p 3000
```

### Production Environment Variables

The following environment variables are configured securely through the deployment platform:

- `RAILS_ENV`
- `DATABASE_URL`
- `RAILS_MASTER_KEY`
- `SECRET_KEY_BASE`
- `RAILS_MAX_THREADS`
- `WEB_CONCURRENCY`

Sensitive environment variable values are not stored in the GitHub repository.

## Development Progress

### Completed

- [x] Create the Rails application
- [x] Configure local PostgreSQL
- [x] Set up the initial application homepage
- [x] Configure the production database connection with Neon
- [x] Configure the production environment
- [x] Configure the Dockerfile for deployment
- [x] Deploy the initial version successfully
- [x] Publish the live application
- [x] Implement user authentication
- [x] Implement user profiles and roles
- [x] Implement inventory management
- [x] Implement custom fields
- [x] Implement custom inventory IDs
- [x] Implement access permissions

### Upcoming

- [ ] Implement search and collaboration features
- [ ] Implement dashboard and statistics
- [ ] Add responsive UI and themes
- [ ] Complete testing and final deployment

## Author

**Maryam Khodaparast**

Ruby on Rails Course – Final Project

GitHub: [https://github.com/marykhodaparast](https://github.com/marykhodaparast)
