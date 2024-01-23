inherited BankAccountChildJournalForm: TBankAccountChildJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'> ('#1076#1077#1090#1072#1083#1100#1085#1086')'
  ClientHeight = 593
  ClientWidth = 1189
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1205
  ExplicitHeight = 632
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 56
    Width = 1189
    Height = 464
    TabOrder = 3
    ExplicitTop = 56
    ExplicitWidth = 1189
    ExplicitHeight = 464
    ClientRectBottom = 464
    ClientRectRight = 1189
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1189
      ExplicitHeight = 464
      inherited cxGrid: TcxGrid
        Width = 1189
        Height = 464
        ExplicitWidth = 1189
        ExplicitHeight = 464
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
              Column = Amount_ch2
            end
            item
              Kind = skSum
              Position = spFooter
              Column = Amount_ch2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_Pay_all
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
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = MoneyPlaceName
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_ch2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_Pay_all
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = 'Interne Nr'
            HeaderAlignmentHorz = taCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Options.Editing = False
            Width = 55
          end
          object InvNumberPartner: TcxGridDBColumn [2]
            Caption = 'External Nr'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Options.Editing = False
            Width = 56
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderHint = '6.Valutadatum'
            Options.Editing = False
            Width = 55
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            Visible = False
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
            HeaderHint = '12.Betrag'
            Options.Editing = False
            Width = 80
          end
          object AmountOut: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '12.Betrag'
            Options.Editing = False
            Width = 80
          end
          object MoneyPlaceName: TcxGridDBColumn
            Caption = 'Lieferanten / Kunden'
            DataBinding.FieldName = 'MoneyPlaceName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object ItemNameMoneyPlace: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemNameMoneyPlace'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ItemName_ch2: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090'***'
            DataBinding.FieldName = 'ItemName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object ObjectName_ch2: TcxGridDBColumn
            Caption = 'Lieferanten / Kunden ***'
            DataBinding.FieldName = 'ObjectName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 212
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '11. Verwendungszweck'
            Options.Editing = False
            Width = 100
          end
          object InvNumberFull_parent: TcxGridDBColumn
            Caption = '*'#8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumberFull_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object InvNumber_parent: TcxGridDBColumn
            Caption = '***'#8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumber_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object DescName_parent: TcxGridDBColumn
            Caption = '*'#1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DescName_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' ('#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object String_7: TcxGridDBColumn
            Caption = '7. Name Zahlungsbeteiligter'
            DataBinding.FieldName = 'String_7'
            FooterAlignmentHorz = taRightJustify
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '7. '#1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
            Options.Editing = False
            Width = 150
          end
          object Ord_ch2: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_ch2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091
            Options.Editing = False
            Width = 120
          end
          object Amount_invoice_ch2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1057#1095#1077#1090
            DataBinding.FieldName = 'Amount_invoice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 120
          end
          object Amount_Pay_all: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1087#1086' '#1042#1089#1077#1084' '#1057#1095#1077#1090#1072#1084
            DataBinding.FieldName = 'Amount_Pay_all'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1042#1089#1077#1084' '#1057#1095#1077#1090#1072#1084' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            Options.Editing = False
            Width = 97
          end
          object Comment_ch2: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment_child'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            Width = 100
          end
          object InvoiceKindName_ch2: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'InvoiceKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 100
          end
          object ReceiptNumber_Invoice_ch2: TcxGridDBColumn
            Caption = 'Inv No'
            DataBinding.FieldName = 'ReceiptNumber_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 120
          end
          object InvNumber_Invoice_Full_ch2: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
            DataBinding.FieldName = 'InvNumber_Invoice_Full'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actInvoiceDetailChoiceForm_Child
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Width = 200
          end
          object ObjectName_invoice_ch2: TcxGridDBColumn
            Caption = '***Lieferanten / Kunden'
            DataBinding.FieldName = 'ObjectName_invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 130
          end
          object InfoMoneyName_Invoice_ch2: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName_all_Invoice_ch2: TcxGridDBColumn
            Caption = '***'#1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName_all_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 80
          end
          object InvNumberFull_parent_ch2: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumberFull_parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 100
          end
          object MovementDescName_parent_ch2: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'MovementDescName_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 80
          end
          object ProductName_Invoice_ch2: TcxGridDBColumn
            Caption = 'Boat'
            DataBinding.FieldName = 'ProductName_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 120
          end
          object ProductCIN_Invoice_ch2: TcxGridDBColumn
            Caption = 'CIN Nr. Boat'
            DataBinding.FieldName = 'ProductCIN_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 120
          end
          object isErased_ch2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1189
    Height = 30
    ExplicitWidth = 1189
    ExplicitHeight = 30
    object lbSearchArticle: TcxLabel
      Left = 408
      Top = 4
      Hint = #1055#1086#1080#1089#1082' '#1076#1083#1103' '#1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      Caption = #1055#1086#1080#1089#1082' Inv No '#1089#1095#1077#1090':'
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearch_ReceiptNumber_Invoice: TcxTextEdit
      Left = 538
      Top = 5
      Hint = #1055#1086#1080#1089#1082' '#1076#1083#1103' '#1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      DesignSize = (
        100
        21)
      Width = 100
    end
    object cxLabel3: TcxLabel
      Left = 841
      Top = 4
      Caption = 'Lieferanten / Kunden: '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchMoneyPlaceName: TcxTextEdit
      Left = 992
      Top = 5
      TabOrder = 7
      DesignSize = (
        120
        21)
      Width = 120
    end
    object cxLabel4: TcxLabel
      Left = 656
      Top = 4
      Caption = #8470' '#1079#1072#1082#1072#1079':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchInvNumber_OrderClient: TcxTextEdit
      Left = 725
      Top = 5
      TabOrder = 9
      DesignSize = (
        100
        21)
      Width = 100
    end
  end
  object Panel_btn: TPanel [2]
    Left = 0
    Top = 520
    Width = 1189
    Height = 73
    Align = alBottom
    TabOrder = 6
    object btnInsert: TcxButton
      Left = 387
      Top = 10
      Width = 78
      Height = 25
      Action = actInsert
      TabOrder = 0
    end
    object btnUpdate: TcxButton
      Left = 469
      Top = 10
      Width = 78
      Height = 25
      Action = actUpdate
      TabOrder = 1
    end
    object btnComplete: TcxButton
      Left = 387
      Top = 41
      Width = 160
      Height = 25
      Action = actComplete
      TabOrder = 2
    end
    object btnUnComplete: TcxButton
      Left = 557
      Top = 10
      Width = 143
      Height = 25
      Action = actUnComplete
      TabOrder = 3
    end
    object btnSetErased: TcxButton
      Left = 557
      Top = 41
      Width = 143
      Height = 25
      Action = actSetErased
      TabOrder = 4
    end
    object btnFormClose: TcxButton
      Left = 777
      Top = 41
      Width = 153
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object cxButton1: TcxButton
      Left = 12
      Top = 10
      Width = 108
      Height = 25
      Action = actInsert_Child
      TabOrder = 6
    end
    object cxButton2: TcxButton
      Left = 12
      Top = 41
      Width = 108
      Height = 25
      Action = actUpdate_Child
      TabOrder = 7
    end
    object cxButton3: TcxButton
      Left = 247
      Top = 41
      Width = 108
      Height = 25
      Action = mactSetErasedItem
      TabOrder = 8
    end
    object cxButton4: TcxButton
      Left = 126
      Top = 10
      Width = 115
      Height = 25
      Action = mactPrint_Invoice
      TabOrder = 9
    end
    object cxButton5: TcxButton
      Left = 126
      Top = 41
      Width = 115
      Height = 25
      Action = actOpenFormPdfEdit
      TabOrder = 10
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
    Top = 51
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 50
    object actOpenFormPdfEdit: TdsdOpenForm [0]
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100' PDF'
      Hint = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100' PDF'
      ImageIndex = 60
      FormName = 'TBankAccountPdfEditForm'
      FormNameParam.Value = 'TBankAccountPdfEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
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
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovmentItemId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId_child'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          Component = actShowErased
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    object actRefreshChild: TdsdDataSetRefresh [4]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actInsert: TdsdInsertUpdateAction
      ShortCut = 16433
      FormName = 'TBankAccountChildForm'
      FormNameParam.Value = 'TBankAccountChildForm'
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
        end
        item
          Name = 'inMovementId_parent'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementItemId_child'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMoneyPlaceId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Invoice'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      ShortCut = 0
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
      FormName = 'TBankAccountChildForm'
      FormNameParam.Value = 'TBankAccountChildForm'
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
        end
        item
          Name = 'inMovementItemId_child'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId_child'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementItemId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited mactReCompleteList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    inherited mactCompleteList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    inherited mactUnCompleteList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1086#1090#1084#1077#1085#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1086#1090#1084#1077#1085#1080#1083#1086#1089#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    inherited mactSetErasedList: TMultiAction
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
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
    object actUpdateDataSetChild: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
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
    object actInvoiceDetailChoiceForm_Child: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'acInvoiceJournalDetailChoiceForm'
      FormName = 'TInvoiceJournalChoiceForm'
      FormNameParam.Value = 'TInvoiceJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumber_Full'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterClientId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterClientName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actInvoiceJournalDetailChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'acInvoiceJournalDetailChoiceForm'
      FormName = 'TInvoiceJournalChoiceForm'
      FormNameParam.Value = 'TInvoiceJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Invoice_Full'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Invoice'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterClientId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MoneyPlaceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterClientName'
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
    object mactSetErasedItem: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetErasedItem
        end
        item
          Action = actRefreshChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1095#1077#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actSetErasedItem: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
    end
    object actOpenInvoiceForm: TdsdOpenForm
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1057#1095#1077#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1057#1095#1077#1090'>'
      ImageIndex = 28
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Invoice'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          Component = actShowErased
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_Child: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1057#1095#1077#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 1
      FormName = 'TBankAccountMovementChildForm'
      FormNameParam.Value = 'TBankAccountMovementChildForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementItemId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId_child'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inParentId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object mactSetUnErasedItem: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetUnErasedItem
        end
        item
          Action = actRefreshChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1095#1077#1090
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          ComponentItem = 'Id'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      ImageIndex = 80
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
    end
    object actGetImportSetting_csv: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting_csv'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1041#1072#1085#1082#1086#1074#1089#1082#1080#1093' '#1074#1099#1087#1080#1089#1086#1082' '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object mactStartLoad_csv: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_csv
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1041#1072#1085#1082#1086#1074#1089#1082#1091#1102' '#1074#1099#1087#1080#1089#1082#1091' '#1080#1079' '#1092#1072#1081#1083#1072' csv?'
      InfoAfterExecute = #1041#1072#1085#1082#1086#1074#1089#1082#1072#1103' '#1074#1099#1087#1080#1089#1082#1072' '#1079#1072#1075#1088#1091#1078#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1041#1072#1085#1082#1086#1074#1089#1082#1091#1102' '#1074#1099#1087#1080#1089#1082#1091' '#1080#1079' '#1092#1072#1081#1083#1072' csv'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1041#1072#1085#1082#1086#1074#1089#1082#1091#1102' '#1074#1099#1087#1080#1089#1082#1091' '#1080#1079' '#1092#1072#1081#1083#1072' csv'
      ImageIndex = 41
      WithoutNext = True
    end
    object actInsert_Child: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1057#1095#1077#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 0
      FormName = 'TBankAccountMovementChildForm'
      FormNameParam.Value = 'TBankAccountMovementChildForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementItemId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inParentId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountChild_diff'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountChild_diff'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actSetUnErasedItem: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
    object actPrintInvoice: TdsdPrintAction
      Category = 'Print'
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
      StoredProc = spSelectPrint_Invoice
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Invoice
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintReturnCDS
          UserName = 'frxDBDReturn'
        end
        item
          DataSet = PrintOptionCDS
          UserName = 'frxDBDOption'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44927d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44927d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Invoice1'
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameInvoice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInvoiceReportName: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName_invoice
      StoredProcList = <
        item
          StoredProc = spGetReportName_invoice
        end>
      Caption = 'actInvoiceReportName'
    end
    object mactPrint_Invoice: TMultiAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actInvoiceReportName
        end
        item
          Action = actPrintInvoice
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090
      ImageIndex = 3
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 163
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 163
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankAccountChild'
    Top = 131
  end
  inherited BarManager: TdxBarManager
    Left = 48
    Top = 51
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
          ItemName = 'bbsView'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsDoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDetail'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
        end>
    end
    object bbAddBonus: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074
      Visible = ivAlways
      ImageIndex = 27
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
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074' '#1044#1072'/'#1053#1077#1090'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074' '#1044#1072'/'#1053#1077#1090'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbOpenInvoiceForm: TdxBarButton
      Action = actOpenInvoiceForm
      Category = 0
    end
    object bbUpdateMoneyPlace: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091'>'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091'>'
      Visible = ivAlways
      ImageIndex = 55
    end
    object bbStartLoad: TdxBarButton
      Action = mactStartLoad_csv
      Category = 0
    end
    object bbInsert_Child: TdxBarButton
      Action = actInsert_Child
      Category = 0
    end
    object bbUpdate_Child: TdxBarButton
      Action = actUpdate_Child
      Category = 0
    end
    object bbsView: TdxBarSubItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088
      Category = 0
      Visible = ivAlways
      ImageIndex = 83
      LargeImageIndex = 83
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end>
    end
    object dxBarSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbsDoc: TdxBarSubItem
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 8
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
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
        end>
    end
    object bbDetail: TdxBarSubItem
      Caption = #1057#1095#1077#1090#1072
      Category = 0
      Visible = ivAlways
      ImageIndex = 7
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert_Child'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Child'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedItem'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedItem'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbtPrint_Invoice'
        end
        item
          Visible = True
          ItemName = 'bbOpenInvoiceForm'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormPdfEdit'
        end>
    end
    object bbsLoadForm: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 41
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStartLoad'
        end>
    end
    object bbSetErasedItem: TdxBarButton
      Action = mactSetErasedItem
      Category = 0
    end
    object bbSetUnErasedItem: TdxBarButton
      Action = mactSetUnErasedItem
      Category = 0
    end
    object bbOpenFormPdfEdit: TdxBarButton
      Action = actOpenFormPdfEdit
      Category = 0
    end
    object bbtPrint_Invoice: TdxBarButton
      Action = mactPrint_Invoice
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 136
    Top = 56
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
    Left = 24
    Top = 304
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
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_BankAccount'
    Left = 336
    Top = 144
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
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchInvNumber_OrderClient
    DataSet = MasterCDS
    Column = InvNumber_parent
    ColumnList = <
      item
        Column = InvNumber_parent
      end
      item
        TextEdit = edSearch_ReceiptNumber_Invoice
      end
      item
        Column = MoneyPlaceName
        TextEdit = edSearchMoneyPlaceName
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 984
    Top = 128
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TBankAccountJournalForm;zc_Object_ImportSetting_BankAccount_csv'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 160
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMI_BankAccount_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId_child'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 368
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMI_BankAccount_SetUnErased'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId_child'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 368
  end
  object spSelectPrint_Invoice: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Invoice_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintReturnCDS
      end
      item
        DataSet = PrintOptionCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 216
  end
  object spGetReportName_invoice: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Invoice_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_parent'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_Invoice_ReportName'
        Value = 'PrintMovement_Invoice1'
        Component = FormParams
        ComponentItem = 'ReportNameInvoice'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 160
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 780
    Top = 233
  end
  object PrintReturnCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 812
    Top = 278
  end
  object PrintOptionCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 876
    Top = 286
  end
end
