import string
import random
# Python client library for SDK runs
from vecdb import VecDBClient
# Encoder library for encoding multimedia data
from vectorhub.encoders.image.tfhub import BitMedium2Vec

username = "charleneleong"
api_key = "cERJaGpub0JYWXNidmtGWGtzd2Y6MGFHYVF3NzdSTWk3NVQxbnhuZFJpdw"
vi = VecDBClient(username, api_key)
model = BitMedium2Vec()

SEED = random.randint(0, 99999999)
print(f"seed is {SEED}")
random.seed(SEED)

def gen_string(num_of_letters=6):
    return ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(num_of_letters))

RANDOM_STRING = gen_string()
DATASET_ID = "coco-dataset"
def encode_documents(docs, seed=SEED, random_string=RANDOM_STRING):
    # LOG THIS IF YOU WANT
    print(f"Random string is {random_string}")
    print(f"vector is coco_url_{random_string}_vector_")    
    IMAGE_FIELD = "image.coco_url"
    for d in docs['documents']:
        image = d.get("image")
        if image is not None:
            if image.get("coco_url") is not None:
                d[f"coco_url_{random_string}_vector_"] = model.encode(image.get("coco_url"))
                
docs = vi.datasets.documents.list(DATASET_ID)

while len(docs['documents']) > 0:
    encode_documents(docs)
    # Log progress here.
    
    print(vi.datasets.documents.bulk_update(DATASET_ID, docs['documents']))
    docs = vi.datasets.documents.list(DATASET_ID, cursor=docs['cursor'])

    
# test that this is now updated in schema
vector_field = f"coco_url_{RANDOM_STRING}_vector_"
assert vector_field in vi.datasets.schema(DATASET_ID), "Didn't edit properly!"