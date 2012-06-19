unit fmServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmServer = class(TForm)
    edtPort: TLabeledEdit;
    btnStart: TButton;
    btnStop: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    procedure SetupControls(const aFlag: Boolean);
  public
  end;

var
  frmServer: TfrmServer;

implementation

uses
  uServerThread;

{$R *.dfm}

var
  FServerThread: TServerThread;

procedure TfrmServer.btnStartClick(Sender: TObject);
begin
  SetupControls(False);
  FServerThread := TServerThread.Create(False, StrToInt(edtPort.Text));
end;

procedure TfrmServer.btnStopClick(Sender: TObject);
begin
  FServerThread.Terminate;
  Sleep(500);
  SetupControls(True);
end;

procedure TfrmServer.FormCreate(Sender: TObject);
begin
  SetupControls(True);
end;

procedure TfrmServer.SetupControls(const aFlag: Boolean);
begin
  edtPort.Enabled := aFlag;
  btnStart.Enabled := aFlag;
  btnStop.Enabled := not aFlag;
end;

end.
