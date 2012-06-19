unit fmBroker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uBrokerThread;

type
  TfrmBroker = class(TForm)
    btnStart: TButton;
    edtFrontEnd: TLabeledEdit;
    edtBackEnd: TLabeledEdit;
    procedure btnStartClick(Sender: TObject);
  private
    FBrokerThread: TBrokerThread;
  public
  end;

var
  frmBroker: TfrmBroker;

implementation

{$R *.dfm}

procedure TfrmBroker.btnStartClick(Sender: TObject);
begin
  FBrokerThread := TBrokerThread.Create(False, StrToInt(edtFrontEnd.Text), StrToInt(edtBackEnd.Text));
end;

end.
