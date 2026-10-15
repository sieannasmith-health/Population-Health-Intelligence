"""Compare manuscript's reported summary figures to exported analyses."""
import csv
from pathlib import Path
root = Path(__file__).resolve().parents[1]
report = (root / 'reports/17_integrated_research_report.md').read_text()
read = lambda name: list(csv.DictReader((root / 'reports' / name).open()))
contrasts = read('16_model_comparison_contrasts.csv')
previous = read('10_complete_case_sensitivity.csv')
missing = read('19_income_missingness_prevalence.csv')
missing_or = read('19_income_missingness_adjusted.csv')[0]
checks = []
for row in contrasts:
    nums = [float(row[k]) for k in ('difference_pp','lower_pp','upper_pp')]
    rendered = f'{nums[0]:.2f}'
    checks.append((f"Contrast {row['model']} {row['dimension']}", rendered in report))
for row in previous:
    checks.append((f"Overall {row['sample']}", f"{float(row['estimate_pct']):.2f}%" in report))
for row in missing:
    checks.append((f"Income missingness {row['status']}", f"{float(row['prevalence_pct']):.2f}%" in report))
checks.append(('Income missingness adjusted OR', f"{float(missing_or['adjusted_or']):.2f}" in report))
for key in ('9,254', '5,569', '5,018', '4,362', '648', '791', '551'):
    checks.append((f'Population count {key}', key in report))
for name, passed in checks:
    print(('PASS' if passed else 'FAIL'), name)
if not all(ok for _,ok in checks):
    raise SystemExit('Reported values require reconciliation')
print(f'PASS: {len(checks)} report consistency assertions')
