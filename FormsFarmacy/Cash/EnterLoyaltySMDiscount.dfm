object EnterLoyaltySMDiscountForm: TEnterLoyaltySMDiscountForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1073#1086#1085#1091#1089#1072#1084#1080' "'#1055#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1086#1081'"'
  ClientHeight = 231
  ClientWidth = 421
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
  object pn1: TPanel
    Left = 0
    Top = 0
    Width = 421
    Height = 81
    Align = alTop
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      421
      81)
    object Label1: TLabel
      Left = 16
      Top = 10
      Width = 68
      Height = 16
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edMaskName: TcxMaskEdit
      Left = 16
      Top = 32
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.ReadOnly = True
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 377
    end
  end
  object ButtonGroup1: TButtonGroup
    Left = 0
    Top = 81
    Width = 421
    Height = 150
    Align = alClient
    ButtonHeight = 48
    ButtonOptions = [gboFullSize, gboGroupStyle, gboShowCaptions]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    Items = <
      item
        Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077' '#1073#1086#1085#1091#1089#1099
      end
      item
        Caption = #1057#1085#1103#1090#1100' '#1073#1086#1085#1091#1089#1086#1074
      end
      item
        Caption = #1044#1072#1083#1100#1085#1077#1081#1096#1077#1077' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077
      end>
    TabOrder = 1
    OnButtonClicked = ButtonGroup1ButtonClicked
    OnClick = ButtonGroup1Click
    OnKeyDown = ButtonGroup1KeyDown
  end
  object ceDiscount: TcxCurrencyEdit
    Left = 264
    Top = 139
    EditValue = 0.000000000000000000
    ParentFont = False
    Properties.DisplayFormat = ',0.00;-,0.00'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 2
    OnKeyDown = ButtonGroup1KeyDown
    Width = 129
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
