# Accession

[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Dependency Status][DS img]][Dependency Status]
[![Code Climate][CC img]][Code Climate]
[![Coverage Status][CS img]][Code Climate]

[Gem Version]: https://rubygems.org/gems/accession
[Build Status]: https://codeship.com/projects/91206
[Dependency Status]: https://gemnasium.com/ausaccessfed/accession
[Code Climate]: https://codeclimate.com/github/ausaccessfed/accession

[GV img]: https://img.shields.io/gem/v/accession.svg
[BS img]: https://img.shields.io/codeship/9f22d070-0cca-0133-3d0f-36a99efb0264/develop.svg
[DS img]: https://img.shields.io/gemnasium/ausaccessfed/accession.svg
[CC img]: https://img.shields.io/codeclimate/github/ausaccessfed/accession.svg
[CS img]: https://img.shields.io/codeclimate/coverage/github/ausaccessfed/accession.svg

Extremely lightweight permissions for Ruby applications.

Author: Shaun Mangelsdorf

```
Copyright 2014-2015, Australian Access Federation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'accession'
```

Use Bundler to install the dependency:

```
bundle install
```

## Usage

Accession is intended to be a lightweight and flexible way to add permissions to
your model classes. It imposes very few requirements on your application.

The two major pieces of API provided by Accession are:

* The `Accession::Principal` module, which consumes a list of permission strings
  returned by the `permissions` method in a class and gives a `permits?` method
  for performing a permission check.
* The `Accession::Permission.regexp` pattern, which can be used to validate an
  Accession permission string.

To get started add a `permission` method to your class that represents an
authenticated user. This method returns permissions strings associated with that
user. Once you have this method, include the `Accession::Principal` module in
your class to add the `permits?` method.

An example implementation is:

```ruby
# app/models/permission.rb
class Permission < ActiveRecord::Base
  validates :value, format: Accession::Permission.regexp
end

# app/models/role.rb
class Role < ActiveRecord::Base
  has_many :permissions
end

# app/models/subject.rb
class Subject < ActiveRecord::Base
  include Accession::Principal

  has_and_belongs_to_many :roles

  def permissions
    roles.flat_map { |role| role.permissions.map(&:value) }
  end
end
```

With this in place, a `Subject` can have a permission check performed, for
example:

```ruby
class ProjectsController < ApplicationController
  before_action { @subject = Subject.find(session[:subject_id]) }

  def index
    fail('Not allowed') unless @subject.permits?('projects:list')
  end
end
```

## Permission Strings

A permission string is comprised of one or more colon-separated parts that
describe the action being permitted. Each part of the permission string can be
either a wildcard (`*`), or a "word" of characters `a-z A-Z 0-9 _ -`

A wildcard in any position will match a single word in that position. A wildcard
in the last position will match any number of words in the action string.

| permission | action  | result |
|------------|---------|--------|
| `a`        | `a`     | permit |
| `a`        | `b`     | deny   |
| `a:b:c`    | `a:b:c` | permit |
| `a:b:c`    | `a:b:d` | deny   |
| `*:b:c`    | `a:b:c` | permit |
| `a:b:*`    | `a:b:c` | permit |
| `a:*`      | `a:b:c` | permit |
| `*:c`      | `a:b:c` | deny   |
| `*`        | `a:b:c` | permit |
| `a:b:*`    | `a:b`   | deny   |
| `a:*:*`    | `a:b`   | deny   |

## Contributing

Refer to [GitHub Flow](https://guides.github.com/introduction/flow/) for
help contributing to this project.
