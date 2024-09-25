inherited Report_Sale_BankAccountForm: TReport_Sale_BankAccountForm
  Caption = #1054#1090#1095#1077#1090' <'#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1086#1087#1083#1072#1090'>'
  ClientHeight = 483
  ClientWidth = 1055
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1071
  ExplicitHeight = 522
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 87
    Width = 1055
    Height = 396
    TabOrder = 3
    ExplicitTop = 87
    ExplicitWidth = 1055
    ExplicitHeight = 396
    ClientRectBottom = 396
    ClientRectRight = 1055
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1055
      ExplicitHeight = 396
      inherited cxGrid: TcxGrid
        Width = 1055
        Height = 396
        ExplicitWidth = 1055
        ExplicitHeight = 396
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmount_Pay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Pay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmount_Bank
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmount_SendDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_debt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_debt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_debt_end
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumPay1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumPay2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumReturn_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumReturn_2
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = StatusCode
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmount_Pay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Pay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmount_Bank
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalAmount_SendDebt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_debt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_debt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_debt_end
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumPay1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumPay2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumReturn_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumReturn_2
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object StatusCode: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 107
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 143
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
            Options.Editing = False
            Width = 70
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1075#1086#1074#1086#1088#1072
            Options.Editing = False
            Width = 107
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 195
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object Summ_calc: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1086' '#1085#1072#1082#1083'.'
            DataBinding.FieldName = 'Summ_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' : '#1042#1086#1079#1074#1088#1072#1090#1099'+'#1054#1087#1083#1072#1090#1099
            Width = 80
          end
          object Summ_Pay: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1087#1086' '#1085#1072#1082#1083'.'
            DataBinding.FieldName = 'Summ_Pay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1086#1087#1083#1072#1090' + '#1074#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090
            Options.Editing = False
            Width = 90
          end
          object Summ_debt: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1087#1086' '#1085#1072#1082#1083'.'
            DataBinding.FieldName = 'Summ_debt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1076#1086#1083#1075#1072' '#1085#1072' '#1085#1072#1095#1072#1083#1086
            Width = 80
          end
          object Summ_ReturnIn: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1085#1072#1082#1083'.'
            DataBinding.FieldName = 'Summ_ReturnIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            Width = 80
          end
          object TotalSumm_debt: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1076#1086#1083#1075' '#1085#1072#1095'.'
            DataBinding.FieldName = 'TotalSumm_debt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1092#1072#1082#1090' '#1076#1086#1083#1075' '#1085#1072#1095#1072#1083#1100#1085#1099#1081
            Width = 80
          end
          object TotalSumm_debt_end: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1076#1086#1083#1075' '#1082#1086#1085'.'
            DataBinding.FieldName = 'TotalSumm_debt_end'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1092#1072#1082#1090' '#1076#1086#1083#1075' '#1082#1086#1085#1077#1095#1085#1099#1081
            Width = 80
          end
          object TotalAmount_Pay: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'TotalAmount_Pay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' + '#1074#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object TotalSumm_ReturnIn: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'TotalSumm_ReturnIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1092#1072#1082#1090' '#1089#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            Width = 80
          end
          object TotalAmount_Bank: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1088'.'#1089#1095'.+'#1082#1072#1089#1089#1072
            DataBinding.FieldName = 'TotalAmount_Bank'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 80
          end
          object TotalAmount_SendDebt: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1074#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090
            DataBinding.FieldName = 'TotalAmount_SendDebt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1074#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 85
          end
          object TotalSumm_calc: TcxGridDBColumn
            Caption = '***'#1053#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1086' - '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
            DataBinding.FieldName = 'TotalSumm_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Ord: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object Ord_ReturnIn: TcxGridDBColumn
            Caption = '***'#8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord_ReturnIn'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '***'#8470' '#1087'/'#1087' - '#1086#1090' '#1087#1086#1089#1083#1077#1076#1085#1080#1093' '#1082' '#1087#1077#1088#1074#1099#1084' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
            Options.Editing = False
            Width = 55
          end
          object DatePay_1: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1086#1087#1083#1072#1090#1099'-1'
            DataBinding.FieldName = 'DatePay_1'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MM YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1077#1089#1103#1094' '#1086#1087#1083#1072#1090#1099'-1'
            Options.Editing = False
            Width = 60
          end
          object SumPay1: TcxGridDBColumn
            Caption = '1-'#1072#1103' '#1086#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'SumPay1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099'-1 '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            Options.Editing = False
            Width = 80
          end
          object SumReturn_1: TcxGridDBColumn
            Caption = '1-'#1099#1081' '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'SumReturn_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090'-1 '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            Options.Editing = False
            Width = 80
          end
          object DatePay_2: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1086#1087#1083#1072#1090#1099'-2'
            DataBinding.FieldName = 'DatePay_2'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MM YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1077#1089#1103#1094' '#1086#1087#1083#1072#1090#1099'-2'
            Options.Editing = False
            Width = 60
          end
          object SumPay2: TcxGridDBColumn
            Caption = '2-'#1072#1103' '#1086#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'SumPay2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099'-2 '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            Options.Editing = False
            Width = 80
          end
          object DateReturn_1: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1074#1086#1079#1074#1088#1072#1090'-1'
            DataBinding.FieldName = 'DateReturn_1'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MM YYYY'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1077#1089#1103#1094' '#1074#1086#1079#1074#1088#1072#1090'-1'
            Options.Editing = False
            Width = 60
          end
          object DateReturn_2: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1074#1086#1079#1074#1088#1072#1090'-2'
            DataBinding.FieldName = 'DateReturn_2'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MM YYYY'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1077#1089#1103#1094' '#1074#1086#1079#1074#1088#1072#1090'-2'
            Options.Editing = False
            Width = 60
          end
          object SumReturn_2: TcxGridDBColumn
            Caption = '2-'#1086#1081' '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'SumReturn_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090'-2 '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1055
    Height = 61
    ExplicitWidth = 1055
    ExplicitHeight = 61
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 44927d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      EditValue = 44927d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 33
      ExplicitLeft = 6
      ExplicitTop = 33
    end
    object edContract: TcxButtonEdit
      Left = 335
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 218
    end
    object cxLabel3: TcxLabel
      Left = 278
      Top = 33
      Caption = #1044#1086#1075#1086#1074#1086#1088':'
    end
    object cxLabel4: TcxLabel
      Left = 572
      Top = 6
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
    end
    object edPaidKind: TcxButtonEdit
      Left = 659
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 102
    end
    object cxLabel5: TcxLabel
      Left = 224
      Top = 6
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
    end
    object edJuridical: TcxButtonEdit
      Left = 335
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 218
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 320
  end
  inherited cxPropertiesStore: TcxPropertiesStore
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
        Component = GuidesContract
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesJuridical
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPaidKind
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 48
  end
  inherited ActionList: TActionList
    Left = 327
    Top = 271
    object actRefreshContract: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1076#1086#1075#1086#1074#1072#1088#1072#1084' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Sale_BankAccountDialogForm'
      FormNameParam.Value = 'TReport_Sale_BankAccountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = ''
          Component = GuidesContract
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = ''
          Component = GuidesContract
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = 'False'
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actisDataAll: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1076#1072#1085#1085#1099#1077
      Hint = #1042#1089#1077' '#1040#1074#1090#1086
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42826d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42826d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1054#1090#1095#1077#1090' '#1074#1085#1077#1096#1085#1080#1077' '#1087#1088#1086#1076#1072#1078#1080
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'PartnerRealName;GoodsPropertyName;OperDate;InvNumber;FromName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42826d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42826d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1074#1085#1077#1096#1085#1080#1077' '#1087#1088#1086#1076#1072#1078#1080
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1074#1085#1077#1096#1085#1080#1077' '#1087#1088#1086#1076#1072#1078#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOpenFormProfitLossService_ContractChild: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1086#1075#1086#1074#1086#1088#1072' ('#1073#1072#1079#1072') '#1076#1083#1103' '#1053#1072#1095#1080#1089#1083#1077#1085#1080#1081' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084'>'
      ImageIndex = 76
      FormName = 'TProfitLossService_ContractChildForm'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 44927d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44927d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Sale_BankAccount'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
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
        Name = 'inPaidKindId'
        Value = '0'
        Component = GuidesPaidKind
        ComponentItem = 'Key'
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
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 408
    Top = 272
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProfitLossService_ContractChild'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrint_byType: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbProfitLossService_ContractChild: TdxBarButton
      Action = actOpenFormProfitLossService_ContractChild
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 648
    Top = 208
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 136
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesContract
      end
      item
        Component = GuidesPaidKind
      end
      item
        Component = GuidesJuridical
      end>
    Left = 560
    Top = 208
  end
  object FormParams: TdsdFormParams
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
        Name = 'inFromId'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromName'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = '0'
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupName'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 186
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 256
    Top = 208
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 32
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 712
    Top = 65535
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 716
    Top = 281
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 724
    Top = 334
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    Key = '0'
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
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
    Left = 488
  end
end
