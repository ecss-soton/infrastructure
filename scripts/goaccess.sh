#!/bin/bash
awk -F\" '{
  if ($2 !~ /^GET /) next
  url = $2
  sub(/^GET /, "", url)
  sub(/ HTTP\/[0-9.]+/, "", url)

  # Drop everything that isn’t a real page view
  if (url ~ /\.(js|css|png|jpg|jpeg|gif|svg|ico|woff2?|webp|avif|json|xml|txt|map)(\?|$)/) next
  if (url ~ /^\/_next\//) next
  if (url ~ /^\/api\//) next
  if (url ~ /^\/service\//) next
  if (url ~ /^\/favicon\.ico$/) next
  if (url ~ /^\/webpack-hmr/) next

  print
}' /var/log/nginx/society-pages.log | /usr/bin/goaccess --log-format=COMBINED --ignore-crawlers \
    --db-path=/srv/goaccess/db/ --persist --restore \
    --output=/var/www/html/stats.html