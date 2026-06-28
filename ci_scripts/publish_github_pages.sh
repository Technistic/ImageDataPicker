#!/bin/bash

#  publish_github_pages.sh
#
#  Publish DocC archives for both projects in this repository to GitHub Pages.
#  Each documentation channel is hosted independently so integration, staging,
#  and release documentation can coexist in one Pages site.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${CI_PRIMARY_REPOSITORY_PATH:-$(cd "${script_dir}/.." && pwd)}"

GITHUB_PAGES_BRANCH="${GITHUB_PAGES_BRANCH:-feature/docc-hosting}"
GITHUB_PAGES_DIR="${GITHUB_PAGES_DIR:-docs}"
GITHUB_ORGANIZATION="${GITHUB_ORGANIZATION:-Technistic}"
GITHUB_PAGES_REPO="${GITHUB_PAGES_REPO:-ImageDataPicker}"

workspace_root="${CI_WORKSPACE_PATH:-${repo_root}}"
workspace_doc_archives="${workspace_root}/doc_archives"
pages_root="${repo_root}/${GITHUB_PAGES_DIR}"

stash_created="false"
checkout_branch="${CI_BRANCH:-$(git -C "${repo_root}" rev-parse --abbrev-ref HEAD)}"

cleanup() {
    local exit_code=$?

    if git -C "${repo_root}" rev-parse --verify "${checkout_branch}" >/dev/null 2>&1; then
        git -C "${repo_root}" checkout "${checkout_branch}" >/dev/null 2>&1 || true
    fi

    if [[ "${stash_created}" == "true" ]]; then
        git -C "${repo_root}" stash pop >/dev/null 2>&1 || true
    fi

    exit "${exit_code}"
}

trap cleanup EXIT

lowercase_string() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

capitalize_string() {
    local input="$1"
    local first_char rest

    if [[ -z "${input}" ]]; then
        return
    fi

    first_char="$(printf '%s' "${input}" | cut -c1 | tr '[:lower:]' '[:upper:]')"
    rest="$(printf '%s' "${input}" | cut -c2-)"
    printf '%s%s\n' "${first_char}" "${rest}"
}

doc_title_for_slug() {
    case "$1" in
        imagedatapicker)
            echo "ImageDataPicker"
            ;;
        employeeformexample)
            echo "EmployeeFormExample"
            ;;
        *)
            capitalize_string "$1"
            ;;
    esac
}

doc_slug_for_archive() {
    local archive_slug
    archive_slug="$(lowercase_string "$1")"

    case "${archive_slug}" in
        imagedatapicker|employeeformexample)
            echo "${archive_slug}"
            ;;
        *)
            echo "${archive_slug}"
            ;;
    esac
}

project_doc_relative_path() {
    local project_slug="$1"
    echo "./${project_slug}/documentation/${project_slug}/"
}

absolute_hosting_base_path() {
    local channel="$1"
    local project_slug="$2"
    echo "/${GITHUB_PAGES_REPO}/${channel}/${project_slug}"
}

determine_pages_channel() {
    local requested_channel="${DOCC_PAGES_CHANNEL:-${GITHUB_PAGES_CHANNEL:-}}"
    local normalized_release_channel="${release_channel:-}"
    local normalized_requested_channel

    if [[ -n "${requested_channel}" ]]; then
        normalized_requested_channel="$(lowercase_string "${requested_channel}")"
        case "${normalized_requested_channel}" in
            integration|alpha)
                echo "integration"
                return
                ;;
            staging|beta|rc)
                echo "staging"
                return
                ;;
            release|production|main)
                echo "release"
                return
                ;;
            *)
                echo "${normalized_requested_channel}"
                return
                ;;
        esac
    fi

    normalized_release_channel="$(lowercase_string "${normalized_release_channel}")"
    case "${normalized_release_channel}" in
        alpha)
            echo "integration"
            ;;
        beta|rc)
            echo "staging"
            ;;
        production|"")
            echo "release"
            ;;
        *)
            echo "${normalized_release_channel}"
            ;;
    esac
}

first_channel_with_docs() {
    local candidate

    for candidate in release staging integration; do
        if [[ -d "${pages_root}/${candidate}" ]] && find "${pages_root}/${candidate}" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
            echo "${candidate}"
            return
        fi
    done
}

channel_has_project() {
    local channel="$1"
    local project_slug="$2"

    [[ -d "${pages_root}/${channel}/${project_slug}" ]]
}

