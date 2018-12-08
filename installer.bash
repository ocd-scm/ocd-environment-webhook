#!/bin/bash

# Created by argbash-init v2.7.1
# ARG_OPTIONAL_SINGLE([oc-server],[s],[mandatory e.g. 192.168.99.100:8443])
# ARG_OPTIONAL_SINGLE([oc-user],[u],[mandatory username e.g. admin])
# ARG_OPTIONAL_SINGLE([oc-passwd],[p],[mandatory password e.g. admin])
# ARG_OPTIONAL_SINGLE([tiller-namespace],[t],[mandatory namespace where tiller is running])
# ARG_OPTIONAL_SINGLE([namespace],[n],[mandatory namespace to instal into])
# ARG_OPTIONAL_SINGLE([insecure-no-tls-verify],[],[optional skip TLS verify needed for minishift])
# ARG_POSITIONAL_SINGLE([git-url],[mandatory url of the enviroment code to checkout e.g. https://github.com/ocd-scm/ocd-demo-env-build.git ])
# ARG_POSITIONAL_SINGLE([git-name],[mandatory name of the repo that fires the webhook used to sanity check the webhook payload is from the correct repo e.g. ocd-scm/ocd-demo-env-build])
# ARG_HELP([Welcome to the ocd-envrionment-webhook installer. It runs heml to install into the current project. It needs some OC login details as tokens will expire so it will have to periodically login to refresh it's authentication token. It needs to know the namespace where tiller is running which might not be the current project. The login you give it will need permissions to list the pods where tiller is running and to port forward to it. On minishift you can use the admin plugin and just have it use admin/admin. In a secure setup you should run this in a project seperate from both tiller and your main app with a login that can only talk to tiller and nothing else.])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.7.1 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}


begins_with_short_option()
{
	local first_option all_short_options='suptnh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_oc_server=
_arg_oc_user=
_arg_oc_passwd=
_arg_tiller_namespace=
_arg_namespace=
_arg_insecure_no_tls_verify=


print_help()
{
	printf '%s\n' "Welcome to the ocd-envrionment-webhook installer. It runs heml to install into the current project. It needs some OC login details as tokens will expire so it will have to periodically login to refresh it's authentication token. It needs to know the namespace where tiller is running which might not be the current project. The login you give it will need permissions to list the pods where tiller is running and to port forward to it. On minishift you can use the admin plugin and just have it use admin/admin. In a secure setup you should run this in a project seperate from both tiller and your main app with a login that can only talk to tiller and nothing else."
	printf 'Usage: %s [-s|--oc-server <arg>] [-u|--oc-user <arg>] [-p|--oc-passwd <arg>] [-t|--tiller-namespace <arg>] [-n|--namespace <arg>] [--insecure-no-tls-verify <arg>] [-h|--help] <git-url> <git-name>\n' "$0"
	printf '\t%s\n' "<git-url>: mandatory url of the enviroment code to checkout e.g. https://github.com/ocd-scm/ocd-demo-env-build.git "
	printf '\t%s\n' "<git-name>: mandatory name of the repo that fires the webhook used to sanity check the webhook payload is from the correct repo e.g. ocd-scm/ocd-demo-env-build"
	printf '\t%s\n' "-s, --oc-server: mandatory e.g. 192.168.99.100:8443 (no default)"
	printf '\t%s\n' "-u, --oc-user: mandatory username e.g. admin (no default)"
	printf '\t%s\n' "-p, --oc-passwd: mandatory password e.g. admin (no default)"
	printf '\t%s\n' "-t, --tiller-namespace: mandatory namespace where tiller is running (no default)"
	printf '\t%s\n' "-n, --namespace: mandatory namespace to instal into (no default)"
	printf '\t%s\n' "--insecure-no-tls-verify: optional skip TLS verify needed for minishift (no default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-s|--oc-server)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_oc_server="$2"
				shift
				;;
			--oc-server=*)
				_arg_oc_server="${_key##--oc-server=}"
				;;
			-s*)
				_arg_oc_server="${_key##-s}"
				;;
			-u|--oc-user)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_oc_user="$2"
				shift
				;;
			--oc-user=*)
				_arg_oc_user="${_key##--oc-user=}"
				;;
			-u*)
				_arg_oc_user="${_key##-u}"
				;;
			-p|--oc-passwd)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_oc_passwd="$2"
				shift
				;;
			--oc-passwd=*)
				_arg_oc_passwd="${_key##--oc-passwd=}"
				;;
			-p*)
				_arg_oc_passwd="${_key##-p}"
				;;
			-t|--tiller-namespace)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_tiller_namespace="$2"
				shift
				;;
			--tiller-namespace=*)
				_arg_tiller_namespace="${_key##--tiller-namespace=}"
				;;
			-t*)
				_arg_tiller_namespace="${_key##-t}"
				;;
			-n|--namespace)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_namespace="$2"
				shift
				;;
			--namespace=*)
				_arg_namespace="${_key##--namespace=}"
				;;
			-n*)
				_arg_namespace="${_key##-n}"
				;;
			--insecure-no-tls-verify)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_insecure_no_tls_verify="$2"
				shift
				;;
			--insecure-no-tls-verify=*)
				_arg_insecure_no_tls_verify="${_key##--insecure-no-tls-verify=}"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'git-url' and 'git-name'"
	test "${_positionals_count}" -ge 2 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 2 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 2 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_git_url _arg_git_name "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


source ./install.sh

# ] <-- needed because of Argbash