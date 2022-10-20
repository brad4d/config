#!/usr/bin/gawk --exec
#
# Use gawk because:
# 1. It handles Unicode correctly.
# 2. It provides the --exec option so users of this script don't have to specify '--'
#    on the command line to separate options for this script from options for gawk.

BEGIN {
	# TODO: adjust this usage message
	if (ARGC >= 1 && ARGV[1] ~ /-h|--help/) {
		print "USAGE: <script-name> [FILE...]"
		exit 1
	}
}

{
	# TODO: Add a condition?
	# TODO: do something for each line
}

END {
}

