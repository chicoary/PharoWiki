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
├── PHAROWIKI_CONTEXT.md
├── scripts.md
└── src/
    ├── BaselineOfPharoWiki/
    │   ├── package.st
    │   └── BaselineOfPharoWiki.class.st
    └── PharoWiki/
        ├── package.st
        ├── PWikiClassPage.class.st              (tag: Core)
        ├── PWikiMethodSection.class.st          (tag: Core)
        ├── PWikiGenerator.class.st              (tag: Core)
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
        └── PWikiSendersPageTest.class.st        (tag: Tests)
```

---

## Classes implementadas

### Core

| Classe | Responsabilidade |
|--------|-----------------|
| `PWikiClassPage` | Introspecção de uma classe via reflexão da imagem |
| `PWikiMethodSection` | Encapsula um método compilado + acesso à AST |
| `PWikiGenerator` | Orquestra a geração — entry point principal |
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

**60 passando, 0 falhas, 0 erros** (última verificação: abril 2026)

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
**Sends:** [[y implementors|y]], [[_at_ implementors|@]]
[[x senders|Senders]]
```smalltalk
x
    ^ x
```

## Extensions
- `*NomeDoPacoteExtensor`
```

### Notas de seletor

- `_implementors/ifTrue_ implementors.md` — lista quem implementa `#ifTrue:`
- `_senders/ifTrue_ senders.md` — lista quem envia `#ifTrue:`
- Caracteres especiais em seletores convertidos: `:` → `_`, `*` → `_asterisk_`, etc.
- Links usam formato Obsidian: `[[ClassName#selector|ClassName>>selector]]`

---

## Decisões arquiteturais

- **Formato de saída:** um `.md` por classe, `##` por protocolo, `###` por método
- **Entrada:** reflexão da imagem Pharo — não parseia `.sources`/`.changes` diretamente
- **Links:** formato Obsidian `[[NomeDaNota]]` e `[[NomeDaNota|display]]`
- **Seletores especiais:** `PWikiSelectorPageBase class >> selectorToFileName:` converte caracteres especiais
- **`_implementors/`** e **`_senders/`** — apagados e recriados no início de geração em volume (`generateForImage`, `generateForPackageNamed:`)
- **`writeSelectorPage:`** e **`writeSenderPage:`** — skip-if-exists (idempotente)
- **`writeClass:package:content:`** — sempre sobrescreve com `ensureDelete`
- **Metacello não remove métodos** — ao renomear/remover, apagar manualmente no browser antes de recarregar
- **`nl` não existe** em `WriteStream` — usar `cr`
- **`PackageOrganizer`** não `RPackageOrganizer`
- **`isMeta`** não `isMetaclass`
- **`protocol name`** para obter nome do protocolo de um `CompiledMethod`
- **`Point`** não tem subclasses no Pharo 13 — usar `Collection` para testar `hasSubclasses`
- **`allSendersOf:`** e **`allImplementorsOf:`** via `SystemNavigation default`

---

## Roadmap

1. **Tempo restante no Job** — estimar e mostrar no `title:` durante geração longa
2. **References** — nota `_references/NomeDaClasse references.md` usando `usersOf:` já implementado
3. **Geração incremental via digest do `.sources`** — calcular SHA do arquivo `.sources` inteiro; se igual ao digest anterior, pular a geração; se diferente, regenerar tudo
4. **`.changes`** — a discutir: rastrear evolução temporal via Epicea ou ignorar por ora
5. **Gerar pacote `PharoWiki`** — o wiki se auto-documenta
6. **Gerar pacote maior** (ex: `Kernel`) — validação em volume
7. **Gerar imagem completa** — 3000+ classes
8. **Índice por pacote** — gerar `index.md` para cada pacote

---

## Notas técnicas Pharo 13

- `aMethod protocol name` — retorna o nome do protocolo como String
- `aMethod methodClass isMeta` — verifica se é método de classe
- `SystemNavigation default allImplementorsOf: aSelector` — quem implementa
- `SystemNavigation default allSendersOf: aSelector` — quem envia
- `SystemNavigation default allReferencesTo: aClass binding` — quem referencia a classe
- `PackageOrganizer default packageNamed: name ifAbsent: [...]` — acesso a pacotes
- `FileSystem memory root` — sistema de arquivos em memória para testes
- `aDirectory / 'subdir' / 'file.md'` — navegação de paths
- `TonelWriter sourceCodeOf: NomeDaClasse` — gera código Tonel de uma classe para compartilhar com a IA
