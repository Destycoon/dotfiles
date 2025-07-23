#!/bin/bash

set -e  # Stop en cas d'erreur

DOTFILES_DIR=$(pwd)

# Fond d'écran par défaut pour pywal (modifiable)
WALLPAPER="$HOME/dotfiles/image/wallhaven-d6xjxg.png"

# Liste des paquets nécessaires à ton rice
PACKAGES=(
  zsh
  kitty
  starship
  fastfetch
  python-pywal
)

echo "📦 Installation des paquets requis..."

# Installation des paquets avec yay
for pkg in "${PACKAGES[@]}"; do
  if ! pacman -Q $pkg &>/dev/null; then
    echo "➕ Installation de $pkg"
    yay -S --noconfirm --needed "$pkg"
  else
    echo "✅ $pkg déjà installé"
  fi
done

# Activation de ZSH comme shell par défaut
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "🔁 Changement du shell par défaut vers zsh"
  chsh -s /bin/zsh
fi

# Liste des fichiers à linker : format "source destination"
declare -A FILES_TO_LINK=(
  [".zshrc"]="$HOME/.zshrc"
  [".config/kitty"]="$HOME/.config/kitty"
  [".config/starship.toml"]="$HOME/.config/starship.toml"
  [".config/fastfetch"]="$HOME/.config/fastfetch"
)

echo "🔗 Lien des fichiers de configuration..."

for SRC in "${!FILES_TO_LINK[@]}"; do
    DEST="${FILES_TO_LINK[$SRC]}"
    FULL_SRC="$DOTFILES_DIR/$SRC"

    mkdir -p "$(dirname "$DEST")"

    if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
        echo "🛑 Backup de $DEST → ${DEST}.bak"
        mv "$DEST" "${DEST}.bak"
    fi

    ln -sf "$FULL_SRC" "$DEST"
    echo "✅ Linked $DEST → $FULL_SRC"
done

# Ajout automatique de starship et fastfetch dans .zshrc
ZSHRC="$HOME/.zshrc"
if ! grep -q "starship init zsh" "$ZSHRC"; then
  echo 'eval "$(starship init zsh)"' >> "$ZSHRC"
fi

if ! grep -q "fastfetch" "$ZSHRC"; then
  echo 'fastfetch' >> "$ZSHRC"
fi

# Appliquer les couleurs pywal si wallpaper trouvé
if [ -f "$WALLPAPER" ]; then
  echo "🎨 Application du thème pywal basé sur : $WALLPAPER"
  wal -i "$WALLPAPER"
else
  echo "⚠️  Wallpaper non trouvé : $WALLPAPER — pywal non appliqué"
fi

# Vérifie que 'include' est présent dans kitty.conf
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
if [ -f "$KITTY_CONF" ] && ! grep -q "include ~/.cache/wal/colors-kitty.conf" "$KITTY_CONF"; then
  echo "📌 Ajout automatique de include ~/.cache/wal/colors-kitty.conf à kitty.conf"
  echo -e "\ninclude ~/.cache/wal/colors-kitty.conf" >> "$KITTY_CONF"
fi

echo "🎉 Configuration complète ! Redémarre le terminal pour voir le résultat."
