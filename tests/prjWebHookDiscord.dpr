program prjWebHookDiscord;

uses
  Vcl.Forms,
  uTestWebHook in 'uTestWebHook.pas' {Form1},
  uClassRequestWebHook in '..\src\uClassRequestWebHook.pas',
  WebhookDiscord.Types in '..\src\WebhookDiscord.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
