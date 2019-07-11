object LoginForm: TLoginForm
  Left = 0
  Top = 0
  Caption = #1042#1093#1086#1076' '#1074' '#1089#1080#1089#1090#1077#1084#1091
  ClientHeight = 155
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 24
    Top = 8
    AutoSize = False
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -21
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    Properties.LabelEffect = cxleExtrude
    Properties.LabelStyle = cxlsLowered
    Height = 240
    Width = 456
    AnchorX = 252
    AnchorY = 128
  end
  object edUserName: TcxComboBox
    Left = 152
    Top = 32
    TabOrder = 0
    Width = 204
  end
  object edPassword: TcxTextEdit
    Left = 152
    Top = 63
    Properties.EchoMode = eemPassword
    Properties.IncrementalSearch = False
    Properties.PasswordChar = '*'
    TabOrder = 1
    Width = 204
  end
  object btnOk: TcxButton
    Left = 152
    Top = 102
    Width = 93
    Height = 21
    Caption = #1042#1086#1081#1090#1080
    Default = True
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TcxButton
    Left = 260
    Top = 102
    Width = 96
    Height = 21
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 61
    Top = 32
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taRightJustify
    AnchorX = 153
  end
  object cxLabel3: TcxLabel
    Left = 101
    Top = 62
    Caption = #1055#1072#1088#1086#1083#1100':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taRightJustify
    AnchorX = 153
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = edUserName
        Properties.Strings = (
          'Properties.CharCase'
          'Text')
      end>
    StorageName = 'LoginForm.ini'
    Left = 328
    Top = 72
  end
end
