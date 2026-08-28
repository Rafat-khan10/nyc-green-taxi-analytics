🚕 NYC Green Taxi Analytics (2025–2026)

End-to-end data analysis project covering 17 months of NYC Green Taxi trip data (Jan 2025 – May 2026, ~800K trips) using SQL (PostgreSQL) for analysis and Power BI for visualization — with a focus on revenue trends, demand patterns, congestion pricing impact, and data quality.

📑 Table of Contents

Project Overview

Business Problem

Key Business Questions Explored

Dataset

Data Cleaning & Quality Notes

Tools & Tech Stack

Dashboard Preview

Screenshots

Key Findings

Business Recommendations

Repository Structure

How to Run

Connect With Me

📌 Project Overview

Green taxis (Street-Hail Liveries) were introduced by NYC TLC in 2013 to expand taxi access in the outer boroughs and upper Manhattan — areas historically underserved by yellow cabs. This project analyzes trip-level data to understand revenue performance, temporal demand patterns, and the impact of NYC's Congestion Relief Zone (CRZ) toll, which took effect in January 2025 — a period this dataset fully covers.

Using SQL (PostgreSQL) and Power BI, I explored revenue trends, demand patterns, borough/zone performance, and the fare impact of congestion pricing — translating raw trip records into a 3-page interactive dashboard and a set of business findings.

📌 Business Problem

Green taxi operators and city planners need to understand where and when demand is concentrated, how revenue behaves across time and geography, and what impact a major policy change has had on trip economics. This project uses trip-level data to answer: where is revenue being generated, when is demand highest, and how has congestion pricing affected trips in the Congestion Relief Zone?

❓ Key Business Questions Explored

How does monthly revenue trend, and which months show growth vs. decline?

Which time-of-day segments generate the highest trip volume and revenue?

Does trip volume correlate with revenue, or do they peak at different times?

Which boroughs and zones drive the most trips and revenue?

What fare premium (if any) applies to trips touching the Congestion Relief Zone?

How does average fare per mile change across trip-distance buckets?

What share of trips are street-hail vs. dispatch, and does that match Green Taxi's original mandate?

Where are the data quality issues (missing/invalid values), and how were they handled?

✨ ...and additional insights derived from 20+ SQL queries across 7 analysis categories.

🗂️ Dataset

Property

Details

Source

NYC TLC Trip Record Data (official)

Period

January 2025 – May 2026 (17 months)

Total Rows

~802,000 trips

Format

Monthly Parquet files, merged into a single CSV

Reference tables

NYC TLC Taxi Zone Lookup · MTA Congestion Relief Zone Taxi Zones

Note: Raw data was sourced directly from NYC TLC and MTA official portals — no third-party or unverified sources were used.

🧹 Data Cleaning & Quality Notes

Data quality issues were identified, quantified, and explicitly flagged rather than silently dropped from the base dataset:

Issue

Scope

Handling

Negative fare_amount / total_amount

~2,345 / 2,393 rows

Flagged; excluded only in fare-specific queries

trip_distance = 0

31,707 rows

Flagged as likely GPS/meter error; excluded from distance analysis

RatecodeID missing or 99 (Unknown)

~79,435 + 327 rows

Retained, labeled "Unknown" — not dropped

payment_type = No Charge / Dispute / Unknown

Minor % of trips

Grouped as "Other" for reporting

CBD zone flag

Derived

Cross-verified against official MTA polygon dataset (39 zones confirmed)

🛠️ Tools & Tech Stack

Tool

Purpose

Python (Pandas)

Dataset merging & pre-processing

PostgreSQL

Data storage & SQL queries

pgAdmin 4

Query execution & output

Power BI

Interactive 3-page dashboard and DAX measures

📊 Dashboard Preview

The Power BI dashboard is organized into 3 pages, each answering a distinct business question:

Page 1 — Executive Overview
High-level snapshot: total revenue, trips, fare, and payment mix — with month-over-month revenue growth highlighted (negative-growth months flagged red).

