# PharoWiki — Contexto do Projeto

> Este arquivo deve ser lido no início de cada sessão de chat no projeto PharoWiki.
> Atualizar após cada sessão que produza mudanças significativas.

---

## Visão geral

Wiki navegável gerada a partir do código-fonte do Pharo Smalltalk, inspirada na abordagem de Karpathy com Obsidian + Claude Code. O gerador usa reflexão da imagem Pharo para produzir arquivos `.md` por classe, organizados por pacote, com links navegáveis no formato Obsidian.

Três wikis são geradas: uma associada ao `.sources` (classes do Pharo base), uma ao `.changes` (classes do projeto), e uma ao `.changes` (bibliotecas externas). A separação entre projeto e libs é declarada em `BaselineOfPharoWiki >> projectPackageNames`.

---

## Repositório

- **GitHub:** https://github.com/chicoary/PharoWiki
- **Local:** `/Users/chicoary/Documents/Obsidian Vaults/CODE Vault/1 - Projetos/1 - In progress/PharoWiki/Anexos/PharoWiki`
- **Wiki:** `/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki`
- **Branch principal:** `main`

---

## Ambiente

- **Pharo:** 13 (última versão estável)
- **Hardware:** Apple M4, macOS Sequoia 15.5
- **Ingestão:** `tonel://` via Metacello no Playground
- **Scripts:** métodos `<script>` no class side de `PWikiGenerator`; acionáveis também pelo instance side via pragma `<script: 'self nomeDoScript'>`

---

## Estrutura do repositório

```
PharoWiki/
├── .gitignore
├── README.md
├── CONVENTIONS.md
├── CONTEXT.md
├── REMINDERS.md
├── bench.script.st
└── src/
    ├── BaselineOfPharoWiki/
    │   ├── package.st
    │   └── BaselineOfPharoWiki.class.st
    └── PharoWiki/
        ├── package.st
        ├── PWikiClassPage.class.st              (tag: Core)
        ├── PWikiMethodSection.class.st          (tag: Core)
        ├── PWikiGenerator.class.st              (tag: Core)
        ├── PWikiGenerationRecord.class.st       (tag: Core)
        ├── PWikiProgressEstimator.class.st      (tag: Core)
        ├── PWikiSelectorPageBase.class.st       (tag: Core)
        ├── PWikiImplementorsPage.class.st       (tag: Core)
        ├── PWikiSendersPage.class.st            (tag: Core)
        ├── PWikiSourcesGenerator.class.st       (tag: Core)
        ├── PWikiChangesGenerator.class.st       (tag: Core)
        ├── PWikiGeneratorRegistry.class.st      (tag: Core)
        ├── PWikiLibsGenerator.class.st          (tag: Core)
        ├── PWikiMicrodownConverter.class.st     (tag: Extractors)
        ├── PWikiAnchorGenerator.class.st        (tag: Extractors)
        ├── PWikiDependencyExtractor.class.st    (tag: Extractors)
        ├── PWikiFileWriter.class.st             (tag: Writers)
        ├── PWikiClassPageTest.class.st          (tag: Tests)
        ├── PWikiMethodSectionTest.class.st      (tag: Tests)
        ├── PWikiMicrodownConverterTest.class.st (tag: Tests)
        ├── PWikiAnchorGeneratorTest.class.st    (tag: Tests)
        ├── PWikiDependencyExtractorTest.class.st(tag: Tests)
        ├── PWikiFileWriterTest.class.st         (tag: Tests)
        ├── PWikiGeneratorTest.class.st          (tag: Tests)
        ├── PWikiGeneratorRegistryTest.class.st  (tag: Tests)
        ├── PWikiLibsGeneratorTest.class.st      (tag: Tests)
        ├── PWikiImplementorsPageTest.class.st   (tag: Tests)
        ├── PWikiSendersPageTest.class.st        (tag: Tests)
        └── PWikiProgressEstimatorTest.class.st  (tag: Tests)
```

---

## Estrutura do vault Obsidian