generate_release_redirect() {
    local project_slug="$1"
    local legacy_root="${pages_root}/${project_slug}"
    local legacy_doc_root="${legacy_root}/documentation"
    local redirect_target="/${GITHUB_PAGES_REPO}/release/${project_slug}/"
    local doc_redirect_target="/${GITHUB_PAGES_REPO}/release/${project_slug}/documentation/${project_slug}/"

    mkdir -p "${legacy_doc_root}"

    cat > "${legacy_root}/index.html" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=${redirect_target}">
  <link rel="canonical" href="${redirect_target}">
  <title>Redirecting...</title>
</head>
<body>
  <p>Redirecting to <a href="${redirect_target}">${redirect_target}</a>...</p>
</body>
</html>
EOF

    cat > "${legacy_doc_root}/index.html" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=${doc_redirect_target}">
  <link rel="canonical" href="${doc_redirect_target}">
  <title>Redirecting...</title>
</head>
<body>
  <p>Redirecting to <a href="${doc_redirect_target}">${doc_redirect_target}</a>...</p>
</body>
</html>
EOF
}

generate_release_doc_redirect() {
    local project_slug="$1"
    local release_target="/${GITHUB_PAGES_REPO}/release/${project_slug}/documentation/${project_slug}/"
    local legacy_doc_path="${pages_root}/${project_slug}/documentation/${project_slug}"

    mkdir -p "${legacy_doc_path}"

    cat > "${legacy_doc_path}/index.html" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=${release_target}">
  <link rel="canonical" href="${release_target}">
  <title>Redirecting...</title>
</head>
<body>
  <p>Redirecting to <a href="${release_target}">${release_target}</a>...</p>
</body>
</html>
EOF
}

