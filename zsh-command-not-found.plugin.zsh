#!/bin/zsh

if ! which brew > /dev/null; then return; fi

homebrew_command_not_found_handle() {

    local cmd="$1"

    if test -z "$CONTINUOUS_INTEGRATION" && test -n "$MC_SID" -o ! -t 1 ; then
        [ -n "$BASH_VERSION" ] && \
            TEXTDOMAIN=command-not-found echo $"$cmd: command not found"

        [ -n "$ZSH_VERSION" ] && [[ "$ZSH_VERSION" > "5.2" ]] && \
            echo "zsh: command not found: $cmd" >&2
        return 127
    fi

    local txt="$(brew which-formula --explain $cmd 2>/dev/null)"

    if [ -z "$txt" ]; then
        [ -n "$BASH_VERSION" ] && \
            TEXTDOMAIN=command-not-found echo $"$cmd: command not found"

        [ -n "$ZSH_VERSION" ] && [[ "$ZSH_VERSION" > "5.2" ]] && \
            echo "zsh: command not found: $cmd" >&2
    else
        echo "$txt"
    fi

    return 127
}

if [ -n "$BASH_VERSION" ]; then
    command_not_found_handle() {
        homebrew_command_not_found_handle $*
        return $?
    }
elif [ -n "$ZSH_VERSION" ]; then
    command_not_found_handler() {
        homebrew_command_not_found_handle $*
        return $?
    }
fi