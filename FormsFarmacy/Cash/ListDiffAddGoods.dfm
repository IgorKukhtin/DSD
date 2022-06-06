object ListDiffAddGoodsForm: TListDiffAddGoodsForm
  Left = 367
  Top = 319
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1072' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
  ClientHeight = 436
  ClientWidth = 588
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 48
    Height = 16
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 24
    Top = 99
    Width = 48
    Height = 16
    Caption = 'Label7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 24
    Top = 96
    Width = 48
    Height = 16
    Caption = 'Label5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 243
    Width = 588
    Height = 193
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 588
      Height = 65
      Align = alTop
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      object Label4: TLabel
        Left = 21
        Top = 36
        Width = 57
        Height = 13
        Caption = #1042#1080#1076' '#1086#1090#1082#1072#1079#1072
      end
      object Label6: TLabel
        Left = 24
        Top = 9
        Width = 194
        Height = 16
        Caption = #1064#1040#1043' 1. '#1042#1099#1073#1086#1088' '#1074#1080#1076#1072' '#1086#1090#1082#1072#1079#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object beDiffKind: TcxButtonEdit
        Left = 93
        Top = 33
        Properties.Buttons = <
          item
            Action = actShowListDiff
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 478
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 65
      Width = 588
      Height = 87
      Align = alClient
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 1
      object Label2: TLabel
        Left = 19
        Top = 37
        Width = 59
        Height = 13
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      end
      object Label8: TLabel
        Left = 24
        Top = 65
        Width = 39
        Height = 13
        Caption = 'Label8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label3: TLabel
        Left = 21
        Top = 88
        Width = 63
        Height = 13
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        Visible = False
      end
      object Label9: TLabel
        Left = 24
        Top = 6
        Width = 221
        Height = 16
        Caption = #1064#1040#1043' 2. '#1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ceAmount: TcxCurrencyEdit
        Left = 93
        Top = 34
        Margins.Left = 1
        Margins.Top = 1
        AutoSize = False
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        Properties.OnChange = ceAmountPropertiesChange
        TabOrder = 0
        Height = 21
        Width = 108
      end
      object meComent: TcxMaskEdit
        Left = 93
        Top = 85
        TabOrder = 1
        Visible = False
        Width = 478
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 152
      Width = 588
      Height = 41
      Align = alBottom
      Caption = 'Panel4'
      ShowCaption = False
      TabOrder = 2
      DesignSize = (
        588
        41)
      object bbCancel: TcxButton
        Left = 496
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 8
        TabOrder = 0
      end
      object bbOk: TcxButton
        Left = 397
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Ok'
        Default = True
        ModalResult = 1
        TabOrder = 1
      end
    end
  end
  object ListDiffCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 376
    Top = 72
  end
  object DiffKindCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 272
    Top = 16
  end
  object ListGoodsCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    StoreDefs = True
    Left = 272
    Top = 72
  end
  object ActionList: TActionList
    Left = 272
    Top = 144
    object actShowListDiff: TAction
      Caption = 'actShowListDiff'
      OnExecute = actShowListDiffExecute
    end
    object actCustomerThresho_RemainsGoodsCash: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actCustomerThresho_RemainsGoodsCash'
      FormName = 'TCustomerThresho_RemainsGoodsCashForm'
      FormNameParam.Value = 'TCustomerThresho_RemainsGoodsCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  object TimerStart: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerStartTimer
    Left = 496
    Top = 16
  end
  object CheckCDS: TClientDataSet
    Aggregates = <>
    Filter = 'Amount > 0'
    Filtered = True
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'CheckCDSIndex1'
      end>
    Params = <>
    StoreDefs = True
    Left = 496
    Top = 80
  end
  object spExistsRemainsGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_CustomerThresho_ExistsRemainsGoodsCash'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outThereIs'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 496
    Top = 144
  end
  object DiffKindPriceCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'DiffKindPriceCDSIndex1'
      end
      item
        Name = 'DiffKindPriceCDSIndex2'
      end
      item
        Name = 'DiffKindPriceCDSIndex3'
      end>
    IndexFieldNames = 'DiffKindId'
    Params = <>
    StoreDefs = True
    Left = 376
    Top = 16
  end
end
