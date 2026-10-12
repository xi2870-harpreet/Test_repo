resource "lab" "main" {
  title       = "Mono A (throwaway)"
  description = "This is the Skeleton Lab.  \nYou can use this as a minimal starting point for developing labs. Monorepo lab A."

  # timelimit and idle are both required on every lab.
  settings {
    theme = "modern-dark"

    timelimit {
      duration = "1h"
    }

    idle {
      enabled = true
      timeout = "15m"
    }
  }

  layout = resource.layout.single_panel
}
