#!/bin/bash
set -euo pipefail -x

mkdir -p "$HOME/bin"
if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi

git clone https://github.com/git/git.git --depth=1 /tmp/git
make -C /tmp/git/contrib/diff-highlight
cp /tmp/git/contrib/diff-highlight/diff-highlight bin/
rm -rf /tmp/git

# Install k9s 0.50.4
wget https://github.com/derailed/k9s/releases/download/v0.50.4/k9s_linux_amd64.deb -O /tmp/k9s.deb
sudo dpkg -i /tmp/k9s.deb
rm -f /tmp/k9s.deb

# Install krew
set -x; cd "$(mktemp -d)"
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
KREW="krew-${OS}_${ARCH}"
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
tar zxvf "${KREW}.tar.gz"
./"${KREW}" install krew

# Copy dotfiles
cp bashrc ~/.bashrc
source "$HOME/.bashrc"
cp tool-versions ~/.tool-versions
cp vimrc ~/.vimrc

