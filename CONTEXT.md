# PharoWiki — Contexto do Projeto

> Este arquivo deve ser lido no início de cada sessão de chat no projeto PharoWiki.
> Atualizar após cada sessão que produza mudanças significativas.

---

## Visão geral

Wiki navegável gerada a partir do código-fonte do Pharo Smalltalk, inspirada na abordagem de Karpathy com Obsidian + Claude Code. O gerador usa reflexão da imagem Pharo para produzir arquivos `.md` por classe, organizados por pacote, com links navegáveis no formato Obsidian.

---

## Repositório

- **GitHub:** https://github.com/chicoary/PharoWiki
- **Local:** `/Users/chicoary/Documents/Obsidian Vaults/CODE Vault/1 - Projetos/1 - In progress/PharoWiki/Anexos/PharoWiki`
- **Wiki:** /Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki
- **Branch principal:** `main`

---

## Ambiente

- **Pharo:** 13 (última versão estável)
- **Hardware:** Apple M4, macOS Sequoia 15.5
- **Ingestão:** `tonel://` via Metacello no Playground
- **Scripts:** ver `scripts.md` na raiz do repositório

---

## Estrutura do repositório

```
PharoWiki/
├── .gitignore
├── README.md
├── CONVENTIONS.md
├── CONTEXT.md
├── scripts.md
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
        ├── PWikiImplementorsPageTest.class.st   (tag: Tests)
        ├── PWikiSendersPageTest.class.st        (tag: Tests)
        └── PWikiProgressEstimatorTest.class.st  (tag: Tests)
```

---

## Classes implementadas

### Core

| Classe | Responsabilidade |
|--------|-----------------|
| `PWikiClassPage` | Introspecção de uma classe via reflexão da imagem — instância e classe |
| `PWikiMethodSection` | Encapsula um método compilado + acesso à AST |
| `PWikiGenerator` | Orquestra a geração — entry point principal; cache LRU de implementors e senders (maximumWeight: 2000) |
| `PWikiGenerationRecord` | Grava `_generation.ston` e `_generation.md` ao final de `generateForImage` |
| `PWikiProgressEstimator` | Estima tempo restante durante geração; mantém `LastRatePerClass` como variável de classe |
| `PWikiSelectorPageBase` | Classe abstrata — base para páginas de seletor |
| `PWikiImplementorsPage` | Gera nota `_implementors/` com quem implementa um seletor |
| `PWikiSendersPage` | Gera nota `_senders/` com quem envia um seletor |

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

## Estado dos testes

**62 passando, 0 falhas, 0 erros, 5 pulados** (última verificação: abril 2026)

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

- **Formato de saída:** um `.md` por classe, `##` por protocolo de instância, `## Class methods` para lado classe, `## Extensions` para extensões de instância
- **Entrada:** reflexão da imagem Pharo — não parseia `.sources`/`.changes` diretamente
- **Links:** formato Obsidian `[[NomeDaNota]]` e `[[NomeDaNota|display]]`
- **Seletores especiais:** `PWikiSelectorPageBase class >> selectorToFileName:` converte caracteres especiais
- **`_implementors/`** e **`_senders/`** — apagados e recriados no início de geração em volume
- **`writeSelectorPage:`** e **`writeSenderPage:`** — skip-if-exists (idempotente)
- **`writeClass:package:content:`** — sempre sobrescreve com `ensureDelete`
- **Extensions:** renderizadas inline com código, `Sends:` e `Senders` — não apenas listadas por nome
- **Progresso:** `pkgJob` mostra `NomePacote — N / Total (%)  — ~Xh Ym Zs remaining`; `classJob` mostra nome da classe; `outerJob` título fixo
- **`PWikiProgressEstimator`** — fallback para `LastRatePerClass` quando estimativa ultrapassa 24h
- **`PWikiGenerationRecord`** — gerado apenas por `generateForImage`, não por `generateForPackageNamed:`
- **`asJob`** — `min:` e `max:` em cascata no `asJob`, não dentro do bloco
- **Cache de implementors e senders:** `LRUCache` (maximumWeight: 2000) em `PWikiGenerator` — `implementorsOf:` e `sendersOf:` consultam o cache antes de delegar ao `PWikiDependencyExtractor`; evita varreduras repetidas via `SystemNavigation` durante geração em volume; tamanho calibrado via benchmark amostral (`bench.script.st`)
- **Metacello não remove métodos** — ao renomear/remover, apagar manualmente no browser antes de recarregar
- **`nl` não existe** em `WriteStream` — usar `cr`
- **`PackageOrganizer`** não `RPackageOrganizer`
- **`isMeta`** não `isMetaclass`
- **`protocol name`** para obter nome do protocolo de um `CompiledMethod`
- **`Point`** não tem subclasses no Pharo 13 — usar `Collection` para testar `hasSubclasses`

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
- `TonelWriter sourceCodeOf: NomeDaClasse` — gera código Tonel de uma classe para compartilhar com a IA
- `SHA256 hashMessage: bytes` — digest do `.sources`
- `STON toString: aDictionary` — serialização para `.ston`
