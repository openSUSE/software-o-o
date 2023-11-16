# software.o.o TODO

## Authentication + Authorization

- Implement devise + omniauth (copy hackweek)
- Implement rolify
- Implement pundit
- build login / account UI

## AppStore

- What to display by default? Latest openSUSE?
- What to display by default? All Packages?
  - What about package duplicates?
- How to get categories per distribution if they are a package association?
- Sort Package by appstream: true first

## Search

## Distribution

- get obs_repo_names from primary.xml
- build admin interface
  - CRUD

## Repository

- Handle HTML in appdata.description
- build admin interface
  - CRUD
  - sync (logs?)
- turn sync methods into services
- turn CacheScreenshotJob sync stuff into service
- make sync idempotent

## Package

- icons
- Handle Package versions / updates (paper_trail)
