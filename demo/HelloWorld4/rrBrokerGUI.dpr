program rrBrokerGUI;

uses
  Forms,
  fmBroker in 'fmBroker.pas' {frmBroker},
  uBrokerThread in 'uBrokerThread.pas',
  zmq in '..\..\src\zmq.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmBroker, frmBroker);
  Application.Run;
end.
