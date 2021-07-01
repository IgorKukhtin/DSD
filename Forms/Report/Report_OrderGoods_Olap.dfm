object Report_OrderGoods_OlapForm: TReport_OrderGoods_OlapForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1055#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1086#1082' ('#1054#1051#1040#1055')>'
  ClientHeight = 448
  ClientWidth = 977
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelHead: TPanel
    Left = 0
    Top = 0
    Width = 977
    Height = 55
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 83
      Top = 5
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 79
    end
    object deEnd: TcxDateEdit
      Left = 83
      Top = 29
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 79
    end
    object cxLabel1: TcxLabel
      Left = 12
      Top = 6
      Caption = #1055#1077#1088#1080#1086#1076' '#1089' ...'
    end
    object cxLabel2: TcxLabel
      Left = 5
      Top = 30
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086' ...'
      Height = 17
      Width = 76
    end
    object cxLabel3: TcxLabel
      Left = 170
      Top = 31
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnitGroup: TcxButtonEdit
      Left = 258
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 195
    end
    object cxLabel4: TcxLabel
      Left = 463
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 558
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 236
    end
    object cxLabel8: TcxLabel
      Left = 514
      Top = 30
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 558
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 236
    end
    object cbIsMovement: TcxCheckBox
      Left = 801
      Top = 5
      Caption = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      TabOrder = 10
      Width = 105
    end
    object cxLabel5: TcxLabel
      Left = 170
      Top = 6
      Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090':'
    end
    object edPriceList: TcxButtonEdit
      Left = 240
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 213
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 81
    Width = 977
    Height = 367
    Align = alClient
    DataSource = DataSource
    Groups = <>
    OptionsView.RowGrandTotalWidth = 456
    TabOrder = 1
    ExplicitLeft = 8
    object pvMonthDate: TcxDBPivotGridField
      Area = faColumn
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1052#1077#1089#1103#1094
      DataBinding.FieldName = 'MonthDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvInvNumber: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #8470' '#1076#1086#1082'.'
      DataBinding.FieldName = 'InvNumber'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvOperDate: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
      DataBinding.FieldName = 'OperDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsGroupName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsCode: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1090#1086#1074'.'
      DataBinding.FieldName = 'GoodsCode'
      Width = 50
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088
      DataBinding.FieldName = 'GoodsName'
      Visible = True
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvMeasureName: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1045#1076'. '#1080#1079#1084'.'
      DataBinding.FieldName = 'MeasureName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupNameFull: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
      DataBinding.FieldName = 'GoodsGroupNameFull'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupAnalystName: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
      DataBinding.FieldName = 'GoodsGroupAnalystName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvTradeMarkName: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      DataBinding.FieldName = 'TradeMarkName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsTagName: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsTagName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsPlatformName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
      DataBinding.FieldName = 'GoodsPlatformName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvAmount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'.'
      DataBinding.FieldName = 'Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072
      DataBinding.FieldName = 'Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvPrice: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvInfoMoneyCode: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055
      DataBinding.FieldName = 'InfoMoneyCode'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyGroupName: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyGroupName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyDestinationName: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'InfoMoneyDestinationName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName_all: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'InfoMoneyName_all'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 120
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 208
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = GuidesUnitGroup
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesGoods
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesGoodsGroup
        Properties.Strings = (
          'key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 256
    Top = 200
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 176
    Top = 216
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 200
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxDBPivotGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_OrderGoods_OlapDialogForm'
      FormNameParam.Value = 'TReport_OrderGoods_OlapDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate2'
          Value = Null
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate2'
          Value = Null
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMovement'
          Value = False
          Component = cbIsMovement
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_OrderGoods_Olap'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMovement'
        Value = Null
        Component = cbIsMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 304
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 544
    Top = 280
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 448
    Top = 336
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 472
    Top = 248
  end
  object PivotAddOn: TPivotAddOn
    ErasedFieldName = 'isErased'
    PivotGrid = cxDBPivotGrid
    OnDblClickActionList = <>
    ActionItemList = <>
    ColorRuleList = <>
    SummaryList = <>
    Left = 392
    Top = 272
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 360
    Top = 184
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 8
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 664
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
    Top = 27
  end
  object cfPrice: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPrice
    GridFields = <
      item
        Field = pvSumm
      end
      item
        Field = pvAmount
      end>
    CalcFieldsType = cfDivision
    Left = 656
    Top = 208
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 293
    Top = 6
  end
end
