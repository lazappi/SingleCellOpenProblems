from ....tools.decorators import metric

import numpy as np
import sklearn.preprocessing


@metric(metric_name="Accuracy", maximize=True)
def accuracy(adata):
    encoder = sklearn.preprocessing.LabelEncoder().fit(adata.obs["labels"])
    test_data = adata[~adata.obs["is_train"]]

    labels = encoder.transform(test_data.obs["labels"])
    labels_pred = encoder.transform(test_data.obs["labels_pred"])

    return np.mean(labels == labels_pred)
