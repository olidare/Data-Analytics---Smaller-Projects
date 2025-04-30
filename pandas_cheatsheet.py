Pandas Python Cheat Sheet


import pandas as pd
import numpy as np
import seaborn as sns
import datetime
import plotly.express as px 
from matplotlib import pyplot as plt

#pulling out a values from a dict of tuples:

california_list = [aqi for county, aqi in aqi_dict['California']]
sum_aqi = 0
for x in california_list:
    sum_aqi += x   
mean_aqi = (sum_aqi / len(california_list))


### PANDAS SECTION ###

#Primary data structures
#Pandas has two primary data structures: Series and DataFrame. 

#Series: A Series is a one-dimensional labeled array that can hold any data type. It’s similar to a column in a spreadsheet or a one-dimensional NumPy array. Each element in a series has an associated label called an index. The index allows for more efficient and intuitive data manipulation by making it easier to reference specific elements of your data.

#DataFrame: A dataframe is a two-dimensional labeled data structure—essentially a table or spreadsheet—where each column and row is represented by a Series.


df = pd.read_csv('student_data.csv')

df.shape - lists columns and rows
df.head() OR df.tail() - top/bottom rows
df.info()  - summary info on df, Null values, Dtype etc
copy() Makes a copy of the dataframe’s indices and data
describe() Returns descriptive statistics of the dataframe, including the minimum, maximum, mean, and percentile values of its numeric columns; the row count; and the data types
drop() Drops specified labels from rows or columns
groupby() Splits the dataframe, applies a function, and combines the results
info() Returns a concise summary of the dataframe
isna() Returns a same-sized Boolean dataframe indicating whether each value is null (can also use isnull() as an alias)
sort_values() Sorts by the values across a given axis
value_counts() Returns a series containing counts of unique rows in the dataframe
where() Replaces values in the dataframe where a given condition is false

# SERIES is one column or Row , 1 dimensional
get_certain_columns = df[['Age','Math Grade']]
create_df_series =  df['Name']

# iloc Accesses a group of rows and columns using integer-based indexing
#to select first 30 rows from index 
first_thirty_loc = df.iloc[:30]

# get even rows
even_rows_english = english_name.iloc[lambda x: x.index % 2 == 0]
even_rows_english = english_name.loc[0::2, ['Age', 'Maths Grade'] ] - cert

# loc[]  - Accesses a group of rows and columns by label(s) or a Boolean array

first_thirty_loc = df.loc[1:31,['Age', 'Maths Grade']]

# Add a column

df['Age Plus 60'] = df['Age'] + 60

		##							##
		##	 BOOLEAN MASKS			##
		##							##

#Boolean masks You know that Boolean is used to describe any binary variable whose possible values are true or false.
#With pandas, Boolean masking, also called Boolean indexing, is used to overlay a Boolean grid onto a dataframe's index in order to select 
#only the values in the dataframe that align with the True values of the grid. "

mask = (df['moons'] < 10) | (df['moons'] > 50)
mask = (df['moons'] > 20) & ~(df['moons'] == 80) & ~(df['radius_km'] < 50000)

paid_100_mask = df['Total Charges'] > 100
age_of_paid_100 = df.loc[paid_100_mask, 'Age'] 
age_of_paid_100 = df[df['Total Charges'] > 100, 'Age']


mask_null = df["internet Service"].isna()
df[mask_null] FOR Where there are N/A internet Service values
df[~mask_null] opposite, for when internet service has values.

# can combine masks
df[mask1 & mask2] ... df[(~mask1) | mask2]
df[~(df['Total Charges'] >= 100) | (df['Age'] >= 18)  ]

#More examples
missing_info = df.loc[ (df["Box Office ($M)"].isna()) | (df['Rating'].isna()), 'Title']
popular_pg_movies = df.loc[ (df["Box Office ($M)"]>1000) & (df['Rating']>8.9), 'Title']

#GROUP BY

The groupby() function is a method that belongs to the DataFrame class. 
It works by splitting data into groups based on specified criteria, applying a function to each group independently, 
then combining the results into a data structure. When applied to a dataframe, the function returns a groupby object. 

This groupby object serves as the foundation for different data manipulation operations, including:

Aggregation: Computing summary statistics for each group
Transformation: Applying functions to each group and returning modified data
Filtration: Selecting specific groups based on certain conditions
Iteration: Iterating over groups or values


