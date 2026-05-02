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
- [x] **Validação em volume** — geração do pacote `Kernel` e da imagem completa (10.655 classes, 112.665 arquivos, 128 MB); qualidade da saída validada
- [x] **Geração incremental por classe** — `PWikiGenerationRecord` persiste digest por classe via `TonelWriter sourceCodeOf:`; `PWikiGenerator` pula classes não modificadas na segunda passagem; digest de duração corrigido com `truncated`

---

## Próximos passos

- [ ] **Duas wikis para apoio à IA** — ver seção abaixo

---

## Duas wikis para apoio à IA

A IA precisa de duas camadas de contexto para apoiar codificação efetiva num projeto Pharo:

**Wiki de base** — gerada a partir do `.sources` via reflexão da imagem. Representa o Pharo "de fábrica". Regenerada apenas quando o digest do `.sources` muda — ou seja, quando se atualiza a versão do Pharo. Estável, raramente muda. Já implementada.

**Wiki de projeto** — gerada via Epicea (`EpMonitor`), capturando as mudanças feitas durante o desenvolvimento do projeto naquela imagem. Atualizada periodicamente ou por evento (ex: ao salvar um método, ao fazer um commit). Evolui continuamente junto com o código do projeto. A ser implementada.

A IA consulta as duas juntas: a wiki de base para entender o ambiente Pharo, e a wiki de projeto para entender o que está sendo construído e como evoluiu.

### Itens a implementar

- [ ] **Digest do `.sources` como gatilho** — comparar digest gravado em `_generation.ston` com o digest atual; regenerar wiki de base apenas se diferir
- [x] **Regenerar só o que mudou** — salvar digests por classe e pular as inalteradas na próxima geração da wiki de base
- [ ] **Wiki de projeto via Epicea** — usar `EpMonitor` para capturar mudanças na imagem durante o desenvolvimento; gerar páginas `.md` por classe modificada com histórico de alterações (diff de método, timestamp, contexto)
- [ ] **Estratégia de atualização da wiki de projeto** — definir gatilho: periódico, por evento (método salvo), ou manual; discutir granularidade do histórico registrado

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
