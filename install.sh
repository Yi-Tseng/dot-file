#!/bin/bash
set -euo pipefail -x

mkdir -p "$HOME/bin"
if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi

rm -rf /tmp/git
git clone https://github.com/git/git.git --depth=1 /tmp/git
make -C /tmp/git/contrib/diff-highlight
cp /tmp/git/contrib/diff-highlight/diff-highlight "$HOME/bin/diff-highlight"
chmod +x "$HOME/bin/diff-highlight"
rm -rf /tmp/git

# Install k9s and kubectl
brew install derailed/k9s/k9s
brew install kubectl

# Install krew
pushd "$(mktemp -d)"
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
KREW="krew-${OS}_${ARCH}"
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
tar zxvf "${KREW}.tar.gz"
./"${KREW}" install krew
popd

# Copy dotfiles
cp bashrc ~/.bashrc
source "$HOME/.bashrc"
cp tool-versions ~/.tool-versions
cp vimrc ~/.vimrc
cp gitconfig ~/.gitconfig

mkdir -p /$HOME/.kube/configs
touch /$HOME/.kube/config

kubectl krew install ctx
kubectl krew install ns
kubectl krew install konfig

