# Contributing to C++23 Enterprise Ready Project Skeleton (Template)

Thank you for your interest in contributing to C++23 Enterprise Ready Project Skeleton (Template)! We're glad to collaborate and appreciate your help in improving the project.

## Branching Strategy

This project follows the **Gitflow** branching model:

- `main` contains production-ready code.
- `develop` is the integration branch for ongoing development.
- `feature/*` branches are used for new features and improvements.
- `release/*` branches are used to prepare a new version.
- `hotfix/*` branches are used for urgent fixes on production code.

Please do not push changes directly to `main` or `develop`.

## Getting Started

If this is your first contribution, a good place to begin is with issues labeled:

- `help wanted`
- `good first issue`

These issues are a great way to get familiar with the codebase and contribute meaningfully.

## Spot a Typo?

Small fixes matter. If you notice a typo, formatting issue, or minor documentation improvement, feel free to open a pull request directly. For these kinds of changes, a separate issue is usually not required.

## Have a Suggestion?

If you have an idea to improve C++23 Enterprise Ready Project Skeleton (Template), please open an issue first and include:

- A clear title and description
- Any relevant examples, screenshots, or mockups
- Whether you would like to implement the change yourself

We will review the idea and discuss whether it fits the project roadmap.

## How to Contribute with Gitflow

### 1. Create a branch

Use the appropriate branch type based on your change:

- `feature/<short-description>` for new features
- `bugfix/<short-description>` for non-urgent bug fixes
- `release/<version>` for release preparation
- `hotfix/<short-description>` for urgent production fixes

Example:
```bash
git checkout develop
git checkout -b feature/task-reminders
```

### 2. Make your changes

Keep your changes focused and consistent with the existing code style.

### 3. Test your work

Before submitting a pull request, make sure the project builds and tests pass.

### 4. Open a pull request

Submit your pull request to the correct target branch:

- feature/* branches -> develop
- release/* branches -> main and then back into develop
- hotfix/* branches -> main and then back into develop

## Contribution Principles

When reviewing contributions, we follow these principles:

- Best Practices: We aim to keep the codebase clean, modern, and aligned with C++23 / C++26 best practices.
- Selective Use of Tools: We prefer technologies that fit the project well rather than adding unnecessary complexity.
- Architectural Integrity: Larger refactors are welcome when they improve the design, maintainability, or performance of the application.
- Reliability and Scalability: Contributions that strengthen stability, error handling, and test coverage are especially valuable.
- Performance Improvements: Performance-related changes are welcome, ideally with clear benchmarks or measurable evidence.

## Code of Conduct

Please be respectful and considerate in all interactions. We want C++23 Enterprise Ready Project Skeleton (Template) to remain a welcoming and productive space for everyone.