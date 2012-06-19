unit fmClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmClient = class(TForm)
    btnDemo1: TButton;
    btnDemo2: TButton;
    Memo1: TMemo;
    edtName: TLabeledEdit;
    procedure btnDemo2Click(Sender: TObject);
    procedure btnDemo1Click(Sender: TObject);
  private
    procedure AddLine(const s: string);
  public
  end;

var
  frmClient: TfrmClient;

implementation

uses zmq, zhelper;

{$R *.dfm}

procedure TfrmClient.AddLine(const s: string);
begin
  Memo1.Lines.Add(s);
  Application.ProcessMessages;
end;

procedure TfrmClient.btnDemo1Click(Sender: TObject);
var
  Context: Pointer;
  Requestor: Pointer;
  I: Integer;
  Msg: string;
begin
  Context := zmq_init(1);

  //  Socket to talk to server
  AddLine('Connecting to hello world server');
  Requestor := zmq_socket(Context, ZMQ_REQ);
  zmq_connect(Requestor, 'tcp://localhost:5555');

  for I := 0 to 50 do
  begin
    Msg := Format('Hello %d from %s', [I, edtName.Text]);
    AddLine(Format('Sending... %s', [Msg]));
    s_send(Requestor, Msg);

    Msg := s_recv(Requestor);
    AddLine(Format('Received %d - %s', [I, Msg]));
  end;

  zmq_close (Requestor);
  zmq_term (Context);
end;

procedure TfrmClient.btnDemo2Click(Sender: TObject);
var
  Context: Pointer;
  Requestor: Pointer;
  Msg: string;
  I: Integer;
begin
  Context := zmq_init(1);

  //  Socket to talk to server
  AddLine('Connecting to hello world server');
  Requestor := zmq_socket(Context, ZMQ_REQ);
  zmq_connect(Requestor, 'tcp://localhost:5555');
  zmq_connect(Requestor, 'tcp://localhost:5556');

  for I := 0 to 50 do
  begin
    Msg := Format('Hello %d from %s', [I, edtName.Text]);
    AddLine(Format('Sending... %s', [Msg]));
    s_send(Requestor, Msg);

    Msg := s_recv(Requestor);
    AddLine(Format('Received %d - %s', [I, Msg]));
  end;

  zmq_close(Requestor);
  zmq_term(Context);
end;

end.
