import ollama
import os

ollama_host = os.getenv('OLLAMA_HOST', 'http://localhost:11434')
client = ollama.Client(host=ollama_host)
response = client.chat(
    model='llama3.1',
    messages=[{
        'role': 'user',
        'content': (
            'What popular operating system, launched in 1991, '
            'also has its own mascot, Tux the penguin?'
        )
    }]
)
print(response['message']['content'])