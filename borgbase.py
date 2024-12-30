from borgbase_api_client.client import GraphQLClient
from borgbase_api_client.mutations import *
from sopsy import Sops
from socket import gethostname
import secrets
import string

sops = Sops('./secrets/secrets.yaml')
token = sops.get('borgbase-token')
client = GraphQLClient(token)
host = 'test' #gethostname()

def gen_key():
    chars = string.ascii_letters + string.ascii_lowercase + string.ascii_uppercase
    return ''.join(secrets.choice(chars) for _ in range(32))

def new_repo():
    credentials = sops.get('restic').get(host)
    if credentials:
        raise Exception('Repo already exists')
    vars = {
        'name': host,
        'alertDats': 1,
        'region': 'eu',
        'quotaEnabled': False,
        'repoType': 'restic'
    }
    result = client.execute(REPO_ADD, vars)
    result_dict = result['data']['repoAdd']['repoAdded']
    repo_id = result_dict['id']
    repo_path = result_dict['repoPath']
    encryption_key = gen_key() 
    credentials.set('key', encryption_key)
    credentials.set('url', repo_path)
    sops.encrypt()

#encryption_key = credentials.get('key')
#repo_url = credentials.get('key')

#new_key_vars = {
#    'name': 'key',
#    'keyData': encryption_key 
#}
#res = client.execute(SSH_ADD, new_key_vars)
#new_key_id = res['data']['sshAdd']['keyAdded']['id']
#
#new_repo_vars = {
#    'name': 'VM-004-test',
#    'quotaEnabled': False,
#    'appendOnlyKeys': [new_key_id],
#    'region': 'eu'
#}
#res = client.execute(REPO_ADD, new_repo_vars)
#new_repo_path = res['data']['repoAdd']['repoAdded']['repoPath']
#print('Added new repo with path:', new_repo_path)

new_repo()