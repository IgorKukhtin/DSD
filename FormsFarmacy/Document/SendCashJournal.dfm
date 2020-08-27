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
  inherited ActionList: TActionList
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
    end
  end
  inherited spSelect: TdsdStoredProc
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
  inherited spSelectPrint: TdsdStoredProc [8]
  end
  inherited PrintItemsSverkaCDS: TClientDataSet [9]
  end
  inherited spUpdate_Movement_OperDate: TdsdStoredProc [10]
  end
  inherited spUpdate_isDeferred_No: TdsdStoredProc [11]
    Params = <
      item
        Name = 'inId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isDeferred'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_isDeferred_Yes: TdsdStoredProc [12]
    Params = <
      item
        Name = 'inId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isDeferred'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_Movement_Received: TdsdStoredProc [13]
    Params = <
      item
        Name = 'inMovementId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReceived'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isReceived'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_Movement_Sent: TdsdStoredProc [14]
    Params = <
      item
        Name = 'inMovementId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSent'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isSent'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_isDefSun: TdsdStoredProc [15]
    Params = <
      item
        Name = 'inId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDefSUN'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isDefSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDefSUN'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isDefSUN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_isSun: TdsdStoredProc [16]
    Params = <
      item
        Name = 'inId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSUN'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSUN'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isSUN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUnCompleteView: TdsdStoredProc [17]
  end
  inherited spUpdate_NotDisplaySUN_Yes: TdsdStoredProc [18]
    Params = <
      item
        Name = 'inMovementId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotDisplaySUN'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isNotDisplaySUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spComplete_Filter: TdsdStoredProc [19]
  end
  inherited spSetErased_Filter: TdsdStoredProc [20]
  end
  inherited FormParams: TdsdFormParams [21]
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
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc [22]
  end
  inherited PrintHeaderCDS: TClientDataSet [23]
  end
  inherited PrintItemsCDS: TClientDataSet [24]
  end
  inherited RefreshDispatcher: TRefreshDispatcher [25]
  end
  inherited spMovementComplete: TdsdStoredProc [26]
  end
  inherited spMovementUnComplete: TdsdStoredProc [27]
  end
  inherited spMovementSetErased: TdsdStoredProc [28]
  end
  inherited BarManager: TdxBarManager [29]
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [30]
  end
  inherited PopupMenu: TPopupMenu [31]
  end
  inherited PeriodChoice: TPeriodChoice [32]
  end
end
