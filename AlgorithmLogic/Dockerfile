FROM python:3.11

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install flask
RUN pip install matplotlib
RUN pip install requests
RUN pip install python-dotenv
RUN pip install psycopg2
RUN pip install pysqlite3
RUN pip install chromadb
RUN pip install scipy

EXPOSE 4160

CMD ["python3", "server.py"]
