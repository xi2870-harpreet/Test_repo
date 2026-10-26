---
slug: rag-retrieval
id: e9lfuhiv78nl
type: challenge
title: 'Agent Observability for RAG: Retrieval and Response Generation'
notes:
- type: text
  contents: |
    Click **Start** in the bottom right when the lab environment is ready.

    > **Note**: This lab will timeout after 60 minutes of inactivity.
tabs:
- id: hrt1k9gjc1sj
  title: Terminal
  type: terminal
  hostname: lab-host
- id: n6eamavbqo0n
  title: IDE
  type: service
  hostname: lab-host
  path: /
  port: 8080
- id: mije2ohxchol
  title: QuantumHound Chatbot
  type: service
  hostname: lab-host
  path: /
  port: 8501
- id: xfdbpo94amjs
  title: Help
  type: website
  url: https://datadoghq.dev/training-lab-support?tags=lc-env
difficulty: basic
enhanced_loading: null
---

With a knowledge base that can be queried and the ability to embed documents, you can now implement the retrieval step in the chatbot's RAG workflow.

In this activity, you'll do the following:

- Implement the retrieval and response generation steps of a RAG workflow
- Configure Agent Observability in your application code
- Use traces in Datadog to debug issues in retrieval and response generation, such as empty context or slow retrieval
- Track the progress and performance of development changes to your LLM application using Datadog's Agent Observability

As you develop the RAG feature, you'll send traces to Datadog and examine them to observe the performance of the QuantumHound chatbot as it evolves.

Step 1: Instrument the API service for Agent Observability
===

Follow the steps below to enable Agent Observability in the QuantumHound API.

This is similar to the configuration you did for the knowledge base service in the previous lab, so the steps may be somewhat familiar.

1. In the [IDE](tab-1), open `backend_api/app/app.py`.

    Below the existing imports, add the following import statement:

    ```python
    # enable Agent Observability
    from ddtrace.llmobs import LLMObs
    ```

1. In the same file, below the import line you just added, and above the line that initializes the FastAPI app, add the following code to enable Agent Observability:

    ```python
    import os

    LLMObs.enable(
      ml_app=os.getenv("DD_LLMOBS_ML_APP"),
      api_key=os.getenv("DD_API_KEY"),
      site=os.getenv("DD_SITE"),
    )
    ```

    These environment variables have already been set in `docker-compose.yml`.

    When you use `LLMObs.enable()`, you no longer need the `ddtrace-run` command in the `docker-compose.yml` file.

1. In the [IDE](tab-1), open `docker-compose.yml`.

1. On line 76, remove `ddtrace-run` from the run command for the `backend_api` services.

    Leave everything else, beginning with `uvicorn`, as it is.

    Lines 72-77 should now look like this:

    ```yaml,wrap,nocopy
    command: [
        "sh",
        "-c",
        "uvicorn app:app --host ${FASTAPI_HOST} --port ${FASTAPI_PORT:-8000} --reload",
      ]
    ```

1. In the [terminal](tab-0), restart the API service to apply the changes:

    ```sh,run
    docker compose up -d --force-recreate backend_api
    ```

    <br>
    <details>
      <summary><strong>🛑 To fix errors when restarting the service</strong></summary>

      <p>If you encounter errors when restarting the knowledge base service, it may be due to formatting issues in the <code>docker-compose.yml</code> file or the <code>kb-service/ingest_documents.py</code> file.</p>

      <p>To overwrite your changes with the correct formatting and content, you can run the following command in the <a href="tab-0">terminal</a>:
      </p>

      ```sh,run
      api-enable-llm-obs
      ```

      <p>Running this script makes the same changes that are detailed in the manual steps above:</p>

      <ul>
      <li>Adds the <code>ddtrace.llmobs</code> import to <code>app.py</code></li>
      <li>Adds <code>LLMObs.enable()</code> to <code>app.py</code></li>
      <li>Removes the <code>ddtrace-run</code> command from <code>docker-compose.yml</code></li>
      <li>Restarts the API service with the new configuration</li>
      </ul>
      <p>You should see output confirming the changes that have been made:</p>

      ```plaintext,nocopy
      Enabling Agent Observability in the API...
      Removing ddtrace-run from docker-compose.yml...
      ✨ Agent Observability enabled. Restarting API service...
      [+] up 2/2
      ✔ Container locallama Running                              0.0s
      ✔ Container api       Recreated                            10.4s
      ```

    </details>
    <br>

