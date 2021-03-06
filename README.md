# Jekyll Mentioji

If your site uses both [`jekyll-mentions`](https://github.com/jekyll/jekyll-mentions) and [`jemoji`](https://github.com/jekyll/jemoji), then
using `jekyll-mentioji` *instead*, is going to improve your build times.

Internally, this plugin combines the code & logic behind the above two plugins and adapts the associated code in
[`html-pipeline`](https://github.com/jch/html-pipeline), which the above two plugins wrap around, to emerge as *the faster implementation*
in comparison to using the two plugins together in a site.

## Usage

Replace the two plugins in your `Gemfile` and/or `_config.yml` with this plugin:

```diff
# Gemfile

group :jekyll_plugins do
-   gem "jekyll-mentions"
-   gem "jemoji"
+   gem "jekyll-mentioji"
end
```
```sh
bundle install
```
```diff
# _config.yml

plugins:
-   - jekyll-mentions
-   - jemoji
+   - jekyll-mentioji
```

## Other Notes:

  - This plugin aims to be a zero-config replacement for the two plugins and therefore should be compatible with existing configuration
  for the two plugins. `jekyll-mentioji` will read both existing `jekyll-mentions:` and `emoji:` settings in your config file.
  - A few diversions from the two official plugins:
      - `@mention` can currently include the underscore (`_`) along with alphanumeric characters and hyphen (`-`)
      - `@mention` will not be rendered within `<script></script>`
      - configuration for emoji assets-path mirror that of `jekyll-mentions`: the value can be both a string or a dictionary

### Build times comparison

rvm   | jmentions+jemoji | *jmentioji*
:---: | :----: | :------:
2.2.9 | 15.482 | *13.671*
2.3.6 | 13.798 | *11.988*
2.4.3 | 14.225 | *12.848*
2.5.0 | 14.560 | *12.771*

(built using `jekyll:master@c7f006`)

*Disclaimer: The no.s above are averages of 3 restarted jobs on two separate Travis CI build-commits and therefore cannot be considered as
solid evidence. However, tests run locally do show an improvement of approx. 2s with `jekyll-mentioji` over the combo.*
