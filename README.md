# phagrancy-gui-overlay
Simple Sinatra frontend that consumes phagrancy (https://github.com/dlundgren/phagrancy) API

## Installation - WIP

1. Clone Overlay - `git clone https://github.com/syntacticvexation/phagrancy-gui-overlay.git`
2. Run `bundle install` in `phagrancy-gui-overlay`
3. Run `bundle exec puma -e development -p 9292 config.ru`
4. If running nginx to serve phagrancy, you can add the following above the phagrancy config:
<pre>
  location ~ ^/assets/.*$ {
    proxy_pass http://localhost:9292;
  }

  location = / {
    proxy_pass http://localhost:9292;
  }
</pre>
