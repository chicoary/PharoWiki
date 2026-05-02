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
- [x] `PWikiGenerator` — superclasse abstrata; orquestra a geração com Jobs aninhados para progresso visual; scripts no class side
- [x] `PWikiGenerationRecord` — grava `_generation.ston` e `_generation.md`; persiste digest por classe para geração incremental
- [x] `PWikiProgressEstimator` — estima tempo restante; mantém `LastRatePerClass` como variável de classe
- [x] `PWikiSelectorPageBase` — classe base para páginas de navegação por seletor
- [x] `PWikiImplementorsPage` — nota `_implementors/` com quem implementa um seletor
- [x] `PWikiSendersPage` — nota `_senders/` com quem envia um seletor
- [x] `PWikiSourcesGenerator` — subclasse de `PWikiGenerator`; gera wiki das classes do `.sources` via Epicea
- [x] `PWikiChangesGenerator` — subclasse de `PWikiGenerator`; gera wiki das classes do `.changes` via Epicea
- [x] Links Obsidian (`[[ClassName]]`) em herança, subclasses e `Sends:`
- [x] Blocos de código com tag `smalltalk` nos comentários de classe
- [x] Tratamento defensivo de blocos de código não fechados
- [x] Conversão de caracteres especiais em nomes de arquivo (`*` → `_asterisk_`)
- [x] Jobs aninhados com 3 níveis: imagem → pacote → classe
- [x] Geração incremental simples: `writeSelectorPage:` e `writeSenderPage:` pulam se arquivo já existe
- [x] Extensions navegáveis no lado instância com código, `Sends:` e `Senders`
- [x] Extensions no lado classe — verificado com `Boolean`; renderização completa (código inline, `Sends:`, `Senders`)
- [x] **Cache de implementors e senders** — `LRUCache` (maximumWeight: 2000) em `PWikiGenerator`; tamanho calibrado via `cacheBenchmark`
- [x] **Validação em volume** — geração do pacote `Kernel` e da imagem completa (10.657 classes); qualidade da saída validada
- [x] **Geração incremental por classe** — `PWikiGenerationRecord` persiste digest por classe; `PWikiGenerator` pula classes não modificadas; digest de duração corrigido com `truncated`
- [x] **Scripts no class side** — todos os scripts operacionais em `PWikiGenerator class` com `<script>`; instance side espelha para conveniência
- [x] **Duas wikis separadas** — `wiki/sources/` e `wiki/changes/`; separação por Epicea; `generateWikis` gera as duas em passagem única com geração incremental; 4 minutos na segunda passagem contra ~2h na primeira

---

## Próximos passos

- [ ] **Fazer merge do branch `feature/generate-wikis` para `main`**
- [ ] **Digest do `.sources` como gatilho** — comparar digest gravado em `_generation.ston` com o digest atual; regenerar wiki de base apenas se diferir

---

## Duas wikis para apoio à IA

A IA precisa de duas camadas de contexto para apoiar codificação efetiva num projeto Pharo:

**Wiki do `.sources`** — gerada a partir do `.sources` via reflexão da imagem. Representa o Pharo "de fábrica". Regenerada apenas quando o digest do `.sources` muda. Estável, raramente muda. Implementada via `PWikiSourcesGenerator`.

**Wiki do `.changes`** — gerada via Epicea (`EpMonitor`), capturando as classes adicionadas ao projeto naquela imagem. Atualizada sempre que `generateWikis` é executado. Evolui continuamente junto com o código do projeto. Implementada via `PWikiChangesGenerator`.

A IA consulta as duas juntas: a wiki do `.sources` para entender o ambiente Pharo, e a wiki do `.changes` para entender o que está sendo construído.

### Itens a implementar

- [ ] **Digest do `.sources` como gatilho** — comparar digest gravado em `_generation.ston` com o digest atual; regenerar wiki do `.sources` apenas se diferir
- [x] **Regenerar só o que mudou** — salvar digests por classe e pular as inalteradas na próxima geração
- [ ] **Wiki do `.changes` com histórico via Epicea** — além de listar as classes atuais, capturar histórico de modificações de métodos (`EpMethodModification`) com timestamp e contexto

---

## Ideias futuras

- [ ] Pacotes carregados podem ser marcados como "intocáveis" apesar de estarem na parte associada ao .changes
- [ ] **Índice por pacote** — gerar `index.md` para cada pacote com lista de classes
- [ ] **Índice global** — `index.md` na raiz com todos os pacotes
- [ ] **PharoWiki como contexto para a IA** — usar as páginas `.md` geradas como contexto em vez de copiar código Tonel manualmente
- [ ] **Integração com Claude Code** — explorar Claude Code apontado para o vault gerado
- [ ] **References via Dataview** — o plugin Dataview do Obsidian expõe backlinks nativos via query `LIST FROM [[ClassName]]`, suprindo a necessidade de references sem geração pelo `PWikiGenerator`. Não requer código Pharo; o vault já contém os dados. Explorar queries analíticas úteis para navegação por dependências e análise de impacto (ex: filtrar por pasta para excluir `_implementors` e `_senders` do resultado).
- [ ] **Índice de classes** — nota `_index.md` com lista alfabética de todas as classes do vault, gerada pelo `PWikiGenerator`
- [ ] **Queries Dataview para navegação** — notas especiais com queries dinâmicas: classes por pacote, classes mais referenciadas, cruzamento senders/implementors; explorar antes de investir em código de geração
- [ ] **Documentar configuração do Obsidian** — ao usar o vault PharoWiki, desativar "Enable Inline Queries" nas configurações do plugin DataView; código Smalltalk com seletores começando com `=` (como `==`) conflita com o parser de inline queries do DataView no Live Preview
