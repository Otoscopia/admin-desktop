
<a title="Made with Fluent Design" href="https://github.com/bdlukaa/fluent_ui">
  <img
    src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=gray&labelColor=0078D7"
  />
</a>

[![SonarQube Analysis](https://github.com/Otoscopia/admin-desktop/actions/workflows/sonar.yml/badge.svg?branch=main)](https://github.com/Otoscopia/admin-desktop/actions/workflows/sonar.yml)

# admin

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## [Code Review for Flutter developers](https://gist.github.com/vhodiak/5a1c1b4a6cb5950e1251455f0f4a2735)

The following aspects are considered to ensure good quality and high-performance deliverables

1. Requirements

- [x] Task requirements have been met

2. Compiler

- [x] 2.1 Code compiles without any warnings
- [x] 2.2 Static analysis passes
- [x] 2.3 Favorite IDE shows 0 errors, warnings
- [x] 2.4 No spelling mistakes, except for specific project names or 3rd party packages

3. Naming conventions

- [x] 3.1 Classes, enums, typedefs, and extensions name are in UpperCamelCase
- [x] 3.2 Libraries, packages, directories, and source files name are in snake_case(lowercase_with_underscores)
- [x] 3.3 Variables, constants, parameters, and named parameters are in lowerCamelCase
- [x] 3.4 Semantically meaningful naming approach followed

4. Readability

- [x] 4.1 Code is self-explanatory
- [ ] 4.2 Controllers, Views, ViewModels, and Repositories do not contain business logic
- [x] 4.3 There aren't multiple if/else blocks in blocks
- [] 4.4 There isn't hardcoded data
- [x] 4.5 There isn’t any commented-out code
- [] 4.6 The data flow is understandable
- [x] 4.7 Streams, TextEditingControllers, and Listeners are closed
- [x] 4.8 Comments start at /// and contain a clear explanation of method properties, returns, and usage.
- [x] 4.9 Code does not contain print() log()...
- [x] 4.10 Reusable code extracted into mixins, utils, and extensions.
- [x] 4.11 Only private Widgets can be placed in the same file as the parent widget.
- [x] 4.12 Used const in Widgets
- [x] 4.13 Switch Case blocs contain the default value
- [] 4.14 Code fit in the standard 14-inch laptop screen. There shouldn’t be a need to scroll horizontally to view the code


5. Directory structure

- [x] 5.1 Segregation of code into a proper folder structure namely providers, entities, screens/pages, and utils.

6. Linting rules

- [x] 6.1 Used package imports
- [x] 6.2 Used very_good_analysis for lint rules

7. Layout

- [ ] 7.1 Widgets do not contain hardcoded sizes
- [x] 7.2 Widgets do not contain hardcoded colors or font sizes.
- [ ] 7.3 Widgets do not produce render errors

8. State

- [ ] 8.1 Bloc Provider used only at the needed level instead of providing everything at top level
- [ ] 8.2 context.watch() used only when listening to changes
- [ ] 8.3 used context select to listen to specific object properties in order to avoid rebuilding the entire tree

9. Third-party packages

-[x] 9.1 Used third-party services do not break the build.

10. Implementation

- [ ] 10.1 Code follows Object-Oriented Analysis and Design Principles
- [ ] 10.2 Any use case in which the code does not behave as intended
- [ ] 10.3 DRY
- [ ] 10.4 KISS
- [ ] 10.5 YAGNI
- [ ] 10.6 The Single-responsibility principle followed
- [ ] 10.7 The Open–closed principle followed
- [ ] 10.8 The Liskov substitution principle followed
- [ ] 10.9 The Interface segregation principle followed
- [x] 10.10 The Dependency inversion principle followed

11. Error handling

- [x] 11.1 Network requests wrapped into a try .. catch blocks
- [x] 11.2 Exceptions messages are localized
- [ ] 11.3 Error messages are user-friendly

12. Security and Data Privacy

- [x] 12.1 Application dependencies are up to date
- [x] 12.2 Authorization and authentication are handled in the right way
- [x] 12.3 Sensitive data like user data, and credit card information are securely handled and stored.
- [x] 12.4 Environment variables aren't stored in git

13. Performance

- [ ] 13.1 Code changes do not impact the system performance in a negative way
