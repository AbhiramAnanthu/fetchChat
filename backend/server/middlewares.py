from Rag_application.rag import check_url_exists, create_record, load_query_engine


## Loading query engine: if url exists direct loading, if not create a record in vector db and then load
def loading_middleware(url: str, namespace: str):
    if not check_url_exists(namespace, url):
        create_record(url, namespace)
    query_engine = load_query_engine(namespace, url)
    return query_engine


async def query_middleware(query_engine, query):
    response = query_engine.query(query)
    return response