Page 2 — Revenue & Time Analysis
Demand and revenue patterns across hours, days, and time segments — including a weekend vs. weekday revenue split.

Page 3 — Location & Trip Analysis
Borough- and zone-level performance, the Congestion Relief Zone's fare impact, and trip-distance pricing patterns.

🖼️ Screenshots

Dashboard screenshots are available in the repository's root-level screenshots/ folder.

👉 View Dashboard Screenshots

📁 Interactive Power BI file: dashboard/NYC_Green_Taxi_Dashboard.pbix

🔍 Key Findings

💰 CBD trips punch above their weight — only 8.6% of trips touch the Congestion Relief Zone, yet they carry an 84% higher average fare ($30.30 vs. $16.50)

📍 Demand is geographically concentrated — East Harlem North & South alone drive ~25% of all pickups, consistent with Green Taxi's restriction from core Manhattan (below ~96th St)

🌙 Volume and value don't peak together — overnight trips (12–4 AM) earn ~26% higher average revenue per trip despite the lowest trip volume, pointing to longer-distance or airport rides

📅 Weekday-dominant demand — weekends generate only 24.6% of revenue despite covering 28.6% of the week

🚖 ~85% of trips are street-hail, not dispatch — consistent with Green Taxi's original 2013 mandate to expand curb access in the outer boroughs

🧾 Data quality handled transparently — ~10% of trips have no recorded payment method, traced to a single non-reporting vendor and labeled "Not Reported" rather than dropped

⚠️ Key Findings will be updated as analysis progresses.

💡 Business Recommendations

Place more drivers near high-value CBD areas during busy periods. CBD trips have much higher average fares, so better driver coverage there could increase revenue per trip.

Study overnight trips more closely. Trips between 12–4 AM earn more per ride. Checking how many are airport or long-distance trips could help with better overnight planning.

Keep strong driver coverage in East Harlem North & South. These zones generate about a quarter of all pickups, so service levels there have a big effect on overall demand.

Keep tracking the impact of congestion pricing. The current data gives an early view of the policy's effect on trip economics; more months of data will show whether the fare difference stays stable.

Fix the missing payment data with the vendor involved. Since a large share of missing payment records comes from one vendor, this looks like a specific reporting issue that can be addressed directly.

Use weekday demand patterns to improve driver scheduling. Since weekends contribute a smaller share of revenue, driver incentives and coverage can be adjusted toward stronger weekday demand.

📁 Repository Structure

nyc-green-taxi-analytics/
│
├── README.md
│
├── sql/
│   ├── 01_data_overview.sql
│   ├── 02_revenue_analysis.sql
│   ├── 03_temporal_demand_analysis.sql
│   ├── 04_location_analysis.sql
│   ├── 05_cbd_congestion_analysis.sql
│   ├── 06_fare_payment_analysis.sql
│   └── 07_trip_distance_analysis.sql
│
├── data/
│   ├── green_taxi_trips_2025_2026.csv
│   ├── taxi_zone_lookup.csv
│   └── cbd_zone_lookup.csv
│
├── dashboard/
│   └── NYC_Green_Taxi_Dashboard.pbix
│
└── screenshots/
    ├── page1_executive_overview.png
    ├── page2_revenue_time.png
    └── page3_location_trip.png

▶️ How to Run

Clone this repository.

Use the dataset and lookup files from the data/ folder.

Create a new database in PostgreSQL.

Import green_taxi_trips_2025_2026.csv into a table named green_taxi, and import the two lookup CSVs into their own tables.

Run the queries from the sql/ folder.

Open dashboard/NYC_Green_Taxi_Dashboard.pbix in Power BI Desktop.

📬 Connect With Me

Rafat Khan — Data Analyst

💼 LinkedIn: https://www.linkedin.com/in/rafat-khan-7215953a1/

🐙 GitHub: https://github.com/Rafat-khan10

📧 Email: rafatkhan2210@gmail.com
