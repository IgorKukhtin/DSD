object EnterLoyaltySaveMoneyForm: TEnterLoyaltySaveMoneyForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1086#1080#1089#1082' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1076#1083#1103' "'#1055#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1086#1081'"'
  ClientHeight = 209
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pn2: TPanel
    Left = 0
    Top = 168
    Width = 421
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
      421
      41)
    object bbCancel: TcxButton
      Left = 329
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
      Left = 236
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
    Width = 421
    Height = 168
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      421
      168)
    object Label1: TLabel
      Left = 48
      Top = 24
      Width = 212
      Height = 19
      Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 48
      Top = 93
      Width = 262
      Height = 19
      Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048#1084#1103' '#1054#1090#1095#1077#1089#1090#1074#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edMaskNumber: TcxMaskEdit
      Left = 48
      Top = 57
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.AutoSelect = False
      Properties.EditMask = '!\(999\)000-0000;1;_'
      Properties.OnValidate = edMaskNumberPropertiesValidate
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -19
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Text = '(   )   -    '
      Width = 331
    end
    object edMaskName: TcxMaskEdit
      Left = 48
      Top = 121
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 331
    end
  end
  object BuyerCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 296
    Top = 8
  end
  object spSelectObjectBuyer: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Buyer_Filter'
    DataSet = BuyerCDS
    DataSets = <
      item
        DataSet = BuyerCDS
      end>
    Params = <
      item
        Name = 'inPhone'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 169
    Top = 13
  end
end
