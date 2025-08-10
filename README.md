# 🎾 ATP Tennis Data Warehouse

A modern data warehouse project built with ATP tennis data to enable rich analytical queries and data products.
The project includes data ingestion, transformation, and modeling using open data and modern data tooling.

## 📌 Project Overview

This project creates a cloud-based data warehouse from historical ATP tennis data. It provides:

* Clean and queryable match-level and player-level datasets
* Analytical models (e.g., win/loss ratios, rankings over time, head-to-head stats)

## 🧱 Tech Stack

* **Data Warehouse**: DuckDB, [Motherduck](https://motherduck.com/)
* **Language**: Python 3.10+
* **Dependency Manager**: [`uv`](https://github.com/astral-sh/uv)
* **Data Ingestion**: [DLT](DLT)
* **Transformations**: [dbt](https://www.getdbt.com/)
* **Dashboards (WIP)**: [evidence](https://docs.evidence.dev/)

## 📊 Data Sources

The ATP data comes from:

* [Jeff Sackmann’s Tennis Data Repository](https://github.com/JeffSackmann/tennis_atp)

  * `atp_matches_*.csv`: Match results from 2000+

## 📁 Project Structure

```
.
├── data_ingestion/
│   └── atp_matches.py         # Scripts to ingest data to DuckDB
├── transformations/
│   └── atp_tennis_dw/              # Data models and transformations
├── pyproject.toml                # Project configuration and dependencies
├── uv.lock                       # uv-generated lockfile
└── README.md
```

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/nahumsa/atp-tennis-dw
cd atp-tennis-dw
```

### 2. Run the pipeline

To run the pipeline you need to have uv installed.

#### Ingest ATP data

Locally:

```bash
make load_data
```

motherduck:

```bash
make load_data ENV=prod
```

#### Run transformations with dbt

Locally:

```bash
make dbt_run
```

Motherduck:

```bash
make dbt_run ENV=prod
```

## 📈 Sample Features

* Match-level fact tables with enriched data
* Player dimension with nationality, handedness, etc.
* Analytical views for:

  * Win/loss ratios
  * Head-to-head matchups

## TODO

* [ ] Use evidence to visualize data
