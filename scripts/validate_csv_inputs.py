import yaml
import pandas as pd

from pathlib import Path
from datetime import datetime

# Paths
CONFIG_FILE = "./validation_config.yaml"
SEED_FOLDER = "../seeds"
RAW_FOLDER = "../data/raw"
REPORT_FOLDER = "../validation_reports"


def load_config(config_path):
    
    with open(config_path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def get_csv_files(configured_files):

    search_paths = [
        Path(SEED_FOLDER),
        Path(RAW_FOLDER)
    ]

    csv_files = []

    for folder in search_paths:

        if not folder.exists():
            continue

        csv_files.extend(
            [
                file
                for file in folder.glob("*.csv")
                if file.name in configured_files
            ]
        )

    return csv_files


def check_required_columns(df, required_columns):
    
    return [
    col
    for col in required_columns
    if col not in df.columns
    ]


def check_nulls(df, columns):
    
    results = {}

    for col in columns:
        null_count = int(df[col].isna().sum())

        if null_count > 0:
            results[col] = null_count

    return results


def check_duplicate_primary_keys(df, primary_keys):

    # Handles absence of primary key for file in config
    if not primary_keys:
        return {
            "checked": False,
            "duplicate_count": 0,
            "sample_rows": []
        }

    duplicate_rows = df[
        df.duplicated(
            subset=primary_keys,
            keep=False
        )
    ]

    if duplicate_rows.empty:
        return {
            "checked": True,
            "duplicate_count": 0,
            "sample_rows": []
        }

    return {
        "checked": True,
        "duplicate_count": len(duplicate_rows),
        "sample_rows": duplicate_rows.head(10).index.tolist()
    }


def check_accepted_values(df, accepted_values):
    
    violations = {}


    for column, valid_values in accepted_values.items():

        invalid_rows = df[
            ~df[column].isin(valid_values)
            & df[column].notna()
        ]

        if not invalid_rows.empty:

            violations[column] = {
                "count": len(invalid_rows),
                "examples": (
                    invalid_rows[column]
                    .astype(str)
                    .unique()
                    .tolist()[:10]
                )
            }

    return violations


def determine_result(row_count, missing_columns, nulls, duplicate_keys, accepted_values):

    if row_count == 0:
        return "FAILED"

    if missing_columns:
        return "FAILED"

    if nulls:
        return "FAILED"

    if duplicate_keys.get("checked", False):
        if duplicate_keys["duplicate_count"] > 0:
            return "FAILED"

    if accepted_values:
        return "FAILED"

    return "PASSED"


def write_report(results):

    Path(REPORT_FOLDER).mkdir(
        parents=True,
        exist_ok=True
    )

    timestamp = datetime.now().strftime(
        "%Y_%m_%d_%H_%M"
    )

    report_path = (
        Path(REPORT_FOLDER)
        / f"validation_report_{timestamp}.txt"
    )

    with open(report_path, "w", encoding="utf-8") as f:

        f.write("Validation Report\n")
        f.write("=" * 80 + "\n\n")

        for filename, result in results.items():

            f.write(f"{filename}\n")
            f.write("-" * 80 + "\n")

            f.write(
                f"Rows: {result['row_count']}\n"
            )

            f.write(
                f"Result: {result['result']}\n"
            )

            f.write(
                f"Missing Required Columns: "
                f"{result['missing_columns']}\n"
            )

            f.write(
                f"Null Violations: "
                f"{result['nulls']}\n"
            )

            f.write(
                f"Duplicate Primary Keys: "
                f"{result['duplicate_keys']}\n"
            )

            f.write(
                f"Accepted Value Violations: "
                f"{result['accepted_values']}\n"
            )

            f.write("\n\n")

    return report_path


def run():

    config = load_config(CONFIG_FILE)

    csv_files = get_csv_files(config.keys())

    results = {}

    for file in csv_files:

        file_config = config[file.name]

        df = pd.read_csv(file)

        row_count = len(df)

        missing_columns = check_required_columns(
            df,
            file_config.get(
                "required_columns",
                []
            )
        )

        if missing_columns:

            results[file.name] = {
                "row_count": row_count,
                "missing_columns": missing_columns,
                "nulls": {},
                "duplicate_keys": {},
                "accepted_values": {},
                "result": "FAILED"
            }

            continue

        nulls = check_nulls(
            df,
            file_config.get(
                "non_null_columns",
                []
            )
        )

        duplicate_keys = check_duplicate_primary_keys(
            df,
            file_config.get(
                "primary_keys",
                []
            )
        )

        accepted_values = check_accepted_values(
            df,
            file_config.get(
                "accepted_values",
                {}
            )
        )

        result = determine_result(
            row_count,
            missing_columns,
            nulls,
            duplicate_keys,
            accepted_values
        )

        results[file.name] = {
            "row_count": row_count,
            "missing_columns": missing_columns,
            "nulls": nulls,
            "duplicate_keys": duplicate_keys,
            "accepted_values": accepted_values,
            "result": result
        }

    # Report generation
    report_file = write_report(results)

    passed = [
        file
        for file, result in results.items()
        if result["result"] == "PASSED"
    ]

    failed = [
        file
        for file, result in results.items()
        if result["result"] == "FAILED"
    ]

    # Summary
    print(
        f"\nValidated {len(results)} files.\n"
    )

    print("PASSED:")
    print(
        "\n".join(passed)
        if passed else "None"
    )

    print("\nFAILED:")
    print(
        "\n".join(failed)
        if failed else "None"
    )

    print(
        f"\nDetailed report written to:\n"
        f"{report_file}"
    )


if __name__ == "__main__":
    run()
