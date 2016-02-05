inherited Report_LiquidForm: TReport_LiquidForm
  Caption = #1054#1090#1095#1077#1090' '#1051#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080' '#1090#1086#1095#1082#1080
  ClientHeight = 575
  ClientWidth = 797
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 813
  ExplicitHeight = 613
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 48
    Width = 797
    Height = 527
    TabOrder = 3
    ExplicitTop = 48
    ExplicitWidth = 797
    ExplicitHeight = 527
    ClientRectBottom = 527
    ClientRectRight = 797
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1055#1088#1086#1089#1090#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 797
      ExplicitHeight = 503
      inherited cxGrid: TcxGrid
        Width = 797
        Height = 276
        ExplicitWidth = 797
        ExplicitHeight = 276
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
              Column = StartAmount
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
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Column = StartAmount
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Column = StartSum
            end
            item
              Format = '+,0.00;-,0.00;0.00;'
              Kind = skSum
              Column = SummaIncome
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
            Width = 61
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Width = 154
          end
          object StartAmount: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1085#1072#1095
            DataBinding.FieldName = 'StartAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object EndAmount: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1082#1086#1085
            DataBinding.FieldName = 'EndAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object StartSum: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072#1095
            DataBinding.FieldName = 'StartSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object EndSum: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1085
            DataBinding.FieldName = 'EndSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object SummaIncome: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076' '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083
            DataBinding.FieldName = 'SummaIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00;0.00;'
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 276
        Width = 797
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
      end
      object grChart: TcxGrid
        Left = 0
        Top = 284
        Width = 797
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
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxDBPivotGrid1: TcxDBPivotGrid
        Left = 0
        Top = 0
        Width = 797
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
    Width = 797
    Height = 22
    Visible = False
    ExplicitWidth = 797
    ExplicitHeight = 22
    inherited deStart: TcxDateEdit
      Left = 159
      Top = 0
      EditValue = 42248d
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
        Name = 'inMonth'
        Value = 41395d
        Component = deStart
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
