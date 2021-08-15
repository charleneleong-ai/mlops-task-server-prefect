import prefect
from prefect import task, Flow
from prefect.run_configs import DockerRun
from prefect.storage import Docker


from prefect import task, Flow
from prefect.tasks.docker import (
    CreateContainer,
    StartContainer,
    GetContainerLogs,
    WaitOnContainer,
)

create = CreateContainer(image_name="taskserver/encoding_task", command="echo 12345")
start = StartContainer()
wait = WaitOnContainer()
logs = GetContainerLogs()


@task
def see_output(out):
    print(out)


with Flow("docker-flow",
    storage=Docker(python_dependencies=["vectorhub==1.2.3", "VecDB==0.5.8"]) 
    as flow:
    
    # container_id = create()
    # s = start(container_id=container_id)
    # w = wait(container_id=container_id)

    # l = logs(container_id=container_id)
    # l.set_upstream(w)

    # see_output(l)

flow.run()




# with Flow(
#     "docker-flow",
#     storage=Docker(python_dependencies=["vectorhub==1.2.3", "VecDB==0.5.8"]
# ) as flow:





# from prefect.agent.docker import DockerAgent

# DockerAgent(labels=["dev", "staging"]).start()



# Configure extra environment variables for this flow,
# and set a custom image
# flow.run_config = DockerRun(
#     # env={"SOME_VAR": "VALUE"},
#     labels=["dev"],
#     image="encoding_task:latest"
# )



# @task
# def say_hello():
#     logger = prefect.context.get("logger")
#     logger.info("Hello, Cloud!")

# with Flow("hello-flow") as flow:
#     say_hello()

# # Register the flow under the "tutorial" project
# flow.register(project_name="test-project")

 

 