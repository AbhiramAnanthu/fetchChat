from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from .middlewares import loading_middleware, query_middleware

app = FastAPI()


@app.get("/")
def index():
    return {"message": "Welcome to FetchChat api"}


@app.websocket("/chat")
async def chat(websocket: WebSocket):
    session_chat_history = []
    print("[Connected] Client Connected")

    await websocket.accept()
    try:
        await websocket.send_text("Send the url in json format with namespace")
        user_json = await websocket.receive_json()
        url, namespace = user_json["url"], user_json["namespace"]
        query_engine = loading_middleware(url, namespace)
        if query_engine is not None:
            await websocket.send_text("engine loaded")
        else:
            await websocket.send_text("Error loading query engine")
        async for message in websocket.iter_text():
            response = await query_middleware(query_engine, message)
            if response.response:
                await websocket.send_text(response.response)
    except WebSocketDisconnect:
        print("Client disconnected")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app)
