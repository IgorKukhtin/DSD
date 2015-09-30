inherited Report_SoldForm: TReport_SoldForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078
  ClientHeight = 556
  ClientWidth = 841
  ExplicitWidth = 857
  ExplicitHeight = 594
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 841
    Height = 499
    TabOrder = 3
    ExplicitTop = 57
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
        ExplicitHeight = 291
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
              Column = colPlanAmount
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
              Column = FactAmount
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
              Column = colDiffAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Column = colPlanAmount
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Column = FactAmount
            end
            item
              Format = '+,0.00;-,0.00;0.00;'
              Kind = skSum
              Column = colDiffAmount
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
          object colPlanDate: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094
            DataBinding.FieldName = 'PlanDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MMMM YYYY'
            Width = 76
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Width = 144
          end
          object colPlanAmount: TcxGridDBColumn
            Caption = #1055#1083#1072#1085
            DataBinding.FieldName = 'PlanAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object colPlanAmountAccum: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'PlanAmountAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object FactAmount: TcxGridDBColumn
            Caption = #1060#1072#1082#1090
            DataBinding.FieldName = 'FactAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object colFactAmountAccum: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'FactAmountAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object colDiffAmount: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'DiffAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00;0.00;'
          end
          object colDiffAmountAccum: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'DiffAmountAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00;0.00;'
          end
          object colPercentMake: TcxGridDBColumn
            AlternateCaption = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
            Caption = '% '#1074#1099#1087'.'
            DataBinding.FieldName = 'PercentMake'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00%'
            HeaderHint = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
          end
          object colPercentMakeAccum: TcxGridDBColumn
            AlternateCaption = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1089' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077#1084
            Caption = '% '#1074#1099#1087'. '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'PercentMakeAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00%'
            HeaderHint = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1089' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077#1084
            Width = 72
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
          object serPlanAmount: TcxGridDBChartSeries
            DataBinding.FieldName = 'planamount'
            DisplayText = #1055#1083#1072#1085
          end
          object serPlanAmountAccum: TcxGridDBChartSeries
            DataBinding.FieldName = 'planamountaccum'
            DisplayText = #1055#1083#1072#1085' '#1089' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077#1084
          end
          object serFactAmount: TcxGridDBChartSeries
            DataBinding.FieldName = 'factamount'
            DisplayText = #1060#1072#1082#1090
          end
          object serFactAmountAccum: TcxGridDBChartSeries
            DataBinding.FieldName = 'factamountaccum'
            DisplayText = #1060#1072#1082#1090' '#1089' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077#1084
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
        ExplicitTop = 291
      end
    end
  end
  inherited Panel: TPanel
    Width = 841
    ExplicitWidth = 841
    inherited deStart: TcxDateEdit
      EditValue = 42248d
      Properties.ReadOnly = True
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42308d
      Properties.ReadOnly = True
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
    StoredProcName = 'gpSelect_Report_Sold'
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
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 408
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 408
    Top = 56
  end
end
