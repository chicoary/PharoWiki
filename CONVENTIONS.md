# PharoWiki — Convenções do Projeto

> Leia este arquivo no início de cada sessão, junto com PHAROWIKI_CONTEXT.md.
> Atualizar sempre que uma nova convenção for estabelecida.

---

## Comunicação

- **Mensagens curtas devem ser completas** — sem elipses (`...`) nem frases truncadas. "Execute Gerar Point no Playground do Pharo." é melhor que "Execute Gerar Point."
- **Não economizar tokens em mensagens curtas** — clareza vale mais que brevidade nesses casos.
- **Perguntar antes de mostrar código** — antes de gerar código para executar, perguntar se o usuário quer ver. Exceção: quando o usuário pede explicitamente.
- **Scripts referenciados por nome** — ao pedir para executar um script, referenciar pelo nome da seção no `scripts.md`. Exemplo: "Execute **Rodar todos os testes** no Playground do Pharo."

## Fluxo de trabalho

- **Editar arquivos no repositório, não na imagem** — mudanças vão para `src/` primeiro, depois recarregadas via Metacello. Nunca editar direto no browser do Pharo.
- **Sequência padrão de mudança:** editar `.class.st` → recarregar pacote → rodar testes → commit só se verde.
- **Commit via Terminal** — a mensagem de commit é fornecida pela Claude com o comando completo. Não há script de commit no `scripts.md`.
- **Git registra estado funcionando** — nunca commitar com testes falhando.

## Estilo de código Pharo

- Variáveis temporárias sempre declaradas no início do método.
- Usar `cr` em `WriteStream`, não `nl`.
- Usar `PackageOrganizer`, não `RPackageOrganizer`.
- Usar `isMeta`, não `isMetaclass`.
- Usar `protocol name` para obter o nome do protocolo de um `CompiledMethod`.
- `Point` não tem subclasses no Pharo 13 — usar `Collection` para testar `hasSubclasses`.
- `FileReference>>ensureCreateDirectory` cria o diretório e todos os pais necessários.
