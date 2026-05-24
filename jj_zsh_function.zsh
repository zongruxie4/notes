# shellcheck shell=bash

# Search the output of jj log and preview revs. Replace the current token with the selected change ID.
# Adapted from https://codeberg.org/valpackett/dotfiles/src/branch/trunk/.config/fish/functions/_pick_jj_revs.fish
#
# Usage:
#
# Source this file.
# Create the widget: zle -N _pick_jj_revs
# Bind it to a key (e.g., Ctrl+J): bindkey '^j' _pick_jj_revs
# Press Ctrl+J to use it.
#
function _pick_jj_revs() {
    local FUZZY=${FUZZY:-sk}
    if ! jj root >/dev/null 2>&1; then
        echo '_pick_jj_revs: Not in a jj repository.' >&2
    else
        local rev="${LBUFFER##* }"
        local query
        if [[ -n "$rev" ]]; then
            query="ancestors($rev)"
        else
            query='all()'
        fi
        local jj_log_format='format_short_id(change_id) ++ " - " ++ committer.timestamp().local().format("%Y-%m-%d") ++ "  " ++ description.first_line() ++ " " ++ bookmarks.map(|b| "[" ++ b ++ "]").join(" ") ++ "\n"'
        local selected_log_lines
        selected_log_lines=$(
            jj log --color=always --no-graph -T "$jj_log_format" -r "$query" | \
            $FUZZY --ansi --multi --no-sort --layout=default --height=95% \
                --bind=ctrl-j:preview-up,ctrl-k:preview-down,shift-pgup:page-up,shift-pgdn:page-down,pgup:preview-page-up,pgdn:preview-page-down \
                --prompt='jj> ' --preview='jj show --color=always {1}'
        )
        if [[ $? -eq 0 ]]; then
            local rev_hashes=()
            while IFS= read -r line; do
                rev_hashes+=("$(echo "$line" | cut -d' ' -f1)")
            done <<< "$selected_log_lines"
            # Reverse array and join with spaces
            local reversed=("${(@Oa)rev_hashes}")
            LBUFFER="${LBUFFER%$rev}${reversed[*]}"
        fi
    fi

    zle reset-prompt

}
