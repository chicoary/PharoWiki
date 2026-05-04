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
- [x] `PWikiSourcesGenerator` — subclasse de `PWikiGenerator`; gera wiki das classes do `.sources`
- [x] `PWikiChangesGenerator` — subclasse de `PWikiGenerator`; gera wiki das classes do projeto via Epicea; separa projeto de libs via `BaselineOfPharoWiki >> projectPackageNames`
- [x] `PWikiGeneratorRegistry` — encapsula a decisão de qual gerador usar para cada classe
- [x] `PWikiLibsGenerator` — subclasse de `PWikiChangesGenerator`; gera wiki das bibliotecas externas em `wiki/libs/`
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
- [x] **Três wikis separadas** — `wiki/sources/`, `wiki/changes/` e `wiki/libs/`; separação por Epicea e baseline; `generateWikis` gera as três em passagem única com geração incremental
- [x] **Merge do branch `feature/generate-wikis` para `main`**
- [x] **Digest do `.sources` como gatilho** — `generateWikis:` compara o digest gravado em `_generation.ston` com o digest atual do `.sources`; se forem iguais, pula toda a geração do sources
- [x] **Refactoring `PWikiGeneratorRegistry`** — extrai lógica de decisão de gerador do `generateWikis:`; `prepareDirectoriesFor:` e `writeRecordsFor:` extraídos como métodos de classe

---

## Próximos passos

- [ ] Escrever o `CLAUDE.md` — instruções para o Claude Code sobre as fronteiras das três wikis
- [ ] Documentar o fluxo completo de desenvolvimento assistido por IA em `CONVENTIONS.md`

---

## Visão: PharoWiki como infraestrutura de desenvolvimento assistido por IA

O PharoWiki está emergindo como mais do que um gerador de wiki — é a infraestrutura de um **processo de desenvolvimento Pharo assistido por IA** com fluxo e disciplina definidos.

### As três wikis como fronteiras de contexto

| Wiki | Fonte | Papel para a IA |
|------|-------|-----------------|
| `wiki/sources/` | `.sources` (Pharo de fábrica) | Contexto — só leitura |
| `wiki/libs/` | `.changes` — bibliotecas externas | Contexto — só leitura |
| `wiki/changes/` | `.changes` — código do projeto | Contexto e edição |

O `CLAUDE.md` instrui o Claude Code sobre essas fronteiras: consulte as três wikis, mas só modifique código cujas classes estão em `changes/`.

### A baseline como declaração de intenção

`BaselineOfPharoWiki >> projectPackageNames` é a fonte de verdade sobre o que é "meu projeto". Pacotes listados aqui vão para `changes/`; os demais vão para `libs/`. Criar um pacote novo sem atualizar este método faz ele aparecer em `libs/` na próxima geração — feedback imediato de que algo está fora do fluxo.

**Regra:** código desenvolvido ativamente → `changes/`; dependência carregada via Metacello → `libs/`.

### Tensão com a cultura Smalltalk

O fluxo Karpathy exige editar arquivos externos, commitar e recarregar — o que contrasta com a cultura Smalltalk de desenvolvimento na imagem viva. A adoção desse processo implica reconhecer que cada ferramenta tem seu domínio:

- **Debug e exploração** → IDE Pharo, insubstituível
- **Edição de código com IA** → editor externo + Git (VSCode, Sublime, etc.)
- **Navegação de dependências e contexto** → wiki no Obsidian

Não é abandonar o IDE — é uma extensão da concessão que a comunidade já fez ao adotar o Iceberg.

### Alternativa para quem não quer sair do IDE

O Iceberg já mostra diffs e status Git dentro da imagem. Para desenvolvedores que preferem permanecer no IDE, o fluxo seria: editar no browser → salvar via Iceberg → commitar de lá. O Claude Code ficaria como alternativa para quem prefere o fluxo externo. O debug e a exploração permanecem sempre no IDE, que é insubstituível para isso.

---

## Três wikis para apoio à IA

A IA precisa de três camadas de contexto para apoiar codificação efetiva num projeto Pharo:

**Wiki do `.sources`** — gerada a partir do `.sources` via reflexão da imagem. Representa o Pharo "de fábrica". Regenerada apenas quando o digest do `.sources` muda. Estável, raramente muda. Implementada via `PWikiSourcesGenerator`.

**Wiki do `.changes` — projeto** — gerada via Epicea (`EpMonitor`), capturando as classes do projeto declaradas em `BaselineOfPharoWiki >> projectPackageNames`. Atualizada sempre que `generateWikis` é executado. Evolui continuamente junto com o código. Implementada via `PWikiChangesGenerator`.

**Wiki do `.changes` — libs** — gerada via Epicea, capturando classes carregadas via Metacello que não pertencem ao projeto. Contexto para a IA entender as dependências, mas intocável. Implementada via `PWikiLibsGenerator`.

A IA consulta as três juntas: `sources/` para entender o ambiente Pharo, `changes/` para entender o que está sendo construído, e `libs/` para entender as dependências.

### Itens implementados

- [x] **Digest do `.sources` como gatilho** — comparar digest gravado em `_generation.ston` com o digest atual; regenerar wiki do `.sources` apenas se diferir
- [x] **Regenerar só o que mudou** — salvar digests por classe e pular as inalteradas na próxima geração
- [x] **Três wikis** — `sources/`, `changes/` e `libs/`; separação declarada na baseline

---

## Ideias futuras

- [ ] **Wiki do `.changes` com histórico via Epicea** — além de listar as classes atuais, capturar histórico de modificações de métodos (`EpMethodModification`) com timestamp e contexto
- [ ] **Índice por pacote** — gerar `index.md` para cada pacote com lista de classes
- [ ] **Índice global** — `index.md` na raiz com todos os pacotes
- [ ] **PharoWiki como contexto para a IA** — usar as páginas `.md` geradas como contexto em vez de copiar código Tonel manualmente
- [ ] **Integração com Claude Code** — explorar Claude Code apontado para o vault gerado
- [ ] **References via Dataview** — o plugin Dataview do Obsidian expõe backlinks nativos via query `LIST FROM [[ClassName]]`, suprindo a necessidade de references sem geração pelo `PWikiGenerator`. Não requer código Pharo; o vault já contém os dados. Explorar queries analíticas úteis para navegação por dependências e análise de impacto (ex: filtrar por pasta para excluir `_implementors` e `_senders` do resultado).
- [ ] **Índice de classes** — nota `_index.md` com lista alfabética de todas as classes do vault, gerada pelo `PWikiGenerator`
- [ ] **Queries Dataview para navegação** — notas especiais com queries dinâmicas: classes por pacote, classes mais referenciadas, cruzamento senders/implementors; explorar antes de investir em código de geração
- [ ] **Documentar configuração do Obsidian** — ao usar o vault PharoWiki, desativar "Enable Inline Queries" nas configurações do plugin DataView; código Smalltalk com seletores começando com `=` (como `==`) conflita com o parser de inline queries do DataView no Live Preview
