import dlt
import requests
import csv
from datetime import datetime, timezone
from typing import Iterator, Dict
from io import StringIO


@dlt.resource(primary_key=("tourney_id", "match_num"), name="atp_matches", write_disposition="replace")
def atp_matches_data() -> Iterator[Dict]:
    for year in range(2019, 2024 + 1):
        response = requests.get(
            f"https://raw.githubusercontent.com/JeffSackmann/tennis_atp/refs/heads/master/atp_matches_{year}.csv", allow_redirects=True
        )

        response.raise_for_status()

        data = csv.DictReader(StringIO(response.text))
        updated_at = datetime.now(timezone.utc)

        for record in data:
            yield dict(**record, **{"updated_at": updated_at})


@dlt.source
def atp_matches_source():
    return atp_matches_data


if __name__ == "__main__":
    pipeline = dlt.pipeline(
        pipeline_name="atp_matches_pipeline",
        destination="duckdb",
        dataset_name="raw_data",
    )

    load_info = pipeline.run(atp_matches_source())
    print(load_info)
