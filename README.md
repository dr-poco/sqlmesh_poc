<<<<<<< HEAD
# SQLMesh DuckLake Tutorial

This project demonstrates building a modern data lakehouse using SQLMesh, DuckDB, and DuckLake. It creates an incremental pipeline that ingests e-commerce events and produces daily revenue reports.

## Architecture

- **Storage Layer**: Local Parquet files in `data/storage/`
- **Metadata Layer**: DuckLake table format with catalog in `data/catalog.ducklake`
- **Compute Layer**: DuckDB engine
- **Orchestration Layer**: SQLMesh with incremental processing
- **State Management**: SQLMesh state in `data/sqlmesh_state.db`

## Prerequisites

- Python 3.8 or higher
- VS Code with SQLMesh extension (recommended)

## Setup Instructions

1. **Create Virtual Environment**:
   ```bash
   python -m venv .venv
   .venv/Scripts/activate  # Windows
   # or
   source .venv/bin/activate  # macOS/Linux
   ```

2. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Initialize DuckLake**:
   ```bash
   # Connect to DuckDB and install DuckLake
   duckdb data/sqlmesh_state.db
   
   # In DuckDB CLI:
   INSTALL ducklake;
   ATTACH 'ducklake:data/catalog.ducklake' AS my_ducklake (DATA_PATH 'data/storage/');
   USE my_ducklake;
   .exit
   ```

4. **Initialize SQLMesh**:
   ```bash
   sqlmesh migrate
   ```

## Running the Pipeline

1. **Plan and Apply Changes**:
   ```bash
   sqlmesh plan dev
   # Type 'y' to apply
   ```

2. **Verify Results**:
   ```bash
   sqlmesh fetchdf "SELECT * FROM analytics__dev.daily_revenue ORDER BY event_date"
   ```

3. **Promote to Production**:
   ```bash
   sqlmesh plan
   # Type 'y' to apply
   ```

## Adding New Data

1. **Add new events to `seeds/raw_events.csv`**
2. **Re-run the pipeline**:
   ```bash
   sqlmesh plan dev
   sqlmesh run --ignore-cron  # Force immediate run
   sqlmesh plan  # Promote to prod
   ```

## Project Structure

```
├── config.yaml              # SQLMesh configuration
├── models/                  # SQL transformation models
│   ├── raw_events.sql      # Seed model for CSV data
│   ├── stg_events.sql      # Staging model
│   └── daily_revenue.sql   # Incremental revenue model
├── seeds/                   # Raw data files
│   └── raw_events.csv      # Sample e-commerce events
├── data/                    # Data storage
│   ├── storage/            # Parquet files
│   ├── catalog.ducklake    # DuckLake metadata
│   └── sqlmesh_state.db    # SQLMesh state
└── requirements.txt         # Python dependencies
```

## Key Features

- **Incremental Processing**: Only processes new data using time-based partitioning
- **ACID Transactions**: DuckLake ensures data integrity
- **Virtual Data Environments**: Isolated dev/prod environments
- **Time Travel**: Query historical versions of tables
- **Schema Enforcement**: Ensures data structure consistency

## Model Details

### Raw Events (Seed)
- Loads CSV data with defined schema
- Source: `seeds/raw_events.csv`

### Staging Events (View)
- Cleans and standardizes raw data
- Extracts date for incremental processing
- Filters out null event IDs

### Daily Revenue (Incremental)
- Aggregates daily metrics
- Processes only new time ranges
- 2-day lookback for late-arriving data
- Partitioned by event_date for efficient storage

## Troubleshooting

- Ensure DuckLake extension is installed in DuckDB
- Check that data directories exist and are writable
- Verify Python virtual environment is activated
- Use `sqlmesh plan --dry-run` to preview changes
=======
# sqlmesh_poc
SQLMesh is an open-source framework for building, orchestrating, and version-controlling SQL and Python-based data pipelines with built-in scheduling, change detection, backfills, and testing—removing the need for separate tools like Airflow or dbt for many workflows.
>>>>>>> f2a43d4465a9ce87cdd1393d2fcfe15846ad615d