generate_channel_index() {
    local channel="$1"
    local channel_index="${pages_root}/${channel}/index.html"
    local framework_link sample_link

    framework_link="$(project_doc_relative_path "imagedatapicker")"
    sample_link="$(project_doc_relative_path "employeeformexample")"

    cat > "${channel_index}" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${CI_PRODUCT:-DocC} $(capitalize_string "${channel}") Documentation</title>
  <style>
    :root {
      color-scheme: light;
      --bg: #eff3fb;
      --panel: rgba(255, 255, 255, 0.92);
      --text: #172033;
      --muted: #5f6b82;
      --border: #d6deef;
      --accent: #0b5cff;
      --accent-soft: #eaf1ff;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      color: var(--text);
      background:
        radial-gradient(circle at top left, #dce7ff 0%, transparent 30%),
        linear-gradient(180deg, #f9fbff 0%, var(--bg) 100%);
    }
    main {
      width: min(980px, calc(100vw - 32px));
      margin: 48px auto;
      padding: 32px;
      border-radius: 28px;
      background: var(--panel);
      border: 1px solid var(--border);
      box-shadow: 0 24px 64px rgba(23, 32, 51, 0.10);
    }
    .eyebrow {
      display: inline-block;
      margin-bottom: 12px;
      padding: 6px 12px;
      border-radius: 999px;
      background: var(--accent-soft);
      color: var(--accent);
      font-size: 0.9rem;
      font-weight: 700;
      letter-spacing: 0.02em;
      text-transform: uppercase;
    }
    h1 {
      margin: 0 0 12px;
      font-size: clamp(2rem, 4vw, 3.2rem);
      line-height: 1.05;
    }
    p {
      margin: 0 0 28px;
      color: var(--muted);
      line-height: 1.6;
      max-width: 66ch;
    }
    .grid {
      display: grid;
      gap: 18px;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    }
    .card {
      display: block;
      padding: 22px;
      border-radius: 20px;
      border: 1px solid var(--border);
      background: #fff;
      text-decoration: none;
      color: inherit;
      box-shadow: 0 14px 36px rgba(23, 32, 51, 0.06);
    }
    .card h2 {
      margin: 0 0 8px;
      font-size: 1.3rem;
    }
    .card p {
      margin: 0;
      font-size: 0.98rem;
    }
    .back-link {
      display: inline-block;
      margin-top: 24px;
      color: var(--accent);
      text-decoration: none;
      font-weight: 600;
    }
  </style>
</head>
<body>
  <main>
    <span class="eyebrow">$(capitalize_string "${channel}")</span>
    <h1>${CI_PRODUCT:-DocC} Documentation</h1>
    <p>Choose the documentation set you want to browse for this channel. The framework and sample app are published independently so both projects can coexist under the same GitHub Pages site.</p>
    <div class="grid">
      <a class="card" href="${framework_link}">
        <h2>ImageDataPicker</h2>
        <p>Framework API documentation, conceptual guides, and tutorials.</p>
      </a>
      <a class="card" href="${sample_link}">
        <h2>EmployeeFormExample</h2>
        <p>Sample app documentation showing the framework in a complete SwiftUI application.</p>
      </a>
    </div>
    <a class="back-link" href="../">Return to the documentation selector</a>
  </main>
</body>
</html>
EOF
}

generate_site_index() {
    local site_index="${pages_root}/index.html"
    local default_channel
    local default_project="imagedatapicker"
    local channel
    local project_label

    default_channel="$(first_channel_with_docs)"
    if [[ -z "${default_channel}" ]]; then
        default_channel="${pages_channel}"
    fi

    if ! channel_has_project "${default_channel}" "${default_project}"; then
        default_project="employeeformexample"
    fi

    cat > "${site_index}" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${CI_PRODUCT:-DocC} Documentation</title>
  <style>
    :root {
      color-scheme: light;
      --bg: #eff3fb;
      --panel: rgba(255, 255, 255, 0.92);
      --text: #172033;
      --muted: #5f6b82;
      --border: #d6deef;
      --accent: #0b5cff;
      --accent-soft: #eaf1ff;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      display: grid;
      place-items: center;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      color: var(--text);
      background:
        radial-gradient(circle at top left, #dce7ff 0%, transparent 30%),
        radial-gradient(circle at bottom right, #e9f3ff 0%, transparent 30%),
        linear-gradient(180deg, #f9fbff 0%, var(--bg) 100%);
    }
    main {
      width: min(760px, calc(100vw - 32px));
      padding: 32px;
      border-radius: 28px;
      background: var(--panel);
      border: 1px solid var(--border);
      box-shadow: 0 24px 64px rgba(23, 32, 51, 0.10);
    }
    h1 {
      margin: 0 0 12px;
      font-size: clamp(2rem, 4vw, 3.2rem);
      line-height: 1.05;
    }
    p {
      margin: 0 0 24px;
      color: var(--muted);
      line-height: 1.6;
    }
    .controls {
      display: grid;
      gap: 16px;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      margin-top: 24px;
    }
    label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
    }
    select {
      width: 100%;
      padding: 14px 16px;
      border-radius: 14px;
      border: 1px solid var(--border);
      background: #fff;
      color: var(--text);
      font-size: 1rem;
    }
    .actions {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
      margin-top: 24px;
    }
    a.button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 190px;
      padding: 12px 16px;
      border-radius: 999px;
      background: var(--accent);
      color: #fff;
      text-decoration: none;
      font-weight: 700;
    }
    .channel-links {
      margin-top: 28px;
      padding-top: 20px;
      border-top: 1px solid var(--border);
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }
    .channel-links a {
      color: var(--accent);
      text-decoration: none;
      font-weight: 600;
    }
  </style>
</head>
<body>
  <main>
    <h1>${CI_PRODUCT:-DocC} Documentation</h1>
    <p>Browse the framework and sample app documentation across the integration, staging, and release channels from one GitHub Pages site.</p>
    <div class="controls">
      <div>
        <label for="channel-select">Release channel</label>
        <select id="channel-select"></select>
      </div>
      <div>
        <label for="project-select">Project</label>
        <select id="project-select"></select>
      </div>
    </div>
    <div class="actions">
      <a class="button" id="open-docs" href="./${default_channel}/${default_project}/documentation/${default_project}/">Open documentation</a>
    </div>
    <div class="channel-links" id="channel-links"></div>
  </main>
  <script>
    const docs = {
EOF

    for channel in release staging integration; do
        if [[ -d "${pages_root}/${channel}" ]]; then
            cat >> "${site_index}" <<EOF
      "${channel}": {
EOF
            local added_project="false"
            for project_slug in imagedatapicker employeeformexample; do
                if channel_has_project "${channel}" "${project_slug}"; then
                    project_label="$(doc_title_for_slug "${project_slug}")"
                    cat >> "${site_index}" <<EOF
        "${project_slug}": {
          title: "${project_slug}",
          label: "${project_label}",
          href: "./${channel}/${project_slug}/documentation/${project_slug}/"
        },
EOF
                    added_project="true"
                fi
            done
            if [[ "${added_project}" == "false" ]]; then
                cat >> "${site_index}" <<EOF
        "__empty__": null,
EOF
            fi
            cat >> "${site_index}" <<EOF
      },
EOF
        fi
    done

    cat >> "${site_index}" <<EOF
    };

    const channelLabels = {
      release: "Release",
      staging: "Staging",
      integration: "Integration",
    };

    const channelSelect = document.getElementById("channel-select");
    const projectSelect = document.getElementById("project-select");
    const openLink = document.getElementById("open-docs");
    const channelLinks = document.getElementById("channel-links");

    function renderChannelOptions() {
      Object.keys(docs).forEach((channel) => {
        const option = document.createElement("option");
        option.value = channel;
        option.textContent = channelLabels[channel] || channel;
        channelSelect.appendChild(option);

        const link = document.createElement("a");
        link.href = "./" + channel + "/";
        link.textContent = (channelLabels[channel] || channel) + " overview";
        channelLinks.appendChild(link);
      });
    }

    function renderProjectOptions(channel) {
      projectSelect.innerHTML = "";
      const projects = docs[channel] || {};

      Object.keys(projects).forEach((project) => {
        if (project === "__empty__") return;
        const option = document.createElement("option");
        option.value = project;
        option.textContent = projects[project].label;
        projectSelect.appendChild(option);
      });
    }

function syncOpenLink() {
  const channel = channelSelect.value;
  const project = projectSelect.value;
  const entry = (docs[channel] || {})[project];
  if (!entry) return;
  openLink.href = entry.href;
}

    renderChannelOptions();
    channelSelect.value = "${default_channel}";
    renderProjectOptions(channelSelect.value);
    projectSelect.value = "${default_project}";
    syncOpenLink();

    channelSelect.addEventListener("change", () => {
      renderProjectOptions(channelSelect.value);
      syncOpenLink();
    });

    projectSelect.addEventListener("change", syncOpenLink);
  </script>
</body>
</html>
EOF
}

echo "Publishing DocC documentation for ${CI_PRODUCT:-unknown product}"

rm -rf "${workspace_doc_archives}"
mkdir -p "${workspace_doc_archives}"

derived_data_path="${CI_DERIVED_DATA_PATH:-${DERIVED_DATA_PATH:-}}"
if [[ -z "${derived_data_path}" ]]; then
    echo "Error: CI_DERIVED_DATA_PATH (or DERIVED_DATA_PATH) is not set."
    exit 1
fi

docc_archives=()
while IFS= read -r archive_path; do
    docc_archives+=("${archive_path}")
done < <(find "${derived_data_path}" -type d -name "*.doccarchive" | sort)

if [[ "${#docc_archives[@]}" -eq 0 ]]; then
    echo "No DocC archives found in ${CI_DERIVED_DATA_PATH}."
    exit 0
fi

cp -R "${docc_archives[@]}" "${workspace_doc_archives}/"

git -C "${repo_root}" config user.name "${DOCC_GITHUB_NAME}"
git -C "${repo_root}" config user.email "${DOCC_GITHUB_EMAIL}"

if [[ -n "$(git -C "${repo_root}" status --porcelain)" ]]; then
    git -C "${repo_root}" stash push -u -m "publish-github-pages" >/dev/null 2>&1 || true
    stash_created="true"
fi

git -C "${repo_root}" remote set-url origin "https://${DOCC_GITHUB_USERNAME}:${DOCC_GITHUB_API_TOKEN}@github.com/${GITHUB_ORGANIZATION}/${GITHUB_PAGES_REPO}"
source "${script_dir}/get_version_from_git_ref.sh" >/dev/null

pages_channel="$(determine_pages_channel)"
channel_root="${pages_root}/${pages_channel}"

echo "Publishing documentation channel: ${pages_channel}"

git -C "${repo_root}" fetch origin "${GITHUB_PAGES_BRANCH}"
git -C "${repo_root}" checkout "${GITHUB_PAGES_BRANCH}"
git -C "${repo_root}" reset --hard "origin/${GITHUB_PAGES_BRANCH}"
rm -rf "${channel_root}"
mkdir -p "${channel_root}"

for archive in "${workspace_doc_archives}"/*.doccarchive; do
    archive_file="$(basename "${archive}")"
    archive_name="${archive_file%%.doccarchive}"
    project_slug="$(doc_slug_for_archive "${archive_name}")"
    archive_target="${channel_root}/${project_slug}"
    hosting_base_path="$(absolute_hosting_base_path "${pages_channel}" "${project_slug}")"

    echo "Transforming archive: ${archive}"
    rm -rf "${archive_target}"
    xcrun docc process-archive transform-for-static-hosting "${archive}" \
        --output-path "${archive_target}" \
        --hosting-base-path "${hosting_base_path}"
done

generate_channel_index "${pages_channel}"
generate_site_index

generate_release_redirect "imagedatapicker"
generate_release_redirect "employeeformexample"
generate_release_doc_redirect "imagedatapicker"
generate_release_doc_redirect "employeeformexample"

git -C "${repo_root}" add "${GITHUB_PAGES_DIR}"

if git -C "${repo_root}" diff --cached --quiet; then
    echo "No DocC changes to publish."
else
    git -C "${repo_root}" commit -m "Updated ${pages_channel} DocC documentation"
    git -C "${repo_root}" push --set-upstream origin "${GITHUB_PAGES_BRANCH}"
fi

echo "Publishing DocC documentation for ${CI_PRODUCT:-unknown product} completed successfully."
