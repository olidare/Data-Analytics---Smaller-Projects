# 📊 Statistics in Python

## 📖 Introduction

This document contains examples of Python code for key statistical concepts, along with plain-language definitions and guidance for interpreting the results. It’s designed as a practical learning resource for data analysts working with Python.

---

## 📦 Imports  

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.metrics import confusion_matrix, accuracy_score, classification_report
from sklearn.decomposition import PCA
from scipy import stats
````

---

## 📊 Descriptive Statistics

**Definition:**
Summary metrics that describe the basic features of a dataset, such as its central tendency and spread.

**When to use it:**
To quickly understand your dataset’s distributions and ranges before deeper analysis.

**Python Example:**

```python
df.describe()

np.mean(df["value"])
np.median(df["value"])
np.min(df["value"])
np.max(df["value"])
np.std(df["value"], ddof=1)
```

**Interpretation:**
Use this to get an overview of your dataset’s numeric columns — means, mins, maxes, and standard deviation.

---

## 📈 Histograms

**Definition:**
A visualisation that displays the distribution of a numeric variable by grouping data into bins.

**When to use it:**
To understand the distribution shape (normal, skewed, bimodal etc.)

**Python Example:**

```python
plt.hist(df['value'], bins=20)
plt.xlabel('Value')
plt.ylabel('Frequency')
plt.title('Histogram of Value')
plt.show()
```

**Interpretation:**
Look for skewness, outliers, and whether the distribution is approximately normal.

---

## 👉 Conditional Probability

**Definition:**
The probability of an event occurring given that another event has already occurred.

**Equation:**
$P(A|B) = \frac{P(A \cap B)}{P(B)}$

**Python Example:**

```python
# Given a DataFrame 'df' with columns 'Event_A' and 'Event_B'
p_A_and_B = len(df[(df['Event_A']==1) & (df['Event_B']==1)]) / len(df)
p_B = len(df[df['Event_B']==1]) / len(df)
p_A_given_B = p_A_and_B / p_B
```

**Interpretation:**
How likely event A happens if B is known to occur.

**Caveats:**
Dependent on accurate joint and marginal probability estimates.

### 📌 Example: Online Purchases

Let’s explore another example. Imagine you are a data professional working for an online retail store. You have data that tells you **20% of the customers who visit the store’s website make a purchase of \$100 or more**. If a customer spends \$100, they are eligible to receive a free gift card. The store randomly awards gift cards to **10% of the customers who spend at least \$100**.

You want to calculate the probability that a customer spends \$100 and receives a gift card. Receiving a gift card depends on first spending \$100. So, this is a **conditional probability** because it deals with two dependent events.

Let's apply the conditional probability formula:


$P(A \text{ and } B) = P(A) \times P(B|A)$


Where:
- Event A = *spends \$100*
- Event B = *receives a gift card*

Given:
- \(P(A) = 0.2\)
- \(P(B|A) = 0.1\)

Now substitute the values:

$P(\$100 \text{ and gift card}) = 0.2 \times 0.1 = 0.02$

**Interpretation:**  
The probability of a customer spending \$100 or more **and** receiving a free gift card is **2%**.


---

## 🔄 Bayes' Theorem

**Definition:**
A way to update probabilities as more information becomes available.

**Equation:**
$P(A|B) = \frac{P(B|A) \times P(A)}{P(B)}$

**Alternatively:**
$P(B|A) = \frac{P(A \text{ and } B)}{P(A)}$

**Python Example:**

```python
p_B_given_A = 0.9
p_A = 0.01
p_B = 0.05

p_A_given_B = (p_B_given_A * p_A) / p_B
```

**Interpretation:**
Revises an initial probability in light of new evidence.

**Caveats:**
Requires accurate prior and conditional probabilities.

---

## 📊 Bayes’ Theorem Interview-Style Questions

### 🟢 Easy: Email Spam Detection

