#!/bin/sh

test()
{
  echo "=============================================="
  echo "  Testing with Python $(cat .python-version)"
  echo "=============================================="
  
  echo "----------------------------------------------"
  echo "  ...with pip"
  echo "----------------------------------------------"
  
  [ -d './venv' ] && rm -rf './venv'
  
  python -m venv venv
  source venv/bin/activate
  
  pip install --no-cache-dir -r build_requirements.txt 2>&1 | grep 'librdkafka'
  
  deactivate
  rm -rf venv
  
  echo "----------------------------------------------"
  echo "  ...with poetry"
  echo "----------------------------------------------"
  
  poetry env info --path
  [ $? == 0 ] && poetry env remove python
  [ -d 'poetry.lock' ] && rm -f 'poetry.lock'
  
  poetry install 2>&1 | grep 'librdkafka'
  
  poetry env remove --quiet python
  rm -f poetry.lock
}

cd "$(dirname "$0")"

pushd './python-3.9.8'
test
popd

pushd './python-3.10.4'
test
popd
