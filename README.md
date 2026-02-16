<div align="center">

# Photo Organizer Pro  
### AI-Powered Smart Gallery with Oracle & Machine Learning Integration

Modern web-based photo management system with **semantic search**,  
**image processing**, and **AI image classification**.

Built with ASP.NET Web Forms, Oracle Database, and ML integration.

</div>

---

## Overview

**Photo Organizer Pro** is a full-stack smart photo gallery application that combines:

-  Oracle database image storage (BLOB)
- AI-powered image classification (ONNX + ML.NET / Python API)
- Semantic image search (content-based retrieval)
- Metadata & tag-based organization
- Built-in image editing tools
- Dashboard analytics

It is designed as a complete intelligent media management system.

---

## Architecture

### Backend
- **ASP.NET Web Forms (C#)**
- **Oracle Database (BLOB + ORDSYS.ORDIMAGE)**
- Stored Procedures for:
  - Insert
  - Update
  - Export
  - Semantic retrieval
  - Signature generation

### AI Layer
Two AI integration options:

1️ **ML.NET + ONNX (SqueezeNet)**
- Loads `squeezenet1.0-12.onnx`
- Uses ImageNet labels
- Returns Top-3 predictions

2️ **Python REST API**
- Sends image to `http://127.0.0.1:5000/classify`
- Receives JSON predictions
- Displays confidence scores

---

##  Core Features

###  Image Upload
- Upload JPEG images
- Add metadata:
  - Date
  - Location
  - Tags
- Stored as BLOB in Oracle

---

### Gallery View
- Responsive card layout
- Quick actions:
  - View
  - Edit
  - Download
- Metadata badges displayed

---

### Image Editing Tools

- Resize
- Rotate
- Brightness & Contrast adjustment
- Grayscale filter
- Sepia filter

All changes update the image directly in the database.

---

### Semantic Image Search

Content-based retrieval using:

- Color similarity
- Texture similarity
- Shape similarity
- Location similarity

Powered by Oracle stored procedures:
- `PROC_GEN_SEMN_IMAGINI`
- `PROC_REGASIRE_IMAGINE`

---

### Text-Based Search

Search images by:
- Tags
- Description keywords
- Metadata fields

Uses Oracle REF CURSOR for dynamic retrieval.

---

### AI Image Classification

Upload an image to receive:

Model:
- SqueezeNet 1.0 (ImageNet – 1000 classes)
- ONNX format

---

### Dashboard Analytics

Displays:
- Total images
- Unique tags
- Unique locations
- Album distribution (family, vacation, nature, etc.)

---

## Project Structure

---

## Requirements

### Backend
- .NET Framework
- Oracle Database
- Oracle.ManagedDataAccess
- Newtonsoft.Json

### ML (Option 1)
- ML.NET
- ONNX Runtime

### ML (Option 2)
- Python 3.x
- Flask (example API)
- ONNX / Torch backend

---

## Oracle Database Setup

Images are stored in:

```sql
IMGS (
    ID NUMBER,
    DESCRIERE VARCHAR2,
    IMG ORDSYS.ORDIMAGE
)


