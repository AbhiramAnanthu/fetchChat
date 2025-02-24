from Rag_application.rag import check_url_exists, create_record, load_query_engine
from llama_index.core import VectorStoreIndex
from llama_index.core.llms import ChatMessage, MessageRole
import asyncio


## Loading query engine: if url exists direct loading, if not create a record in vector db and then load
def loading_middleware(url: str, namespace: str):
    if not check_url_exists(namespace, url):
        create_record(url, namespace)
    query_engine = load_query_engine(namespace, url)
    return query_engine


async def query_middleware(query_engine, query):
    response = query_engine.query(query)
    return response


# async def test():
#     url = input("Enter Url: ")

#     namespace = "tenant-abhiram"

#     query_engine = loading_middleware(url, namespace)

#     while True:
#         query = input("Enter query: ")
#         response = await query_middleware(query_engine, query)
#         print(response)


# if __name__ == "__main__":
#     asyncio.run(test())
