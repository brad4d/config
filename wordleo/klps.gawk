#!/usr/bin/gawk --exec
BEGIN {
	if (ARGC > 0 && ARGV[1] ~ /^-h|--help/) {
		print "UZADO: klps [DOSIERO...]"
		print ""
		print "Kalkulu numero de linio ke enhavas cxiuj signo."
		print "Eligu la kalkulojn en malkreskanta ordo."
		exit 1
	}
  # each character in the line is a separate field
  FS = ""
}

{
	delete cxuVidita
	for (i = 1; i <= NF; ++i) {
		signo = $i
		if (! cxuVidita[signo]) {
			cxuVidita[signo] = 1
			kalkulo[signo]++
		}
	}
}

END {
  # Tio cxi farus, ke gawk mem ordigus la signoj, sed sort(1) ordigas pli
  # rapide, lavx mia eksperimentoj.
	# PROCINFO["sorted_in"] = "@val_num_desc"
	for (signo in kalkulo) {
    n = kalkulo[signo]
    pc = 100.0 * n / NR
		printf "%8d %5.2f %s\n", n, pc, signo | "sort -rn"
	}
}