🔹 Final Takeaways
✅ Memorize the Pattern:

df.groupby('Column').agg(
    NewColumn1=('OriginalColumn1', 'sum'),
    NewColumn2=('OriginalColumn2', 'mean')
).reset_index()
✅ For multiple aggregations, use .agg({}).
✅ Use NamedAgg() for readability.
✅ Use reset_index() to keep columns visible.
✅ Grouping by dates? Convert to datetime first!


#Examples - does sums on the numeric fields 
grouped = clothes.groupby('type').mean()
grouped = clothes.groupby(['type', 'color']).min()

# Calculate the mean count of lightning strikes for each weekday.
df[['weekday','number_of_strikes']].groupby(['weekday']).mean()

#COMMON

count(): The number of non-null values in each group
sum(): The sum of values in each group
mean(): The mean of values in each group
median(): The median of values in each group
min(): The minimum value in each group
max(): The maximum value in each group
std(): The standard deviation of values in each group
var(): The variance of values in each group

#APPLY VS ASSIGN

apply() method applies the function to all the elements of the DataFrame, 
while the assign() method helps create a new column based on the results of the lambda function

# AGG 

The agg() function is useful when you want to apply multiple functions to a dataframe at the same time. 
 agg() is a method that belongs to the DataFrame class.

# Calculate total lightning strikes for each month of each year.
lightning_by_month = union_df.groupby(['month_txt','year']).agg(
    number_of_strikes = pd.NamedAgg(column='number_of_strikes',aggfunc=sum)
    ).reset_index()

# This means that within each group, it will sum the number_of_strikes column.
# The result will be stored in a new column called number_of_strikes.

#Example DF

   color  mass_g  price_usd   type
0    red     125         20  pants
1   blue     440         35  shirt
2  green     680         50  shirt
3   blue     200         40  pants
4  green     395        100  shirt
5    red     485         75  pants

# Specify which columns 'price' and 'mass', get the sum and mean of them.
clothes[['price_usd', 'mass_g']].agg(['sum', 'mean'])

# groupby() with agg()

Ex,1

clothes.groupby('color').agg({'price_usd': ['mean', 'max'],
                             'mass_g': ['mean', 'max']})

OUTPUT:                             
      price_usd      mass_g     
           mean  max   mean  max
color                           
blue       37.5   40  320.0  440
green      75.0  100  537.5  680
red        47.5   75  305.0  485          

Ex,2     

grouped = clothes.groupby(['color', 'type']).agg(['mean', 'min'])

OUTPUT:

            mass_g      price_usd    
              mean  min      mean min
color type                           
blue  pants  200.0  200      40.0  40
      shirt  440.0  440      35.0  35
green shirt  537.5  395      75.0  50
red   pants  305.0  125      47.5  20     

		##							##
		##	 DATA MERGING			##
		##							##

# We will merge the lightning_by_month dataframe with the lightning_by_year dataframe, specifying to merge on the year column. 
# This means that wherever the year columns contain the same value in both dataframes, a row is created in our new dataframe with all the other columns 
# from both dataframes being merged.

# Calculate total lightning strikes for each month of each year.
lightning_by_month = union_df.groupby(['month_txt','year']).agg(
    number_of_strikes = pd.NamedAgg(column='number_of_strikes',aggfunc=sum)
    ).reset_index()

# Calculate total lightning strikes for each year.
lightning_by_year = union_df.groupby(['year']).agg(
  year_strikes = pd.NamedAgg(column='number_of_strikes',aggfunc=sum)
).reset_index()

# Combine `lightning_by_month` and `lightning_by_year` dataframes into single dataframe.
percentage_lightning = lightning_by_month.merge(lightning_by_year,on='year')

# Create a new column in our new dataframe that represents the percentage of total lightning strikes that occurred during each month for each year. 
# We will do this by dividing the number_of_strikes column by the year_strikes

plt.figure(figsize=(10,6));

month_order = ['January', 'February', 'March', 'April', 'May', 'June', 
               'July', 'August', 'September', 'October', 'November', 'December']

sns.barplot(
    data = percentage_lightning,
    x = 'month_txt',
    y = 'percentage_lightning_per_month',
    hue = 'year',
    order = month_order );
