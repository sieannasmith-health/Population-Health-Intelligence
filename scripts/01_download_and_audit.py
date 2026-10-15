"""Download official NHANES XPT files and audit the joined sample (no estimates)."""
from pathlib import Path
from urllib.request import urlretrieve
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / 'data' / 'raw'
OUT = ROOT / 'data' / 'processed'
RAW.mkdir(parents=True, exist_ok=True)
OUT.mkdir(parents=True, exist_ok=True)
BASE = 'https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/'
FILES = {'DEMO_J': ['SEQN','RIDAGEYR','RIAGENDR','RIDRETH3','DMDEDUC2','INDFMPIR','WTMEC2YR','SDMVSTRA','SDMVPSU'],
         'GHB_J': ['SEQN','LBXGH']}
frames = {}
for name, columns in FILES.items():
    target = RAW / f'{name}.XPT'
    if not target.exists():
        print('Downloading',name)
        urlretrieve(BASE + f'{name}.XPT', target)
    df = pd.read_sas(target, format='xport')
    missing = [column for column in columns if column not in df.columns]
    if missing:
        raise ValueError(f'{name} missing columns: {missing}')
    if df.SEQN.duplicated().any():
        raise ValueError(f'Duplicate respondent IDs in {name}')
    frames[name] = df[columns]
    print(name,'records',len(df))
joined = frames['DEMO_J'].merge(frames['GHB_J'], on='SEQN',how='left',validate='one_to_one',indicator=True)
adults = joined.loc[joined.RIDAGEYR>=20].copy()
print('Joined records:', len(joined),'Adults age 20+:',len(adults))
print('HbA1c missing in adults:',int(adults.LBXGH.isna().sum()))
print('Weight missing or nonpositive:',int((adults.WTMEC2YR.isna() | (adults.WTMEC2YR<=0)).sum()))
print('Missing by variable:')
print(adults.isna().sum().to_string())
adults.to_csv(OUT/'adult_hba1c_audit.csv',index=False)
print('Saved:',OUT/'adult_hba1c_audit.csv')
