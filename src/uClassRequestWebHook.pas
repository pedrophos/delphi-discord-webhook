unit uClassRequestWebHook;

interface
  uses System.classes, REST.Client, System.JSON, Rest.Types,IPPeerClient,DbClient,Db,Math, StrUtils , SysUtils, WebhookDiscord.Types;

type
  TRequestWebHook = class
    private
      FRequest: TRestRequest;
      FResponse: TRestResponse;
      FClient: TRestClient;
      FMessages: TStringList;
      FWebHook: String;
      FWebHookMessage: TWebhookMessage;

     function GetLeftPadding(aFieldSize, aTextSize: integer): integer;
     function GetRightPadding(aFieldSize, aTextSize: integer): integer;
     function SendDiscorMessage: Boolean;
     function Post(aMessage: TJSONObject): Boolean;

    public
      constructor Create(aWebHook: String);
      destructor Destroy;
      function SendMessage: Boolean;
      procedure AddTable(aDataSet: TDataSet);
      procedure AddTableInline(aDataset: TDataSet);
      function Send: Boolean;

      property Messages: TStringList read FMessages write FMessages;
      property WebHookMessage: TWebhookMessage read FWebHookMessage write FWebHookMessage;
  end;

implementation
 uses
   Rest.Json;

{ TRequestWebHook }

const
  cLineBreak: String = '\n';
  cAdditionalSize: Integer = 2;

constructor TRequestWebHook.Create(aWebHook: String);
begin
  FWebHook  := aWebHook;
  FResponse := TRESTResponse.Create(nil);
  FResponse.ContentType := 'application/json';

  FClient := TRESTClient.Create(FWebHook);
  FClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  FClient.AcceptCharset := 'UTF-8, *;q=0.8';
  FClient.HandleRedirects := True;
  FClient.SynchronizedEvents := False;
  FClient.RaiseExceptionOn500 := False;

  FRequest := TRESTRequest.Create(nil);
  FRequest.Timeout := 30000;
  FRequest.Client := FClient;
  FRequest.Response := FResponse;

  FMessages := TStringList.Create;
end;

procedure TRequestWebHook.AddTableInline(aDataset: TDataSet);
var
  I: Integer;
begin
  if aDataset.IsEmpty then Exit;

  FMessages.Add('```md'+cLineBreak);
  aDataset.First;
  while not aDataset.Eof do
  begin
    for I := 0 to aDataset.FieldCount - 1 do
    begin
      Messages.Add(aDataset.Fields[I].DisplayLabel+' - '+aDataset.Fields[I].AsString);
    end;

    FMessages.Add('');

    aDataset.Next;
  end;

  FMessages.Add('```');
end;

procedure TRequestWebHook.AddTable(aDataSet: TDataSet);
var
  I: Integer;
  vTable: String;
  vPaddings: Double;
  vLeftPadding, vRightPadding, vFieldSize, vDisplayLabelSize : Integer;


const
  // Corner Dividers

  cLTopCorner: char       = '╔';

  cLBottonCorner: char    = '╚';

  cRTopCorner: char       = '╗';

  cRBottonCorner: char    = '╝';

  cCrossDivider: char     = '╪';

  // Verifical / Horizontal Dividers
  cHorizontalDividerOuter: char       = '═';
  cVerticalDividerOuter: char         = '║';

  cHorizontalDividerInner: char       = '─';
  cVerticalDividerInner: char         = '│';

  // T Dividers
  cTDivider: char         = '╤';

  cTReverseDivider: char  = '╧';
  cTRigthDivider: char    = '╢';

  cTLeftDivider: char     = '╟';

