# PharoWiki — Scripts do Playground

> Referência rápida de scripts para executar no Playground do Pharo 13.
> Ajuste os caminhos conforme necessário.

---

## Variáveis comuns

```smalltalk
pharoWikiPath := '/Users/chicoary/Documents/Obsidian Vaults/CODE Vault/1 - Projetos/1 - In progress/PharoWiki/Anexos/PharoWiki'.
wikiOutputPath := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki/'.
```

---

## Recarregar pacote

```smalltalk
| pharoWikiPath |
pharoWikiPath := '/Users/chicoary/Documents/Obsidian Vaults/CODE Vault/1 - Projetos/1 - In progress/PharoWiki/Anexos/PharoWiki'.

Transcript
    clear;
    show: '[', DateAndTime now printString, '] Recarregando PharoWiki...'; cr.

Metacello new
    baseline: 'PharoWiki';
    repository: 'tonel://', pharoWikiPath, '/src';
    load.
self inform: 'Ok'
```

---

## Rodar todos os testes

```smalltalk
| result suite |

Transcript
    clear;
    cr;
    show: '[', DateAndTime now printString, '] Rodando testes...'; cr.

suite := TestSuite new.
suite addTest: PWikiClassPageTest suite.
suite addTest: PWikiMethodSectionTest suite.
suite addTest: PWikiMicrodownConverterTest suite.
suite addTest: PWikiAnchorGeneratorTest suite.
suite addTest: PWikiDependencyExtractorTest suite.
suite addTest: PWikiFileWriterTest suite.
suite addTest: PWikiGeneratorTest suite.
suite addTest: PWikiImplementorsPageTest suite.
suite addTest: PWikiSendersPageTest suite.
suite addTest: PWikiProgressEstimatorTest suite.

[ :job |
    job title: 'Rodando testes PharoWiki'; min: 0; max: 1.
    result := suite run.
    job currentValue: 1 ] asJob run.

Transcript
    show: result passed size printString, ' passaram'; cr;
    show: result failures size printString, ' falharam'; cr;
    show: result errors size printString, ' erros'; cr;
    show: result skipped size printString, ' pulados'; cr.
self inform: 'Ok'
```

---

## Gerar código da classe

```smalltalk
TonelWriter sourceCodeOf: DebugTracer 
```

---

## Gerar Point

```smalltalk
| gen outputDir |
outputDir := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki/' asFileReference.
gen := PWikiGenerator outputDir: outputDir.
gen generateForClass: Point.
self inform: 'Ok'
```

---

## Gerar pacote PharoWiki

```smalltalk
| gen outputDir |
outputDir := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki/' asFileReference.
gen := PWikiGenerator outputDir: outputDir.
gen generateForPackageNamed: 'PharoWiki'.
self inform: 'Ok'
```

---

## Gerar imagem completa

```smalltalk
| gen outputDir |
outputDir := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki/' asFileReference.

gen := PWikiGenerator outputDir: outputDir.
gen generateForImage.
self inform: 'Ok'
```

## Materializar generation record

```smalltalk
| stonFile dict |
stonFile := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki/_generation.ston' asFileReference.
dict := STON fromString: stonFile contents.
dict
```

## Materializar classDigests

```smalltalk
| stonFile digests |
stonFile := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki/_generation.ston' asFileReference.
digests := (STON fromString: stonFile contents) at: #classDigests.
digests
```