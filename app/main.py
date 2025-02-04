from fastapi import FastAPI, HTTPException
from app.models import RequestPayload
from app import selenium_handlers

app = FastAPI(title="Business Registration API")

@app.post("/register")
async def register_business(payload: RequestPayload):
    """
    Принимает JSON с данными регистрации, валидирует их и заполняет форму на сайте.
    Возвращает {"status": "success", "application_id": "...", "state": "..."} или сообщение об ошибке.
    """
    try:
        # Здесь можно добавить дополнительную валидацию, если потребуется
        application_id = selenium_handlers.fill_form(payload.state, payload.credentials, payload.data)
        return {"status": "success", "application_id": application_id, "state": payload.state.upper()}

    except ValueError as ve:
        raise HTTPException(status_code=400, detail={"status": "error", "message": str(ve), "state": payload.state.upper()})
    except Exception as e:
        raise HTTPException(status_code=500, detail={"status": "error", "message": str(e), "state": payload.state.upper()})

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
