import dlt
import requests
import csv
import time
import argparse
from datetime import datetime, timezone
from typing import Iterator, Dict
from io import StringIO


@dlt.resource(
    primary_key=("tourney_id", "match_num"),
    name="atp_matches",
    write_disposition="replace",
)
def atp_matches_data() -> Iterator[Dict]:
    for year in range(2000, 2024 + 1):
        # Change this to a logger
        print(f"loading year={year}")

        response = requests.get(
            f"https://raw.githubusercontent.com/JeffSackmann/tennis_atp/refs/heads/master/atp_matches_{year}.csv",
            allow_redirects=True,
        )

        # add sleep to avoid 429 Error
        time.sleep(5)

        response.raise_for_status()

        data = csv.DictReader(StringIO(response.text))
        updated_at = datetime.now(timezone.utc)

        for record in data:
            yield dict(**record, **{"updated_at": updated_at, "year": year})


@dlt.source
def atp_matches_source():
    return atp_matches_data


def cli() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="Load Tennis Data",
        description="loads tennis data to duckdb or motherduck",
    )

    parser.add_argument(
        "--env", choices=["dev", "prod"], default="dev"
    )

    return parser.parse_args()


if __name__ == "__main__":
    args = cli()
    match args.env:
        case "dev":
            destination = "duckdb"
        case "prod":
            destination = "motherduck"
        case _:
            raise ValueError(f"invalid environment: {args.backend}")

    pipeline = dlt.pipeline(
        pipeline_name="atp_matches_pipeline",
        destination=destination,
        dataset_name="raw_data",
    )

    load_info = pipeline.run(atp_matches_source())
    print(load_info)
