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
          inherited TotalSumm: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited TotalSummMVAT: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited TotalSummPVAT: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited TotalSummFrom: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited TotalSummTo: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isAuto: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited Checked: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isComplete: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isSUN_v2: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isSUN_v3: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isSUN_v4: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isSUN: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isDefSUN: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isOverdueSUN: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isNotDisplaySUN: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited MCSPeriod: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited MCSDay: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited UpdateDateDiff: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited ReportInvNumber_full: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Visible = False
  end
  inherited spUpdate_isDefSun: TdsdStoredProc [2]
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
  inherited spUpdate_isSun: TdsdStoredProc [3]
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
  inherited spUnCompleteView: TdsdStoredProc [4]
  end
  inherited spUpdate_NotDisplaySUN_Yes: TdsdStoredProc [5]
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
  inherited spComplete_Filter: TdsdStoredProc [6]
  end
  inherited spSetErased_Filter: TdsdStoredProc [7]
  end
  inherited RefreshDispatcher: TRefreshDispatcher [8]
  end
  inherited spMovementComplete: TdsdStoredProc [9]
  end
  inherited spMovementUnComplete: TdsdStoredProc [10]
  end
  inherited spMovementSetErased: TdsdStoredProc [11]
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [12]
  end
  inherited ActionList: TActionList [13]
  end
  inherited cxPropertiesStore: TcxPropertiesStore [14]
  end
  inherited BarManager: TdxBarManager [15]
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [16]
  end
  inherited MasterDS: TDataSource [17]
  end
  inherited MasterCDS: TClientDataSet [18]
  end
  inherited PopupMenu: TPopupMenu [19]
  end
  inherited PeriodChoice: TPeriodChoice [20]
  end
  inherited spSelect: TdsdStoredProc [21]
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
  inherited FormParams: TdsdFormParams [22]
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
        Value = True
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
  inherited spMovementReComplete: TdsdStoredProc [23]
  end
  inherited PrintHeaderCDS: TClientDataSet [24]
  end
  inherited spSelectPrint: TdsdStoredProc [25]
  end
  inherited PrintItemsSverkaCDS: TClientDataSet [26]
  end
  inherited spUpdate_Movement_OperDate: TdsdStoredProc [27]
  end
  inherited PrintItemsCDS: TClientDataSet [28]
  end
  inherited spUpdate_isDeferred_No: TdsdStoredProc [29]
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
  inherited spUpdate_isDeferred_Yes: TdsdStoredProc [30]
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
  inherited spUpdate_Movement_Received: TdsdStoredProc [31]
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
  inherited spUpdate_Movement_Sent: TdsdStoredProc [32]
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
end
