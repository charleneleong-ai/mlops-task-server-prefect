#!/usr/bin/env python3
# -*- coding:utf-8 -*-
import logging
import string
import random

# Python client library for SDK runs
from vectorai import ViClient
# Encoder library for encoding multimedia data
from vectorhub.bi_encoders.text_image.torch import Clip2Vec
import click
import click_log

click_log.basic_config()
log = logging.getLogger(__name__)

username = "charleneleong"
api_key = "cERJaGpub0JYWXNidmtGWGtzd2Y6MGFHYVF3NzdSTWk3NVQxbnhuZFJpdw"
DATASET_ID = "coco-dataset"
IMAGE_FIELD = "image.coco_url"

vi = ViClient(username, api_key)
clip = Clip2Vec()
SEED = random.randint(0, 99999999)
log.info(f"seed is {SEED}")
random.seed(SEED)

def gen_string(length=6):
    return "".join(
        random.choices(string.ascii_uppercase + string.ascii_lowercase, k=length)
    )

RANDOM_STRING = gen_string()
# log.info(f"Random string is {RANDOM_STRING}")

def encode_documents(docs, seed=SEED, random_string=RANDOM_STRING):
    """Loops through documents and encodes media into vectors
    """
    # LOG THIS IF YOU WANT
    vector_field = f"{IMAGE_FIELD}_{random_string}_vector_"
    log.info(f"vector is {vector_field}")
    for d in docs['documents']:
        image = d.get("image")
        try:
            d[vector_field] = clip.encode_image(vi.get_field(IMAGE_FIELD))
        except:
            continue



def main():
    # backend, we store documents (Python DICTIONARIES or JSONS)
    docs = vi.retrieve_documents(DATASET_ID)
    # once you retrieve all the documents, this becomes 0
    # {"data": 3, "image-url": ""}
    while len(docs['documents']) > 0:
        encode_documents(docs)
        # Log progress here.
        # Update documents
        log.info(vi.edit_documents(DATASET_ID, docs['documents']))
        # Returns this
        # {'edited_successfully': 20, 'failed': 0, 'failed_document_ids': []}
        # Cursor is what we use to bookmark retrieval
        docs = vi.retrieve_documents(DATASET_ID, cursor=docs['cursor'])

    # test that this is now updated in schema
    vector_field = f"{IMAGE_FIELD}_{RANDOM_STRING}_vector_"
    log.info(f'Testing {vector_field}: assertion')
    assert vector_field in vi.collection_schema(DATASET_ID), "Didn't edit properly!"

    # search results to see if it encoded properly!
    log.info(f'Testing {vector_field}: search')
    log.info(vi.search(
        DATASET_ID,
        vector=clip.encode_text("seagull"), 
        field=[vector_field]))
        

if __name__ == '__main__':
    main()
