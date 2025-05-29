from datetime import date
year = date.today().year
print("Hello Beneva " + str(year))
df = SAS.sd2df("SASHELP.class")
print(df)

df['year'] = 2023
SAS.df2sd(df,"DEMO2")