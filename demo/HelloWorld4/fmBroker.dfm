object frmBroker: TfrmBroker
  Left = 0
  Top = 0
  Caption = 'REQ-REP Broker'
  ClientHeight = 202
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnStart: TButton
    Left = 104
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object edtFrontEnd: TLabeledEdit
    Left = 16
    Top = 32
    Width = 75
    Height = 21
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = 'Front End'
    NumbersOnly = True
    TabOrder = 1
    Text = '5559'
  end
  object edtBackEnd: TLabeledEdit
    Left = 192
    Top = 32
    Width = 75
    Height = 21
    EditLabel.Width = 43
    EditLabel.Height = 13
    EditLabel.Caption = 'Back End'
    NumbersOnly = True
    TabOrder = 2
    Text = '5560'
  end
end
