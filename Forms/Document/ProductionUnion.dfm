inherited ProductionUnionForm: TProductionUnionForm
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
  ClientWidth = 1030
  ExplicitLeft = 3
  ExplicitWidth = 1038
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 124
    Width = 1030
    Height = 250
    TabOrder = 2
    ExplicitTop = 124
    ExplicitHeight = 250
    ClientRectBottom = 246
    ClientRectRight = 1026
    inherited tsMain: TcxTabSheet
      ExplicitHeight = 224
      inherited cxGrid: TcxGrid
        Width = 1024
        Height = 224
        ExplicitHeight = 224
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colCount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colCount
            end>
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colLineNum: TcxGridDBColumn [0]
            Caption = #8470#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 20
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          inherited colGoodsCode: TcxGridDBColumn
            Options.Editing = False
          end
          inherited colGoodsName: TcxGridDBColumn
            Options.Editing = False
          end
          object colPartionClose: TcxGridDBColumn [4]
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1088#1099#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PartionClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colPartionGoods: TcxGridDBColumn [5]
            Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colComment: TcxGridDBColumn [6]
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          inherited colAmount: TcxGridDBColumn
            Properties.DecimalPlaces = 4
            Width = 50
          end
          object colCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colRealWeight: TcxGridDBColumn
            Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081' '#1074#1077#1089
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colCuterCount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1091#1090#1077#1088#1086#1074
            DataBinding.FieldName = 'CuterCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colReceiptName: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1099
            DataBinding.FieldName = 'ReceiptName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
        end
      end
    end
    inherited tsEntry: TcxTabSheet
      ExplicitHeight = 224
      inherited cxGridEntry: TcxGrid
        Width = 1024
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
    Width = 1030
    TabOrder = 4
    inherited cxGridDBTableViewChild: TcxGridDBTableView
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Kind = skSum
          Position = spFooter
        end
        item
          Kind = skSum
          Position = spFooter
        end
        item
          Kind = skSum
          Position = spFooter
        end
        item
          Kind = skSum
          Position = spFooter
        end
        item
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = colChildAmount
        end
        item
          Format = ',0.####;-,0.####; ;'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skSum
        end
        item
          Kind = skSum
        end
        item
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = colChildAmount
        end
        item
          Kind = skSum
        end
        item
          Kind = skSum
        end
        item
          Format = ',0.####;-,0.####; ;'
          Kind = skSum
        end>
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      object colChildLineNum: TcxGridDBColumn [0]
        Caption = #8470' '#1087'/'#1087
        DataBinding.FieldName = 'LineNum'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 20
      end
      inherited colChildGoodsCode: TcxGridDBColumn
        Options.Editing = False
      end
      inherited colChildGoodsName: TcxGridDBColumn
        Properties.AutoSelect = False
        Properties.Buttons = <
          item
            Action = actGoodsChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
      end
      inherited colChildPartionGoods: TcxGridDBColumn [3]
        Visible = True
        Width = 60
      end
      object colPartionGoodsDate: TcxGridDBColumn [4]
        Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072' ('#1076#1072#1090#1072')'
        DataBinding.FieldName = 'PartionGoodsDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      inherited colChildAmount: TcxGridDBColumn
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
      end
      inherited colChildAmountReceipt: TcxGridDBColumn
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = True
        Width = 60
      end
      inherited colChildComment: TcxGridDBColumn [7]
      end
      inherited colChildIsErased: TcxGridDBColumn [8]
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      inherited colChildGoodsKindName: TcxGridDBColumn [9]
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actGoodsKindChoiceChild
            Default = True
            Kind = bkEllipsis
          end>
        Visible = True
        Width = 60
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1030
    Height = 96
    ExplicitHeight = 96
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object actUpdateChildDS: TdsdUpdateDataSet [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    inherited actGoodsKindChoiceChild: TOpenChoiceForm
      FormNameParam.Name = 'TGoodsKindForm'
    end
    inherited actGoodsChoiceForm: TOpenChoiceForm
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = ''
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionUnion'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
    inherited bbPrint: TdxBarButton
      Visible = ivNever
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
    Left = 96
    Top = 56
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
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end>
    Left = 418
    Top = 104
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Master_SetErased'
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Master_SetUnErased'
    Left = 382
    Top = 200
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Master'
    Params = <
      item
        Name = 'ioId'
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
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionClose'
        Component = MasterCDS
        ComponentItem = 'PartionClose'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inCount'
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inRealWeight'
        Component = MasterCDS
        ComponentItem = 'RealWeight'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inCuterCount'
        Component = MasterCDS
        ComponentItem = 'CuterCount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inReceiptId'
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
        ParamType = ptInput
      end>
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Child_SetErased'
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_Child_SetUnErased'
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Child'
    Params = <
      item
        Name = 'ioId'
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
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inParentId'
        Component = ChildCDS
        ComponentItem = 'ParentId'
        ParamType = ptInput
      end
      item
        Name = 'inAmountReceipt'
        Component = ChildCDS
        ComponentItem = 'AmountReceipt'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoodsDate'
        Component = ChildCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Component = ChildCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = ChildCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end>
  end
end
