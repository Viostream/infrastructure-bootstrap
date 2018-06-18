#!/bin/bash

python -c "from urllib import urlretrieve; urlretrieve('https://raw.githubusercontent.com/Viostream/infrastructure-bootstrap/master/bootstrap.py', 'bootstrap.py'); execfile('bootstrap.py')"