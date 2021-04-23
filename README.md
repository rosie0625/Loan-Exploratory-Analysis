# Loan-Exploratory-Analysis

## Introduction:
Loans are created and renewed between borrowers and lenders monthly. These loans have different conditions based on different attributes of the borrowers and behave differently as time passes. Companies spend time understanding borrower behavior and the default probabilities to minimize risk, by determining whether a loan will default and predicting the loss ahead of time, and optimize ROI, by offering tailored loan plans for customers with various risk types to maximize investors profit. Thus, in this project, our team uses public loan data to simulate helping companies better understand borrower behavior and predict default risks.

## Data Source:
- Data Set: Lending Club
- Time Period: 2020 Q2
- Details: loan info, loan payment account info, borrower info... 
- Dimension: 150 Columns, 13000+ Rows

## Objective
1. Build a highly normalized (3NF+) data warehouse and EER diagram from unstructured and uncleaned raw dataset so that we can extract, store and analyse data more efficiently
2. Use the large loan dataset to analyse the demographic of borrowers, the likelihood of default, and critical features related to the default

## Tools used:
- ETL Process: Excel, Open Refine
- Data Warehouse & ER Design: MySQL, GCP
- Data Modeling & Analysis: MySQL
- Data Visualization: Tableau
- Reporting: Microsoft Powerpoint 

## Result:
1. Succesfully designed an OLTP database using MySQl with careful considerations of relational data integrity, entity cardinality, attribute selection
2. Performed ETL processing to migrate 20,000 records of loan data into Google Cloud
3. Identified borrower traits that make them vulnerable to default risks, and explored relationships between borrower loan
behaviors and loan grade, loan purpose and loan status using SQL, and visualized findings through Tableau dashboards.
**Some exmaples of insights we extracted:**
    - Borrowers who take on loans for debt consolidation purpose heavily dominate the loan market.
    - Risky loan status (Late, Charged Off, In Grace Period) have higher average loan amount.
    - Borrowers with 10+ years work experience dominate the loan market.
    - More developed states such as CA, TX, NY generate more loans.
    - The higher loan grade are given to borrowers with higher annual income and lower debt-to-income ratio. These high loan grade borroowers as a result have lower deliquency, higher credit lines, higher average account balances but less revolving balances.
    - Loans with purpose of “Medical Expenses” are more likely to become debt in collections
    - High income population are more likely to invest in personal career development and life quality improvement
    - Lower income and lower asset debtors are more likely to go broke
