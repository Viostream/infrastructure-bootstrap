#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Execute this script using the following one-liner from a shell prompt
# python -c "from urllib import urlretrieve; urlretrieve('https://raw.githubusercontent.com/Viostream/infrastructure-bootstrap/master/bootstrap.py', 'bootstrap.py'); execfile('bootstrap.py')"
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


import requests
import subprocess
from requests.auth import HTTPBasicAuth

url = 'https://raw.githubusercontent.com/Viostream/infrastructure/master/Viostream.Pexip.Plugin.1.0.0.21.0.tar'
#tarfilename = '/home/admin/Viostream.Pexip.Plugin.1.0.0.21.tar'
extractpath = '/home/admin/tmp'

username = raw_input("Github username? ")
password = raw_input("Github password? ")

if url.find('/'):
  filename = url.rsplit('/', 1)[1]
else:
  filename = 'myfile.tar'

r = requests.get(url, allow_redirects=True, auth=HTTPBasicAuth(username, password))

open(filename, 'wb').write(r.content)

retcode = subprocess.call(['tar', '-xvf', filename, '-C', extractpath])
if retcode == 0:
    print "Extracted successfully"
else:
    raise IOError('tar exited with code %d' % retcode)
