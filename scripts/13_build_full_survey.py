"""Merge all-age public NHANES source records for survey-domain analysis."""
from pathlib import Path
import pandas as pd
root = Path(__file__).resolve().parents[1]
raw = root / "data/raw"
out = root / "data/processed/all_age_hba1c_survey.csv"
cols = ["SEQN", "RIDAGEYR", "RIAGENDR", "RIDRETH3", "DMDEDUC2",
        "INDFMPIR", "WTMEC2YR", "SDMVSTRA", "SDMVPSU"]
demo = pd.read_sas(raw / "DEMO_J.XPT", format="xport")[cols]
ghb = pd.read_sas(raw / "GHB_J.XPT", format="xport")[["SEQN", "LBXGH"]]
assert demo.SEQN.is_unique and ghb.SEQN.is_unique
all_age = demo.merge(ghb, on="SEQN", how="left", validate="one_to_one")
assert all_age.SEQN.is_unique
all_age.to_csv(out, index=False)
print("All age records:", len(all_age))
print("Adults >=20:", sum(all_age.RIDAGEYR >= 20))
print("Adult HbA1c observed:", sum((all_age.RIDAGEYR >= 20) & all_age.LBXGH.notna()))
print("Saved:", out)
