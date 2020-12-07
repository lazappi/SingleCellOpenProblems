from scanpy import AnnData

from ....tools.decorators import method
from ....tools.utils import check_version


@method(
    method_name="No denoising",
    paper_name="Molecular Cross-Validation for Single-Cell RNA-seq",
    paper_url="https://www.biorxiv.org/content/10.1101/786269v1",
    paper_year=2019,
    code_url="https://github.com/czbiohub/molecular-cross-validation",
    code_version=check_version("scanpy"),
)
def no_denoising(adata: AnnData) -> None:
    """Do nothing."""
    adata.obsm["denoised"] = adata.obsm["train"]
    return adata
