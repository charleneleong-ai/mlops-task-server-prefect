import prefect
from prefect import task, Flow
from prefect.storage import Docker

@task
def hello_task():
    logger = prefect.context.get("logger")
    logger.info("Hello, Kubernetes!")

flow = Flow("hello-k8s", tasks=[hello_task])

flow.storage = Docker(registry_url="prefectdevacr.azurecr.io")

flow.register(project_name="AKS")