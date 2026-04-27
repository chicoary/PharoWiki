# PharoWiki — Roadmap

> Atualizar sempre que um item for concluído ou uma nova ideia surgir.
> Itens marcados com ✅ estão implementados e no `main`.

---

## Concluído ✅

- [x] `PWikiClassPage` — introspecção de uma classe via reflexão
- [x] `PWikiMethodSection` — encapsula um método compilado e sua AST
- [x] `PWikiMicrodownConverter` — converte links Microdown para formato Obsidian (`[[ClassName]]`)
- [x] `PWikiAnchorGenerator` — gera âncoras Markdown seguras para seletores
- [x] `PWikiDependencyExtractor` — extrai implementors, senders e referências via `SystemNavigation`
- [x] `PWikiFileWriter` — escreve `.md` no sistema de arquivos, idempotente
- [x] `PWikiGenerator` — orquestra a geração com Jobs aninhados para progresso visual
- [x] `PWikiSelectorPageBase` — classe base para páginas de navegação por seletor
- [x] `PWikiImplementorsPage` — nota `_implementors/` com quem implementa um seletor
- [x] `PWikiSendersPage` — nota `_senders/` com quem envia um seletor
- [x] Links Obsidian (`[[ClassName]]`) em herança, subclasses e `Sends:`
- [x] Blocos de código com tag `smalltalk` nos comentários de classe
- [x] Tratamento defensivo de blocos de código não fechados
- [x] Conversão de caracteres especiais em nomes de arquivo (`*` → `_asterisk_`)
- [x] Jobs aninhados com 3 níveis: imagem → pacote → classe
- [x] Geração incremental simples: `writeSelectorPage:` e `writeSenderPage:` pulam se arquivo já existe

---

## Em andamento

- [ ] **Tempo estimado restante no Job** — mostrar `~3min restantes` no `title:` durante geração longa
- [ ] **Geração em volume** — validar com pacote `Kernel` e depois imagem completa

---

## Próximos passos

- [ ] **References** — nota `_references/ClassName references.md` com quem referencia uma classe (via `usersOf:` já implementado em `PWikiDependencyExtractor`)
- [ ] **Cache de implementors** — usar `AbstractCache` para evitar chamar `SystemNavigation` repetidamente para o mesmo seletor durante geração em volume

---

## Geração incremental avançada

- [ ] **Digest do `.sources`** — calcular digest (SHA) do código-fonte de cada classe no momento da geração
- [ ] **Armazenar digests** — salvar em `digests.json` no vault
- [ ] **Regenerar só o que mudou** — comparar digests na próxima geração e pular classes inalteradas
- [ ] **Integração com `.changes`** — discutir estratégia: rastrear evolução temporal via Epicea ou só estado atual

---

## Ideias futuras

- [ ] **Índice por pacote** — gerar `index.md` para cada pacote com lista de classes
- [ ] **Índice global** — `index.md` na raiz com todos os pacotes
- [ ] **Integração com Epicea** — usar `EpMonitor` para geração incremental automática quando código muda na imagem
- [ ] **PharoWiki como contexto para a IA** — usar as páginas `.md` geradas como contexto em vez de copiar código Tonel manualmente
- [ ] **Geração via Claude Code** — explorar integração com Claude Code apontado para o vault

======
Trazido de context.md:

1. **References** — nota `_references/NomeDaClasse references.md` usando `usersOf:` já implementado
2. **Geração incremental via digest do `.sources`** — `PWikiGenerationRecord` já grava o digest; comparar com geração anterior para decidir se regenera
3. **Extensions navegáveis no lado classe** — já implementado para instância; verificar se falta algo no lado classe
4. **Índice por pacote** — gerar `index.md` para cada pacote
5. **`.changes` via Epicea** — rastrear evolução temporal
6. **`_references/`** — quem referencia cada classe