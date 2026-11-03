# Inventra – Inventory Management System

## Project Overview

Inventra is a web-based inventory management application built with Ruby on Rails.

The application allows users to create and manage customizable inventories, define their own fields, and add items based on those field definitions.

The goal is to provide a flexible platform for managing different types of resources, such as office equipment, library books, and company documents.

This project is being developed as the final project for the Ruby on Rails course.

## Technology Stack

The project uses the following technologies:

- **Backend:** Ruby on Rails
- **Programming Language:** Ruby
- **Database:** PostgreSQL
- **ORM:** ActiveRecord
- **Frontend:** HTML, CSS, JavaScript
- **CSS Framework:** Bootstrap (planned)
- **Version Control:** Git and GitHub

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

Create and configure the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

Start the Rails server:

```bash
bin/rails server
```

Open the application in your browser:

```text
http://localhost:3000
```

## Development Progress

The project is currently in its initial setup stage.

- [x] Create the Rails application
- [ ] Configure PostgreSQL database
- [ ] Create the initial application homepage
- [ ] Deploy the initial version
- [ ] Implement user authentication
- [ ] Implement inventory management
- [ ] Implement custom fields
- [ ] Implement custom inventory IDs
- [ ] Implement access permissions
- [ ] Implement search and collaboration features
- [ ] Complete testing and deployment

## Deployment

The application is planned to be deployed using SnapDeploy.

Deployment configuration and production setup will be documented as development progresses.

## Author

**Maryam Khodaparast**

Ruby on Rails Course – Final Project

GitHub: https://github.com/marykhodaparast