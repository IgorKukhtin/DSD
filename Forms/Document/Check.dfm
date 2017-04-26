inherited CheckForm: TCheckForm
  Caption = #1050#1072#1089#1089#1086#1074#1099#1081' '#1095#1077#1082
  ClientHeight = 406
  ExplicitHeight = 444
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 183
    Height = 223
    ExplicitTop = 183
    ExplicitHeight = 223
    ClientRectBottom = 223
    inherited tsMain: TcxTabSheet
      ExplicitHeight = 199
      inherited cxGrid: TcxGrid
        Height = 199
        ExplicitHeight = 199
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummSale
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummSale
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn [0]
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
          object colName: TcxGridDBColumn [1]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 222
          end
          object colIntenalSPName: TcxGridDBColumn [2]
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072
            DataBinding.FieldName = 'IntenalSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 107
          end
          object colChangePercent: TcxGridDBColumn [3]
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
          object colAmount: TcxGridDBColumn [4]
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
          object colAmountOrder: TcxGridDBColumn [5]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object colPrice: TcxGridDBColumn [6]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colPriceSale: TcxGridDBColumn [7]
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object colSummChangePercent: TcxGridDBColumn [8]
            Caption = #1057#1091#1084#1084#1072' '#1057#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object List_UID: TcxGridDBColumn [9]
            Caption = 'UID '#1101#1083#1077#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'List_UID'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colSumm: TcxGridDBColumn [10]
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
          object colSummSale: TcxGridDBColumn [11]
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'SummSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colisSp: TcxGridDBColumn [12]
            Caption = #1059#1095'. '#1074' '#1057#1055
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1077
            Options.Editing = False
            Width = 50
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Height = 157
    ExplicitHeight = 157
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
      Caption = #8470' '#1082#1072#1088#1090#1099
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
    Left = 477
    Top = 76
    Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
  end
  object edConfirmedKind: TcxTextEdit [7]
    Left = 477
    Top = 92
    Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1057#1086#1089#1090#1086#1103#1085#1080#1077' VIP-'#1095#1077#1082#1072')'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 160
  end
  object edConfirmedKindClient: TcxTextEdit [8]
    Left = 641
    Top = 92
    Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 160
  end
  object cxLabel11: TcxLabel [9]
    Left = 641
    Top = 76
    Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
    Caption = #1057#1090#1072#1090#1091#1089' '#1057#1052#1057
  end
  object cxLabel12: TcxLabel [10]
    Left = 8
    Top = 114
    Caption = ' '#9#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077'('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
  end
  object edPartnerMedical: TcxTextEdit [11]
    Left = 8
    Top = 130
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 237
  end
  object cxLabel13: TcxLabel [12]
    Left = 251
    Top = 115
    Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edOperDateSP: TcxDateEdit [13]
    Left = 251
    Top = 130
    EditValue = 42261d
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 90
  end
  object cxLabel14: TcxLabel [14]
    Left = 347
    Top = 114
    Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edInvNumberSP: TcxTextEdit [15]
    Left = 347
    Top = 130
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 116
  end
  object cxLabel16: TcxLabel [16]
    Left = 477
    Top = 114
    Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
  end
  object edMedicSP: TcxTextEdit [17]
    Left = 477
    Top = 130
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 160
  end
  object cxLabel17: TcxLabel [18]
    Left = 641
    Top = 114
    Caption = #8470' '#1072#1084#1073#1091#1083#1072#1090#1086#1088#1080#1080' '
  end
  object edAmbulance: TcxTextEdit [19]
    Left = 641
    Top = 130
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 160
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
    inherited actUnCompleteMovement: TChangeGuidesStatus [8]
      Enabled = False
    end
    inherited actCompleteMovement: TChangeGuidesStatus [9]
      Enabled = False
    end
    inherited actDeleteMovement: TChangeGuidesStatus [10]
      Enabled = False
    end
    inherited actMovementItemContainer: TdsdOpenForm [11]
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm [12]
    end
    inherited MultiAction: TMultiAction [13]
      Enabled = False
    end
    inherited actNewDocument: TdsdInsertUpdateAction [14]
      Enabled = False
    end
    inherited actFormClose: TdsdFormClose [15]
    end
    inherited actAddMask: TdsdExecStoredProc [16]
      Enabled = False
    end
    object actShowMessage: TShowMessageAction [17]
      Category = 'DSDLib'
      MoveParams = <>
    end
    object ChoiceCashRegister: TOpenChoiceForm [18]
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
    object PrintDialog: TExecuteDialog [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actCheckPrintDialog'
      ImageIndex = 3
      FormName = 'TCheckPrintDialogForm'
      FormNameParam.Value = 'TCheckPrintDialogForm'
      FormNameParam.DataType = ftDateTime
      FormNameParam.ParamType = ptInputOutput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = edFiscalCheckNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = edBayer
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    inherited actPrint: TdsdPrintAction [20]
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091
      ReportNameParam.Value = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091
      ReportNameParam.ParamType = ptInput
    end
    object macPrint: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = PrintDialog
        end
        item
          Action = actPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      ImageIndex = 3
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
    object actUpdateOperDate: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdateMovement_OperDate
      StoredProcList = <
        item
          StoredProc = spUpdateMovement_OperDate
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 24
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogUpdateOperDate: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      ImageIndex = 24
      FormName = 'TDataTimeDialogForm'
      FormNameParam.Value = 'TDataTimeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = '0'
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateOperDate: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateOperDate
        end
        item
          Action = actUpdateOperDate
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      ImageIndex = 67
    end
    object actUpdateSpParam: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_SpParam
      StoredProcList = <
        item
          StoredProc = spUpdate_SpParam
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogSP: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
      ImageIndex = 26
      FormName = 'TCheck_SPEditForm'
      FormNameParam.Value = 'TCheck_SPEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDateSp'
          Value = 42261d
          Component = edOperDateSP
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumberSP'
          Value = Null
          Component = edInvNumberSP
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMedicSPName'
          Value = Null
          Component = edMedicSP
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAmbulance'
          Value = Null
          Component = edAmbulance
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerMedicalName'
          Value = Null
          Component = edPartnerMedical
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerMedicalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'inPartnerMedicalId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateSpParam: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogSP
        end
        item
          Action = actUpdateSpParam
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
      ImageIndex = 26
    end
  end
  inherited MasterDS: TDataSource
    Top = 221
  end
  inherited MasterCDS: TClientDataSet
    Top = 221
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
    Top = 221
  end
  inherited BarManager: TdxBarManager
    Top = 220
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
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
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateOperDate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbPrint: TdxBarButton
      Action = macPrint
    end
    object dxBarButton1: TdxBarButton
      Action = actEditDocument
      Category = 0
    end
    object bbUpdateOperDate: TdxBarButton
      Action = macUpdateOperDate
      Category = 0
    end
    object bb: TdxBarButton
      Action = macUpdateSpParam
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
    Top = 214
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
    Left = 56
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Top = 221
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Check'
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
        Name = 'ioStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 221
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
      end
      item
        Name = 'ConfirmedKindClientName'
        Value = Null
        Component = edConfirmedKindClient
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalName'
        Value = Null
        Component = edPartnerMedical
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateSP'
        Value = 'NULL'
        Component = edOperDateSP
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberSP'
        Value = Null
        Component = edInvNumberSP
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSPName'
        Value = Null
        Component = edMedicSP
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Ambulance'
        Value = Null
        Component = edAmbulance
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPartnerMedicalId'
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 312
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
    Left = 186
    Top = 272
  end
  inherited GuidesFiller: TGuidesFiller
    Top = 221
  end
  inherited HeaderSaver: THeaderSaver
    Left = 320
    Top = 313
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Top = 261
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 422
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    Left = 536
    Top = 280
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 408
    Top = 304
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 508
    Top = 236
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
    Top = 328
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Check_Print'
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
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 232
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 748
    Top = 233
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 740
    Top = 286
  end
  object spUpdateMovement_OperDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_OperDate'
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
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = 'edInvNumber'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 482
    Top = 336
  end
  object spUpdate_SpParam: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_SpParam'
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
        Name = 'inPartnerMedicalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPartnerMedicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateSP'
        Value = 42261d
        Component = edOperDateSP
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmbulance'
        Value = 'edInvNumber'
        Component = edAmbulance
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMedicSP'
        Value = Null
        Component = edMedicSP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberSP'
        Value = Null
        Component = edInvNumberSP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 554
    Top = 336
  end
end
