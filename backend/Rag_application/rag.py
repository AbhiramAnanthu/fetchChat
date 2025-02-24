import os
import re
import uuid
from dotenv import load_dotenv
from nltk.corpus import stopwords
from llama_index.vector_stores.pinecone import PineconeVectorStore
from llama_index.readers.web import SimpleWebPageReader
from llama_index.llms.groq import Groq
from llama_index.core import VectorStoreIndex, StorageContext, Document
from pinecone import Pinecone
from llama_index.embeddings.gemini import GeminiEmbedding
from llama_index.core import Settings
from llama_index.core.vector_stores import (
    MetadataFilter,
    MetadataFilters,
    FilterOperator,
)
from llama_index.core.node_parser import SentenceSplitter
from pydantic import ValidationError


load_dotenv()


llm = Groq(api_key=os.getenv("GROQ_API_KEY"), model="llama-3.3-70b-versatile")

embed_model = GeminiEmbedding(
    model_name="models/text-embedding-004", api_key=os.getenv("GOOGLE_API_KEY")
)
Settings.embed_model = embed_model

pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
index_name = "fetch-chat"


def clean_data(text: str) -> str:
    """
    Cleaning the scraped text to simpler, semantically meaning text removing punctuations,
    stop words, extra spaces and links
    """
    stop_words = stopwords.words("english")

    text_lwr = text.strip().lower()
    remove_stpwrd_list = [word for word in text_lwr.split() if word not in stop_words]
    remv_stpwrd = " ".join(remove_stpwrd_list)

    pattern = (
        r'(\*\s*)?(\[\s*!\[([^\]]+)\]\([^)]+\s*"[^\"]*"\)\]|\[([^\]]+)\]\([^)]+\))'
    )
    remv_links = re.sub(pattern, "", remv_stpwrd)

    return remv_links


def create_record(url: str, namespace: str):
    """
    Create a record in pinecone vector store
    steps
    1) scrape the website
    2) clean the text
    3) store the cleaned text in vector database
    """
    try:
        document = SimpleWebPageReader(html_to_text=True).load_data([url])
        if len(document) <= 0:
            raise ValueError("WebPage error")
        clean_text = clean_data(document[0].text)
        metadata = {"url": url}
        upsert_document = Document(text=clean_text, metadata=metadata)

        vector_store = PineconeVectorStore(namespace=namespace, index_name=index_name)
        storage_context = StorageContext.from_defaults(vector_store=vector_store)
        index = VectorStoreIndex(
            [], embed_model=embed_model, storage_context=storage_context
        )
        index.insert(upsert_document)
    except ValidationError as e:
        print(f"Error on Namespace or index: {e}")
    except ValueError as e:
        print(f"Site Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")


def check_url_exists(namespace: str, url: str) -> bool:
    """
    Returns True if url exists, returns false if it does not exists
    """
    try:
        index = pc.Index(name=index_name)
        recordIds = [ids for ids in index.list(namespace=namespace)]
        if len(recordIds) == 0:
            print("Empty records")
            return False
        else:
            records = index.fetch(ids=recordIds[0], namespace=namespace).to_dict()
            results = [val["metadata"]["url"] for val in records["vectors"].values()]

            required_url = [res for res in results if res == url]
            status = True if len(required_url) != 0 else False
            return status
    except Exception as e:
        print(f"An error occurred: {e}")
        return False


def load_query_engine(namespace: str, url: str):
    try:
        metadata_filter = MetadataFilters(
            filters=[
                MetadataFilter(key="url", value=url, operator=FilterOperator.EQ),
            ]
        )
        vector_store = PineconeVectorStore(namespace=namespace, index_name=index_name)
        index = VectorStoreIndex.from_vector_store(
            vector_store=vector_store, embed_model=embed_model
        )
        query_engine = index.as_query_engine(filters=metadata_filter, llm=llm)
        return query_engine
    except Exception as e:
        print(f"An error occurred: {e}")
        return None
