object HardwareDialogForm: THardwareDialogForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1040#1087#1087#1072#1088#1072#1090#1085#1072#1103' '#1095#1072#1089#1090#1100
  ClientHeight = 229
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pn2: TPanel
    Left = 0
    Top = 188
    Width = 427
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
    ExplicitTop = 136
    ExplicitWidth = 381
    DesignSize = (
      427
      41)
    object bbCancel: TcxButton
      Left = 335
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 8
      TabOrder = 0
      ExplicitLeft = 289
    end
    object bbOk: TcxButton
      Left = 242
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
      ExplicitLeft = 196
    end
  end
  object pn1: TPanel
    Left = 0
    Top = 0
    Width = 427
    Height = 188
    Align = alClient
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 381
    ExplicitHeight = 136
    DesignSize = (
      427
      188)
    object Label1: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 24
      Width = 377
      Height = 69
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        #1042#1074#1077#1076#1080#1090#1077' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088', '#1101#1090#1086' '#1085#1086#1084#1077#1088' '#1092#1086#1088#1084#1072#1090#1072' XXXX '#1085#1072' '#1074#1072#1096#1077#1084' '#1089#1080#1089#1090#1077#1084#1085#1086#1084 +
        ' '#1073#1083#1086#1082#1077', '#1082#1072#1082' '#1087#1088#1072#1074#1080#1083#1086' '#1094#1080#1092#1088#1072', '#1082#1086#1090#1086#1088#1072#1103' '#1085#1072#1095#1080#1085#1072#1077#1090#1089#1103' '#1089' 0:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      WordWrap = True
    end
    object cbLicense: TcxCheckBox
      Left = 16
      Top = 144
      Caption = #1051#1080#1094#1077#1085#1079#1080#1103' '#1085#1072' '#1055#1050
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
    end
  end
  object edMaskIdentifier: TcxMaskEdit
    Left = 16
    Top = 99
    ParentFont = False
    Properties.CharCase = ecUpperCase
    Properties.EditMask = '!AAAA;1;_'
    Properties.ValidationOptions = []
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    Text = '    '
    Width = 90
  end
end