```
PharoWiki vault/wiki/
├── sources/    ← PWikiSourcesGenerator — classes do .sources (Pharo base)
│   ├── _generation.ston
│   ├── _generation.md
│   ├── _implementors/
│   ├── _senders/
│   └── (pacotes e classes)
├── changes/    ← PWikiChangesGenerator — classes do projeto (declaradas na baseline)
│   ├── _generation.ston
│   ├── _generation.md
│   ├── _implementors/
│   ├── _senders/
│   └── (pacotes e classes)
└── libs/       ← PWikiLibsGenerator — bibliotecas externas carregadas via .changes
    ├── _generation.ston
    ├── _generation.md
    ├── _implementors/
    ├── _senders/
    └── (pacotes e classes)
```

---

## Classes implementadas

### Core

| Classe | Responsabilidade |
|--------|-----------------|
| `PWikiClassPage` | Introspecção de uma classe via reflexão da imagem — instância e classe |
| `PWikiMethodSection` | Encapsula um método compilado + acesso à AST |
| `PWikiGenerator` | Superclasse abstrata — orquestra a geração; cache LRU; scripts no class side |
| `PWikiGenerationRecord` | Grava `_generation.ston` e `_generation.md`; persiste digest por classe para geração incremental |
| `PWikiProgressEstimator` | Estima tempo restante durante geração; mantém `LastRatePerClass` como variável de classe |
| `PWikiSelectorPageBase` | Classe abstrata — base para páginas de seletor |
| `PWikiImplementorsPage` | Gera nota `_implementors/` com quem implementa um seletor |
| `PWikiSendersPage` | Gera nota `_senders/` com quem envia um seletor |
| `PWikiSourcesGenerator` | Subclasse de `PWikiGenerator` — gera wiki das classes do `.sources` |
| `PWikiChangesGenerator` | Subclasse de `PWikiGenerator` — gera wiki das classes do projeto via Epicea |
| `PWikiGeneratorRegistry` | Decide qual gerador usar para cada classe — sources, changes ou libs |
| `PWikiLibsGenerator` | Subclasse de `PWikiChangesGenerator` — gera wiki das bibliotecas externas em `wiki/libs/` |

### Extractors

| Classe | Responsabilidade |
|--------|-----------------|
| `PWikiMicrodownConverter` | Converte links Microdown → formato Obsidian |
| `PWikiAnchorGenerator` | Gera e resolve âncoras entre páginas |
| `PWikiDependencyExtractor` | `implementorsOf:`, `sendersOf:`, `usersOf:`, `dependenciesOf:` |

### Writers

| Classe | Responsabilidade |
|--------|-----------------|
| `PWikiFileWriter` | Escreve `.md` no sistema de arquivos — `writeClass:package:content:`, `writeSelectorPage:`, `writeSenderPage:` |

---

## Scripts disponíveis

Todos os scripts estão no class side de `PWikiGenerator` com `<script>` e são acionáveis também pelo instance side.

| Script | Descrição |
|--------|-----------|
| `reload` | Recarrega o pacote via Metacello |
| `reloadAndTest` | Recarrega o pacote e roda todos os testes em sequência |
| `runAllTests` | Roda a suíte completa de testes |
| `generateWikis` | Gera as três wikis (sources, changes e libs) em passagem única |
| `generateSourcesWiki` | Gera só a wiki do `.sources` |
| `generateChangesWiki` | Gera só a wiki do `.changes` |
| `generateClass` | Gera a página de uma classe (detecta a wiki automaticamente) |
| `generatePackage` | Gera as páginas de um pacote (detecta a wiki automaticamente) |
| `sourceCodeOf` | Exibe o Tonel de `PWikiGenerator` no Transcript |
| `saveClassTonel` | Exporta uma classe para `.class.st` |
| `cacheBenchmark` | Benchmark do LRUCache com 7 tamanhos |

---

## Estado dos testes

**71 passando, 0 falhas, 0 erros, 6 pulados** (última verificação: maio 2026)

---

## Formato de saída gerado (.md)

```markdown
# NomeDaClasse
**Package:** `NomeDoPacote`
**Inherits from:** [[Superclasse]]
**Subclasses:** [[Sub1]], [[Sub2]]

## Comment
(conteúdo Microdown convertido para Markdown)

## accessing

### x
**Sends:** [[y implementors|y]]
[[x senders|Senders]]
```smalltalk
x
    ^ x
```

## Class methods

### instance creation
#### new:
**Sends:** ...
[[new_ senders|Senders]]
```smalltalk
new: anInteger
    ...
