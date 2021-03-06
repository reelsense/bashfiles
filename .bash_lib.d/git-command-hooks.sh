# git-command-hooks -- a wrapper for git that allows hooks
#
# Note: adding the --force flag to the command
# causes to skip the execution of the precommit hook.
#
# Version: 0.1.0
#
# Works with all Bourne compatible shells.
#
# Based on: https://github.com/rkitover/git-svn-hooks
# Based on: https://raw.github.com/hkjels/.dotfiles/master/zsh/git-svn.zsh
#
# Author: stevenkaras: Steven Karas (steven.karas@gmail.com)
#
# repo: https://github.com/stevenkaras/bashfiles

git() {
    _gitdir=$(command git rev-parse --git-dir 2>/dev/null)

    # Expand git aliases
    _param_1=$1
    export _param_1
    _expanded="$( \
        command git config --get-regexp alias | sed -e 's/^alias\.//' | while read _alias _git_cmd; do \
            if [ "$_alias" = "$_param_1" ]; then \
                echo "$_git_cmd"; \
                break; \
            fi; \
        done \
    )"
    unset _param_1

    # check for !shell-command aliases
    case "$_expanded" in
    \!*)
        _expanded=$(echo "$_expanded" | sed -e 's/.//')
        shift
        eval "$_expanded \"\$@\""
        _exit_val=$?
        unset _gitdir _expanded
        return $_exit_val
        ;;
    *)
        if [ -n "$_expanded" ]; then
            shift
            eval "git $_expanded \"\$@\""
            _exit_val=$?
            unset _gitdir _expanded
            return $_exit_val
        fi
        ;;
    esac
    unset _expanded

    # Pre hooks
    if [ -x "$_gitdir/hooks/pre-command-$1" ]; then
        if ! "$_gitdir/hooks/pre-command-$1" "${@:2}"; then
            _exit_val=$?
            unset _gitdir
            return $_exit_val
        fi
    fi

    # call git
    command git "$@"
    _exit_val=$?

    # Post hooks
    if [ -x "$_gitdir/hooks/post-command-$1" ]; then
        if ! "$_gitdir/hooks/post-command-$1" "${@:2}"; then
            _exit_val=$?
            unset _gitdir
            return $_exit_val
        fi
    fi

    unset _gitdir
    return $_exit_val
}

# Copyright (c) 2016, Steven Karas
# Portions copyright (c) 2013, Rafael Kitover
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
