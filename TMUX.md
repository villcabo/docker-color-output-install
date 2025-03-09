# TMUX Configuration

## Instalacion

Instalacion configuration de **TMUX**

```bash
wget -q https://raw.githubusercontent.com/villcabo/docker-color-output-install/main/tmux_configuration/tmux.conf -O ~/.tmux.conf
```

Tmux Plugin Manager **TPM**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Para recargar la configuracion, debe iniciar **tmux** y teclear **ctrl + A shit I**

**En caso de que tmux ya se este ejecutando, puede utilizar este comando para recargar la configuracion**
```
tmux source ~/.tmux.conf
```

Si desea ver mas temas puede ir al siguiente link [TMUX Themes](https://github.com/jimeh/tmux-themepack)
