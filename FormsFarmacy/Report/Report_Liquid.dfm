inherited Report_LiquidForm: TReport_LiquidForm
  Caption = #1054#1090#1095#1077#1090' '#1051#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080' '#1090#1086#1095#1082#1080
  ClientHeight = 579
  ClientWidth = 1275
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1291
  ExplicitHeight = 617
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 48
    Width = 1275
    Height = 531
    TabOrder = 3
    ExplicitTop = 48
    ExplicitWidth = 1275
    ExplicitHeight = 531
    ClientRectBottom = 531
    ClientRectRight = 1275
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1055#1088#1086#1089#1090#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 1275
      ExplicitHeight = 507
      inherited cxGrid: TcxGrid
        Width = 1275
        Height = 323
        ExplicitWidth = 1275
        ExplicitHeight = 323
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
              Column = StartSum
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
              Column = SummaIncome
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaSale
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = EndSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = StartSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaIncome
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaCheck
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaSendIn
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaSendOut
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaOrderExternal
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaOrderInternal
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaReturnIn
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Column = StartSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaIncome
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaSale
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = EndSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaCheck
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaSendIn
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaSendOut
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaOrderExternal
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaOrderInternal
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
              Column = clSummaReturnIn
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
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM.YYYY (DDD)'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 154
          end
          object StartSum: TcxGridDBColumn
            Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'StartSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object EndSum: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'EndSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object SummaIncome: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object clSummaCheck: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072' '#1085#1072' '#1082#1072#1089#1089#1077' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaSale: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072' ('#1076#1086#1082#1091#1084#1077#1085#1090') '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object clSummaSendIn: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1090#1086#1095#1082#1091' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaSendIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaSendOut: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1090#1086#1095#1082#1080' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaSendOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaDocSendIn: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1090#1086#1095#1082#1091' '#1074' '#1094#1077#1085#1072#1093' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'SummaDocSendIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaDocSendOut: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1090#1086#1095#1082#1080' '#1074' '#1094#1077#1085#1072#1093' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'SummaDocSendOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaOrderExternal: TcxGridDBColumn
            Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1077#1096#1085#1080#1077' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaOrderExternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaOrderInternal: TcxGridDBColumn
            Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaOrderInternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaDocOrderExternal: TcxGridDBColumn
            Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1077#1096#1085#1080#1077' '#1074' '#1094#1077#1085#1072#1093' '#1076#1086#1082'.'
            DataBinding.FieldName = 'SummaDocOrderExternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaDocOrderInternal: TcxGridDBColumn
            Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' '#1074' '#1094#1077#1085#1072#1093' '#1076#1086#1082'.'
            DataBinding.FieldName = 'SummaDocOrderInternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clSummaReturnIn: TcxGridDBColumn
            Caption = #1042#1080#1088#1090'. '#1089#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaReturnIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 323
        Width = 1275
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
      end
      object grChart: TcxGrid
        Left = 0
        Top = 331
        Width = 1275
        Height = 176
        Align = alBottom
        TabOrder = 2
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramColumn.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object dgUnit: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'unitname'
            DisplayText = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          end
          object serSummaIncome: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaIncome'
            DisplayText = #1055#1088#1080#1093#1086#1076
          end
          object serSummaCheck: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaCheck'
            DisplayText = #1055#1088#1086#1076#1072#1078#1072' '#1085#1072' '#1082#1072#1089#1089#1077' '
          end
          object serSummaSale: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSale'
            DisplayText = #1055#1088#1086#1076#1072#1078#1072' '#1076#1086#1082'.'
          end
          object serSummaOrderExternal: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaOrderExternal'
            DisplayText = #1047#1072#1103#1082#1080' '#1074#1085#1077#1096#1085#1080#1077
          end
          object serSummaOrderInternal: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaOrderInternal'
            DisplayText = #1047#1072#1103#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077
          end
          object serSummaSendIN: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSendIN'
            DisplayText = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1090#1086#1095#1082#1091
          end
          object serSummaSendOut: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaSendOut'
            DisplayText = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1090#1086#1095#1082#1080
          end
          object serSummaReturnIn: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaReturnIn'
            DisplayText = #1042#1086#1079#1074#1088#1072#1090
          end
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
    end
    object tsPivot: TcxTabSheet
      Caption = #1057#1074#1086#1076#1085#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
      ImageIndex = 1
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxDBPivotGrid1: TcxDBPivotGrid
        Left = 0
        Top = 0
        Width = 1053
        Height = 507
        Align = alClient
        DataSource = MasterDS
        Groups = <>
        OptionsView.RowGrandTotalWidth = 118
        TabOrder = 0
        object pcolPlanDate: TcxDBPivotGridField
          AreaIndex = 2
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'PlanDate'
          Visible = True
          UniqueName = #1044#1072#1090#1072
        end
        object pcolWeek: TcxDBPivotGridField
          AreaIndex = 0
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1053#1077#1076#1077#1083#1103
          DataBinding.FieldName = 'PlanDate'
          GroupInterval = giDateWeekOfYear
          Visible = True
          UniqueName = #1053#1077#1076#1077#1083#1103
        end
        object pcolUnitName: TcxDBPivotGridField
          Area = faRow
          AreaIndex = 0
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          Visible = True
          UniqueName = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        end
        object pcolPlanAmount: TcxDBPivotGridField
          Area = faData
          AreaIndex = 0
          AllowedAreas = [faFilter, faData]
          IsCaptionAssigned = True
          Caption = #1055#1083#1072#1085
          DataBinding.FieldName = 'PlanAmount'
          Visible = True
          UniqueName = #1055#1083#1072#1085
        end
        object pcolFactAmount: TcxDBPivotGridField
          Area = faData
          AreaIndex = 1
          AllowedAreas = [faFilter, faData]
          IsCaptionAssigned = True
          Caption = #1060#1072#1082#1090
          DataBinding.FieldName = 'FactAmount'
          Visible = True
          UniqueName = #1060#1072#1082#1090
        end
        object pcolDiffAmount: TcxDBPivotGridField
          Area = faData
          AreaIndex = 2
          AllowedAreas = [faFilter, faData]
          IsCaptionAssigned = True
          Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
          DataBinding.FieldName = 'DiffAmount'
          Visible = True
          UniqueName = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
        end
        object pcolDayOfWeek: TcxDBPivotGridField
          AreaIndex = 1
          IsCaptionAssigned = True
          Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
          DataBinding.FieldName = 'PlanDate'
          GroupInterval = giDateDayOfWeek
          Visible = True
          UniqueName = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1275
    Height = 22
    Visible = False
    ExplicitWidth = 1275
    ExplicitHeight = 22
    inherited deStart: TcxDateEdit
      Left = 127
      Top = 0
      EditValue = 42370d
      ExplicitLeft = 127
      ExplicitTop = 0
    end
    inherited deEnd: TcxDateEdit
      Left = 280
      Top = 0
      EditValue = 42371d
      ExplicitLeft = 280
      ExplicitTop = 0
      ExplicitWidth = 81
      Width = 81
    end
    inherited cxLabel1: TcxLabel
      Left = 64
      Top = 1
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072':'
      ExplicitLeft = 64
      ExplicitTop = 1
      ExplicitWidth = 56
    end
    inherited cxLabel2: TcxLabel
      Left = 13
      Top = 1
      Caption = '-'
      ExplicitLeft = 13
      ExplicitTop = 1
      ExplicitWidth = 8
    end
    object cxLabel3: TcxLabel
      Left = 388
      Top = 1
      Caption = '  '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 478
      Top = 0
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 289
    end
    object cxLabel4: TcxLabel
      Left = 217
      Top = 1
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072':'
    end
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 287
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
    object actQuasiSchedule: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1069#1084#1087#1080#1088#1080#1095#1077#1089#1082#1080#1081
      Hint = 
        #1055#1083#1072#1085' '#1088#1072#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1083#1080' '#1087#1088#1086#1076#1072#1078' '#1076#1085#1103' '#1079#1072' '#1087#1086 +
        #1089#1083#1077#1076#1085#1080#1077' 8 '#1085#1077#1076#1077#1083#1100
      ImageIndex = 40
      Value = False
      HintTrue = #1055#1083#1072#1085' '#1076#1077#1083#1080#1090#1089#1103' '#1088#1072#1074#1085#1086#1084#1077#1088#1085#1086' '#1085#1072' '#1082#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1074' '#1084#1077#1089#1103#1094#1077
      HintFalse = 
        #1055#1083#1072#1085' '#1088#1072#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1083#1080' '#1087#1088#1086#1076#1072#1078' '#1076#1085#1103' '#1079#1072' '#1087#1086 +
        #1089#1083#1077#1076#1085#1080#1077' 8 '#1085#1077#1076#1077#1083#1100
      CaptionTrue = #1056#1072#1074#1085#1086#1084#1077#1088#1085#1099#1081
      CaptionFalse = #1069#1084#1087#1080#1088#1080#1095#1077#1089#1082#1080#1081
      ImageIndexTrue = 35
      ImageIndexFalse = 40
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_LiquidDialogForm'
      FormNameParam.Value = 'TReport_LiquidDialogForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 42371d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
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
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Top = 128
  end
  inherited MasterCDS: TClientDataSet
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Liquid'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 42248d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = 41395d
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inQuasiSchedule'
        Value = Null
        Component = actQuasiSchedule
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Top = 128
  end
  inherited BarManager: TdxBarManager
    Top = 128
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
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'bbStart'
        end
        item
          Visible = True
          ItemName = 'bb122'
        end
        item
          Visible = True
          ItemName = 'bbEnd'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem4'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bbQuasiSchedule'
        end>
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1053#1072#1095'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbStart: TdxBarControlContainerItem
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1053#1072#1095'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = deStart
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = #1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Category = 0
      Hint = #1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Visible = ivAlways
      Control = cxLabel3
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Category = 0
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Visible = ivAlways
      Control = ceUnit
    end
    object bbQuasiSchedule: TdxBarButton
      Action = actQuasiSchedule
      Category = 0
    end
    object bb122: TdxBarControlContainerItem
      Caption = #1050#1086#1085' '#1076#1072#1090#1072
      Category = 0
      Hint = #1050#1086#1085' '#1076#1072#1090#1072
      Visible = ivAlways
      Control = cxLabel4
    end
    object bbEnd: TdxBarControlContainerItem
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1050#1086#1085'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = deEnd
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 584
  end
  inherited PopupMenu: TPopupMenu
    Top = 296
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 24
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
      end>
    Left = 88
    Top = 176
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
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
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 200
    Top = 120
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 200
    Top = 168
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 272
    Top = 168
  end
end
