# coder-templates

Project containing all of our templates for [Coder](https://workspaces-dev.nextcloud.aero).

## Process for adding a template

1. Create a directory in the `templates` directory.
   1. The name of the directory cannot exceed 32 chars, this will be the name of the template in coder
   1. Do not use dots `.` in the name of the directory either
1. Create a `main.tf` and `README.md` files in the directory, these are the template contents
1. Create a `.yml` file with the same name as the directory.  This is the parameters for the template
   1. In this file put any values used as variables within the `main.tf`.
   1. Put `display-name:` and `description:`. These will be used to make the display in coder more friendly.

## Things to Remember

- template names cannot exceed 32 chars
- template names cannot have dots `.` in them

## TODO

- Deploy only the changed templates instead of all of them all the time
- Refactor the terraform to reduce the duplicated sections
