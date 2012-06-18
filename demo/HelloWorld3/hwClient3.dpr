program hwClient3;

uses
  Forms,
  fmClient in 'fmClient.pas' {frmClient},
  zmq in '..\..\src\zmq.pas',
  zhelper in '..\..\src\zhelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmClient, frmClient);
  Application.Run;
end.
