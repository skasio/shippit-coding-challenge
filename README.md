# shippit-coding-challenge

My submission to the Shippit Coding Challenge, implemented in Ruby v3.3.5, is a small application to manage the following family tree of King Arthur and Queen Margaret:

![Image of the Family Tree](./family-tree.png)

The application accepts an action file where each line denotes an action to perform on the family tree.

Example: `./ruby family_tree.rb /path/to/actions.txt`

**Supported Actions**

- `ADD_CHILD [MOTHER'S NAME] [CHILD'S NAME] [CHILD'S GENDER]`
- `GET_RELATIONSHIP [PERSON'S NAME] [RELATIONSHIP TYPE]`

> Note that you can only add a child via the mother

**Supported Genders**

- `MALE`
- `FEMAL`

**Supported Relationship Types**

- `MOTHER`
- `FATHER`
- `SIBLINGS`
- `CHILD`
- `DAUGHTER`
- `SON`
- `PATERNAL-UNCLE`
- `MATERNAL-UNCLE`
- `PATERNAL-AUNT`
- `MATERNAL-AUNT`
- `SISTER-IN-LAW`
- `BROTHER-IN-LAW`

**Comments and Blank Lines**

Blank lines and lines starting with `#` are ignored.

**Example `actions.txt` File**

Based on the family tree of King Arthur and Queen Margaret, here is an example action file:

```txt
# Adding Children
ADD_CHILD "Queen Margaret" "Jonathan" "Male"

# Getting relationships
GET_RELATIONSHIP Remus Maternal-Aunt
```

> Note that quotation marks are only required if the name of the person has a space in it, if quotation marks are ommitted the action will fail.\
> Also, note that the **gender** and **relationship-types** are **case-insensitive**.

**Output**

Based on the family tree, here are the expected outputs for commoon scenarios:

| Action                                          | Output                  | Comments                    |
| ----------------------------------------------- | ----------------------- | --------------------------- |
| `ADD_CHILD "Queen Margaret" "Jonathan" "Male"`  | `CHILD_ADDED`           | Successful                  |
| `ADD_CHILD "Betty" "Jonathan" "Male"`           | `PERSON_NOT_FOUND`      | Betty doesn't exist         |
| `ADD_CHILD "Queen Margaret" "Jonathan" "Other"` | `CHILD_ADDITION_FAILED` | Invalid gender              |
| `ADD_CHILD "King Arthur" "Jonathan" "Other"`    | `CHILD_ADDITION_FAILED` | Father's name provided      |
| `ADD_CHILD "King Arthur"`                       | _no output_             | Invalid number of arguments |
| `ADD_CHILD "King Arthur" "Jonathan"`            | _no output_             | Invalid number of arguments |
| `ADD_PET "King Arthur" "Poodles"`               | _no output_             | Invalid action, `ADD_PET`   |
| `GET_RELATIONSHIP "Percy" "Child"`              | `Molly Lucy`            | Names of children           |
| `GET_RELATIONSHIP "Charlie" "Child"`            | `NONE`                  | Charlie has no children     |
| `GET_RELATIONSHIP "Betty" "Child"`              | `PERSON_NOT_FOUND`      | Betty doesn't exist         |
| `GET_RELATIONSHIP "King Arthur" "Pets"`         | _no output_             | Invalid relationship type   |
| `GET_RELATIONSHIP "King Arthur"`                | _no output_             | Invalid number of arguments |

## Approach

The implementation of this project follows a structured approach:

- **Testing**: All tests are written using RSpec.
- **Main Entrypoint**: The application is launched via `./bin/family_tree.rb`.
- **Command Line Interface**: Arguments are handled by the `CLI` class, which passes the actions file to the `ActionFileExecutor`.
- **Action Processing**: The `ActionFileExecutor` processes the actions file line by line, executing each action using the `FamilyTree`.
- **FamilyTree**: The `FamilyTree` singleton maintains a single instance of all families and exposes the `add_child` and `get_relationship` methods.
- **NilPerson Class**: The `NilPerson` class follows the Null Object pattern, providing a default, non-intrusive representation of a person when a real instance is not available. This helps avoid null checks throughout the application and simplifies code that interacts with `Person` objects.

### Data Model

The data model revolves around four primary classes: `FamilyTree`, `FamilyFactory`, `Family`, and `Person`.

- The `FamilyTree` follows the singleton pattern and provides functions for querying and modifying the family structure.
- The `FamilyFactory` uses the factory pattern to populate the `FamilyTree` during instantiation.
- The `Family` represents a unit comprising a mother, a father, and their children.
- A `Person` belongs to a `Family` and can appear as a child or as a parent (mother or father).
- A `Person` can be linked to another `Person` via the `spouse` attribute.

## Dependencies

This project requires the following dependencies:

- Ruby 3.3.5
- Bundler (for managing gem dependencies)

Make sure to install Bundler if you haven't already:

```sh
gem install bundler
```

## Usage

To run the application with a custom `actions.txt` file, you can specify the path to your custom file. For example:

```sh
ruby ./bin/family_tree.rb ./path/to/your/actions.txt
```

This will execute the actions specified in your custom `actions.txt` file.

Alternatively, you can use the Rake task `rake run` to run the application with the included `./data/actions.txt` file:

```sh
rake run
```

## Testing

To run the tests, you can use the Rake tasks defined in the `Rakefile`. Use the following command to run all tests:

```sh
rake test
```

This will execute all the RSpec tests in the `spec` directory.
