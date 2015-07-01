inherited ProductionSeparateForm: TProductionSeparateForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
  ClientHeight = 678
  ClientWidth = 903
  ExplicitWidth = 919
  ExplicitHeight = 713
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 122
    Width = 903
    Height = 556
    TabOrder = 2
    ExplicitTop = 122
    ExplicitWidth = 903
    ExplicitHeight = 556
    ClientRectBottom = 556
    ClientRectRight = 903
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 903
      ExplicitHeight = 532
      inherited cxGrid: TcxGrid
        Width = 903
        Height = 224
        ExplicitWidth = 903
        ExplicitHeight = 224
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colHeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colLiveWeight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colHeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colLiveWeight
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsGroupNameFull: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          inherited colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1088#1072#1089#1093#1086#1076')'
          end
          object clMeasureName: TcxGridDBColumn [3]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colAmount: TcxGridDBColumn [4]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colLiveWeight: TcxGridDBColumn [5]
            Caption = #1046#1080#1074#1086#1081' '#1074#1077#1089
            DataBinding.FieldName = 'LiveWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colHeadCount: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxGridChild: TcxGrid
        Top = 229
        Width = 903
        ExplicitTop = 229
        ExplicitWidth = 903
        inherited cxGridDBTableViewChild: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildHeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildLiveWeight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildHeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildLiveWeight
            end>
          Styles.Content = nil
          object colCholdGoodsGroupNameFull: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          inherited colChildGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
          end
          object colCholdMeasureName: TcxGridDBColumn [3]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colChildAmount: TcxGridDBColumn [4]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildLiveWeight: TcxGridDBColumn [5]
            Caption = #1046#1080#1074#1086#1081' '#1074#1077#1089
            DataBinding.FieldName = 'LiveWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colChildHeadCount: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colChildPartionGoods: TcxGridDBColumn [7]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          inherited colChildIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxBottomSplitter: TcxSplitter
        Top = 224
        Width = 903
        ExplicitTop = 224
        ExplicitWidth = 903
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 903
    Height = 96
    ExplicitWidth = 903
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
      Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080
    end
    object actPrint_Ceh: TdsdPrintAction [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintCeh
      StoredProcList = <
        item
          StoredProc = spSelectPrintCeh
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1086#1073#1074#1072#1083#1082#1077
      ReportNameParam.Value = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1086#1073#1074#1072#1083#1082#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actUpdateChildDS: TdsdUpdateDataSet [10]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    inherited actMIMasterProtocol: TdsdOpenForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083#1077#1084#1077#1085#1090#1072' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083#1077#1084#1077#1085#1090#1072' ('#1088#1072#1089#1093#1086#1076')>'
    end
    inherited actMIChildProtocol: TdsdOpenForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083#1077#1084#1077#1085#1090#1072' ('#1087#1088#1080#1093#1086#1076')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083#1077#1084#1077#1085#1090#1072' ('#1087#1088#1080#1093#1086#1076')>'
    end
  end
  inherited MasterCDS: TClientDataSet
    Left = 656
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionSeparate'
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddChild'
        end
        item
          Visible = True
          ItemName = 'bbErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedChild'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbMIContainer'
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
          ItemName = 'bbPrint_Ceh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIMasterProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrint_Ceh: TdxBarButton
      Action = actPrint_Ceh
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 96
    Top = 272
  end
  inherited StatusGuides: TdsdGuides
    Left = 144
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ProductionSeparate'
    Left = 96
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionSeparate'
    OutputType = otResult
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
        Value = Null
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
        Component = GuidesFrom
        ComponentItem = 'Key'
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PartionGoods'
        Value = ''
        Component = cePartionGoods
        DataType = ftString
      end
      item
        Value = Null
        ParamType = ptUnknown
      end>
    Left = 288
    Top = 168
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
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 224
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = cePartionGoods
      end>
    Left = 264
    Top = 209
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Master_SetErased'
    Left = 454
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Master_SetUnErased'
    Left = 390
    Top = 200
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Master'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
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
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inLiveWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LiveWeight'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'HeadCount'
        ParamType = ptInput
      end>
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Master'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inLiveWeight'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inHeadCount'
        Value = '0'
        ParamType = ptInput
      end>
  end
  inherited ChildCDS: TClientDataSet
    IndexFieldNames = ''
    MasterFields = ''
    MasterSource = nil
    PacketRecords = -1
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Child_SetErased'
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Child_SetUnErased'
  end
  inherited spInsertMaskMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Child'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inParentId'
        Value = 0
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inLiveWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'LiveWeight'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
      end>
  end
  inherited GuidesTo: TdsdGuides
    PositionDataSet = 'MasterCDS'
  end
  inherited GuidesFrom: TdsdGuides
    PositionDataSet = 'MasterCDS'
    Left = 304
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Child'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
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
        Name = 'inParentId'
        Value = 0
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inLiveWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'LiveWeight'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
      end>
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 751
    Top = 96
  end
  object spSelectPrintCeh: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Ceh_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 679
    Top = 96
  end
end
