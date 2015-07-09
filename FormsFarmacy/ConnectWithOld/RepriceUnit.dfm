object RepriceUnitForm: TRepriceUnitForm
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
  ClientHeight = 594
  ClientWidth = 670
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
    Width = 670
    Height = 345
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 32
    ExplicitTop = 279
    ExplicitHeight = 307
    object AllGoodsPriceGridTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = QueryDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        Width = 289
      end
      object colRemainsCount: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'RemainsCount'
      end
      object colOldPrice: TcxGridDBColumn
        Caption = #1058#1077#1082#1091#1097#1072#1103' '#1094#1077#1085#1072
        DataBinding.FieldName = 'LastPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Width = 82
      end
      object colNewPrice: TcxGridDBColumn
        Caption = #1053#1086#1074#1072#1103' '#1094#1077#1085#1072
        DataBinding.FieldName = 'NewPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Width = 74
      end
      object colPercent: TcxGridDBColumn
        Caption = '% '#1080#1079#1084#1077#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'Percent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Width = 62
      end
      object colNDS: TcxGridDBColumn
        Caption = #1053#1044#1057
        DataBinding.FieldName = 'NDS'
        Width = 48
      end
      object colExpirationDate: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
        DataBinding.FieldName = 'ExpirationDate'
        Width = 77
      end
      object colNotReprice: TcxGridDBColumn
        AlternateCaption = #1053#1077' '#1087#1077#1088#1077#1086#1094#1077#1085#1080#1074#1072#1077#1090#1089#1103
        Caption = #1061
        DataBinding.FieldName = 'NotReprice'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = dmMain.ImageList
        Properties.Items = <
          item
            Description = #1053#1077' '#1087#1077#1088#1077#1086#1094#1077#1085#1080#1074#1072#1077#1090#1089#1103
            ImageIndex = 72
            Value = True
          end
          item
            Description = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1074#1072#1077#1090#1089#1103
            ImageIndex = 7
            Value = False
          end>
        Properties.ShowDescriptions = False
        HeaderHint = #1053#1077' '#1087#1077#1088#1077#1086#1094#1077#1085#1080#1074#1072#1077#1090#1089#1103
        Width = 22
      end
      object colNotRepriceNote: TcxGridDBColumn
        Caption = #1055#1088#1080#1095#1080#1085#1072
        DataBinding.FieldName = 'NotRepriceNote'
        Width = 207
      end
    end
    object AllGoodsPriceGridLevel: TcxGridLevel
      GridView = AllGoodsPriceGridTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 670
    Height = 241
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 40
    ExplicitWidth = 641
    object Panel2: TPanel
      Left = 298
      Top = 1
      Width = 371
      Height = 239
      Align = alRight
      TabOrder = 0
      ExplicitLeft = 312
      ExplicitTop = 64
      ExplicitWidth = 358
      ExplicitHeight = 171
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 369
        Height = 32
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 356
        object Button1: TButton
          Left = 224
          Top = 3
          Width = 116
          Height = 25
          Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100'  >>>'
          TabOrder = 0
          OnClick = Button1Click
        end
        object cePercentDifference: TcxCurrencyEdit
          Left = 104
          Top = 5
          EditValue = 30.000000000000000000
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          TabOrder = 1
          Width = 52
        end
        object cxLabel1: TcxLabel
          Left = 8
          Top = 6
          Caption = '% '#1088#1072#1079#1085#1080#1094#1099' '#1094#1077#1085#1099
        end
      end
      object Memo1: TMemo
        Left = 1
        Top = 33
        Width = 369
        Height = 205
        Align = alClient
        ReadOnly = True
        TabOrder = 1
        ExplicitLeft = 40
        ExplicitTop = -54
        ExplicitWidth = 318
        ExplicitHeight = 225
      end
    end
    object cxSplitter2: TcxSplitter
      Left = 292
      Top = 1
      Width = 6
      Height = 239
      AlignSplitter = salRight
      ExplicitLeft = 361
      ExplicitTop = -4
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 291
      Height = 239
      Align = alClient
      Caption = 'Panel4'
      TabOrder = 2
      ExplicitTop = 7
      ExplicitWidth = 224
      ExplicitHeight = 228
      object CheckListBox: TCheckListBox
        Left = 1
        Top = 1
        Width = 289
        Height = 210
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        ExplicitWidth = 291
        ExplicitHeight = 239
      end
      object Panel5: TPanel
        Left = 1
        Top = 211
        Width = 289
        Height = 27
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 210
        object Button2: TButton
          Left = 103
          Top = 2
          Width = 75
          Height = 25
          Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
          TabOrder = 0
          OnClick = Button2Click
        end
      end
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 241
    Width = 670
    Height = 8
    AlignSplitter = salTop
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
    Left = 184
    Top = 64
  end
  object UnitsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 56
  end
  object UnitsDS: TDataSource
    DataSet = UnitsCDS
    Left = 112
    Top = 128
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    OnCalcFields = ADOQueryCalcFields
    Parameters = <>
    Left = 120
    Top = 16
    object ADOQueryId: TIntegerField
      FieldName = 'Id'
    end
    object ADOQueryCode: TIntegerField
      FieldName = 'Code'
    end
    object ADOQueryGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object ADOQueryLastPrice: TFloatField
      FieldName = 'LastPrice'
    end
    object ADOQueryRemainsCount: TFloatField
      FieldName = 'RemainsCount'
    end
    object ADOQueryNewPrice: TFloatField
      FieldKind = fkCalculated
      FieldName = 'NewPrice'
      Calculated = True
    end
    object ADOQueryPercent: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Percent'
      Calculated = True
    end
    object ADOQueryNDS: TFloatField
      FieldKind = fkCalculated
      FieldName = 'NDS'
      Calculated = True
    end
    object ADOQueryExpirationDate: TDateField
      FieldKind = fkCalculated
      FieldName = 'ExpirationDate'
      Calculated = True
    end
    object ADOQueryNotReprice: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'NotReprice'
      Calculated = True
    end
    object ADOQueryNotRepriceNote: TStringField
      FieldKind = fkCalculated
      FieldName = 'NotRepriceNote'
      Size = 500
      Calculated = True
    end
    object ADOQueryCategoriesId: TIntegerField
      FieldName = 'CategoriesId'
    end
  end
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=sql;Persist Security Info=True;User ' +
      'ID=dba;Data Source=Kassa6DS'
    KeepConnection = False
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 184
    Top = 32
  end
  object spSelectPrice: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsPrice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsCode'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'GoodsCode'
        Value = Null
      end
      item
        Name = 'GoodsName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'NDS'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'NewPrice'
        Value = Null
        DataType = ftFloat
      end
      item
        Name = 'ExpirationDate'
        Value = Null
        DataType = ftDateTime
      end>
    PackSize = 1
    Left = 192
    Top = 120
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 184
  end
  object spInsertUpdate: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'dba.InsertUpdateLastPriceList'
    Parameters = <
      item
        Name = '@CategoriesId'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@LastPrice'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@GoodsPropertyID'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@StartDate'
        DataType = ftDateTime
        Value = Null
      end>
    Left = 280
    Top = 200
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
    Left = 432
    Top = 400
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
      end>
    PackSize = 1
    Left = 312
    Top = 408
  end
  object AllGoodsPriceCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 200
    Top = 432
  end
  object AllGoodPriceDS: TDataSource
    DataSet = AllGoodsPriceCDS
    Left = 120
    Top = 432
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
      end>
    Left = 192
    Top = 360
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 256
    Top = 312
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 192
    Top = 312
  end
  object ActionList1: TActionList
    Left = 120
    Top = 376
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
  object QueryDS: TDataSource
    DataSet = ResultCDS
    Left = 488
    Top = 176
  end
  object ResultCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 392
    Top = 128
  end
  object DataSetProvider: TDataSetProvider
    DataSet = ADOQuery
    Left = 488
    Top = 128
  end
end