**Problem:**
80% of emails are non-spam (ham). 20% are spam. A keyword detection tool flags 90% of spam emails but also incorrectly flags 5% of ham emails as spam.
If an email is flagged, what’s the probability it’s actually spam?

AKA what is Prob of it being Spam given its flagged:  P(Spam | Flag)

First you need to assign the correct Probabilities to what is already known.

**Given:**

* $P(\text{Spam}) = 0.2$
* $P(\text{Flag}|\text{Spam}) = 0.9$
* $P(\text{Flag}|\text{Ham}) = 0.05$
* $P(\text{Ham}) = 0.8$

**Use Bayes' theorem:**

$$
P(\text{Spam}|\text{Flag}) = \frac{P(\text{Flag}|\text{Spam}) \times P(\text{Spam})}{P(\text{Flag})}
$$

Where:

$$
P(\text{Flag}) = P(\text{Flag}|\text{Spam}) \times P(\text{Spam}) + P(\text{Flag}|\text{Ham}) \times P(\text{Ham})
$$

**Python Code:**

```python
p_spam = 0.2
p_flag_given_spam = 0.9
p_flag_given_ham = 0.05
p_ham = 0.8

p_flag = (p_flag_given_spam * p_spam) + (p_flag_given_ham * p_ham)
p_spam_given_flag = (p_flag_given_spam * p_spam) / p_flag

print(round(p_spam_given_flag, 4))  # e.g. 0.8182
```

---

### 🟡 Medium: Website Conversion Prediction

**Problem:**
10% of website visitors are high-value customers. 60% of high-value visitors make a purchase, while only 5% of regular visitors do.
If someone makes a purchase, what is the probability they were a high-value visitor?

So this wants to know - What is P(High Value | Purchase) 

**Given:**

* $P(H) = 0.1$
* $P(P|H) = 0.6$
* $P(P|R) = 0.05$
* $P(R) = 0.9$

**Bayes' theorem:**

$$
P(H|P) = \frac{P(P|H) \times P(H)}{P(P)}
$$

Where:

$$
P(P) = P(P|H) \times P(H) + P(P|R) \times P(R)
$$

**Python Code:**

```python
p_H = 0.1
p_P_given_H = 0.6
p_P_given_R = 0.05
p_R = 0.9

p_P = (p_P_given_H * p_H) + (p_P_given_R * p_R)
p_H_given_P = (p_P_given_H * p_H) / p_P

print(round(p_H_given_P, 4))
```

---

### 🔴 Hard: False Positive Rate in Medical Testing

**Problem:**
A disease affects 0.5% of the population. A test correctly identifies 99% of cases (sensitivity), but has a 2% false positive rate.
If a person tests positive, what is the probability they actually have the disease?

**Given:**

* $P(D) = 0.005$
* $P(Pos|D) = 0.99$
* $P(Pos|ND) = 0.02$
* $P(ND) = 0.995$

**Bayes' theorem:**

$$
P(D|Pos) = \frac{P(Pos|D) \times P(D)}{P(Pos)}
$$

Where:

$$
P(Pos) = P(Pos|D) \times P(D) + P(Pos|ND) \times P(ND)
$$

**Python Code:**

```python
p_D = 0.005
p_Pos_given_D = 0.99
p_Pos_given_ND = 0.02
p_ND = 0.995

p_Pos = (p_Pos_given_D * p_D) + (p_Pos_given_ND * p_ND)
p_D_given_Pos = (p_Pos_given_D * p_D) / p_Pos

print(round(p_D_given_Pos, 4))  # e.g. 0.1980
```

**Interpretation:**
Even with a good test, because the disease is rare, the chance of actually having it after a positive test is under **20%**. Classic *base rate fallacy* illustration.

---

✅ Would you like me to pop these straight into your markdown document structure under a **Bayes' Theorem Examples** section too?


---

## 💊 Probability Distributions Overview

**Definition:**
Mathematical functions describing the likelihood of different outcomes.

### Binomial Distribution

