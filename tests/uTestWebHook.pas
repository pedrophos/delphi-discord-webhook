unit uTestWebHook;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    edtTest: TEdit;
    btnTextoSimples: TButton;
    dtTest: TFDMemTable;
    dtTestCODIGO: TStringField;
    dtTestDESCRICAO: TStringField;
    dtTestESTOQUE: TStringField;
    btnTabela: TButton;
    rgTipoTabela: TRadioGroup;
    FDMemTable1: TFDMemTable;
    Memo1: TMemo;
    btnWebHookMessage: TButton;
    Label1: TLabel;
    edtServerUrl: TEdit;
    Label2: TLabel;
    procedure btnTextoSimplesClick(Sender: TObject);
    procedure btnTabelaClick(Sender: TObject);
    procedure btnWebHookMessageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function getUrlSetverDiscord: String;
    procedure setUrlServerDiscord(const Value: String);
  public
    { Public declarations }

    property UrlServerDiscord: String read getUrlSetverDiscord write setUrlServerDiscord;
  end;

var
  Form1: TForm1;

implementation

uses
  uClassRequestWebHook, WebhookDiscord.Types, Rest.Json, System.Json, IniFiles;

  const
    cLineBreak: String = '\n';

{$R *.dfm}

procedure TForm1.btnTextoSimplesClick(Sender: TObject);
var
  vSendMessage: TRequestWebHook;
  vTestMessage: String;
begin
  vSendMessage := TRequestWebHook.Create(UrlServerDiscord);
  try
    vSendMessage.Messages.Add(edtTest.Text);

    vSendMessage.SendMessage;
  finally
    FreeAndNil(vSendMessage);
  end;
end;

procedure TForm1.btnTabelaClick(Sender: TObject);
var
  vSendMessage: TRequestWebHook;
begin
// Tabelas serão enviadas nesse formato
//                 '╔════════════╤════════════╤══════════╤════════════╗'
//                 '║  CODIGO    │    DESC    │ ESTOQUE  │ MOVIMENTO  ║'
//                 '╠════════════╪════════════╪══════════╪════════════╣'
//                 '║   123      │ Produto A  │   50     │   Entrada  ║'
//                 '╟────────────┼────────────┼──────────┼────────────╢'
//                 '║   456      │ Produto B  │   30     │   Saída    ║'
//                 '╟────────────┼────────────┼──────────┼────────────╢'
//                 '║   789      │ Produto C  │   20     │   Entrada  ║'
//                 '╚════════════╧════════════╧══════════╧════════════╝'

  vSendMessage := TRequestWebHook.Create(UrlServerDiscord);
  dtTest.Open;

  dtTest.Append;
  dtTestCODIGO.AsString    := '17';
  dtTestDESCRICAO.AsString := 'ITEM TESTE';
  dtTestESTOQUE.AsString   := '010';
  dtTest.Post;

  dtTest.Append;
  dtTestCODIGO.AsString    := '15';
  dtTestDESCRICAO.AsString := 'ITEM TESTE 2';
  dtTestESTOQUE.AsString   := '005';
  dtTest.Post;

  dtTest.Append;
  dtTestCODIGO.AsString    := '24';
  dtTestDESCRICAO.AsString := 'ITEM TESTE 3 ';
  dtTestESTOQUE.AsString   := '020';
  dtTest.Post;

  dtTest.Append;
  dtTestCODIGO.AsString    := '31';
  dtTestDESCRICAO.AsString := 'ITEM TESTE 5';
  dtTestESTOQUE.AsString   := '030';
  dtTest.Post;

  if rgTipoTabela.ItemIndex = 0 then
    vSendMessage.AddTable(dtTest)
  else
    vSendMessage.AddTableInline(dtTest);

  vSendMessage.Send;
end;

procedure TForm1.btnWebHookMessageClick(Sender: TObject);
var
  vWebHook: TWebhookMessage;
  vTesteJson: TJSONObject;

  vSendMessage: TRequestWebHook;
begin
  vSendMessage := TRequestWebHook.Create(UrlServerDiscord);

  try
    try
      vWebHook := TWebhookMessage.Create;


      vWebHook.Username  := 'Pedro';
      vWebHook.Content   := 'Conteúdo';
      vWebHook.TTS       := True;
      vWebHook.AvatarUrl := 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxdTwd_Z8eMYOLNBP-4YEnEI9IJpkE_YUjEg&s';

      vWebHook.Embeds[0] := TEmbed.Create;
      vWebHook.Embeds[0].Author.Name :=  'Nome do Autor';
      vWebHook.Embeds[0].Title := 'Titulo Embed';
      vWebHook.Embeds[0].Description := 'Descrição para testar';
      vWebHook.Embeds[0].Footer.Text := 'Texto Rodapé';
      vWebHook.Embeds[0].TimeStamp := Now;

//      vWebHook.

      vSendMessage.WebHookMessage := vWebHook;
      vSendMessage.Send;

      Memo1.Lines.Add(TJson.ObjectToJsonObject(vWebHook).ToString);
    Except
      on E: Exception do
        ShowMessage('Falhou: '+E.Message);
    end;
  finally
    FreeAndNil(vSendMessage);
    FreeAndNil(vWebHook);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  vIni: TIniFile;
begin
  vIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  try
    UrlServerDiscord := vIni.ReadString('DISCORD','SERVER URL','');
  finally
    FreeAndNil(vIni);
  end;
end;

function TForm1.getUrlSetverDiscord: String;
begin
  Result := edtServerUrl.Text;
end;

procedure TForm1.setUrlServerDiscord(const Value: String);
begin
  edtServerUrl.Text := Value;
end;

end.
