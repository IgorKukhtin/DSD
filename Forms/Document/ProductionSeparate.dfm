inherited ProductionSeparateForm: TProductionSeparateForm
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 124
    Height = 250
    TabOrder = 2
    ExplicitTop = 124
    ExplicitHeight = 250
    ClientRectBottom = 246
    inherited tsMain: TcxTabSheet
      ExplicitHeight = 224
      inherited cxGrid: TcxGrid
        Height = 224
        ExplicitHeight = 224
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
    inherited tsEntry: TcxTabSheet
      ExplicitHeight = 224
      inherited cxGridEntry: TcxGrid
        Height = 224
        ExplicitHeight = 224
        inherited cxGridEntryDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited cxGridChild: TcxGrid
    TabOrder = 4
  end
  inherited DataPanel: TPanel
    Height = 96
    ExplicitHeight = 96
    object cePartionGoods: TcxTextEdit
      Left = 214
      Top = 61
      TabOrder = 10
      Width = 270
    end
    object cxLabel10: TcxLabel
      Left = 214
      Top = 43
      Caption = #1055#1072#1088#1090#1080#1103
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionSeparate'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftBoolean
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftBoolean
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'PartionGoods'
        Value = ''
        Component = cePartionGoods
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
      end>
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ProductionSeparate'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Value = ''
        Component = cePartionGoods
        DataType = ftString
        ParamType = ptInput
      end>
  end
  inherited GuidesFrom: TdsdGuides
    Top = 8
  end
end
