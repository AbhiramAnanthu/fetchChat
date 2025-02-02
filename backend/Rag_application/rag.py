import os
import re
from dotenv import load_dotenv
from nltk.corpus import stopwords
from llama_index.llms.groq import Groq
from llama_index.vector_stores.pinecone import PineconeVectorStore
from llama_index.readers.web import SimpleWebPageReader
from llama_index.core import VectorStoreIndex, StorageContext, Document
from pinecone import Pinecone, ServerlessSpec
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.core import Settings

load_dotenv()

llm = Groq(api_key=os.getenv("GROQ_API_KEY"), model="llama-3.3-70b-versatile")
pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
embed_model = HuggingFaceEmbedding(model_name="BAAI/bge-small-en-v1.5")

Settings.embed_model = embed_model


def load_data(url: str) -> str:
    """
    Scrape the webpage from the url given using SimpleWebReader from llamaindex,
    Extracts the text from the page
    @ param url: string
    @ return text: string
    """
    document = SimpleWebPageReader(html_to_text=True).load_data([url])
    return document


def clean_data(text: str) -> str:
    """
    Clean the data for more clarity.
    Remove
    """
    stop_words = stopwords.words("english")
    text_lwr = text.strip().lower()  # Removes trailing spaces and convert to lowercase
    remove_stpwrd_list = [word for word in text_lwr.split() if word not in stop_words]
    remv_stpwrd = " ".join(remove_stpwrd_list)
    remv_links = re.sub(
        r'(\*\s*)?(\[\s*!\[([^\]]+)\]\([^)]+\s*"[^\"]*"\)\]|\[([^\]]+)\]\([^)]+\))',
        "",
        remv_stpwrd,
    )  # Removes urls
    return remv_links


def create_new(document: list[Document], dimension: int) -> str:
    pc.create_index(
        name="scrap-embedding",
        dimension=dimension,
        metric="euclidean",
        spec=ServerlessSpec(cloud="aws", region="us-east-1"),
    )
    pinecone_index = pc.Index("scrap-embedding")
    vector_store = PineconeVectorStore(pinecone_index=pinecone_index)
