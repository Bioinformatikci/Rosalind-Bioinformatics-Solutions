import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
import seaborn as sns

df1 = pd.read_csv("HW_GBM_DEVAM.csv",index_col=0)
gbm_cols = df1.iloc[:, 0:5]
sur_cols = df1.iloc[:, 5:12]

df1["p_value"] = -np.log10(df1["p_value"])

plt.figure(figsize=(10, 8)) # Grafiği biraz büyütelim (10'a 8 inç)
plt.scatter(x=df1["Fold_Change_Log2"],y=df1["p_value"], c="red", alpha=0.6, s=20)
plt.show()
