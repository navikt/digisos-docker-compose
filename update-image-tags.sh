#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

usage() {
  printf 'Usage: %s [--dry-run]\n' "${0##*/}"
}

dry_run=false
case "${1:-}" in
  '') ;;
  --dry-run) dry_run=true ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac
if (( $# > 1 )); then
  usage >&2
  exit 2
fi

command -v gcloud >/dev/null || { printf 'gcloud is required\n' >&2; exit 1; }
# Resolve the file next to the script, regardless of the current directory.
compose="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/docker-compose.yml"
temp=$(mktemp "${compose}.XXXXXX")
trap 'rm -f "$temp"' EXIT
cp -p "$compose" "$temp"
: > "$temp"

image_line="^([[:space:]]*image:[[:space:]]*)([^[:space:]\"']+):([^[:space:]#]+)([[:space:]]*(#.*)?)$"
digisos_tag='^[0-9]{4}\.[0-9]{2}\.[0-9]{2}-[0-9]{2}\.[0-9]{2}-[0-9a-f]{7,}$'
wonderwall_tag='^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}-[0-9a-f]{7,}$'
changed=false

while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ $line =~ $image_line ]]; then
    prefix=${BASH_REMATCH[1]}
    image=${BASH_REMATCH[2]}
    current=${BASH_REMATCH[3]}
    suffix=${BASH_REMATCH[4]}
    pattern=''
    if [[ $image == *.pkg.dev/* && $current =~ $digisos_tag ]]; then
      pattern=$digisos_tag
    elif [[ $image == *.pkg.dev/* && $current =~ $wonderwall_tag ]]; then
      pattern=$wonderwall_tag
    fi

    if [[ -n $pattern ]]; then
      if ! tags=$(gcloud artifacts docker tags list "$image" --format='value(tag.basename())' --quiet); then
        printf 'Failed to list tags for %s; no changes written\n' "$image" >&2
        exit 1
      fi
      latest=''
      while IFS= read -r tag; do
        if [[ $tag =~ $pattern && ( -z $latest || $tag > $latest ) ]]; then
          latest=$tag
        fi
      done <<< "$tags"
      if [[ -z $latest ]]; then
        printf 'No matching timestamp tags for %s; no changes written\n' "$image" >&2
        exit 1
      fi
      # Never replace a newer pinned tag with an older one.
      if [[ $latest > $current ]]; then
        printf '%s: %s -> %s\n' "$image" "$current" "$latest"
        line="${prefix}${image}:${latest}${suffix}"
        changed=true
      else
        printf '%s: %s (unchanged)\n' "$image" "$current"
      fi
    fi
  fi
  printf '%s\n' "$line" >> "$temp"
done < "$compose"

if [[ $changed == true && $dry_run == false ]]; then
  mv -f "$temp" "$compose"
elif [[ $dry_run == true ]]; then
  printf 'Dry run: no changes written\n'
fi
