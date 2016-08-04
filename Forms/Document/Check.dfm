inherited CheckForm: TCheckForm
  Caption = #1050#1072#1089#1089#1086#1074#1099#1081' '#1095#1077#1082
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 147
    Height = 269
    ExplicitTop = 147
    ExplicitHeight = 269
    ClientRectBottom = 269
    inherited tsMain: TcxTabSheet
      ExplicitHeight = 245
      inherited cxGrid: TcxGrid
        Height = 245
        ExplicitHeight = 245
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountOrder
            end>
          DataController.Summary.FooterSummaryItems = <
            item
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colName
            end
            item
              Format = ',0.000'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountOrder
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 222
          end
          object colChangePercent: TcxGridDBColumn
            Caption = '% c'#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object colAmountOrder: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'AmountOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colPriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object colSummChangePercent: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1057#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object colSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Height = 121
    ExplicitHeight = 121
    inherited edInvNumber: TcxTextEdit
      Left = 7
      Top = 14
      Text = 'edInvNumber'
      ExplicitLeft = 7
      ExplicitTop = 14
      ExplicitWidth = 142
      Width = 142
    end
    inherited cxLabel1: TcxLabel
      Left = 7
      Top = -1
      ExplicitLeft = 7
      ExplicitTop = -1
    end
    inherited edOperDate: TcxDateEdit
      Left = 155
      Top = 14
      EditValue = 42261d
      Properties.ReadOnly = True
      ExplicitLeft = 155
      ExplicitTop = 14
      ExplicitWidth = 90
      Width = 90
    end
    inherited cxLabel2: TcxLabel
      Left = 155
      Top = -1
      ExplicitLeft = 155
      ExplicitTop = -1
    end
    inherited cxLabel15: TcxLabel
      Top = 37
      ExplicitTop = 37
    end
    inherited ceStatus: TcxButtonEdit
      Top = 52
      PopupMenu = nil
      ExplicitTop = 52
      ExplicitWidth = 141
      ExplicitHeight = 22
      Width = 141
    end
    object edUnitName: TcxTextEdit
      Left = 251
      Top = 14
      Properties.ReadOnly = True
      TabOrder = 6
      Text = 'edUnitName'
      Width = 212
    end
    object edCashRegisterName: TcxTextEdit
      Left = 586
      Top = 14
      Properties.ReadOnly = True
      TabOrder = 7
      Text = 'edCashRegisterName'
      Width = 121
    end
    object cxLabel3: TcxLabel
      Left = 251
      Top = -1
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel4: TcxLabel
      Left = 464
      Top = -1
      Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
    end
    object cxLabel5: TcxLabel
      Left = 586
      Top = -1
      Caption = #1050#1072#1089#1089#1072
    end
    object edPaidTypeName: TcxTextEdit
      Left = 464
      Top = 14
      Properties.ReadOnly = True
      TabOrder = 11
      Text = 'edPaidTypeName'
      Width = 121
    end
    object lblCashMember: TcxLabel
      Left = 251
      Top = 36
      Caption = #1052#1077#1085#1077#1076#1078#1077#1088
    end
    object edCashMember: TcxTextEdit
      Left = 251
      Top = 52
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 212
    end
    object lblBayer: TcxLabel
      Left = 8
      Top = 76
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object edBayer: TcxTextEdit
      Left = 8
      Top = 92
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 237
    end
    object cxLabel6: TcxLabel
      Left = 708
      Top = -1
      Caption = #8470' '#1092#1080#1089#1082'. '#1095#1077#1082#1072
    end
    object edFiscalCheckNumber: TcxTextEdit
      Left = 708
      Top = 14
      Properties.ReadOnly = True
      TabOrder = 17
      Text = 'edFiscalCheckNumber'
      Width = 93
    end
    object chbNotMCS: TcxCheckBox
      Left = 477
      Top = 52
      Caption = #1053#1077' '#1076#1083#1103' '#1053#1058#1047
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 82
    end
    object cxLabel7: TcxLabel
      Left = 586
      Top = 36
      Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1072#1103' '#1082#1072#1088#1090#1072
    end
    object edDiscountCard: TcxTextEdit
      Left = 586
      Top = 52
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 215
    end
  end
  object edInvNumberOrder: TcxTextEdit [2]
    Left = 155
    Top = 52
    Properties.ReadOnly = True
    TabOrder = 6
    Text = 'edInvNumberOrder'
    Width = 90
  end
  object cxLabel9: TcxLabel [3]
    Left = 155
    Top = 37
    Caption = #8470' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
  end
  object cxLabel10: TcxLabel [4]
    Left = 251
    Top = 76
    Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' ('#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
  end
  object edBayerPhone: TcxTextEdit [5]
    Left = 251
    Top = 92
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 212
  end
  object cxLabel8: TcxLabel [6]
    Left = 586
    Top = 76
    Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1057#1086#1089#1090#1086#1103#1085#1080#1077' VIP-'#1095#1077#1082#1072')'
  end
  object edConfirmedKind: TcxTextEdit [7]
    Left = 586
    Top = 92
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 212
  end
  inherited ActionList: TActionList
    inherited actMISetErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actMISetUnErased: TdsdUpdateErased
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
    inherited actUnCompleteMovement: TChangeGuidesStatus
      Enabled = False
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      Enabled = False
    end
    inherited actDeleteMovement: TChangeGuidesStatus
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
    object ChoiceCashRegister: TOpenChoiceForm
      Category = 'EditMovement'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ChoiceCashRegister'
      FormName = 'TCashRegisterForm'
      FormNameParam.Value = 'TCashRegisterForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CashRegisterId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = edCashRegisterName
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ChoicePaidType: TOpenChoiceForm
      Category = 'EditMovement'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ChoiceCashRegister'
      FormName = 'TPaidTypeForm'
      FormNameParam.Value = 'TPaidTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'PaidTypeId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = 'cxTextEdit3'
          Component = edPaidTypeName
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = FormParams
          ComponentItem = 'PaidTypeCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_Movement_Check: TdsdExecStoredProc
      Category = 'EditMovement'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Check
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Check
        end>
    end
    object actEditDocument: TMultiAction
      Category = 'EditMovement'
      MoveParams = <>
      ActionList = <
        item
          Action = ChoiceCashRegister
        end
        item
          Action = ChoicePaidType
        end
        item
          Action = actUpdate_Movement_Check
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1088#1086#1087#1080#1089#1072#1090#1100' '#1082#1072#1089#1089#1086#1074#1099#1081' '#1080' '#1090#1080#1087' '#1086#1087#1083#1072#1090#1099
      Hint = #1055#1088#1086#1087#1080#1089#1072#1090#1100' '#1082#1072#1089#1089#1086#1074#1099#1081' '#1080' '#1090#1080#1087' '#1086#1087#1083#1072#1090#1099
      ImageIndex = 43
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Check'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
          ItemName = 'bbMovementItemProtocol'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actEditDocument
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
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
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashRegisterId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidTypeId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidTypeCode'
        Value = Null
        MultiSelectSeparator = ','
      end>
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Check'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Check'
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
        Name = 'OperDate'
        Value = 42132d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
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
        Name = 'UnitName'
        Value = Null
        Component = edUnitName
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashRegisterName'
        Value = Null
        Component = edCashRegisterName
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidTypeName'
        Value = 'cxTextEdit3'
        Component = edPaidTypeName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashMember'
        Value = Null
        Component = edCashMember
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Bayer'
        Value = Null
        Component = edBayer
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FiscalCheckNumber'
        Value = Null
        Component = edFiscalCheckNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NotMCS'
        Value = Null
        Component = chbNotMCS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountCardName'
        Value = Null
        Component = edDiscountCard
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerPhone'
        Value = Null
        Component = edBayerPhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberOrder'
        Value = 'edInvNumberOrder'
        Component = edInvNumberOrder
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConfirmedKindName'
        Value = Null
        Component = edConfirmedKind
        DataType = ftString
        MultiSelectSeparator = ','
      end>
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check'
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashRegisterId'
        Value = ''
        Component = FormParams
        ComponentItem = 'CashRegisterId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidTypeId'
        Value = Null
        Component = edOperDate
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited HeaderSaver: THeaderSaver
    Left = 288
    Top = 305
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 390
    Top = 208
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    Left = 536
    Top = 280
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 460
    Top = 204
  end
  object spUpdate_Movement_Check: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inPaidTypeId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PaidTypeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashRegisterId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashRegisterId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 186
    Top = 320
  end
end
