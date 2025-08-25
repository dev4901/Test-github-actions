from googleapiclient.discovery import build
from google.auth import default

# Auth
credentials, project_id = default()
service = build('compute', 'v1', credentials=credentials)

# Params
project = "cellular-motif-457805-t1"
zone = "asia-south1-b"
instance = "gcml-test-poc"

# Get the instance
instance_resource = service.instances().get(
    project=project, zone=zone, instance=instance).execute()

# Labels
labels = instance_resource.get('labels', {})
labels['hello-test5'] = 'this-new-label5'

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
