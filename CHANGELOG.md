# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-05-17

### Changed
- **BREAKING**: Migrated from Oracle to PostgreSQL for free, open-source deployment
- Converted all PL/SQL packages to PostgreSQL functions
- Updated all SQL syntax for PostgreSQL compatibility
- Removed all icons and emojis from documentation
- Converted documentation to British English
- Changed from proprietary Oracle to free PostgreSQL database

### Added
- **NEW**: Complete web interface using Node.js and Express
- **NEW**: Browser-based dashboard for all operations
- **NEW**: Visual reports with charts
- **NEW**: CSV export functionality
- New PostgreSQL-specific functions for better performance
- Enhanced error handling throughout the system
- Additional utility functions (available_vehicles, revenue_report)
- Comprehensive triggers for data integrity
- Improved testing framework for PostgreSQL
- Docker-ready configuration structure
- Docker Compose setup for one-command deployment

### Updated
- All documentation for PostgreSQL usage
- Installation scripts for PostgreSQL
- Sample data for PostgreSQL syntax
- Test scripts for PostgreSQL functions
- Docker configuration to include web service

## [1.1.0] - 2025-05-17

### Added
- Complete project restructuring with organised directories
- Comprehensive installation and uninstall scripts
- Sample data for testing and development
- API documentation with detailed examples
- Database schema documentation with ERD
- Troubleshooting guide for common issues
- Development guide for contributors
- CI/CD pipeline with GitHub Actions
- Issue templates for bug reports and feature requests
- Testing framework with installation verification
- Contributing guidelines
- MIT Licence

### Changed
- Moved SQL files to organised directory structure
- Updated README with professional formatting
- Enhanced documentation with better examples
- Improved error handling in packages

### Security
- Added .gitignore to prevent credential exposure
- Implemented security checks in CI/CD pipeline

## [1.0.0] - 2019-12-15

### Added
- Initial release
- BOOKING_CARS package for customer and booking management
- UPDATE_INFORMATION package for vehicle management and reporting
- Business rule triggers
- Basic customer, vehicle, and booking functionality

### Features
- Customer registration and validation
- Vehicle availability checking
- Booking creation and management
- Status updates
- Basic reporting capabilities