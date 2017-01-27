**Version 0.1.14** - *2017-01-27*

- Setting bundle last modified to max bundle modified time

**Version 0.1.13** - *2017-01-27*

- Setting bundle last modified to boot time

**Version 0.1.12** - *2017-01-26*

- Reverted symlinks, assets must be file

**Version 0.1.11** - *2017-01-25*

- Assets and images now follow symlinks

**Version 0.1.10** - *2017-01-22*

- Included rubyracer as dependency, fixed Uglifier now working
- Refactored router, now 404 only if item not found

**Version 0.1.9** - *2017-01-19*

- Added auto-reload with listen gem for development mode

**Version 0.1.8** - *2017-01-19*

- Removed tilt as dependency, using Sass only
- Fixed cache disk writing

**Version 0.1.7** - *2017-01-18*

- Production mode also for staging

**Version 0.1.6** - *2017-01-18*

- Reading the file content instead of timestamp for cache key

**Version 0.1.5** - *2017-01-18*

- Correct load order for bundle

**Version 0.1.4** - *2017-01-18*

- Moved images to /images instead of /assets/images

**Version 0.1.3** - *2017-01-18*

- Added more greedy regex for files with dashes

**Version 0.1.2** - *2017-01-18*

- Removed old options, manifest is now only for bundle

**Version 0.1.1** - *2017-01-16*

- Moved image timestamps to startup

**Version 0.1.0** - *2017-01-07*

- Renamed application.js/css to bundle.js/css
- Options added for robots.txt and favicon.ico
- Compress and bundle options are working
- Fixed caching issue

**Version 0.0.3** - *2017-01-05*

- Fixed gemspec issues
