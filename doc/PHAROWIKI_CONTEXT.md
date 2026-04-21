# PharoWiki — Contexto do Projeto

> Este arquivo deve ser lido no início de cada sessão de chat no projeto PharoWiki.
> Atualizar após cada sessão que produza mudanças significativas.

---

## Visão geral

Wiki navegável gerada a partir do código-fonte do Pharo Smalltalk, inspirada na abordagem de Karpathy com Obsidian + Claude Code. O gerador usa reflexão da imagem Pharo para produzir arquivos `.md` por classe, organizados por pacote.

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

### Script de ingestão

```smalltalk
| pharoWikiPath |
pharoWikiPath := '/Users/chicoary/Documents/Obsidian Vaults/CODE Vault/1 - Projetos/1 - In progress/PharoWiki/Anexos/PharoWiki'.

Metacello new
    baseline: 'PharoWiki';
    repository: 'tonel://', pharoWikiPath, '/src';
    load.
```

### Script de testes

```smalltalk
| result suite |
suite := TestSuite new.
suite addTest: PWikiClassPageTest suite.
suite addTest: PWikiMethodSectionTest suite.
suite addTest: PWikiMicrodownConverterTest suite.
suite addTest: PWikiAnchorGeneratorTest suite.
suite addTest: PWikiDependencyExtractorTest suite.
suite addTest: PWikiFileWriterTest suite.
suite addTest: PWikiGeneratorTest suite.
result := suite run.

Transcript
    show: result passed size printString, ' passaram'; cr;
    show: result failures size printString, ' falharam'; cr;
    show: result errors size printString, ' erros'; cr.
```

---

## Estrutura do repositório

```
PharoWiki/
├── .gitignore
├── README.md
├── load-pharowiki.st
└── src/
    ├── BaselineOfPharoWiki/
    │   ├── package.st
    │   └── BaselineOfPharoWiki.class.st
    └── PharoWiki/
        ├── package.st
        ├── PWikiClassPage.class.st          (tag: Core)
        ├── PWikiMethodSection.class.st      (tag: Core)
        ├── PWikiGenerator.class.st          (tag: Core)
        ├── PWikiMicrodownConverter.class.st (tag: Extractors)
        ├── PWikiAnchorGenerator.class.st    (tag: Extractors)
        ├── PWikiDependencyExtractor.class.st(tag: Extractors)
        ├── PWikiFileWriter.class.st         (tag: Writers)
        ├── PWikiClassPageTest.class.st      (tag: Tests)
        ├── PWikiMethodSection.class.st      (tag: Tests)
        ├── PWikiMicrodownConverterTest.class.st (tag: Tests)
        ├── PWikiAnchorGeneratorTest.class.st    (tag: Tests)
        ├── PWikiDependencyExtractorTest.class.st(tag: Tests)
        ├── PWikiFileWriterTest.class.st         (tag: Tests)
        └── PWikiGeneratorTest.class.st          (tag: Tests)
```

---

## Classes implementadas

### Core

| Classe | Responsabilidade |
|--------|-----------------|
| `PWikiClassPage` | Introspecção de uma classe via reflexão da imagem |
| `PWikiMethodSection` | Encapsula um método compilado + acesso à AST |
| `PWikiGenerator` | Orquestra a geração — entry point principal |

### Extractors

| Classe | Responsabilidade |
|--------|-----------------|
| `PWikiMicrodownConverter` | Converte links Microdown → Markdown |
| `PWikiAnchorGenerator` | Gera e resolve âncoras entre páginas |
| `PWikiDependencyExtractor` | Extrai dependências via `SystemNavigation` |

### Writers

| Classe | Responsabilidade |
|--------|-----------------|
| `PWikiFileWriter` | Escreve arquivos `.md` no sistema de arquivos |

---

## Estado dos testes

**42 passando, 0 falhas, 0 erros** (última verificação: abril 2026)

---

## Decisões arquiteturais

- **Formato de saída:** um `.md` por classe, `##` por protocolo, `###` por método
- **Entrada:** reflexão da imagem Pharo — não parseia `.sources`/`.changes` diretamente
- **Links:** Microdown convertido para Markdown — `` `Point>>#x` `` → `[Point>>x](Point.md#x)`
- **Dependências:** via `SystemNavigation default allReferencesTo:` (rápido) + superclasse + traits
- **Pacotes:** `#category` no formato `#'PharoWiki-Core'` — formato Tonel do Pharo 13
- **Variáveis temporárias:** sempre declaradas no início do método (padrão Smalltalk)
- **`nl` não existe** em `WriteStream` do Pharo — usar `cr`
- **`RPackageOrganizer`** não existe no Pharo 13 — usar `PackageOrganizer`
- **`isMetaclass`** não existe no Pharo 13 — usar `isMeta`
- **`protocol`** em `CompiledMethod` retorna objeto `Protocol` — usar `protocol name`
- **`Point`** não tem subclasses no Pharo 13 — usar `Collection` para testar `hasSubclasses`

---

## Formato de saída gerado (.md)

```markdown
# NomeDaClasse
**Pacote:** `NomeDoPacote`
**Herda de:** [Superclasse](Superclasse.md)

## Comentário
(conteúdo Microdown convertido)

## accessing

### x
```smalltalk
x
    ^ x
```

## arithmetic
...
```

---

## Próximos passos

1. **Gerar primeiras páginas wiki reais** — experimentar com `Point` ou pacote `Kernel`
2. **Verificar saída gerada** — abrir os `.md` no Obsidian e avaliar qualidade
3. **Refinar o renderizador** — melhorar `PWikiGenerator>>renderPage:` conforme necessário
4. **Geração incremental via Epicea** — usar `EpMonitor` para atualizar só o que mudou
5. **Índice por pacote** — gerar `index.md` para cada pacote

---

## Convenções Git

Commits seguem o padrão:
- `Add NomeClasse` — nova classe
- `Fix NomeClasse - descrição` — correção
- `All N tests passing` — marco de testes

---

## Notas técnicas Pharo 13

- `aMethod protocol name` — retorna o nome do protocolo como String
- `aMethod methodClass isMeta` — verifica se é método de classe
- `SystemNavigation default allReferencesTo: aClass binding` — quem referencia a classe
- `PackageOrganizer default packageNamed: name ifAbsent: [...]` — acesso a pacotes
- `FileSystem memory root` — sistema de arquivos em memória para testes
- `aDirectory / 'subdir' / 'file.md'` — navegação de paths
- Tonel: `#name : #NomeDaClasse` (símbolo), `#category : #'Pacote-Tag'`
