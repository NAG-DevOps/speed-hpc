import ollama
import os
from pathlib import Path

user = os.getenv("USER")
host_file = Path(f"/speed-scratch/{user}/ollama/.ollama_host")
ollama_host = host_file.read_text().strip()
client = ollama.Client(host=ollama_host)

model_name = "llama3"

question = (
    "What popular operating system, launched in 1991, "
    "also has its own mascot, Tux the penguin?"
)

response = client.chat(
    model=model_name,
    messages=[{
        'role': 'user',
        'content': question
    }]
)

print("=" * 60)
print(f"Server: {ollama_host}")
print(f"Model: {model_name}")
print("=" * 60)
print("\n💬 Question:")
print(f"   {question}\n")
print("🤖 Answer:")
print(f"   {response['message']['content']}\n")
print("=" * 60)
