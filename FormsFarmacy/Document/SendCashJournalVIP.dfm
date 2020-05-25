inherited SendCashJournalVIPForm: TSendCashJournalVIPForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' VIP>'
  AddOnFormData.ExecuteDialogAction = nil
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 1
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
  inherited Panel: TPanel
    Visible = False
  end
  inherited FormParams: TdsdFormParams [2]
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
      end
      item
        Name = 'isVIP'
        Value = 'True'
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
  inherited spSelect: TdsdStoredProc [3]
  end
  inherited spMovementReComplete: TdsdStoredProc [4]
  end
  inherited PrintHeaderCDS: TClientDataSet [5]
  end
  inherited PrintItemsCDS: TClientDataSet [6]
  end
  inherited spSelectPrint: TdsdStoredProc [7]
  end
  inherited PrintItemsSverkaCDS: TClientDataSet [8]
  end
  inherited spUpdate_Movement_OperDate: TdsdStoredProc [9]
  end
  inherited spUpdate_isDeferred_No: TdsdStoredProc [10]
  end
  inherited spUpdate_isDeferred_Yes: TdsdStoredProc [11]
  end
  inherited spUpdate_Movement_Received: TdsdStoredProc [12]
  end
  inherited spUpdate_Movement_Sent: TdsdStoredProc [13]
  end
  inherited spUpdate_isDefSun: TdsdStoredProc [14]
  end
  inherited spUpdate_isSun: TdsdStoredProc [15]
  end
  inherited spUnCompleteView: TdsdStoredProc [16]
  end
  inherited spUpdate_NotDisplaySUN_Yes: TdsdStoredProc [17]
  end
  inherited spComplete_Filter: TdsdStoredProc [18]
  end
  inherited spSetErased_Filter: TdsdStoredProc [19]
  end
  inherited RefreshDispatcher: TRefreshDispatcher [20]
  end
  inherited spMovementComplete: TdsdStoredProc [21]
  end
  inherited spMovementUnComplete: TdsdStoredProc [22]
  end
  inherited spMovementSetErased: TdsdStoredProc [23]
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [24]
  end
  inherited ActionList: TActionList [25]
  end
  inherited cxPropertiesStore: TcxPropertiesStore [26]
  end
  inherited BarManager: TdxBarManager [27]
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [28]
  end
  inherited MasterDS: TDataSource [29]
  end
  inherited MasterCDS: TClientDataSet [30]
  end
  inherited PopupMenu: TPopupMenu [31]
  end
  inherited PeriodChoice: TPeriodChoice [32]
  end
end
