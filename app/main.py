from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates

from app.messages import FastAPIAppMessages

app = FastAPI(
    title=FastAPIAppMessages.TITLE,
    description=FastAPIAppMessages.DESCRIPTION,
    version="1.0.0",
)

templates = Jinja2Templates(directory="app/templates")


@app.get("/", include_in_schema=False)
async def home(request: Request):
    return templates.TemplateResponse("home.html", {"request": request})
