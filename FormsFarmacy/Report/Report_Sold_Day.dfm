inherited Report_Sold_DayForm: TReport_Sold_DayForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081')'
  ClientHeight = 575
  ClientWidth = 1129
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 1145
  ExplicitHeight = 614
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 48
    Width = 1129
    Height = 527
    TabOrder = 3
    ExplicitTop = 48
    ExplicitWidth = 1129
    ExplicitHeight = 527
    ClientRectBottom = 527
    ClientRectRight = 1129
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1055#1088#1086#1089#1090#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 1129
      ExplicitHeight = 503
      inherited cxGrid: TcxGrid
        Width = 1129
        Height = 276
        ExplicitWidth = 1129
        ExplicitHeight = 276
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
              Column = PlanAmount
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
              Column = DiffAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Column = PlanAmount
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Column = FactAmount
            end
            item
              Format = '+,0.00;-,0.00;0.00;'
              Kind = skSum
              Column = DiffAmount
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
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'PlanDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM.YYYY (DDD)'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 61
          end
          object UnitJuridical: TcxGridDBColumn
            Caption = #1070#1088#1083#1080#1094#1086
            DataBinding.FieldName = 'UnitJuridical'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 80
          end
          object ProvinceCityName: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085
            DataBinding.FieldName = 'ProvinceCityName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 109
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 154
          end
          object PlanAmount: TcxGridDBColumn
            Caption = #1055#1083#1072#1085
            DataBinding.FieldName = 'PlanAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
          end
          object PlanAmountAccum: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'PlanAmountAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
          end
          object FactAmount: TcxGridDBColumn
            Caption = #1060#1072#1082#1090
            DataBinding.FieldName = 'FactAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
          end
          object FactAmountAccum: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'FactAmountAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
          end
          object DiffAmount: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'DiffAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00;0.00;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
          end
          object DiffAmountAccum: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'DiffAmountAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00;0.00;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
          end
          object PercentMake: TcxGridDBColumn
            AlternateCaption = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
            Caption = '% '#1074#1099#1087'.'
            DataBinding.FieldName = 'PercentMake'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00%'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
          end
          object PercentMakeAccum: TcxGridDBColumn
            AlternateCaption = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1089' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077#1084
            Caption = '% '#1074#1099#1087'. '#1089' '#1085#1072#1082#1086#1087#1083'.'
            DataBinding.FieldName = 'PercentMakeAccum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00%'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = '% '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1089' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077#1084
            Width = 72
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 276
        Width = 1129
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
      end
      object grChart: TcxGrid
        Left = 0
        Top = 284
        Width = 1129
        Height = 219
        Align = alBottom
        TabOrder = 2
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramLine.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'plandate'
            DisplayText = #1044#1072#1090#1072
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
    end
    object tsPivot: TcxTabSheet
      Caption = #1057#1074#1086#1076#1085#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
      ImageIndex = 1
      object cxDBPivotGrid1: TcxDBPivotGrid
        Left = 0
        Top = 0
        Width = 1129
        Height = 503
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
        object pcolUnitJuridical: TcxDBPivotGridField
          AreaIndex = 3
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1070#1088#1083#1080#1094#1086
          DataBinding.FieldName = 'UnitJuridical'
          Visible = True
          UniqueName = #1070#1088#1083#1080#1094#1086
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
    Width = 1129
    Height = 22
    Visible = False
    ExplicitWidth = 1129
    ExplicitHeight = 22
    inherited deStart: TcxDateEdit
      Left = 159
      Top = 0
      ExplicitLeft = 159
      ExplicitTop = 0
    end
    inherited deEnd: TcxDateEdit
      Left = 19
      Top = 0
      ExplicitLeft = 19
      ExplicitTop = 0
      ExplicitWidth = 30
      Width = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 123
      Top = 1
      Caption = #1052#1077#1089#1103#1094':'
      ExplicitLeft = 123
      ExplicitTop = 1
      ExplicitWidth = 39
    end
    inherited cxLabel2: TcxLabel
      Left = 5
      Top = 1
      Caption = '-'
      ExplicitLeft = 5
      ExplicitTop = 1
      ExplicitWidth = 8
    end
    object cxLabel3: TcxLabel
      Left = 244
      Top = 1
      Caption = '  '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 334
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
  end
  inherited ActionList: TActionList
    inherited actGridToExcel: TdsdGridToExcel
      TabSheet = tsMain
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
    object actGridToExcelPivot: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = tsPivot
      MoveParams = <>
      Enabled = False
      Grid = cxDBPivotGrid1
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actNoStaticCodes: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1041#1077#1079' '#1089#1090#1072#1090#1080#1095#1077#1089#1082#1080#1093' '#1082#1086#1076#1086#1074
      Hint = #1055#1083#1072#1085' '#1076#1077#1083#1080#1090#1089#1103' '#1088#1072#1074#1085#1086#1084#1077#1088#1085#1086' '#1085#1072' '#1082#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1074' '#1084#1077#1089#1103#1094#1077
      ImageIndex = 76
      Value = True
      HintTrue = #1055#1083#1072#1085' '#1076#1077#1083#1080#1090#1089#1103' '#1088#1072#1074#1085#1086#1084#1077#1088#1085#1086' '#1085#1072' '#1082#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1074' '#1084#1077#1089#1103#1094#1077
      HintFalse = #1041#1077#1079' '#1089#1090#1072#1090#1080#1095#1077#1089#1082#1080#1093' '#1082#1086#1076#1086#1074
      CaptionTrue = #1041#1077#1079' '#1089#1090#1072#1090#1080#1095#1077#1089#1082#1080#1093' '#1082#1086#1076#1086#1074
      CaptionFalse = 'C '#1089#1090#1072#1090#1080#1095#1077#1089#1082#1080#1084#1080' '#1082#1086#1076#1072#1084#1080
      ImageIndexTrue = 76
      ImageIndexFalse = 79
    end
    object actSP: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1057' '#1091#1095#1077#1090#1086#1084' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
      Hint = #1057' '#1091#1095#1077#1090#1086#1084' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
      ImageIndex = 77
      Value = True
      HintTrue = #1057' '#1091#1095#1077#1090#1086#1084' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
      HintFalse = #1041#1077#1079' '#1091#1095#1077#1090#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
      CaptionTrue = #1057' '#1091#1095#1077#1090#1086#1084' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
      CaptionFalse = #1041#1077#1079' '#1091#1095#1077#1090#1072' '#1088#1077#1080#1084#1073#1091#1088#1089#1072#1094#1080#1080
      ImageIndexTrue = 77
      ImageIndexFalse = 80
    end
  end
  inherited MasterDS: TDataSource
    Top = 128
  end
  inherited MasterCDS: TClientDataSet
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_SoldDay'
    Params = <
      item
        Name = 'inMonth'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = 41395d
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQuasiSchedule'
        Value = Null
        Component = actQuasiSchedule
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNoStaticCodes'
        Value = Null
        Component = actNoStaticCodes
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSP'
        Value = Null
        Component = actSP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
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
          ItemName = 'bbGridToExcelPivot'
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
        end
        item
          Visible = True
          ItemName = 'bbNoStaticCodes'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = #1052#1077#1089#1103#1094
      Category = 0
      Hint = #1052#1077#1089#1103#1094
      Visible = ivAlways
      Control = cxLabel1
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = #1052#1077#1089#1103#1094
      Category = 0
      Hint = #1052#1077#1089#1103#1094
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
    object bbGridToExcelPivot: TdxBarButton
      Action = actGridToExcelPivot
      Category = 0
    end
    object dxBarControlContainerItem5: TdxBarControlContainerItem
      Caption = #1041#1077#1079' '#1089#1090#1072#1090#1080#1095#1077#1089#1082#1080#1093' '#1082#1086#1076#1086#1074
      Category = 0
      Hint = #1041#1077#1079' '#1089#1090#1072#1090#1080#1095#1077#1089#1082#1080#1093' '#1082#1086#1076#1086#1074
      Visible = ivAlways
    end
    object bbNoStaticCodes: TdxBarButton
      Action = actNoStaticCodes
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton1: TdxBarButton
      Action = actSP
      Category = 0
      PaintStyle = psCaptionGlyph
    end
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
        Component = deStart
      end>
    Left = 88
    Top = 176
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
    Left = 200
    Top = 120
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 168
  end
end
