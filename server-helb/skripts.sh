#!/bin/bash

# Width of the outer frame (total 66 characters)
outer_dash=$(printf '%*s' 64 '' | tr ' ' -)
# Width of the inner frame (total 62 characters)
inner_dash=$(printf '%*s' 62 '' | tr ' ' -)

echo
echo "+$outer_dash+"
echo "|                    📜 AVAILABLE SCRIPTS                    |"
echo "+$outer_dash+"
echo "| +$inner_dash+ |"

for f in /usr/local/bin/*.sh /usr/local/bin/*.py; do
  [ -f "$f" ] || continue
  FN=$(basename "$f")
  # left-aligned on 55 characters, rest is blank
  printf '| |  📜 %-55s | |\n' "$FN"
done

echo "| +$inner_dash+ |"
echo "+$outer_dash+"
