object EnterBuyerForSiteForm: TEnterBuyerForSiteForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1096#1090#1088#1080#1093' '#1082#1086#1076#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1089#1072#1081#1090#1072
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
  OnClose = FormClose
  OnCreate = FormCreate
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
      Width = 287
      Height = 19
      Caption = #1042#1074#1077#1076#1080#1090#1077' '#1096#1090#1088#1080#1093#1082#1086#1076' '#1082#1072#1088#1090#1099' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103':'
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
    Properties.MaskKind = emkRegExpr
    Properties.EditMask = '\d?\d?\d?\d?\d?\d?\d?\d?\d?\d?\d?\d?\d'
    Properties.ValidationOptions = []
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    Width = 291
  end
  object spGet_BuyerForSiteId: TdsdStoredProc
    StoredProcName = 'gpGet_Object_BuyerForSiteId'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 21
  end
end
