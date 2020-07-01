inherited ProductionOrderReportForm: TProductionOrderReportForm
  Caption = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
  ClientHeight = 363
  ClientWidth = 806
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 822
  ExplicitHeight = 401
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 806
    Height = 304
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 806
    ExplicitHeight = 304
    ClientRectBottom = 304
    ClientRectRight = 806
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 806
      ExplicitHeight = 304
      inherited cxGrid: TcxGrid
        Width = 806
        Height = 304
        ExplicitWidth = 806
        ExplicitHeight = 304
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colGoodsName
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object ToName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 128
          end
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentVert = vaCenter
            Width = 47
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Width = 105
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object colGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentVert = vaCenter
          end
          object colMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object colMiddleOrderSumm: TcxGridDBColumn
            Caption = #1057#1088#1077#1076#1085#1103#1103' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'MiddleOrderSumm'
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object colRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colRemainsInDays: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1074' '#1076#1085#1103#1093
            DataBinding.FieldName = 'RemainsInDays'
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object colNotShippedOrder: TcxGridDBColumn
            Caption = #1053#1077#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1081' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'NotShippedOrder'
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object colTodayOrder: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' '#1089#1077#1075#1086#1076#1085#1103
            DataBinding.FieldName = 'TodayOrder'
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object colKoeff: TcxGridDBColumn
            Caption = #1050#1086#1101#1092#1092'. '#1089#1077#1079#1086#1085'.'
            DataBinding.FieldName = 'Koeff'
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 806
    Height = 33
    ExplicitWidth = 806
    ExplicitHeight = 33
    inherited deEnd: TcxDateEdit
      EditValue = 42075d
      Visible = False
    end
    inherited cxLabel2: TcxLabel
      Left = 751
      Top = 8
      Visible = False
      ExplicitLeft = 751
      ExplicitTop = 8
    end
    object cxLabel4: TcxLabel
      Left = 200
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 294
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 215
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ProductionOrderDialogForm'
      FormNameParam.Value = 'TReport_ProductionOrderDialogForm'
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
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
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
    Top = 112
  end
  inherited MasterCDS: TClientDataSet
    Top = 112
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionOrder'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
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
      26
      0)
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end>
    Top = 152
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
  end
end
