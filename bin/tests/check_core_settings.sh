#!/usr/bin/env bash

# Cause the script to exit if a single command fails
set -eo pipefail -v


################################  pipeline 00  ################################
# checking catalyst-core loading (default)
pip uninstall -r requirements/requirements-cv.txt -y
pip uninstall -r requirements/requirements-dev.txt -y
pip uninstall -r requirements/requirements-ecosystem.txt -y
pip uninstall -r requirements/requirements-log.txt -y
pip uninstall -r requirements/requirements-ml.txt -y
pip uninstall -r requirements/requirements-nlp.txt -y
pip uninstall -r requirements/requirements-tune.txt -y
pip uninstall nmslib -y
pip install -r requirements/requirements.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

cat <<EOT > .catalyst
[catalyst]
cv_required = false
log_required = false
ml_required = false
nlp_required = false
tune_required = false
nmslib_required = false
EOT

python -c """
from catalyst.contrib import callbacks
from catalyst.contrib import utils

try:
    callbacks.AlchemyLogger
except (AttributeError, ImportError):
    pass  # Ok
else:
    raise AssertionError('\'ImportError\' expected')
"""

################################  pipeline 00  ################################
# checking catalyst-core loading (pandas)
pip uninstall -r requirements/requirements-cv.txt -y
pip uninstall -r requirements/requirements-dev.txt -y
pip uninstall -r requirements/requirements-ecosystem.txt -y
pip uninstall -r requirements/requirements-log.txt -y
pip uninstall -r requirements/requirements-ml.txt -y
pip uninstall -r requirements/requirements-nlp.txt -y
pip uninstall -r requirements/requirements-tune.txt -y
pip uninstall nmslib -y
pip install -r requirements/requirements.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

cat <<EOT > .catalyst
[catalyst]
cv_required = false
log_required = false
ml_required = false
nlp_required = false
tune_required = false
nmslib_required = false
pandas_required = true
EOT

# check if fail if requirements not installed
python -c """
try:
    from catalyst.contrib.__main__ import COMMANDS

    assert not 'project-embeddings' in COMMANDS
except (ImportError, AssertionError):
    pass  # Ok
else:
    raise AssertionError('\'ImportError\' or \'AssertionError\' expected')
"""

pip install pandas --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

python -c """
from catalyst.contrib.__main__ import COMMANDS

assert 'project-embeddings' in COMMANDS
"""


################################  pipeline 01  ################################
# checking catalyst-cv dependencies loading
pip uninstall -r requirements/requirements-cv.txt -y
pip uninstall -r requirements/requirements-dev.txt -y
pip uninstall -r requirements/requirements-ecosystem.txt -y
pip uninstall -r requirements/requirements-log.txt -y
pip uninstall -r requirements/requirements-ml.txt -y
pip uninstall -r requirements/requirements-nlp.txt -y
pip uninstall -r requirements/requirements-tune.txt -y
pip uninstall nmslib -y
pip install -r requirements/requirements.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

cat <<EOT > .catalyst
[catalyst]
cv_required = true
log_required = false
ml_required = false
nlp_required = false
tune_required = false
nmslib_required = false
EOT

# check if fail if requirements not installed
python -c """
from catalyst.settings import SETTINGS

assert SETTINGS.use_libjpeg_turbo == False

try:
    from catalyst.contrib.data import cv as cv_data
    from catalyst.contrib.callbacks import InferMaskCallback
    from catalyst.contrib.models import cv as cv_models
    from catalyst.contrib.utils import imread, imwrite
    from catalyst.contrib.__main__ import COMMANDS

    assert not (
        'process-images' in COMMANDS
        or 'project-embeddings' in COMMANDS
    )
except (ImportError, AssertionError):
    pass  # Ok
else:
    raise AssertionError('\'ImportError\' or \'AssertionError\' expected')
"""

pip install pandas -r requirements/requirements-cv.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

python -c """
from catalyst.contrib.data import cv as cv_data
from catalyst.contrib.callbacks import InferMaskCallback
from catalyst.contrib.models import cv as cv_models
from catalyst.contrib.utils import imread, imwrite
from catalyst.contrib.__main__ import COMMANDS

assert (
    'process-images' in COMMANDS
    and 'project-embeddings' in COMMANDS
)
"""


################################  pipeline 02  ################################
# checking catalyst-log dependencies loading
pip uninstall -r requirements/requirements-cv.txt -y
pip uninstall -r requirements/requirements-dev.txt -y
pip uninstall -r requirements/requirements-ecosystem.txt -y
pip uninstall -r requirements/requirements-log.txt -y
pip uninstall -r requirements/requirements-ml.txt -y
pip uninstall -r requirements/requirements-nlp.txt -y
pip uninstall -r requirements/requirements-tune.txt -y
pip uninstall nmslib -y
pip install -r requirements/requirements.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

cat <<EOT > .catalyst
[catalyst]
cv_required = false
log_required = true
ml_required = false
nlp_required = false
tune_required = false
nmslib_required = false
EOT

