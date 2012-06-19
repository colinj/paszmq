program rrServer;

uses
  Forms,
  fmServer in 'fmServer.pas' {frmServer},
  uServerThread in 'uServerThread.pas',
  zmq in '..\..\src\zmq.pas',
  zhelper in '..\..\src\zhelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmServer, frmServer);
  Application.Run;
end.
