# Inventra – Inventory Management System

## Project Overview

Inventra is a web-based inventory management application built with Ruby on Rails.

The application allows users to create and manage customizable inventories, define their own fields, and add items based on those field definitions.

The goal is to provide a flexible platform for managing different types of resources, such as office equipment, library books, and company documents.

This project is being developed as the final project for the Ruby on Rails course.

## Live Demo

**Live Application:** https://inventra-d63b5.containers.snapdeploy.app

The initial version of Inventra is successfully deployed and publicly accessible.

## Technology Stack

The project uses the following technologies:

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
- Custom ID formats for each inventory
- Support fixed text, random numbers, GUIDs, dates, and sequences
- Database-level uniqueness within each inventory
- Custom ID validation and editing

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

Configure your local PostgreSQL credentials using the environment variables expected by `config/database.yml`.

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

http://localhost:3000

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

### Upcoming

- [ ] Implement user authentication
- [ ] Implement user profiles and roles
- [ ] Implement inventory management
- [ ] Implement custom fields
- [ ] Implement custom inventory IDs
- [ ] Implement access permissions
- [ ] Implement search and collaboration features
- [ ] Implement dashboard and statistics
- [ ] Add responsive UI and themes
- [ ] Complete testing and final deployment

## Author

**Maryam Khodaparast**

Ruby on Rails Course – Final Project

GitHub: https://github.com/marykhodaparast