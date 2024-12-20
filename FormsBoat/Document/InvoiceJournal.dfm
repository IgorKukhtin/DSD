﻿inherited InvoiceJournalForm: TInvoiceJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1057#1095#1077#1090#1072'>'
  ClientHeight = 569
  ClientWidth = 1279
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1295
  ExplicitHeight = 608
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1279
    Height = 282
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1279
    ExplicitHeight = 282
    ClientRectBottom = 282
    ClientRectRight = 1279
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1279
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 1279
        Height = 282
        ExplicitWidth = 1279
        ExplicitHeight = 282
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
              Column = AmountIn_NotVAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_NotVAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_VAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_VAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_real
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
              Column = AmountOut_NotVAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_VAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_VAT
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountOut_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_BankAccount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount_rem
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_NotVAT
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ObjectName
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountIn_real
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
          object isAuto: TcxGridDBColumn [1]
            Caption = 'Auto'
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object isFilesNotUploaded: TcxGridDBColumn [2]
            Caption = #1054#1090#1084#1077#1085#1072' '#1074' DropBox'
            DataBinding.FieldName = 'isFilesNotUploaded'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1083#1086#1078#1080#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1074' DropBox ('#1044#1072'/'#1053#1077#1090')'
            Options.Editing = False
            Width = 77
          end
          object isPostedToDropBox: TcxGridDBColumn [3]
            Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086' '#1074' DropBox'
            DataBinding.FieldName = 'isPostedToDropBox'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1087#1086#1083#1085#1077#1085#1072' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1086#1090#1087#1088#1072#1074#1082#1072' '#1074' DropBox ('#1044#1072'/'#1053#1077#1090')'
            Options.Editing = False
            Width = 80
          end
          object DateUnloading: TcxGridDBColumn [4]
            Caption = #1042#1088#1077#1084#1103' '#1074' DropBox'
            DataBinding.FieldName = 'DateUnloading'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1074#1099#1087#1086#1083#1085#1077#1085#1085#1086#1081' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' DropBox'
            Options.Editing = False
            Width = 116
          end
          object InvoiceKindName: TcxGridDBColumn [5]
            Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'InvoiceKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object ReceiptNumber: TcxGridDBColumn [6]
            Caption = 'Inv No'
            DataBinding.FieldName = 'ReceiptNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
            Options.Editing = False
            Width = 70
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 63
          end
          object InvNumberPartner: TcxGridDBColumn [8]
            Caption = 'Externe Nr'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1082#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          object PlanDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' ('#1087#1083#1072#1085')'
            DataBinding.FieldName = 'PlanDate'
            Visible = False
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1057#1095#1077#1090#1091' ('#1087#1083#1072#1085')'
            Options.Editing = False
            Width = 70
          end
          object AmountIn_real: TcxGridDBColumn
            Caption = '***Debet'
            DataBinding.FieldName = 'AmountIn_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1044#1057' '#1087#1086' '#1089#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 80
          end
          object AmountIn: TcxGridDBColumn
            Caption = 'Debet'
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1044#1057' '#1087#1086' '#1089#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountOut: TcxGridDBColumn
            Caption = 'Kredit'
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1044#1057' '#1087#1086' '#1089#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountIn_VAT: TcxGridDBColumn
            Caption = 'Debet Vat'
            DataBinding.FieldName = 'AmountIn_VAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1044#1057' '#1087#1086' '#1089#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountOut_VAT: TcxGridDBColumn
            Caption = 'Kredit Vat'
            DataBinding.FieldName = 'AmountOut_VAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1044#1057' '#1087#1086' '#1089#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountIn_NotVAT: TcxGridDBColumn
            Caption = 'Debet no_Vat'
            DataBinding.FieldName = 'AmountIn_NotVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1044#1057' '#1087#1086' '#1089#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountOut_NotVAT: TcxGridDBColumn
            Caption = 'Kredit no_Vat'
            DataBinding.FieldName = 'AmountOut_NotVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1044#1057' '#1087#1086' '#1089#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object Amount_BankAccount: TcxGridDBColumn
            Caption = 'Total (Payment)'
            DataBinding.FieldName = 'Amount_BankAccount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1054#1087#1083#1072#1090#1072' '#1087#1086' '#1057#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object Amount_rem: TcxGridDBColumn
            Caption = 'Total (balance)'
            DataBinding.FieldName = 'Amount_rem'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1086#1087#1083#1072#1090#1077' '#1087#1086' '#1057#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountIn_BankAccount: TcxGridDBColumn
            Caption = 'Debet (Payment)'
            DataBinding.FieldName = 'AmountIn_BankAccount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1093#1086#1076' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1057#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountOut_BankAccount: TcxGridDBColumn
            Caption = 'Kredit (Payment)'
            DataBinding.FieldName = 'AmountOut_BankAccount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1093#1086#1076' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1057#1095#1077#1090#1091', '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object AmountIn_rem: TcxGridDBColumn
            Caption = 'Debet (balance)'
            DataBinding.FieldName = 'AmountIn_rem'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1082' '#1086#1087#1083#1072#1090#1077' '#1087#1086' '#1089#1095#1077#1090#1091', '#1055#1088#1080#1093#1086#1076
            Options.Editing = False
            Width = 70
          end
          object AmountOut_rem: TcxGridDBColumn
            Caption = 'Kredit (balance)'
            DataBinding.FieldName = 'AmountOut_rem'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1082' '#1086#1087#1083#1072#1090#1077' '#1087#1086' '#1089#1095#1077#1090#1091', '#1056#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 70
          end
          object ObjectName: TcxGridDBColumn
            Caption = 'Lieferanten / Kunden'
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' / '#1050#1083#1080#1077#1085#1090
            Options.Editing = False
            Width = 128
          end
          object ObjectDescName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ObjectDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' / '#1050#1083#1080#1077#1085#1090
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object VATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object TaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1053#1044#1057
            DataBinding.FieldName = 'TaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TaxKindName_info: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1053#1044#1057
            DataBinding.FieldName = 'TaxKindName_info'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object TaxKindName_Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1053#1044#1057
            DataBinding.FieldName = 'TaxKindName_Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            Options.Editing = False
            Width = 120
          end
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = '***'#1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1055' '#1057#1090#1072#1090#1100#1103
            Options.Editing = False
            Width = 80
          end
          object Comment: TcxGridDBColumn
            Caption = #1058#1077#1082#1089#1090
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1082#1083#1072#1076
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076'/'#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object Comment_Product: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' (Boat)'
            DataBinding.FieldName = 'Comment_Product'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InvNumberFull_parent: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumberFull_parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 109
          end
          object ProductCIN: TcxGridDBColumn
            Caption = 'CIN Nr.'
            DataBinding.FieldName = 'ProductCIN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 100
          end
          object ProductCode: TcxGridDBColumn
            Caption = 'Interne Nr (Boat)'
            DataBinding.FieldName = 'ProductCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 43
          end
          object ProductName: TcxGridDBColumn
            Caption = 'Boat'
            DataBinding.FieldName = 'ProductName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 78
          end
          object InvNumber_parent: TcxGridDBColumn
            Caption = '***'#8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumber_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 109
          end
          object MovementDescName_parent: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'MovementDescName_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072'/'#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 110
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
            Width = 85
          end
          object Color_Pay: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Pay'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1279
    Height = 65
    ExplicitWidth = 1279
    ExplicitHeight = 65
    inherited deEnd: TcxDateEdit
      Left = 315
      ExplicitLeft = 315
    end
    object cxLabel4: TcxLabel
      Left = 248
      Top = 34
      Caption = #8470' '#1079#1072#1082#1072#1079':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearch_InvNumber_OrderClient: TcxTextEdit
      Left = 318
      Top = 35
      TabOrder = 5
      DesignSize = (
        100
        21)
      Width = 100
    end
    object edSearch_ReceiptNumber_Invoice: TcxTextEdit
      Left = 135
      Top = 35
      Hint = #1055#1086#1080#1089#1082' '#1076#1083#1103' '#1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      DesignSize = (
        100
        21)
      Width = 100
    end
    object cxLabel3: TcxLabel
      Left = 426
      Top = 34
      Caption = 'Lieferanten / Kunden: '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearch_ObjectName: TcxTextEdit
      Left = 577
      Top = 35
      TabOrder = 8
      DesignSize = (
        120
        21)
      Width = 120
    end
    object lbSearchArticle: TcxLabel
      Left = 3
      Top = 34
      Hint = #1055#1086#1080#1089#1082' '#1076#1083#1103' '#1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      Caption = #1055#1086#1080#1089#1082' Inv No '#1089#1095#1077#1090': '
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
    object cxLabel5: TcxLabel
      Left = 710
      Top = 6
      Caption = #1071#1079#1099#1082':'
    end
    object edLanguage: TcxButtonEdit
      Left = 745
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Text = #1040#1085#1075#1083#1080#1081#1089#1082#1080#1081
      Width = 141
    end
  end
  object Panel_btn: TPanel [2]
    Left = 0
    Top = 496
    Width = 1279
    Height = 73
    Align = alBottom
    TabOrder = 6
    object btnUpdate: TcxButton
      Left = 218
      Top = 8
      Width = 111
      Height = 25
      Action = actUpdate
      TabOrder = 0
    end
    object btnComplete: TcxButton
      Left = 805
      Top = 8
      Width = 160
      Height = 25
      Action = actComplete
      TabOrder = 1
    end
    object btnSetErased: TcxButton
      Left = 805
      Top = 42
      Width = 160
      Height = 25
      Action = actSetErased
      TabOrder = 2
    end
    object btnFormClose: TcxButton
      Left = 989
      Top = 8
      Width = 130
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object cxButton1: TcxButton
      Left = 633
      Top = 42
      Width = 145
      Height = 25
      Action = actOpenBankAccountJournalByInvoice
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' - <'#1054#1087#1083#1072#1090#1099'>'
      TabOrder = 4
    end
    object cxButton5: TcxButton
      Left = 989
      Top = 42
      Width = 130
      Height = 25
      Action = actSetVisible_Grid_Item
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object cxButton3: TcxButton
      Left = 10
      Top = 8
      Width = 95
      Height = 25
      Action = actInsert
      TabOrder = 6
    end
    object cxButton4: TcxButton
      Left = 111
      Top = 8
      Width = 95
      Height = 25
      Action = actInsert_Pay
      TabOrder = 7
    end
    object cxButton7: TcxButton
      Left = 10
      Top = 42
      Width = 95
      Height = 25
      Action = actInsert_Proforma
      TabOrder = 8
    end
    object cxButton8: TcxButton
      Left = 111
      Top = 42
      Width = 95
      Height = 25
      Action = actInsert_Service
      TabOrder = 9
    end
    object btnOpenFormPdfEdit: TcxButton
      Left = 218
      Top = 42
      Width = 111
      Height = 25
      Action = actOpenFormPdfEdit
      TabOrder = 10
    end
    object cxButton6: TcxButton
      Left = 334
      Top = 42
      Width = 137
      Height = 25
      Action = actFilesNotUploaded
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
    end
    object btnUpdate_PostedToDropBox: TcxButton
      Left = 334
      Top = 8
      Width = 137
      Height = 25
      Action = actUpdate_PostedToDropBox
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
    end
    object btnInsertAction: TcxButton
      Left = 481
      Top = 8
      Width = 145
      Height = 25
      Action = mactInsertItem
      TabOrder = 13
    end
    object cxButton2: TcxButton
      Left = 633
      Top = 8
      Width = 145
      Height = 25
      Action = mactUpdateItem
      TabOrder = 14
    end
    object btnSetErasedItem: TcxButton
      Left = 481
      Top = 42
      Width = 145
      Height = 25
      Action = mactSetErasedItem
      TabOrder = 15
    end
  end
  object cxGrid_Item: TcxGrid [3]
    Left = 0
    Top = 381
    Width = 1279
    Height = 115
    Align = alBottom
    TabOrder = 7
    object cxGridDBTableView_Det: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ItemDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_ch4
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummMVAT_ch4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummPVAT_ch4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Summа_VAT_ch4
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_ch4
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = 'C'#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName_ch4
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummMVAT_ch4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummPVAT_ch4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Summа_VAT_ch4
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Ord_ch4: TcxGridDBColumn
        Caption = #8470' '#1087'/'#1087
        DataBinding.FieldName = 'Ord'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Comment_ch4: TcxGridDBColumn
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 362
      end
      object Article_ch4: TcxGridDBColumn
        Caption = 'Artikel Nr'
        DataBinding.FieldName = 'Article'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GoodsCode_ch4: TcxGridDBColumn
        Caption = 'Interne Nr'
        DataBinding.FieldName = 'GoodsCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 130
      end
      object GoodsName_ch4: TcxGridDBColumn
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
        DataBinding.FieldName = 'GoodsName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceFormGoods_item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 199
      end
      object Amount_ch4: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 66
      end
      object OperPrice_ch4: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
        DataBinding.FieldName = 'OperPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 88
      end
      object isErased_ch4: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object SummMVAT_ch4: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
        DataBinding.FieldName = 'SummMVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object SummPVAT_ch4: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
        DataBinding.FieldName = 'SummPVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Summа_VAT_ch4: TcxGridDBColumn
        Caption = #1053#1044#1057
        DataBinding.FieldName = 'Summ'#1072'_VAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
    end
    object cxGridLevel_Det: TcxGridLevel
      GridView = cxGridDBTableView_Det
    end
  end
  object cxSplitter_Bottom_Item: TcxSplitter [4]
    Left = 0
    Top = 373
    Width = 1279
    Height = 8
    AlignSplitter = salBottom
    Control = cxGrid_Item
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = actSetVisible_Grid_Item
        Properties.Strings = (
          'Value')
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
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actOpenIncomeByInvoice: TdsdOpenForm [0]
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1086' '#1089#1095#1077#1090#1091' - <'#1055#1088#1080#1093#1086#1076' / '#1059#1089#1083#1091#1075#1080'>'
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1089#1095#1077#1090#1091' - '#1046#1091#1088#1085#1072#1083' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      ImageIndex = 24
      FormName = 'TIncomeJournalByInvoiceForm'
      FormNameParam.Value = 'TIncomeJournalByInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId_Invoice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull_Invoice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Full'
          DataType = ftString
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
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object mactExport_invoice: TMultiAction [1]
      Category = 'Export_Email'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_Email
        end
        item
          Action = actInvoiceReportName
        end
        item
          Action = actPrintInvoice_save
        end
        item
          Action = actInsertDocument
        end
        item
          Action = actSMTPFile_DBF
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1057#1095#1077#1090' PDF '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1057#1095#1077#1090' PDF '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1057#1095#1077#1090' PDF'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1057#1095#1077#1090' PDF'
      ImageIndex = 53
    end
    inherited actInsert: TdsdInsertUpdateAction [2]
      Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1086#1087#1083#1072#1090#1072
      ShortCut = 16433
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44927d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_OrderClient'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindDesc'
          Value = 'zc_Enum_InvoiceKind_PrePay'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actInsert_Pay: TdsdInsertUpdateAction [3]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1095#1077#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1057#1095#1077#1090
      ShortCut = 16434
      ImageIndex = 0
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44927d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_OrderClient'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindDesc'
          Value = 'zc_Enum_InvoiceKind_Pay'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert_Proforma: TdsdInsertUpdateAction [4]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1092#1086#1088#1084#1072
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1055#1088#1086#1092#1086#1088#1084#1072
      ShortCut = 16435
      ImageIndex = 0
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44927d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_OrderClient'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindDesc'
          Value = 'zc_Enum_InvoiceKind_Proforma'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert_Service: TdsdInsertUpdateAction [5]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1059#1089#1083#1091#1075#1080
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1059#1089#1083#1091#1075#1080
      ShortCut = 16436
      ImageIndex = 0
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44927d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_OrderClient'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindDesc'
          Value = 'zc_Enum_InvoiceKind_Service'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actOpenIncomeCostByInvoice: TdsdOpenForm [6]
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1086' '#1089#1095#1077#1090#1091' - <'#1055#1088#1080#1093#1086#1076' ('#1079#1072#1090#1088#1072#1090#1099')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1086' '#1089#1095#1077#1090#1091' - <'#1055#1088#1080#1093#1086#1076' ('#1079#1072#1090#1088#1072#1090#1099')>'
      ImageIndex = 26
      FormName = 'TIncomeCostJournalByInvoiceForm'
      FormNameParam.Value = 'TIncomeCostJournalByInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId_Invoice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull_Invoice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Full'
          DataType = ftString
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
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited actMovementItemContainer: TdsdOpenForm [7]
    end
    inherited actMovementProtocolOpenForm: TdsdOpenForm [8]
    end
    object actRefreshMov: TdsdDataSetRefresh [9]
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
    inherited actShowErased: TBooleanStoredProcAction [10]
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectMI
        end>
    end
    inherited actRefresh: TdsdDataSetRefresh [11]
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectMI
        end>
    end
    inherited actGridToExcel: TdsdGridToExcel [12]
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      ShortCut = 0
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      GuiParams = <
        item
          Name = 'Id'
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
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
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
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actSetErased: TdsdChangeMovementStatus
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'> '#1091#1076#1072#1083#1077#1085
    end
    inherited mactReCompleteList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    inherited mactCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactUnCompleteList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1086#1090#1084#1077#1085#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1086#1090#1084#1077#1085#1080#1083#1086#1089#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    inherited mactSetErasedList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object mactPrint_Invoice: TMultiAction [28]
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
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      ShortCut = 16464
    end
    object actInvoiceReportName: TdsdExecStoredProc [29]
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName
      StoredProcList = <
        item
          StoredProc = spGetReportName
        end>
      Caption = 'actInvoiceReportName'
    end
    object actPrintInvoice: TdsdPrintAction [30]
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
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
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
        end
        item
          Name = 'LanguageCode'
          Value = Null
          Component = FormParams
          ComponentItem = 'LanguageCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Invoice1'
      ReportNameParam.Value = 'PrintMovement_Invoice1'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameInvoice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateDataSet_item: TdsdUpdateDataSet [33]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateItem
      StoredProcList = <
        item
          StoredProc = spInsertUpdateItem
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = 'actUpdateDataSet'
      DataSource = ItemDS
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
      Enabled = False
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
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
      ReportName = 'PrintMovement_Invoice'
      ReportNameParam.Value = 'PrintMovement_Invoice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    object actMasterPost: TDataSetPost
      Category = 'DSDLib'
      Caption = 'actMasterPost'
      Hint = 'actMasterPost'
      DataSource = MasterDS
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
    object mactInsertItem: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertAction
        end
        item
          Action = actRefresh
        end>
      Caption = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> '#1080#1083#1080' <'#1059#1089#1083#1091#1075#1080'>'
      ImageIndex = 0
      ShortCut = 16437
    end
    object mactSetUnErasedItem: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetUnErasedItem
        end
        item
          Action = actRefreshMov
        end>
      Caption = '***'#1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> '#1080#1083#1080' <'#1059#1089#1083#1091#1075#1080'>'
      ImageIndex = 8
      ShortCut = 49220
    end
    object actSetUnErasedItem: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ItemDS
    end
    object actOpenBankAccountJournalByInvoice: TdsdOpenForm
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1086' '#1089#1095#1077#1090#1091' - <'#1054#1087#1083#1072#1090#1099'>'
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1089#1095#1077#1090#1091' - '#1046#1091#1088#1085#1072#1083' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
      ImageIndex = 25
      FormName = 'TBankAccountJournalByInvoiceForm'
      FormNameParam.Value = 'TBankAccountJournalByInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId_Invoice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull_Invoice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Full'
          DataType = ftString
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
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 0
      FormName = 'TInvoiceItemEditForm'
      FormNameParam.Value = 'TInvoiceItemEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = 0
          Component = ItemCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object actUpdateAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080' '#1094#1077#1085#1099'>'
      ImageIndex = 1
      FormName = 'TInvoiceItemEditForm'
      FormNameParam.Value = 'TInvoiceItemEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ItemCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ItemCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object actSetVisible_Grid_Item: TBooleanSetVisibleAction
      MoveParams = <>
      Value = False
      Components = <
        item
        end
        item
          Component = cxGrid_Item
        end>
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1044#1077#1090#1072#1083#1100#1085#1086
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1044#1077#1090#1072#1083#1100#1085#1086
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1044#1077#1090#1072#1083#1100#1085#1086
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1044#1077#1090#1072#1083#1100#1085#1086
      ImageIndexTrue = 31
      ImageIndexFalse = 32
    end
    object mactUpdateItem: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAction
        end
        item
          Action = actRefresh
        end>
      Caption = '***'#1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> '#1080#1083#1080' <'#1059#1089#1083#1091#1075#1080'>'
      ImageIndex = 1
      ShortCut = 16438
    end
    object mactSetErasedItem: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetErasedItem
        end
        item
          Action = actRefreshMov
        end>
      Caption = '***'#1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> '#1080#1083#1080' <'#1059#1089#1083#1091#1075#1080'>'
      ImageIndex = 2
      ShortCut = 49220
    end
    object actSetErasedItem: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ItemDS
    end
    object actChoiceFormGoods_item: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods_item'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ItemCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ItemCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ItemCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ItemCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice_choice'
          Value = Null
          Component = ItemCDS
          ComponentItem = 'OperPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenFormPdfEdit: TdsdOpenForm
      Category = 'OpenForm'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' PDF'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' PDF'
      ImageIndex = 26
      FormName = 'TInvoicePdfEditForm'
      FormNameParam.Value = 'TInvoicePdfEditForm'
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
          ComponentItem = 'Id'
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
    object actInsertDocument: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'InvoicePdfId'
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertDocument
      StoredProcList = <
        item
          StoredProc = spInsertDocument
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
    end
    object actDocumentOpenInvoice: TDocumentOpenAction
      Category = 'Print'
      MoveParams = <>
      Document = DocumentInvoice
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1057#1082#1072#1085
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object mactSave_Invoice: TMultiAction
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
          Action = actPrintInvoice_save
        end
        item
          Action = actInsertDocument
        end
        item
          Action = actDocumentOpenInvoice
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090' + '#1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090' + '#1057#1086#1093#1088#1072#1085#1080#1090#1100
    end
    object actPrintInvoice_save: TdsdPrintAction
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
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
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
        end
        item
          Name = 'frxPDFExport_find'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxPDFExport1_ShowDialog'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxPDFExport1_EmbeddedFonts'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxPDFExport1_Background'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'ExportDirectory'
          Value = 'GetTempPath'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FileNameExport'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvoiceFileName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GetFileNameExport'
          Value = '789C535018D10000F1E01FE1'
          Component = DocumentInvoice
          ComponentItem = 'FileName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Invoice1'
      ReportNameParam.Value = 'PrintMovement_Invoice1'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameInvoice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actFilesNotUploaded: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_FilesNotUploaded
      StoredProcList = <
        item
          StoredProc = spUpdate_FilesNotUploaded
        end>
      Caption = #1054#1090#1084#1077#1085#1072' '#1074' DropBox'
      Hint = #1054#1090#1083#1086#1078#1080#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1074' DropBox ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 82
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1054#1090#1083#1086#1078#1080#1090#1100'/'#1042#1082#1083#1102#1095#1080#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1074' DropBox?'
    end
    object actUpdate_PostedToDropBox: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PostedToDropBox
      StoredProcList = <
        item
          StoredProc = spUpdate_PostedToDropBox
        end>
      Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1100' '#1074' DropBox'
      Hint = #1042#1082#1083#1102#1095#1080#1090#1100' '#1057#1095#1077#1090' '#1074' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1091#1102' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1074' DropBox?'
      ImageIndex = 81
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1082#1083#1102#1095#1080#1090#1100' '#1057#1095#1077#1090' '#1074' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1091#1102' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1074' DropBox?'
      InfoAfterExecute = #1044#1083#1103' '#1057#1095#1077#1090#1072' '#1074#1082#1083#1102#1095#1077#1085#1072' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1086#1090#1087#1088#1072#1074#1082#1072' '#1074' DropBox'
    end
    object actGet_Export_Email: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_ImportSettings_Email
      StoredProcList = <
        item
          StoredProc = spGet_ImportSettings_Email
        end>
      Caption = 'actGet_Export_Email'
    end
    object actSMTPFile_DBF: TdsdSMTPFileAction
      Category = 'Export_Email'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = DocumentInvoice
          FromParam.ComponentItem = 'FileName'
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = actSMTPFile_DBF
          ToParam.DataType = ftString
          ToParam.MultiSelectSeparator = ','
        end>
      Host.Value = Null
      Host.Component = ExportEmailCDS
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = ExportEmailCDS
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = ExportEmailCDS
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = ExportEmailCDS
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = ExportEmailCDS
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = DocumentInvoice
      Subject.ComponentItem = 'FileName'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = ExportEmailCDS
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = ExportEmailCDS
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Top = 115
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Invoice'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
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
        Name = 'inClientId'
        Value = '0'
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
          BeginGroup = True
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
          ItemName = 'bbsOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSave_Invoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Invoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExport_invoice'
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
      Caption = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      Category = 0
      Hint = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16465
    end
    object bbisCopy: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074' '#1044#1072'/'#1053#1077#1090'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074' '#1044#1072'/'#1053#1077#1090'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbUpdateMoneyPlace: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091'>'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091'>'
      Visible = ivAlways
      ImageIndex = 55
    end
    object bbOpenBankAccountJournalByInvoice: TdxBarButton
      Action = actOpenBankAccountJournalByInvoice
      Category = 0
    end
    object bbOpenIncomeCostByInvoice: TdxBarButton
      Action = actOpenIncomeCostByInvoice
      Category = 0
    end
    object bbtPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbOpenIncomeByInvoice: TdxBarButton
      Action = actOpenIncomeByInvoice
      Category = 0
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1089#1095#1077#1090#1091' - '#1046#1091#1088#1085#1072#1083' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object bbDetail: TdxBarSubItem
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086
      Category = 0
      Visible = ivAlways
      ImageIndex = 7
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertAction'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAction'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedItem'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end>
    end
    object bbInsertAction: TdxBarButton
      Action = mactInsertItem
      Category = 0
    end
    object bbUpdateAction: TdxBarButton
      Action = mactUpdateItem
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = mactSetUnErasedItem
      Category = 0
    end
    object bbSetErasedItem: TdxBarButton
      Action = mactSetErasedItem
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrint_Invoice: TdxBarButton
      Action = mactPrint_Invoice
      Category = 0
    end
    object bbsView: TdxBarSubItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088
      Category = 0
      Visible = ivAlways
      ImageIndex = 83
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end>
    end
    object bbsDoc: TdxBarSubItem
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 8
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbInsert_Pay'
        end
        item
          Visible = True
          ItemName = 'bbInsert_Proforma'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
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
    object bbsOpenForm: TdxBarSubItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 24
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbOpenBankAccountJournalByInvoice'
        end
        item
          Visible = True
          ItemName = 'bbOpenIncomeByInvoice'
        end
        item
          Visible = True
          ItemName = 'bbOpenIncomeCostByInvoice'
        end>
    end
    object bbInsert_Pay: TdxBarButton
      Action = actInsert_Pay
      Category = 0
    end
    object bbInsert_Proforma: TdxBarButton
      Action = actInsert_Proforma
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actInsert_Service
      Category = 0
    end
    object bbSave_Invoice: TdxBarButton
      Action = mactSave_Invoice
      Category = 0
    end
    object bbExport_invoice: TdxBarButton
      Action = mactExport_invoice
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = Color_Pay
        ColorValueList = <>
      end>
    Left = 248
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
    StoredProcName = 'gpComplete_Movement_Invoice'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Invoice'
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Invoice'
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
        Name = 'ReportNameInvoice'
        Value = 'PrintMovement_Invoice1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceFileName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoicePdfId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'LanguageId'
        Value = '179'
        Component = GuidesLanguage
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LanguageName'
        Value = #1040#1085#1075#1083#1080#1081#1089#1082#1080#1081
        Component = GuidesLanguage
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LanguageCode'
        Value = '3'
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Invoice'
    Left = 456
    Top = 120
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 756
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
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
        Value = 41640d
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 615
    Top = 216
  end
  object FieldFilter_InvNumber_parent: TdsdFieldFilter
    TextEdit = edSearch_InvNumber_OrderClient
    DataSet = MasterCDS
    Column = InvNumber_parent
    ColumnList = <
      item
        Column = InvNumber_parent
      end
      item
        Column = Comment_Product
      end
      item
        Column = ReceiptNumber
        TextEdit = edSearch_ReceiptNumber_Invoice
      end
      item
        Column = ObjectName
        TextEdit = edSearch_ObjectName
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 592
    Top = 136
  end
  object ItemCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 128
    Top = 399
  end
  object ItemDS: TDataSource
    DataSet = ItemCDS
    Left = 182
    Top = 407
  end
  object ItemViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView_Det
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 6
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 59
    Top = 401
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Invoice_Item'
    DataSet = ItemCDS
    DataSets = <
      item
        DataSet = ItemCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inClientId'
        Value = Null
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
    PackSize = 1
    Left = 280
    Top = 407
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Invoice_SetErased'
    DataSet = ItemCDS
    DataSets = <
      item
        DataSet = ItemCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 510
    Top = 412
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Invoice_SetUnErased'
    DataSet = ItemCDS
    DataSets = <
      item
        DataSet = ItemCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 446
    Top = 416
  end
  object spGetReportName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Invoice_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
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
        Value = 'PrintMovement_Sale1_test'
        Component = FormParams
        ComponentItem = 'ReportNameInvoice'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'InvoiceFileName'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 160
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 820
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
  object spInsertUpdateItem: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Invoice'
    DataSet = ItemCDS
    DataSets = <
      item
        DataSet = ItemCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = ItemCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ItemCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice'
        Value = 0.000000000000000000
        Component = ItemCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ItemCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 644
    Top = 425
  end
  object spGetDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_InvoicePdf'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inInvoicePdfId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'InvoicePdfId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 288
  end
  object DocumentInvoice: TDocument
    GetBlobProcedure = spGetDocument
    Left = 496
    Top = 232
  end
  object spInsertDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_InvoicePdf_bySave'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inProductDocumentId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhotoname'
        Value = '789C535018D10000F1E01FE1'
        Component = FormParams
        ComponentItem = 'InvoiceFileName'
        DataType = ftString
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
        Name = 'inInvoicePdfData'
        Value = '789C535018D10000F1E01FE1'
        Component = DocumentInvoice
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 440
    Top = 288
  end
  object spUpdate_FilesNotUploaded: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Invoice_FilesNotUploaded'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsFilesNotUploaded'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isFilesNotUploaded'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsPostedToDropBox'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPostedToDropBox'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 951
    Top = 176
  end
  object spUpdate_PostedToDropBox: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Invoice_PostedToDropBox'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsPostedToDropBox'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPostedToDropBox'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsFilesNotUploaded'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isFilesNotUploaded'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 951
    Top = 240
  end
  object ExportEmailDS: TDataSource
    DataSet = ExportEmailCDS
    Left = 1136
    Top = 129
  end
  object ExportEmailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 1080
    Top = 128
  end
  object spGet_ImportSettings_Email: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Invoice_Email'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = 'zc_Enum_EmailKind_Mail_InvoiceKredit()'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1144
    Top = 176
  end
  object GuidesLanguage: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLanguage
    Key = '179'
    TextValue = #1040#1085#1075#1083#1080#1081#1089#1082#1080#1081
    FormNameParam.Value = 'TLanguageForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLanguageForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = FormParams
        ComponentItem = 'LanguageCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 840
  end
end
