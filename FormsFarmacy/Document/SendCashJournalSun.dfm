inherited SendCashJournalSunForm: TSendCashJournalSunForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1057#1059#1053'>'
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
          inherited ProvinceCityName_From: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited ProvinceCityName_To: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
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
          inherited isSUN_v3: TcxGridDBColumn
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
          inherited isVIP: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isUrgently: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isConfirmed: TcxGridDBColumn
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
          inherited PartionDateKindName: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited lInsertName: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited lInsertDate: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited InsertDateDiff: TcxGridDBColumn
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
  inherited cxPropertiesStore: TcxPropertiesStore [2]
  end
  inherited BarManager: TdxBarManager [3]
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [4]
  end
  inherited MasterDS: TDataSource [5]
  end
  inherited MasterCDS: TClientDataSet [6]
  end
  inherited PopupMenu: TPopupMenu [7]
  end
  inherited PeriodChoice: TPeriodChoice [8]
  end
  inherited spSelect: TdsdStoredProc [9]
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
  inherited FormParams: TdsdFormParams [10]
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
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSUNAll'
        Value = True
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
  inherited spMovementReComplete: TdsdStoredProc [11]
  end
  inherited PrintHeaderCDS: TClientDataSet [12]
  end
  inherited spSelectPrint: TdsdStoredProc [13]
  end
  inherited PrintItemsSverkaCDS: TClientDataSet [14]
  end
  inherited spUpdate_Movement_OperDate: TdsdStoredProc [15]
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [16]
  end
  inherited spUpdate_isDeferred_No: TdsdStoredProc [17]
  end
  inherited spUpdate_isDeferred_Yes: TdsdStoredProc [18]
  end
  inherited spUpdate_Movement_Received: TdsdStoredProc [19]
  end
  inherited spUpdate_Movement_Sent: TdsdStoredProc [20]
  end
  inherited spUpdate_isDefSun: TdsdStoredProc [21]
  end
  inherited spUpdate_isSun: TdsdStoredProc [22]
  end
  inherited spUnCompleteView: TdsdStoredProc [23]
  end
  inherited spUpdate_NotDisplaySUN_Yes: TdsdStoredProc [24]
  end
  inherited spComplete_Filter: TdsdStoredProc [25]
  end
  inherited spSetErased_Filter: TdsdStoredProc [26]
  end
  inherited RefreshDispatcher: TRefreshDispatcher [27]
  end
  inherited spMovementComplete: TdsdStoredProc [28]
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
  inherited PrintItemsCDS: TClientDataSet [29]
  end
  inherited spMovementUnComplete: TdsdStoredProc [30]
  end
  inherited spMovementSetErased: TdsdStoredProc [31]
  end
  inherited ActionList: TActionList [32]
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSendCashSUNForm'
      FormNameParam.Value = 'TSendCashSUNForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSendCashSUNForm'
      FormNameParam.Value = 'TSendCashSUNForm'
    end
    inherited actDirectoryDialog: TFileDialogAction
      Param.Value = Null
    end
    inherited actDataToJson: TdsdDataToJsonAction
      JsonParam.Value = Null
    end
    inherited actWayTTNToXLS: TdsdExportToXLS
      FileNameParam.Value = ''
    end
  end
end