In the next several steps, you'll implement retrieval and response generation in the QuantumHound chatbot.

At each step, you'll also add instrumentation for Agent Observability to ensure that you're tracing key operations in the RAG workflow.

You'll make several changes before restarting the API service.

Step 2: Convert user messages into embeddings for retrieval
===

In this step you'll add code to convert user messages (the chatbot’s input) into embeddings, which will be used to search the vector database for relevant documents.

1. In the [terminal](tab-0), run the following command to add the query embedding functionality:

    ```sh,run
    add-query-embedding
    ```

    You should see output confirming the changes made:

    ```plaintext,nocopy
    Updating code to add query embedding functionality to the API...
    Query embedding functionality added to the API.
    ```

    Running this command makes the following changes to the code:

    - Adds the `create_embeddings` function to `backend_api/app/utils/llm.py`
    - Configures the embedding model settings in `config.py`
    - Adds the `@embedding` decorator to the `create_embeddings` function to trace embedding generation.

1. In the [IDE](tab-1), open `backend_api/app/utils/llm.py` to review the changes made by running the command.

    <br>
    <details>
      <summary>Review code additions in <code>backend_api/app/utils/llm.py</code></summary>

      ```python,wrap,nocopy
      # llm.py
      from ddtrace.llmobs.decorators import embedding
      ...
      EMBED_URL = f"{config.EMBED_BASE_URL}:{config.EMBED_PORT}/v1"
      ...
      openai_client_embedding = OpenAI(
          base_url=EMBED_URL,
          api_key=config.OPENAI_API_KEY,
      )
      ...
      @embedding(model_name=config.EMBED_MODEL)
      def create_embeddings(text: str, prefix: str = "search_query") -> List[float]:
          """
          Creates embeddings for the given text using the configured embedding model.
          """
          response = openai_client_embedding.embeddings.create(
              model=config.EMBED_MODEL, input=[f"{prefix}: {text}"]
          )
          return response.data[0].embedding
      ```

    </details>
    <br>

There are a few more changes to make before restarting the services.

Step 3: Retrieve documents from the database
===

Now you'll add code to search the vector database for documents similar to the user's query, using the embeddings generated in the previous step.

1. In the [terminal](tab-0), run the following command to add the retrieval functionality:

    ```sh,run
    add-document-retrieval
    ```

    The output should look like this:

    ```plaintext,nocopy
    Adding code for document retrieval to the API...
    Document retrieval functionality added to the API.
    ```

    This command implements the following changes:

    - Adds `utils/vector_store.py` to allow the API to retrieve documents from the vector store using the `find_similar_documents` function
    - Adds the ChromaDB client to the `requirements.txt` file
    - Configures the vector store settings in `config.py`
    - Adds the `@retrieval` decorator and an annotation to the `find_similar_documents` function to track the vector store operation

1. In the [IDE](tab-1), open `backend_api/app/utils/vector_store.py` to review the changes made by running the command.

    <br>
    <details>
      <summary>Review changes in <code>backend_api/app/utils/vector_store.py</code></summary>

      ```python,wrap,nocopy
      # vector_store.py
      from ddtrace.llmobs.decorators import retrieval
      from ddtrace.llmobs import LLMObs
      ...
      @retrieval
      def find_similar_documents(embeddings: List[float], n_results: int = 3, topic: str = None) -> List[str]:
          #...
          LLMObs.annotate(
              output_data=results,
          )
      ```

    </details>
    <br>

    There is one more step to complete the RAG workflow. When it is complete and running, you'll examine this retrieval step closely to check that documents are being retrieved correctly.

Step 4: Augment the LLM prompt with the retrieved documents
===

This step brings all the pieces of the RAG workflow together. You'll modify the LLM call that powers the chatbot to include the retrieved documents as context for the original prompt.