**Equation:**
$P(X=k) = \binom{n}{k} p^k (1-p)^{n-k}$

**Python Example:**

```python
from scipy.stats import binom

p = 0.5
n = 10
k = 5
prob = binom.pmf(k, n, p)
```

**Interpretation:**
Probability of k successes in n trials.

---

### Poisson Distribution

**Equation:**
$P(X=k) = \frac{\lambda^k e^{-\lambda}}{k!}$

**Python Example:**

```python
from scipy.stats import poisson

lambda_ = 3
prob = poisson.pmf(2, lambda_)
```

**Interpretation:**
Probability of a given number of events in a fixed interval.

---

### Normal Distribution

**Equation:**
$f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$

**Python Example:**

```python
from scipy.stats import norm

mean, std = 0, 1
prob = norm.pdf(0, mean, std)
```

**Interpretation:**
Probability density at a given point for a normal distribution.

---

## 📏 Standardizing with Z-Scores

**Equation:**
$z = \frac{x-\mu}{\sigma}$

**Python Example:**

```python
z_score = (x - df['value'].mean()) / df['value'].std()
```

**Interpretation:**
How many standard deviations a data point is from the mean.

---

## 📗 Sampling in Python

**Definition:**
Selecting a subset of data points from a dataset.

**Python Example:**

```python
sample = df.sample(n=100, random_state=1)
```

**Effect:**
Introduces sampling variability — sample means vary from population mean.

---

## 🔄 Central Limit Theorem (CLT)

**Definition:**
The sampling distribution of the mean approaches normality as sample size increases.

**Illustration Code:**

```python
means = [df.sample(30).mean() for _ in range(1000)]
plt.hist(means, bins=30)
plt.show()
```

**Key Idea:**
Sample means will approximate a normal distribution regardless of the original distribution.

---

## 🔄 Confidence Intervals

**Equation (for mean):**
$CI = \bar{x} \pm z \times \frac{s}{\sqrt{n}}$

**Python Example:**

```python
import statsmodels.stats.api as sms

ci = sms.DescrStatsW(df['value']).tconfint_mean()
```

**Interpretation:**
Range where the true population mean likely lies.

**Variants:**

* Small sample: use t-distribution
* Large sample: normal approximation

---

## 📖 Conclusion

This guide provides practical equations and Python implementations for foundational statistics topics essential to data analytics. Expand with Bayesian methods, time series, and hypothesis testing in future updates.

---


## 📉 Linear Regression

**Definition:**
A method to model the relationship between a dependent variable and one or more independent variables.

**When to use it:**
When predicting a continuous numeric outcome based on one or more predictors.

**Python Example:**

```python
X = sm.add_constant(df['feature'])
y = df['target']

model = sm.OLS(y, X).fit()
print(model.summary())
```

**Interpretation:**
Check the coefficients and p-values to see which variables significantly affect the outcome.

**Caveats:**
Assumes linearity, independence of errors, homoscedasticity, and normality of residuals.

---

## 📊 R-Squared vs Adjusted R-Squared

**Definition:**

* R² measures the proportion of variance in the dependent variable explained by the independent variables.
* Adjusted R² adjusts for the number of predictors in the model.

**When to use it:**
To evaluate model fit.

**Interpretation:**
Adjusted R² is preferred when comparing models with different numbers of predictors.

---

## 🔢 Confusion Matrix

**Definition:**
A table that describes the performance of a classification model by comparing predicted and actual values.

**When to use it:**
To assess classification model accuracy.

**Python Example:**

```python
y_pred = model.predict(X_test)
cm = confusion_matrix(y_test, y_pred)
print(cm)
```

**Interpretation:**
Use the matrix to compute accuracy, precision, recall, and F1-score.

---

## 🔄 Cross Validation

**Definition:**
A technique for assessing how a model generalizes to an independent dataset by splitting data into training and validation folds.

**When to use it:**
To prevent overfitting and assess model stability.

**Python Example:**

