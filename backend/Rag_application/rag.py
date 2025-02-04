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
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.core import Settings

load_dotenv()

llm = Groq(api_key=os.getenv("GROQ_API_KEY"), model="llama-3.3-70b-versatile")
embed_model = HuggingFaceEmbedding(model_name="BAAI/bge-small-en-v1.5")
Settings.embed_model = embed_model


class VectorDataBase:
    def __init__(self):
        self.pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
        self.index = "scrap-embedding"

    def _clean_data(text: str) -> str:

        stop_words = stopwords.words("english")

        text_lwr = text.strip().lower()
        remove_stpwrd_list = [
            word for word in text_lwr.split() if word not in stop_words
        ]
        remv_stpwrd = " ".join(remove_stpwrd_list)

        pattern = (
            r'(\*\s*)?(\[\s*!\[([^\]]+)\]\([^)]+\s*"[^\"]*"\)\]|\[([^\]]+)\]\([^)]+\))'
        )
        remv_links = re.sub(pattern, "", remv_stpwrd)

        return remv_links

    def _load_chat_engine(self, namespace):
        vector_store = PineconeVectorStore(namespace=namespace, index_name=self.index)
        index = VectorStoreIndex.from_vector_store(
            vector_store=vector_store, embed_model=embed_model
        )
        chat_engine = index.as_chat_engine(chat_mode="react", llm=llm)
        return chat_engine

    def stream_response(self, query, namespace):
        chat_engine = self._load_chat_engine(namespace=namespace)
        response = chat_engine.stream_chat(query)
        for token in response.response_gen:
            print(token, end="")

    def create_record(self, url: str, userId: str, namespace: str):

        try:
            document = SimpleWebPageReader(html_to_text=True).load_data([url])
            clean_text = self._clean_data(document[0].text)

            doc_id = f"{userId}#{uuid.uuid4()}"
            metadata = {"url": url, "userId": userId}
            upsert_document = [Document(id_=doc_id, text=clean_text, metadata=metadata)]

            vector_store = PineconeVectorStore(
                namespace=namespace, index_name=self.index
            )
            storage_context = StorageContext.from_defaults(vector_store=vector_store)
            index = VectorStoreIndex(
                [], embed_model=embed_model, storage_context=storage_context
            )
            index.insert(document=upsert_document[0])

        except Exception as e:
            print(f"An error occurred: {e}")

    def delete_record(self, url: str, namespace: str):
        pass

    def update_record(self, recordId: str, namespace: str):
        pass
