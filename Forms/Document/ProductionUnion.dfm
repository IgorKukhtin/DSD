inherited ProductionUnionForm: TProductionUnionForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077'>'
  ClientWidth = 1020
  ExplicitWidth = 1036
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 122
    Width = 1020
    Height = 552
    TabOrder = 2
    ExplicitTop = 122
    ExplicitWidth = 1020
    ExplicitHeight = 552
    ClientRectBottom = 552
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 528
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 220
        ExplicitWidth = 1020
        ExplicitHeight = 220
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clGoodsGroupNameFull: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colMeasureName: TcxGridDBColumn [3]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colGoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colGoodsKindName_Complete: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindName_Complete'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colCuterCount: TcxGridDBColumn [6]
            Caption = #1050#1091#1090#1077#1088#1086#1074' '#1092#1072#1082#1090
            DataBinding.FieldName = 'CuterCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colRealWeight: TcxGridDBColumn [7]
            Caption = #1060#1072#1082#1090' '#1074#1077#1089
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colCount: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colAmount: TcxGridDBColumn [9]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colPartionGoodsDate: TcxGridDBColumn [10]
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.SaveTime = False
            Properties.ShowTime = False
            Properties.UseNullString = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colPartionGoods: TcxGridDBColumn [11]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colReceiptCode: TcxGridDBColumn [12]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colReceiptName: TcxGridDBColumn [13]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
            DataBinding.FieldName = 'ReceiptName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colIsPartionClose: TcxGridDBColumn [14]
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1088#1099#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionClose'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colComment: TcxGridDBColumn [15]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object clInfoMoneyCode: TcxGridDBColumn [16]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clInfoMoneyGroupName: TcxGridDBColumn [17]
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn [18]
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyName: TcxGridDBColumn [19]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clInfoMoneyName_all: TcxGridDBColumn [20]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxGridChild: TcxGrid
        Top = 225
        Width = 1020
        ExplicitTop = 225
        ExplicitWidth = 1020
        inherited cxGridDBTableViewChild: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountReceipt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountReceipt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmount
            end>
          Styles.Content = nil
          object colChildGroupNumber: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' '#8470
            DataBinding.FieldName = 'GroupNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colChildGoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colChildMeasureName: TcxGridDBColumn [4]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colChildGoodsKindName: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceChild
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object colChildAmountReceipt: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086' 1 '#1082#1091#1090#1077#1088
            DataBinding.FieldName = 'AmountReceipt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildAmount: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildPartionGoods: TcxGridDBColumn [8]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colChildPartionGoodsDate: TcxGridDBColumn [9]
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colChildComment: TcxGridDBColumn [10]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          inherited colChildIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxBottomSplitter: TcxSplitter
        Top = 220
        Width = 1020
        ExplicitTop = 220
        ExplicitWidth = 1020
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1020
    Height = 96
    ExplicitWidth = 1020
    ExplicitHeight = 96
    inherited ceStatus: TcxButtonEdit
      ExplicitHeight = 22
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 763
    Top = 72
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
      ReportName = 'PrintMovement_Send'
      ReportNameParam.Value = 'PrintMovement_Send'
    end
    object actUpdateChildDS: TdsdUpdateDataSet [9]
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
    object actGoodsKindChoiceChild: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindChoiceChild'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actGoodsKindChoiceMaster: TOpenChoiceForm [20]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindChoiceMaster'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 768
    Top = 216
  end
  inherited MasterCDS: TClientDataSet
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionUnion'
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
          ItemName = 'bbMIMasterProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocol'
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
    StoredProcName = 'gpUpdate_Status_ProductionUnion'
    Left = 200
    Top = 32
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionUnion'
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
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end>
    Left = 288
    Top = 168
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ProductionUnion'
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
        Name = 'inIsPeresort'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 466
    Top = 224
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
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
      end>
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Master_SetErased'
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Master_SetUnErased'
    Left = 334
    Top = 224
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Master'
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
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end>
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Master'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
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
        Name = 'inCount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end>
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Child_SetErased'
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Child_SetUnErased'
  end
  inherited GuidesTo: TdsdGuides
    PositionDataSet = 'MasterCDS'
  end
  inherited GuidesFrom: TdsdGuides
    PositionDataSet = 'MasterCDS'
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Child'
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
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ParentId'
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end>
  end
  inherited PrintHeaderCDS: TClientDataSet
    Left = 716
    Top = 265
  end
  inherited PrintItemsCDS: TClientDataSet
    Left = 644
    Top = 270
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send_Print'
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
    Left = 495
    Top = 416
  end
end