```

### Extensions
#### *PacoteExtensor
##### metodoDeClasse
...

## Extensions

### *NomeDoPacoteExtensor
#### metodo
...
```

### Notas de seletor

- `_implementors/ifTrue_ implementors.md` — lista quem implementa `#ifTrue:`
- `_senders/ifTrue_ senders.md` — lista quem envia `#ifTrue:`
- Caracteres especiais em seletores convertidos: `:` → `_`, `*` → `_asterisk_`, etc.
- Links usam formato Obsidian: `[[ClassName#selector|ClassName>>selector]]`
- Métodos de classe linkam para `ClassName.md` (não `ClassName class.md`) via `instanceSide name`

---

## Decisões arquiteturais

- **Três wikis:** `sources/` para classes do `.sources` (Pharo base), `changes/` para classes do projeto, `libs/` para bibliotecas externas carregadas via `.changes`; separação projeto/libs declarada em `BaselineOfPharoWiki >> projectPackageNames`
- **Fronteira projeto vs libs:** código desenvolvido ativamente nesta imagem vai para `changes/`; dependências carregadas via Metacello vão para `libs/`. A linha divisória é o ato de carregar — se você escreveu o código, é do projeto; se o Metacello trouxe como dependência, é lib.
- **`BaselineOfPharoWiki >> projectPackageNames`** — método com papel duplo: (1) lista pacotes para carregamento Metacello; (2) declara fronteira para o `PWikiChangesGenerator`. Pacotes listados aqui vão para `changes/`, os demais para `libs/`. Ao criar um novo pacote do projeto, adicionar aqui antes de recarregar.
- **`PWikiChangesGenerator >> projectPackageNames`** — delega para `BaselineOfPharoWiki new projectPackageNames`
- **`PWikiChangesGenerator >> isProjectPackage:`** — predicado que separa projeto de libs
- **`PWikiLibsGenerator >> classesToGenerate`** — mesmo source do Epicea que `PWikiChangesGenerator`, mas usa `reject:` em vez de `select:`
- **`PWikiGeneratorRegistry`** — encapsula a decisão de qual gerador usar; `generatorFor:` consulta Epicea e depois `isProjectPackage:` para decidir entre `changesGen` e `libsGen`
- **`PWikiGenerator class >> prepareDirectoriesFor:`** — prepara `_implementors` e `_senders` para coleção de geradores
- **`PWikiGenerator class >> writeRecordsFor:classCount:startTime:`** — grava `_generation` para coleção de geradores
- **`generatorFor:sourcesGen:changesGen:`** — deprecated; substituído pelo `PWikiGeneratorRegistry`
- **Trigger Epicea não distingue projeto de libs** — `e tags at: #trigger` retorna `EpMonticelloVersionsLoad` tanto para classes do projeto (carregadas via reload) quanto para bibliotecas externas. Não é utilizável como heurística automática de separação — investigado e descartado.
- **`PWikiGenerator >> classesToGenerate`** — abstrato (`subclassResponsibility`); subclasses definem quais classes gerar
- **`PWikiSourcesGenerator >> classesToGenerate`** — rejeita classes registradas no Epicea; retorna classes do `.sources`
- **`PWikiChangesGenerator >> classesToGenerate`** — retorna classes registradas no Epicea como `EpClassAddition` que pertencem ao projeto
- **`EpClassAddition >> classAdded realClass`** — retorna a classe viva a partir da definição Ring
- **`generateWikis`** — itera `Smalltalk allClasses`, delega cada classe ao registry; grava digests incrementalmente; uma passagem só para as três wikis
- **`generatorClassFor:`** — retorna a classe do gerador para uso nos scripts `generateClass` e `generatePackage`; consulta `PWikiChangesGenerator new isProjectPackage:` para distinguir changes de libs
- **`writeGenerationRecord:startTime:`** — método de instância exposto para uso pelo `generateWikis`
- **`generationRecord`** — accessor público em `PWikiGenerator`
- **Geração incremental:** `PWikiGenerationRecord` persiste digest por classe; `generateWikis` pula classes não modificadas; `_generation.ston` gravado em cada pasta
- **Formato de saída:** um `.md` por classe, `##` por protocolo de instância, `## Class methods` para lado classe, `## Extensions` para extensões de instância
- **Entrada:** reflexão da imagem Pharo — não parseia `.sources`/`.changes` diretamente
- **Links:** formato Obsidian `[[NomeDaNota]]` e `[[NomeDaNota|display]]`
- **Seletores especiais:** `PWikiSelectorPageBase class >> selectorToFileName:` converte caracteres especiais
- **`_implementors/`** e **`_senders/`** — apagados e recriados no início de geração em volume
- **`writeSelectorPage:`** e **`writeSenderPage:`** — skip-if-exists (idempotente)
- **`writeClass:package:content:`** — sempre sobrescreve com `ensureDelete`
- **Progresso em `generateWikis`:** uma barra única com `N / Total (%) ~Xh Ym Zs remaining`
- **Progresso em `generateForImage`:** três níveis — outer (título fixo), pacote (% e tempo restante), classe
- **`PWikiProgressEstimator`** — fallback para `LastRatePerClass` quando estimativa ultrapassa 24h
- **`asJob`** — `min:` e `max:` em cascata no `asJob`, não dentro do bloco
- **Cache de implementors e senders:** `LRUCache` (maximumWeight: 2000) em `PWikiGenerator`; tamanho calibrado via `cacheBenchmark`
- **Scripts:** no class side de `PWikiGenerator` com `<script>`; instance side espelha com `<script: 'self nomeDoScript'>` e corpo vazio
- **Metacello não remove métodos** — ao renomear/remover, apagar manualmente no browser antes de recarregar
- **`nl` não existe** em `WriteStream` — usar `cr`
- **`PackageOrganizer`** não `RPackageOrganizer`
- **`isMeta`** não `isMetaclass`
- **`protocol name`** para obter nome do protocolo de um `CompiledMethod`
- **`Point`** não tem subclasses no Pharo 13 — usar `Collection` para testar `hasSubclasses`
- **DataView "Enable Inline Queries"** — desativar nas configurações do plugin no Obsidian; seletores Smalltalk começando com `=` (como `==`) conflitam com o parser de inline queries do DataView no Live Preview
- **`PWikiGenerationRecord >> computeDigest`** — usar `upToEnd` em vez de `contentsOfEntireFile`; `binaryReadStream` retorna `ZnBufferedReadStream` que não entende `contentsOfEntireFile`
- **`(DateAndTime now - aDateAndTime) totalSeconds truncated`** — `totalSeconds` retorna `Fraction` no Pharo 13; usar `truncated`

