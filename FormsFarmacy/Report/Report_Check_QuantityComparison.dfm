﻿inherited Report_Check_QuantityComparisonForm: TReport_Check_QuantityComparisonForm
  Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
  ClientHeight = 716
  ClientWidth = 984
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1000
  ExplicitHeight = 755
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 984
    Height = 633
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 984
    ExplicitHeight = 633
    ClientRectBottom = 633
    ClientRectRight = 984
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 984
      ExplicitHeight = 609
      inherited cxGrid: TcxGrid
        Width = 984
        Height = 219
        ExplicitWidth = 984
        ExplicitHeight = 219
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = nil
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0;-,0;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0;-,0;'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0;-,0;'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0;-,0; ;'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skAverage
              Column = AverageCheck
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
              Column = CountCash
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
              Column = CountCashLess
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skAverage
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.BandHiding = True
          OptionsCustomize.BandsQuickCustomization = True
          OptionsCustomize.ColumnVertSizing = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsSelection.InvertSelect = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Width = 262
            end
            item
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Visible = False
              Width = 120
            end>
          object UnitName: TcxGridDBBandedColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Options.Moving = False
            Width = 153
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object Color_calc: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Count: TcxGridDBBandedColumn
            Caption = '1'
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.Moving = False
            Options.VertSizing = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object AverageCheck: TcxGridDBBandedColumn
            Caption = '2'
            DataBinding.FieldName = 'AverageCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.Moving = False
            Options.VertSizing = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object CountCash: TcxGridDBBandedColumn
            Caption = '3'
            DataBinding.FieldName = 'CountCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.Moving = False
            Options.VertSizing = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object CountCashLess: TcxGridDBBandedColumn
            Caption = '4'
            DataBinding.FieldName = 'CountCashLess'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.Moving = False
            Options.VertSizing = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object PercentChange: TcxGridDBBandedColumn
            Caption = '5'
            DataBinding.FieldName = 'PercentChange'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+ ,0.##;- ,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.Moving = False
            Options.VertSizing = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
      object grChart: TcxGrid
        Left = 0
        Top = 227
        Width = 984
        Height = 187
        Align = alBottom
        TabOrder = 1
        object grChartDBChartView1: TcxGridDBChartView
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 3
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 219
        Width = 984
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
      end
      object grChartDay: TcxGrid
        Left = 0
        Top = 422
        Width = 984
        Height = 187
        Align = alBottom
        TabOrder = 3
        object grChartDBChartView2: TcxGridDBChartView
          DataController.DataSource = ChartDayDS
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 3
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object grChartDBChartView2DataGroup1: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object grChartDBChartView2Series1: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountChecks'
            DisplayText = #1058#1077#1082#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
          end
          object grChartDBChartView2Series2: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountChecksPrew'
            DisplayText = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = grChartDBChartView2
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 414
        Width = 984
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChartDay
      end
    end
    object tsDey: TcxTabSheet
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1076#1085#1103#1084
      ImageIndex = 0
      object cxGridDay: TcxGrid
        Left = 0
        Top = 0
        Width = 984
        Height = 609
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0;-,0;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0;-,0;'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0;-,0;'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        end
        object cxGridDBBandedTableView2: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDayDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0;-,0; ;'
              Kind = skSum
              Column = DeyCount
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skAverage
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skAverage
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.BandHiding = True
          OptionsCustomize.BandsQuickCustomization = True
          OptionsCustomize.ColumnVertSizing = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsSelection.InvertSelect = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Width = 262
            end
            item
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Visible = False
              VisibleForCustomization = False
              Width = 69
            end>
          object DeyUnitName: TcxGridDBBandedColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Options.Moving = False
            Width = 153
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object DeyCount: TcxGridDBBandedColumn
            Caption = '1'
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.Moving = False
            Options.VertSizing = False
            VisibleForCustomization = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBBandedTableView2
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 984
    Height = 57
    ExplicitWidth = 984
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 66
      ExplicitLeft = 66
      ExplicitWidth = 112
      Width = 112
    end
    inherited deEnd: TcxDateEdit
      Left = 263
      ExplicitLeft = 263
      ExplicitWidth = 107
      Width = 107
    end
    inherited cxLabel1: TcxLabel
      Caption = #1052#1077#1089#1103#1094' '#1089' :'
      ExplicitWidth = 50
    end
    inherited cxLabel2: TcxLabel
      Caption = #1052#1077#1089#1103#1094' '#1087#1086' :'
      ExplicitWidth = 57
    end
    object edRetail: TcxButtonEdit
      Left = 49
      Top = 28
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 240
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 29
      Caption = #1057#1077#1090#1100':'
    end
    object ceUnit: TcxButtonEdit
      Left = 389
      Top = 28
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 6
      Width = 305
    end
    object cxLabel4: TcxLabel
      Left = 295
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceYearsAgo: TcxCurrencyEdit
      Left = 549
      Top = 5
      EditValue = 1.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 8
      Width = 47
    end
    object cxLabel5: TcxLabel
      Left = 389
      Top = 6
      Caption = #1057#1088#1072#1074#1085#1080#1090#1100' '#1089' '#1095#1077#1082#1072#1084#1080' '#1083#1077#1090' '#1085#1072#1079#1072#1076
    end
  end
  object cbChartData: TcxComboBox [2]
    Left = 744
    Top = 120
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 166
  end
  object lblChartData: TcxLabel [3]
    Left = 616
    Top = 121
    Caption = #1044#1080#1072#1075#1088#1072#1084#1084#1072' '#1087#1086':'
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
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
        Component = RetailGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = actExpand
        Properties.Strings = (
          'Value')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_QuantityComparisonDialogForm'
      FormNameParam.Value = 'TReport_Check_QuantityComparisonDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = ''
          Component = RetailGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = ''
          Component = RetailGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'YearsAgo'
          Value = Null
          Component = ceYearsAgo
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGet_MovementFormClass: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_MovementFormClass'
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_MovementFormClass
        end
        item
          Action = actOpenDocument
        end>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 1
    end
    object actOpenDocument: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormNameParam.Name = 'FormClass'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormClass'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptInput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actExpand: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1090#1086#1083#1073#1080#1082#1086#1084
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1090#1086#1083#1073#1080#1082#1086#1084
      ImageIndex = 11
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1090#1088#1086#1082#1072#1084#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1090#1086#1083#1073#1080#1082#1086#1084
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1090#1088#1086#1082#1072#1084#1080
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1090#1086#1083#1073#1080#1082#1086#1084
      ImageIndexTrue = 12
      ImageIndexFalse = 11
    end
  end
  inherited MasterDS: TDataSource
    Left = 344
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 152
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_QuantityComparison'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = MultiplyCDS
      end
      item
        DataSet = ChartCDS
      end
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChartDayDataCDS
      end
      item
        DataSet = HeaderDayCDS
      end
      item
        DataSet = MultiplyDayCDS
      end
      item
        DataSet = ChartDayCDS
      end
      item
        DataSet = MasterDayCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inDateStart'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateFinal'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inYearsAgo'
        Value = Null
        Component = ceYearsAgo
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 128
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 184
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExpand'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
    object bbExpand: TdxBarButton
      Action = actExpand
      Category = 0
    end
    object dxBarContainerItem1: TdxBarContainerItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = lblChartData
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbChartData
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = nil
    OnDblClickActionList = <
      item
        Action = mactOpenDocument
      end>
    Left = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 88
    Top = 176
  end
  object FormParams: TdsdFormParams
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
      end>
    Left = 176
    Top = 264
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    Key = '0'
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = RetailGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 206
    Top = 14
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 24
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 440
    Top = 184
  end
  object CrossDBViewReportAddOn: TCrossDBViewReportAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <
      item
        ChartView = grChartDBChartView1
        DataGroupsFielddName = 'DateName'
        HeaderName = #1052#1077#1089#1103#1094
        HeaderFieldName = 'ValueChartName'
        ChartDataSet = ChartCDS
        SeriesName = 'SeriesName'
        SeriesFieldName = 'FieldName'
        DisplayedDataComboBox = cbChartData
        NameDisplayedDataFieldName = 'DisplayedDataName'
      end>
    ColorRuleList = <
      item
        ColorColumn = Count
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AverageCheck
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CountCash
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CountCashLess
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = PercentChange
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    MultiplyColumnList = <
      item
        FieldName = 'FieldNameCount'
        HeaderFieldName = 'HeaderFieldNameCount'
        Column = Count
      end
      item
        FieldName = 'FieldNameAverageCheck'
        HeaderFieldName = 'HeaderFieldNameAverageCheck'
        Column = AverageCheck
      end
      item
        FieldName = 'FieldNameCountCash'
        HeaderFieldName = 'HeaderFieldNameCountCash'
        Column = CountCash
      end
      item
        FieldName = 'FieldNameCountCashLess'
        HeaderFieldName = 'HeaderFieldNameCountCashLess'
        Column = CountCashLess
      end
      item
        FieldName = 'FieldNamePercentChange'
        HeaderFieldName = 'HeaderFieldNamePercentChange'
        Column = PercentChange
      end>
    MultiplyType = mtTop
    TemplateColumnList = <
      item
        HeaderColumnName = 'ValueName1'
        TemplateColumn = Count
      end
      item
        HeaderColumnName = 'ValueName2'
        TemplateColumn = AverageCheck
      end
      item
        HeaderColumnName = 'ValueName3'
        TemplateColumn = CountCash
      end
      item
        HeaderColumnName = 'ValueName4'
        TemplateColumn = CountCashLess
      end
      item
        HeaderColumnName = 'ValueName5'
        TemplateColumn = PercentChange
      end>
    HeaderDataSet = HeaderCDS
    MultiplyDataSet = MultiplyCDS
    BаndColumnName = 'ValueBandName'
    NoCrossColorColumn = True
    ActionExpand = actExpand
    Left = 568
    Top = 192
  end
  object MultiplyCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    Params = <>
    Left = 440
    Top = 256
  end
  object ChartCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'DEFAULT_ORDER'
      end
      item
        Name = 'CHANGEINDEX'
      end>
    Params = <>
    StoreDefs = True
    Left = 440
    Top = 328
  end
  object ChartDayDataCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'DEFAULT_ORDER'
      end
      item
        Name = 'CHANGEINDEX'
      end>
    IndexFieldNames = 'UnitId'
    MasterFields = 'UnitId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    Left = 440
    Top = 512
  end
  object ChartDayDS: TDataSource
    DataSet = ChartDayDataCDS
    Left = 552
    Top = 512
  end
  object MasterDayDS: TDataSource
    DataSet = MasterDayCDS
    Left = 552
    Top = 440
  end
  object MasterDayCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 440
    Top = 440
  end
  object MultiplyDayCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    Params = <>
    Left = 336
    Top = 512
  end
  object HeaderDayCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 440
  end
  object ChartDayCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'DEFAULT_ORDER'
      end
      item
        Name = 'CHANGEINDEX'
      end>
    Params = <>
    StoreDefs = True
    Left = 336
    Top = 584
  end
  object CrossDBViewReportAddOnDay: TCrossDBViewReportAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    MultiplyColumnList = <
      item
        FieldName = 'FieldNameCount'
        HeaderFieldName = 'HeaderFieldNameCount'
        Column = DeyCount
      end>
    MultiplyType = mtTop
    TemplateColumnList = <
      item
        HeaderColumnName = 'ValueName1'
        TemplateColumn = DeyCount
      end>
    HeaderDataSet = HeaderDayCDS
    MultiplyDataSet = MultiplyDayCDS
    BаndColumnName = 'ValueBandName'
    NoCrossColorColumn = True
    Left = 568
    Top = 280
  end
end
