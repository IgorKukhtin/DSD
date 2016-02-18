object RepriceUnitForm: TRepriceUnitForm
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
  ClientHeight = 540
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AllGoodsPriceGrid: TcxGrid
    Left = 0
    Top = 249
    Width = 864
    Height = 291
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 32
    ExplicitTop = 385
    object AllGoodsPriceGridTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsResult
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = '+,0.00 '#1075#1088#1085'; -,0.00 '#1075#1088#1085'; ;'
          Kind = skSum
          FieldName = 'RealSummReprice'
          Column = colMinExpirationDate
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = '+,0.00 '#1075#1088#1085'; -,0.00 '#1075#1088#1085'; ;'
          Kind = skSum
          FieldName = 'RealSummReprice'
          Column = colSumReprice
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
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
      object colMinMarginPercent: TcxGridDBColumn
        Caption = #1052#1080#1085'. % '#1088#1072#1079#1085#1080#1094#1099
        DataBinding.FieldName = 'MinMarginPercent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##'
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
        Width = 96
      end
      object colIsOneJuridical: TcxGridDBColumn
        Caption = #1054#1076#1080#1085' '#1087#1086#1089#1090'.'
        DataBinding.FieldName = 'isOneJuridical'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Editing = False
        Width = 40
      end
      object colJuridicalName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'JuridicalName'
        Options.Editing = False
        Width = 103
      end
      object colJuridical_Price: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1089' '#1053#1044#1057
        DataBinding.FieldName = 'Juridical_Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Options.Editing = False
        Width = 94
      end
      object colMarginPercent: TcxGridDBColumn
        Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1090#1086#1095#1082#1077
        DataBinding.FieldName = 'MarginPercent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##'
        Options.Editing = False
        Width = 92
      end
      object colJuridical_GoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        DataBinding.FieldName = 'Juridical_GoodsName'
        Options.Editing = False
        Width = 187
      end
      object colProducerName: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'ProducerName'
        Options.Editing = False
        Width = 103
      end
      object colSumReprice: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080
        DataBinding.FieldName = 'SumReprice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Options.Editing = False
        Width = 127
      end
      object colMinExpirationDate: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
        DataBinding.FieldName = 'MinExpirationDate'
        Options.Editing = False
        Width = 118
      end
      object colUnitId: TcxGridDBColumn
        DataBinding.FieldName = 'UnitId'
        Visible = False
        VisibleForCustomization = False
      end
      object colGoodsId: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        Visible = False
        VisibleForCustomization = False
      end
      object colJuridicalId: TcxGridDBColumn
        DataBinding.FieldName = 'JuridicalId'
        Visible = False
        VisibleForCustomization = False
        Width = 60
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
      object CheckListBox: TCheckListBox
        Left = 1
        Top = 1
        Width = 860
        Height = 211
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
      object Panel5: TPanel
        Left = 1
        Top = 212
        Width = 860
        Height = 26
        Align = alBottom
        TabOrder = 1
        ExplicitLeft = -1
        ExplicitTop = 236
        object lblProggres1: TLabel
          Left = 402
          Top = 0
          Width = 22
          Height = 13
          Alignment = taCenter
          Caption = '0 / 0'
        end
        object lblProggres2: TLabel
          Left = 496
          Top = 0
          Width = 22
          Height = 13
          Alignment = taCenter
          Caption = '0 / 0'
        end
        object SpeedButton1: TSpeedButton
          Left = 728
          Top = 0
          Width = 121
          Height = 24
          Action = dsdGridToExcel1
        end
        object btnSelectNewPrice: TButton
          Left = 233
          Top = 0
          Width = 91
          Height = 25
          Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
          TabOrder = 0
          OnClick = btnSelectNewPriceClick
        end
        object ProgressBar1: TProgressBar
          Left = 368
          Top = 13
          Width = 81
          Height = 10
          TabOrder = 1
        end
        object ProgressBar2: TProgressBar
          Left = 456
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
          Left = 592
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
    Left = 576
    Top = 384
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
    Top = 464
  end
  object ActionList1: TActionList
    Images = dmMain.ImageList
    Left = 88
    Top = 464
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
    object dsdGridToExcel1: TdsdGridToExcel
      MoveParams = <>
      Grid = AllGoodsPriceGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
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
        Name = 'MinMarginPercent'
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
      end
      item
        Name = 'JuridicalName'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Juridical_Price'
        DataType = ftCurrency
      end
      item
        Name = 'Juridical_GoodsName'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'MarginPercent'
        DataType = ftCurrency
      end
      item
        Name = 'ProducerName'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SumReprice'
        DataType = ftCurrency
      end
      item
        Name = 'MinExpirationDate'
        DataType = ftDate
      end
      item
        Name = 'isOneJuridical'
        DataType = ftBoolean
      end
      item
        Name = 'JuridicalId'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    OnCalcFields = cdsResultCalcFields
    Left = 168
    Top = 360
    Data = {
      B70200009619E0BD010000001800000016000000000003000000B70202496404
      0001000000000004436F6465040001000000000009476F6F64734E616D650200
      49000000010005574944544802000200FF00094C617374507269636508000400
      0000010007535542545950450200490006004D6F6E6579000C52656D61696E73
      436F756E74080004000000010007535542545950450200490006004D6F6E6579
      00034E4453080004000000010007535542545950450200490006004D6F6E6579
      000E45787069726174696F6E446174650400060000000000084E657750726963
      65080004000000010007535542545950450200490006004D6F6E657900104D69
      6E4D617267696E50657263656E74080004000000010007535542545950450200
      490006004D6F6E65790009507269636544696666080004000000010007535542
      545950450200490006004D6F6E65790007526570726963650200030000000000
      06556E69744964040001000000000008556E69744E616D650200490000000100
      05574944544802000200FF000D4A757269646963616C4E616D65010049000000
      01000557494454480200020064000F4A757269646963616C5F50726963650800
      04000000010007535542545950450200490006004D6F6E657900134A75726964
      6963616C5F476F6F64734E616D65010049000000010005574944544802000200
      FA000D4D617267696E50657263656E7408000400000001000753554254595045
      0200490006004D6F6E6579000C50726F64756365724E616D6501004900000001
      000557494454480200020064000A53756D526570726963650800040000000100
      07535542545950450200490006004D6F6E657900114D696E4578706972617469
      6F6E4461746504000600000000000E69734F6E654A757269646963616C020003
      00000000000B4A757269646963616C496404000100000000000000}
    object cdsResultId: TIntegerField
      FieldName = 'Id'
    end
    object cdsResultCode: TIntegerField
      FieldName = 'Code'
    end
    object cdsResultGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsResultLastPrice: TCurrencyField
      FieldName = 'LastPrice'
    end
    object cdsResultRemainsCount: TCurrencyField
      FieldName = 'RemainsCount'
    end
    object cdsResultNDS: TCurrencyField
      FieldName = 'NDS'
    end
    object cdsResultExpirationDate: TDateField
      FieldName = 'ExpirationDate'
    end
    object cdsResultNewPrice: TCurrencyField
      FieldName = 'NewPrice'
    end
    object cdsResultMarginPercent: TCurrencyField
      FieldName = 'MarginPercent'
    end
    object cdsResultPriceDiff: TCurrencyField
      FieldName = 'PriceDiff'
    end
    object cdsResultReprice: TBooleanField
      FieldName = 'Reprice'
    end
    object cdsResultUnitId: TIntegerField
      FieldName = 'UnitId'
    end
    object cdsResultUnitName: TStringField
      FieldName = 'UnitName'
      Size = 255
    end
    object cdsResultJuridicalName: TStringField
      FieldName = 'JuridicalName'
      Size = 100
    end
    object cdsResultJuridical_Price: TCurrencyField
      FieldName = 'Juridical_Price'
    end
    object cdsResultJuridical_GoodsName: TStringField
      FieldName = 'Juridical_GoodsName'
      Size = 250
    end
    object cdsResultProducerName: TStringField
      FieldName = 'ProducerName'
      Size = 100
    end
    object cdsResultSumReprice: TCurrencyField
      FieldName = 'SumReprice'
    end
    object cdsResultMinExpirationDate: TDateField
      FieldName = 'MinExpirationDate'
    end
    object cdsResultRealSummReprice: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'RealSummReprice'
      Calculated = True
    end
    object cdsResultMinMarginPercent: TCurrencyField
      FieldName = 'MinMarginPercent'
    end
    object cdsResultisOneJuridical: TBooleanField
      FieldName = 'isOneJuridical'
    end
    object cdsResultJuridicalId: TIntegerField
      FieldName = 'JuridicalId'
    end
  end
  object UnitsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 72
    Top = 8
  end
  object spInsertUpdate_MovementItem_Reprice: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Reprice'
    DataSets = <>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'ioID'
        Value = '0'
        ParamType = ptInputOutput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inExpirationDate'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inMinExpirationDate'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPriceOld'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPriceNew'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inJuridical_Price'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inGUID'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 100
    Left = 664
    Top = 96
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stRegistry
    Left = 360
    Top = 328
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 352
    Top = 384
  end
end
