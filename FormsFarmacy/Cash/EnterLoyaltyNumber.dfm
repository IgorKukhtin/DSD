object EnterLoyaltyNumberForm: TEnterLoyaltyNumberForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' "'#1055#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080'"'
  ClientHeight = 177
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    381
    177)
  PixelsPerInch = 96
  TextHeight = 13
  object pn2: TPanel
    Left = 0
    Top = 136
    Width = 381
    Height = 41
    Align = alBottom
    Caption = 'pn2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 2
    DesignSize = (
      381
      41)
    object bbCancel: TcxButton
      Left = 289
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 8
      TabOrder = 0
    end
    object bbOk: TcxButton
      Left = 196
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object pn1: TPanel
    Left = 0
    Top = 0
    Width = 381
    Height = 136
    Align = alClient
    ShowCaption = False
    TabOrder = 1
    object Label1: TLabel
      Left = 48
      Top = 24
      Width = 200
      Height = 19
      Caption = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1087#1088#1086#1084#1086#1082#1086#1076#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object edMaskNumber: TcxMaskEdit
    Left = 48
    Top = 67
    Anchors = [akLeft, akTop, akRight]
    ParentFont = False
    Properties.CharCase = ecUpperCase
    Properties.EditMask = 'AAAA\-AAAA\-AAAA\-AAAA;1;_'
    Properties.ValidationOptions = []
    Properties.OnValidate = edMaskNumberPropertiesValidate
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    Text = '    -    -    -    '
    OnKeyPress = edMaskNumberKeyPress
    Width = 291
  end
end
