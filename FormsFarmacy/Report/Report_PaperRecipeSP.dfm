object Report_PaperRecipeSPForm: TReport_PaperRecipeSPForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1057#1055' '#1073#1091#1084#1072#1078#1085#1099#1077' '#1088#1077#1094#1077#1087#1090#1099
  ClientHeight = 447
  ClientWidth = 1086
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
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1086
    Height = 55
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 4
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object edDateInvoice: TcxDateEdit
      Left = 654
      Top = 29
      EditValue = 42736d
      Properties.ShowTime = False
      TabOrder = 4
      Width = 79
    end
    object edInvoice: TcxTextEdit
      Left = 550
      Top = 29
      TabOrder = 5
      Text = '0'
      Width = 79
    end
    object cxLabel8: TcxLabel
      Left = 496
      Top = 30
      Caption = #1057#1095#1077#1090' '#8470
    end
    object edJuridical: TcxButtonEdit
      Left = 101
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 230
    end
    object cxLabel4: TcxLabel
      Left = 4
      Top = 30
      Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
    end
    object edJuridicalMedic: TcxButtonEdit
      Left = 550
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 183
    end
    object cxLabel6: TcxLabel
      Left = 410
      Top = 6
      Caption = #1070#1088'.'#1083#1080#1094#1086' '#1054#1047' ('#1087#1083#1072#1090#1077#1083#1100#1096#1080#1082'):'
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 81
    Width = 1086
    Height = 366
    Align = alClient
    PopupMenu = PopupMenu
    TabOrder = 2
    ExplicitLeft = 152
    ExplicitTop = 73
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
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
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Position = spFooter
          Column = SummSP
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Column = SummSP
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
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
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = BrandSPName
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Column = SummSP
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Column = SummChangePercent
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Column = TotalSumm_Check
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object NumLine: TcxGridDBColumn
        Caption = #8470' '#1079'.'#1087'.'
        DataBinding.FieldName = 'NumLine'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 41
      end
      object InvNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1063#1077#1082
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 58
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1074#1110#1076#1087#1091#1089#1082#1091' '#1088#1077#1094#1077#1087#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 77
      end
      object InsertName_Check: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.) ('#1095#1077#1082')'
        DataBinding.FieldName = 'InsertName_Check'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 170
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 104
      end
      object InvNumber_Invoice_Full: TcxGridDBColumn
        Caption = #8470' '#1057#1095#1077#1090#1072' ('#1057#1055')'
        DataBinding.FieldName = 'InvNumber_Invoice_Full'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 138
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 52
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072' ('#1085#1072#1096#1072')'
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 157
      end
      object BrandSPName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
        DataBinding.FieldName = 'BrandSPName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 149
      end
      object MakerSP: TcxGridDBColumn
        Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072
        DataBinding.FieldName = 'MakerSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 138
      end
      object KindOutSPName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091
        DataBinding.FieldName = 'KindOutSPName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 79
      end
      object CommentSendName: TcxGridDBColumn
        Caption = #1057#1080#1083#1072' '#1076#1110#1111' ('#1076#1086#1079#1091#1074#1072#1085#1085#1103')'
        DataBinding.FieldName = 'Pack'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 83
      end
      object CountSP: TcxGridDBColumn
        Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1086#1076#1080#1085#1080#1094#1100' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1074' '#1089#1087#1086#1078#1080#1074#1095#1110#1081' '#1091#1087#1072#1082#1086#1074#1094#1110'  '
        DataBinding.FieldName = 'CountSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 97
      end
      object PriceSP: TcxGridDBColumn
        Caption = 
          #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1074#1110#1076#1087#1086#1074#1110#1076#1085#1086' '#1076 +
          #1086' '#1056#1077#1108#1089#1090#1088#1091'  '
        DataBinding.FieldName = 'PriceSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 126
      end
      object PriceSale: TcxGridDBColumn
        Caption = #1060#1072#1082#1090#1080#1095#1085#1072' '#1088#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1088#1077#1072#1083#1110#1079#1072#1094#1110#1111' '#1091#1087#1072#1082#1086#1074#1082#1080
        DataBinding.FieldName = 'PriceSale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 93
      end
      object Amount: TcxGridDBColumn
        Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1074#1110#1076#1087#1091#1097#1077#1085#1080#1093' '#1091#1087#1072#1082#1086#1074#1086#1082', '#1096#1090
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummSP: TcxGridDBColumn
        Caption = #1057#1091#1084#1072' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (15)'
        DataBinding.FieldName = 'SummSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object PaymentSP: TcxGridDBColumn
        Caption = #1057#1091#1084#1072' '#1076#1086#1087#1083#1072#1090#1080' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (16)'
        DataBinding.FieldName = 'PaymentSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object PriceCheckSP: TcxGridDBColumn
        Caption = 
          #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1074#1072#1088#1090#1086#1089#1090#1110' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1095#1077 +
          #1082')'
        DataBinding.FieldName = 'PriceCheckSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 105
      end
      object SummChangePercent: TcxGridDBColumn
        Caption = #1057#1091#1084#1072' '#1091' '#1092#1072#1082#1090'. '#1088#1086#1079#1076#1088#1110#1073'. '#1094#1110#1085#1072#1093' '#1088#1077#1072#1083#1110#1079#1072#1094#1110#1111' '#1074' '#1072#1087#1090#1077#1094#1110', '#1075#1088#1085'.'
        DataBinding.FieldName = 'SummChangePercent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 84
      end
      object TotalSumm_Check: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' ('#1095#1077#1082')'
        DataBinding.FieldName = 'TotalSumm_Check'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object PriceRetSP: TcxGridDBColumn
        Caption = #1056#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (12)'
        DataBinding.FieldName = 'PriceRetSP'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 74
      end
      object HospitalName: TcxGridDBColumn
        DataBinding.FieldName = 'HospitalName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
      end
      object isPrintLast: TcxGridDBColumn
        DataBinding.FieldName = 'isPrintLast'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
      end
      object IntenalSPName: TcxGridDBColumn
        DataBinding.FieldName = 'IntenalSPName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
      end
      object SummaSP: TcxGridDBColumn
        DataBinding.FieldName = 'SummaSP'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
      end
      object JuridicalFullName: TcxGridDBColumn
        DataBinding.FieldName = 'JuridicalFullName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object JuridicalAddress: TcxGridDBColumn
        DataBinding.FieldName = 'JuridicalAddress'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object OKPO: TcxGridDBColumn
        DataBinding.FieldName = 'OKPO'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object MainName: TcxGridDBColumn
        DataBinding.FieldName = 'MainName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object MainName_Cut: TcxGridDBColumn
        DataBinding.FieldName = 'MainName_Cut'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object AccounterName: TcxGridDBColumn
        DataBinding.FieldName = 'AccounterName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object INN: TcxGridDBColumn
        DataBinding.FieldName = 'INN'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object NumberVAT: TcxGridDBColumn
        DataBinding.FieldName = 'NumberVAT'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object BankAccount: TcxGridDBColumn
        DataBinding.FieldName = 'BankAccount'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object Phone: TcxGridDBColumn
        DataBinding.FieldName = 'Phone'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object BankName: TcxGridDBColumn
        DataBinding.FieldName = 'BankName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object MFO: TcxGridDBColumn
        DataBinding.FieldName = 'MFO'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object PartnerMedical_MainName: TcxGridDBColumn
        DataBinding.FieldName = 'PartnerMedical_MainName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
      end
      object PartnerMedical_FullName: TcxGridDBColumn
        DataBinding.FieldName = 'PartnerMedical_FullName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
      end
      object Department_FullName: TcxGridDBColumn
        DataBinding.FieldName = 'Department_FullName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
      end
      object Department_MainName: TcxGridDBColumn
        DataBinding.FieldName = 'Department_MainName'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
      end
      object InvNumberSP: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
        DataBinding.FieldName = 'InvNumberSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object OperDateSP: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
        DataBinding.FieldName = 'OperDateSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 74
      end
      object MedicSPName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
        DataBinding.FieldName = 'MedicSPName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 107
      end
      object PartnerMedicalName: TcxGridDBColumn
        Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077
        DataBinding.FieldName = 'PartnerMedicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object MedicalProgramSPName: TcxGridDBColumn
        Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072' '#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1086#1074
        DataBinding.FieldName = 'MedicalProgramSPName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 128
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cbisInsert: TcxCheckBox
    Left = 200
    Top = 93
    Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1095#1077#1090
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1095#1077#1090
    TabOrder = 6
    Width = 108
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 152
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 208
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 312
    Top = 200
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
    Left = 224
    Top = 208
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
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbUpdate'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
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
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbStaticText: TdxBarButton
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbPrint2: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbcbTotal: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbOpenReport_AccountMotion: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Visible = ivAlways
      ImageIndex = 26
    end
    object bbReport_Account: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbPrint3: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbGroup: TdxBarControlContainerItem
      Caption = 'bbGroup'
      Category = 0
      Hint = 'bbGroup'
      Visible = ivAlways
    end
    object bbUpdate: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbisInsert
    end
    object dxBarButton1: TdxBarButton
      Action = macPrintInvoice
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 32
    Top = 200
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
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
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TSendForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
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
          Value = 43466d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actPrintDepartment: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalFullName;UnitName;NumLine'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43466d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43466d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actSaveMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSavePrintMovement
      StoredProcList = <
        item
          StoredProc = spSavePrintMovement
        end>
      Caption = 'actSPSavePrintState'
    end
    object macPrintInvoice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaveMovement
        end
        item
          Action = actPrintDepartment
        end>
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1089#1095#1077#1090' '#1053#1057#1047#1059
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1089#1095#1077#1090' '#1053#1057#1047#1059
      ImageIndex = 15
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_PaperRecipeSP'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inDateStart'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateFinal'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 296
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 784
    Top = 16
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 400
    Top = 48
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesJuridical
      end>
    Left = 488
    Top = 48
  end
  object spGetBalanceParam: TdsdStoredProc
    StoredProcName = 'gpGetBalanceParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inData'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RootType'
        Value = '0'
        Component = FormParams
        ComponentItem = 'RootType'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupId'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountDirectionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountDirectionName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountId'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccountName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = FormParams
        ComponentItem = 'InfoMoneyId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = FormParams
        ComponentItem = 'InfoMoneyName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDirectionId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDirectionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDestinationId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDestinationId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'JuridicalBasisId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessId'
        Value = Null
        Component = FormParams
        ComponentItem = 'BusinessId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = Null
        Component = FormParams
        ComponentItem = 'BusinessName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 296
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'AccountId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 208
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ActionItemList = <>
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
    PropertiesCellList = <>
    Left = 392
    Top = 304
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 8
  end
  object GuidesJuridicalMedic: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalMedic
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalMedic
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalMedic
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
  end
  object spSavePrintMovement: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Invoice_PaperRecipeSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalMedicId'
        Value = ''
        Component = GuidesJuridicalMedic
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateInvoice'
        Value = 42736d
        Component = edDateInvoice
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvoice'
        Value = '0'
        Component = edInvoice
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInsert'
        Value = False
        Component = cbisInsert
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 216
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 112
    Top = 264
    object N1: TMenuItem
      Action = actRefresh
    end
    object Excel1: TMenuItem
    end
  end
end
