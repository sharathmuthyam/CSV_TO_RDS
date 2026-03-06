# CSV_TO_RDS — Automated Student Data Orchestrator

A containerized **ETL (Extract, Transform, Load)** pipeline that ingests raw student grade exports from Canvas/University CSV files, performs automated validation and At-Risk analysis, and persists structured results into a relational SQL database (SQLite locally, AWS RDS in production).

---

## Overview

Manual grade tracking creates bottlenecks: inconsistent formatting, missing values, and no audit trail. This tool eliminates that entirely by automating the full pipeline — from raw CSV ingestion to a validated, queryable database — with zero manual intervention required after setup.

---

## Features

| Feature | Description |
|---|---|
| **Automated Ingestion** | Parses raw Canvas/University CSV exports, strips metadata rows, and aligns headers automatically |
| **Data Persistence** | SQLAlchemy ORM maps Python objects to relational records, ensuring zero data loss across sessions |
| **At-Risk Detection** | Calculates performance metrics per student and flags At-Risk profiles based on configurable grade thresholds |
| **Dockerized** | Fully containerized — runs identically on macOS, Windows, and Linux with no environment setup |
| **Audit Reporting** | Outputs structured Excel summaries and a success/failure audit log after every run |

---

## Tech Stack

- **Language:** Python 3.x
- **Data Engine:** Pandas (ETL & transformation)
- **ORM:** SQLAlchemy
- **Database:** SQLite (local) / AWS RDS (production)
- **Containerization:** Docker

---

## Architecture

```
canvas_grades.csv
      │
      ▼
  [EXTRACT]
  Parse CSV, strip "Points Possible" rows,
  handle missing values
      │
      ▼
  [TRANSFORM]
  Map to Student schema,
  calculate performance metrics,
  flag At-Risk profiles
      │
      ▼
   [LOAD]
  Commit records to SQL database
  via SQLAlchemy ORM
      │
      ▼
  [ORCHESTRATE]
  Output audit log + Excel report
```

---

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your machine
- A `canvas_grades.csv` file exported from Canvas or your university's LMS

### Installation & Usage

**1. Clone the repository:**
```bash
git clone https://github.com/[YOUR_USERNAME]/CSV_TO_RDS.git
cd CSV_TO_RDS
```

**2. Add your CSV file to the project folder:**
```
CSV_TO_RDS/
├── canvas_grades.csv   ← place your export here
├── Dockerfile
├── main.py
└── ...
```

**3. Build the Docker image:**
```bash
docker build -t csv_to_rds .
```

**4. Run the pipeline with persistence:**
```bash
docker run -it -v "$(pwd):/app" csv_to_rds
```

> The `-v "$(pwd):/app"` flag mounts your local directory into the container so the database file (`students.db`) and generated reports are saved back to your machine after the run.

---

## Output

After a successful run, the following files are written to your project directory:

| File | Description |
|---|---|
| `students.db` | SQLite database with all processed student records |
| `report_YYYY-MM-DD.xlsx` | Excel summary formatted for stakeholder review |
| `audit_log.txt` | Success/failure log with row-level traceability |

---

## Configuration

Adjust thresholds and behavior in `config.py` (or via environment variables):

```python
AT_RISK_THRESHOLD = 70       # Grade % below which a student is flagged
MISSING_VALUE_STRATEGY = "zero"  # Options: "zero", "drop", "mean"
DB_PATH = "students.db"      # Override with RDS connection string for production
```

---

## Connecting to AWS RDS (Production)

To swap SQLite for a live RDS instance, replace `DB_PATH` with your RDS connection string:

```python
DB_PATH = "postgresql://user:password@your-rds-endpoint.amazonaws.com:5432/dbname"
```

No other code changes required — SQLAlchemy handles the rest.

---

## Project Structure

```
CSV_TO_RDS/
├── Dockerfile
├── main.py              # Pipeline entrypoint
├── config.py            # Thresholds and settings
├── models.py            # SQLAlchemy Student schema
├── etl/
│   ├── extract.py       # CSV parsing and header normalization
│   ├── transform.py     # Validation, metric calculation, At-Risk flagging
│   └── load.py          # ORM commits to database
├── reports/
│   └── excel_writer.py  # Excel report generation
└── README.md
```

---

## License

MIT License — see [LICENSE](LICENSE) for details.