# check if fail if requirements not installed
python -c """
from catalyst.settings import SETTINGS

assert SETTINGS.use_lz4 == False and SETTINGS.use_pyarrow == False

try:
    from catalyst.contrib.callbacks import AlchemyLogger
except ImportError:
    pass  # Ok
else:
    raise AssertionError('\'ImportError\' expected')
"""

pip install -r requirements/requirements-log.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed
pip install -r requirements/requirements-ecosystem.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

python -c """
from catalyst.contrib.callbacks import AlchemyLogger
from catalyst.contrib.callbacks import NeptuneLogger
from catalyst.contrib.callbacks import WandbLogger
"""


################################  pipeline 03  ################################
# checking catalyst-ml dependencies loading
pip uninstall -r requirements/requirements-cv.txt -y
pip uninstall -r requirements/requirements-dev.txt -y
pip uninstall -r requirements/requirements-ecosystem.txt -y
pip uninstall -r requirements/requirements-log.txt -y
pip uninstall -r requirements/requirements-ml.txt -y
pip uninstall -r requirements/requirements-nlp.txt -y
pip uninstall -r requirements/requirements-tune.txt -y
pip uninstall nmslib -y
pip install -r requirements/requirements.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

cat <<EOT > .catalyst
[catalyst]
cv_required = false
log_required = false
ml_required = true
nlp_required = false
tune_required = false
nmslib_required = false
EOT

# check if fail if requirements not installed
python -c """
try:
    from catalyst.contrib.utils import balance_classes, split_dataframe_train_test
    from catalyst.contrib.__main__ import COMMANDS

    assert not (
        'find-thresholds' in COMMANDS
        or 'tag2label' in COMMANDS
        or 'split-dataframe' in COMMANDS
    )
except (ImportError, AssertionError):
    pass  # Ok
else:
    raise AssertionError('\'ImportError\' or \'AssertionError\' expected')
"""

pip install -r requirements/requirements-ml.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

python -c """
from catalyst.contrib.utils import balance_classes, split_dataframe_train_test
from catalyst.contrib.__main__ import COMMANDS

assert (
    'find-thresholds' in COMMANDS
    and 'tag2label' in COMMANDS
    and 'split-dataframe' in COMMANDS
)
"""

################################  pipeline 03  ################################
# checking catalyst-ml dependencies loading (nmslib)
pip uninstall -r requirements/requirements-cv.txt -y
pip uninstall -r requirements/requirements-dev.txt -y
pip uninstall -r requirements/requirements-ecosystem.txt -y
pip uninstall -r requirements/requirements-log.txt -y
pip uninstall -r requirements/requirements-ml.txt -y
pip uninstall -r requirements/requirements-nlp.txt -y
pip uninstall -r requirements/requirements-tune.txt -y
pip uninstall nmslib -y
pip install -r requirements/requirements.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

cat <<EOT > .catalyst
[catalyst]
cv_required = false
log_required = false
ml_required = true
nlp_required = false
tune_required = false
nmslib_required = true
EOT

# check if fail if requirements not installed
python -c """
try:
    from catalyst.contrib.__main__ import COMMANDS

    assert not (
        'check-index-model' in COMMANDS or 'create-index-model' in COMMANDS
    )
except (ImportError, AssertionError):
    pass  # Ok
else:
    raise AssertionError('\'ImportError\' or \'AssertionError\' expected')
"""

pip install nmslib -r requirements/requirements-ml.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

python -c """
from catalyst.contrib.__main__ import COMMANDS

assert 'check-index-model' in COMMANDS and 'create-index-model' in COMMANDS
"""


################################  pipeline 04  ################################
# checking catalyst-nlp dependencies loading
pip uninstall -r requirements/requirements-cv.txt -y
pip uninstall -r requirements/requirements-dev.txt -y
pip uninstall -r requirements/requirements-ecosystem.txt -y
pip uninstall -r requirements/requirements-log.txt -y
pip uninstall -r requirements/requirements-ml.txt -y
pip uninstall -r requirements/requirements-nlp.txt -y
pip uninstall -r requirements/requirements-tune.txt -y
pip uninstall nmslib -y
pip install -r requirements/requirements.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

cat <<EOT > .catalyst
[catalyst]
cv_required = false
log_required = false
ml_required = false
nlp_required = true
tune_required = false
nmslib_required = false
EOT

# check if fail if requirements not installed
python -c """
try:
    from catalyst.contrib.data import nlp as nlp_data
    from catalyst.contrib.models import nlp as nlp_models
    from catalyst.contrib.utils import tokenize_text, process_bert_output
    from catalyst.contrib.__main__ import COMMANDS

    assert 'text2embedding' not in COMMANDS
except (ImportError, AssertionError):
    pass  # Ok
else:
    raise AssertionError('\'ImportError\' or \'AssertionError\' expected')
"""

pip install pandas -r requirements/requirements-nlp.txt --quiet \
  --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
  --upgrade-strategy only-if-needed

python -c """
from catalyst.contrib.data import nlp as nlp_data
from catalyst.contrib.models import nlp as nlp_models
from catalyst.contrib.utils import tokenize_text, process_bert_output
from catalyst.contrib.__main__ import COMMANDS

assert 'text2embedding' in COMMANDS
"""


################################  pipeline 99  ################################
rm .catalyst
