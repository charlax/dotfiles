import pygsheets

client = pygsheets.authorize(custom_credentials=my_credentials)
sheet = client.open_by_key(SPREADSHEET_KEY)
worksheet = sheet.worksheet_by_title(WORKSHEET_TITLE)

# Conditional formatting
# https://developers.google.com/sheets/api/guides/conditional-format#boolean-rules
worksheet.add_conditional_formatting(
    "N2", "N3001", "TEXT_EQ", {"backgroundColor": {"red": 1}}, ["FALSE"]
)
