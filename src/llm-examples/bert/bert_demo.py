from transformers import BertTokenizer, BertForMaskedLM, BertForQuestionAnswering, pipeline

import torch
import transformers
transformers.logging.set_verbosity_error()

print("\n=== Masked Word Prediction ===")

# Load tokenizer and model
tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")
model = BertForMaskedLM.from_pretrained("bert-base-uncased")

# Input sentence with [MASK]
text = "Speed is a high-performance computing cluster. Speed cluster is really [MASK]!"
inputs = tokenizer(text, return_tensors="pt")
mask_token_index = torch.where(inputs["input_ids"] == tokenizer.mask_token_id)[1]

# Get predictions
with torch.no_grad():
    outputs = model(**inputs)

# Extract logits and top predictions
logits = outputs.logits
mask_token_logits = logits[0, mask_token_index, :]
top_tokens = torch.topk(mask_token_logits, 5, dim=1).indices[0].tolist()
predicted_words = [tokenizer.decode([token]) for token in top_tokens]
predicted_token = predicted_words[0]

# Output results
print(f"Original: {text}")
print(f"Prediction: Speed cluster is really {predicted_token}!")
print("Top 5 predictions:", predicted_words)
  
print("\n=== Question Answering ===")

# Use pre-trained QA model
qa_pipeline = pipeline("question-answering", model="bert-large-uncased-whole-word-masking-finetuned-squad")

# Example from Speed HPC manual (paraphrased content)
context = (
    "Speed is a high-performance computing cluster at Concordia University. "
    "It uses SLURM for job scheduling. Students must be approved by a supervisor or instructor to use it. "
    "Speed is free to all Gina Cody School faculty, staff, and students."
)

question = "Who can use the Speed cluster?"
result = qa_pipeline(question=question, context=context)

print(f"Question: {question}")
print("Answer:", result['answer'])
