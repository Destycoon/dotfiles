#!/bin/bash

set -e  # Stop en cas d'erreur

DOTFILES_DIR=$(pwd)

# Liste des fichiers à linker : format "source destination"
declare -A FILES_TO_LINK=(
  [".bashrc"]="$HOME/.bashrc"
  [".zshrc"]="$HOME/.zshrc"
  [".config/kitty"]="$HOME/.config/kitty"
  [".config/starship.toml"]="$HOME/.config/starship.toml"
)

echo "🔗 Starting dotfiles linking..."

for SRC in "${!FILES_TO_LINK[@]}"; do
    DEST="${FILES_TO_LINK[$SRC]}"
    FULL_SRC="$DOTFILES_DIR/$SRC"

    # Création du dossier parent s’il n'existe pas
    mkdir -p "$(dirname "$DEST")"

    # Backup si fichier/dossier existant (et pas déjà un lien vers le bon fichier)
    if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
        echo "🛑 Backup de $DEST → ${DEST}.bak"
        mv "$DEST" "${DEST}.bak"
    fi

    # Création du lien symbolique
    ln -sf "$FULL_SRC" "$DEST"
    echo "✅ Linked $DEST → $FULL_SRC"
done

echo "🎉 All dotfiles linked successfully!"
