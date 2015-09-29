inherited ReportSoldParamsForm: TReportSoldParamsForm
  Caption = #1055#1083#1072#1085' '#1087#1088#1086#1076#1072#1078
  ClientWidth = 658
  ExplicitWidth = 674
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 658
    ExplicitWidth = 658
    ClientRectRight = 658
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 658
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 658
        ExplicitWidth = 658
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colPlanAmount
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colId: TcxGridDBColumn
            Caption = #1048#1044
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 28
          end
          object colUnitId: TcxGridDBColumn
            Caption = #1048#1044' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'UnitId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            VisibleForCustomization = False
          end
          object colUnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1050#1086#1076' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
            Options.Editing = False
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 367
          end
          object colPlanDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'PlanDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MMMM YYYY'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 109
          end
          object colPlanAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1083#1072#1085#1072
            DataBinding.FieldName = 'PlanAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.MinValue = True
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            Width = 85
          end
        end
      end
      object lblMonth: TcxLabel
        Left = 176
        Top = 67
        Caption = #1052#1077#1089#1103#1094':'
      end
      object dePlanDate: TcxDateEdit
        Left = 213
        Top = 67
        Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1083#1102#1073#1091#1102' '#1076#1072#1090#1091' '#1084#1077#1089#1103#1094#1072
        EditValue = 42274d
        Properties.AssignedValues.EditFormat = True
        Properties.DisplayFormat = 'MMMM YYYY'
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 2
        Width = 116
      end
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = dePlanDate
        Properties.Strings = (
          'Date')
      end>
  end
  inherited ActionList: TActionList
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1089' '#1087#1083#1072#1085#1072#1084#1080
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1089' '#1087#1083#1072#1085#1072#1084#1080
      ImageIndex = 62
      Value = True
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1089' '#1087#1083#1072#1085#1072#1084#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1089' '#1087#1083#1072#1085#1072#1084#1080
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actReportSoldParams: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Object_ReportSoldParams
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Object_ReportSoldParams
        end>
      Caption = 'dsdUpdateReportSoldParams'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReportSoldParams'
    Params = <
      item
        Name = 'inPlanDate'
        Value = Null
        Component = dePlanDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
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
          ItemName = 'bbChoice'
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
          ItemName = 'bclblMonth'
        end
        item
          Visible = True
          ItemName = 'bcdePlanDate'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bclblMonth: TdxBarControlContainerItem
      Caption = #1052#1077#1089#1103#1094
      Category = 0
      Hint = #1052#1077#1089#1103#1094
      Visible = ivAlways
      Control = lblMonth
    end
    object bcdePlanDate: TdxBarControlContainerItem
      Caption = #1052#1077#1089#1103#1094
      Category = 0
      Hint = #1052#1077#1089#1103#1094
      Visible = ivAlways
      Control = dePlanDate
    end
  end
  object rdDate: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = dePlanDate
      end>
    Left = 336
    Top = 88
  end
  object spInsertUpdate_Object_ReportSoldParams: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReportSoldParams'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'ioPlanDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PlanDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
      end
      item
        Name = 'inPlanAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PlanAmount'
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 200
    Top = 176
  end
end
