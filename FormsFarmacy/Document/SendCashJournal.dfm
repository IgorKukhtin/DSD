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
  inherited PrintHeaderCDS: TClientDataSet [2]
  end
  inherited PrintItemsCDS: TClientDataSet [3]
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
  inherited ActionList: TActionList [10]
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
        end
        item
          DataSet = PrintItemsCDS
        end>
    end
  end
  inherited MasterDS: TDataSource [11]
  end
  inherited MasterCDS: TClientDataSet [12]
  end
  inherited spSelect: TdsdStoredProc [13]
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
      end>
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [14]
  end
  inherited cxPropertiesStore: TcxPropertiesStore [15]
  end
  inherited BarManager: TdxBarManager [16]
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [17]
  end
  inherited PopupMenu: TPopupMenu [18]
  end
  inherited PeriodChoice: TPeriodChoice [19]
  end
  inherited RefreshDispatcher: TRefreshDispatcher [20]
  end
  inherited spMovementComplete: TdsdStoredProc [21]
  end
  inherited spMovementUnComplete: TdsdStoredProc [22]
  end
  inherited spMovementSetErased: TdsdStoredProc [23]
  end
  inherited FormParams: TdsdFormParams [24]
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
        Value = 'False'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc [25]
  end
end