1. In the [terminal](tab-0), run the following command to augment the LLM prompt with the retrieved documents:

    ```sh,run
    add-rag-llm-call
    ```

    Running this command makes the following changes to the code:

    - Adds the `categorize_query` function to `utils/llm.py` to specify a topic for the retrieval step
    - Adds the `@llm` decorator to the `categorize_query` function
    - Adds the `ask_the_llm_with_rag` function to `utils/llm.py`
    - Adds the `@workflow` decorator to the `ask_the_llm_with_rag` function
    - Changes the `/ask` API endpoint to use the new `ask_the_llm_with_rag` function
    - Restarts the API service

    While you're waiting for the build to complete, you can review what's changed in the code.

1. In the [IDE](tab-1), open `backend_api/app/utils/llm.py` to review the changes made by running the command.

    <br>
    <details>
      <summary>Review changes in <code>backend_api/app/utils/llm.py</code></summary>

      ```python,wrap,nocopy
      # llm.py
      from ddtrace.llmobs.decorators import llm, workflow
      ...
      @llm(model_name=config.LLM_MODEL)
      def categorize_query(query: str) -> str:
          #...
          return category

      @workflow
      def ask_the_llm_with_rag(prompt: str) -> str:
          #...
          return response
      ```

    </details>
    <br>

1. Open `backend_api/app/app.py` to see the changes made to the API endpoint that handles the request from the chatbot frontend.
    <br>
    <details>
      <summary>Review changes in <code>backend_api/app/app.py</code></summary>

      ```python,wrap,nocopy
      # app.py
      from utils.llm import ask_the_llm_with_rag

      # augmented LLM call
      @app.get("/ask")
      def ask(prompt: str):
          #...
          response = ask_the_llm_with_rag(prompt) # New LLM call with RAG
          return Response(content=response, media_type="application/json")
      ```

    </details>
    <br>

1. Return to the [Terminal](tab-0) tab to check the progress of the build.

    When everything has completed, you should see output like the following:

    ```plaintext,nocopy
    Updating code for RAG LLM call in the API...
    RAG LLM call added to the API 🎉
    Restarting services...
    [+] up 2/2
    ✔ Container locallama Running                                0.0s
    ✔ Container api       Started                                10.7s
    ```

1. Run the following command to confirm that all the services are up and running:

    ```sh,run
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
    ```

    You should see that the following services are all up (any order is fine):

    - `chatbot`
    - `api`
    - `locallama`
    - `text-embedder`
    - `vector-store`
    - `kb-service`

Ok, you've got all the pieces in place for retrieval and response generation! It's time to ask the chatbot a question and see how it performs.

Step 5: Interact with and troubleshoot the RAG-enabled chatbot
===

In this step, you'll see how well document retrieval and response generation are working and analyze traces coming from the RAG-enabled chatbot to diagnose any issues you encounter.

1. In the [QuantumHound Chatbot](tab-2), ask a question that should be answered using the information in the knowledge base.

    The knowledge base contains a list of time-travel destinations and events, policies, time-travel technology details, and sales information.

    You can see the knowledge base documents in the `kb_data/` directory in the [IDE](tab-1) if you want to compare the chatbot's responses to the knowledge base content.

    Here's a question you can start with:

    ```plaintext
    What time-travel packages does QuantumHound offer?
    ```

    You might see a response like this at this point:

    ![Chatbot interaction showing an answer that begins "I'm not aware of any information about a company called QuantumHound or their time-travel packages."](..\assets\chatbot-hallucination.png)

    You were expecting to see that it was using the knowledge base to answer this question, but it still seems to be making up information and not referring to the QuantumHound knowledge base.

    You'll need to check the traces in Datadog to see what's actually happening here.

