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
- [x] Extensions no lado classe — verificado com `Boolean`; renderização completa (código inline, `Sends:`, `Senders`)
- [x] **Cache de implementors e senders** — `LRUCache` (maximumWeight: 2000) em `PWikiGenerator` para `implementorsOf:` e `sendersOf:`, evitando varreduras repetidas via `SystemNavigation` durante geração em volume; tamanho calibrado via benchmark amostral (`bench.script.st`)

---

## Próximos passos

- [ ] **Validação em volume** — gerar pacote `Kernel` e depois imagem completa; avaliar qualidade da saída

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
- [ ] **References via Dataview** — o plugin Dataview do Obsidian expõe backlinks nativos via query `LIST FROM [[ClassName]]`, suprindo a necessidade de references sem geração pelo `PWikiGenerator`. Não requer código Pharo; o vault já contém os dados. Explorar queries analíticas úteis para navegação por dependências e análise de impacto (ex: filtrar por pasta para excluir `_implementors` e `_senders` do resultado).
- [ ] **Índice de classes** — nota `_index.md` com lista alfabética de todas as classes do vault, gerada pelo `PWikiGenerator`
- [ ] **Queries Dataview para navegação** — notas especiais com queries dinâmicas: classes por pacote, classes mais referenciadas, cruzamento senders/implementors; explorar antes de investir em código de geração
- [ ] **Documentar configuração do Obsidian** — ao usar o vault PharoWiki, desativar "Enable Inline Queries" nas configurações do plugin DataView; código Smalltalk com seletores começando com `=` (como `==`) conflita com o parser de inline queries do DataView no Live Preview
