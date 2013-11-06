inherited SendForm: TSendForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
  ClientWidth = 851
  ExplicitWidth = 859
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 851
    ExplicitWidth = 851
    ClientRectRight = 851
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 851
      inherited cxGrid: TcxGrid
        Width = 851
        ExplicitWidth = 851
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
            Width = 58
          end
          object colName: TcxGridDBColumn [1]
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object colGoodsKindName: TcxGridDBColumn [2]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colPartionGoods: TcxGridDBColumn [3]
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colAmount: TcxGridDBColumn [4]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colHeadCount: TcxGridDBColumn [5]
            Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
          end
          object colAssetName: TcxGridDBColumn [6]
            Caption = #1054#1089#1085'.'#1089#1088#1077#1076#1089#1090#1074#1072
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
          end
        end
      end
    end
    inherited tsEntry: TcxTabSheet
      ExplicitWidth = 851
      inherited cxGridEntry: TcxGrid
        Width = 851
        ExplicitWidth = 851
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
    Width = 851
    TabOrder = 3
    ExplicitWidth = 851
    inherited edInvNumber: TcxTextEdit
      Enabled = False
    end
    object cxLabel3: TcxLabel
      Left = 427
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 427
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 196
    end
    object cxLabel4: TcxLabel
      Left = 630
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edTo: TcxButtonEdit
      Left = 629
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Width = 209
    end
  end
  object FromGuides: TdsdGuides [3]
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
    Left = 512
    Top = 24
  end
  object ToGuides: TdsdGuides [4]
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
  inherited ActionList: TActionList
    inherited actNewDocument: TdsdInsertUpdateAction
      FormName = 'TSendForm'
    end
  end
  inherited MainDataDS: TDataSource
    Top = 96
  end
  inherited MainDataCDS: TClientDataSet
    Top = 96
  end
  inherited spMainData: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send'
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Top = 96
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited StatusGuides: TdsdGuides
    Top = 96
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    Top = 96
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
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end>
  end
  inherited RefreshAddOn: TRefreshAddOn
    FormName = 'SendJournalForm'
    DataSet = 'MainDataCDS'
  end
  inherited spInsertUpdateMI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send'
    Params = <
      item
        Name = 'ioId'
        Component = MainDataCDS
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
        Component = MainDataCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = MainDataCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inCount'
        Component = MainDataCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inHeadCount'
        Component = MainDataCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Component = MainDataCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = MainDataCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inAssetId'
        Component = MainDataCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
      end>
  end
end
