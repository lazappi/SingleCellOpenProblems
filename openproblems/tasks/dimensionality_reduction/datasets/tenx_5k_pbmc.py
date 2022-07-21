from ....data.tenx import load_tenx_5k_pbmc
from ....tools.decorators import dataset


@dataset(
    "5k Peripheral blood mononuclear cells (PBMCs) from a healthy donor. "
    "10x Genomics; July 24, 2019.",
    data_url=load_tenx_5k_pbmc.metadata["data_url"],
    data_reference=load_tenx_5k_pbmc.metadata["data_reference"],
    dataset_summary=(
        "5k Peripheral Blood Mononuclear Cells (PBMCs) from a healthy donor "
        "produced by 10x Genomics in July 2019"
    ),
)
def tenx_5k_pbmc(test=False):
    return load_tenx_5k_pbmc(test=test)
