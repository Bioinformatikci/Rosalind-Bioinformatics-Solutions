import pandas as pd
import numpy as np
from scipy import stats



df1 = pd.read_csv("HW_GBM.csv")

df1['Fold_Change'] = (df1.iloc[:, 1:6].mean(axis=1)) / (df1.iloc[:, 6:].mean(axis=1))
df2 = df1.groupby("GeneName").mean()
df2["Fold_Change_Log2"] = np.log2(df2["Fold_Change"])

fc_change_increase = df2[df2["Fold_Change_Log2"]>=1][["Fold_Change_Log2"]]
fc_change_increase.to_csv("FC_increase.csv")

fc_change_decrease = df2[df2["Fold_Change_Log2"]<=-1][["Fold_Change_Log2"]]
fc_change_decrease.to_csv("FC_decrease.csv")

t_stats = []
p_values = []
for i,r in df2.iterrows():
    gbm = r.iloc[:5]
    tissue = r.iloc[5:12]
    t, p = stats.ttest_ind(gbm, tissue,equal_var=False)
    p_values.append(p)

df2['p_value'] = p_values
df2.to_csv("HW_GBM_DEVAM.csv")

p_005 = df2[df2["p_value"]<=0.05]
p_005.to_csv("p_005.csv")
p_001 = df2[df2["p_value"]<=0.01]
p_001.to_csv("P_001.csv")













