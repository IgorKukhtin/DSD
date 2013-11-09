inherited SendTicketFuelForm: TSendTicketFuelForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086')>'
  ClientWidth = 701
  ExplicitWidth = 717
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 701
    ExplicitWidth = 701
    ClientRectRight = 701
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 701
      inherited cxGrid: TcxGrid
        Width = 701
        ExplicitWidth = 701
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colName: TcxGridDBColumn [1]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object colFuelName: TcxGridDBColumn [2]
            Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
            DataBinding.FieldName = 'FuelName'
            Width = 80
          end
          object colAmount: TcxGridDBColumn [3]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
        end
      end
    end
    inherited tsEntry: TcxTabSheet
      ExplicitWidth = 701
      inherited cxGridEntry: TcxGrid
        Width = 701
        ExplicitWidth = 701
        inherited cxGridEntryDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 701
    ExplicitWidth = 701
    object cxLabel3: TcxLabel
      Left = 380
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086' ('#1057#1086#1090#1088#1091#1076#1085#1080#1082')'
    end
    object edFrom: TcxButtonEdit
      Left = 380
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 150
    end
    object cxLabel4: TcxLabel
      Left = 540
      Top = 5
      Caption = #1050#1086#1084#1091' ('#1057#1086#1090#1088#1091#1076#1085#1080#1082')'
    end
    object edTo: TcxButtonEdit
      Left = 540
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Width = 150
    end
  end
  inherited ActionList: TActionList
    inherited actNewDocument: TdsdInsertUpdateAction
      FormName = 'TSendTicketFuelForm'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Send'
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'FromId'
        Value = ''
        Component = FromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'FromName'
        Value = ''
        Component = FromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ToId'
        Value = ''
        Component = ToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = ToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Send'
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
        DataType = ftString
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
        Component = FromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
  end
  inherited RefreshAddOn: TRefreshAddOn
    FormName = 'SendTicketFuelJournalForm'
    DataSet = 'MainDataCDS'
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inCount'
        Value = Null
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inHeadCount'
        Value = Null
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inAssetId'
        Value = Null
        ComponentItem = 'AssetId'
        ParamType = ptInput
      end>
  end
  object FromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormName = 'TObject_StoragePlace'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 479
    Top = 24
  end
  object ToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormName = 'TObject_StoragePlace'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ToGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 640
    Top = 24
  end
end
