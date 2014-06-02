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
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = colHeadCount
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
              Column = colHeadCount
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
          inherited colAmount: TcxGridDBColumn
            Properties.DecimalPlaces = 4
          end
          object colHeadCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
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
          Column = ColChildHeadCount
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
          Column = ColChildHeadCount
        end>
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
            Action = GoodsChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
      end
      inherited colChildAmount: TcxGridDBColumn
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
      end
      object ColChildHeadCount: TcxGridDBColumn [8]
        Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
        DataBinding.FieldName = 'HeadCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Width = 60
      end
      inherited colChildIsErased: TcxGridDBColumn
        Width = 50
      end
    end
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
    inherited GoodsChoiceForm: TOpenChoiceForm
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = ''
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionSeparate'
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
    Left = 418
    Top = 104
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Master_SetErased'
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
        Name = 'inHeadCount'
        Component = MasterCDS
        ComponentItem = 'HeadCount'
        ParamType = ptInput
      end>
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Child_SetErased'
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Child_SetUnErased'
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Child'
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
        Name = 'inHeadCount'
        Component = ChildCDS
        ComponentItem = 'HeadCount'
        ParamType = ptInput
      end>
  end
end
