inherited Report_SheetWorkTime_GraphForm: TReport_SheetWorkTime_GraphForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1091#1087#1072#1082#1086#1074#1082#1077' - '#1089' '#1075#1088#1072#1092#1080#1082#1072#1084#1080'>'
  ClientHeight = 542
  ClientWidth = 966
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 982
  ExplicitHeight = 581
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 60
    Width = 966
    Height = 482
    TabOrder = 3
    ExplicitTop = 60
    ExplicitWidth = 966
    ExplicitHeight = 482
    ClientRectBottom = 482
    ClientRectRight = 966
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1054#1073#1097#1080#1077' '#1076#1072#1085#1085#1099#1077
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 966
      ExplicitHeight = 458
      inherited cxGrid: TcxGrid
        Width = 966
        Height = 458
        ExplicitWidth = 966
        ExplicitHeight = 458
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountHours
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPackage
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Weight_Send_out
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PersonalGroupName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountHours
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPackage
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Weight_Send_out
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object PersonalGroupName: TcxGridDBColumn
            Caption = #1041#1088#1080#1075#1072#1076#1072
            DataBinding.FieldName = 'PersonalGroupName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 246
          end
          object AmountHours: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'AmountHours'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object CountDay: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1084#1077#1085
            DataBinding.FieldName = 'CountDay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object CountPackage: TcxGridDBColumn
            Caption = #1055#1072#1082#1077#1090#1099' ('#1096#1090')'
            DataBinding.FieldName = 'CountPackage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object Weight_Send_out: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'Weight_Send_out'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 115
          end
        end
      end
    end
    object tsPivot: TcxTabSheet
      Caption = #1043#1088#1072#1092#1080#1082' 1'
      ImageIndex = 1
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 966
        Height = 458
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView1: TcxGridDBChartView
          DataController.DataSource = DSGraph1
          DiagramArea.Values.LineWidth = 2
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 2
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup1: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartSeries1: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPersonal'
            DisplayText = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1089#1086#1085#1072#1083#1072
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBChartView1
        end
      end
    end
    object tsDetail: TcxTabSheet
      Caption = #1043#1088#1072#1092#1080#1082' 2'
      ImageIndex = 1
      object cxGrid2: TcxGrid
        Left = 0
        Top = 0
        Width = 966
        Height = 458
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView2: TcxGridDBChartView
          DataController.DataSource = DSGraph1
          DiagramArea.Values.LineWidth = 2
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 2
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup2: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxAmount: TcxGridDBChartSeries
            DataBinding.FieldName = 'Amount'
            DisplayText = #1056#1072#1073#1086#1095#1080#1077' '#1095#1072#1089#1099
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBChartView2
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1043#1088#1072#1092#1080#1082' 3'
      ImageIndex = 3
      object cxGrid3: TcxGrid
        Left = 0
        Top = 0
        Width = 966
        Height = 458
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView3: TcxGridDBChartView
          DataController.DataSource = DSGraph3
          DiagramArea.Values.LineWidth = 2
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 2
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup3: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartCountPackage: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPackage'
            DisplayText = #1055#1072#1082#1077#1090#1099' ('#1096#1090')'
          end
          object cxGridDBChartWeightPackage: TcxGridDBChartSeries
            DataBinding.FieldName = 'WeightPackage'
            DisplayText = #1055#1072#1082#1077#1090#1099' ('#1042#1077#1089')'
          end
          object cxGridDBChartWeight_Send_out: TcxGridDBChartSeries
            DataBinding.FieldName = 'Weight_Send_out'
            DisplayText = #1056#1072#1089#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1074#1077#1089')'
          end
        end
        object cxGridLevel3: TcxGridLevel
          GridView = cxGridDBChartView3
        end
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1043#1088#1072#1092#1080#1082' 4'
      ImageIndex = 4
      object cxGrid5: TcxGrid
        Left = 0
        Top = 0
        Width = 966
        Height = 458
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView5: TcxGridDBChartView
          DataController.DataSource = DSGraph4
          DiagramArea.Values.LineWidth = 2
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 2
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup5: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartSeries4: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPackage'
            DisplayText = #1055#1072#1082#1077#1090#1099' ('#1096#1090') '#1041#1088#1080#1075#1072#1076#1072' '#1076#1088'.'
          end
          object cxGridDBChartSeries4_1: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPackage_1'
            DisplayText = #1055#1072#1082#1077#1090#1099' ('#1096#1090') '#1041#1088#1080#1075#1072#1076#1072' 1'
          end
          object cxGridDBChartSeries4_2: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPackage_2'
            DisplayText = #1055#1072#1082#1077#1090#1099' ('#1096#1090') '#1041#1088#1080#1075#1072#1076#1072' 2'
          end
          object cxGridDBChartSeries4_3: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPackage_3'
            DisplayText = #1055#1072#1082#1077#1090#1099' ('#1096#1090') '#1041#1088#1080#1075#1072#1076#1072' 3'
          end
          object cxGridDBChartSeries4_4: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPackage_4'
            DisplayText = #1055#1072#1082#1077#1090#1099' ('#1096#1090') '#1041#1088#1080#1075#1072#1076#1072' 4'
          end
          object cxGridDBChartSeries4_0: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPackage_0'
            DisplayText = #1055#1072#1082#1077#1090#1099' ('#1096#1090') '#1041#1088#1080#1075#1072#1076#1072' _'
          end
        end
        object cxGridLevel5: TcxGridLevel
          GridView = cxGridDBChartView5
        end
      end
    end
    object cxTabSheet3: TcxTabSheet
      Caption = #1043#1088#1072#1092#1080#1082' 5'
      ImageIndex = 5
      object cxGrid4: TcxGrid
        Left = 0
        Top = 0
        Width = 966
        Height = 458
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView4: TcxGridDBChartView
          DataController.DataSource = DSGraph4
          DiagramArea.Values.LineWidth = 2
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 2
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup4: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartSeries3: TcxGridDBChartSeries
            DataBinding.FieldName = 'Weight_Send_out'
            DisplayText = #1056#1072#1089#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1074#1077#1089') '#1041#1088#1080#1075#1072#1076#1072' '#1076#1088'.'
          end
          object cxGridDBChartSeries3_1: TcxGridDBChartSeries
            DataBinding.FieldName = 'Weight_Send_out_1'
            DisplayText = #1056#1072#1089#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1074#1077#1089') '#1041#1088#1080#1075#1072#1076#1072' 1'
          end
          object cxGridDBChartSeries3_2: TcxGridDBChartSeries
            DataBinding.FieldName = 'Weight_Send_out_2'
            DisplayText = #1056#1072#1089#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1074#1077#1089') '#1041#1088#1080#1075#1072#1076#1072' 2'
          end
          object cxGridDBChartSeries3_3: TcxGridDBChartSeries
            DataBinding.FieldName = 'Weight_Send_out_3'
            DisplayText = #1056#1072#1089#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1074#1077#1089') '#1041#1088#1080#1075#1072#1076#1072' 3'
          end
          object cxGridDBChartSeries3_4: TcxGridDBChartSeries
            DataBinding.FieldName = 'Weight_Send_out_4'
            DisplayText = #1056#1072#1089#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1074#1077#1089') '#1041#1088#1080#1075#1072#1076#1072' 4'
          end
          object cxGridDBChartSeries3_0: TcxGridDBChartSeries
            DataBinding.FieldName = 'Weight_Send_out_0'
            DisplayText = #1056#1072#1089#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1074#1077#1089') '#1041#1088#1080#1075#1072#1076#1072' _'
          end
        end
        object cxGridLevel4: TcxGridLevel
          GridView = cxGridDBChartView4
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 966
    Height = 34
    ExplicitWidth = 966
    ExplicitHeight = 34
    inherited deStart: TcxDateEdit
      Left = 59
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 59
    end
    inherited deEnd: TcxDateEdit
      Left = 219
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 219
    end
    inherited cxLabel1: TcxLabel
      Left = 12
      Caption = #1044#1072#1090#1072' '#1089' :'
      ExplicitLeft = 12
      ExplicitWidth = 45
    end
    inherited cxLabel2: TcxLabel
      Left = 165
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
      ExplicitLeft = 165
      ExplicitWidth = 52
    end
    object ceUnit: TcxButtonEdit
      Left = 415
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 256
    end
    object cxLabel4: TcxLabel
      Left = 321
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 312
  end
  inherited cxPropertiesStore: TcxPropertiesStore
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
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actGridToExcel: TdsdGridToExcel
      TabSheet = tsMain
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_SheetWorkTime_GraphDialogForm'
      FormNameParam.Value = 'TReport_SheetWorkTime_GraphDialogForm'
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
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NumLine'
        end
        item
          DataSet = ChildCDS
          UserName = 'frxDBDChild'
          IndexFieldNames = 'NumLine'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupGPName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportName'
          Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1072#1084' '#1087#1086' '#1076#1072#1090#1072#1084' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1055#1086' '#1054#1090#1075#1088#1091#1079#1082#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1055#1086' '#1054#1090#1075#1088#1091#1079#1082#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPivotToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = tsPivot
      MoveParams = <>
      Enabled = False
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actDetailToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = tsDetail
      MoveParams = <>
      Enabled = False
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_SheetWorkTime_Graph'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = CDSGraph1
      end
      item
        DataSet = CDSGraph3
      end
      item
        DataSet = CDSGraph4
      end>
    OutputType = otMultiDataSet
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
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 232
  end
  inherited BarManager: TdxBarManager
    Left = 184
    Top = 240
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bb: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPivotToExcel: TdxBarButton
      Action = actPivotToExcel
      Category = 0
    end
    object bbDetailToExcel: TdxBarButton
      Action = actDetailToExcel
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = ''
    Left = 24
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 288
    Top = 136
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 208
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 328
    Top = 170
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 624
    Top = 152
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 568
    Top = 152
  end
  object ChildDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 712
    Top = 136
  end
  object CDSGraph1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 656
    Top = 408
  end
  object DSGraph1: TDataSource
    DataSet = CDSGraph1
    Left = 592
    Top = 408
  end
  object DBViewAddOn_Graph1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 489
    Top = 384
  end
  object DSGraph2: TDataSource
    DataSet = CDSGraph2
    Left = 576
    Top = 216
  end
  object CDSGraph2: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 640
    Top = 216
  end
  object dsdDBViewAddOn_Graph2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 489
    Top = 224
  end
  object DBViewAddOn_Graph3: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 777
    Top = 208
  end
  object DSGraph3: TDataSource
    DataSet = CDSGraph3
    Left = 736
    Top = 264
  end
  object CDSGraph3: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 824
    Top = 256
  end
  object dsdDBViewAddOn_Graph4: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 481
    Top = 320
  end
  object DSGraph4: TDataSource
    DataSet = CDSGraph4
    Left = 568
    Top = 312
  end
  object CDSGraph4: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 632
    Top = 312
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_SheetWorkTimeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_SheetWorkTimeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 520
    Top = 5
  end
end
