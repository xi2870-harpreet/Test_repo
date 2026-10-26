# ---------------------------------------------------------------------------
# Labs 2.0 migration of: workshop-llm-obs-rag
#
# BLOCKER: The original track uses a GCP VM image:
#   datadog-community/workshop-llm-obs-v2-lab-host-2-0-1  (e2-highcpu-8)
# This is not a Docker image. Labs 2.0 uses containers, not VMs.
#
# Additionally, this workshop runs multiple Docker Compose services inside
# the VM (Ollama LLM, ChromaDB, FastAPI backend, Streamlit chatbot).
# These would need to be either:
#   a) Pre-baked into a single Docker image, OR
#   b) Modelled as separate container resources in the lab
#
# ACTION REQUIRED (Datadog team):
# 1. Build container images for each service or a single combined image.
# 2. Push to a registry accessible from Instruqt.
# 3. Replace placeholders in the datadog-lab-host module.
#
# This file is a structural stub showing the correct Labs 2.0 pattern.
# ---------------------------------------------------------------------------

module "sandbox" {
  source = "../modules/datadog-lab-host"
}

resource "layout" "default" {
  content {
    type = "split-left"
    left {
      type    = "tabs"
      content = [module.sandbox.output.terminal_lab_host, module.sandbox.output.storedog_tab]
    }
    right {
      type = "instructions"
    }
    left_size = 60
  }
}

resource "page" "rag_knowledge_base" {
  title   = "RAG Knowledge Base"
  layout  = resource.layout.default
  content = file("instructions/01-rag-knowledge-base.md")
}

resource "page" "rag_retrieval" {
  title   = "RAG Retrieval"
  layout  = resource.layout.default
  content = file("instructions/02-rag-retrieval.md")
}

resource "lab" "main" {
  title     = "Agent Observability for RAG Workflows"
  timelimit = "4h"

  page { ref = resource.page.rag_knowledge_base }
  page { ref = resource.page.rag_retrieval }
}
