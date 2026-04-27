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
- [x] `PWikiGenerationRecord` — grava `_generation.ston` e `_generation.md` ao final de `generateForImage`
- [x] `PWikiProgressEstimator` — estima tempo restante; mantém `LastRatePerClass` como variável de classe
- [x] `PWikiSelectorPageBase` — classe base para páginas de navegação por seletor
- [x] `PWikiImplementorsPage` — nota `_implementors/` com quem implementa um seletor
- [x] `PWikiSendersPage` — nota `_senders/` com quem envia um seletor
- [x] Links Obsidian (`[[ClassName]]`) em herança, subclasses e `Sends:`
- [x] Blocos de código com tag `smalltalk` nos comentários de classe
- [x] Tratamento defensivo de blocos de código não fechados
- [x] Conversão de caracteres especiais em nomes de arquivo (`*` → `_asterisk_`)
- [x] Jobs aninhados com 3 níveis: imagem → pacote → classe
- [x] Geração incremental simples: `writeSelectorPage:` e `writeSenderPage:` pulam se arquivo já existe
- [x] Extensions navegáveis no lado instância com código, `Sends:` e `Senders`

---

## Próximos passos

- [ ] **Validação em volume** — gerar pacote `Kernel` e depois imagem completa; avaliar qualidade da saída
- [ ] **References** — nota `_references/ClassName references.md` com quem referencia uma classe (via `usersOf:` já implementado em `PWikiDependencyExtractor`)
- [ ] **Extensions no lado classe** — verificar se a renderização de extensões no lado classe está completa (instância já OK)
- [ ] **Cache de implementors** — evitar chamar `SystemNavigation` repetidamente para o mesmo seletor durante geração em volume

---

## Geração incremental avançada

- [ ] **Digest do `.sources`** — `PWikiGenerationRecord` já grava o digest; comparar com geração anterior para decidir se regenera
- [ ] **Regenerar só o que mudou** — salvar digests por classe e pular as inalteradas na próxima geração
- [ ] **Integração com Epicea** — usar `EpMonitor` para geração incremental automática quando código muda na imagem; discutir estratégia: rastrear evolução temporal ou só estado atual

---

## Ideias futuras

- [ ] **Índice por pacote** — gerar `index.md` para cada pacote com lista de classes
- [ ] **Índice global** — `index.md` na raiz com todos os pacotes
- [ ] **PharoWiki como contexto para a IA** — usar as páginas `.md` geradas como contexto em vez de copiar código Tonel manualmente
- [ ] **Integração com Claude Code** — explorar Claude Code apontado para o vault gerado
