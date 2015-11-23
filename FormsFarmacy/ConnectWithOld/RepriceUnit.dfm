object RepriceUnitForm: TRepriceUnitForm
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
  ClientHeight = 594
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object AllGoodsPriceGrid: TcxGrid
    Left = 0
    Top = 249
    Width = 864
    Height = 345
    Align = alClient
    TabOrder = 0
    object AllGoodsPriceGridTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsResult
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      object colUnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        Visible = False
        GroupIndex = 0
        Options.Editing = False
        Width = 154
      end
      object colReprice: TcxGridDBColumn
        AlternateCaption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100
        Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100
        DataBinding.FieldName = 'Reprice'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderHint = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100
        Width = 22
      end
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        Options.Editing = False
        Width = 54
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        Options.Editing = False
        Width = 289
      end
      object colRemainsCount: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'RemainsCount'
        PropertiesClassName = 'TcxCalcEditProperties'
        Properties.DisplayFormat = ',0.000;-0.000; ;'
        Options.Editing = False
      end
      object colOldPrice: TcxGridDBColumn
        Caption = #1058#1077#1082#1091#1097#1072#1103' '#1094#1077#1085#1072
        DataBinding.FieldName = 'LastPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Options.Editing = False
        Width = 82
      end
      object colNewPrice: TcxGridDBColumn
        Caption = #1053#1086#1074#1072#1103' '#1094#1077#1085#1072
        DataBinding.FieldName = 'NewPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Options.Editing = False
        Width = 74
      end
      object colPercent: TcxGridDBColumn
        Caption = '% '#1080#1079#1084#1077#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'PriceDiff'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '+0.0%;-0.0%; ;'
        Options.Editing = False
        Width = 78
      end
      object colMarginPercent: TcxGridDBColumn
        Caption = #1052#1080#1085'. % '#1088#1072#1079#1085#1080#1094#1099
        DataBinding.FieldName = 'MarginPercent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.### %'
        Options.Editing = False
        Width = 92
      end
      object colNDS: TcxGridDBColumn
        Caption = #1053#1044#1057
        DataBinding.FieldName = 'NDS'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = '0.## %'
        Options.Editing = False
        Width = 43
      end
      object colExpirationDate: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
        DataBinding.FieldName = 'ExpirationDate'
        Options.Editing = False
        Width = 77
      end
    end
    object AllGoodsPriceGridLevel: TcxGridLevel
      GridView = AllGoodsPriceGridTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 241
    Align = alTop
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 862
      Height = 239
      Align = alClient
      Caption = 'Panel4'
      TabOrder = 0
      ExplicitWidth = 485
      object CheckListBox: TCheckListBox
        Left = 1
        Top = 1
        Width = 860
        Height = 211
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        ExplicitWidth = 483
      end
      object Panel5: TPanel
        Left = 1
        Top = 212
        Width = 860
        Height = 26
        Align = alBottom
        TabOrder = 1
        ExplicitWidth = 483
        object lblProggres1: TLabel
          Left = 514
          Top = 0
          Width = 22
          Height = 13
          Alignment = taCenter
          Caption = '0 / 0'
        end
        object lblProggres2: TLabel
          Left = 608
          Top = 0
          Width = 22
          Height = 13
          Alignment = taCenter
          Caption = '0 / 0'
        end
        object btnSelectNewPrice: TButton
          Left = 345
          Top = 0
          Width = 91
          Height = 25
          Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
          TabOrder = 0
          OnClick = btnSelectNewPriceClick
        end
        object ProgressBar1: TProgressBar
          Left = 480
          Top = 13
          Width = 81
          Height = 10
          TabOrder = 1
        end
        object ProgressBar2: TProgressBar
          Left = 568
          Top = 13
          Width = 93
          Height = 10
          TabOrder = 2
        end
        object cePercentDifference: TcxCurrencyEdit
          Left = 92
          Top = 3
          EditValue = 30.000000000000000000
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          TabOrder = 3
          Width = 29
        end
        object cxLabel1: TcxLabel
          Left = 0
          Top = 4
          Caption = '% '#1088#1072#1079#1085#1080#1094#1099' '#1094#1077#1085#1099
        end
        object btnReprice: TButton
          Left = 704
          Top = 0
          Width = 116
          Height = 25
          Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100'  >>>'
          TabOrder = 5
          OnClick = btnRepriceClick
        end
        object chbVAT20: TcxCheckBox
          Left = 127
          Top = 3
          Caption = #1053#1044#1057' 20%'
          TabOrder = 6
          Width = 82
        end
      end
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 241
    Width = 864
    Height = 8
    AlignSplitter = salTop
    Control = Panel1
  end
  object GetUnitsList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitForReprice'
    DataSet = UnitsCDS
    DataSets = <
      item
        DataSet = UnitsCDS
      end>
    Params = <>
    PackSize = 1
    Left = 24
    Top = 8
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = AllGoodsPriceGridTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 600
    Top = 520
  end
  object spSelect_AllGoodsPrice: TdsdStoredProc
    StoredProcName = 'gpSelect_AllGoodsPrice'
    DataSet = AllGoodsPriceCDS
    DataSets = <
      item
        DataSet = AllGoodsPriceCDS
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inMinPercent'
        Value = Null
        Component = cePercentDifference
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inVAT20'
        Value = Null
        Component = chbVAT20
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 48
    Top = 408
  end
  object AllGoodsPriceCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 360
  end
  object dsResult: TDataSource
    DataSet = cdsResult
    Left = 216
    Top = 360
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'UnitName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 24
    Top = 520
  end
  object ActionList1: TActionList
    Left = 88
    Top = 520
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetAfterExecute = True
      StoredProc = spSelect_AllGoodsPrice
      StoredProcList = <
        item
          StoredProc = spSelect_AllGoodsPrice
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object cdsResult: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'Code'
        DataType = ftInteger
      end
      item
        Name = 'GoodsName'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'LastPrice'
        DataType = ftCurrency
      end
      item
        Name = 'RemainsCount'
        DataType = ftCurrency
      end
      item
        Name = 'NDS'
        DataType = ftCurrency
      end
      item
        Name = 'ExpirationDate'
        DataType = ftDate
      end
      item
        Name = 'NewPrice'
        DataType = ftCurrency
      end
      item
        Name = 'MarginPercent'
        DataType = ftCurrency
      end
      item
        Name = 'PriceDiff'
        DataType = ftCurrency
      end
      item
        Name = 'Reprice'
        DataType = ftBoolean
      end
      item
        Name = 'UnitId'
        DataType = ftInteger
      end
      item
        Name = 'UnitName'
        DataType = ftString
        Size = 255
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 168
    Top = 360
    Data = {
      870100009619E0BD01000000180000000D000000000003000000870102496404
      0001000000000004436F6465040001000000000009476F6F64734E616D650200
      49000000010005574944544802000200FF00094C617374507269636508000400
      0000010007535542545950450200490006004D6F6E6579000C52656D61696E73
      436F756E74080004000000010007535542545950450200490006004D6F6E6579
      00034E4453080004000000010007535542545950450200490006004D6F6E6579
      000E45787069726174696F6E446174650400060000000000084E657750726963
      65080004000000010007535542545950450200490006004D6F6E6579000D4D61
      7267696E50657263656E74080004000000010007535542545950450200490006
      004D6F6E65790009507269636544696666080004000000010007535542545950
      450200490006004D6F6E6579000752657072696365020003000000000006556E
      69744964040001000000000008556E69744E616D650200490000000100055749
      44544802000200FF000000}
  end
  object UnitsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 72
    Top = 8
  end
  object spInsertUpdate_Object_Price: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Price_From_Excel'
    DataSets = <>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsCode'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inPriceValue'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 100
    Left = 664
    Top = 96
  end
end
