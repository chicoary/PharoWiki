Class {
	#name : #BaselineOfPharoWiki,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoWiki
}

{ #category : #baselines }
BaselineOfPharoWiki >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec
				package: 'PharoWiki'
				with: [ spec requires: #() ].
			spec
				group: 'Core'
				with: #('PharoWiki').
			spec
				group: 'Tests'
				with: #('PharoWiki').
			spec
				group: 'default'
				with: #('Core' 'Tests') ]
]

{ #category : #accessing }
BaselineOfPharoWiki >> projectPackageNames [
	"Pacotes que compõem este projeto.
	
	Este método tem papel duplo:
	1. Carregamento via Metacello — define o que é instalado na imagem.
	2. Fronteira para o PWikiChangesGenerator — distingue código do projeto
	   de bibliotecas externas carregadas via .changes.
	
	Pacotes listados aqui vão para wiki/changes/ (editável pela IA).
	Pacotes ausentes desta lista vão para wiki/libs/ (somente leitura para a IA).
	
	Ao criar um novo pacote do projeto, adicione-o aqui antes de recarregar."

	^ #('PharoWiki')
]
