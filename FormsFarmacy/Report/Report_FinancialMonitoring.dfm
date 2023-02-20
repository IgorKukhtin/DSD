inherited Report_FinancialMonitoringForm: TReport_FinancialMonitoringForm
  Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1084#1086#1085#1080#1090#1086#1088#1080#1085#1075
  ClientHeight = 492
  ClientWidth = 776
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 794
  ExplicitHeight = 539
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 776
    Height = 435
    ExplicitWidth = 776
    ExplicitHeight = 435
    ClientRectBottom = 435
    ClientRectRight = 776
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1084#1086#1085#1080#1090#1086#1088#1080#1085#1075
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 776
      ExplicitHeight = 411
      inherited cxGrid: TcxGrid
        Width = 776
        Height = 73
        Align = alTop
        ExplicitWidth = 776
        ExplicitHeight = 73
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end>
          OptionsData.Editing = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object SummaSale: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1080' '
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 151
          end
          object SummaBankAccount: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1077#1078#1080
            DataBinding.FieldName = 'SummaBankAccount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 119
          end
          object SummaDelta: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'SummaDelta'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 132
          end
          object SaldoSum: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1085#1072' '#1082#1086#1085'. '#1087#1077#1088#1080#1086#1076#1072', '#1075#1088#1085'.'
            DataBinding.FieldName = 'SaldoSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object SummaNoPay: TcxGridDBColumn
            Caption = #1053#1077' '#1086#1087#1083#1072#1095#1077#1085#1086' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088'. '#1075#1088#1085'.'
            DataBinding.FieldName = 'SummaNoPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
        end
      end
      object cxGrid8: TcxGrid
        Left = 0
        Top = 73
        Width = 776
        Height = 338
        Align = alClient
        TabOrder = 1
        object cxGridDBChartView4: TcxGridDBChartView
          DataController.DataSource = ChartDS
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 3
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup3: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1055#1077#1088#1080#1086#1076
          end
          object cxGridDBChartSeries3: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale'
            DisplayText = #1055#1088#1086#1076#1072#1078#1080' '
            Styles.Values = cxStyle1
          end
          object cxGridDBChartView4Series1: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaBankAccount'
            DisplayText = #1055#1083#1072#1090#1077#1078#1080
            Styles.Values = cxStyle2
          end
          object cxGridDBChartView4Series2: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaDelta'
            DisplayText = #1056#1072#1079#1085#1080#1094#1072
            Styles.Values = cxStyle3
          end
        end
        object cxGridLevel4: TcxGridLevel
          GridView = cxGridDBChartView4
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1054#1089#1090#1072#1090#1082#1080
      ImageIndex = 1
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 776
        Height = 411
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView1: TcxGridDBChartView
          DataController.DataSource = ChartDS
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 3
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup1: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1055#1077#1088#1080#1086#1076
          end
          object cxGridDBChartSeries5: TcxGridDBChartSeries
            DataBinding.FieldName = 'SaldoSum'
            DisplayText = #1054#1089#1090#1072#1090#1086#1082
            Styles.Values = cxStyle1
          end
          object cxGridDBChartView1Series1: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaNoPay'
            DisplayText = #1053#1077' '#1086#1087#1083#1072#1095#1077#1085#1086
            Styles.Values = cxStyle2
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBChartView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 776
    ExplicitWidth = 776
    inherited deStart: TcxDateEdit
      EditValue = 42491d
      TabOrder = 1
    end
    inherited deEnd: TcxDateEdit
      Left = 316
      EditValue = 42491d
      TabOrder = 0
      ExplicitLeft = 316
    end
    inherited cxLabel1: TcxLabel
      Caption = #1044#1072#1090#1072' '#1088#1072#1089#1095#1077#1090#1072':'
      ExplicitWidth = 78
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 35
    Top = 296
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 167
    Top = 279
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGetForm'
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
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 280
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_FinancialMonitoring'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChartCDC
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 88
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
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' "'#1054#1074#1077#1088#1076#1088#1072#1092#1090'"'
      Category = 0
      Hint = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' "'#1054#1074#1077#1088#1076#1088#1072#1092#1090'"'
      Visible = ivAlways
      ImageIndex = 43
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    Left = 376
    Top = 96
  end
  inherited PopupMenu: TPopupMenu
    Left = 160
    Top = 208
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 136
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 344
    Top = 144
  end
  object ChartDS: TDataSource
    DataSet = ChartCDC
    Left = 264
    Top = 296
  end
  object ChartCDC: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 264
    Top = 225
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 512
    Top = 120
    PixelsPerInch = 120
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = clYellow
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor]
      Color = clRed
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor]
      Color = clGreen
    end
  end
end
