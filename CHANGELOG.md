## 0.19.1

- Download with net/http(s) instead of open-uri
- Remove threading, need more test.

## 0.18.0 - Oct. 2025

- Adding threads on tasks
- Random user-agent on each download
- Code improvement with Rubocop

### Fixes

- Skip in not things or things[] is nil
- Error on download with file.path

## 0.16.0, release 01/2025

- Reaver stop rewriting our yaml collections and erase indentation...
- Change the user-agent used for a more generic `Mozilla/5.0 (Windows NT 10.0; WOW64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6556.192 Safari/537.36`
- Can add `keep_name = true` per file, not only globally.

## 0.14.0, release 11/2024

- Can `git clone` && `git pull` if use `things[].git: true`

## 0.12.0

- Add `--strip-components=1` to tar, by default set to `1` may be changed by
  `things[].strip_components: <number>` variable

## 0.11.0, release 10/2024

- can extract tar.xz archive.

## 0.10.1

- For `all_to_dir_path` or `things[].dest_dir`, all paths are relative to `$HOME` (or
  /home/<name>), so don't include shell variable `~` or `$HOME`.
- unzip not interactive with `-o`.

## 0.10.0, release 10/2024

- New variable for collections, all_into_dir, things.dest_dir, keep_name and
  force_download.
- Use [Marcel](https://github.com/rails/marcel) to detect file mime.
- Can decompress archive `zip` or `tar.gz (gzip)` using unzip and tar from `unix`.
- Cam move files to specific directory.

## 0.7.0, release 12/24/22

- Each collections download things in separate directory.
- Add a `changed` boolean if a file change.
- Stop modifying collection content, add them in a file called `metadata.yml`.
- Improve runtime.

## 0.4.0, release 12/22/22

- Renaming project.
- Add a banner.
- Separate main.
- Add collection yml.
- Download stack.

## 0.0.1, release 12/21/22

- Initial push, code released!
