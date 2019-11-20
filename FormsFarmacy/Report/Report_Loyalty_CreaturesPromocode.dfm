inherited Report_Loyalty_CreaturesPromocodeForm: TReport_Loyalty_CreaturesPromocodeForm
  Caption = #1054#1090#1095#1077#1090' <'#1054#1090#1095#1105#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099'>'
  ClientHeight = 566
  ClientWidth = 720
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 736
  ExplicitHeight = 605
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 720
    Height = 509
    TabOrder = 3
    Properties.ActivePage = tsPivot
    ExplicitWidth = 720
    ExplicitHeight = 518
    ClientRectBottom = 509
    ClientRectRight = 720
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1055#1088#1086#1089#1090#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 720
      ExplicitHeight = 494
      inherited cxGrid: TcxGrid
        Width = 720
        Height = 287
        ExplicitWidth = 720
        ExplicitHeight = 288
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Position = spFooter
              Column = TotalSumm
            end
            item
              Format = ',0.00;-,0.00'
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PaymentSum
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
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = '+,0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PaymentSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
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
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM.YYYY (DDD)'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 109
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 260
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1055#1088#1086#1084#1086#1082#1086#1076#1086#1074' '#1085#1072' '#1089#1091#1084#1084#1091
            DataBinding.FieldName = 'SummaPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1075#1085#1086#1079' '#1085#1072' '#1086#1087#1083#1072#1090#1091
            Width = 127
          end
          object PaymentSum: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
            DataBinding.FieldName = 'CountPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 287
        Width = 720
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
        ExplicitTop = 288
      end
      object grChart: TcxGrid
        Left = 0
        Top = 295
        Width = 720
        Height = 190
        Align = alBottom
        TabOrder = 2
        ExplicitTop = 368
        object grChartDBChartView1: TcxGridDBChartView
          DataController.DataSource = MasterDS
          DiagramLine.Active = True
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object dgDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1044#1072#1090#1072
          end
          object dgUnit: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'UnitName'
            DisplayText = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          end
          object serSummaPromo: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaPromo'
            DisplayText = #1055#1088#1086#1084#1086#1082#1086#1076#1086#1074', '#1089#1091#1084#1084#1072
          end
          object serCountPromo: TcxGridDBChartSeries
            DataBinding.FieldName = 'CountPromo'
            DisplayText = #1055#1088#1086#1084#1086#1082#1086#1076#1086#1074', '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086
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
      ExplicitHeight = 494
      object cxDBPivotGrid1: TcxDBPivotGrid
        Left = 0
        Top = 0
        Width = 720
        Height = 485
        Align = alClient
        DataSource = MasterDS
        Groups = <>
        OptionsView.RowGrandTotalWidth = 308
        TabOrder = 0
        ExplicitHeight = 494
        object pcolOperDate: TcxDBPivotGridField
          Area = faRow
          AreaIndex = 0
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'OperDate'
          Visible = True
          UniqueName = #1044#1072#1090#1072
        end
        object pcolWeek: TcxDBPivotGridField
          AreaIndex = 0
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1053#1077#1076#1077#1083#1103
          DataBinding.FieldName = 'OperDate'
          GroupInterval = giDateWeekOfYear
          Visible = True
          UniqueName = #1053#1077#1076#1077#1083#1103
        end
        object pcolUnitName: TcxDBPivotGridField
          Area = faColumn
          AreaIndex = 0
          AllowedAreas = [faColumn, faRow, faFilter]
          IsCaptionAssigned = True
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          MinWidth = 40
          Visible = True
          UniqueName = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        end
        object pcolSummaPromo: TcxDBPivotGridField
          Area = faData
          AreaIndex = 0
          AllowedAreas = [faFilter, faData]
          IsCaptionAssigned = True
          Caption = #1055#1088#1086#1084#1086#1082#1086#1076#1086#1074' '#1085#1072' '#1089#1091#1084#1084#1091
          DataBinding.FieldName = 'SummaPromo'
          Visible = True
          UniqueName = #1060#1072#1082#1090
        end
        object pcoCountPromo: TcxDBPivotGridField
          Area = faData
          AreaIndex = 1
          AllowedAreas = [faFilter, faData]
          IsCaptionAssigned = True
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
          DataBinding.FieldName = 'CountPromo'
          Visible = True
          UniqueName = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 720
    ExplicitWidth = 720
    inherited deStart: TcxDateEdit
      Left = 83
      Top = 3
      EditValue = 42614d
      ExplicitLeft = 83
      ExplicitTop = 3
    end
    inherited deEnd: TcxDateEdit
      Left = 239
      Top = 3
      EditValue = 42614d
      ExplicitLeft = 239
      ExplicitTop = 3
      ExplicitWidth = 86
      Width = 86
    end
    inherited cxLabel1: TcxLabel
      Left = 27
      Top = 4
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072':'
      ExplicitLeft = 27
      ExplicitTop = 4
      ExplicitWidth = 56
    end
    inherited cxLabel2: TcxLabel
      Left = 182
      Top = 4
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072':'
      ExplicitLeft = 182
      ExplicitTop = 4
      ExplicitWidth = 56
    end
    object cxLabel3: TcxLabel
      Left = 346
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 440
      Top = 3
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1102#1088'.'#1083#1080#1094#1086'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 271
    end
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
      Enabled = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
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
      Grid = cxDBPivotGrid1
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
      FormName = 'TReport_LoyaltyDialogForm'
      FormNameParam.Value = 'TReport_LoyaltyDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42614d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42614d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
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
  end
  inherited MasterDS: TDataSource
    Left = 264
    Top = 264
  end
  inherited MasterCDS: TClientDataSet
    Left = 208
    Top = 280
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Loyalty_CreaturesPromocode'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
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
        Value = 'NULL'
        Component = deEnd
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
      end>
    Left = 256
    Top = 192
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 176
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
          ItemName = 'bbGridToExcelPivot'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 24
    Top = 200
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = deStart
      end>
    Left = 88
    Top = 208
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
    Left = 536
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 24
    Top = 144
  end
end
