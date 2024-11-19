import pygsheets
from google.oauth2 import service_account

SCOPES = (
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/drive",
)
credentials = service_account.Credentials.from_service_account_info(TODO, scopes=SCOPES)

gsheet = pygsheets.authorize(custom_credentials=credentials)
spreadsheet = gsheet.open_by_url(
    "https://docs.google.com/spreadsheets/d/REPLACE_ME/edit?gid=REPLACE#gid=REPLACE"
)
worksheet = spreadsheet.worksheet("title", "The Tab Title")
df = None  # dataframe
worksheet.set_dataframe(df, (1, 1))