```python
scores = cross_val_score(model, X, y, cv=5)
print(scores)
print(np.mean(scores))
```

**Interpretation:**
Mean score indicates average model performance across different splits.

---

## 🌳 Decision Tree

**Definition:**
A model that splits data based on decision rules inferred from features.

**When to use it:**
For both classification and regression problems where relationships are non-linear.

**Python Example:**

```python
from sklearn.tree import DecisionTreeClassifier

tree = DecisionTreeClassifier(max_depth=3)
tree.fit(X_train, y_train)
```

**Interpretation:**
Check feature importance and visualize the tree for interpretability.

---

## 🎓 Supervised vs Unsupervised Learning

**Definition:**

* **Supervised Learning**: Training a model on labeled data.
* **Unsupervised Learning**: Finding patterns in data without labels.

**When to use it:**
Depends on whether your target variable is known.

---

## 📉 Principal Component Analysis (PCA)

**Definition:**
A dimensionality reduction technique that transforms data into fewer variables called principal components.

**When to use it:**
To reduce dataset dimensions while retaining most variability.

**Python Example:**

```python
pca = PCA(n_components=2)
components = pca.fit_transform(X)
```

**Interpretation:**
Check how much variance each component explains using `pca.explained_variance_ratio_`.

---

## 📊 Correlation vs Causation

**Definition:**

* **Correlation**: Measures linear relationship between variables.
* **Causation**: One variable directly affects another.

**When to use it:**
For exploratory analysis — but be cautious drawing causal conclusions.

**Python Example:**

```python
df.corr()
```

**Interpretation:**
Look for values close to +1 or -1, indicating strong relationships.

---

## 📈 Hypothesis Testing

**Definition:**
A method to test assumptions about a population using sample data.

**When to use it:**
To compare means or proportions between groups.

**Python Example:**

```python
t_stat, p_value = stats.ttest_ind(group1, group2)
print(p_value)
```

**Interpretation:**
If p-value < 0.05, reject the null hypothesis.

---

## 📏 Confidence Intervals

**Definition:**
A range of values likely to contain the population parameter with a specified probability.

**When to use it:**
To quantify uncertainty around sample estimates.

**Python Example:**

```python
import statsmodels.stats.api as sms

ci = sms.DescrStatsW(df['value']).tconfint_mean()
print(ci)
```

**Interpretation:**
There's a 95% chance the population mean lies within this range.

---

## 📊 Outlier Detection

**Definition:**
Identifying data points significantly different from others.

**When to use it:**
To clean data or flag anomalies.

**Python Example:**

```python
z_scores = np.abs(stats.zscore(df['value']))
outliers = df[z_scores > 3]
```

**Interpretation:**
Data points with a z-score > 3 are considered outliers.

---

## 🔍 ANOVA (Analysis of Variance)

**Definition:**
A technique to compare means across multiple groups.

**When to use it:**
When comparing the means of 3+ groups.

**Python Example:**

```python
f_stat, p_value = stats.f_oneway(group1, group2, group3)
print(p_value)
```

**Interpretation:**
If p-value < 0.05, at least one group differs significantly.

---

## 📊 Chi-Square Test

**Definition:**
A test to examine the relationship between two categorical variables.

**When to use it:**
For testing independence between variables in a contingency table.

**Python Example:**

```python
contingency_table = pd.crosstab(df['var1'], df['var2'])
chi2, p, dof, expected = stats.chi2_contingency(contingency_table)
print(p)
```

**Interpretation:**
If p-value < 0.05, variables are dependent.

---

## 📚 Further Reading

* [Python Data Science Handbook (Jake VanderPlas)](https://jakevdp.github.io/PythonDataScienceHandbook/)
* [Statistics Done Wrong (Alex Reinhart)](https://www.statisticsdonewrong.com/)
* [scikit-learn Documentation](https://scikit-learn.org/stable/)
* [Statsmodels Documentation](https://www.statsmodels.org/stable/)

---
