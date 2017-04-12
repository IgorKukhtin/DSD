inherited Report_CheckSPForm: TReport_CheckSPForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
  ClientHeight = 480
  ClientWidth = 1077
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1093
  ExplicitHeight = 518
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 58
    Width = 1077
    Height = 422
    TabOrder = 3
    ExplicitTop = 58
    ExplicitWidth = 1077
    ExplicitHeight = 422
    ClientRectBottom = 422
    ClientRectRight = 1077
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1077
      ExplicitHeight = 422
      inherited cxGrid: TcxGrid
        Width = 1077
        Height = 422
        ExplicitWidth = 1077
        ExplicitHeight = 422
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
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
              Column = colIntenalSPName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
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
              Column = colSummaSP
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clNumLine: TcxGridDBColumn
            Caption = #8470' '#1079'.'#1087'.'
            DataBinding.FieldName = 'NumLine'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object clUnitName: TcxGridDBColumn
            Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object clHospitalName: TcxGridDBColumn
            Caption = #1047#1072#1082#1083#1072#1076' '#1086#1093#1086#1088#1086#1085#1080' '#1079#1076#1086#1088#1086#1074'`'#1103
            DataBinding.FieldName = 'HospitalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object clGoodsName: TcxGridDBColumn
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
            Width = 56
          end
          object colIntenalSPName: TcxGridDBColumn
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' (2)'
            DataBinding.FieldName = 'IntenalSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 217
          end
          object clBrandSPName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' (3)'
            DataBinding.FieldName = 'BrandSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object clKindOutSPName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' (4)'
            DataBinding.FieldName = 'KindOutSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object clPack: TcxGridDBColumn
            Caption = #1057#1080#1083#1072' '#1076#1110#1111' ('#1076#1086#1079#1091#1074#1072#1085#1085#1103') (5)'
            DataBinding.FieldName = 'Pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clCountSP: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1086#1076#1080#1085#1080#1094#1100' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1091' '#1089#1087#1086#1078#1080#1074#1095#1110#1081' '#1091#1087#1072#1082#1086#1074#1094#1110' (6)'
            DataBinding.FieldName = 'CountSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object CodeATX: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1040#1058#1061' (7)'
            DataBinding.FieldName = 'CodeATX'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 56
          end
          object MakerSP: TcxGridDBColumn
            Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072', '#1082#1088#1072#1111#1085#1072' (8)'
            DataBinding.FieldName = 'MakerSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object ReestrSP: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1080#1081' '#1079#1072#1089#1110#1073' (9)'
            DataBinding.FieldName = 'ReestrSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 116
          end
          object DateReestrSP: TcxGridDBColumn
            Caption = 
              #1044#1072#1090#1072' '#1079#1072#1082#1110#1085#1095#1077#1085#1085#1103' '#1089#1090#1088#1086#1082#1091' '#1076#1110#1111' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100 +
              #1082#1080#1081' '#1079#1072#1089#1110#1073' (10)'
            DataBinding.FieldName = 'DateReestrSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 121
          end
          object PriceOptSP: TcxGridDBColumn
            Caption = #1054#1087#1090#1086#1074#1086'- '#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (11)'
            DataBinding.FieldName = 'PriceOptSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 91
          end
          object PriceRetSP: TcxGridDBColumn
            Caption = #1056#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (12)'
            DataBinding.FieldName = 'PriceRetSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object DailyNormSP: TcxGridDBColumn
            Caption = #1044#1086#1073#1086#1074#1072' '#1076#1086#1079#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1072' '#1042#1054#1054#1047' (13)'
            DataBinding.FieldName = 'DailyNormSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Width = 111
          end
          object clPriceSP: TcxGridDBColumn
            Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (15)'
            DataBinding.FieldName = 'PriceSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
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
            Width = 65
          end
          object clGroupSP: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1072' '#1074#1110#1076#1096#1082#1086#1076#1091'-'#1074#1072#1085#1085#1103' '#8211' '#1030' '#1072#1073#1086' '#1030#1030
            DataBinding.FieldName = 'GroupSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1074#1110#1076#1087#1091#1097#1077#1085#1085#1080#1093' '#1091#1087#1072#1082#1086#1074#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object colSummaSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1072' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object JuridicalFullName: TcxGridDBColumn
            Caption = #1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103' ('#1087#1086#1074#1085#1072' '#1085#1072#1079#1074#1072')'
            DataBinding.FieldName = 'JuridicalFullName'
            Visible = False
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
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1077
    Height = 32
    ExplicitWidth = 1077
    ExplicitHeight = 32
    inherited deStart: TcxDateEdit
      Left = 26
      ExplicitLeft = 26
    end
    inherited deEnd: TcxDateEdit
      Left = 138
      ExplicitLeft = 138
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 117
      Caption = #1087#1086':'
      ExplicitLeft = 117
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 470
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 562
      Top = 5
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
      Left = 230
      Top = 6
      Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
    end
    object edJuridical: TcxButtonEdit
      Left = 322
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 143
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 798
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088'-'#1090#1080#1077' '#1054#1047':'
  end
  object ceHospital: TcxButtonEdit [3]
    Left = 888
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 186
  end
  inherited ActionList: TActionList
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
          Component = JuridicalGuide
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = JuridicalGuide
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'HospitalId'
          Value = Null
          Component = HospitalGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'HospitalName'
          Value = Null
          Component = HospitalGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'UnitName;IntenalSPName'
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
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
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
        Component = JuridicalGuide
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHospitalId'
        Value = Null
        Component = HospitalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 160
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
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 112
    Top = 56
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UnitGuides
      end
      item
        Component = HospitalGuides
      end
      item
        Component = JuridicalGuide
      end>
    Left = 304
    Top = 168
  end
  object UnitGuides: TdsdGuides
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
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
    Top = 16
  end
  object JuridicalGuide: TdsdGuides
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
        Component = JuridicalGuide
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuide
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 8
  end
  object HospitalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceHospital
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = HospitalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = HospitalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 920
    Top = 8
  end
end
