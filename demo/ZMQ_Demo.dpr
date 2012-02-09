program ZMQ_Demo;

uses
  Forms,
  fmMain in 'fmMain.pas' {Form2},
  zmq in '..\src\zmq.pas',
  paszmq in '..\src\paszmq.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
