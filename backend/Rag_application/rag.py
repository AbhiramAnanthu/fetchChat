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
from llama_index.core.vector_stores import ExactMatchFilter, MetadataFilter

load_dotenv()


def intialize_config():
    """
    loading and initializing all the global variables
    """
    global llm, embed_model, pc, index_name

    llm = Groq(api_key=os.getenv("GROQ_API_KEY"), model="llama-3.3-70b-versatile")

    embed_model = GeminiEmbedding(
        model_name="models/text-embedding-004", api_key=os.getenv("GOOGLE_API_KEY")
    )
    Settings.embed_model = embed_model

    pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
    index_name = "scrap-embedding"


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


def create_record(url: str, userId: str, namespace: str):
    """
    Create a record in pinecone vector store
    steps
    1) scrape the website
    2) clean the text
    3) store the cleaned text in vector database
    """
    try:
        document = SimpleWebPageReader(html_to_text=True).load_data([url])
        clean_text = clean_data(document[0].text)

        doc_id = f"{userId}#{uuid.uuid4()}"
        metadata = {"url": url, "userId": userId}
        upsert_document = [Document(id_=doc_id, text=clean_text, metadata=metadata)]

        vector_store = PineconeVectorStore(namespace=namespace, index_name=index_name)
        storage_context = StorageContext.from_defaults(vector_store=vector_store)
        index = VectorStoreIndex(
            [], embed_model=embed_model, storage_context=storage_context
        )
        index.insert(document=upsert_document[0])

    except Exception as e:
        print(f"An error occurred: {e}")


def load_query_engine(namespace: str, url: str, userId: str):
    metadata_filter = MetadataFilter(
        filters=[
            ExactMatchFilter(key="userId", value=userId),
            ExactMatchFilter(key="url", value=url),
        ]
    )
    vector_store = PineconeVectorStore(namespace=namespace, index_name=index_name)
    index = VectorStoreIndex.from_vector_store(
        vector_store=vector_store, embed_model=embed_model
    )
    query_engine = index.as_query_engine(filters=metadata_filter, llm=llm)
    return query_engine


def stream_response(query: str, namespace: str, url: str, userId: str):
    query_engine = load_query_engine(namespace=namespace, url=url, userId=userId)
    response = query_engine.query(query)
    return response


if __name__ == "__main__":
    intialize_config()
