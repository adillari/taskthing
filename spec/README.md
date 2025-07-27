# Test Suite Documentation

This directory contains a comprehensive test suite for the Taskthing application using RSpec, FactoryBot, and Capybara.

## Test Structure

### Models (`spec/models/`)
- **User**: Authentication, validations, associations, email normalization
- **Board**: CRUD operations, default lane creation, version management
- **BoardUser**: Role management, associations, validations
- **Lane**: Position ordering, board associations, task relationships
- **Task**: CRUD operations, position management, lane associations
- **Invite**: Invitation system, email handling, board associations
- **Session**: User session management, IP and user agent tracking

### Request Specs (`spec/requests/`)
- **Boards**: Full CRUD with authentication and authorization
- **Users**: Registration, authentication, profile updates
- **Sessions**: Login/logout functionality, rate limiting
- **Tasks**: Task management with proper authorization
- **Invites**: Invitation creation, acceptance, and rejection
- **Home**: Root path behavior with authentication

### System Specs (`spec/features/`)
- **User Registration**: End-to-end registration flow
- **User Login**: Authentication flow with error handling
- **Board Management**: Board CRUD operations
- **Task Management**: Task creation, editing, and deletion

### Factories (`spec/factories/`)
Comprehensive factories for all models with:
- **Base factories**: Valid default data
- **Traits**: Specialized data variations
- **Associations**: Proper relationship setup
- **Sequences**: Unique data generation

## Running Tests

### All Tests
```bash
bundle exec rspec
```

### Specific Test Types
```bash
# Model tests only
bundle exec rspec spec/models/

# Request tests only
bundle exec rspec spec/requests/

# System tests only
bundle exec rspec spec/features/

# Specific file
bundle exec rspec spec/models/user_spec.rb
```

### Test Coverage
```bash
# Run with coverage report
COVERAGE=true bundle exec rspec
```

## Test Configuration

### Support Files
- `spec/support/factory_bot.rb`: FactoryBot configuration
- `spec/support/authentication_helper.rb`: Authentication helpers for tests
- `spec/support/shoulda_matchers.rb`: Shoulda Matchers configuration
- `spec/support/test_configuration.rb`: General test configuration

### Database Cleanup
Tests use DatabaseCleaner to ensure clean state between tests:
- Transaction strategy for unit tests
- Truncation strategy for system tests

### Authentication Helpers
```ruby
# Sign in a user for request/feature tests
sign_in_as(user)

# Sign out for authentication tests
sign_out
```

## Testing Patterns

### Model Testing
- Validations using Shoulda Matchers
- Associations and callbacks
- Custom methods and business logic
- Factory validation

### Request Testing
- HTTP status codes
- Authentication and authorization
- Parameter handling
- Redirects and responses

### System Testing
- End-to-end user workflows
- JavaScript interactions
- Form submissions
- Page content verification

## Factory Usage

### Basic Usage
```ruby
# Create a user
user = create(:user)

# Create a board with default lanes
board = create(:board)

# Create a task
task = create(:task, lane: lane)
```

### Using Traits
```ruby
# Create user with boards
user = create(:user, :with_boards)

# Create admin user
admin = create(:user, :admin)

# Create task with description
task = create(:task, :with_description)
```

### Associations
```ruby
# Create board with users
board = create(:board, :with_users)

# Create lane with tasks
lane = create(:lane, :with_tasks)

# Create board with full hierarchy
board = create(:board, :with_tasks)
```

## Best Practices

### Test Organization
- Use descriptive context blocks
- Group related tests together
- Use meaningful test names
- Follow AAA pattern (Arrange, Act, Assert)

### Data Setup
- Use factories for test data
- Avoid hardcoded values
- Use sequences for unique data
- Clean up after tests

### Assertions
- Test one thing per example
- Use specific matchers
- Verify both positive and negative cases
- Test edge cases and error conditions

## Continuous Integration

The test suite is designed to run in CI environments:
- Headless browser for system tests
- Database cleanup between runs
- Proper exit codes for CI systems
- Coverage reporting integration

## Troubleshooting

### Common Issues
1. **Database state**: Ensure DatabaseCleaner is working properly
2. **Authentication**: Check authentication helper setup
3. **JavaScript errors**: Review browser logs in system tests
4. **Factory issues**: Validate factory definitions

### Debugging
```bash
# Run with verbose output
bundle exec rspec --format documentation

# Run specific failing test
bundle exec rspec spec/models/user_spec.rb:25

# Run with debugging
bundle exec rspec --debug
``` 