---

## Roadmap

Ver o arquivo ROADMAP.md.

---

## Notas técnicas Pharo 13

- `aMethod protocol name` — retorna o nome do protocolo como String
- `aMethod methodClass isMeta` — verifica se é método de classe
- `aMethod methodClass instanceSide name` — nome da classe sem `class` para links
- `SystemNavigation default allImplementorsOf: aSelector` — quem implementa
- `SystemNavigation default allSendersOf: aSelector` — quem envia
- `SystemNavigation default allReferencesTo: aClass binding` — quem referencia a classe
- `PackageOrganizer default packageNamed: name ifAbsent: [...]` — acesso a pacotes
- `FileSystem memory root` — sistema de arquivos em memória para testes
- `aDirectory / 'subdir' / 'file.md'` — navegação de paths
- `TonelWriter sourceCodeOf: aClass` — serializa uma classe completa em Tonel como String
- `SHA256 hashMessage: bytes` — digest do `.sources`
- `STON toString: aDictionary` — serialização para `.ston`
- `ZnBufferedReadStream` não entende `contentsOfEntireFile` — usar `upToEnd`
- `EpMonitor current log entries` — log do Epicea; entradas do tipo `EpClassAddition` identificam classes adicionadas após criação da imagem
- `e content classAdded realClass` — retorna a classe viva a partir de uma entrada `EpClassAddition`
- `(e content isKindOf: EpClassAddition)` — testa o tipo de uma entrada do Epicea
- `e tags at: #trigger` — retorna referência à entrada que disparou a adição; para classes carregadas via Metacello o trigger é `EpMonticelloVersionsLoad`; não utilizável para distinguir projeto de libs pois o reload do próprio projeto também gera `EpMonticelloVersionsLoad`
