inherited BankAccountJournalByInvoiceForm: TBankAccountJournalByInvoiceForm
  Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1089#1095#1077#1090#1091' - '#1046#1091#1088#1085#1072#1083' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 356
  ClientWidth = 819
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  ExplicitWidth = 835
  ExplicitHeight = 394
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 819
    Height = 299
    TabOrder = 3
    ExplicitWidth = 819
    ExplicitHeight = 299
    ClientRectBottom = 299
    ClientRectRight = 819
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 819
      ExplicitHeight = 299
      inherited cxGrid: TcxGrid
        Width = 819
        Height = 299
        ExplicitWidth = 819
        ExplicitHeight = 299
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.00##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_diff
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_Invoice
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_Invoice
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_Invoice
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.00##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_diff
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_Invoice
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_Invoice
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_Invoice
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 69
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = 'Interne Nr'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumberParent: TcxGridDBColumn [2]
            Caption = 'External Nr'
            DataBinding.FieldName = 'InvNumberParent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 48
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object AmountIn: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountOut: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object MoneyPlaceName: TcxGridDBColumn
            Caption = 'Lieferanten / Kunden'
            DataBinding.FieldName = 'MoneyPlaceName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object ItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyCode_Invoice: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 33
          end
          object InfoMoneyGroupName_Invoice: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyDestinationName_Invoice: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyName_Invoice: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyName_all_Invoice: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object UnitName_Invoice: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 101
          end
          object Amount_diff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1057#1095#1077#1090
            DataBinding.FieldName = 'Amount_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1085#1080#1094#1072' '#1089' '#1089#1091#1084#1084#1086#1081' '#1087#1086' '#1057#1095#1077#1090#1091
            Options.Editing = False
            Width = 55
          end
          object isDiff: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'.'
            DataBinding.FieldName = 'isDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1090#1100' '#1088#1072#1079#1085#1080#1094#1072' '#1089' '#1089#1091#1084#1084#1086#1081' '#1087#1086' '#1089#1095#1077#1090#1091' '#1076#1072'/'#1085#1077#1090
            Options.Editing = False
            Width = 51
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ReceiptNumber_Invoice: TcxGridDBColumn
            Caption = '***Quittung Nr'
            DataBinding.FieldName = 'ReceiptNumber_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1082#1074#1080#1090#1072#1085#1094#1080#1080' '#1074' '#1044#1086#1082#1091#1084#1077#1085#1090#1077' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 55
          end
          object InvNumber_Invoice_Full: TcxGridDBColumn
            Caption = '***Interne Nr'
            DataBinding.FieldName = 'InvNumber_Invoice_Full'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actInvoiceJournalDetailChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
            Width = 120
          end
          object PaidKindName_Invoice: TcxGridDBColumn
            Caption = '***'#1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 56
          end
          object Amount_Invoice: TcxGridDBColumn
            Caption = '***'#1057#1091#1084#1084#1072' '#1057#1095#1077#1090
            DataBinding.FieldName = 'Amount_Invoice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1057#1095#1077#1090#1091
            Options.Editing = False
            Width = 80
          end
          object ObjectName_Invoice: TcxGridDBColumn
            Caption = '***Lieferanten / Kunden'
            DataBinding.FieldName = 'ObjectName_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' / '#1050#1083#1080#1077#1085#1090' '#1074' '#1044#1086#1082#1091#1084#1077#1085#1090#1077' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 128
          end
          object DescName_Invoice: TcxGridDBColumn
            Caption = '***'#1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'DescName_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' / '#1050#1083#1080#1077#1085#1090' '#1074' '#1044#1086#1082#1091#1084#1077#1085#1090#1077' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 70
          end
          object Comment_Invoice: TcxGridDBColumn
            Caption = '***'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 95
          end
          object ProductCIN_Invoice: TcxGridDBColumn
            Caption = '***CIN Nr. Boat'
            DataBinding.FieldName = 'ProductCIN_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 100
          end
          object ProductCode_Invoice: TcxGridDBColumn
            Caption = '***Interne Nr Boat'
            DataBinding.FieldName = 'ProductCode_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076' '#1083#1086#1076#1082#1080' '#1074' '#1044#1086#1082#1091#1084#1077#1085#1090#1077' '#1047#1072#1082#1072#1079#1077' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 43
          end
          object ProductName_Invoice: TcxGridDBColumn
            Caption = '***Boat'
            DataBinding.FieldName = 'ProductName_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 78
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 101
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 78
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            Options.Editing = False
            Width = 101
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            Options.Editing = False
            Width = 78
          end
          object AmountIn_Invoice: TcxGridDBColumn
            Caption = 'Debet (Invoice)'
            DataBinding.FieldName = 'AmountIn_Invoice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountOut_Invoice: TcxGridDBColumn
            Caption = 'Kredit (Invoice)'
            DataBinding.FieldName = 'AmountOut_Invoice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 819
    ExplicitWidth = 819
    inherited deStart: TcxDateEdit
      Left = 685
      Top = 0
      EditValue = 43101d
      Visible = False
      ExplicitLeft = 685
      ExplicitTop = 0
    end
    inherited deEnd: TcxDateEdit
      Left = 710
      Top = 6
      EditValue = 43101d
      Visible = False
      ExplicitLeft = 710
      ExplicitTop = 6
    end
    inherited cxLabel1: TcxLabel
      Left = 588
      Top = 1
      Visible = False
      ExplicitLeft = 588
      ExplicitTop = 1
    end
    inherited cxLabel2: TcxLabel
      Left = 600
      Top = 7
      Visible = False
      ExplicitLeft = 600
      ExplicitTop = 7
    end
    object cxLabel6: TcxLabel
      Left = 14
      Top = 8
      Caption = #1057#1095#1077#1090':'
    end
    object edInvoice: TcxButtonEdit
      Left = 53
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 236
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end>
  end
  inherited ActionList: TActionList
    object macUpdateMoneyPlace: TMultiAction [2]
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceMoneyPlace
        end
        item
          Action = actUpdateMoneyPlace
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091'>'
      ImageIndex = 55
    end
    object actUpdateMoneyPlace: TdsdDataSetRefresh [3]
      Category = 'Update'
      MoveParams = <>
      StoredProc = spUpdateJuridical
      StoredProcList = <
        item
          StoredProc = spUpdateJuridical
        end>
      Caption = 'actUpdateContract'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 55
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementForm'
      FormNameParam.Value = 'TBankAccountMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    object actChoiceMoneyPlace: TOpenChoiceForm [18]
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoice'
      ImageIndex = 55
      FormName = 'TMoneyPlace_ObjectForm'
      FormNameParam.Value = 'TMoneyPlace_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MoneyPlaceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'MoneyPlaceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceContract: TOpenChoiceForm [19]
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoice'
      ImageIndex = 24
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MoneyPlaceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MoneyPlaceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateContract: TdsdDataSetRefresh [20]
      Category = 'Update'
      MoveParams = <>
      StoredProc = spUpdateContract
      StoredProcList = <
        item
          StoredProc = spUpdateContract
        end>
      Caption = 'actUpdateContract'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 24
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1072#1084
      Hint = #1054#1090#1095#1077#1090' - '#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1072#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
          IndexFieldNames = 'AccountName;BankName;BankAccountName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      Hint = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDItems'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      ReportNameParam.Value = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actMasterPost: TDataSetPost
      Category = 'DSDLib'
      Caption = 'actMasterPost'
      Hint = 'actMasterPost'
      DataSource = MasterDS
    end
    object mactIsCopy: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actIsCopy
        end
        item
          Action = actMasterPost
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 58
    end
    object actIsCopy: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isCopy'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'isCopy'
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isCopy'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isCopy'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isCopy
      StoredProcList = <
        item
          StoredProc = spUpdate_isCopy
        end>
      Caption = 'actIsCopy'
    end
    object mactInsertProfitLossService: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actIsCopyTrue
        end
        item
          Action = actMasterPost
        end
        item
          Action = actInsertProfitLossService
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074
      ImageIndex = 27
    end
    object actIsCopyTrue: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isCopy'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isCopy'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isCopy'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isCopy
      StoredProcList = <
        item
          StoredProc = spUpdate_isCopy
        end>
      Caption = 'actIsCopyTrue'
    end
    object actInsertProfitLossService: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actInsertProfitLossService'
      FormName = 'TProfitLossServiceForm'
      FormNameParam.Value = 'TProfitLossServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '-1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      IdFieldName = 'Id'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Invoice
      StoredProcList = <
        item
          StoredProc = spUpdate_Invoice
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actInvoiceJournalDetailChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'acInvoiceJournalDetailChoiceForm'
      FormName = 'TInvoiceJournalDetailChoiceForm'
      FormNameParam.Value = 'TInvoiceJournalDetailChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Invoice'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Invoice'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MoneyPlaceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MoneyPlaceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Comment_Invoice'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object macUpdateContract: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceContract
        end
        item
          Action = actUpdateContract
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      ImageIndex = 43
    end
  end
  inherited MasterDS: TDataSource
    Top = 115
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankAccount_byInvoice'
    Params = <
      item
        Name = 'inMovementId_Invoice'
        Value = 41640d
        Component = GuidesInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 131
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 131
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
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
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
    object bbAddBonus: TdxBarButton
      Action = mactInsertProfitLossService
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint1: TdxBarButton
      Action = actPrint1
      Category = 0
      ShortCut = 16465
    end
    object bbisCopy: TdxBarButton
      Action = mactIsCopy
      Category = 0
    end
    object bb: TdxBarButton
      Action = macUpdateContract
      Category = 0
    end
    object bbUpdateMoneyPlace: TdxBarButton
      Action = macUpdateMoneyPlace
      Category = 0
    end
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_BankAccount'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_BankAccount'
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_BankAccount'
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
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCopy'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_BankAccount'
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 262
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpReport_BankAccount'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDetail'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 631
    Top = 232
  end
  object spUpdate_isCopy: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_isCopy'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCopy'
        Value = Null
        Component = FormParams
        ComponentItem = 'isCopy'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsCopy'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isCopy'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 243
  end
  object spUpdate_Invoice: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementLink_Invoice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId_Invoice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Invoice'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 153
  end
  object spUpdateContract: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_BankAccount_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 904
    Top = 169
  end
  object spUpdateJuridical: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_BankAccount_MoneyPlace'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MoneyPlaceId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 896
    Top = 217
  end
  object GuidesInvoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvoice
    FormNameParam.Value = 'TInvoiceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInvoiceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInvoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 65531
  end
end
