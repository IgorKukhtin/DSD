object LoginForm: TLoginForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 256
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 24
    Top = 8
    AutoSize = False
    Caption = #1040' '#1090#1091#1090' '#1076#1086#1083#1078#1085#1072' '#1073#1099#1090#1100' '#1082#1072#1088#1090#1080#1085#1082#1072' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
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
    Left = 276
    Top = 145
    TabOrder = 0
    Width = 204
  end
  object edPassword: TcxTextEdit
    Left = 276
    Top = 176
    Properties.EchoMode = eemPassword
    Properties.IncrementalSearch = False
    Properties.PasswordChar = '*'
    TabOrder = 1
    Width = 204
  end
  object btnOk: TcxButton
    Left = 276
    Top = 215
    Width = 93
    Height = 25
    Caption = #1042#1086#1081#1090#1080
    Default = True
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TcxButton
    Left = 384
    Top = 215
    Width = 96
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 185
    Top = 145
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxLabel3: TcxLabel
    Left = 225
    Top = 175
    Caption = #1055#1072#1088#1086#1083#1100':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = edUserName
        Properties.Strings = (
          'Properties.CharCase'
          'Properties.Items')
      end>
    StorageName = 'cxPropertiesStore'
    Left = 328
    Top = 72
  end
end
