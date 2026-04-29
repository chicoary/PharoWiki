<img width="1032" height="820" alt="Screenshot 2026-04-28 at 18 14 37" src="https://github.com/user-attachments/assets/23b70732-6fba-4a25-a144-7dca9b2969cf" />

# PharoWiki

Wiki navegável gerada a partir do código-fonte do Pharo Smalltalk.
Inspirado na abordagem de Karpathy com Obsidian + Claude Code.

## Estrutura do projeto

```
PharoWiki/
├── src/
│   ├── BaselineOfPharoWiki/
│   │   ├── package.st
│   │   └── BaselineOfPharoWiki.class.st
│   └── PharoWiki/
│       ├── package.st
│       ├── PWikiClassPage.class.st        (tag: Core)
│       ├── PWikiMethodSection.class.st    (tag: Core)
│       ├── PWikiClassPageTest.class.st    (tag: Tests)
│       └── PWikiMethodSectionTest.class.st (tag: Tests)
├── load-pharowiki.st   ← script de ingestão
└── README.md
```

## Tags de pacote

| Tag | Responsabilidade |
|-----|-----------------|
| `Core` | Modelo principal — `PWikiClassPage`, `PWikiMethodSection` |
| `Extractors` | Extração de deps, conversão Microdown, geração de âncoras *(em breve)* |
| `Writers` | Escrita dos `.md` no sistema de arquivos *(em breve)* |
| `Tests` | Todos os TestCases BDD-style |

## Como carregar no Pharo 13

1. Abra o **Playground** (`Ctrl+O, W` ou via menu World)
2. Abra o arquivo `load-pharowiki.st`
3. Ajuste o caminho `pharoWikiPath` para onde este repositório está no seu Mac
4. Selecione tudo e execute (`Ctrl+D` — Do it)
5. Verifique o Transcript para confirmação e resultado dos testes

## Classes implementadas

### PWikiClassPage
Representa uma página wiki para uma classe Pharo.
Encapsula toda a introspecção necessária via reflexão da imagem.

Mensagens principais:
- `forClass: aClass` — construtor
- `className` — nome da classe
- `superclassName` — nome da superclasse
- `packageName` — pacote
- `comment` — comentário em Microdown
- `protocolNames` — protocolos (excluindo extensões)
- `extensionProtocolNames` — protocolos de extensão (`*`)
- `methodsInProtocol: aName` — métodos de um protocolo
- `instanceVariableNames` — variáveis de instância
- `classVariableNames` — variáveis de classe
- `subclassNames` — subclasses diretas
- `traitNames` — traits usados

### PWikiMethodSection
Representa um método dentro de uma página de classe.

Mensagens principais:
- `forMethod: aCompiledMethod` — construtor
- `selector` — seletor
- `protocol` — protocolo/categoria
- `sourceCode` — código fonte
- `pragmas` — pragmas do método
- `selfSends` — mensagens enviadas a self
- `superSends` — mensagens enviadas a super
- `sentMessages` — todas as mensagens enviadas
- `referencedClasses` — classes referenciadas estaticamente
- `anchorName` — âncora Markdown segura para o seletor
- `isAbstract`, `isPrimitive`, `isClassSide` — testes

## Próximas classes (roadmap)

- `PWikiDependencyExtractor` — consulta deps já mapeadas na imagem
- `PWikiMicrodownConverter` — converte links Microdown → Markdown
- `PWikiAnchorGenerator` — gera e resolve âncoras entre páginas
- `PWikiFileWriter` — escreve os `.md` no sistema de arquivos
- `PWikiGenerator` — orquestra tudo (entry point)
