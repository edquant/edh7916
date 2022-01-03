# EDH 7916: Contemporary Research in Higher Education

Class and website materials for EDH 7916: Contemporary Research in
Higher Education.

## Branches

Setup based on this [gist](https://gist.github.com/chrisjacob/825950).

- `main` branch holds primary files and ignores `_site` subdirectory
  (local to machine)
- `gh-pages` branch works in `_site` directory and holds files for
  website  
  
## To build

1. On `main` branch in top-level directory, run `bundle exec jekyll build`
2. (on `main` branch) `add`, `commit`, and `push` to remote `main`
3. `cd` into `_site` subdirectory
4. (on `gh-pages` branch now) `add`, `commit`, and `push` to remote
   `gh-pages`
