from flask import Flask, request, jsonify
from transformers import pipeline
from youtube_transcript_api import YouTubeTranscriptApi, TranscriptsDisabled, NoTranscriptFound
import re

app = Flask(__name__)
summarizer = pipeline("summarization", model="facebook/bart-large-cnn")

def extract_video_id(url):
    match = re.search(r"(?:v=|youtu\.be/)([A-Za-z0-9_-]{11})", url)
    if match:
        return match.group(1)
    return None

@app.route("/summarize", methods=["POST"])
def summarize_text():
    data = request.get_json()

    if "youtube_url" in data:
        video_id = extract_video_id(data["youtube_url"])
        if not video_id:
            return jsonify({"error": "Invalid YouTube URL."})
        try:
            transcript = YouTubeTranscriptApi.get_transcript(video_id)
            text = " ".join([t["text"] for t in transcript])
        except (TranscriptsDisabled, NoTranscriptFound):
            return jsonify({"error": "Transcript not available for this video."})
    elif "text" in data:
        text = data["text"]
    else:
        return jsonify({"error": "No text or YouTube URL provided."})

    input_len = len(text.split())
    max_len = max(5, min(150, input_len * 2))
    min_len = min(5, max_len)

    summary = summarizer(text, max_length=max_len, min_length=min_len, do_sample=False)

    return jsonify({"summary": summary[0]['summary_text']})

if __name__ == "__main__":
    app.run(debug=True)

