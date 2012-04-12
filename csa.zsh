#
# csa.zsh - Context-Sensitive Alias for Zsh
#

export CSA_CONTEXT
export CSA_PREV_CONTEXT
export CSA_ORIGINAL_ALIAS

typeset -A CSA_CTX2NAME
export CSA_CTX2NAME
typeset -A CSA_NAME2CMD
export CSA_NAME2CMD

#DEBUG function warn { print -P "%F{red}csa: $*%f" }

function csalias { # (ctx, name, cmd)
	CSA_CTX2NAME[$1]="${CSA_CTX2NAME[$1]} $2"
	CSA_NAME2CMD[$1.$2]="$3"
}

function csa_init {
	#DEBUG warn '-> csa_init'
	CSA_ORIGINAL_ALIAS=`alias`
}

function csa_set_context {
	#DEBUG warn '-> csa_set_context'
	CSA_PREV_CONTEXT=$CSA_CONTEXT
	CSA_CONTEXT=$*
	#DEBUG warn "curr ctx: $CSA_CONTEXT"
	#DEBUG warn "prev ctx: $CSA_PREV_CONTEXT"

	if [[ "x$CSA_CONTEXT" != "x$CSA_PREV_CONTEXT" ]]; then
		_csa_reset_alias
		_csa_set_alias_for_context default $CSA_CONTEXT
	fi
}

function _csa_set_alias_for_context {
	#DEBUG warn '-> _csa_set_alias_for_context'
	local cmd ctx name names
	#_csa_reset_alias
	for ctx in $*; do
		names=${CSA_CTX2NAME[$ctx]}
		for name in ${=names}; do
			#DEBUG warn "($ctx) alias $name='${CSA_NAME2CMD[$ctx.$name]}'"
			cmd=${CSA_NAME2CMD[$ctx.$name]}
			alias $name="$cmd"
		done
	done
}

function _csa_reset_alias {
	#DEBUG warn '-> _csa_reset_alias'
	local name2cmd
	local a as
	as=`alias`
	for a in ${(f)as}; do
		unalias ${a%%\=*}
	done
	for name2cmd in ${(f)CSA_ORIGINAL_ALIAS}; do
		eval "alias ${name2cmd%%\=*}=${name2cmd#*\=}"
	done
}
