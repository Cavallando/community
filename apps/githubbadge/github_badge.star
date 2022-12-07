"""
Applet: Github Badge
Summary: Github action status
Description: Displays a Github badge for the status of the configured Action.
Author: Cavallando
"""

load("render.star", "render")
load("schema.star", "schema")
load("http.star", "http")
load("secret.star", "secret")
load("encoding/json.star", "json")
load("encoding/base64.star", "base64")

GITHUB_LOGO = base64.decode("""
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
""")
GITHUB_LOADING_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAIRlWElmTU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAAqgAwAEAAAAAQAAAAoAAAAAyELV9gAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDYuMC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KGV7hBwAAALRJREFUGBmNULkNAjEQnPUZUqQTBZATugGqID4S6rg6iC6mChq4kJwCAOkiJB4bj9GiFRCwkuXV7GhmdgWmUoJgh6pACzxEkMz41aYW7hO0mOeQgLSI+y3qsUND7BrRyRJnnQntaEHSyKGfTjAj8TjgcIsIc5Izx/UbFFUvWJF0GnDhY6/qzP2Vi2q/6m9rz3wlcM6Sc4Zs21Ax5+tKPi4qiG8XewoFLSYK8ud2ulxY424P/gQvBFBVoqUqSQAAAABJRU5ErkJggg==
""")
GITHUB_FAILED_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAIRlWElmTU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAAqgAwAEAAAAAQAAAAoAAAAAyELV9gAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDYuMC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KGV7hBwAAAJZJREFUGBl9kE0OgjAQhT/FI7HxBmw4oImJF3DneQxVVp6BRH1vYEgXSpPSefN+OhSW9YG99z8cfQl2laARbio8c5lS4DxAlwLXD7gYW3NIQuAq6+0Jx0lN12/ok49TorjqDu0Ar6ItQ2syuXX4cGx95AixkroCk5Oc7HpcZg5NJTwl4WAb659xz3No9nmp/v08lWDzwb8IgDcQ6vIG+QAAAABJRU5ErkJggg==
""")
GITHUB_SUCCESS_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAIRlWElmTU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAAqgAwAEAAAAAQAAAAoAAAAAyELV9gAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDYuMC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KGV7hBwAAALdJREFUGBl9kDEKwkAQRd8m0UbBWsRbWAsewCt4DrESwXNYit5ALEK2EIu09lZewkCcnWQW02SLnZk/j78zC31nT0JN2ofA9Q+ocQbHRIWcTOODWVqwCXmiAvJA3eYBWlFxY5RWlOIwbxkJL4ZaWAyQ55N5dqrbGCKeRDyqeGfSgUoGQW9m80xltadznGWEteiXasmBAC34qkHcLmcsTu+sYKuN1qmB7LYZrLbFrO7E5nNd3L7ThB9v2CtM7SwcKwAAAABJRU5ErkJggg==
""")


def get_status_icon(status):
  if status == "completed":
    return GITHUB_SUCCESS_ICON
  elif status == "failed":
    return GITHUB_FAILED_ICON
  else:
    return GITHUB_LOADING_ICON

def main(config):
    access_token = config.str("access_token")
    print(access_token)
    data = http.get(
        "https://api.github.com/repos/lovdcom/bucket/actions/runs",
        params = { "branch": "main" },
        headers = {"Accept": "application/vnd.github+json", "Authorization": "Bearer {}".format(access_token), "X-GitHub-Api-Version": "2022-11-28"},
    ).json()
    
    github_token = config.get("access_token")

    children = []
    for run in data.get("workflow_runs"):
        status = run.get("status")
        repository = run.get("repository")
        repository_name = run.get("full_name")
        workflow_url = run.get("workflow_url")
        workflow_data = http.get(
            workflow_url,
            params = { "branch": "main" },
            headers = {"Accept": "application/vnd.github+json", "Authorization": "Bearer {}".format(access_token), "X-GitHub-Api-Version": "2022-11-28"},
        ).json()
        workflow_name = workflow_data.get("name")
        children.append(
            render.Row(
                        cross_align="center",
                        main_align="center",
                        children=[
                            render.Padding(
                                pad=(1, 4, 2, 4),
                                child=render.Image(
                                    src=get_status_icon(status)
                                    )),
                            render.WrappedText(workflow_name)
                        ]
                    )
        )
    column = render.Column(
        expanded=True,
        children=children
    )

    return render.Root(
         child = render.Row(
            expanded=True,
            cross_align="center",
            main_align="center",
            children=[
                    render.Padding(
                        pad=(1, 4, 1, 4),
                        child=render.Image(
                                width=15,
                                height=15,
                                src=GITHUB_LOGO
                            )
                    ),
                    render.Marquee(
                        height=30,
                        scroll_direction="vertical",
                        child=column
                    )
            ]
         )
         
    )

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
           schema.Text(
                id = "access_token",
                name = "Github Personal Access Token",
                desc = "Personal Access token",
                icon = "lock",
                default = "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",
            ),
        ],
    )
