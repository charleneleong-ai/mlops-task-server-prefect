import prefect
from prefect import task, Flow
from prefect.storage import Docker

@task
def hello_task():
    logger = prefect.context.get("logger")
    logger.info("Hello, Kubernetes!")


with Flow("encoding-task",
        storage=Docker(registry_url="prefectdevacr.azurecr.io",
                        python_dependencies=["vectorhub==1.2.3", 
                                            "VecDB==0.5.8"],
                        image_tag='latest')
        ) as flow:
    hello_task()


if __name__ == '__main__':
    # flow.run()
    flow.register(project_name="AKS")

