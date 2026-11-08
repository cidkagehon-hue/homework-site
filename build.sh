#!/bin/bash
cd "$(dirname "$0")"
LAST_WEEK=8        # change this number to show more weeks

count() { ls $1 2>/dev/null | wc -l | tr -d ' '; }

{
cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ankhaa's Homework Hub</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header>
    <h1>Ankhaa's Homework Hub</h1>
    <p>Web Programming · Gachon University</p>
  </header>
  <main>
    <section class="view" id="view-weeks">
      <h2>Choose a week</h2>
      <div class="week-grid">
EOF

# ---- Level 1: week boxes ----
for w in $(seq 1 $LAST_WEEK); do
  total=$(count "week$w-*/*.html")
  if [ "$w" -eq 1 ]; then
    echo "        <button class=\\"week-card\\" data-target=\\"week-1\\"><span class=\\"week-name\\">Group Presentation</span><span class=\\"week-info\\">Personal finance project</span></button>"
    continue
  fi
  if [ "$total" -gt 0 ]; then
    echo "        <button class=\"week-card\" data-target=\"week-$w\"><span class=\"week-name\">Week $w</span><span class=\"week-info\">$total assignments</span></button>"
  else
    echo "        <button class=\"week-card empty\" disabled><span class=\"week-name\">Week $w</span><span class=\"week-info\">Coming soon</span></button>"
  fi
done
echo "      </div>"
echo "    </section>"

cat <<'EOF'
    <section class="view" id="week-1" hidden>
      <button class="back-btn" data-target="view-weeks">← All weeks</button>
      <h2>Group Presentation</h2>
      <div class="presentation-embed">
        <iframe src="FINORA_Personal_Finance_Presentation.pdf" title="Group Presentation slides" loading="lazy"></iframe>
      </div>
    </section>
EOF

for w in $(seq 1 $LAST_WEEK); do
  [ "$(count "week$w-*/*.html")" -gt 0 ] || continue

  # ---- Level 2: Monday / Friday boxes ----
  echo "    <section class=\"view\" id=\"week-$w\" hidden>"
  echo "      <button class=\"back-btn\" data-target=\"view-weeks\">← All weeks</button>"
  echo "      <h2>Week $w</h2>"
  echo "      <div class=\"week-grid\">"
  for p in 1 2; do
    case $p in 1) day="Monday"; slug="mon" ;; 2) day="Friday"; slug="fri" ;; esac
    n=$(count "week$w-$p/*.html")
    if [ "$n" -gt 0 ]; then
      echo "        <button class=\"week-card\" data-target=\"week-$w-$slug\"><span class=\"week-name\">$day</span><span class=\"week-info\">$n assignments</span></button>"
    else
      echo "        <button class=\"week-card empty\" disabled><span class=\"week-name\">$day</span><span class=\"week-info\">Coming soon</span></button>"
    fi
  done
  echo "      </div>"
  echo "    </section>"

  # ---- Level 3: homework boxes for each day ----
  for p in 1 2; do
    d="week$w-$p"
    [ "$(count "$d/*.html")" -gt 0 ] || continue
    case $p in 1) day="Monday"; slug="mon" ;; 2) day="Friday"; slug="fri" ;; esac
    echo "    <section class=\"view\" id=\"week-$w-$slug\" hidden>"
    echo "      <button class=\"back-btn\" data-target=\"week-$w\">← Week $w</button>"
    echo "      <h2>Week $w · $day</h2>"
    for kind in task topic; do
      case $kind in task) K="Task" ;; topic) K="Topic" ;; esac
      [ "$(count "$d/$kind-*.html")" -gt 0 ] || continue
      echo "      <h3>${K}s</h3>"
      echo "      <div class=\"box-grid\">"
      for i in $(seq 1 30); do
        f="$d/$kind-$i.html"
        [ -f "$f" ] && echo "        <a class=\"box\" href=\"$f\" data-src=\"$f\">$K $i</a>"
      done
      echo "      </div>"
    done
    echo "    </section>"
  done
done

cat <<'EOF'
  </main>

  <div id="preview-area" hidden>
    <div class="preview-bar">
      <a id="open-link" href="#" target="_blank" rel="noopener noreferrer">Open in new tab ↗</a>
      <button id="close-btn">Close</button>
    </div>
    <iframe id="preview-frame" title="Homework preview"></iframe>
  </div>

  <footer>
    <p>&copy; 2026 Ankhaa</p>
  </footer>
  <script src="script.js"></script>
</body>
</html>
EOF
} > index.html

echo "index.html rebuilt"
