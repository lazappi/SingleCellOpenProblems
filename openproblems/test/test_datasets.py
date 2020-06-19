import anndata
import parameterized
import openproblems


@parameterized.parameterized(
    [(dataset,) for task in openproblems.TASKS for dataset in task.DATASETS]
)
def test_task(dataset):
    X = dataset()
    assert isinstance(X, anndata.AnnData)
