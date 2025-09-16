import ollama
import os
from pathlib import Path

user = os.getenv("USER")
host_file = Path(f"/speed-scratch/{user}/ollama/.ollama_host")

ollama_host = host_file.read_text().strip()

client = ollama.Client(host=ollama_host)
response = client.chat(
    model='llama3.2',
    messages=[{
        'role': 'user',
        'content': (
            'What popular operating system, launched in 1991, '
            'also has its own mascot, Tux the penguin?'
        )
    }]
)

print(f"[Client connected to {ollama_host}]")
print(response["message"]["content"])
