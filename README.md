# 📊 Online Retail Sales & Operations Analysis

**End-to-End Data Analytics Portfolio Project | PostgreSQL + Power BI**

---

## 📌 Project Overview

This project demonstrates an end-to-end data analytics workflow using PostgreSQL and Power BI to transform raw retail transaction data into meaningful business insights.

The project focuses on analyzing sales performance, product contribution, country-level performance, customer purchasing behavior, and unusual transaction patterns while maintaining data accuracy and reliability.

Through data auditing, cleaning, validation, SQL analysis, and interactive visualization, the goal is to demonstrate how raw transactional data can support better commercial and operational decisions.

### 🎯 Project Objectives

✅ **Data Auditing & Quality Assessment (PostgreSQL):** Examine the raw dataset to identify missing values, duplicate records, inconsistent formats, and unusual transaction patterns.

✅ **Data Cleaning & Validation (PostgreSQL):** Prepare a reliable analytical dataset while preserving important transaction information and documenting data-quality issues.

✅ **Business Analysis (SQL):** Analyze sales performance, product trends, country contributions, customer purchasing behavior, and transaction patterns using SQL queries.

✅ **Data Visualization (Power BI):** Develop an interactive, three-page dashboard to communicate key business metrics, trends, and insights.

✅ **Reporting & Presentation:** Document analytical findings, highlight business implications, and present actionable recommendations through a professional project report and presentation.



### 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL | Data storage, auditing, cleaning, validation, and SQL analysis |
| pgAdmin | PostgreSQL database management and query execution |
| Power BI | Interactive dashboards and business intelligence |
| SQL | Data exploration, transformation, and business analysis |
| GitHub | Project documentation, version control, and portfolio presentation |

---

## 📂 Dataset

**Source:** UCI Machine Learning Repository

**Dataset:** Online Retail

**Original Dataset:** [Download Online Retail Dataset](https://archive.ics.uci.edu/dataset/352/online+retail)

The dataset contains historical transactional records from a UK-based online retail business.

- **Original Dataset Size:** 541,909 transaction rows
- **Data Type:** Historical retail transaction data
- **Key Attributes:** Invoice number, stock code, product description, quantity, invoice date, unit price, customer ID, and country.

**Note:** The raw CSV file is not included in this repository. Please download it directly from the original UCI source before executing the SQL scripts. The local imported dataset contains 541,909 rows.

---

## 🔍 Data Preparation & Quality Assessment

Before performing business analysis, I conducted a structured data-quality assessment to understand the reliability of the raw transactional data.

### Key Data Quality Checks

- Identified missing customer identifiers.
- Detected blank and missing product descriptions.
- Investigated negative quantities and cancellation-prefixed invoices.
- Identified zero-price transactions.
- Checked inconsistent or unusual transaction patterns.
- Reviewed transaction records before creating the analytical dataset.

### Data Cleaning & Validation Approach

- Imported the original dataset into a PostgreSQL staging table.
- Profiled data-quality issues using SQL queries.
- Converted quantity and unit-price fields into appropriate numeric data types.
- Normalized blank customer identifiers and product descriptions.
- Created a clean analytical view for downstream analysis.
- Preserved unusual transaction records for investigation rather than silently deleting them.
- Validated the resulting dataset using row counts and data-quality checks.

---

## 📈 SQL Business Analysis

After preparing the analytical dataset, I used PostgreSQL to investigate business questions related to retail performance and customer behavior.

### Areas of Analysis

**1. Sales Performance**
- How does sales performance change over time?
- Which periods generate the highest sales?
- What are the overall gross positive line-item sales?

**2. Product Performance**
- Which products contribute the most to sales?
- What are the best-performing products?
- Which products have unusual transaction patterns?

**3. Country-Level Performance**
- Which countries generate the highest sales?
- How is sales contribution distributed geographically?
- Which markets represent potential growth opportunities?

**4. Customer Purchasing Behavior**
- Who are the highest-value customers?
- How frequently do customers make purchases?
- How concentrated is revenue among top customers?

**5. Transaction & Operational Analysis**
- How frequently do cancellation-prefixed invoices occur?
- What patterns exist in negative-quantity transactions?
- How do missing customer identifiers affect analysis?

---

## 📊 Power BI Dashboard

The SQL analysis was translated into an interactive three-page Power BI report designed to communicate business performance and support decision-making.

**Dashboard Pages:**

1. **Sales Overview:** High-level sales KPIs, sales trends, and overall performance.
2. **Product & Country Analysis:** Product contribution, top-performing products, and country-level performance.
3. **Customer & Operations Analysis:** Customer purchasing behavior and unusual transaction patterns.

### Dashboard Preview

_Add your Power BI dashboard screenshots below._

**Page 1 – Sales Overview**

![Sales Overview Dashboard](screenshots/sales_overview.png)

**Page 2 – Product & Country Analysis**

![Product and Country Dashboard](screenshots/product_country_analysis.png)

**Page 3 – Customer & Operations Analysis**

![Customer and Operations Dashboard](screenshots/customer_operations_analysis.png)

---

## 📑 Project Deliverables

The repository contains the supporting materials needed to understand and reproduce the analysis.

| Deliverable | Description |
|---|---|
| SQL Scripts | Data auditing, cleaning, validation, and business analysis queries |
| Power BI Dashboard | Three-page interactive business intelligence report |
| Project Brief | Business problem, objectives, scope, and methodology |
| Analysis Report | Findings, business implications, and recommendations |
| Presentation | Visual summary of the project and analytical outcomes |
| Data Quality Notes | Documentation of data issues and validation approach |

---

## ⚠️ Important Definitions & Limitations

**Gross Positive Line-Item Revenue:** Calculated as `Quantity × Unit Price` for records where quantity and unit price are both positive.

This is a baseline sales measure, not net revenue after returns, refunds, or other adjustments.

**Cancellation-Prefixed Invoices:** Invoice numbers beginning with `C` are treated as indicators for further investigation, not definitive proof of a specific business event.

**Data Limitations:**
- Customer identifiers are missing from a significant portion of the dataset.
- Negative quantities may represent returns, corrections, damaged goods, or other adjustments.
- Zero-price transactions require additional business context.
- Historical transactions may not reflect current retail market conditions.
- Net revenue should not be claimed without validated treatment of returns and cancellations.

---

## 🚀 How to Explore This Project

1. Download the original dataset from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online+retail).
2. Create a PostgreSQL database.
3. Import the raw CSV into the staging table using the provided SQL instructions.
4. Execute the data auditing and profiling scripts.
5. Run the cleaning and validation scripts.
6. Execute the SQL business analysis queries.
7. Connect PostgreSQL to Power BI and explore the dashboard.
8. Review the project report and presentation for findings and recommendations.

---

## 👨‍💻 About the Author

**Suharta Ahmed | Data Analyst**

I enjoy transforming raw data into meaningful insights that help businesses understand performance, identify problems, and make better decisions.

My focus areas include Data Analytics, Data Operations, SQL, Python, PostgreSQL, Power BI, and business process improvement.

**Connect with me:**

- **LinkedIn:** [linkedin.com/in/suhartaahmed](https://www.linkedin.com/in/suhartaahmed/)
- **GitHub:** [github.com/suhartaahmed](https://github.com/suhartaahmed)

---

⭐ If you find this project useful, feel free to star the repository or connect with me!