plt.xlabel("Month");
plt.ylabel("% of lightning strikes");
plt.title("% of lightning strikes each Month (2016-2018)");





		##							##
		##	 DATE EXAMPLES			##
		##							##

# Convert date column to datetime
df['date']= pd.to_datetime(df['date'])

# Create a new `month` column
df['month'] = df['date'].dt.month

# Create four new columns with strftime.
df['week'] = df['date'].dt.strftime('%Y-W%V')
df['month'] = df['date'].dt.strftime('%Y-%m')
df['quarter'] = df['date'].dt.to_period('Q').dt.strftime('%Y-Q%q')
df['year'] = df['date'].dt.strftime('%Y')

# Create two new columns.  week number 1-52 and weekday
df['week'] = df.date.dt.isocalendar().week
df['weekday'] = df.date.dt.day_name()

# Calculate total number of strikes per month
df.groupby(['month']).sum().sort_values('number_of_strikes', ascending=False).head(12)

# Create a new `month_txt` column. First 3 letters.
df['month_txt'] = df['date'].dt.month_name().str.slice(stop=3)

# Create a new helper dataframe for plotting.
df_by_month = df.groupby(['month','month_txt']).sum().sort_values('month', ascending=True).head(12).reset_index

# Plot the number of weekly lightning strikes in 2018
df_by_week_2018 = df[df['year'] == '2018'].groupby(['week']).sum().reset_index()


		##							##
		##	 DATA VIZUALISATIONS	##
		##							##

#PLTPLOT BAR CHAR

# we can't read the x-axis labels. To fix this problem, ult plt.figure to make biiger
# This will change the size to 20 inches wide by 5 inches tall.
plt.figure(figsize=(20, 5)). 

# Example 1

plt.bar(x=df_by_month['month_txt'],height= df_by_month['number_of_strikes'], label="Number of strikes")
plt.plot()

plt.xlabel("Months(2018)")
plt.ylabel("Number of lightning strikes")
plt.title("Number of lightning strikes in 2018 by months")
plt.legend()
plt.show()

#Ex2 - groupny inndustry

companies_sample["years_till_unicorn"] = companies_sample["Year Joined"] - companies_sample["Year Founded"]

# Group the data by `Industry`. For each industry, get the max value in the `years_till_unicorn` column.
grouped = (companies_sample[["Industry", "years_till_unicorn"]]
           .groupby("Industry")
           .max()
           .sort_values(by="years_till_unicorn")
          )
grouped

plt.bar(grouped.index, grouped["years_till_unicorn"])

# Set title
plt.title("Bar plot of maximum years taken by company to become unicorn per industry (from sample)")
# Set x-axis label
plt.xlabel("Industry")
# Set y-axis label
plt.ylabel("Maximum number of years")
# Rotate labels on the x-axis as a way to avoid overlap in the positions of the text  
plt.xticks(rotation=45, horizontalalignment='right')
# Display the plot
plt.show()

# EX3 - Visualize unicorn companies' maximum valuation for each industry represented in the sample.

grouped_valuation = (companies_sampled[["Industry", "valuation_billions"]]
           .groupby("Industry")
           .max()
           .sort_values(by="valuation_billions")
)
grouped_valuation

plt.bar(grouped_valuation.index, grouped_valuation["valuation_billions"])

# Set title
plt.title("Bar plot of maximum unicorn company valuation per industry (from sample)")
# Set x-axis label
plt.xlabel("Industry")
# Set y-axis label
plt.ylabel("Maximum valuation in billions of dollars")
plt.xticks(rotation=45, horizontalalignment='right')
plt.show()

# EXAMPLE 4 - plot a bar graph of weekly strike totals in 2018.
plt.bar(x = df_by_week_2018['week'], height = df_by_week_2018['number_of_strikes'])
plt.plot()
plt.xlabel("Week number")
plt.ylabel("Number of lightning strikes")
plt.title("Number of lightning strikes per week (2018)");

# EXAMLE 5 - ADD LABELS WITH FUNCTION

def addlabels(x, y, labels):
    '''
    Iterates over data and plots text labels above each bar of bar graph.
    '''
    for i in range(len(x)):
        plt.text(i, y[i], labels[i], ha = 'center', va = 'bottom')
        
