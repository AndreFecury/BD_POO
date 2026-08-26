import sqlite3

conn = sqlite3.connect('crud.db')
cur = conn.cursor()
cur.execute("""CREATE TABLE IF NOT EXISTS user(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER
)""") 