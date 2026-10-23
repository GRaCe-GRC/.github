#!/usr/bin/env bash
set -euo pipefail

csv="${1:-target/site/jacoco/jacoco.csv}"

echo "### Coverage (JaCoCo)"
echo

if [[ ! -f "$csv" ]]; then
  echo "No coverage report was produced (\`$csv\` not found)."
  exit 0
fi

awk -F, '
  function percent(covered, total) {
    return total ? sprintf("%.1f%%", 100 * covered / total) : "n/a"
  }
  NR == 1 {
    for (i = 1; i <= NF; i++) column[$i] = i
    next
  }
  {
    line_missed += $column["LINE_MISSED"]
    line_covered += $column["LINE_COVERED"]
    branch_missed += $column["BRANCH_MISSED"]
    branch_covered += $column["BRANCH_COVERED"]
  }
  END {
    print "| | Covered | Total | % |"
    print "|---|---|---|---|"
    printf "| Lines | %d | %d | %s |\n", line_covered, line_covered + line_missed, percent(line_covered, line_covered + line_missed)
    printf "| Branches | %d | %d | %s |\n", branch_covered, branch_covered + branch_missed, percent(branch_covered, branch_covered + branch_missed)
  }
' "$csv"
