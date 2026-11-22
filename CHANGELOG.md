# Changelog

All notable changes to this bundle are documented here.

## [Unreleased]

## [1.1.0] - 2026-11-22

### Added

- `inbox-process`: optional `processed_source_cleanup` hook moves leftover download copies of filed originals to the trash after an interactive run (#174).
- `inbox-process`: optional `processed_inbox_cleanup` hook trashes inbox originals and `auto` copies that have an identical copy elsewhere, keeping item records (#176).

## [1.0.0] - 2026-11-22

### Added

- Initial versioned release of the skill bundle, its shared references, and default environment.