begin
  if aDataset.IsEmpty then Exit;
  // Isso deu mais trabalho do que eu esperava
  // Adicionado as crases para iniciar um bloco de código
  // MD = Markdown

  try
    vTable := '```md'+cLineBreak;

    vLeftPadding := 0;

    // Bloco que monta a linha de topo da Tabela, no padrão ╔════════════╤════════════╤══════════╤════════════╗

    vTable := vTable + cLTopCorner;

    for I := 0 to aDataSet.FieldCount - 1 do
    begin
      vTable := vTable + StringOfChar(cHorizontalDividerOuter,aDataSet.Fields[I].Size + cAdditionalSize);

      if I = aDataSet.FieldCount - 1 then
        vTable := vTable + cRTopCorner
      else
        vTable := vTable + cTDivider;
    end;

    vTable := vTable + cLineBreak;

    // Bloco que conta os titulos, no padão ║  Titulo1    │    Titulo2    │ Titulo3  │ Titulo4  ║
    vTable := vTable + cVerticalDividerOuter;

    for I := 0 to aDataSet.FieldCount - 1 do
    begin
      vFieldSize        := aDataSet.Fields[I].Size + cAdditionalSize;
      vDisplayLabelSize := Length(aDataSet.Fields[I].DisplayLabel);

      vPaddings     :=  vFieldSize - vDisplayLabelSize;

      if vPaddings > 0 then
      begin
        vLeftPadding  := Trunc(vPaddings / 2);
        vRightPadding := Ceil(vPaddings / 2);
      end
      else
      begin
        vLeftPadding  := 0;
        vRightPadding := 0;
      end;

      if vLeftPadding > 0 then
        vTable := vTable + StringOfChar(' ',vLeftPadding);

      vTable := vTable + aDataSet.Fields[I].DisplayLabel;

      if vRightPadding > 0 then
        vTable := vTable + StringOfChar(' ',vRightPadding);

      if I = aDataSet.FieldCount - 1 then
        vTable := vTable + cVerticalDividerOuter
      else
        vTable := vTable + cVerticalDividerInner;
    end;

    vTable := vTable + cLineBreak;

    // Bloco que monta a base do titulo, no padrão ╠════════════╪════════════╪══════════╪════════════╣
    vTable := vTable + cTLeftDivider;

    for I := 0 to aDataSet.FieldCount - 1 do
    begin
      vTable := vTable + StringOfChar(cHorizontalDividerOuter,aDataSet.Fields[I].Size + cAdditionalSize);

      if I = aDataSet.FieldCount -1 then
        vTable := vTable + cTRigthDivider
      else
        vTable := vTable + cCrossDivider;
    end;

    vTable := vTable + cLineBreak;

    aDataSet.First;

    // Bloco que insere os dados

    while not aDataSet.Eof do
    begin
      for I := 0 to aDataSet.FieldCount - 1 do
      begin
        vFieldSize := aDataSet.Fields[I].Size + cAdditionalSize;

        if I = 0 then
          vTable := vTable + cVerticalDividerOuter
        else
          vTable := vTable + cVerticalDividerInner;

        vLeftPadding := 0;

        if aDataSet.Fields[I].Alignment = taCenter then
          vLeftPadding :=  GetLeftPadding(aDataSet.Fields[I].Size, Length(aDataSet.Fields[I].AsString));

        vTable := vTable + StringOfChar(' ',vLeftPadding);

        vTable := vTable + aDataSet.Fields[I].AsString;

        if vLeftPadding > 0 then
         vRightPadding := GetRightPadding(aDataSet.Fields[I].Size, Length(aDataSet.Fields[I].AsString))
        else
          vRightPadding := vFieldSize - Length(aDataSet.Fields[I].AsString);

        if vRightPadding > 0 then
          vTable := vTable + StringOfChar(' ', vRightPadding);
      end;

      vTable := vTable + cVerticalDividerOuter;

      vTable := vTable + cLineBreak;

      aDataSet.Next;
    end;

    // Bloco que insere a base da tabela, no padrão ╚════════════╧════════════╧══════════╧════════════╝

    vTable := vTable + cLBottonCorner;

    for I := 0 to aDataSet.FieldCount - 1 do
    begin
      vFieldSize := aDataSet.Fields[I].Size + cAdditionalSize;
      vTable     := vTable + StringOfChar(cHorizontalDividerOuter, vFieldSize);

      if I = aDataSet.FieldCount - 1 then
        vTable := vTable + cRBottonCorner
      else
        vTable := vTable + cTReverseDivider;
    end;

    // Encerra a tag que indica o bloco de código do discord

    vTable := vTable + '```';

    Messages.Add(vTable);
  except
    on E: Exception do
      raise Exception.Create('Erro ao gerar tabela!'+E.Message);
  end;
end;

function TRequestWebHook.GetLeftPadding(aFieldSize, aTextSize: integer): integer;
begin
  try
    Result := Trunc((aFieldSize + cAdditionalSize - aTextSize) / 2);
  Except
    Result := 0;
  end;
end;

function TRequestWebHook.GetRightPadding(aFieldSize, aTextSize: integer): integer;
begin
  try
    Result := Ceil((aFieldSize + cAdditionalSize - aTextSize) / 2);
  Except
    Result := 0;
  end;
end;

function TRequestWebHook.Post(aMessage: TJSONObject): Boolean;
begin
  try
    Result := False;
    FRequest.Params.Clear;
    FRequest.Method := rmPost;
    FRequest.AddBody(aMessage.ToString, ctAPPLICATION_JSON);
    FRequest.Execute;

    if FResponse.StatusCode in [200,204] then
      Result := True
    else
      raise Exception.Create('Error sending message '+FResponse.StatusCode.ToString+' '+FResponse.Content);
  except
    on E: Exception do
      raise Exception.Create('Error sending message '+E.Message);
  end;
end;

destructor TRequestWebHook.Destroy;
begin
  FResponse.Free;
  FRequest.Free;
  FClient.Free;
end;

function TRequestWebHook.Send: Boolean;
begin
  if FWebHookMessage <> nil then
    SendDiscorMessage
  else
  if FMessages.Count > 0 then
    SendMessage
  else
    raise Exception.Create('No message to send!');
end;

function TRequestWebHook.SendDiscorMessage: Boolean;
var
  vWebMessageJson: TJSONObject;
begin
  try
    try
      vWebMessageJson := TJson.ObjectToJsonObject(FWebHookMessage);

      Post(vWebMessageJson);
    except
      on E: Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(vWebMessageJson);
  end;
end;

function TRequestWebHook.SendMessage: Boolean;
var
  vJsonmessage: TJsonObject;
  vMessageString, vMessage: String;
begin
  vJsonmessage := TJSONObject.Create;
  try
    try
      vMessageString := '';

      for vMessage in FMessages do
      begin
        vMessageString := vMessageString +  ReplaceStr(vMessage, sLineBreak, cLineBreak)  + cLineBreak;
      end;

      vJsonmessage.AddPair('content',vMessageString);

      Result := Post(vJsonmessage);
    except
      on E: Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(vJsonmessage);
  end;
end;

end.
