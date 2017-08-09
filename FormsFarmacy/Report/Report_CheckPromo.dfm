inherited Report_CheckPromoForm: TReport_CheckPromoForm
  Caption = #1054#1090#1095#1077#1090' % ('#1089#1091#1084#1084#1099') '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1077#1078#1077#1084#1077#1089#1103#1095'.'#1084#1072#1088#1082#1077#1090' '#1087#1083#1072#1085#1072
  ClientHeight = 556
  ClientWidth = 841
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 857
  ExplicitHeight = 594
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 841
    Height = 499
    TabOrder = 3
    ExplicitWidth = 841
    ExplicitHeight = 499
    ClientRectBottom = 499
    ClientRectRight = 841
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 841
      ExplicitHeight = 499
      inherited cxGrid: TcxGrid
        Width = 841
        Height = 272
        ExplicitWidth = 841
        ExplicitHeight = 272
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = PlanAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = TotalAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = AmountPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = SummaPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
              Position = spFooter
              Column = DiffAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DiffAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PlanAmount
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
          object PlanDate: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094
            DataBinding.FieldName = 'PlanDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MMMM YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 144
          end
          object TotalAmount: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086', '#1096#1090'.'
            DataBinding.FieldName = 'TotalAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object TotalSumma: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086', '#1075#1088#1085'.'
            DataBinding.FieldName = 'TotalSumma'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object AmountPromo: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075'.)'
            DataBinding.FieldName = 'AmountPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 99
          end
          object SummaPromo: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075'.)'
            DataBinding.FieldName = 'SummaPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1086#1095#1077#1077')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1087#1088#1086#1095#1077#1077')'
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object PercentPromo: TcxGridDBColumn
            Caption = '% '#1074#1099#1087'.'
            DataBinding.FieldName = 'PercentPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00%;-,0.00%; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PlanAmount: TcxGridDBColumn
            Caption = '% '#1074#1099#1087'. '#1087#1086' '#1084#1072#1088#1082#1077#1090'.'
            DataBinding.FieldName = 'PlanAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091
            Options.Editing = False
            Width = 70
          end
          object DiffAmount: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072'  (% '#1074#1099#1087'. '#1084#1072#1088#1082#1077#1090'. - % '#1074#1099#1087'.)'
            DataBinding.FieldName = 'DiffAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00;0.00;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object PlanAmountAccum: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'PlanAmountAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
        end
      end
      object grChart: TcxGrid
        Left = 0
        Top = 280
        Width = 841
        Height = 219
        Align = alBottom
        TabOrder = 1
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramLine.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'plandate'
            DisplayText = #1052#1077#1089#1103#1094
          end
          object dgUnit: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'unitname'
            DisplayText = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          end
          object serTotalSumma: TcxGridDBChartSeries
            DataBinding.FieldName = 'TotalSumma'
            DisplayText = #1048#1090#1086#1075#1086', '#1075#1088#1085
          end
          object serSummaPromo: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaPromo'
            DisplayText = #1057#1091#1084#1084#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075'.)'
          end
          object serSumma: TcxGridDBChartSeries
            DataBinding.FieldName = 'Summa'
            DisplayText = #1057#1091#1084#1084#1072' ('#1087#1088#1086#1095#1077#1077')'
          end
          object serPercentPromo: TcxGridDBChartSeries
            DataBinding.FieldName = 'PercentPromo'
            DisplayText = '% '#1074#1099#1087'.'
          end
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 272
        Width = 841
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
      end
    end
  end
  inherited Panel: TPanel
    Width = 841
    ExplicitWidth = 841
    inherited deStart: TcxDateEdit
      EditValue = 42705d
      Properties.ReadOnly = True
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42735d
      Properties.ReadOnly = True
    end
  end
  inherited ActionList: TActionList
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
          Value = 42705d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42735d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 120
  end
  inherited MasterCDS: TClientDataSet
    Top = 120
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_Promo'
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
      end
      item
        Name = 'inIsFarm'
        Value = Null
        Component = FormParams
        ComponentItem = 'inIsFarm'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 120
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 120
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
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 408
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 408
    Top = 56
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inIsFarm'
        Value = ''
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 186
  end
end
