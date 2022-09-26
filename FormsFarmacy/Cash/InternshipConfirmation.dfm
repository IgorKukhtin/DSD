object InternshipConfirmationForm: TInternshipConfirmationForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' "'#1057#1090#1072#1078#1080#1088#1086#1074#1082#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1072'"'
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
    TabOrder = 1
    DesignSize = (
      381
      41)
    object bbOk: TcxButton
      Left = 72
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1044#1072
      ModalResult = 6
      TabOrder = 0
    end
    object cxButton1: TcxButton
      Left = 224
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1053#1077#1090
      ModalResult = 7
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
    TabOrder = 0
    object cxTextEdit1: TcxTextEdit
      Left = 40
      Top = 53
      ParentColor = True
      ParentFont = False
      Properties.AutoSelect = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsNone
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      StyleDisabled.BorderStyle = ebsNone
      StyleFocused.BorderStyle = ebsNone
      StyleHot.BorderStyle = ebsNone
      TabOrder = 0
      Text = #1057' '#1042#1072#1084#1080' '#1073#1099#1083#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1072' '#1089#1090#1072#1078#1080#1088#1086#1074#1082#1072'?'
      Width = 289
    end
  end
end