plt.figure(figsize = (15, 5))
plt.bar(x = df_by_quarter['quarter'], height = df_by_quarter['number_of_strikes'])
addlabels(df_by_quarter['quarter'], df_by_quarter['number_of_strikes'], df_by_quarter['number_of_strikes_formatted'])
plt.plot()
plt.xlabel('Quarter')
plt.ylabel('Number of lightning strikes')
plt.title('Number of lightning strikes per quarter (2016-2018)')
plt.show()       

### EXAMPLE 6 - Create a grouped bar chart

# Create two new columns. break out the quarter and year from the quarter column
df_by_quarter['quarter_number'] = df_by_quarter['quarter'].str[-2:]
df_by_quarter['year'] = df_by_quarter['quarter'].str[:4]
df_by_quarter.head()

#THEN:

# This code below is using Seaborn (sns) to create a bar plot from a dataset called df_by_quarter.
# p.patches → Contains all the bars in the plot.

plt.figure(figsize = (15, 5))
p = sns.barplot(
    data = df_by_quarter,
    x = 'quarter_number',
    y = 'number_of_strikes',
    hue = 'year')

# round(b.get_height()/1000000, 1) + 'M' → Converts the value into millions and rounds it to one decimal place, then adds 'M' (for millions).
# (b.get_x() + b.get_width() / 2., b.get_height() + 1.2e6) → Determines the position of the annotation.
# b.get_height() + 1.2e6 → Places the text slightly above the bar.
# ha='center' → Centers the text horizontally.
# va='bottom' → Aligns the text from the bottom.
# xytext=(0, -12), textcoords='offset points' → Adjusts the text position slightly for better readability.

for b in p.patches:
    p.annotate(str(round(b.get_height()/1000000, 1))+'M', 
                   (b.get_x() + b.get_width() / 2., b.get_height() + 1.2e6), 
                   ha = 'center', va = 'bottom', 
                   xytext = (0, -12), 
                   textcoords = 'offset points')
plt.xlabel("Quarter")
plt.ylabel("Number of lightning strikes")
plt.title("Number of lightning strikes per quarter (2016-2018)")
plt.show()

## EXAMPLE 7 - Box Plot

# Define order of days for the plot.
weekday_order = ['Monday','Tuesday', 'Wednesday', 'Thursday','Friday','Saturday','Sunday']

# Remember that showfliers is the parameter that controls whether or not outliers are displayed in the plot. 
# If we input True, outliers are included; if we input False, outliers are left off of the box plot.

# Create boxplots of strike counts for each day of week.
g = sns.boxplot(data=df, 
            x='weekday',
            y='number_of_strikes', 
            order=weekday_order, 
            showfliers=False 
            );
g.set_title('Lightning distribution per weekday (2018)');

## EXAMPLE 8 - Histograms

# Plot histogram with matplotlib pyplot
plt.hist(df['seconds'], bins=range(40, 101, 5))  #increment by 5 between 40-100
plt.xticks(range(35, 101, 5))
plt.yticks(range(0, 61, 10))
plt.xlabel('seconds')
plt.ylabel('count')
plt.title('Old Faithful geyser - time between eruptions')
plt.show();

# Plot histogram with seaborn
ax = sns.histplot(df['seconds'], binrange=(40, 100), binwidth=5, color='#4285F4', alpha=1)
ax.set_xticks(range(35, 101, 5))
ax.set_yticks(range(0, 61, 10))
plt.title('Old Faithful geyser - time between eruptions')
plt.show();

### ADVANCED HISTOGRAM ###


plt.hist(estimate_df['estimate'], bins=25, density=True, alpha=0.4, label = "histogram of sample means of 10000 random samples")
xmin, xmax = plt.xlim()
x = np.linspace(xmin, xmax, 100) # generate a grid of 100 values from xmin to xmax.
p = stats.norm.pdf(x, mean_sample_means, stats.tstd(estimate_df['estimate']))
plt.plot(x, p,'k', linewidth=2, label = 'normal curve from central limit theorem')
plt.axvline(x=population_mean, color='g', linestyle = 'solid', label = 'population mean')
plt.axvline(x=estimate1, color='r', linestyle = '--', label = 'sample mean of the first random sample')
plt.axvline(x=mean_sample_means, color='b', linestyle = ':', label = 'mean of sample means of 10000 random samples')
plt.title("Sampling distribution of sample mean")
plt.xlabel('sample mean')
plt.ylabel('density')
plt.legend(bbox_to_anchor=(1.04,1))
plt.show()

