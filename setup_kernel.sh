#!/bin/bash

# Check if the Jupyter kernel is already installed
if ! jupyter kernelspec list | grep -q 'devbox-env'; then
    python -m ipykernel install --user --name=devbox-env --display-name='Devbox Environment'
    echo "Jupyter kernel 'devbox-env' installed."

    # Create .vscode directory if it doesn't exist
    mkdir -p .vscode

    # Check if the settings file exists and contains the correct kernel setting
    SETTINGS_FILE=".vscode/settings.json"
    if [ -f "$SETTINGS_FILE" ]; then
        if ! grep -q '"jupyter.notebook.defaultKernel": "devbox-env"' "$SETTINGS_FILE"; then
            echo "Updating kernel setting in $SETTINGS_FILE."
            # Update the settings file with the correct kernel
            jq '. + {"jupyter.notebook.defaultKernel": "devbox-env"}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        else
            echo "Kernel setting already configured in $SETTINGS_FILE."
        fi
    else
        echo "Creating $SETTINGS_FILE with kernel setting."
        cat <<EOL > "$SETTINGS_FILE"
{
    "jupyter.jupyterServerType": "local",
    "jupyter.notebook.defaultKernel": "devbox-env"
}
EOL
fi
else
    echo "Jupyter kernel 'devbox-env' already exists."
fi


