inherited SendCashJournalForm: TSendCashJournalForm
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 0
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited spSelectPrint: TdsdStoredProc [4]
  end
  inherited PrintItemsSverkaCDS: TClientDataSet [5]
  end
  inherited spUpdate_Movement_OperDate: TdsdStoredProc [6]
  end
  inherited spUpdate_isDeferred_No: TdsdStoredProc [7]
  end
  inherited spUpdate_isDeferred_Yes: TdsdStoredProc [8]
  end
  inherited spUpdate_Movement_Received: TdsdStoredProc [9]
  end
  inherited spUpdate_Movement_Sent: TdsdStoredProc [10]
  end
  inherited spUpdate_isDefSun: TdsdStoredProc [11]
  end
  inherited spUpdate_isSun: TdsdStoredProc [12]
  end
  inherited spUnCompleteView: TdsdStoredProc [13]
  end
  inherited spUpdate_NotDisplaySUN_Yes: TdsdStoredProc [14]
  end
  inherited spComplete_Filter: TdsdStoredProc [15]
  end
  inherited spSetErased_Filter: TdsdStoredProc [16]
  end
  inherited FormParams: TdsdFormParams [17]
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSend'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSUN'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSUNAll'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVIP'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VIPType'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupByBox'
        Value = Null
        Component = cxGridDBTableView
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc [18]
  end
  inherited PrintHeaderCDS: TClientDataSet [19]
  end
  inherited PrintItemsCDS: TClientDataSet [20]
  end
  inherited RefreshDispatcher: TRefreshDispatcher [21]
  end
  inherited spMovementComplete: TdsdStoredProc [22]
    Params = <
      item
        Name = 'inmovementid'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCurrentData'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementUnComplete: TdsdStoredProc [23]
  end
  inherited spMovementSetErased: TdsdStoredProc [24]
  end
  inherited BarManager: TdxBarManager [25]
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [26]
  end
  inherited PopupMenu: TPopupMenu [27]
  end
  inherited PeriodChoice: TPeriodChoice [28]
  end
  inherited ActionList: TActionList [29]
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
    end
    inherited actPrintFilter: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxPDFExport_find'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxPDFExport1_ShowDialog'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'ExportDirectory'
          Value = Null
          Component = FormParams
          ComponentItem = 'FileDirectory'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FileNameExport'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrefixFileNameExport'
          Value = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    inherited actDataForTTNToXLS: TdsdExportToXLS
      ColumnParams = <
        item
          Caption = #1053#1072#1087#1088#1077#1074#1083#1077#1085#1080#1077
          FieldName = 'WayName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1081' '#1090#1086#1074#1072#1088#1072
          FieldName = 'GoodsCount'
          DataType = ftInteger
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1048#1090#1086#1075#1086', '#1096#1090
          FieldName = 'Amount'
          DataType = ftCurrency
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1057#1088'. '#1094#1077#1085#1072', '#1075#1088#1085'.'
          FieldName = 'Price'
          DataType = ftCurrency
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1048#1090#1086#1075#1086', '#1075#1088#1085'.'
          FieldName = 'Summ'
          DataType = ftCurrency
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
    end
    inherited actSendWayNameChoice: TOpenChoiceForm
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'WayNameId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'WayName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actWayTTNToXLS: TdsdExportToXLS
      FileNameParam.Value = ''
      ColumnParams = <
        item
          Caption = #1050#1086#1076
          FieldName = 'ObjectCode'
          DataType = ftInteger
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          FieldName = 'Name'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1048#1090#1086#1075#1086', '#1096#1090
          FieldName = 'Amount'
          DataType = ftCurrency
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1057#1088'. '#1094#1077#1085#1072', '#1075#1088#1085'.'
          FieldName = 'Price'
          DataType = ftCurrency
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1048#1090#1086#1075#1086', '#1075#1088#1085'.'
          FieldName = 'Summ'
          DataType = ftCurrency
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
    end
  end
  inherited MasterDS: TDataSource [30]
  end
  inherited MasterCDS: TClientDataSet [31]
  end
  inherited spSelect: TdsdStoredProc [32]
    StoredProcName = 'gpSelect_Movement_SendCash'
    Params = <
      item
        Name = 'instartdate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inenddate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSUN'
        Value = False
        Component = FormParams
        ComponentItem = 'isSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSUNAll'
        Value = Null
        Component = FormParams
        ComponentItem = 'isSUNAll'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisVIP'
        Value = False
        Component = FormParams
        ComponentItem = 'isVIP'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVIPType'
        Value = Null
        Component = FormParams
        ComponentItem = 'VIPType'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_Movement_DriverSun: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDriverSunId'
        Value = Null
        Component = FormParams
        ComponentItem = 'DriverSunId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spGet_Options: TdsdStoredProc
    Params = <
      item
        Name = 'GroupByBox'
        Value = 42005d
        Component = FormParams
        ComponentItem = 'GroupByBox'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
end
