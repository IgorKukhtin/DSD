inherited CashSettingsHistoryForm: TCashSettingsHistoryForm
  Caption = #1048#1089#1090#1086#1088#1080#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
  ClientHeight = 354
  ClientWidth = 733
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 751
  ExplicitHeight = 401
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 733
    Height = 327
    ExplicitTop = 27
    ExplicitWidth = 1169
    ExplicitHeight = 327
    ClientRectBottom = 327
    ClientRectRight = 733
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1169
      ExplicitHeight = 327
      inherited cxGrid: TcxGrid
        Width = 733
        Height = 327
        ExplicitWidth = 1169
        ExplicitHeight = 327
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = nil
          OptionsData.Deleting = False
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.BandHeaderHeight = 40
          Bands = <
            item
            end
            item
              Caption = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1083#1072#1085#1072#9
              Width = 266
            end
            item
              Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1086#1088#1086#1075#1072' '#1087#1083#1072#1085#1072' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
              Width = 185
            end
            item
            end>
          object StartDate: TcxGridDBBandedColumn
            Caption = #1057' '#1076#1072#1090#1099
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 104
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object FixedPercent: TcxGridDBBandedColumn
            Caption = #1050#1072#1090'. A'
            DataBinding.FieldName = 'FixedPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1083#1072#1085#1072#9
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object PenMobApp: TcxGridDBBandedColumn
            Caption = #1064#1090#1088#1072#1092' '#1079#1072' 1% '#1087#1083#1072#1085#1072' '#1087#1086' '#1084#1086#1073#1102' '#1087#1088#1077#1083#1086#1078'.'
            DataBinding.FieldName = 'PenMobApp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' '#1079#1072' 1% '#1085#1077#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1083#1072#1085#1072' '#1087#1086' '#1084#1086#1073#1080#1083#1100#1085#1086#1084#1091' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1102
            Width = 114
            Position.BandIndex = 3
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object PrizeThreshold: TcxGridDBBandedColumn
            Caption = #1055#1086' '#1087#1088#1077#1084#1080#1080
            DataBinding.FieldName = 'PrizeThreshold'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1086#1088#1086#1075#1072' '#1087#1086' '#1087#1088#1077#1084#1080#1080' '#1087#1088#1080' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1080' '#1087#1083#1072#1085#1072' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
            Width = 98
            Position.BandIndex = 2
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object MarkPlanThreshol: TcxGridDBBandedColumn
            Caption = #1047#1072' '#1074#1099#1095#1077#1090#1086#1084' '#1087#1088#1077#1084#1080#1080
            DataBinding.FieldName = 'MarkPlanThreshol'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
            Position.BandIndex = 2
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object FixedPercentB: TcxGridDBBandedColumn
            Caption = #1050#1072#1090'. B'
            DataBinding.FieldName = 'FixedPercentB'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object FixedPercentC: TcxGridDBBandedColumn
            Caption = #1050#1072#1090'. C'
            DataBinding.FieldName = 'FixedPercentC'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object FixedPercentD: TcxGridDBBandedColumn
            Caption = #1050#1072#1090'. D'
            DataBinding.FieldName = 'FixedPercentD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_ObjectHistory_CashSettings
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_ObjectHistory_CashSettings
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Top = 112
  end
  inherited MasterCDS: TClientDataSet
    Top = 112
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectHistory_CashSettings'
    Params = <
      item
        Name = 'inCashSettingsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashSettingsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Top = 112
    DockControlHeights = (
      0
      0
      27
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoice'
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBBandedTableView1
    Left = 176
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CashSettingsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 168
  end
  object spInsertUpdate_ObjectHistory_CashSettings: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_ObjectHistory_CashSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashSettingsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashSettingsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixedPercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixedPercent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixedPercentB'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixedPercentB'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixedPercentC'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixedPercentC'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixedPercentD'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixedPercentD'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPenMobApp'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PenMobApp'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrizeThreshold'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PrizeThreshold'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarkPlanThreshol'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MarkPlanThreshol'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 128
  end
end
