inherited Report_CheckSPForm: TReport_CheckSPForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
  ClientHeight = 480
  ClientWidth = 1077
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1093
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 86
    Width = 1077
    Height = 394
    TabOrder = 3
    ExplicitTop = 86
    ExplicitWidth = 1077
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 1077
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1077
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 1077
        Height = 394
        ExplicitWidth = 1077
        ExplicitHeight = 394
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSP_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PriceSP
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = CountSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_Check
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = IntenalSPName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSP
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UnitName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSP_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PriceSP
            end
            item
              Format = ',0.####'
              Kind = skAverage
              Column = CountSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_Check
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isPrintLast: TcxGridDBColumn
            Caption = #1055#1077#1095'. '#1085#1072' '#1087#1086#1089#1083'. '#1089#1090#1088'.'
            DataBinding.FieldName = 'isPrintLast'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1095#1072#1090#1072#1090#1100' '#1085#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1089#1090#1088#1072#1085#1080#1094#1077
            Width = 40
          end
          object NumLine: TcxGridDBColumn
            Caption = #8470' '#1079'.'#1087'.'
            DataBinding.FieldName = 'NumLine'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object InvNumber_Full: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1063#1077#1082
            DataBinding.FieldName = 'InvNumber_Full'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object InvNumber_Invoice_Full: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' ('#1057#1055')'
            DataBinding.FieldName = 'InvNumber_Invoice_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InvNumber_Invoice: TcxGridDBColumn
            Caption = #8470' '#1057#1095#1077#1090#1072' ('#1057#1055')'
            DataBinding.FieldName = 'InvNumber_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object OperDate_Invoice: TcxGridDBColumn
            DataBinding.FieldName = 'OperDate_Invoice'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object HospitalName: TcxGridDBColumn
            Caption = #1047#1072#1082#1083#1072#1076' '#1086#1093#1086#1088#1086#1085#1080' '#1079#1076#1086#1088#1086#1074'`'#1103
            DataBinding.FieldName = 'HospitalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object MedicSPName: TcxGridDBColumn
            Caption = #1051#1110#1082#1072#1088', '#1097#1086' '#1074#1080#1087#1080#1089#1072#1074' '#1088#1077#1094#1077#1087#1090
            DataBinding.FieldName = 'MedicSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1074#1110#1076#1087#1091#1089#1082#1091
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM.YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object OperDateSP: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'OperDateSP'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM.YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object InvNumberSP: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'InvNumberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_Check: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1095#1077#1082')'
            DataBinding.FieldName = 'TotalSumm_Check'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object InsertName_Check: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.) ('#1095#1077#1082')'
            DataBinding.FieldName = 'InsertName_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object InsertDate_Check: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.) ('#1095#1077#1082')'
            DataBinding.FieldName = 'InsertDate_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072' ('#1085#1072#1096#1072')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 216
          end
          object ColSP: TcxGridDBColumn
            Caption = #8470' '#1079'/'#1087' (1)'
            DataBinding.FieldName = 'ColSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object IntenalSPName: TcxGridDBColumn
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' (2)'
            DataBinding.FieldName = 'IntenalSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 217
          end
          object BrandSPName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' (3)'
            DataBinding.FieldName = 'BrandSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object KindOutSPName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' (4)'
            DataBinding.FieldName = 'KindOutSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object Pack: TcxGridDBColumn
            Caption = #1057#1080#1083#1072' '#1076#1110#1111' ('#1076#1086#1079#1091#1074#1072#1085#1085#1103') (5)'
            DataBinding.FieldName = 'Pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CountSP: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1086#1076#1080#1085#1080#1094#1100' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1091' '#1089#1087#1086#1078#1080#1074#1095#1110#1081' '#1091#1087#1072#1082#1086#1074#1094#1110' (6)'
            DataBinding.FieldName = 'CountSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object CodeATX: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1040#1058#1061' (7)'
            DataBinding.FieldName = 'CodeATX'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object MakerSP: TcxGridDBColumn
            Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072', '#1082#1088#1072#1111#1085#1072' (8)'
            DataBinding.FieldName = 'MakerSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object ReestrSP: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1080#1081' '#1079#1072#1089#1110#1073' (9)'
            DataBinding.FieldName = 'ReestrSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 116
          end
          object DateReestrSP: TcxGridDBColumn
            Caption = 
              #1044#1072#1090#1072' '#1079#1072#1082#1110#1085#1095#1077#1085#1085#1103' '#1089#1090#1088#1086#1082#1091' '#1076#1110#1111' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100 +
              #1082#1080#1081' '#1079#1072#1089#1110#1073' (10)'
            DataBinding.FieldName = 'DateReestrSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 121
          end
          object PriceOptSP: TcxGridDBColumn
            Caption = #1054#1087#1090#1086#1074#1086'- '#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (11)'
            DataBinding.FieldName = 'PriceOptSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object PriceRetSP: TcxGridDBColumn
            Caption = #1056#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (12)'
            DataBinding.FieldName = 'PriceRetSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object PriceSale: TcxGridDBColumn
            Caption = #1060#1072#1082#1090#1080#1095#1085#1072' '#1088#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1088#1077#1072#1083#1110#1079#1072#1094#1110#1111' '#1091#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'PriceSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object SummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1072' '#1091' '#1092#1072#1082#1090'. '#1088#1086#1079#1076#1088#1110#1073'. '#1094#1110#1085#1072#1093' '#1088#1077#1072#1083#1110#1079#1072#1094#1110#1111' '#1074' '#1072#1087#1090#1077#1094#1110', '#1075#1088#1085'.'
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object DailyNormSP: TcxGridDBColumn
            Caption = #1044#1086#1073#1086#1074#1072' '#1076#1086#1079#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1072' '#1042#1054#1054#1047' (13)'
            DataBinding.FieldName = 'DailyNormSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object DailyCompensationSP: TcxGridDBColumn
            Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1076#1086#1073#1086#1074#1086#1111' '#1076#1086#1079#1080' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (14)'
            DataBinding.FieldName = 'DailyCompensationSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object PriceSP: TcxGridDBColumn
            Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (15)'
            DataBinding.FieldName = 'PriceSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object SummaSP_pack: TcxGridDBColumn
            Caption = #1057#1091#1084#1072' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (15)'
            DataBinding.FieldName = 'SummaSP_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object PaymentSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1072' '#1076#1086#1087#1083#1072#1090#1080' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (16)'
            DataBinding.FieldName = 'PaymentSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object InsertDateSP: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'InsertDateSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object GroupSP: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1072' '#1074#1110#1076#1096#1082#1086#1076#1091'-'#1074#1072#1085#1085#1103' '#8211' '#1030' '#1072#1073#1086' '#1030#1030
            DataBinding.FieldName = 'GroupSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1074#1110#1076#1087#1091#1097#1077#1085#1085#1080#1093' '#1091#1087#1072#1082#1086#1074#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
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
            Width = 102
          end
          object SummaSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1072' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object JuridicalFullName: TcxGridDBColumn
            Caption = #1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103' ('#1087#1086#1074#1085#1072' '#1085#1072#1079#1074#1072')'
            DataBinding.FieldName = 'JuridicalFullName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object JuridicalAddress: TcxGridDBColumn
            Caption = #1070#1088'. '#1072#1076#1088#1077#1089#1072' ('#1057#1043')'
            DataBinding.FieldName = 'JuridicalAddress'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1070#1088'. '#1072#1076#1088#1077#1089#1072' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' ('#1057#1043')'
            DataBinding.FieldName = 'OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1050#1055#1054' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object MainName: TcxGridDBColumn
            Caption = #1044#1080#1088#1077#1082#1090#1086#1088' ('#1057#1043')'
            DataBinding.FieldName = 'MainName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object MainName_Cut: TcxGridDBColumn
            Caption = #1044#1080#1088#1077#1082#1090#1086#1088' ('#1057#1043')'
            DataBinding.FieldName = 'MainName_Cut'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object AccounterName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1043')'
            DataBinding.FieldName = 'AccounterName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object INN: TcxGridDBColumn
            Caption = #1030#1055#1053' ('#1057#1043')'
            DataBinding.FieldName = 'INN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1030#1055#1053' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object NumberVAT: TcxGridDBColumn
            Caption = #8470' '#1089#1074#1110#1076'. ('#1057#1043')'
            DataBinding.FieldName = 'NumberVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1089#1074#1110#1076#1086#1094#1090#1074#1072' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object BankAccount: TcxGridDBColumn
            Caption = #1056'/'#1088' ('#1057#1043')'
            DataBinding.FieldName = 'BankAccount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056'/'#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object Phone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1057#1043')'
            DataBinding.FieldName = 'Phone'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1057#1043')'
            DataBinding.FieldName = 'BankName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object MFO: TcxGridDBColumn
            Caption = #1052#1060#1054' ('#1057#1043')'
            DataBinding.FieldName = 'MFO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_FullName: TcxGridDBColumn
            Caption = #1047#1072#1082#1083#1072#1076' '#1086#1093#1086#1088#1086#1085#1080' '#1079#1076#1086#1088#1086#1074'`'#1103' ('#1087#1086#1074#1085#1072' '#1085#1072#1079#1074#1072')'
            DataBinding.FieldName = 'PartnerMedical_FullName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_JuridicalAddress: TcxGridDBColumn
            Caption = #1070#1088'. '#1072#1076#1088#1077#1089#1072' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_JuridicalAddress'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1070#1088'. '#1072#1076#1088#1077#1089#1072' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_Phone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_Phone'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Contract_SigningDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1076#1087'. '#1076#1086#1075'.'
            DataBinding.FieldName = 'Contract_SigningDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
            Options.Editing = False
            Width = 74
          end
          object Contract_StartDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1075#1086#1074#1086#1088#1091
            DataBinding.FieldName = 'Contract_StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object PartnerMedical_MainName: TcxGridDBColumn
            Caption = #1043#1083'.'#1074#1088#1072#1095' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_MainName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_MainName_Cut: TcxGridDBColumn
            Caption = #1043#1083'.'#1074#1088#1072#1095' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_MainName_Cut'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object PartnerMedical_OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1050#1055#1054' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object PartnerMedical_AccounterName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_AccounterName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object PartnerMedical_INN: TcxGridDBColumn
            Caption = #1030#1055#1053' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_INN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1030#1055#1053' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object PartnerMedical_NumberVAT: TcxGridDBColumn
            Caption = #8470' '#1089#1074#1110#1076'. ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_NumberVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1089#1074#1110#1076'. ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object PartnerMedical_BankAccount: TcxGridDBColumn
            Caption = #1056'/'#1088' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_BankAccount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056'/'#1088' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object PartnerMedical_BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_BankName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object PartnerMedical_MFO: TcxGridDBColumn
            Caption = #1052#1060#1054' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_MFO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object CountInvNumberSP: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1088#1077#1094#1077#1087#1090#1086#1074
            DataBinding.FieldName = 'CountInvNumberSP'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TotalSumm_Invoice: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1087#1086' '#1076#1086#1075'.'
            DataBinding.FieldName = 'TotalSumm_Invoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1087#1086' '#1076#1086#1075#1086#1074#1086#1088#1091' '#1089' '#1085#1072#1095#1072#1083#1072' '#1075#1086#1076#1072
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object JuridicalId: TcxGridDBColumn
            DataBinding.FieldName = 'JuridicalId'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object HospitalId: TcxGridDBColumn
            DataBinding.FieldName = 'HospitalId'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object DepartmentId: TcxGridDBColumn
            DataBinding.FieldName = 'DepartmentId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Department_FullName: TcxGridDBColumn
            Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' '#1086#1093#1086#1088#1086#1085#1080' '#1079#1076#1086#1088#1086#1074'`'#1103' ('#1087#1086#1074#1085#1072' '#1085#1072#1079#1074#1072')'
            DataBinding.FieldName = 'Department_FullName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object Department_JuridicalAddress: TcxGridDBColumn
            Caption = #1070#1088'. '#1072#1076#1088#1077#1089#1072' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Department_JuridicalAddress'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1070#1088'. '#1072#1076#1088#1077#1089#1072' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object Department_Phone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Department_Phone'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object ContractName_Department: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1044#1054#1047')'
            DataBinding.FieldName = 'ContractName_Department'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Contract_SigningDate_Department: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1076#1087'. '#1076#1086#1075'. ('#1044#1054#1047')'
            DataBinding.FieldName = 'Contract_SigningDate_Department'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
            Options.Editing = False
            Width = 74
          end
          object Contract_StartDate_Department: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1075#1086#1074#1086#1088#1091' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Contract_StartDate_Department'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object Department_MainName: TcxGridDBColumn
            Caption = #1043#1083'.'#1074#1088#1072#1095' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Department_MainName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object Department_MainName_Cut: TcxGridDBColumn
            Caption = #1043#1083'.'#1074#1088#1072#1095' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Department_MainName_Cut'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object Department_OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Department_OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1050#1055#1054' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object Department_BankAccount: TcxGridDBColumn
            Caption = #1056'/'#1088' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Department_BankAccount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056'/'#1088' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object Department_BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Department_BankName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
          object Department_MFO: TcxGridDBColumn
            Caption = #1052#1060#1054' ('#1044#1054#1047')'
            DataBinding.FieldName = 'Department_MFO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' ('#1047#1054#1047')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 155
          end
        end
      end
      object cbisInsert: TcxCheckBox
        Left = 112
        Top = 13
        Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1095#1077#1090
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1095#1077#1090
        TabOrder = 1
        Width = 108
      end
    end
  end
  inherited Panel: TPanel
    Width = 1077
    Height = 60
    ExplicitWidth = 1077
    ExplicitHeight = 60
    inherited deStart: TcxDateEdit
      Left = 26
      ExplicitLeft = 26
    end
    inherited deEnd: TcxDateEdit
      Left = 26
      Top = 33
      ExplicitLeft = 26
      ExplicitTop = 33
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 5
      Top = 34
      Caption = #1087#1086':'
      ExplicitLeft = 5
      ExplicitTop = 34
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 124
      Top = 34
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 216
      Top = 33
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 230
    end
    object cxLabel4: TcxLabel
      Left = 124
      Top = 6
      Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
    end
    object edJuridical: TcxButtonEdit
      Left = 216
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 230
    end
    object cxLabel8: TcxLabel
      Left = 897
      Top = 6
      Caption = #1057#1095#1077#1090' '#8470
    end
    object edInvoice: TcxTextEdit
      Left = 942
      Top = 5
      TabOrder = 9
      Text = '0'
      Width = 79
    end
    object cxLabel7: TcxLabel
      Left = 926
      Top = 33
      Caption = #1086#1090
    end
    object edDateInvoice: TcxDateEdit
      Left = 942
      Top = 32
      EditValue = 42736d
      Properties.ShowTime = False
      TabOrder = 11
      Width = 79
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 455
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088'-'#1090#1080#1077' '#1054#1047':'
  end
  object ceHospital: TcxButtonEdit [3]
    Left = 541
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 316
  end
  object cxLabel6: TcxLabel [4]
    Left = 455
    Top = 34
    Caption = #1070#1088'.'#1083#1080#1094#1086' '#1054#1047' ('#1087#1083#1072#1090#1077#1083#1100#1096#1080#1082'):'
  end
  object edJuridicalMedic: TcxButtonEdit [5]
    Left = 595
    Top = 33
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 262
  end
  inherited ActionList: TActionList
    object actGetReportNameSPDepartmen: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameSPDepartment
      StoredProcList = <
        item
          StoredProc = spGetReporNameSPDepartment
        end>
      Caption = 'actGetReportNameSP'
    end
    object mactPrint_PactDepartment: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetReportNameSPDepartmen
        end
        item
          Action = actPrintPactDepartment
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077'  ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077'  ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      ImageIndex = 17
    end
    object actPrintPactDepartment: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
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
      ReportName = 'ReportNameSP'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSP'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
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
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_CheckSPDialogForm'
      FormNameParam.Value = 'TReport_CheckSPDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'HospitalId'
          Value = Null
          Component = GuidesHospital
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'HospitalName'
          Value = Null
          Component = GuidesHospital
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalMedicId'
          Value = Null
          Component = GuidesJuridicalMedic
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalMedicName'
          Value = Null
          Component = GuidesJuridicalMedic
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint_152: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'HospitalName;isPrintLast;NumLine'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'Invoice'
          Value = '0'
          Component = edInvoice
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'HospitalName;UnitName;isPrintLast;IntenalSPName;OperDate'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = False
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
    object actPrintInvoiceDepartment: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;HospitalName;ContractName;'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'Invoice'
          Value = '0'
          Component = edInvoice
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateInvoice'
          Value = 42736d
          Component = edDateInvoice
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1057#1095#1077#1090' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090
      ReportNameParam.Value = #1057#1095#1077#1090' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintInvoice: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;HospitalName;ContractName;'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'Invoice'
          Value = ''
          Component = edInvoice
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateInvoice'
          Value = 42736d
          Component = edDateInvoice
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1057#1095#1077#1090' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090
      ReportNameParam.Value = #1057#1095#1077#1090' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090
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
          Action = actPrintInvoice
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 15
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
          IndexFieldNames = 'HospitalName;UnitName;isPrintLast;IntenalSPName;OperDate'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
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
    object actPrintDepartment_152: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090' ('#1087#1086#1089#1090'.152)'
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090' ('#1087#1086#1089#1090'.152)'
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'HospitalName;isPrintLast;NumLine'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'Invoice'
          Value = '0'
          Component = edInvoice
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDepartment'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintInvoiceDepartment: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaveMovement
        end
        item
          Action = actPrintInvoiceDepartment
        end>
      Caption = #1055#1077#1095#1072#1090#1100' C'#1095#1077#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' C'#1095#1077#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      ImageIndex = 15
    end
    object actGetReportNameSP: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameSP
      StoredProcList = <
        item
          StoredProc = spGetReporNameSP
        end>
      Caption = 'actGetReportNameSP'
    end
    object mactPrint_Pact: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetReportNameSP
        end
        item
          Action = actPrintPact
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      ImageIndex = 17
    end
    object actPrintPact: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
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
        end
        item
          Name = 'isDepartment'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'ReportNameSP'
      ReportNameParam.Value = 'ReportNameSP'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSP'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 216
  end
  inherited MasterCDS: TClientDataSet
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_SP'
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
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHospitalId'
        Value = Null
        Component = GuidesHospital
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalMedicId'
        Value = Null
        Component = GuidesJuridicalMedic
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 224
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 216
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
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintInvoice'
        end
        item
          Visible = True
          ItemName = 'bbPrint1'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Pact'
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
          ItemName = 'bbPrintInvoiceDepartment'
        end
        item
          Visible = True
          ItemName = 'bbPrintDepartment_152'
        end
        item
          Visible = True
          ItemName = 'bbPrint_PactDepartment'
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
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint1: TdxBarButton
      Action = actPrint_152
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086#1089#1090'.152'
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbisInsert
    end
    object bbPrintInvoice: TdxBarButton
      Action = macPrintInvoice
      Category = 0
    end
    object bbPrint_Pact: TdxBarButton
      Action = mactPrint_Pact
      Category = 0
    end
    object bbPrintDepartment: TdxBarButton
      Action = actPrintDepartment
      Category = 0
    end
    object bbPrintDepartment_152: TdxBarButton
      Action = actPrintDepartment_152
      Category = 0
    end
    object bbPrintInvoiceDepartment: TdxBarButton
      Action = macPrintInvoiceDepartment
      Category = 0
    end
    object bbPrint_PactDepartment: TdxBarButton
      Action = mactPrint_PactDepartment
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 488
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 40
    Top = 64
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesHospital
      end
      item
        Component = GuidesJuridical
      end>
    Left = 272
    Top = 232
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 24
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
    Left = 312
  end
  object GuidesHospital: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceHospital
    FormNameParam.Value = 'TPartnerMedicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerMedicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesHospital
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesHospital
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 808
  end
  object spSavePrintMovement: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Invoice_Check'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 42736d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42736d
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
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = ''
        Component = GuidesHospital
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalMedicId'
        Value = Null
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
        Value = ''
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
    Left = 592
    Top = 216
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ReportNameSP'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 216
  end
  object spGetReporNameSP: TdsdStoredProc
    StoredProcName = 'gpGet_ReportNameSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = Null
        Component = GuidesHospital
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_ReportNameSP'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSP'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 296
  end
  object spGetReporNameSPDepartment: TdsdStoredProc
    StoredProcName = 'gpGet_ReportNameSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'DepartmentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_ReportNameSP'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSP'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 272
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
    Left = 720
    Top = 32
  end
end
