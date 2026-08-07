# Seed the live user's home from /etc/skel on first login so packaged defaults are available.
if [[ ! -e ~/.nitroos-skel-seeded ]]; then
    cp -an /etc/skel/. ~/
    touch ~/.nitroos-skel-seeded
fi

if [[ -r /etc/skel/.zshrc ]]; then
    source /etc/skel/.zshrc
fi