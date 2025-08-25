from googleapiclient import discovery
from oauth2client.client import GoogleCredentials

# Auth
credentials = GoogleCredentials.get_application_default()
service = discovery.build('compute', 'v1', credentials=credentials)

# Params
project = "cellular-motif-457805-t1"
zone = "asia-south1-b"
instance = "gcml-test-poc"

# Get the instance
instance_resource = service.instances().get(
    project=project, zone=zone, instance=instance).execute()

# Labels
labels = instance_resource.get('labels', {})
labels['hello'] = 'world'

# Set new labels
req = service.instances().setLabels(
    project=project,
    zone=zone,
    instance=instance,
    body={
        "labels": labels,
        "labelFingerprint": instance_resource['labelFingerprint']
    }
)
print(req.execute())
