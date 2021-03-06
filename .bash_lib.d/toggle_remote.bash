# I have a workflow where sometimes I work on my laptop, and sometimes I ssh into it from home.
# This leads to environment issues where I'd prefer to use a different editor based on my current workflow.
# Normally, i would just detect if the bash session is inside SSH, but tmux confounds this.
# So I'm building a set of functions to setup a local/remote environment

function toggle_remote() {
	function _setup_local() {
		export DISPLAY=:0
		export VISUAL="subl -w"
	}

	function _setup_remote() {
		unset DISPLAY
		export VISUAL="vi"
	}

	local desired=""
	if [[ $# -eq 1 ]]; then
		desired="$1"
	else
		if is_remote; then
			desired="remote"
		else
			desired="local"
		fi
	fi
	if [[ "$desired" == "remote" ]]; then
		_setup_remote
	elif [[ "$desired" == "local" ]]; then
		_setup_local
	else
		echo "USAGE: toggle_remote [local|remote]"
	fi

	unset -f _setup_local
	unset -f _setup_remote
}
