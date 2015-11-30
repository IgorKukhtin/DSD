inherited RepriceForm: TRepriceForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1086#1094#1077#1085#1082#1072'>'
  ExplicitWidth = 845
  ExplicitHeight = 454
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
            end
            item
              Format = #1058#1086#1074#1072#1088#1086#1074': ,0'
              Kind = skCount
              FieldName = 'GoodsName'
              Column = colGoodsName
            end
            item
              Format = ',0.00'
              Kind = skSum
              FieldName = 'SummReprice'
              Column = colSummReprice
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            DataBinding.FieldName = ''
            VisibleForCustomization = False
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Width = 69
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            Width = 286
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
          end
          object colPriceOld: TcxGridDBColumn
            Caption = #1057#1090#1072#1088#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'PriceOld'
            Width = 93
          end
          object colPriceNew: TcxGridDBColumn
            Caption = #1053#1086#1074#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'PriceNew'
            Width = 90
          end
          object colSummReprice: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'SummReprice'
            Width = 107
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    TabOrder = 3
    inherited edOperDate: TcxDateEdit
      Properties.ReadOnly = True
    end
    inherited cxLabel15: TcxLabel
      Visible = False
    end
    inherited ceStatus: TcxButtonEdit
      Visible = False
      ExplicitHeight = 22
    end
    object edUnit: TcxButtonEdit
      Left = 384
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 270
    end
    object lblUnit: TcxLabel
      Left = 384
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel3: TcxLabel
      Left = 674
      Top = 5
      Caption = #1057#1091#1084#1084#1072
    end
    object edTotalSumm: TcxTextEdit
      Left = 674
      Top = 23
      Properties.Alignment.Horz = taRightJustify
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 90
    end
  end
  inherited ActionList: TActionList
    inherited actMISetErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      Enabled = False
    end
    inherited actShowErased: TBooleanStoredProcAction
      Enabled = False
    end
    inherited actShowAll: TBooleanStoredProcAction
      Enabled = False
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      Enabled = False
    end
    inherited actPrint: TdsdPrintAction
      Enabled = False
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      Enabled = False
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      Enabled = False
    end
    inherited actDeleteMovement: TChangeGuidesStatus
      Enabled = False
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      Enabled = False
    end
    inherited MultiAction: TMultiAction
      Enabled = False
    end
    inherited actNewDocument: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actAddMask: TdsdExecStoredProc
      Enabled = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Reprice'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Value = False
        ParamType = ptUnknown
      end
      item
        Value = False
        ParamType = ptUnknown
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    inherited bbShowAll: TdxBarButton
      Visible = ivNever
    end
    inherited bbInsertUpdateMovement: TdxBarButton
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbShowErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    inherited bbMovementItemContainer: TdxBarButton
      Visible = ivNever
    end
    inherited bbMovementItemProtocol: TdxBarButton
      Visible = ivNever
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        DataSummaryItemIndex = 0
      end>
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Reprice'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = Null
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
        Name = 'TotalSumm'
        Value = ''
        Component = edTotalSumm
        DataType = ftFloat
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
  end
  inherited HeaderSaver: THeaderSaver
    StoredProc = nil
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 440
    Top = 16
  end
end
