inherited SendCashSUNForm: TSendCashSUNForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1057#1059#1053'>'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 3
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ValueFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ValueTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = isPromo
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumPriceIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStorage
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PartionDateKindName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaUnitFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaUnitTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colIsErased
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStorageDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ValueFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ValueTo
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited IsClose: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited IsTop: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isFirst: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited isSecond: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited PartionDateKindName: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited CommentSendName: TcxGridDBColumn
            Properties.Buttons = <
              item
                Action = actChoiceCommentSend
                Default = True
                Kind = bkEllipsis
              end
              item
                Action = actClearCommentSend
                Kind = bkGlyph
              end>
          end
          inherited PriceIn: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited PriceWithVAT: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited Price: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited PriceUnitFrom: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited PriceUnitTo: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited SumPriceIn: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited SummaWithVAT: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited Summa: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited ConditionsKeepName: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited DateInsertChild: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited DateInsert: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited RemainsFrom: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited RemainsTo: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited ValueFrom: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited ValueTo: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited TechnicalRediscountInvNumber: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
          inherited TechnicalRediscountOperDate: TcxGridDBColumn
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
      inherited cxGrid1: TcxGrid
        inherited cxGridDBTableView1: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited DataPanel: TPanel
    TabOrder = 0
  end
  inherited ceChecked: TcxCheckBox
    TabOrder = 5
  end
  inherited PrintItemsCDS: TClientDataSet [4]
  end
  inherited PrintItemsSverkaCDS: TClientDataSet [5]
  end
  inherited spSelectPrint: TdsdStoredProc [6]
  end
  inherited GuidesFrom: TdsdGuides [7]
  end
  inherited GuidesTo: TdsdGuides [8]
  end
  inherited ActionList1: TActionList [9]
  end
  inherited ActionList2: TActionList [10]
  end
  inherited spMovementComplete: TdsdStoredProc [11]
  end
  inherited spInsert_Object_Price: TdsdStoredProc [12]
  end
  inherited spUpdate_isDeferred_Yes: TdsdStoredProc [13]
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
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
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_isDeferred_No: TdsdStoredProc [14]
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
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
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spInsert_Send_WriteRestFromPoint: TdsdStoredProc [15]
  end
  inherited DetailDCS: TClientDataSet [16]
  end
  inherited DetailDS: TDataSource [17]
  end
  inherited dsdDBViewAddOn1: TdsdDBViewAddOn [18]
  end
  inherited spSelect_MI_Child: TdsdStoredProc [19]
  end
  inherited GuidesPartionDateKind: TdsdGuides [20]
  end
  inherited spUpdate_SendOverdue: TdsdStoredProc [21]
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc [22]
  end
  inherited GuidesDriverSun: TdsdGuides [23]
  end
  inherited spUpdate_Movement_Received: TdsdStoredProc [24]
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReceived'
        Value = False
        Component = cbReceived
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisReceived'
        Value = False
        Component = cbReceived
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_Movement_Sent: TdsdStoredProc [25]
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSent'
        Value = False
        Component = cbSent
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSent'
        Value = False
        Component = cbSent
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_Movement_NotDisplaySUN: TdsdStoredProc [26]
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotDisplaySUN'
        Value = False
        Component = cbNotDisplaySUN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotDisplaySUN'
        Value = False
        Component = cbNotDisplaySUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spCreateLoss: TdsdStoredProc [27]
  end
  inherited spUpdate_Movement_Confirmed: TdsdStoredProc [28]
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisConfirmed'
        Value = False
        Component = FormParams
        ComponentItem = 'isConfirmed'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisConfirmed'
        Value = False
        Component = cbConfirmed
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outConfirmedText'
        Value = #1054#1078#1080#1076#1072#1077#1090' '#1087#1086#1076#1090#1074#1077#1088#1078#1076'.'
        Component = edConfirmed
        DataType = ftString
        MultiSelectSeparator = ','
      end>
  end
  inherited spUpdate_MovementItem_ContainerId: TdsdStoredProc [29]
  end
  inherited spMovementItem_ShowPUSH_Comment: TdsdStoredProc [30]
  end
  inherited spAddIncome: TdsdStoredProc [31]
  end
  inherited spErasedMIMasterDetail: TdsdStoredProc [32]
  end
  inherited spUnErasedMIMasterDetail: TdsdStoredProc [33]
  end
  inherited spUpdateSendLoss: TdsdStoredProc [34]
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSendLoss'
        Value = False
        Component = cbSendLoss
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited PopupMenu: TPopupMenu [35]
  end
  inherited FormParams: TdsdFormParams [36]
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
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
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
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 43681d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'LossID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isConfirmed'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContainerID'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAddNewLine'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeId'
        Value = 'False'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SetFocused'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
  end
  inherited StatusGuides: TdsdGuides [37]
  end
  inherited spChangeStatus: TdsdStoredProc [38]
  end
  inherited MasterCDS: TClientDataSet [39]
  end
  inherited spSelect: TdsdStoredProc [40]
  end
  inherited BarManager: TdxBarManager [41]
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn [42]
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn [43]
  end
  inherited cxPropertiesStore: TcxPropertiesStore [44]
  end
  inherited ActionList: TActionList [45]
    inherited actPartionGoodsChoiceForm: TOpenChoiceForm
      GuiParams = <
        item
          Name = 'inGoodsId'
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'PartionGoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageName'
          Component = MasterCDS
          ComponentItem = 'StorageName_Partion'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartion'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsOperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited actClearCommentSend: TdsdSetDefaultParams
      DefaultParams = <
        item
          Param.Value = Null
          Param.ComponentItem = 'CommentSendId'
          Param.MultiSelectSeparator = ','
          Value = Null
        end
        item
          Param.Value = Null
          Param.ComponentItem = 'CommentSendCode'
          Param.MultiSelectSeparator = ','
          Value = Null
        end
        item
          Param.Value = Null
          Param.ComponentItem = 'CommentSendName'
          Param.DataType = ftString
          Param.MultiSelectSeparator = ','
          Value = Null
        end>
    end
    inherited actSetFocused: TdsdSetFocusedAction
      ControlName.Value = ''
    end
    inherited actSendPartionDateChange: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'SendPartionDateChangeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource [46]
  end
  inherited spGet: TdsdStoredProc [47]
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 43681d
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 42951d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAuto'
        Value = False
        Component = edIsAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MCSPeriod'
        Value = 0.000000000000000000
        Component = edNumberSeats
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MCSDay'
        Value = 0.000000000000000000
        Component = edDay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Checked'
        Value = False
        Component = ceChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isComplete'
        Value = False
        Component = edisComplete
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionDateKindId'
        Value = ''
        Component = GuidesPartionDateKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionDateKindName'
        Value = ''
        Component = GuidesPartionDateKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSun'
        Value = False
        Component = cbSun
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDefSun'
        Value = False
        Component = cbDefSun
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSent'
        Value = False
        Component = cbSent
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReceived'
        Value = False
        Component = cbReceived
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DriverSunId'
        Value = ''
        Component = GuidesDriverSun
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DriverSunName'
        Value = ''
        Component = GuidesDriverSun
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotDisplaySUN'
        Value = False
        Component = cbNotDisplaySUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSun_v2'
        Value = False
        Component = cbSun_v2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberSeats'
        Value = 0.000000000000000000
        Component = edNumberSeats
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSUN_v3'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSUN_v4'
        Value = False
        Component = cbSUN_v4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVIP'
        Value = False
        Component = cbVIP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUrgently'
        Value = False
        Component = cbUrgently
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isConfirmed'
        Value = False
        Component = cbConfirmed
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConfirmedText'
        Value = #1054#1078#1080#1076#1072#1077#1090' '#1087#1086#1076#1090#1074#1077#1088#1078#1076'.'
        Component = edConfirmed
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBanFiscalSale'
        Value = False
        Component = cbisBanFiscalSale
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSendLoss'
        Value = False
        Component = cbSendLoss
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SetFocused'
        Value = Null
        Component = FormParams
        ComponentItem = 'SetFocused'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
  end
  inherited spInsertUpdateMovement: TdsdStoredProc [48]
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42951d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = False
        Component = ceChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisComplete'
        Value = False
        Component = edisComplete
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumberSeats'
        Value = 0.000000000000000000
        Component = edNumberSeats
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDriverSunId'
        Value = ''
        Component = GuidesDriverSun
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited GuidesFiller: TGuidesFiller [49]
  end
  inherited HeaderSaver: THeaderSaver [50]
  end
  inherited RefreshAddOn: TRefreshAddOn [51]
    DataSet = 'ClientDataSet'
  end
  inherited spErasedMIMaster: TdsdStoredProc [52]
  end
  inherited spUnErasedMIMaster: TdsdStoredProc [53]
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc [54]
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc [55]
  end
  inherited spGetTotalSumm: TdsdStoredProc [56]
  end
  inherited RefreshDispatcher: TRefreshDispatcher [57]
  end
  inherited PrintHeaderCDS: TClientDataSet [58]
    Left = 468
    Top = 185
  end
  inherited spGet_SendPartionDateChangeId: TdsdStoredProc
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'SendPartionDateChangeId'
        MultiSelectSeparator = ','
      end>
  end
end
