"===============================================================
 PharoWiki — Script de Ingestão
 
 Execute este script no Playground do Pharo 13 para carregar
 o pacote PharoWiki na imagem a partir dos arquivos Tonel.
 
 Pré-requisito: Iceberg configurado (vem por padrão no Pharo 13).
 
 OPÇÃO 1 — Carregar direto do sistema de arquivos (desenvolvimento local)
 Ajuste o caminho 'pharoWikiPath' para onde os arquivos estão.
 ==============================================================="

| pharoWikiPath |

"Ajuste este caminho para a pasta raiz do PharoWiki no seu Mac"
pharoWikiPath := '/Users/SEU_USUARIO/PharoWiki'.

Metacello new
	baseline: 'PharoWiki';
	repository: 'filetree://', pharoWikiPath, '/src';
	load.

"Confirmar que as classes foram carregadas"
Transcript
	show: 'PharoWiki carregado com sucesso!'; cr;
	show: 'Classes: '; cr.

#(PWikiClassPage PWikiMethodSection) do: [ :className |
	| cls |
	cls := Smalltalk globals at: className ifAbsent: [ nil ].
	cls
		ifNil: [ Transcript show: '  ✗ ', className, ' — NÃO encontrada'; cr ]
		ifNotNil: [ Transcript show: '  ✓ ', className; cr ] ].

"Rodar os testes"
Transcript show: ''; cr; show: 'Rodando testes...'; cr.
| result |
result := TestSuite new.
result addTest: PWikiClassPageTest suite.
result addTest: PWikiMethodSectionTest suite.
result := result run.

Transcript
	show: 'Resultado: ';
	show: result passed size printString, ' passaram, ';
	show: result failures size printString, ' falharam, ';
	show: result errors size printString, ' erros.'; cr.
