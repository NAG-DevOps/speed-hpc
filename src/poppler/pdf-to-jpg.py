import sys, os
from pdf2image import (
    convert_from_bytes,
    convert_from_path,
    pdfinfo_from_bytes,
    pdfinfo_from_path,
)
from pdf2image.exceptions import (
    PDFInfoNotInstalledError,
    PDFPageCountError,
    PDFSyntaxError,
    PDFPopplerTimeoutError,
)

pdf_file = "example.pdf"
output_dir = "./output"

if not os.path.exists(output_dir):
	os.makedirs("output")

# Save pages as images in the pdf
try:
	images = convert_from_path(pdf_file)
	for i in range(len(images)):
		output_file = os.path.join(output_dir, f'page_{i}.jpg')
		images[i].save(output_file, 'JPEG')
except Exception as e:
	print(f"Error processing PDF: {e}")
