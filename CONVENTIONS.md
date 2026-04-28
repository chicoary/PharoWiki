# PharoWiki — Convenções do Projeto
> Leia este arquivo no início de cada sessão, junto com CONTEXT.md.
> Atualizar sempre que uma nova convenção for estabelecida.
> **Atualizar `CONVENTIONS.md` tem prioridade sobre adicionar ou corrigir código.**

---

## Comunicação

- **Mensagens curtas devem ser completas** — sem elipses (`...`) nem frases truncadas. "Execute Gerar Point no Playground do Pharo." é melhor que "Execute Gerar Point."
- **Não economizar tokens em mensagens curtas** — clareza vale mais que brevidade nesses casos.
- **Perguntar antes de mostrar código** — antes de gerar código para executar, perguntar se o usuário quer ver. Exceção: quando o usuário pede explicitamente.
- **Scripts referenciados por nome** — ao pedir para executar um script, referenciar pelo nome da seção no `scripts.md`. Exemplo: "Execute **Rodar todos os testes** no Playground do Pharo."
- **Correções e implementações sempre entregues como arquivo para download** — ao propor qualquer método novo ou corrigido, sempre gerar o arquivo `.class.st` completo para download. Nunca mostrar só o trecho alterado inline. O código atual já está em `src/`; o arquivo completo é tudo que o usuário precisa para aplicar.
- **Sem `...` em trechos de código** — nunca usar `...` para indicar "o resto não muda". Mostrar sempre o método completo.
- **Explicar antes de implementar** — antes de gerar código de uma nova classe ou método significativo, escrever um parágrafo curto explicando responsabilidades, API principal e decisões de design relevantes.
- **Avisar antes de qualquer redução de código** — se um arquivo gerado remove métodos, remove trechos de métodos, refatora reduzindo estrutura, ou "encolhe" o código em relação ao original, avisar explicitamente o que foi reduzido e por quê, e pedir aprovação antes de o usuário salvar.

---

## Playground

- **Omitir `inspect`** — o Playground já abre um Inspector para a última expressão avaliada. Usar `inspect` é redundante.

---

## Fluxo de trabalho

- **Editar arquivos no repositório, não na imagem** — mudanças vão para `src/` primeiro, depois recarregadas via Metacello. Nunca editar direto no browser do Pharo.
- **Sequência padrão de mudança:** editar `.class.st` → recarregar pacote → rodar testes → commit só se verde.
- **Commit via Terminal** — a mensagem de commit é fornecida pela Claude com o comando completo. Não há script de commit no `scripts.md`.
- **Git registra estado funcionando** — nunca commitar com testes falhando.
- **Uma coisa de cada vez** — corrigir um problema por vez, com testes quando aplicável.
- **Metacello não remove métodos** — ao renomear ou remover um método, o Metacello recarrega o arquivo mas não apaga o método antigo da imagem. Remover manualmente no browser do Pharo antes de recarregar.
- **Atualizar arquivos de contexto no projeto Claude** — sempre que `ROADMAP.md`, `CONVENTIONS.md` ou `CONTEXT.md` forem modificados, fazer upload das versões atualizadas nos arquivos do projeto PharoWiki no Claude. Isso garante que a próxima sessão começa com contexto correto. A Claude deve lembrar o usuário disso ao final de qualquer sessão que produza mudanças nesses arquivos.

---

## Testes

- **`self skip` ignora o teste na execução da suíte completa**, mas é contornado quando o método é executado individualmente pela UI do Test Runner (clicar no botão ao lado do teste). Use esse comportamento para validar testes lentos sob demanda sem remover a marcação de skip.
- **Manter testes lentos marcados com `self skip`** para preservar o ciclo rápido de validação, executando-os pontualmente via UI quando necessário.

---

## Estilo de código Pharo

- Métodos curtos são desejáveis — extrair métodos auxiliares quando o método cresce.
- Variáveis temporárias sempre declaradas no início do método.
- Usar `cr` em `WriteStream`, não `nl`.
- Usar `PackageOrganizer`, não `RPackageOrganizer`.
- Usar `isMeta`, não `isMetaclass`.
- Usar `protocol name` para obter o nome do protocolo de um `CompiledMethod`.
- `Point` não tem subclasses no Pharo 13 — usar `Collection` para testar `hasSubclasses`.
- `FileReference>>ensureCreateDirectory` cria o diretório e todos os pais necessários.
- Protocolos privados: usar `private` para ganhar marcação visual no IDE; usar `private-xxx` quando vale nomear o grupo (ex: `private-converting`, `private-rendering`).

---

## Design de classes

- **Responsabilidade única** — cada classe faz uma coisa. Separar modelo, orquestração e escrita em classes distintas.
- **Começar pelo modelo, não pela orquestração** — implementar a classe que representa o conceito antes de quem a usa. Isso torna os testes do modelo independentes.
- **Testes guiam o design da API** — pensar no teste antes de escrever o método força a definir a API de forma clara.
- **Classe canônica de teste estável** — usar `Point` para classes e `#ifTrue:` para seletores: pequenos, estáveis, com comportamento conhecido.
- **Nomenclatura revela intenção** — `selectorToFileName: aSelector` é melhor que `convert: aSelector`.
- **Ordenar saída para testes previsíveis** — coleções geradas devem ser ordenadas quando a ordem importa para comparação em testes.