1. In Datadog, navigate to [AI Observability > Agent Observability > Traces](https://app.datadoghq.com/llm/traces).

1. Clear any existing filters in the search bar.

1. Select `Traces` as the search scope.

1. In the list of facets in the sidebar, find the **Span Kind** section.

1. Select the `workflow` span kind to filter the list to only show these top-level spans.

    The workflow span `ask_the_llm_with_rag` at the top of the list is the root span that orchestrates the entire RAG pipeline, from query categorization to LLM response generation.

    This filter may be enough to find the trace for the question you just asked, but if not, you can search for the text of your specific question.

1. In the search bar, next to the `@meta.span.kind:workflow` filter, enter the question you just asked, including quotation marks.

    ```plaintext
    "What time-travel packages does QuantumHound offer?"
    ```

    The search input should look like this:

    ![Search bar with span kind and question text.](..\assets\search-bar-with-span-kind-and-question.png)

1. Click the trace that corresponds to your question to open the trace details.

1. In the trace details, look at the list of spans to see the chain of operations in the trace.

    Notice that no errors are displayed in any of the steps, which means that the steps are running as expected.

    Near the bottom of the span list, the LLM span `ask_the_llm` has a child LLM span called `OpenAI.createChatCompletion`.

1. Click the `OpenAI.createChatCompletion` span to inspect its input and output data.

    The input data is expected to include the user's query and the context retrieved from the vector database.

    ![Input data for OpenAI.createChatCompletion span showing missing context](..\assets\chat-completion-input.png)

    You notice something unexpected in the `USER` input message: **there are empty brackets where the retrieved context should be!**

    This means that the knowledge base documents are not being passed to the LLM before it generates its response.

    This is just missing information, not an error. This type of failure, which is common in RAG workflows, is difficult to track down without the visibility you have in the trace.

    But why is this information missing? Are any documents being found?

1. Click the `find_similar_documents` retrieval span and look at the input and output data.

    The input data includes the embeddings generated from the user's query, and the output data should include the retrieved documents.

    Remembering that you added an annotation to the span to include the output data, scroll below the Input section to see the output.

1. Click the output section to expand it.

    Inspecting the output data, you can see **3 Output Documents** were retrieved in this step:

    ![Output data for find_similar_documents span](..\assets\find-similar-documents-output.png)

    The retrieved documents appear incomplete or truncated, but they *are* present. So why they are missing from the LLM call? You need to investigate further.

1. In the [IDE](tab-1), go to `backend_api/app/utils/vector_store.py` and scroll down to the `find_similar_documents` function.

    On line 56, you notice that the annotation is using the key `documents` to get the data from the queried `results`—but on line 60, the incorrect key `document` is being used instead! This causes an empty list to be returned and used as the context in the request to the LLM.

    ```python
    # vector_store.py
    def find_similar_documents(
        embeddings: List[float], n_results: int = 3, topic: str = None
    ) -> List[str]:
        # ...
        LLMObs.annotate(
          output_data=results.get("documents", [[]])[0] # <-- this is correct!
        )

        # Extract first document list from results if available
        docs = results.get("document", [[]])  # <-- this is a bug!
        return docs[0] if docs else []
    ```

1. Fix the bug by changing the key from `document` to `documents`.

    You can make this change manually in the [IDE](tab-1), or you can run the following command in the [terminal](tab-0) to make the change:

    ```sh,run
    sed -i 's/results\.get("document", \[\[\]\]).*$/results.get("documents", [[]])/g' backend_api/app/utils/vector_store.py
    ```

1. In the [terminal](tab-0), restart the API service:

    ```sh,run
    docker compose restart backend_api
    ```

    Wait a few moments for the service to restart before continuing.

1. In the [QuantumHound Chatbot](tab-2), ask a similar question:

    ```plaintext
    Can you tell me about the time-travel packages QuantumHound offers?
    ```

    The chatbot should now be able to retrieve relevant information from the knowledge base and provide an answer based on the documents you ingested earlier.

1. In Datadog, navigate to [AI Observability > Agent Observability > Traces](https://app.datadoghq.com/llm/traces) and look for the trace of the question you just asked.

1. Open the trace details and select the `OpenAI.createChatCompletion` span again.

    In the **Input Messages** section under `USER`, you should see that the context is no longer missing.

    ![Input data for OpenAI.createChatCompletion span showing retrieved context](..\assets\fixed-context.png)

    The context now includes the expected documents retrieved from the vector database, which should provide the necessary information for the LLM to generate a response.

### Generate new traces

1. In the [terminal](tab-0), run the script to simulate user interactions with the chatbot again and generate new traces that should all include context from the knowledge base:

    ```sh,run
    automate-requests
    ```

    While you are waiting for the traces to show up, you might take a few moments to skim the documents in the knowledge base to see what information is available. Then, you can check the chatbot's response against that information. The next steps will guide you through doing that.

1. In the [IDE](tab-1), navigate to `kb-service/kb_data`, where you'll find the documents that were ingested into the knowledge base.

1. Open the FAQ document (`faq.md`) and skim its contents.

    This document contains common questions and answers about the QuantumHound time-travel service. Find something in this document you can use to fact-check the chatbot's RAG-enabled responses.

1. In the [QuantumHound Chatbot](tab-2), ask a question to check the chatbot's accuracy.

    For example, you can ask:

    ```plaintext
    Can I travel to any time period with QuantumHound?
    ```

    The FAQ document in the knowledge base (`kb-service/kb_data/faq.md`) states that only pre-approved events listed as an official travel package can be booked:

    ```md,nocopy,wrap
    ## Can I choose any time period or historical event for travel?
    No. QuantumHound travel packages are limited to **pre-approved destinations** listed in the official Travel Package Catalog. Custom destinations or speculative time periods are not supported.
    ```

    With the context bug fixed, you expect the chatbot to reply with an answer that reflects this policy. But you might see an ambiguous response like this:

    ![Chatbot interaction showing an answer that includes "Unfortunately, with our current knowledge base, we can't guarantee that you'll be able to visit every possible time period."](..\assets\rag-response.png)

From the chatbot's response alone, it's challenging to determine if the knowledge base is actually being used effectively. By examining traces in Datadog, you gain clear and concrete evidence of exactly how retrieval and response generation operations are performing.

Step 6: Observe the RAG workflow in Datadog
===

Now that you’ve verified the chatbot is returning context-aware responses (even if they are still not very good), you're ready to analyze the traces in Datadog to observe the RAG workflow in action.

1. In Datadog, navigate back to the Agent Observability [Traces list](https://app.datadoghq.com/llm/traces).

    Traces that reflect the RAG-enabled responses should be rolling in.

1. Clear any filters or queries that may still be in the search bar.

1. In the facets in the sidebar, in the **Service** section, select the `quantumhound-api` service to filter the traces to only show those from the API service.

1. Make sure `Spans` is selected as the search scope.

1. Search for a specific span kind, which you defined using decorators for the RAG workflow.

    For example, you can search for spans with the `retrieval` span kind to see all the retrieval operations that were performed in the RAG workflow:

    ```plaintext
    @meta.span.kind:retrieval
    ```

    You can also select the **Span Kind** facet in the sidebar to filter by any available span kind.

1. Click the span to see its details.

1. Click **Flame Graph** to visualize the spans that were generated for this trace.

1. Click the icon to collapse the minimap so you can see the full flame graph.

    ![Flame graph showing spans for the RAG workflow](..\assets\rag-workflow-flamegraph.png)

1. Hover over the `ask_the_llm_with_rag` span in the flame graph.

    This workflow span is the parent of the retrieval span you originally viewed.

1. Hover over each horizontal bar in the flamegraph to see more details.

    You can see the full chain of operations that were executed to handle the user's request reflected in the flame graph and in the list of spans.

    What steps could use more visibility? The Datadog tracing library lets you add custom annotations and tags to spans, so you can include more detailed context at any stage of the workflow.

You're just getting started with Agent Observability, but you can already see how it provides deep visibility into the RAG pipeline, helping you track the flow of data, clearly observe key operations, and debug issues like the one you encountered with missing context.

With the ability to analyze trace and span data for your LLM application, you'll be able to continue refining your chatbot to improve its performance and accuracy.

Lab summary
===

In this lab activity, you did the following:

1. Built a fully functional RAG pipeline for the QuantumHound chatbot, providing accurate, context-aware responses based on a curated knowledge base
1. Instrumented the RAG workflow with Datadog to observe span-level traces for each step in the process
1. Captured additional context in the traces to provide full visibility into RAG operations
1. Used span-level trace data in Datadog to debug issues in the RAG workflow
1. Analyzed the performance of the RAG workflow and identified areas for improvement

Click **Next** to finish the lab.
