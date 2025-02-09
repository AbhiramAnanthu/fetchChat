"""
Testing the Rag applications

evaluations: FaithFullEvaluation, Relevancy Evaluation and RetrievalEvaluation

"""

from dotenv import load_dotenv
from rag import VectorDataBase
from llama_index.core.evaluation import RelevancyEvaluator
import rag
import asyncio

load_dotenv()


evaluator = RelevancyEvaluator(llm=rag.llm)


def testRag():
    # load the project vector database
    db = VectorDataBase()

    # create a record
    test_url = (
        "https://docs.llamaindex.ai/en/stable/module_guides/evaluating/usage_pattern/"
    )

    db.create_record(test_url, "abhiram@123", "abhiram@123")

    test_query = "Explain usage_pattern implementation, and how it is used to evaluate rag application in llamaindex"
    response = db.stream_response(test_query, "abhiram@123")
    if response != None:
        eval_result = evaluator.evaluate_response(response=response, query=test_query)
        print(eval_result.passing)


if __name__ == "__main__":
    testRag()
