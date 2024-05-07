﻿object ProductForm: TProductForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1051#1086#1076#1082#1072' - '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088'>'
  ClientHeight = 435
  ClientWidth = 1188
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ChoiceAction = actChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMaster: TPanel
    Left = 0
    Top = 26
    Width = 1188
    Height = 199
    Align = alClient
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 0
    object cxGrid: TcxGrid
      Left = 0
      Top = 50
      Width = 1188
      Height = 149
      Align = alClient
      PopupMenu = PopupMenu
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSource
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = Hours
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ1
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ2
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ1_orig
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ2_orig
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = OperPrice_load
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = BasisPrice_load
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TransportSumm_load
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ_orig
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ_transport
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = BasisWVAT_summ_transport
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummTax
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount_total
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ_calc
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount1
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount2
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount3
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_Invoice
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_BankAccount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_Debt
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TransportSumm
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = Name
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Hours
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ1
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ2
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ1_orig
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ2_orig
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = OperPrice_load
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = BasisPrice_load
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TransportSumm_load
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ_orig
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ_transport
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = BasisWVAT_summ_transport
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummTax
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount_total
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Basis_summ_calc
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount1
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount2
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = SummDiscount3
          end
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = ClientName
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_Invoice
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_BankAccount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_Debt
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TransportSumm
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object isSale: TcxGridDBColumn
          Caption = #1055#1088#1086#1076#1072#1085#1072' ('#1076#1072'/'#1085#1077#1090')'
          DataBinding.FieldName = 'isSale'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1088#1086#1076#1072#1085#1072' ('#1076#1072'/'#1085#1077#1090')'
          Width = 72
        end
        object isBasicConf: TcxGridDBColumn
          Caption = 'Basic Yes/no'
          DataBinding.FieldName = 'isBasicConf'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1082#1083#1102#1095#1080#1090#1100' '#1073#1072#1079#1086#1074#1091#1102' '#1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1102' '#1052#1086#1076#1077#1083#1080' Yes/no'
          Options.Editing = False
          Width = 55
        end
        object NPP_OrderClient: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087' '#1060#1072#1082#1090
          DataBinding.FieldName = 'NPP_OrderClient'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1074' '#1086#1095#1077#1088#1077#1076#1080' '#1089#1073#1086#1088#1082#1080' ('#1060#1072#1082#1090')'
          Options.Editing = False
          Width = 55
        end
        object StateText: TcxGridDBColumn
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
          DataBinding.FieldName = 'StateText'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object StatusCode_OrderClient: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
          DataBinding.FieldName = 'StatusCode_OrderClient'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
              ImageIndex = 76
              Value = 1
            end
            item
              Description = #1055#1088#1086#1074#1077#1076#1077#1085
              ImageIndex = 77
              Value = 2
            end
            item
              Description = #1059#1076#1072#1083#1077#1085
              ImageIndex = 52
              Value = 3
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
          Width = 80
        end
        object OperDate_OrderClient: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
          DataBinding.FieldName = 'OperDate_OrderClient'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
          Options.Editing = False
          Width = 70
        end
        object InvNumberFull_OrderClient: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
          DataBinding.FieldName = 'InvNumberFull_OrderClient'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
          Options.Editing = False
          Width = 100
        end
        object InvNumber_OrderClient: TcxGridDBColumn
          Caption = '***'#8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
          DataBinding.FieldName = 'InvNumber_OrderClient'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
          Options.Editing = False
          Width = 100
        end
        object isReserve: TcxGridDBColumn
          Caption = #1056#1077#1079#1077#1088#1074#1072#1094#1080#1103
          DataBinding.FieldName = 'isReserve'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 85
        end
        object DateStart: TcxGridDBColumn
          Caption = #1055#1083#1072#1085' '#1089#1090#1072#1088#1090
          DataBinding.FieldName = 'DateStart'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1083#1072#1085' '#1089#1090#1072#1088#1090' '#1089#1073#1086#1088#1082#1080' '#1083#1086#1076#1082#1080
          Options.Editing = False
          Width = 60
        end
        object DateBegin: TcxGridDBColumn
          Caption = #1055#1083#1072#1085' '#1092#1080#1085#1080#1096
          DataBinding.FieldName = 'DateBegin'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1083#1072#1085' '#1092#1080#1085#1080#1096' '#1089#1073#1086#1088#1082#1080' '#1083#1086#1076#1082#1080
          Options.Editing = False
          Width = 66
        end
        object NPP_2: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087' '#1055#1083#1072#1085
          DataBinding.FieldName = 'NPP_2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1074' '#1086#1095#1077#1088#1077#1076#1080' '#1089#1073#1086#1088#1082#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1055#1083#1072#1085' '#1092#1080#1085#1080#1096
          Options.Editing = False
          Width = 55
        end
        object InvoiceKindName: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
          DataBinding.FieldName = 'InvoiceKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object ReceiptNumber_Invoice: TcxGridDBColumn
          Caption = 'Inv No'
          DataBinding.FieldName = 'ReceiptNumber_Invoice'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
          Options.Editing = False
          Width = 55
        end
        object InvNumberFull_Invoice: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
          DataBinding.FieldName = 'InvNumberFull_Invoice'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
          Options.Editing = False
          Width = 80
        end
        object Amount_Invoice: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083'. '#1087#1086' '#1089#1095#1077#1090#1091
          DataBinding.FieldName = 'Amount_Invoice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1082' '#1086#1087#1083#1072#1090#1077' '#1087#1086' '#1089#1095#1077#1090#1091
          Options.Editing = False
          Width = 100
        end
        object OperDate_BankAccount: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
          DataBinding.FieldName = 'OperDate_BankAccount'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1086#1087#1083#1072#1090#1099
          Options.Editing = False
          Width = 70
        end
        object Amount_BankAccount: TcxGridDBColumn
          Caption = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072
          DataBinding.FieldName = 'Amount_BankAccount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
          Options.Editing = False
          Width = 80
        end
        object Amount_Debt: TcxGridDBColumn
          Caption = #1044#1086#1083#1075' '#1048#1058#1054#1043#1054
          DataBinding.FieldName = 'Amount_Debt'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' '#1084#1080#1085#1091#1089' '#1042#1057#1045' '#1086#1087#1083#1072#1090#1099
          Options.Editing = False
          Width = 80
        end
        object ClientName: TcxGridDBColumn
          Caption = 'Kunden'
          DataBinding.FieldName = 'ClientName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1083#1080#1077#1085#1090
          Options.Editing = False
          Width = 80
        end
        object TaxKind_Value_Client: TcxGridDBColumn
          Caption = '% '#1053#1044#1057
          DataBinding.FieldName = 'TaxKind_Value_Client'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
          Options.Editing = False
          Width = 60
        end
        object TaxKindName_Client: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1053#1044#1057
          DataBinding.FieldName = 'TaxKindName_Client'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object TaxKindName_info_Client: TcxGridDBColumn
          Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1053#1044#1057
          DataBinding.FieldName = 'TaxKindName_info_Client'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 87
        end
        object InfoMoneyName_Client: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
          DataBinding.FieldName = 'InfoMoneyName_Client'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object Code: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076' '#1051#1086#1076#1082#1080
          Options.Editing = False
          Width = 43
        end
        object CIN: TcxGridDBColumn
          Caption = 'CIN Nr.'
          DataBinding.FieldName = 'CIN'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object ModelName: TcxGridDBColumn
          Caption = 'Model'
          DataBinding.FieldName = 'ModelName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object ProdColorName: TcxGridDBColumn
          Caption = '~Farbe'
          DataBinding.FieldName = 'ProdColorName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 'Farbe Boat Structure'
          Options.Editing = False
          Width = 100
        end
        object EngineName: TcxGridDBColumn
          Caption = 'Engine'
          DataBinding.FieldName = 'EngineName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1052#1086#1090#1086#1088
          Options.Editing = False
          Width = 80
        end
        object EngineNum: TcxGridDBColumn
          Caption = 'Engine Nr.'
          DataBinding.FieldName = 'EngineNum'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1077#1088#1080#1081#1085#1099#1081' '#8470' '#1084#1086#1090#1086#1088#1072
          Options.Editing = False
          Width = 55
        end
        object ReceiptProdModelName: TcxGridDBColumn
          Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080
          DataBinding.FieldName = 'ReceiptProdModelName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080
          Options.Editing = False
          Width = 112
        end
        object Name: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'Name'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1051#1086#1076#1082#1080
          Options.Editing = False
          Width = 100
        end
        object BasisPrice_load: TcxGridDBColumn
          Caption = '***Ladenpreis site (Basis)'
          DataBinding.FieldName = 'BasisPrice_load'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 
            #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072 +
            #1081#1090#1072')'
          Options.Editing = False
          Width = 70
        end
        object OperPrice_load: TcxGridDBColumn
          Caption = 'Ladenpreis site'
          DataBinding.FieldName = 'OperPrice_load'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 
            #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1083#1086#1076#1082#1080', '#1048#1058#1054#1043#1054' '#1041#1077#1079' '#1089#1082#1080#1076#1082#1080' Basis+options+transport, '#1073#1077 +
            #1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
          Options.Editing = False
          Width = 70
        end
        object Basis_summ1_orig: TcxGridDBColumn
          Caption = '*Total LP (Basis)'
          DataBinding.FieldName = 'Basis_summ1_orig'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 
            #1048#1058#1054#1043#1054' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1089#1082#1080#1076#1082#1080' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080 +
            ' '#1083#1086#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object Basis_summ2_orig: TcxGridDBColumn
          Caption = '*Total LP (options)'
          DataBinding.FieldName = 'Basis_summ2_orig'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1089#1082#1080#1076#1082#1080' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1086#1087#1094#1080#1081', '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object Basis_summ_orig: TcxGridDBColumn
          Caption = '*Total LP (Basis + Opt)'
          DataBinding.FieldName = 'Basis_summ_orig'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1089#1082#1080#1076#1082#1080' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 80
        end
        object SummDiscount: TcxGridDBColumn
          Caption = '***'#1057#1082#1080#1076#1082#1072' % '#1080#1090#1086#1075#1086
          DataBinding.FieldName = 'SummDiscount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
          Options.Editing = False
          Width = 75
        end
        object SummDiscount1: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089#1082'. (% '#1086#1089#1085'.)'
          DataBinding.FieldName = 'SummDiscount1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1086#1089#1085#1086#1074#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
          Options.Editing = False
          Width = 75
        end
        object SummDiscount2: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089#1082'. (% '#1076#1086#1087'.)'
          DataBinding.FieldName = 'SummDiscount2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1084#1091' % '#1089#1082#1080#1076#1082#1080
          Options.Editing = False
          Width = 75
        end
        object SummDiscount3: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089#1082'. (% '#1086#1087#1094'.)'
          DataBinding.FieldName = 'SummDiscount3'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1086#1087#1094#1080#1081' '#1087#1086' '#1074#1089#1077#1084' % '#1089#1082#1080#1076#1082#1080
          Options.Editing = False
          Width = 75
        end
        object Basis_summ1: TcxGridDBColumn
          Caption = '***Total LP (Basis)'
          DataBinding.FieldName = 'Basis_summ1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 
            #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' % '#1089#1082#1080#1076#1086#1082', '#1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1072#1079#1086#1074#1086#1081' '#1084#1086#1076#1077#1083#1080' '#1083#1086#1076#1082#1080', '#1073#1077#1079' ' +
            #1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object Basis_summ2: TcxGridDBColumn
          Caption = '***Total LP (options)'
          DataBinding.FieldName = 'Basis_summ2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' % '#1089#1082#1080#1076#1086#1082', '#1057#1091#1084#1084#1072' '#1086#1087#1094#1080#1081', '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object Basis_summ: TcxGridDBColumn
          Caption = '***Total LP'
          DataBinding.FieldName = 'Basis_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 
            #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' % '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' ' +
            #1053#1044#1057
          Options.Editing = False
          Width = 80
        end
        object SummTax: TcxGridDBColumn
          Caption = #1057#1082#1080#1076#1082#1072' ('#1074#1074#1086#1076')'
          DataBinding.FieldName = 'SummTax'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 80
        end
        object Basis_summ_calc: TcxGridDBColumn
          Caption = 'C'#1091#1084#1084#1072' '#1087#1086#1089#1083#1077' '#1089#1082#1080#1076#1082#1080' ('#1088#1072#1089#1095'.)'
          DataBinding.FieldName = 'Basis_summ_calc'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = 
            #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044 +
            #1057
          Options.Editing = False
          Width = 100
        end
        object TransportSumm_load: TcxGridDBColumn
          Caption = 'Transport Pre.(site)'
          DataBinding.FieldName = 'TransportSumm_load'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' Transport Preparation, '#1073#1077#1079' '#1053#1044#1057' ('#1076#1072#1085#1085#1099#1077' '#1089#1072#1081#1090#1072')'
          Options.Editing = False
          Width = 70
        end
        object TransportSumm: TcxGridDBColumn
          Caption = 'Transport'
          DataBinding.FieldName = 'TransportSumm'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' Transport, '#1073#1077#1079' '#1053#1044#1057' '
          Options.Editing = False
          Width = 70
        end
        object Basis_summ_transport: TcxGridDBColumn
          Caption = 'Total LP'
          DataBinding.FieldName = 'Basis_summ_transport'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 80
        end
        object BasisWVAT_summ_transport: TcxGridDBColumn
          Caption = 'Total LP + Vat'
          DataBinding.FieldName = 'BasisWVAT_summ_transport'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082' '#1080' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 80
        end
        object SummDiscount_total: TcxGridDBColumn
          Caption = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054
          DataBinding.FieldName = 'SummDiscount_total'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1090#1086#1075#1086#1074#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
          Options.Editing = False
          Width = 80
        end
        object Hours: TcxGridDBColumn
          Caption = #1042#1088#1077#1084#1103' '#1086#1073#1089#1083#1091#1078'., '#1095'.'
          DataBinding.FieldName = 'Hours'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1088#1077#1084#1103' '#1086#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1103', '#1095'.'
          Options.Editing = False
          Width = 84
        end
        object DiscountTax: TcxGridDBColumn
          Caption = '% '#1089#1082#1080#1076#1082#1080
          DataBinding.FieldName = 'DiscountTax'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
          Options.Editing = False
          Width = 84
        end
        object DiscountNextTax: TcxGridDBColumn
          Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087'.)'
          DataBinding.FieldName = 'DiscountNextTax'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
          Options.Editing = False
          Width = 84
        end
        object DateSale: TcxGridDBColumn
          Caption = #1055#1088#1086#1076#1072#1078#1072
          DataBinding.FieldName = 'DateSale'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1072#1090#1072' '#1087#1088#1086#1076#1072#1078#1080
          Options.Editing = False
          Width = 66
        end
        object InsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InsertName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object isErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 78
        end
        object KeyId: TcxGridDBColumn
          DataBinding.FieldName = 'KeyId'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object StateColor: TcxGridDBColumn
          DataBinding.FieldName = 'StateColor'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 70
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 33
      Width = 1188
      Height = 17
      Align = alTop
      Caption = 'Boat'
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 1
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 1188
      Height = 33
      Align = alTop
      TabOrder = 2
      object lbSearchName: TcxLabel
        Left = 5
        Top = 7
        Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079': '
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
      end
      object edSearchInvNumber_OrderClient: TcxTextEdit
        Left = 111
        Top = 6
        TabOrder = 1
        DesignSize = (
          151
          21)
        Width = 151
      end
      object edSearchClientName: TcxTextEdit
        Left = 549
        Top = 6
        TabOrder = 2
        DesignSize = (
          162
          21)
        Width = 162
      end
      object cxLabel1: TcxLabel
        Left = 490
        Top = 7
        Caption = 'Kunden: '
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
      end
      object cxLabel4: TcxLabel
        Left = 278
        Top = 7
        Caption = 'Inv No '#1089#1095#1077#1090':'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
      end
      object edSearchReceiptNumber_Invoice: TcxTextEdit
        Left = 364
        Top = 6
        TabOrder = 5
        DesignSize = (
          120
          21)
        Width = 120
      end
    end
  end
  object PanelChildItems: TPanel
    Left = 0
    Top = 230
    Width = 1188
    Height = 141
    Align = alBottom
    TabOrder = 2
    object cxSplitter_Left: TcxSplitter
      Left = 522
      Top = 1
      Width = 8
      Height = 139
      Control = PanelProdColorItems
    end
    object PanelProdColorItems: TPanel
      Left = 1
      Top = 1
      Width = 521
      Height = 139
      Align = alLeft
      BevelEdges = [beLeft]
      BevelOuter = bvNone
      TabOrder = 0
      object cxGridProdColorItems: TcxGrid
        Left = 0
        Top = 17
        Width = 521
        Height = 122
        Align = alClient
        PopupMenu = PopupMenuColor
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = 'UserSkin'
        object cxGridDBTableViewProdColorItems: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ProdColorItemsDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EKPrice_summ_ch1
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EKPrice_summ_ch1
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ProdColorPatternName_ch1
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.CellAutoHeight = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object isEnabled_ch1: TcxGridDBColumn
            Caption = 'Yes/no'
            DataBinding.FieldName = 'isEnabled'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object NPP_ch1: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'NPP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object Code_ch1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object ProdColorGroupName_ch1: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
            DataBinding.FieldName = 'ProdColorGroupName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormProdColorGroup
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProdColorPatternName_ch1: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ProdColorPatternName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormProdColorPattern
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 150
          end
          object isDiff_ch1: TcxGridDBColumn
            Caption = 'Diff'
            DataBinding.FieldName = 'isDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1041#1072#1079#1086#1074#1086#1081' '#1050#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1080' Yes/no'
            Options.Editing = False
            Width = 50
          end
          object ProdColorName_ch1: TcxGridDBColumn
            Caption = 'Farbe'
            DataBinding.FieldName = 'ProdColorName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object IsProdOptions_ch1: TcxGridDBColumn
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1072#1082' '#1054#1087#1094#1080#1102
            DataBinding.FieldName = 'IsProdOptions'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1072#1082' '#1054#1087#1094#1080#1102
            Options.Editing = False
            Width = 62
          end
          object GoodsGroupNameFull_ch1: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsGroupName_ch1: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 172
          end
          object GoodsCode_ch1: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
            Options.Editing = False
            Width = 55
          end
          object Article_ch1: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormGoods
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName_ch1: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormGoods
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 110
          end
          object MeasureName_ch1: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object EKPrice_ch1: TcxGridDBColumn
            Caption = 'Netto EK'
            DataBinding.FieldName = 'EKPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 50
          end
          object Amount_ch1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1089#1073#1086#1088#1082#1077
            Options.Editing = False
            Width = 55
          end
          object EKPrice_summ_ch1: TcxGridDBColumn
            Caption = 'Total EK'
            DataBinding.FieldName = 'EKPrice_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object Comment_ch1: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 179
          end
          object InsertDate_ch1: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InsertName_ch1: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErased_ch1: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object Color_fon_ch1: TcxGridDBColumn
            DataBinding.FieldName = 'Color_fon'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewProdColorItems
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 521
        Height = 17
        Align = alTop
        Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
        Color = clLime
        ParentBackground = False
        TabOrder = 1
      end
    end
    object PanelProdOptItems: TPanel
      Left = 530
      Top = 1
      Width = 657
      Height = 139
      Align = alClient
      BevelEdges = [beLeft]
      BevelOuter = bvNone
      TabOrder = 1
      object cxGridProdOptItems: TcxGrid
        Left = 0
        Top = 17
        Width = 657
        Height = 122
        Align = alClient
        PopupMenu = PopupMenuOption
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = 'UserSkin'
        object cxGridDBTableViewProdOptItems: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ProdOptItemsDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EKPrice_summ_ch2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Sale_summ_ch2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleWVAT_summ_ch2
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Amount_ch2
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EKPrice_summ_ch2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Sale_summ_ch2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleWVAT_summ_ch2
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Amount_ch2
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ProdOptionsName_ch2
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.CellAutoHeight = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object isEnabled_ch2: TcxGridDBColumn
            Caption = 'Yes/no'
            DataBinding.FieldName = 'isEnabled'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object NPP_ch2: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'NPP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object DiscountTax_ch2: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'DiscountTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object MaterialOptionsName_ch2: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1054#1087#1094#1080#1081
            DataBinding.FieldName = 'MaterialOptionsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormMaterialOptions
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ProdOptPatternName_ch2: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ProdOptPatternName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormProdOptPattern
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 152
          end
          object Code_ch2: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object ProdOptionsName_ch2: TcxGridDBColumn
            Caption = #1054#1087#1094#1080#1103
            DataBinding.FieldName = 'ProdOptionsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormProdOptions_Object
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Color_ProdColor_ch2: TcxGridDBColumn
            Caption = '***'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1074#1077#1090
            Options.Editing = False
            Width = 45
          end
          object ProdColorName_ch2: TcxGridDBColumn
            Caption = 'Farbe'
            DataBinding.FieldName = 'ProdColorName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormProdColor_goods
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Comment_ch2: TcxGridDBColumn
            Caption = '***Material/farbe'
            DataBinding.FieldName = 'Comment'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormProdOptions_сomment
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 110
          end
          object CommentOpt_ch2: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1086#1087#1094#1080#1103')'
            DataBinding.FieldName = 'CommentOpt'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 110
          end
          object GoodsGroupNameFull_ch2: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object Amount_ch2: TcxGridDBColumn
            Caption = 'Amount Opt.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1086#1087#1094#1080#1081
            Width = 54
          end
          object GoodsGroupName_ch2: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 172
          end
          object GoodsCode_ch2: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
            Options.Editing = False
            Width = 55
          end
          object Article_ch2: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormGoods_optitems
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsName_ch2: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormGoods_optitems
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object MeasureName_ch2: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartNumber_ch2: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1087'. '#1086#1073#1086#1088#1091#1076'.'
            DataBinding.FieldName = 'PartNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1075#1086' '#1076#1086#1087'. '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1103
            Width = 80
          end
          object AmountBasis_ch2: TcxGridDBColumn
            Caption = 'Value'
            DataBinding.FieldName = 'AmountBasis'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1089#1073#1086#1088#1082#1080' '#1091#1079#1083#1072
            Options.Editing = False
            Width = 70
          end
          object EKPrice_ch2: TcxGridDBColumn
            Caption = 'Netto EK'
            DataBinding.FieldName = 'EKPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 50
          end
          object EKPrice_summ_ch2: TcxGridDBColumn
            Caption = 'Total EK'
            DataBinding.FieldName = 'EKPrice_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object SalePrice_ch2: TcxGridDBColumn
            Caption = 'Ladenpreis'
            DataBinding.FieldName = 'SalePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089
            Options.Editing = False
            Width = 70
          end
          object SalePriceWVAT_ch2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
            DataBinding.FieldName = 'SalePriceWVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
            Options.Editing = False
            Width = 70
          end
          object Sale_summ_ch2: TcxGridDBColumn
            Caption = 'Total LP'
            DataBinding.FieldName = 'Sale_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object SaleWVAT_summ_ch2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SaleWVAT_summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 80
          end
          object InsertDate_ch2: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InsertName_ch2: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsErased_ch2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object Color_fon_ch2: TcxGridDBColumn
            DataBinding.FieldName = 'Color_fon'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Color_ProdColorValue_Ch2: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ProdColorValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableViewProdOptItems
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 657
        Height = 17
        Align = alTop
        Caption = #1054#1087#1094#1080#1080
        Color = clAqua
        ParentBackground = False
        TabOrder = 1
      end
    end
  end
  object cxSplitter_Bottom: TcxSplitter
    Left = 0
    Top = 225
    Width = 1188
    Height = 5
    AlignSplitter = salBottom
    Control = PanelChildItems
  end
  object Panel_btn: TPanel
    Left = 0
    Top = 371
    Width = 1188
    Height = 64
    Align = alBottom
    TabOrder = 4
    object btnInsert: TcxButton
      Left = 81
      Top = 5
      Width = 90
      Height = 25
      Action = actInsert
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btnUpdate: TcxButton
      Left = 182
      Top = 5
      Width = 90
      Height = 25
      Action = actUpdate
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object btnUpdate2: TcxButton
      Left = 301
      Top = 35
      Width = 180
      Height = 25
      Action = actUpdate2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object btnShowAllOptItems: TcxButton
      Left = 507
      Top = 35
      Width = 174
      Height = 25
      Action = actShowAllOptItems
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object btnUpdate_OrderClient: TcxButton
      Left = 301
      Top = 5
      Width = 180
      Height = 25
      Action = actUpdate_OrderClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object btnFormClose: TcxButton
      Left = 930
      Top = 5
      Width = 130
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object btnChangeNPP: TcxButton
      Left = 81
      Top = 35
      Width = 191
      Height = 25
      Action = macChangeNPP
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object btnSetVisible_ProdColorItems: TcxButton
      Left = 711
      Top = 5
      Width = 174
      Height = 25
      Action = actSetVisible_ProdColorItems
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object btnSetVisible_ProdOptItems: TcxButton
      Left = 507
      Top = 5
      Width = 174
      Height = 25
      Action = actSetVisible_ProdOptItems
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
    end
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 608
    Top = 120
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 560
    Top = 136
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = actSetVisible_ProdColorItems
        Properties.Strings = (
          'Value')
      end
      item
        Component = actSetVisible_ProdOptItems
        Properties.Strings = (
          'Value')
      end
      item
        Component = cxSplitter_Bottom
        Properties.Strings = (
          'Top')
      end
      item
        Component = cxSplitter_Left
        Properties.Strings = (
          'Left')
      end
      item
        Component = PanelChildItems
        Properties.Strings = (
          'Height'
          'Top')
      end
      item
        Component = PanelProdColorItems
        Properties.Strings = (
          'Width')
      end
      item
        Component = Panel_btn
        Properties.Strings = (
          'Top')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 72
    Top = 88
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 40
    Top = 136
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'BarSubItemBoat'
        end
        item
          Visible = True
          ItemName = 'bbShowAllBoatSale'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'BarSubItemColor'
        end
        item
          Visible = True
          ItemName = 'bbShowAllColorItems'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'BarSubItemOption'
        end
        item
          Visible = True
          ItemName = 'bbShowAllOptItems'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMov'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
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
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_OrderClient'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_NPP_Plus'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_NPP_Minus'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChangeNPP'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoice: TdxBarButton
      Action = actChoiceGuides
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAllErased
      Category = 0
    end
    object bbInsertRecordProdColorItems: TdxBarButton
      Action = actInsertRecordProdColorItems
      Category = 0
    end
    object bbInsertRecordProdOptItems: TdxBarButton
      Action = actInsertRecordProdOptItems
      Category = 0
    end
    object bbSetErasedColor: TdxBarButton
      Action = actSetErasedColor
      Category = 0
    end
    object bbSetUnErasedColor: TdxBarButton
      Action = actSetUnErasedColor
      Category = 0
    end
    object bbSetErasedOpt: TdxBarButton
      Action = actSetErasedOpt
      Category = 0
    end
    object bbSetUnErasedOpt: TdxBarButton
      Action = actSetUnErasedOpt
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbShowAllColorItems: TdxBarButton
      Action = actShowAllColorItems
      Category = 0
    end
    object bbShowAllOptItems: TdxBarButton
      Action = actShowAllOptItems
      Category = 0
    end
    object BarSubItemBoat: TdxBarSubItem
      Caption = 'Boat'
      Category = 0
      Visible = ivAlways
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
          ItemName = 'bbUpdate2'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end>
    end
    object BarSubItemColor: TdxBarSubItem
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordProdColorItems'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedColor'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedColor'
        end>
    end
    object BarSubItemOption: TdxBarSubItem
      Caption = #1054#1087#1094#1080#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordProdOptItems'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedOpt'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedOpt'
        end>
    end
    object bbShowAllBoatSale: TdxBarButton
      Action = actShowAllBoatSale
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrintOffer
      Category = 0
    end
    object bbPrintStructure: TdxBarButton
      Action = actPrintStructure
      Category = 0
    end
    object bbPrintTender: TdxBarButton
      Action = actPrintOrderConfirmation
      Category = 0
    end
    object bbUpdate_OrderClient: TdxBarButton
      Action = actUpdate_OrderClient
      Category = 0
    end
    object bbUpdate2: TdxBarButton
      Action = actUpdate2
      Category = 0
    end
    object bbChangeNPP: TdxBarButton
      Action = macChangeNPP
      Category = 0
    end
    object bbUpdate_NPP_Plus: TdxBarButton
      Action = actUpdate_NPP_Plus
      Category = 0
    end
    object bbUpdate_NPP_Minus: TdxBarButton
      Action = actUpdate_NPP_Minus
      Category = 0
    end
    object bbUpdateMov: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdate_Invoice'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_BankAccount'
        end>
    end
    object bbUpdate_Invoice: TdxBarButton
      Action = actUpdate_Invoice
      Category = 0
    end
    object bbUpdate_BankAccount: TdxBarButton
      Action = actUpdate_BankAccount
      Category = 0
    end
    object bbtProtocol2: TdxBarButton
      Action = actProtocol2
      Category = 0
    end
    object bbtProtocol3: TdxBarButton
      Action = actProtocol3
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrintOffer_TD'
        end
        item
          Visible = True
          ItemName = 'bbPrintOrderConfirmation_TD'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrintTender'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintStructure'
        end>
    end
    object bbsProtocol: TdxBarSubItem
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083
      Category = 0
      Visible = ivAlways
      ImageIndex = 34
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbtProtocol2'
        end
        item
          Visible = True
          ItemName = 'bbtProtocol3'
        end>
    end
    object bbPrintOffer_TD: TdxBarButton
      Action = actPrintOffer_TD
      Category = 0
    end
    object bbPrintOrderConfirmation_TD: TdxBarButton
      Action = actPrintOrderConfirmation_TD
      Category = 0
    end
    object bbSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 64
    Top = 120
    object actRefreshMaster: TdsdDataSetRefresh
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
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 90
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      FormName = 'TProductEditForm'
      FormNameParam.Value = 'TProductEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_OrderClient'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate2: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1099' / '#1060#1086#1090#1086
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1099' / '#1060#1086#1090#1086
      ImageIndex = 29
      FormName = 'TProductDocumentPhotoEditForm'
      FormNameParam.Value = 'TProductDocumentPhotoEditForm'
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
          Name = 'inMovementId_OrderClient'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TProductEditForm'
      FormNameParam.Value = 'TProductEditForm'
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
          Name = 'inMovementId_OrderClient'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actSetErasedColor: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedColor
      StoredProcList = <
        item
          StoredProc = spErasedColor
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 49201
      ErasedFieldName = 'isErased'
      DataSource = ProdColorItemsDS
    end
    object actSetErasedOpt: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedOpt
      StoredProcList = <
        item
          StoredProc = spErasedOpt
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 49202
      ErasedFieldName = 'isErased'
      DataSource = ProdOptItemsDS
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErased
      StoredProcList = <
        item
          StoredProc = spErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object actSetUnErasedOpt: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedOpt
      StoredProcList = <
        item
          StoredProc = spUnErasedOpt
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49202
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ProdOptItemsDS
    end
    object actSetUnErasedColor: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedColor
      StoredProcList = <
        item
          StoredProc = spUnErasedColor
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49201
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ProdColorItemsDS
    end
    object actSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErased
      StoredProcList = <
        item
          StoredProc = spUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BrandId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BrandName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CIN'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CIN'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ClientId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ClientName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId_Client'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName_Client'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKind_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TaxKind_Value_Client'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptProdModelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptProdModelName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelName'
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103
      Hint = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1080#1079' '#1089#1087#1080#1089#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actProtocol2: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocol3: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1054#1087#1094#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1054#1087#1094#1080#1080
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptionsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocol: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowAllErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actInsertRecordProdOptItems: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewProdOptItems
      Action = actChoiceFormProdOptions_Object
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object actInsertRecordProdColorItems: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewProdColorItems
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object actChoiceFormProdColorGroup: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColorGroup'
      FormName = 'TProdColorGroupForm'
      FormNameParam.Value = 'TProdColorGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdOptPattern: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdOptPattern'
      FormName = 'TProdOptPatternForm'
      FormNameParam.Value = 'TProdOptPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormMaterialOptions: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdOptions'
      FormName = 'TMaterialOptionsChoiceForm'
      FormNameParam.Value = 'TMaterialOptionsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'MaterialOptionsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'MaterialOptionsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorPatternId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdOptions_Object: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdOptions_Object'
      FormName = 'TProdOptions_ObjectForm'
      FormNameParam.Value = 'TProdOptions_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptionsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdOptionsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId_choice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SalePrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'SalePrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SalePriceWVAT'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'SalePriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaterialOptionsId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'MaterialOptionsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaterialOptionsName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'MaterialOptionsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ModelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelName_full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ModelName_full'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdColorPattern: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColorPattern'
      FormName = 'TProdColorPatternForm'
      FormNameParam.Value = 'TProdColorPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorGroupId'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorGroupName'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdColor_goods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColor_goods'
      FormName = 'TProdColor_goodsForm'
      FormNameParam.Value = 'TProdColor_goodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDataSetProdOptItems: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateProdOptItems
      StoredProcList = <
        item
          StoredProc = spInsertUpdateProdOptItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end
        item
          StoredProc = spSelect_ProdColorItems
        end>
      Caption = 'actUpdateDataSetProdColorItems'
      DataSource = ProdOptItemsDS
    end
    object actUpdateDataSetProdColorItems: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateProdColorItems
      StoredProcList = <
        item
          StoredProc = spInsertUpdateProdColorItems
        end
        item
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = 'actUpdateDataSetProdColorItems'
      DataSource = ProdColorItemsDS
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
    end
    object actShowAllBoatSale: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_ProdColorItems
        end
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1088#1086#1076#1072#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1088#1086#1076#1072#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actShowAllColorItems: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_ProdColorItems
      StoredProcList = <
        item
          StoredProc = spSelect_ProdColorItems
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actChoiceFormGoods_optitems: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'SalePrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPriceWVAT'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'SalePriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintOrderConfirmation_TD: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintOrderConfirmation
      StoredProcList = <
        item
          StoredProc = spSelectPrintOrderConfirmation
        end>
      Caption = 'Confirmation'
      ImageIndex = 18
      ShortCut = 16434
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
          DataSet = PrintItemsColorCDS
          UserName = 'frxDBDChild'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_OrderConfirmation'
      ReportNameParam.Value = 'PrintProduct_OrderConfirmation'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
    end
    object actPrintStructure: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintStructure
      StoredProcList = <
        item
          StoredProc = spSelectPrintStructure
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NPP;ProdColorGroupName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_Structure'
      ReportNameParam.Value = 'PrintProduct_Structure'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PictureFields.Strings = (
        'photo1')
    end
    object actPrintOrderConfirmation: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintOrderConfirmation
      StoredProcList = <
        item
          StoredProc = spSelectPrintOrderConfirmation
        end>
      Caption = 'Confirmation (Discount)'
      ImageIndex = 18
      ShortCut = 16436
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
          DataSet = PrintItemsColorCDS
          UserName = 'frxDBDChild'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_OrderConfirmation_Discount'
      ReportNameParam.Value = 'PrintProduct_OrderConfirmation_Discount'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintOffer_TD: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintOffer
      StoredProcList = <
        item
          StoredProc = spSelectPrintOffer
        end>
      Caption = 'Offer'
      ImageIndex = 3
      ShortCut = 16433
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
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_Offer'
      ReportNameParam.Value = 'PrintProduct_Offer'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1042#1057#1045#1061' '#1044#1072#1085#1085#1099#1093'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1057#1045' '#1044#1072#1085#1085#1099#1077' '#1051#1086#1076#1082#1072#1084
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1057#1045' '#1044#1072#1085#1085#1099#1077' '#1051#1086#1076#1082#1072#1084
      ImageIndex = 41
    end
    object actShowAllOptItems: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_ProdOptItems
      StoredProcList = <
        item
          StoredProc = spSelect_ProdOptItems
        end>
      Caption = #1056#1077#1078#1080#1084' '#1042#1089#1077' '#1086#1087#1094#1080#1080
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1057#1087#1080#1089#1086#1082' '#1042#1089#1077#1093' '#1086#1087#1094#1080#1081' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1086#1087#1094#1080#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1057#1087#1080#1089#1086#1082' '#1042#1089#1077#1093' '#1086#1087#1094#1080#1081' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072
      CaptionTrue = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1086#1087#1094#1080#1080
      CaptionFalse = #1056#1077#1078#1080#1084' '#1042#1089#1077' '#1086#1087#1094#1080#1080
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actChoiceFormGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'BasisPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPriceWVAT'
          Value = Null
          Component = ProdColorItemsCDS
          ComponentItem = 'BasisPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintOffer: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintOffer
      StoredProcList = <
        item
          StoredProc = spSelectPrintOffer
        end>
      Caption = 'Offer (Discount)'
      Hint = #1055#1077#1095#1072#1090#1100' Offer'
      ImageIndex = 3
      ShortCut = 16435
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
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintProduct_Offer_Discount'
      ReportNameParam.Value = 'PrintProduct_Offer_Discount'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdate_OrderClient: TdsdInsertUpdateAction
      Category = 'Movement'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1047#1072#1082#1072#1079
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079
      ImageIndex = 28
      FormName = 'TOrderClientForm'
      FormNameParam.Value = 'TOrderClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44197d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actChoiceFormProdOptions_сomment: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdOptions_'#1089'omment'
      FormName = 'TProdOptions_CommentForm'
      FormNameParam.Value = 'TProdOptions_CommentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'Comment'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorPatternId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternId'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternName'
          Value = Null
          Component = ProdOptItemsCDS
          ComponentItem = 'ColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateMovement_NPP: TdsdExecStoredProc
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovement_NPP
      StoredProcList = <
        item
          StoredProc = spUpdateMovement_NPP
        end>
      Caption = 'actUpdateMovement_NPP'
    end
    object actChangePercentDialog: TExecuteDialog
      Category = 'NPP'
      MoveParams = <>
      Caption = 'actOrderClientDialog'
      FormName = 'TOrderClientDialogForm'
      FormNameParam.Value = 'TOrderClientDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'NPP'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'NPP_OrderClient'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateBegin'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DateBegin'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macChangeNPP: TMultiAction
      Category = 'NPP'
      MoveParams = <>
      ActionList = <
        item
          Action = actChangePercentDialog
        end
        item
          Action = actUpdateMovement_NPP
        end
        item
          Action = actRefreshMaster
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100
      ImageIndex = 43
    end
    object actUpdate_NPP_Plus: TdsdExecStoredProc
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_NPP_Minus
      StoredProcList = <
        item
          StoredProc = spUpdate_NPP_Minus
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1056#1072#1085#1100#1096#1077
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1056#1072#1085#1100#1096#1077' (-1)'
      ImageIndex = 81
    end
    object actUpdate_NPP_Minus: TdsdExecStoredProc
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_NPP_Plus
      StoredProcList = <
        item
          StoredProc = spUpdate_NPP_Plus
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1055#1086#1079#1078#1077
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1055#1086#1079#1078#1077' (+1)'
      ImageIndex = 82
    end
    object actUpdate_BankAccount: TdsdInsertUpdateAction
      Category = 'Movement'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1087#1083#1072#1090#1091
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1087#1083#1072#1090#1091
      ImageIndex = 1
      FormName = 'TBankAccountMovementForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_BankAccount'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_BankAccount'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44197d
          Component = MasterCDS
          ComponentItem = 'OperDate_BankAccount'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMoneyPlaceId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ClientId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_parent'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate_Invoice: TdsdInsertUpdateAction
      Category = 'Movement'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1057#1095#1077#1090
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 1
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
          Value = 44197d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ClientId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ClientName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_OrderClient'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_OrderClient'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_OrderClient'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ImageIndex = 87
    end
    object actSetVisible_ProdColorItems: TBooleanSetVisibleAction
      MoveParams = <>
      Value = False
      Components = <
        item
          Component = cxSplitter_Left
        end
        item
          Component = PanelProdColorItems
        end>
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      ImageIndexTrue = 25
      ImageIndexFalse = 26
    end
    object actSetVisible_ProdOptItems: TBooleanSetVisibleAction
      MoveParams = <>
      Value = False
      Components = <
        item
          Component = cxSplitter_Bottom
        end
        item
          Component = PanelChildItems
        end>
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1054#1087#1094#1080#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1054#1087#1094#1080#1080
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1054#1087#1094#1080#1080
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1054#1087#1094#1080#1080
      ImageIndexTrue = 31
      ImageIndexFalse = 32
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inProductId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSale'
        Value = Null
        Component = actShowAllBoatSale
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 120
  end
  object spErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Product'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 120
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 352
    Top = 120
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        BackGroundValueColumn = StateColor
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 656
    Top = 128
  end
  object spUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Product'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 128
  end
  object ProdOptItemsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'KeyId'
    MasterFields = 'KeyId'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 616
    Top = 336
  end
  object ProdOptItemsDS: TDataSource
    DataSet = ProdOptItemsCDS
    Left = 672
    Top = 336
  end
  object dsdDBViewAddOnProdOptItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewProdOptItems
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = Color_ProdColor_ch2
        BackGroundValueColumn = Color_ProdColorValue_Ch2
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 728
    Top = 296
  end
  object ProdColorItemsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'KeyId'
    MasterFields = 'KeyId'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 184
    Top = 304
  end
  object ProdColorItemsDS: TDataSource
    DataSet = ProdColorItemsCDS
    Left = 248
    Top = 336
  end
  object dsdDBViewAddOnProdColorItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewProdColorItems
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 368
    Top = 296
  end
  object spSelect_ProdColorItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProdColorItems'
    DataSet = ProdColorItemsCDS
    DataSets = <
      item
        DataSet = ProdColorItemsCDS
      end>
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAllColorItems
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSale'
        Value = Null
        Component = actShowAllBoatSale
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 304
  end
  object spSelect_ProdOptItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProdOptItems'
    DataSet = ProdOptItemsCDS
    DataSets = <
      item
        DataSet = ProdOptItemsCDS
      end>
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = False
        Component = actShowAllOptItems
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSale'
        Value = Null
        Component = actShowAllBoatSale
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 288
  end
  object spInsertUpdateProdColorItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'ProdColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaterialOptionsId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'MaterialOptionsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEnabled'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'isEnabled'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsProdOptions'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'IsProdOptions'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 344
  end
  object spInsertUpdateProdOptItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdOptItems'
    DataSet = ProdOptItemsCDS
    DataSets = <
      item
        DataSet = ProdOptItemsCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioProdOptionsId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdOptionsId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptPatternId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdOptPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'ProdColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaterialOptionsId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'MaterialOptionsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsName'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceIn'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'EKPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOut'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'SalePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'DiscountTax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentOpt'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'CommentOpt'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEnabled'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'isEnabled'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 568
    Top = 336
  end
  object spErasedColor: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 208
  end
  object spUnErasedColor: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 256
  end
  object spErasedOpt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdOptItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 312
  end
  object spUnErasedOpt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdOptItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdOptItemsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 352
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 720
    Top = 16
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
        Value = 'TBoat1Form;zc_Object_ImportSetting_Boat1'
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
    Left = 776
    Top = 128
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 376
    Top = 208
    object N1: TMenuItem
      Action = actRefresh
    end
    object N2: TMenuItem
      Action = actInsert
    end
    object N4: TMenuItem
      Action = actUpdate
    end
    object N3: TMenuItem
      Action = actSetErased
    end
    object N5: TMenuItem
      Action = actSetUnErased
    end
  end
  object PopupMenuColor: TPopupMenu
    Images = dmMain.ImageList
    Left = 440
    Top = 208
    object MenuItem2: TMenuItem
      Action = actInsertRecordProdColorItems
    end
    object MenuItem3: TMenuItem
      Action = actSetErasedColor
    end
    object MenuItem4: TMenuItem
      Action = actSetUnErasedColor
    end
  end
  object PopupMenuOption: TPopupMenu
    Images = dmMain.ImageList
    Left = 496
    Top = 208
    object MenuItem1: TMenuItem
      Action = actInsertRecordProdOptItems
    end
    object MenuItem5: TMenuItem
      Action = actSetErasedOpt
    end
    object MenuItem6: TMenuItem
      Action = actSetUnErasedOpt
    end
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 908
    Top = 105
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 900
    Top = 158
  end
  object spSelectPrintOffer: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_OfferPrint'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1016
    Top = 112
  end
  object spSelectPrintStructure: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_StructurePrint'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1048
    Top = 152
  end
  object PrintItemsColorCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 844
    Top = 142
  end
  object spSelectPrintOrderConfirmation: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_OrderConfirmationPrint'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsColorCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1000
    Top = 208
  end
  object spUpdateMovement_NPP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderClient_NPP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateBegin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DateBegin'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NPP_OrderClient'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 154
    Top = 128
  end
  object spUpdate_NPP_Minus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderClient_NPP_Plus'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioNPP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NPP_OrderClient'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlus'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 250
    Top = 96
  end
  object spUpdate_NPP_Plus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderClient_NPP_Plus'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioNPP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NPP_OrderClient'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlus'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 250
    Top = 152
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchInvNumber_OrderClient
    DataSet = MasterCDS
    Column = InvNumber_OrderClient
    ColumnList = <
      item
        Column = InvNumber_OrderClient
      end
      item
        Column = Comment
      end
      item
        Column = ClientName
        TextEdit = edSearchClientName
      end
      item
        Column = ReceiptNumber_Invoice
        TextEdit = edSearchReceiptNumber_Invoice
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 616
    Top = 24
  end
end
