inherited Report_Movement_DynamicsOrdersEICForm: TReport_Movement_DynamicsOrdersEICForm
  Caption = #1054#1090#1095#1077#1090' <'#1044#1080#1085#1072#1084#1080#1082#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1087#1086' '#1045#1048#1062'> '
  ClientHeight = 522
  ClientWidth = 889
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 905
  ExplicitHeight = 561
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 889
    Height = 463
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 889
    ExplicitHeight = 463
    ClientRectBottom = 463
    ClientRectRight = 889
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 889
      ExplicitHeight = 463
      inherited cxGrid: TcxGrid
        Top = 8
        Width = 889
        Height = 232
        ExplicitTop = 8
        ExplicitWidth = 889
        ExplicitHeight = 232
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.##'
              Kind = skAverage
            end
            item
              Format = ',0.##'
              Kind = skAverage
            end
            item
              Format = ',0.##'
              Kind = skAverage
            end
            item
              Format = ',0.##'
              Kind = skAverage
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0'
              Kind = skSum
              Column = CountNeBoley
            end
            item
              Format = ',0'
              Kind = skSum
              Column = CountAll
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0'
              Kind = skSum
              Column = CountTabletki
            end
            item
              Format = ',0'
              Kind = skSum
              Column = CountLiki24
            end
            item
              Format = ',0.##'
              Kind = skAverage
            end
            item
              Format = ',0.##'
              Kind = skAverage
            end
            item
              Format = ',0.##'
              Kind = skAverage
            end
            item
              Format = ',0.##'
              Kind = skAverage
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0'
              Kind = skSum
              Column = CountNeBoleyMobile
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
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
            Options.Editing = False
            Width = 100
          end
          object CountNeBoley: TcxGridDBColumn
            Caption = #1057#1072#1081#1090' "'#1053#1077' '#1073#1086#1083#1077#1081'"'
            DataBinding.FieldName = 'CountNeBoley'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1076#1077#1085#1100' ('#1096#1090')'
            Options.Editing = False
            Width = 104
          end
          object CountNeBoleyMobile: TcxGridDBColumn
            Caption = #1057#1072#1081#1090' "'#1053#1077' '#1073#1086#1083#1077#1081'" '#1084#1086#1073'.'#1087#1088'.'
            DataBinding.FieldName = 'CountNeBoleyMobile'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object CountTabletki: TcxGridDBColumn
            Caption = #1057#1072#1081#1090' "Tabletki"'
            DataBinding.FieldName = 'CountTabletki'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object CountLiki24: TcxGridDBColumn
            Caption = #1057#1072#1081#1090' "Liki24"'
            DataBinding.FieldName = 'CountLiki24'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object CountAll: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086
            DataBinding.FieldName = 'CountAll'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 240
        Width = 889
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        AutoSnap = True
        Control = grChart2
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 0
        Width = 889
        Height = 8
        AlignSplitter = salTop
        AutoSnap = True
        Control = cxGrid
      end
      object grChart2: TcxGrid
        Left = 0
        Top = 248
        Width = 889
        Height = 215
        Hint = #1044#1080#1085#1072#1084#1080#1082#1072
        Align = alBottom
        TabOrder = 3
        object cxGridDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 2
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup2: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object cxGridDBChartSeries10: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountAll'
            DisplayText = #1048#1090#1086#1075#1086
          end
          object cxGridDBChartSeries7: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountNeBoley'
            DisplayText = #1057#1072#1081#1090' "'#1053#1077' '#1073#1086#1083#1077#1081'"'
          end
          object cxGridDBChartSeries11: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountNeBoleyMobile'
            DisplayText = #1057#1072#1081#1090' "'#1053#1077' '#1073#1086#1083#1077#1081'" '#1084#1086#1073'.'#1087#1088'.'
          end
          object cxGridDBChartSeries8: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountTabletki'
            DisplayText = #1057#1072#1081#1090' "Tabletki"'
          end
          object cxGridDBChartSeries9: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountLiki24'
            DisplayText = #1057#1072#1081#1090' "Liki24"'
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBChartView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 889
    Height = 33
    ExplicitWidth = 889
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 26
      EditValue = 43009d
      ExplicitLeft = 26
    end
    inherited deEnd: TcxDateEdit
      Left = 141
      EditValue = 43009d
      TabOrder = 2
      ExplicitLeft = 141
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 117
      Caption = #1087#1086':'
      ExplicitLeft = 117
      ExplicitWidth = 20
    end
  end
  inherited ActionList: TActionList
    Left = 135
    Top = 231
    object actGridToExcel1: TdsdGridToExcel [1]
      Category = 'DSDLib'
      MoveParams = <>
      ExportType = cxegExportToHtml
      Grid = grChart2
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1044#1080#1072#1075#1088#1072#1084#1084#1099
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1048#1090#1086#1075#1080
      ImageIndex = 40
      ShortCut = 16472
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshOnMonth: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1052#1077#1089#1103#1094#1072#1084
      Hint = #1087#1086' '#1044#1085#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshOnDay: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1085#1103#1084
      Hint = #1087#1086' '#1044#1085#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_DynamicsOrdersEIC'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 160
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
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bb: TdxBarButton
      Action = actGridToExcel1
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actGridToExcel1
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 248
    Top = 216
  end
  inherited PopupMenu: TPopupMenu
    Left = 104
    Top = 216
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end>
    Left = 456
    Top = 72
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
      end>
    Left = 600
    Top = 48
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 48
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 64
    Top = 472
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 168
    Top = 472
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
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
    PropertiesCellList = <>
    Left = 248
    Top = 480
  end
end