# EXAMPLE 9 - Geo Scatter

# Create new df of just latitude, longitude, and number of strikes and group by latitude and longitude
top_missing = df_null_geo[['latitude','longitude','number_of_strikes_x']
            ].groupby(['latitude','longitude']
                      ).sum().sort_values('number_of_strikes_x',ascending=False).reset_index()


import plotly.express as px  # Be sure to import express as it speed up everything
# reduce size of db otherwise it could break
fig = px.scatter_geo(top_missing[top_missing.number_of_strikes_x>=300],  # Input Pandas DataFrame
                    lat="latitude",  # DataFrame column with latitude
                    lon="longitude",  # DataFrame column with latitude
                    size="number_of_strikes_x") # Set to plot size as number of strikes


fig.update_layout(
    title_text = 'Missing data', # Create a Title
    geo_scope='usa',  # Plot only the USA instead of globe
)

fig.show()


# EXAMPLE 10 BOX PLOT

# A boxplot can help to visually break down the data into percentiles / quartiles, which are important summary statistics. 
#The shaded center of the box represents the middle 50th percentile of the data points. This is the interquartile range, or IQR.

# Create boxplot
box = sns.boxplot(x=df['number_of_strikes'])
g = plt.gca()
box.set_xticklabels(np.array([readable_numbers(x) for x in g.get_xticks()]))
plt.xlabel('Number of strikes')
plt.title('Yearly number of lightning strikes');


		##							##
		##	 GOOD RANDOM EXAMPLES	##
		##							##
		
#Rename a column
DataFrame.rename(columns={'column1': 'COLUMN_1', 'column2':'COLUMN_2'}, inplace=True)		

#To delete a column
DataFrame.drop(['Column_Name'], axis=1)

#To delete a row
DataFrame.drop([Row_Index_Number], axis=0)

# To update a value (Year Founded) for the Company InVision
companies.loc[companies['Company']=='InVision', 'Year Founded'] = 2011
# Verify the change was made properly
companies[companies['Company']=='InVision']



# Format as text, in millions. change 25,000,000 to 25M
df_by_quarter['number_of_strikes_formatted'] = df_by_quarter['number_of_strikes'].div(1000000).round(1).astype(str) + 'M'

# Create a new dataframe combining 2016–2017 data with 2018 data.
# Remember that the 2018 data has two added columns: week and weekday. 
# To simplify the results of our combined dataframe, we will drop these added columns during the concatenation

union_df = pd.concat([df.drop(['weekday','week'],axis=1), df_2], ignore_index=True)
union_df.head()

# wanting to split the device column by whether there is a null value or not
# .unstack(fill_value=0) reshapes the table for better readability.
# .map() replaces True with "Has Value" and False with "NaN".
#  It’s a way to convert Boolean values into meaningful categories.
# .map() is faster and simpler than .apply(lambda x: 'Has Value' if pd.notna(x) else 'NaN')

device_null_mask = df['label'].notna().map({True: 'Has Value', False: 'Null Value'})
df.groupby(['device', device_null_mask ]).size().unstack(fill_value=0)

#.value_counts(normalize=True) → Counts occurrences and normalizes them (returns proportions).
device_null_percentage = df[missing_data_mask]['device'].value_counts(normalize=True) * 100

# Identify the top 20 locations with most days of lightning.
df.center_point_geom.value_counts()[:20].rename_axis('unique_values').reset_index(name='counts').style.background_gradient()

# WHEN you want to summarise the data/ add a column without modifying the main df, 2 ways:
Assign method:
df_clean['label'].value_counts().to_frame().assign(
    Percentage=lambda x: round(x['count'] / len(df_clean) * 100, 2)
)

DF Summary:

label_counts = df_clean['label'].value_counts()
label_summary = pd.DataFrame({
    'Total': label_counts,
    'Percentage': round(label_counts / len(df_clean) * 100, 2)  # Convert to percentage
})

# CONVERT SERIES TO DF
.to_frame() converts the Series into a DataFrame.



# Calculate days with most lightning strikes.
df.groupby(['date']).sum().sort_values('number_of_strikes', ascending=False).head(10)
