inherited SendMenegerVIPJournalForm: TSendMenegerVIPJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'  (VIP)>'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 2
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
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSendMenegerForm'
      FormNameParam.Value = 'TSendMenegerForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSendMenegerForm'
      FormNameParam.Value = 'TSendMenegerForm'
    end
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      ShortCut = 0
      DataSets = <
        item
          DataSet = PrintHeaderCDS
        end
        item
          DataSet = PrintItemsCDS
        end>
    end
    object actPrintNew: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ReportNameParam.Value = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actToGenerateCheck: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' VIP '#1095#1077#1082#1086#1074' '#1087#1086' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1085#1099#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1084
      ImageIndex = 30
      FormName = 'TSendVIP_ToGenerateCheckForm'
      FormNameParam.Value = 'TSendVIP_ToGenerateCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited spSelect: TdsdStoredProc
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
        Name = 'inisVip'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'inisVip'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_OperDateList'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDeferredYes'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDeferredNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbPrint: TdxBarButton
      Action = actPrintNew
    end
    object dxBarButton7: TdxBarButton
      Action = actToGenerateCheck
      Category = 0
    end
  end
  inherited FormParams: TdsdFormParams
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
        Name = 'inisVip'
        Value = 'True'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
end
