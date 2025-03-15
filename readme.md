# Documentação da Classe de Envio de Mensagens para Discord

## Visão Geral
Esta classe permite o envio de mensagens para um webhook do Discord, incluindo mensagens simples e tabelas formatadas a partir de um `TDataSet`.

## Construtor
```delphi
constructor Create(aWebHook: String);
```
- **aWebHook**: Endereço HTTP do webhook do Discord.

## Métodos

### `AddTable`
```delphi
procedure AddTable(aDataSet: TDataSet);
```
- **aDataSet**: O conjunto de dados será convertido para uma tabela em formato de texto, seguindo o padrão abaixo:
  
  ```
  ╔════════════╤════════════╤══════════╤════════════╗
  ║  CODIGO    │    DESC    │ ESTOQUE  │ MOVIMENTO  ║
  ╠════════════╪════════════╪══════════╪════════════╣
  ║   123      │ Produto A  │   50     │   Entrada  ║
  ╟────────────┼────────────┼──────────┼────────────╢
  ║   456      │ Produto B  │   30     │   Saída    ║
  ╟────────────┼────────────┼──────────┼────────────╢
  ║   789      │ Produto C  │   20     │   Entrada  ║
  ╚════════════╧════════════╧══════════╧════════════╝
  ```

### `AddTableInline`
```delphi
procedure AddTableInline(aDataset: TDataSet);
```
- **aDataSet**: Os registros da tabela serão convertidos para linhas no formato `Título: Valor`.

### `Send`
```delphi
function Send: Boolean;
```
- Envia a mensagem para o webhook do Discord.
- Prioriza a propriedade `WebHookMessage`. Caso esta esteja nula, envia o conteúdo da propriedade `Messages`.

## Propriedades

### `Messages`
```delphi
property Messages: TStringList read FMessages write FMessages;
```
- Lista de mensagens simples.
- Os valores serão adicionados ao campo `content` do JSON enviado ao Discord.

### `WebHookMessage`
```delphi
property WebHookMessage: TWebhookMessage read FWebHookMessage write FWebHookMessage;
```
- Objeto do tipo `TWebhookMessage`, que segue o mesmo padrão de estrutura do JSON aceito pelo Discord.
- Caso definido, este objeto será convertido para JSON e enviado ao webhook.

---

Este documento detalha o funcionamento da classe e suas principais funcionalidades. Para mais detalhes sobre integração com webhooks do Discord, consulte a [documentação oficial](https://discord.com/developers/docs/resources/webhook).

