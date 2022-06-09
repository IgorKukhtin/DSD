inherited Unit_ObjectForm: TUnit_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
  ClientHeight = 614
  ClientWidth = 1442
  PopupMenu = PopupMenu
  ExplicitWidth = 1458
  ExplicitHeight = 653
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1442
    Height = 588
    ExplicitWidth = 1442
    ExplicitHeight = 588
    ClientRectBottom = 588
    ClientRectRight = 1442
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1442
      ExplicitHeight = 588
      inherited cxGrid: TcxGrid
        Width = 1442
        Height = 588
        ExplicitWidth = 1442
        ExplicitHeight = 588
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsSelection.MultiSelect = True
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id: TcxGridDBColumn
            Caption = #1050#1054#1044' '#1089#1074#1103#1079#1080' '#1076#1083#1103' '#1057#1072#1081#1090#1072
            DataBinding.FieldName = 'Id'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object ParentName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'ParentName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object Address: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089
            DataBinding.FieldName = 'Address'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 119
          end
          object Phone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085
            DataBinding.FieldName = 'Phone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object ProvinceCityName: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085
            DataBinding.FieldName = 'ProvinceCityName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenAreaForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object DriverName: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'DriverName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1086#1076#1080#1090#1077#1083#1100' '#1076#1083#1103' '#1088#1072#1079#1074#1086#1079#1082#1080' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 103
          end
          object TaxService: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080
            DataBinding.FieldName = 'TaxService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object TaxServiceNigth: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080' '#1085#1086#1095#1100
            DataBinding.FieldName = 'TaxServiceNigth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object KoeffInSUN: TcxGridDBColumn
            Caption = #1050#1086#1101#1092'. '#1073#1072#1083#1072#1085#1089#1072' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'KoeffInSUN'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1083#1080' >= '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1072', '#1086#1075#1088#1072#1085#1080#1095#1080#1074#1072#1077#1084' '#1087#1088#1080#1093#1086#1076
            Options.Editing = False
            Width = 57
          end
          object KoeffOutSUN: TcxGridDBColumn
            Caption = #1050#1086#1101#1092'. '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'KoeffOutSUN'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1083#1080' >= '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1072', '#1086#1075#1088#1072#1085#1080#1095#1080#1074#1072#1077#1084' '#1088#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 56
          end
          object KoeffInSUN_v3: TcxGridDBColumn
            Caption = #1050#1086#1101#1092'. '#1057#1047#1055
            DataBinding.FieldName = 'KoeffInSUN_v3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' - '#1086#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1088#1080#1093#1086#1076
            Options.Editing = False
            Width = 57
          end
          object KoeffOutSUN_v3: TcxGridDBColumn
            Caption = #1050#1086#1101#1092'. '#1057#1047#1054
            DataBinding.FieldName = 'KoeffOutSUN_v3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' - '#1086#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1088#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 56
          end
          object T1_SUN_v2: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1086#1090#1087#1088'. '#1057#1059#1053'2 (T1)'
            DataBinding.FieldName = 'T1_SUN_v2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1059#1053'-'#1074'2 - '#1087#1088#1086#1076#1072#1078#1080' '#1091' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' '#1074' '#1088#1072#1079#1088#1077#1079#1077' T1'
            Options.Editing = False
            Width = 60
          end
          object T2_SUN_v2: TcxGridDBColumn
            Caption = #1055#1088#1086#1076' '#1087#1086#1083#1091#1095'. '#1057#1059#1053'2 (T2)'
            DataBinding.FieldName = 'T2_SUN_v2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1059#1053'-'#1074'2 - '#1087#1088#1086#1076#1072#1078#1080' '#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1074' '#1088#1072#1079#1088#1077#1079#1077' T2'
            Options.Editing = False
            Width = 60
          end
          object T1_SUN_v4: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1086#1090#1087#1088'. '#1057#1059#1053'2-'#1055#1048' (T1)'
            DataBinding.FieldName = 'T1_SUN_v4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1059#1053'-'#1074'2-'#1055#1048' - '#1087#1088#1086#1076#1072#1078#1080' '#1091' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' '#1074' '#1088#1072#1079#1088#1077#1079#1077' T1'
            Options.Editing = False
            Width = 60
          end
          object isSUN: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V.1)'
            DataBinding.FieldName = 'isSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
            Options.Editing = False
            Width = 70
          end
          object isSUN_v2: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V.2)'
            DataBinding.FieldName = 'isSUN_v2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1074#1077#1088#1089#1080#1103' 2'
            Options.Editing = False
            Width = 70
          end
          object isSUN_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1087#1088#1080#1077#1084') (V.1)'
            DataBinding.FieldName = 'isSUN_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object isSUN_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1086#1090#1087#1088#1072#1074#1082#1072') (V.1)'
            DataBinding.FieldName = 'isSUN_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object isSUN_Supplement_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1087#1088#1080#1077#1084') (V.1)'
            DataBinding.FieldName = 'isSUN_Supplement_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object isSUN_Supplement_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1086#1090#1087#1088#1072#1074#1082#1072') (V.1)'
            DataBinding.FieldName = 'isSUN_Supplement_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object isSUN_Supplement_Priority: TcxGridDBColumn
            Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053' (V.1)'
            DataBinding.FieldName = 'isSUN_Supplement_Priority'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object isOutUKTZED_SUN1: TcxGridDBColumn
            Caption = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053' (V.1)'
            DataBinding.FieldName = 'isOutUKTZED_SUN1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object isSUN_v2_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1087#1088#1080#1077#1084') (V.2)'
            DataBinding.FieldName = 'isSUN_v2_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object isSUN_v2_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1086#1090#1087#1088#1072#1074#1082#1072') (V.2)'
            DataBinding.FieldName = 'isSUN_v2_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object isOnlyTimingSUN: TcxGridDBColumn
            Caption = #1054#1090#1076#1072#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1089#1088#1086#1082#1086#1074#1099#1081' '#1090#1086#1074#1072#1088' '#1087#1086' '#1057#1059#1053' (V.1)'
            DataBinding.FieldName = 'isOnlyTimingSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object isSUN_v3_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' ('#1087#1088#1080#1077#1084')'
            DataBinding.FieldName = 'isSUN_v3_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1069#1082#1089#1087#1088#1077#1089#1089' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object isSUN_v3: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053
            DataBinding.FieldName = 'isSUN_v3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1069#1082#1089#1087#1088#1077#1089#1089
            Options.Editing = False
            Width = 70
          end
          object isSUN_v3_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'  ('#1086#1090#1087#1088#1072#1074#1082#1072')'
            DataBinding.FieldName = 'isSUN_v3_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1069#1082#1089#1087#1088#1077#1089#1089' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object isSUN_v4: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
            DataBinding.FieldName = 'isSUN_v4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'-'#1055#1048
            Options.Editing = False
            Width = 70
          end
          object isSUN_v4_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' ('#1087#1088#1080#1077#1084')'
            DataBinding.FieldName = 'isSUN_v4_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object isSUN_v4_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048'  ('#1086#1090#1087#1088#1072#1074#1082#1072')'
            DataBinding.FieldName = 'isSUN_v4_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object isSUN_v2_LockSale: TcxGridDBColumn
            Caption = #1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053' (V.2)'
            DataBinding.FieldName = 'isSUN_v2_LockSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053' (V.2)'
            Options.Editing = False
            Width = 70
          end
          object isSUN_v2_Supplement_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1087#1088#1080#1077#1084') (V.2)'
            DataBinding.FieldName = 'isSUN_v2_Supplement_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object isSUN_v2_Supplement_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1086#1090#1087#1088#1072#1074#1082#1072') (V.2)'
            DataBinding.FieldName = 'isSUN_v2_Supplement_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object isSUN_NotSold: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' (V.1)'
            DataBinding.FieldName = 'isSUN_NotSold'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053
            Options.Editing = False
            Width = 95
          end
          object isSUA: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1040
            DataBinding.FieldName = 'isSUA'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object ListDaySUN: TcxGridDBColumn
            Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
            DataBinding.FieldName = 'ListDaySUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086' '#1082#1072#1082#1080#1084' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
            Options.Editing = False
            Width = 85
          end
          object ListDaySUN_pi: TcxGridDBColumn
            Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
            DataBinding.FieldName = 'ListDaySUN_pi'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086' '#1082#1072#1082#1080#1084' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1087#1077#1088#1077#1084#1077#1097'.'#1080#1079#1083#1080#1096#1082#1086#1074
            Options.Editing = False
            Width = 85
          end
          object SUN_v1_Lock: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'-1'
            DataBinding.FieldName = 'SUN_v1_Lock'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'-1 '#1076#1083#1103' 1)'#1087#1086#1076#1082#1083#1102#1095#1072#1090#1100' '#1095#1077#1082' "'#1085#1077' '#1076#1083#1103' '#1053#1058#1047'" 2)'#1090#1086#1074#1072#1088#1099' "'#1079#1072#1082#1088#1099 +
              #1090' '#1082#1086#1076'" 3)'#1090#1086#1074#1072#1088#1099' "'#1091#1073#1080#1090' '#1082#1086#1076
            Options.Editing = False
            Width = 85
          end
          object SUN_v2_Lock: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'-2'
            DataBinding.FieldName = 'SUN_v2_Lock'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'-2 '#1076#1083#1103' 1)'#1087#1086#1076#1082#1083#1102#1095#1072#1090#1100' '#1095#1077#1082' "'#1085#1077' '#1076#1083#1103' '#1053#1058#1047'" 2)'#1090#1086#1074#1072#1088#1099' "'#1079#1072#1082#1088#1099 +
              #1090' '#1082#1086#1076'" 3)'#1090#1086#1074#1072#1088#1099' "'#1091#1073#1080#1090' '#1082#1086#1076
            Options.Editing = False
            Width = 85
          end
          object SUN_v4_Lock: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'2-'#1055#1048
            DataBinding.FieldName = 'SUN_v4_Lock'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'-2-'#1055#1048' '#1076#1083#1103' 1)'#1087#1086#1076#1082#1083#1102#1095#1072#1090#1100' '#1095#1077#1082' "'#1085#1077' '#1076#1083#1103' '#1053#1058#1047'" 2)'#1090#1086#1074#1072#1088#1099' "'#1079#1072 +
              #1082#1088#1099#1090' '#1082#1086#1076'" 3)'#1090#1086#1074#1072#1088#1099' "'#1091#1073#1080#1090' '#1082#1086#1076
            Options.Editing = False
            Width = 85
          end
          object SunIncome: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085'. '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082'. '#1057#1059#1053') (V.1)'
            DataBinding.FieldName = 'SunIncome'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053')'
            Options.Editing = False
            Width = 85
          end
          object Sun_v2Income: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085'. '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082'. '#1057#1059#1053') (V.2)'
            DataBinding.FieldName = 'Sun_v2Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' 2)'
            Options.Editing = False
            Width = 85
          end
          object Sun_v4Income: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085'. '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082'. '#1057#1059#1053') (V.2-'#1055#1048')'
            DataBinding.FieldName = 'Sun_v4Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' 2-'#1055#1048')'
            Options.Editing = False
            Width = 85
          end
          object HT_SUN_v1: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085'. '#1076#1083#1103' HT ('#1057#1059#1053') (V.1)'
            DataBinding.FieldName = 'HT_SUN_v1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053'-1)'
            Options.Editing = False
            Width = 85
          end
          object HT_SUN_v2: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085'. '#1076#1083#1103' HT ('#1057#1059#1053' '#1080' '#1057#1059#1040') (V.2)'
            DataBinding.FieldName = 'HT_SUN_v2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053'-2)'
            Options.Editing = False
            Width = 85
          end
          object HT_SUN_v4: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085'. '#1076#1083#1103' HT ('#1057#1059#1053') (V.2-'#1055#1048')'
            DataBinding.FieldName = 'HT_SUN_v4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053'-2-'#1055#1048')'
            Options.Editing = False
            Width = 85
          end
          object HT_SUN_All: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085'. '#1076#1083#1103' HT ('#1057#1059#1053') ('#1087#1086' '#1074#1089#1077#1084')'
            DataBinding.FieldName = 'HT_SUN_All'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1082#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime '#1076#1083#1103' '#1074#1089#1077#1093' '#1057#1059#1053' '#1087#1086' '#1074#1089#1077#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1084
            Options.Editing = False
            Width = 77
          end
          object LimitSUN_N: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053' v1, v2, v2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
            DataBinding.FieldName = 'LimitSUN_N'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
            Options.Editing = False
            Width = 70
          end
          object DeySupplSun1: TcxGridDBColumn
            Caption = #1044#1085#1080' '#1087#1088#1086#1076#1072#1078' '#1074' '#1044#1086#1087#1086#1083#1085'. '#1057#1059#1053'1'
            DataBinding.FieldName = 'DeySupplSun1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object MonthSupplSun1: TcxGridDBColumn
            Caption = ' '#1050#1086#1083'-'#1074#1086' '#1084#1077#1089'. '#1085#1072#1079#1072#1076' '#1074' '#1044#1086#1087#1086#1083#1085'. '#1057#1059#1053'1 '
            DataBinding.FieldName = 'MonthSupplSun1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object isRepriceAuto: TcxGridDBColumn
            Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072
            DataBinding.FieldName = 'isRepriceAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
            Options.Editing = False
            Width = 70
          end
          object isOver: TcxGridDBColumn
            Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
            DataBinding.FieldName = 'isOver'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080
            Options.Editing = False
            Width = 88
          end
          object isGoodsCategory: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099
            DataBinding.FieldName = 'isGoodsCategory'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1086#1081' '#1084#1072#1090#1088#1080#1094#1099
            Options.Editing = False
            Width = 70
          end
          object isTopNo: TcxGridDBColumn
            Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055
            DataBinding.FieldName = 'isTopNo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055' '#1076#1083#1103' '#1072#1087#1090#1077#1082#1080
            Options.Editing = False
            Width = 70
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object isUploadBadm: TcxGridDBColumn
            Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090'. '#1041#1040#1044#1052
            DataBinding.FieldName = 'isUploadBadm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1041#1040#1044#1052
            Options.Editing = False
            Width = 89
          end
          object Num_byReportBadm: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'. ('#1041#1072#1044#1052')'
            DataBinding.FieldName = 'Num_byReportBadm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isMarginCategory: TcxGridDBColumn
            Caption = #1060#1086#1088#1084'. '#1074' '#1087#1088#1086#1089#1084'. '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'isMarginCategory'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 115
          end
          object isReport: TcxGridDBColumn
            Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
            DataBinding.FieldName = 'isReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
            Options.Editing = False
            Width = 72
          end
          object isShareFromPrice: TcxGridDBColumn
            Caption = #1044#1077#1083#1080#1090#1100' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099' '#1086#1090' '#1094#1077#1085#1099
            DataBinding.FieldName = 'isShareFromPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object CreateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'. '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'CreateDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object CloseDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1082#1088'. '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'CloseDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object UserManagerName: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'UserManagerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUserForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'MemberName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUserForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EMail_Member: TcxGridDBColumn
            Caption = 'E-Mail ('#1084#1077#1085#1077#1076#1078#1077#1088')'
            DataBinding.FieldName = 'EMail_Member'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object Phone_Member: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1084#1077#1085#1077#1076#1078#1077#1088')'
            DataBinding.FieldName = 'Phone_Member'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object UserManager2Name: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088' 2'
            DataBinding.FieldName = 'UserManager2Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUser2Form
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object Member2Name: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1052#1077#1085#1077#1076#1078#1077#1088' 2'
            DataBinding.FieldName = 'Member2Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUser2Form
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EMail_Member2: TcxGridDBColumn
            Caption = 'E-Mail ('#1084#1077#1085#1077#1076#1078#1077#1088' 2)'
            DataBinding.FieldName = 'EMail_Member2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object Phone_Member2: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1084#1077#1085#1077#1076#1078#1077#1088' 2)'
            DataBinding.FieldName = 'Phone_Member2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object UserManager3Name: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088' 3'
            DataBinding.FieldName = 'UserManager3Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUser3Form
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object Member3Name: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1052#1077#1085#1077#1076#1078#1077#1088' 3'
            DataBinding.FieldName = 'Member3Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUser3Form
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EMail_Member3: TcxGridDBColumn
            Caption = 'E-Mail ('#1084#1077#1085#1077#1076#1078#1077#1088' 3)'
            DataBinding.FieldName = 'EMail_Member3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object Phone_Member3: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1084#1077#1085#1077#1076#1078#1077#1088' 3)'
            DataBinding.FieldName = 'Phone_Member3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object UnitRePriceName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076'. '#1076#1083#1103' '#1091#1088#1072#1074#1085'. '#1094#1077#1085' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094'.'
            DataBinding.FieldName = 'UnitRePriceName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceUnit
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076'. '#1076#1083#1103' '#1091#1088#1072#1074#1085#1080#1074#1072#1085#1080#1103' '#1094#1077#1085' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
            Width = 95
          end
          object PartnerMedicalName: TcxGridDBColumn
            Caption = #1052#1077#1076'. '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1082#1084#1091' 1303'
            DataBinding.FieldName = 'PartnerMedicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isSP1303: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1077#1090' '#1087#1086' '#1057#1055' 1303'
            DataBinding.FieldName = 'isSP1303'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object EndDateSP1303: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1087#1086' '#1057#1055' 1303'
            DataBinding.FieldName = 'EndDateSP1303'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object isSP: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091
            DataBinding.FieldName = 'isSP'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 89
          end
          object DateSP: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091
            DataBinding.FieldName = 'DateSP'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091
            Options.Editing = False
            Width = 85
          end
          object isNotCashMCS: TcxGridDBColumn
            Caption = #1041#1083#1086#1082'. '#1053#1058#1047' '#1085#1072' '#1082#1072#1089#1089#1072#1093
            DataBinding.FieldName = 'isNotCashMCS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object isNotCashListDiff: TcxGridDBColumn
            Caption = #1041#1083#1086#1082'.  '#1083#1080#1089#1090#1099' '#1086#1090#1082#1072#1079#1086#1074
            DataBinding.FieldName = 'isNotCashListDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object TimeWork: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1088#1072#1073#1086#1090#1099
            DataBinding.FieldName = 'TimeWork'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object isTechnicalRediscount: TcxGridDBColumn
            Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1080' '#1055#1057' '
            DataBinding.FieldName = 'isTechnicalRediscount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object isAlertRecounting: TcxGridDBColumn
            Caption = #1054#1087#1086#1074#1077#1097#1077#1085#1080#1077' '#1087#1077#1088#1077#1076' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1084
            DataBinding.FieldName = 'isAlertRecounting'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object DateCheck: TcxGridDBColumn
            Caption = #1055#1077#1088#1074#1099#1081' '#1095#1077#1082
            DataBinding.FieldName = 'DateCheck'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object LayoutName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1074#1099#1082#1083#1072#1076#1082#1080
            DataBinding.FieldName = 'LayoutName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object TypeSAUA: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1074' '#1057#1040#1059#1040
            DataBinding.FieldName = 'TypeSAUA'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object MasterSAUA: TcxGridDBColumn
            Caption = 'Master '#1074' '#1057#1040#1059#1040
            DataBinding.FieldName = 'MasterSAUA'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUpdate_UnitSAUA
                Default = True
                Kind = bkEllipsis
              end
              item
                Action = actClear_UnitSAUA
                Kind = bkGlyph
              end>
            Properties.Images = dmMain.ImageList
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object PercentSAUA: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090' '#1057#1040#1059#1040
            DataBinding.FieldName = 'PercentSAUA'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = ' '#1055#1088#1086#1094#1077#1085#1090' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1086#1076#1086#1074' '#1074' '#1095#1077#1082#1072#1093' '#1076#1083#1103' '#1057#1040#1059#1040' '
            Options.Editing = False
            Width = 66
          end
          object isCheckUKTZED: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1077#1090' '#1085#1072' '#1087#1077#1095#1072#1090#1100' '#1095#1077#1082#1072' '#1087#1086' '#1059#1050#1058#1042#1069#1044
            DataBinding.FieldName = 'isCheckUKTZED'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1087#1088#1077#1090' '#1085#1072' '#1087#1077#1095#1072#1090#1100' '#1095#1077#1082#1072', '#1077#1089#1083#1080' '#1077#1089#1090#1100' '#1087#1086#1079#1080#1094#1080#1103' '#1087#1086' '#1059#1050#1058#1042#1069#1044' '
            Width = 83
          end
          object isGoodsUKTZEDRRO: TcxGridDBColumn
            Caption = #1059#1050#1058#1042#1069#1044' '#1095#1077#1088#1077#1079' '#1056#1056#1054
            DataBinding.FieldName = 'isGoodsUKTZEDRRO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1095#1072#1090#1100' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1059#1050#1058#1042#1069#1044' '#1095#1077#1088#1077#1079' '#1056#1056#1054
            Options.Editing = False
            Width = 75
          end
          object isMessageByTime: TcxGridDBColumn
            Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084
            DataBinding.FieldName = 'isMessageByTime'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1088#1080' '#1086#1087#1091#1089#1082#1072#1085#1080#1080' '#1077#1089#1083#1080' '#1088#1072#1079#1085#1099#1077' '#1089#1088#1086#1082#1080
            Options.Editing = False
            Width = 82
          end
          object isMessageByTimePD: TcxGridDBColumn
            Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084' '#1087#1086' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
            DataBinding.FieldName = 'isMessageByTimePD'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1088#1080' '#1086#1087#1091#1089#1082#1072#1085#1080#1080' '#1077#1089#1083#1080' '#1088#1072#1079#1085#1099#1077' '#1089#1088#1086#1082#1080' '#1087#1086' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
            Options.Editing = False
            Width = 86
          end
          object isParticipDistribListDiff: TcxGridDBColumn
            Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1088#1072#1089#1087#1088'. '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080' '#1079#1072#1082#1072#1079#1077
            DataBinding.FieldName = 'isParticipDistribListDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1080' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080' '#1079#1072#1082#1072#1079#1077' '#1076#1083#1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            Options.Editing = False
            Width = 80
          end
          object isBlockCommentSendTP: TcxGridDBColumn
            Caption = #1041#1083#1080#1082#1080#1088#1086#1074#1072#1090#1100' '#1082#1086#1084#1077#1085#1090#1099' '#1089' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077#1084' '#1058#1055
            DataBinding.FieldName = 'isBlockCommentSendTP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object PharmacyManager: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1047#1072#1074'. '#1072#1087#1090#1077#1082#1086#1081
            DataBinding.FieldName = 'PharmacyManager'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 99
          end
          object PharmacyManagerPhone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' '#1047#1072#1074'. '#1072#1087#1090#1077#1082#1086#1081
            DataBinding.FieldName = 'PharmacyManagerPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object TelegramId: TcxGridDBColumn
            Caption = 'ID '#1072#1087#1090#1077#1082#1080' '#1074' Telegram'
            DataBinding.FieldName = 'TelegramId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object isErrorRROToVIP: TcxGridDBColumn
            Caption = #1055#1088#1080' '#1086#1096#1080#1073#1082#1077' '#1056#1056#1054' '#1095#1077#1082' '#1074' '#1042#1048#1055
            DataBinding.FieldName = 'isErrorRROToVIP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080' '#1086#1096#1080#1073#1082#1077' '#1056#1056#1054' '#1080' '#1085#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1086#1084' '#1095#1077#1082#1077' '#1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1077#1075#1086' '#1082#1072#1082' '#1042#1048#1055
            Options.Editing = False
            Width = 73
          end
          object isShowMessageSite: TcxGridDBColumn
            AlternateCaption = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1086#1073' '#1086#1073#1088#1072#1073#1086#1090#1082#1077' '#1079#1072#1082#1072#1079#1086#1074' '#1089#1072#1081#1090#1072
            Caption = #1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077' '#1079#1072' 5 '#1084#1080#1085' '#1076#1086' '#1073#1083#1086#1082#1072' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'isShowMessageSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object isSupplementAddCash: TcxGridDBColumn
            Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053' 1 '#1080#1079' '#1082#1072#1089#1089#1099
            DataBinding.FieldName = 'isSupplementAddCash'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object isSupplementAdd30Cash: TcxGridDBColumn
            Caption = 
              #1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1090#1086#1074#1072#1088#1072' '#1089#1086' '#1089#1088#1086#1082#1086#1084' '#1086#1090' 30 '#1076#1085#1077#1081' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053' 1 '#1080#1079' '#1082#1072#1089#1089 +
              #1099
            DataBinding.FieldName = 'isSupplementAdd30Cash'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 114
          end
          object isSUN_NotSoldIn: TcxGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1086#1074#1072#1088' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053'-1'
            DataBinding.FieldName = 'isSUN_NotSoldIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object isExpressVIPConfirm: TcxGridDBColumn
            Caption = #1069#1082#1089#1087#1088#1077#1089#1089' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1042#1048#1055
            DataBinding.FieldName = 'isExpressVIPConfirm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    Left = 79
    object actUpdate_Unit_isSUN_No: TdsdExecStoredProc [0]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_No
        end
        item
          StoredProc = spUpdate_Unit_isSUN_v3_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 50
    end
    object actUpdate_Unit_isSUN_v4_out_yes: TdsdExecStoredProc [1]
      Category = 'isSUN8'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4_out_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4_out_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object actUpdate_Unit_isSUN_v3_yes: TdsdExecStoredProc [2]
      Category = 'isSUN7'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 71
    end
    object actUpdate_Unit_isSUN_v4_out_no: TdsdExecStoredProc [3]
      Category = 'isSUN8'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4_out_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4_out_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object actUpdate_Unit_isSUN_v4_yes: TdsdExecStoredProc [4]
      Category = 'isSUN8'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object actUpdate_Unit_isSUN_v4_no: TdsdExecStoredProc [5]
      Category = 'isSUN8'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object actUpdate_Unit_isSUN_v4_in_no: TdsdExecStoredProc [6]
      Category = 'isSUN8'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4_in_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4_in_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object actUpdate_Unit_isSUN_v3_out_no: TdsdExecStoredProc [7]
      Category = 'isSUN7'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3_out_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3_out_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 71
    end
    object actUpdate_Unit_isSUN_v3_out_yes: TdsdExecStoredProc [8]
      Category = 'isSUN7'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3_out_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3_out_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 71
    end
    object actUpdate_Unit_isSUN_v3_in_no: TdsdExecStoredProc [9]
      Category = 'isSUN7'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3_in_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3_in_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' - '#1053#1077#1090
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' - '#1053#1077#1090
      ImageIndex = 71
    end
    object ExecuteDialog_SUN_Lock: TExecuteDialog [10]
      Category = 'SUN_Lock'
      MoveParams = <>
      Caption = 'actUnit_SUN_LockDialog'
      FormName = 'TUnit_SUN_LockDialogForm'
      FormNameParam.Value = 'TUnit_SUN_LockDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inv1_Lock'
          Value = Null
          Component = FormParams
          ComponentItem = 'inv1_Lock'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inv2_Lock'
          Value = Null
          Component = FormParams
          ComponentItem = 'inv2_Lock'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inv4_Lock'
          Value = Null
          Component = FormParams
          ComponentItem = 'inv4_Lock'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisv1'
          Value = True
          Component = FormParams
          ComponentItem = 'inisv1'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisv2'
          Value = True
          Component = FormParams
          ComponentItem = 'inisv2'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisv4'
          Value = True
          Component = FormParams
          ComponentItem = 'inisv4'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Unit_isSUN_v3_no: TdsdExecStoredProc [11]
      Category = 'isSUN7'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3_no
        end
        item
          StoredProc = spUpdate_Unit_isSUN_No
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 71
    end
    object macUpdate_Unit_isSUN_No_list: TMultiAction [12]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_No
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1053#1077#1090
      ImageIndex = 50
    end
    object actUpdate_Unit_isSUN_Yes: TdsdExecStoredProc [13]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_Yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 50
    end
    object macUpdate_Unit_isSUN_Yes_list: TMultiAction [14]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_Yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1044#1072
      ImageIndex = 50
    end
    object macUpdate_Unit_isSUN_v3_in_yes: TMultiAction [15]
      Category = 'isSUN7'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v3_in_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' - '#1044#1072
      ImageIndex = 71
    end
    object macUpdate_Unit_isSUN_v2_Yes_list: TMultiAction [16]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_Yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V2) - '#1044#1072
      ImageIndex = 47
    end
    object actUpdate_Unit_isSUN_v2_No: TdsdExecStoredProc [17]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2_No
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V2) - '#1053#1077#1090
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V2) - '#1053#1077#1090
      ImageIndex = 47
    end
    object macUpdate_Unit_isSUN_v2_No_list: TMultiAction [18]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_No
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V2) - '#1053#1077#1090
      ImageIndex = 47
    end
    object actUpdate_Unit_isSUN_v2_Yes: TdsdExecStoredProc [19]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2_Yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V2) - '#1044#1072
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V2) - '#1044#1072
      ImageIndex = 47
    end
    object actUpdate_Unit_isSUN_in_yes: TdsdExecStoredProc [20]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_in_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_in_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_Unit_isSUN_in_no: TdsdExecStoredProc [21]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_in_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_in_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_SUN_v2_LockSale_No: TdsdExecStoredProc [22]
      Category = 'SUN_v2_LockSale'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SUN_v2_LockSale_No
      StoredProcList = <
        item
          StoredProc = spUpdate_SUN_v2_LockSale_No
        end>
      Caption = #1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053'-2 - '#1053#1077#1090
      Hint = #1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053'-2 - '#1053#1077#1090
    end
    object macUpdate_Unit_isSUN_out_yes: TMultiAction [23]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_out_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072') -'#1044#1072
      ImageIndex = 49
    end
    object macUpdate_Unit_isSUN_out_no: TMultiAction [24]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_out_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072') - '#1053#1077#1090
      ImageIndex = 49
    end
    object macUpdate_Unit_isSUN_in_yes: TMultiAction [25]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_in_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') - '#1044#1072
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') - '#1044#1072
      ImageIndex = 48
    end
    object macUpdate_Unit_isSUN_in_no: TMultiAction [26]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_in_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') - '#1053#1077#1090
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') - '#1053#1077#1090
      ImageIndex = 48
    end
    object actUpdate_Unit_isSUN_out_yes: TdsdExecStoredProc [27]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_out_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_out_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 49
    end
    object macUpdate_SUN_Lock_list: TMultiAction [28]
      Category = 'SUN_Lock'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_SUN_Lock
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1047#1072#1087#1088#1077#1090#1099' '#1087#1086' '#1057#1059#1053' (V.1, V.2, V.2-'#1055#1048')'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1047#1072#1087#1088#1077#1090#1099' '#1087#1086' '#1057#1059#1053' (V.1, V.2, V.2-'#1055#1048')'
      ImageIndex = 42
    end
    object actUpdate_SUN_Lock: TdsdExecStoredProc [29]
      Category = 'SUN_Lock'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SUN_Lock
      StoredProcList = <
        item
          StoredProc = spUpdate_SUN_Lock
        end>
      Caption = 'actUpdate_SUN_Lock'
    end
    object macUpdate_SUN_Lock: TMultiAction [30]
      Category = 'SUN_Lock'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialog_SUN_Lock
        end
        item
          Action = macUpdate_SUN_Lock_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1047#1072#1087#1088#1077#1090#1099' '#1087#1086' '#1057#1059#1053' (V.1, V.2, V.2-'#1055#1048')'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1047#1072#1087#1088#1077#1090#1099' '#1087#1086' '#1057#1059#1053' (V.1, V.2, V.2-'#1055#1048')'
      ImageIndex = 42
    end
    object ExecuteDialogUnit_HT_SUN: TExecuteDialog [31]
      Category = 'HT_Sun'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053' v1, v2, v2-'#1055#1048')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053' v1, v2, v2-'#1055#1048')'
      ImageIndex = 42
      FormName = 'TUnit_HT_SUN_EditForm'
      FormNameParam.Value = 'TUnit_HT_SUN_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inHT_SUN_v1'
          Value = Null
          Component = FormParams
          ComponentItem = 'inHT_SUN_v1'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inHT_SUN_v2'
          Value = Null
          Component = FormParams
          ComponentItem = 'inHT_SUN_v2'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inHT_SUN_v4'
          Value = Null
          Component = FormParams
          ComponentItem = 'inHT_SUN_v4'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inHT_SUN_All'
          Value = Null
          Component = FormParams
          ComponentItem = 'inHT_SUN_All'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_v1'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_v1'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_v2'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_v2'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_v4'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_v4'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_All'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_All'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_SUN_v2_LockSale_Yes: TdsdExecStoredProc [32]
      Category = 'SUN_v2_LockSale'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SUN_v2_LockSale_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_SUN_v2_LockSale_Yes
        end>
      Caption = #1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053'-2 - '#1044#1072
      Hint = #1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053'-2 - '#1044#1072
    end
    object actUpdate_Unit_isSUN_out_no: TdsdExecStoredProc [33]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_out_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_out_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 49
    end
    object actUpdate_Unit_isSUN_NotSold_no: TdsdExecStoredProc [34]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_NotSold_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_NotSold_no
        end>
      Caption = #1054#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1054#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 68
    end
    object macUpdate_Unit_isSUN_NotSold_no: TMultiAction [35]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_NotSold_no
        end>
      View = cxGridDBTableView
      Caption = #1054#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' - '#1053#1077#1090
      ImageIndex = 68
    end
    object macUpdate_Unit_isSUN_NotSold_yes: TMultiAction [36]
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_NotSold_yes
        end>
      View = cxGridDBTableView
      Caption = #1054#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' - '#1044#1072
      ImageIndex = 68
    end
    object actUpdate_Unit_isSUN_NotSold_yes: TdsdExecStoredProc [37]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_NotSold_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_NotSold_yes
        end>
      Caption = #1054#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1054#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 68
    end
    object actUpdate_Unit_isSUN_v2_in_no: TdsdExecStoredProc [38]
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2_in_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2_in_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 69
    end
    object ExecuteDialogUnit_LimitSun: TExecuteDialog [39]
      Category = 'LimitSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
      ImageIndex = 26
      FormName = 'TUnit_LimitSUN_EditForm'
      FormNameParam.Value = 'TUnit_LimitSUN_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inLimitSun_N'
          Value = 'false'
          Component = FormParams
          ComponentItem = 'inLimitSun_N'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdate_SUN_v2_LockSale_No: TMultiAction [40]
      Category = 'SUN_v2_LockSale'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_SUN_v2_LockSale_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053'-2" - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053'-2" - '#1053#1077#1090
      ImageIndex = 58
    end
    object macUpdateUnit_LimitSUN_list: TMultiAction [41]
      Category = 'LimitSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_LimitSUN
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
      ImageIndex = 43
    end
    object macUpdate_SUN_v2_LockSale_Yes: TMultiAction [42]
      Category = 'SUN_v2_LockSale'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_SUN_v2_LockSale_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053'-2" - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1053#1077' '#1089#1095#1080#1090#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1057#1059#1053'-2" - '#1044#1072
      ImageIndex = 52
    end
    object actUpdate_Unit_LimitSUN: TdsdDataSetRefresh [44]
      Category = 'LimitSUN'
      MoveParams = <>
      StoredProc = spUpdate_Unit_LimitSUN_N
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_LimitSUN_N
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdate_Unit_HT_SUN: TdsdDataSetRefresh [45]
      Category = 'HT_Sun'
      MoveParams = <>
      StoredProc = spUpdate_HT_SUN
      StoredProcList = <
        item
          StoredProc = spUpdate_HT_SUN
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053' v1, v2, v2-'#1055#1048')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053' v1, v2, v2-'#1055#1048')'
      ImageIndex = 42
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateUnit_LimitSUN: TMultiAction [46]
      Category = 'LimitSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUnit_LimitSun
        end
        item
          Action = macUpdateUnit_LimitSUN_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1073#1086#1090#1072#1077#1090' '#1057#1059#1053'-1, '#1057#1059#1053'-2, '#1057#1059#1053'-2-'#1055#1048'  '#1076#1083#1103' '#1058'1)'
      ImageIndex = 43
    end
    object macUpdateUnit_HT_Sun_list: TMultiAction [48]
      Category = 'HT_Sun'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_HT_SUN
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053' v1, v2, v2-'#1055#1048')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053' v1, v2, v2-'#1055#1048')'
      ImageIndex = 42
    end
    object macUpdateUnit_T_SUN_list: TMultiAction [49]
      Category = 'T_SUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_T_SUN
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1057#1059#1053' V2'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1057#1059#1053' V2'
      ImageIndex = 43
    end
    object macUpdateUnit_HT_Sun: TMultiAction [50]
      Category = 'HT_Sun'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUnit_HT_SUN
        end
        item
          Action = macUpdateUnit_HT_Sun_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053' v1, v2, v2-'#1055#1048')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053' v1, v2, v2-'#1055#1048')'
      ImageIndex = 67
    end
    object macUpdate_ListDaySUN_pi: TMultiAction [51]
      Category = 'ListDaySUN'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actEDListDaySUN_pi
      ActionList = <
        item
          Action = actExecUpdate_ListDaySUN_pi
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1040#1087#1090#1077#1082'?'
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
      ImageIndex = 42
    end
    object actExecUpdate_ListDaySUN_pi: TdsdExecStoredProc [52]
      Category = 'ListDaySUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ListDaySUN_pi
      StoredProcList = <
        item
          StoredProc = spUpdate_ListDaySUN_pi
        end>
      Caption = 'actExecUpdate_ListDaySUN'
    end
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'KeyList'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValuelist'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actProtocolOpenForm: TdsdOpenForm
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
    object actUpdateisTopNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isTopNo
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isTopNo
        end>
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055' ('#1044#1072' / '#1053#1077#1090')'
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055' ('#1044#1072' / '#1053#1077#1090')'
      ImageIndex = 78
    end
    object actUpdateisReport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isReport
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isReport
        end>
      Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
      Hint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
      ImageIndex = 38
    end
    object actUpdate_Unit_isSUN_v2_in_yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2_in_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2_in_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 69
    end
    object macUpdate_Unit_isSUN_v2_in_yes: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_in_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' V2) - '#1044#1072
      ImageIndex = 69
    end
    object macUpdate_Unit_isSUN_v2_in_no: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_in_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' V2) - '#1053#1077#1090
      ImageIndex = 69
    end
    object actUpdate_Unit_isSUN_v4_in_yes: TdsdExecStoredProc
      Category = 'isSUN8'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4_in_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4_in_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object macUpdate_Unit_isSUN_v4_no: TMultiAction
      Category = 'isSUN8'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v4_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' -'#1053#1077#1090
      ImageIndex = 73
    end
    object actUpdateisMarginCategory: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isMarginCategory
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isMarginCategory
        end>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
      ImageIndex = 77
    end
    object actUpdateisUploadBadm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isUploadBadm
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isUploadBadm
        end>
      Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1041#1040#1044#1052
      Hint = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1041#1040#1044#1052' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 76
    end
    object actUpdate_Unit_isSUN_v3_in_yes: TdsdExecStoredProc
      Category = 'isSUN7'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3_in_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3_in_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 71
    end
    object actUpdate_Unit_isSUN_v2_out_yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2_out_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2_out_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 70
    end
    object actUpdate_Unit_isSUN_v2_out_no: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2_out_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2_out_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 70
    end
    object actUpdateisOver: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072'/'#1053#1077#1090
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 72
    end
    object actUpdateGoodsCategory_No: TdsdExecStoredProc
      Category = 'GoodsCategory'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GoodsCategory_No
      StoredProcList = <
        item
          StoredProc = spUpdate_GoodsCategory_No
        end>
      Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1053#1077#1090
      Hint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1053#1077#1090
    end
    object actUpdateGoodsCategory_Yes: TdsdExecStoredProc
      Category = 'GoodsCategory'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GoodsCategory_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_GoodsCategory_Yes
        end>
      Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1044#1072
      Hint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1044#1072
    end
    object spUpdateisOverNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver_No
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1053#1077#1090
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1053#1077#1090
    end
    object spUpdateisOverYes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver_Yes
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072
    end
    object actOpenUser2Form: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManager2Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManager2Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Member2Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macUpdateisGoodsCategoryNo: TMultiAction
      Category = 'GoodsCategory'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateGoodsCategory_No
        end>
      View = cxGridDBTableView
      Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1053#1077#1090
      Hint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1053#1077#1090
      ImageIndex = 58
    end
    object macUpdateisGoodsCategoryYes: TMultiAction
      Category = 'GoodsCategory'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateGoodsCategory_Yes
        end>
      View = cxGridDBTableView
      Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1044#1072
      Hint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1044#1072
      ImageIndex = 52
    end
    object ExecuteDialogUnit_T_SUN: TExecuteDialog
      Category = 'T_SUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1057#1059#1053' V2'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1057#1059#1053' V2'
      ImageIndex = 26
      FormName = 'TUnit_T_SUN_EditForm'
      FormNameParam.Value = 'TUnit_T_SUN_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inT1_SUN_v2'
          Value = Null
          Component = FormParams
          ComponentItem = 'inT1_SUN_v2'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inT2_SUN_v2'
          Value = Null
          Component = FormParams
          ComponentItem = 'inT2_SUN_v2'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inT1_SUN_v4'
          Value = Null
          Component = FormParams
          ComponentItem = 'inT1_SUN_v4'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisT1_SUN_v2'
          Value = False
          Component = FormParams
          ComponentItem = 'inisT1_SUN_v2'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisT2_SUN_v2'
          Value = False
          Component = FormParams
          ComponentItem = 'inisT2_SUN_v2'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisT1_SUN_v4'
          Value = False
          Component = FormParams
          ComponentItem = 'inisT1_SUN_v4'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateisOverNo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisOverNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1053#1077#1090
      ImageIndex = 58
    end
    object actUpdate_Unit_T_SUN: TdsdDataSetRefresh
      Category = 'T_SUN'
      MoveParams = <>
      StoredProc = spUpdate_Unit_T_SUN
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_T_SUN
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1057#1059#1053' V2'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1057#1059#1053' V2'
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateUnit_T_SUN: TMultiAction
      Category = 'T_SUN'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUnit_T_SUN
        end
        item
          Action = macUpdateUnit_T_SUN_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1077' '#1057#1059#1053'-'#1074'2 / '#1057#1059#1053'-'#1074'2 -'#1055#1048' '#1074' '#1088#1072#1079#1088#1077#1079#1077' T1/'#1058'2'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1077' '#1057#1059#1053'-'#1074'2 / '#1057#1059#1053'-'#1074'2 -'#1055#1048' '#1074' '#1088#1072#1079#1088#1077#1079#1077' T1/'#1058'2'
      ImageIndex = 43
    end
    object actOpenUser3Form: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManager3Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManager3Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Member3Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macUpdateisOverYes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisOverYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1044#1072
      ImageIndex = 52
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actOpenAreaForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TAreaForm'
      FormName = 'TAreaForm'
      FormNameParam.Value = 'TAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitRePriceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitRePriceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ExecuteDialogKoeffSUNv3: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      ImageIndex = 26
      FormName = 'TUnit_KoeffSUN_EditForm'
      FormNameParam.Value = 'TUnit_KoeffSUN_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inKoeffInSUN'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KoeffInSUN_v3'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeffOutSUN'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KoeffOutSUN_v3'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'FormName'
          Value = #1044#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'KoeffInSUNText'
          Value = #1050#1086#1101#1092'. '#1057#1047#1055
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'KoeffOutSUNText'
          Value = #1050#1086#1101#1092'. '#1057#1047#1054
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actOpenUserForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManagerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManagerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateKoeffSUNv3: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_KoeffSUNv3
      StoredProcList = <
        item
          StoredProc = spUpdate_KoeffSUNv3
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateKoeffSUNv3: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogKoeffSUNv3
        end
        item
          Action = actUpdateKoeffSUNv3
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      ImageIndex = 43
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_Params
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_Params
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object dsdSetUnErased: TdsdUpdateErased
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object ExecuteDialogKoeffSUN: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      ImageIndex = 26
      FormName = 'TUnit_KoeffSUN_EditForm'
      FormNameParam.Value = 'TUnit_KoeffSUN_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inKoeffInSUN'
          Value = 42261d
          Component = MasterCDS
          ComponentItem = 'KoeffInSUN'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeffOutSUN'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'KoeffOutSUN'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'FormName'
          Value = #1044#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'KoeffInSUNText'
          Value = #1050#1086#1101#1092'. '#1073#1072#1083'. '#1087#1088#1080#1093'.'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'KoeffOutSUNText'
          Value = #1050#1086#1101#1092'. '#1073#1072#1083'. '#1088#1072#1089#1093'.'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actEDListDaySUN_pi: TExecuteDialog
      Category = 'ListDaySUN'
      MoveParams = <>
      Caption = 'actEDListDaySUN'
      FormName = 'TListDaySUNDialogForm'
      FormNameParam.Value = 'TListDaySUNDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ListDaySUN'
          Value = ''
          Component = FormParams
          ComponentItem = 'ListDaySUN_pi'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateKoeffSUN: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_KoeffSUN
      StoredProcList = <
        item
          StoredProc = spUpdate_KoeffSUN
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateKoeffSUN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogKoeffSUN
        end
        item
          Action = actUpdateKoeffSUN
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      ImageIndex = 43
    end
    object actUpdate_Unit_TechnicalRediscount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_TechnicalRediscount
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_TechnicalRediscount
        end>
      Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090
      Hint = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090
      ImageIndex = 79
    end
    object actUpdate_ListDaySUN: TMultiAction
      Category = 'ListDaySUN'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actEDListDaySUN
      ActionList = <
        item
          Action = actExecUpdate_ListDaySUN
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
      ImageIndex = 35
    end
    object actExecUpdate_ListDaySUN: TdsdExecStoredProc
      Category = 'ListDaySUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ListDaySUN
      StoredProcList = <
        item
          StoredProc = spUpdate_ListDaySUN
        end>
      Caption = 'actExecUpdate_ListDaySUN'
    end
    object actEDListDaySUN: TExecuteDialog
      Category = 'ListDaySUN'
      MoveParams = <>
      Caption = 'actEDListDaySUN'
      FormName = 'TListDaySUNDialogForm'
      FormNameParam.Value = 'TListDaySUNDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ListDaySUN'
          Value = Null
          Component = FormParams
          ComponentItem = 'ListDaySUN'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Unit_AlertRecounting: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_AlertRecounting
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_AlertRecounting
        end>
      Caption = ' '#1054#1087#1086#1074#1077#1097#1077#1085#1080#1077' '#1087#1077#1088#1077#1076' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1084' '
      Hint = ' '#1054#1087#1086#1074#1077#1097#1077#1085#1080#1077' '#1087#1077#1088#1077#1076' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1084' '
      ImageIndex = 53
    end
    object Action1: TAction
      Caption = 'Action1'
    end
    object ExecuteDialogUnit_SunIncome: TExecuteDialog
      Category = 'SunIncome'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' v1, v' +
        '2, v2-'#1055#1048')'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' v1, v' +
        '2, v2-'#1055#1048')'
      ImageIndex = 26
      FormName = 'TUnit_SunIncome_EditForm'
      FormNameParam.Value = 'TUnit_SunIncome_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inSunIncome'
          Value = Null
          Component = FormParams
          ComponentItem = 'inSunIncome'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inSun_v2Income'
          Value = Null
          Component = FormParams
          ComponentItem = 'inSun_v2Income'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inSun_v4Income'
          Value = Null
          Component = FormParams
          ComponentItem = 'inSun_v4Income'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_v1'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_v1'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_v2'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_v2'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_v4'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_v4'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Unit_SunIncome: TdsdDataSetRefresh
      Category = 'SunIncome'
      MoveParams = <>
      StoredProc = spUpdate_Unit_SunIncome
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_SunIncome
        end>
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' v1, v' +
        '2, v2-'#1055#1048')'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' v1, v' +
        '2, v2-'#1055#1048')'
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateUnit_SunIncome_list: TMultiAction
      Category = 'SunIncome'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_SunIncome
        end>
      View = cxGridDBTableView
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' v1, v' +
        '2, v2-'#1055#1048')'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' v1, v' +
        '2, v2-'#1055#1048')'
      ImageIndex = 43
    end
    object macUpdateUnit_SunIncome: TMultiAction
      Category = 'SunIncome'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUnit_SunIncome
        end
        item
          Action = macUpdateUnit_SunIncome_list
        end
        item
          Action = actRefresh
        end>
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' v1, v' +
        '2, v2-'#1055#1048')'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053' v1, v' +
        '2, v2-'#1055#1048')'
      ImageIndex = 42
    end
    object macUpdate_Unit_isSUN_v2_out_yes: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_out_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' V2) - '#1044#1072
      ImageIndex = 70
    end
    object macUpdate_Unit_isSUN_v2_out_no: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_out_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' V2) - '#1053#1077#1090
      ImageIndex = 70
    end
    object macUpdate_Unit_isSUN_v3_yes: TMultiAction
      Category = 'isSUN7'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v3_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1044#1072
      ImageIndex = 71
    end
    object macUpdate_Unit_isSUN_v3_no: TMultiAction
      Category = 'isSUN7'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v3_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1053#1077#1090
      ImageIndex = 71
    end
    object macUpdate_Unit_isSUN_v3_out_yes: TMultiAction
      Category = 'isSUN7'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v3_out_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' -'#1044#1072
      ImageIndex = 71
    end
    object macUpdate_Unit_isSUN_v3_out_no: TMultiAction
      Category = 'isSUN7'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v3_out_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' - '#1053#1077#1090
      ImageIndex = 71
    end
    object macUpdate_Unit_isSUN_v3_in_no: TMultiAction
      Category = 'isSUN7'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v3_in_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' - '#1053#1077#1090
      ImageIndex = 71
    end
    object macUpdate_Unit_isSUN_v4_yes: TMultiAction
      Category = 'isSUN8'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v4_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1044#1072
      ImageIndex = 73
    end
    object macUpdate_Unit_isSUN_v4_out_yes: TMultiAction
      Category = 'isSUN8'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v4_out_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' -'#1044#1072
      ImageIndex = 73
    end
    object macUpdate_Unit_isSUN_v4_out_no: TMultiAction
      Category = 'isSUN8'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v4_out_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' - '#1053#1077#1090
      ImageIndex = 73
    end
    object macUpdate_Unit_isSUN_v4_in_yes: TMultiAction
      Category = 'isSUN8'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v4_in_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' - '#1044#1072
      ImageIndex = 73
    end
    object macUpdate_Unit_isSUN_v4_in_no: TMultiAction
      Category = 'isSUN8'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v4_in_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' - '#1053#1077#1090
      ImageIndex = 73
    end
    object actDeySupplSun1: TMultiAction
      Category = 'ListDaySUN'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actEDDeySupplSun1
      ActionList = <
        item
          Action = actExecSPDeySupplSun1
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1087#1088#1086#1076#1072#1078' '#1074' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1087#1088#1086#1076#1072#1078' '#1074' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1'
      ImageIndex = 43
    end
    object actExecSPDeySupplSun1: TdsdExecStoredProc
      Category = 'ListDaySUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_DeySupplSun1
      StoredProcList = <
        item
          StoredProc = spUpdate_DeySupplSun1
        end>
      Caption = 'actExecSPDeySupplSun1'
    end
    object actEDDeySupplSun1: TExecuteDialog
      Category = 'ListDaySUN'
      MoveParams = <>
      Caption = 'actEDDeySupplSun1'
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = ''
          Component = FormParams
          ComponentItem = 'ValuesInt'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1044#1085#1080' '#1087#1088#1086#1076#1072#1078' '#1074' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actMonthSupplSun1: TMultiAction
      Category = 'ListDaySUN'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actEDMonthSupplSun1
      ActionList = <
        item
          Action = actExecSPMonthSupplSun1
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1084#1077#1089#1103#1094#1077#1074' '#1085#1072#1079#1072#1076' '#1074' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1084#1077#1089#1103#1094#1077#1074' '#1085#1072#1079#1072#1076' '#1074' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1'
      ImageIndex = 43
    end
    object actExecSPMonthSupplSun1: TdsdExecStoredProc
      Category = 'ListDaySUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MonthSupplSun1
      StoredProcList = <
        item
          StoredProc = spUpdate_MonthSupplSun1
        end>
      Caption = 'actExecSPMonthSupplSun1'
    end
    object actEDMonthSupplSun1: TExecuteDialog
      Category = 'ListDaySUN'
      MoveParams = <>
      Caption = 'actEDMonthSupplSun1'
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = Null
          Component = FormParams
          ComponentItem = 'ValuesInt'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1084#1077#1089#1103#1094#1077#1074' '#1085#1072#1079#1072#1076' '#1074' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actChoiceUnitSAUA: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceUnitSAUA'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitSAUA'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecutePercentSAUA: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actChoiceUnitSAUA
      Caption = 'actExecutePercentSAUA'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = Null
          Component = FormParams
          ComponentItem = 'PercentSAUA'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = Null
          Component = FormParams
          ComponentItem = 'LabelPercentSAUA'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_UnitSAUA: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecutePercentSAUA
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_UnitSAUA
      StoredProcList = <
        item
          StoredProc = spUpdate_UnitSAUA
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' Master  '#1076#1083#1103' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1057#1040#1059#1040
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' Master  '#1076#1083#1103' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1057#1040#1059#1040
    end
    object actClear_UnitSAUA: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spClear_UnitSAUA
      StoredProcList = <
        item
          StoredProc = spClear_UnitSAUA
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' Master '#1076#1083#1103' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1057#1040#1059#1040
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' Slave '#1076#1083#1103' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1057#1040#1059#1040
      ImageIndex = 52
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' Master '#1076#1083#1103' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1057#1040#1059#1040'?'
    end
    object actUpdate_PercentSAUA: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteUpdatePercentSAUA
      ActionList = <
        item
          Action = actExecUpdate_PercentSAUA
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1088#1086#1094#1077#1085#1090' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1086#1076#1086#1074' '#1074' '#1095#1077#1082#1072#1093' '#1076#1083#1103' '#1057#1040#1059#1040' ?'
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1088#1086#1094#1077#1085#1090' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1086#1076#1086#1074' '#1074' '#1095#1077#1082#1072#1093' '#1076#1083#1103' '#1057#1040#1059#1040' '
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1088#1086#1094#1077#1085#1090' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1086#1076#1086#1074' '#1074' '#1095#1077#1082#1072#1093' '#1076#1083#1103' '#1057#1040#1059#1040' '
      ImageIndex = 43
    end
    object actExecUpdate_PercentSAUA: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PercentSAUA
      StoredProcList = <
        item
          StoredProc = spUpdate_PercentSAUA
        end>
      Caption = 'actExecUpdate_PercentSAUA'
    end
    object actExecuteUpdatePercentSAUA: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteUpdatePercentSAUA'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = 0c
          Component = FormParams
          ComponentItem = 'PercentSAUA'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = ' '#1055#1088#1086#1094#1077#1085#1090' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1076#1083#1103' '#1057#1040#1059#1040' '
          Component = FormParams
          ComponentItem = 'LabelPercentSAUA'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Unit_isSUA_No: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUA_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUA_No
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1040' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1040' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 51
    end
    object macUpdate_Unit_isSUA_No_list: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUA_No
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1040' - '#1053#1077#1090
      ImageIndex = 51
    end
    object actUpdate_Unit_isSUA_Yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUA_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUA_Yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1040' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1040' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 51
    end
    object macUpdate_Unit_isSUA_Yes_list: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUA_Yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1040' - '#1044#1072
      ImageIndex = 51
    end
    object actUpdate_isShareFromPrice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isShareFromPrice
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1077#1083#1080#1090#1100' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099' '#1086#1090' '#1094#1077#1085#1099'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1077#1083#1080#1090#1100' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099' '#1086#1090' '#1094#1077#1085#1099'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1077#1083#1080#1090#1100' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099' '#1086#1090' '#1094#1077#1085#1099'"'
      ImageIndex = 79
    end
    object actExecUpdate_isShareFromPrice: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isShareFromPrice
      StoredProcList = <
        item
          StoredProc = spUpdate_isShareFromPrice
        end>
      Caption = 'actExecUpdate_isShareFromPrice'
    end
    object actUpdate_Unit_isSUN_Supplement_in_yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_Supplement_in_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_Supplement_in_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_Unit_isSUN_Supplement_in_no: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_Supplement_in_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_Supplement_in_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_Unit_isSUN_Supplement_out_yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_Supplement_out_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_Supplement_out_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 49
    end
    object actUpdate_Unit_isSUN_Supplement_out_no: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_Supplement_out_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_Supplement_out_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 49
    end
    object macUpdate_Unit_isSUN_Supplement_out_yes: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_Supplement_out_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') -'#1044#1072
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') -'#1044#1072
      ImageIndex = 49
    end
    object macUpdate_Unit_isSUN_Supplement_out_no: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_Supplement_out_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') - '#1053#1077#1090
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') - '#1053#1077#1090
      ImageIndex = 49
    end
    object macUpdate_Unit_isSUN_Supplement_in_yes: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_Supplement_in_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') - '#1044#1072
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') - '#1044#1072
      ImageIndex = 48
    end
    object macUpdate_Unit_isSUN_Supplement_in_no: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_Supplement_in_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') - '#1053#1077#1090
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') - '#1053#1077#1090
      ImageIndex = 48
    end
    object actOpenChoiceUnitTree: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitFrom'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_SunAllParam: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actOpenChoiceUnitTree
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SunAllParam
      StoredProcList = <
        item
          StoredProc = spUpdate_SunAllParam
        end>
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086' '#1057#1059#1053
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086' '#1057#1059#1053
      ImageIndex = 30
    end
    object actUpdate_isOutUKTZED_SUN1_No: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isOutUKTZED_SUN1_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isOutUKTZED_SUN1_No
        end>
      Caption = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053'1 ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053'1 ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_isOutUKTZED_SUN1_Yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isOutUKTZED_SUN1_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isOutUKTZED_SUN1_Yes
        end>
      Caption = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053'1 ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053'1 ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object macUpdate_isOutUKTZED_SUN1_No: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isOutUKTZED_SUN1_No
        end>
      View = cxGridDBTableView
      Caption = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053' (V1) - '#1053#1077#1090
      Hint = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053' (V1) - '#1053#1077#1090
      ImageIndex = 48
    end
    object macUpdate_isOutUKTZED_SUN1_Yes: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isOutUKTZED_SUN1_Yes
        end>
      View = cxGridDBTableView
      Caption = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053' (V1) - '#1044#1072
      Hint = #1054#1090#1076#1072#1095#1072' '#1059#1050#1058#1042#1069#1044' '#1074' '#1057#1059#1053' (V1) - '#1044#1072
      ImageIndex = 48
    end
    object macExecUpdate_isCheckUKTZED: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isCheckUKTZED
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1087#1088#1077#1090' '#1085#1072' '#1087#1077#1095#1072#1090#1100' '#1095#1077#1082#1072', '#1077#1089#1083#1080' '#1077#1089#1090#1100' '#1087#1086#1079#1080#1094#1080#1103' '#1087#1086' '#1059#1050 +
        #1058#1042#1069#1044'"?'
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1087#1088#1077#1090' '#1085#1072' '#1087#1077#1095#1072#1090#1100' '#1095#1077#1082#1072', '#1077#1089#1083#1080' '#1077#1089#1090#1100' '#1087#1086#1079#1080#1094#1080#1103' '#1087#1086' '#1059#1050 +
        #1058#1042#1069#1044'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1087#1088#1077#1090' '#1085#1072' '#1087#1077#1095#1072#1090#1100' '#1095#1077#1082#1072', '#1077#1089#1083#1080' '#1077#1089#1090#1100' '#1087#1086#1079#1080#1094#1080#1103' '#1087#1086' '#1059#1050 +
        #1058#1042#1069#1044'"'
      ImageIndex = 79
    end
    object actExecUpdate_isCheckUKTZED: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isCheckUKTZED
      StoredProcList = <
        item
          StoredProc = spUpdate_isCheckUKTZED
        end>
      Caption = 'actExecUpdate_isCheckUKTZED'
    end
    object macExecUpdate_isGoodsUKTZEDRRO: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isGoodsUKTZEDRRO
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1077#1095#1072#1090#1100' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1059#1050#1058#1042#1069#1044' '#1095#1077#1088#1077#1079' '#1056#1056#1054'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1077#1095#1072#1090#1100' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1059#1050#1058#1042#1069#1044' '#1095#1077#1088#1077#1079' '#1056#1056#1054'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1077#1095#1072#1090#1100' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1059#1050#1058#1042#1069#1044' '#1095#1077#1088#1077#1079' '#1056#1056#1054'"'
      ImageIndex = 79
    end
    object actExecUpdate_isGoodsUKTZEDRRO: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isGoodsUKTZEDRRO
      StoredProcList = <
        item
          StoredProc = spUpdate_isGoodsUKTZEDRRO
        end>
      Caption = 'actExecUpdate_isGoodsUKTZEDRRO'
    end
    object actUpdate_Unit_isSUN_Supplement_Priority_yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_Supplement_Priority_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_Supplement_Priority_yes
        end>
      Caption = #9#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #9#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_Unit_isSUN_Supplement_Priority_no: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_Supplement_Priority_no
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_Supplement_Priority_no
        end>
      Caption = #9#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #9#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object macUpdate_Unit_isSUN_Supplement_Priority_yes: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_Supplement_Priority_yes
        end>
      View = cxGridDBTableView
      Caption = #9#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053'- '#1044#1072
      Hint = #9#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053'- '#1044#1072
      ImageIndex = 48
    end
    object macUpdate_Unit_isSUN_Supplement_Priority_no: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_Supplement_Priority_no
        end>
      View = cxGridDBTableView
      Caption = #9#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053' - '#1053#1077#1090
      Hint = #9#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1080' '#1086#1090#1076#1072#1095#1077' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1082' '#1057#1059#1053' - '#1053#1077#1090
      ImageIndex = 48
    end
    object macExecUpdate_isMessageByTime: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isMessageByTime
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084'"'
      ImageIndex = 79
    end
    object actExecUpdate_isMessageByTime: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMessageByTime
      StoredProcList = <
        item
          StoredProc = spUpdate_isMessageByTime
        end>
      Caption = 'actExecUpdate_isMessageByTime'
    end
    object macExecUpdate_isMessageByTimePD: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isMessageByTimePD
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084' '#1087#1086' '#1082#1072#1090#1077#1075#1086#1088#1080#1080'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084' '#1087#1086' '#1082#1072#1090#1077#1075#1086#1088#1080#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084' '#1087#1086' '#1082#1072#1090#1077#1075#1086#1088#1080#1080'"'
      ImageIndex = 79
    end
    object actExecUpdate_isMessageByTimePD: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMessageByTimePD
      StoredProcList = <
        item
          StoredProc = spUpdate_isMessageByTimePD
        end>
      Caption = 'actExecUpdate_isMessageByTime'
    end
    object macactUnit_isParticipDistribListDiff: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUnit_isParticipDistribListDiff
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1080' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080' '#1079#1072#1082#1072#1079#1077' '#1076#1083 +
        #1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'"?'
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1080' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080' '#1079#1072#1082#1072#1079#1077' '#1076#1083 +
        #1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1080' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080' '#1079#1072#1082#1072#1079#1077' '#1076#1083 +
        #1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'"'
      ImageIndex = 79
    end
    object actUnit_isParticipDistribListDiff: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUnit_isParticipDistribListDiff
      StoredProcList = <
        item
          StoredProc = spUnit_isParticipDistribListDiff
        end>
      Caption = 'actExecUpdate_isMessageByTime'
    end
    object macUnit_isPauseDistribListDiff: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUnit_isPauseDistribListDiff
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1089#1077#1090#1080'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1089#1077#1090#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1089#1077#1090#1080'"'
      ImageIndex = 79
    end
    object actUnit_isPauseDistribListDiff: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUnit_isPauseDistribListDiff
      StoredProcList = <
        item
          StoredProc = spUnit_isPauseDistribListDiff
        end>
      Caption = 'actExecUpdate_isMessageByTime'
    end
    object macUnit_isRequestDistribListDiff: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUnit_isRequestDistribListDiff
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1087#1088#1086#1089' '#1085#1072' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082 +
        #1072' '#1087#1086' '#1089#1077#1090#1080'"?'
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1087#1088#1086#1089' '#1085#1072' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082 +
        #1072' '#1087#1086' '#1089#1077#1090#1080'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1087#1088#1086#1089' '#1085#1072' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103' '#1079#1072#1082#1072#1079' '#1073#1077#1079' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1086#1089#1090#1072#1090#1082 +
        #1072' '#1087#1086' '#1089#1077#1090#1080'"'
      ImageIndex = 79
    end
    object actUnit_isRequestDistribListDiff: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUnit_isRequestDistribListDiff
      StoredProcList = <
        item
          StoredProc = spUnit_isRequestDistribListDiff
        end>
      Caption = 'actExecUpdate_isMessageByTime'
    end
    object actUpdate_TelegramId: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'TelegramId'
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'TelegramId'
          ToParam.DataType = ftString
          ToParam.MultiSelectSeparator = ','
        end>
      AfterAction = actRefresh
      BeforeAction = actTelegramIdDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_TelegramId
      StoredProcList = <
        item
          StoredProc = spUpdate_TelegramId
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' ID '#1072#1087#1090#1077#1082#1080' '#1074' Telegram'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' ID '#1072#1087#1090#1077#1082#1080' '#1074' Telegram'
      ImageIndex = 43
    end
    object actTelegramIdDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteUpdatePercentSAUA'
      FormName = 'TStringDialogForm'
      FormNameParam.Value = 'TStringDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Text'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'TelegramId'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = 'ID '#1072#1087#1090#1077#1082#1080' '#1074' Telegram'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actSendTelegramBotName: TdsdSendTelegramBotAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actGet_TelegramBotToken
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1085#1072#1079#1074#1072#1085#1080#1103' '#1072#1087#1090#1077#1077#1082#1080' '#1085#1072' '#1058#1077#1083#1077#1075#1088#1072#1084' '#1073#1086#1090
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' '#1085#1072#1079#1074#1072#1085#1080#1103' '#1072#1087#1090#1077#1077#1082#1080' '#1085#1072' '#1058#1077#1083#1077#1075#1088#1072#1084' '#1073#1086#1090
      ImageIndex = 30
      QuestionBeforeExecute = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1103' '#1072#1087#1090#1077#1077#1082#1080' '#1085#1072' '#1058#1077#1083#1077#1075#1088#1072#1084' '#1073#1086#1090'?'
      BaseURLParam.Value = 'https://api.telegram.org'
      BaseURLParam.DataType = ftString
      BaseURLParam.MultiSelectSeparator = ','
      Token.Value = ''
      Token.Component = FormParams
      Token.ComponentItem = 'TelegramBotToken'
      Token.DataType = ftString
      Token.MultiSelectSeparator = ','
      ChatId.Value = ''
      ChatId.Component = MasterCDS
      ChatId.ComponentItem = 'TelegramId'
      ChatId.DataType = ftString
      ChatId.MultiSelectSeparator = ','
      isSeend.Value = True
      isSeend.DataType = ftBoolean
      isSeend.MultiSelectSeparator = ','
      isErroeSend.Value = False
      isErroeSend.DataType = ftBoolean
      isErroeSend.MultiSelectSeparator = ','
      Error.Value = ''
      Error.DataType = ftString
      Error.MultiSelectSeparator = ','
      Message.Value = ''
      Message.Component = MasterCDS
      Message.ComponentItem = 'Name'
      Message.DataType = ftString
      Message.MultiSelectSeparator = ','
    end
    object actGet_TelegramBotToken: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_TelegramBotToken
      StoredProcList = <
        item
          StoredProc = spGet_TelegramBotToken
        end>
      Caption = 'actGet_TelegramBotToken'
    end
    object mactUpdate_isOnlyTimingSUN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_isOnlyTimingSUN
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1076#1072#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1089#1088#1086#1082#1086#1074#1099#1081' '#1090#1086#1074#1072#1088' '#1087#1086' '#1057#1059#1053' (V.1)"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1076#1072#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1089#1088#1086#1082#1086#1074#1099#1081' '#1090#1086#1074#1072#1088' '#1087#1086' '#1057#1059#1053' (V.1)"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1076#1072#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1089#1088#1086#1082#1086#1074#1099#1081' '#1090#1086#1074#1072#1088' '#1087#1086' '#1057#1059#1053' (V.1)"'
      ImageIndex = 79
    end
    object actUpdate_isOnlyTimingSUN: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isOnlyTimingSUN
      StoredProcList = <
        item
          StoredProc = spUpdate_isOnlyTimingSUN
        end>
      Caption = 'actUpdate_isOnlyTimingSUN'
    end
    object mspUpdate_isErrorRROToVIP: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_isErrorRROToVIP
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1080' '#1086#1096#1080#1073#1082#1077' '#1056#1056#1054' '#1080' '#1085#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1086#1084' '#1095#1077#1082#1077' '#1089#1086#1093#1088#1072#1085#1103#1090#1100 +
        ' '#1077#1075#1086' '#1082#1072#1082' '#1042#1048#1055'"?'
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1080' '#1086#1096#1080#1073#1082#1077' '#1056#1056#1054' '#1080' '#1085#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1086#1084' '#1095#1077#1082#1077' '#1089#1086#1093#1088#1072#1085#1103#1090#1100 +
        ' '#1077#1075#1086' '#1082#1072#1082' '#1042#1048#1055'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1080' '#1086#1096#1080#1073#1082#1077' '#1056#1056#1054' '#1080' '#1085#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1086#1084' '#1095#1077#1082#1077' '#1089#1086#1093#1088#1072#1085#1103#1090#1100 +
        ' '#1077#1075#1086' '#1082#1072#1082' '#1042#1048#1055'"'
      ImageIndex = 79
    end
    object actUpdate_isErrorRROToVIP: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isErrorRROToVIP
      StoredProcList = <
        item
          StoredProc = spUpdate_isErrorRROToVIP
        end>
      Caption = 'spUpdate_isErrorRROToVIP'
    end
    object actUpdate_Unit_isSUN_v2_Supplement_in_yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSUN_v2_Supplement_in_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isSUN_v2_Supplement_in_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_Unit_isSUN_v2_Supplement_in_no: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSUN_v2_Supplement_in_no
      StoredProcList = <
        item
          StoredProc = spUpdate_isSUN_v2_Supplement_in_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_Unit_isSUN_v2_Supplement_out_yes: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSUN_v2_Supplement_out_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isSUN_v2_Supplement_out_yes
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 49
    end
    object actUpdate_Unit_isSUN_v2_Supplement_out_no: TdsdExecStoredProc
      Category = 'isSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSUN_v2_Supplement_out_no
      StoredProcList = <
        item
          StoredProc = spUpdate_isSUN_v2_Supplement_out_no
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 49
    end
    object macUpdate_Unit_isSUN_v2_Supplement_out_yes: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_Supplement_out_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') -'#1044#1072
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') -'#1044#1072
      ImageIndex = 49
    end
    object macUpdate_Unit_isSUN_v2_Supplement_out_no: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_Supplement_out_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') - '#1053#1077#1090
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1054#1090#1087#1088#1072#1074#1082#1072') - '#1053#1077#1090
      ImageIndex = 49
    end
    object macUpdate_Unit_isSUN_v2_Supplement_in_yes: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_Supplement_in_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') - '#1044#1072
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') - '#1044#1072
      ImageIndex = 48
    end
    object macUpdate_Unit_isSUN_v2_Supplement_in_no: TMultiAction
      Category = 'isSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Unit_isSUN_v2_Supplement_in_no
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') - '#1053#1077#1090
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' v2 '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' ('#1055#1088#1080#1077#1084') - '#1053#1077#1090
      ImageIndex = 48
    end
    object mactUpdate_ShowMessageSite: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_ShowMessageSite
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077' '#1079#1072' 5 '#1084#1080#1085' '#1076#1086' '#1073#1083#1086#1082#1072' '#1079#1072#1082#1072#1079#1072'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077' '#1079#1072' 5 '#1084#1080#1085' '#1076#1086' '#1073#1083#1086#1082#1072' '#1079#1072#1082#1072#1079#1072'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077' '#1079#1072' 5 '#1084#1080#1085' '#1076#1086' '#1073#1083#1086#1082#1072' '#1079#1072#1082#1072#1079#1072'"'
      ImageIndex = 79
    end
    object actUpdate_ShowMessageSite: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ShowMessageSite
      StoredProcList = <
        item
          StoredProc = spUpdate_ShowMessageSite
        end>
      Caption = 'actUpdate_ShowMessageSite'
    end
    object mactUpdate_SupplementAddCash: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_SupplementAddCash
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053' 1 '#1080#1079' '#1082#1072#1089#1089#1099'"' +
        '?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053' 1 '#1080#1079' '#1082#1072#1089#1089#1099'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053' 1 '#1080#1079' '#1082#1072#1089#1089#1099'"'
      ImageIndex = 79
    end
    object actUpdate_SupplementAddCash: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SupplementAddCash
      StoredProcList = <
        item
          StoredProc = spUpdate_SupplementAddCash
        end>
      Caption = 'actUpdate_SupplementAddCash'
    end
    object mactUpdate_SUN_NotSoldIn: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_SUN_NotSoldIn
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1086#1074#1072#1088' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053'-1"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1086#1074#1072#1088' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053'-1"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1086#1074#1072#1088' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053'-1"'
      ImageIndex = 79
    end
    object actUpdate_SUN_NotSoldIn: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SUN_NotSoldIn
      StoredProcList = <
        item
          StoredProc = spUpdate_SUN_NotSoldIn
        end>
      Caption = 'actUpdate_SUN_NotSoldIn'
    end
    object mactUpdate_SupplementAdd30Cash: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_SupplementAdd30Cash
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1090#1086#1074#1072#1088#1072' '#1089#1086' '#1089#1088#1086#1082#1086#1084' '#1086#1090' 30 '#1076#1085#1077#1081' '#1074' '#1076#1086#1087#1086#1083#1085 +
        #1077#1085#1080#1077' '#1057#1059#1053' 1 '#1080#1079' '#1082#1072#1089#1089#1099'"?'
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1090#1086#1074#1072#1088#1072' '#1089#1086' '#1089#1088#1086#1082#1086#1084' '#1086#1090' 30 '#1076#1085#1077#1081' '#1074' '#1076#1086#1087#1086#1083#1085 +
        #1077#1085#1080#1077' '#1057#1059#1053' 1 '#1080#1079' '#1082#1072#1089#1089#1099'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1090#1086#1074#1072#1088#1072' '#1089#1086' '#1089#1088#1086#1082#1086#1084' '#1086#1090' 30 '#1076#1085#1077#1081' '#1074' '#1076#1086#1087#1086#1083#1085 +
        #1077#1085#1080#1077' '#1057#1059#1053' 1 '#1080#1079' '#1082#1072#1089#1089#1099'"'
      ImageIndex = 79
    end
    object actUpdate_SupplementAdd30Cash: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SupplementAdd30Cash
      StoredProcList = <
        item
          StoredProc = spUpdate_SupplementAdd30Cash
        end>
      Caption = 'actUpdate_SupplementAdd30Cash'
    end
    object mactUpdate_ExpressVIPConfirm: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_ExpressVIPConfirm
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1069#1082#1089#1087#1088#1077#1089#1089' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1042#1048#1055'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1069#1082#1089#1087#1088#1077#1089#1089' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1042#1048#1055'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1069#1082#1089#1087#1088#1077#1089#1089' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1042#1048#1055'"'
      ImageIndex = 79
    end
    object actUpdate_ExpressVIPConfirm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ExpressVIPConfirm
      StoredProcList = <
        item
          StoredProc = spUpdate_ExpressVIPConfirm
        end>
      Caption = 'actUpdate_SupplementAdd30Cash'
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
    Params = <
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
          ItemName = 'bbUpdateisOver'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisOverList'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisOverNoList'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisUploadBadm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbisMarginCategory'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisGoodsCategoryYes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisGoodsCategoryNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisReport'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisTopNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
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
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbUpdateisOver: TdxBarButton
      Action = actUpdateisOver
      Category = 0
    end
    object bbUpdateisOverList: TdxBarButton
      Action = macUpdateisOverYes
      Category = 0
    end
    object bbUpdateisOverNoList: TdxBarButton
      Action = macUpdateisOverNo
      Category = 0
    end
    object bbUpdateisUploadBadm: TdxBarButton
      Action = actUpdateisUploadBadm
      Category = 0
    end
    object bbisMarginCategory: TdxBarButton
      Action = actUpdateisMarginCategory
      Category = 0
    end
    object bbUpdateisReport: TdxBarButton
      Action = actUpdateisReport
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbUpdateisGoodsCategoryYes: TdxBarButton
      Action = macUpdateisGoodsCategoryYes
      Category = 0
    end
    object bbUpdateisGoodsCategoryNo: TdxBarButton
      Action = macUpdateisGoodsCategoryNo
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = dsdSetErased
      Category = 0
      ImageIndex = 2
    end
    object dxBarButton2: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
      ImageIndex = 8
    end
    object bbUpdate_Unit_isSUN: TdxBarButton
      Action = macUpdate_Unit_isSUN_Yes_list
      Category = 0
    end
    object bbUpdateisTopNo: TdxBarButton
      Action = actUpdateisTopNo
      Category = 0
    end
    object bbUpdateKoeffSUN: TdxBarButton
      Action = macUpdateKoeffSUN
      Category = 0
    end
    object bbUpdate_Unit_isSUN_in: TdxBarButton
      Action = macUpdate_Unit_isSUN_in_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_out: TdxBarButton
      Action = macUpdate_Unit_isSUN_out_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v2: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_Yes_list
      Category = 0
    end
    object bbUpdate_Unit_isSUN_NotSold: TdxBarButton
      Action = macUpdate_Unit_isSUN_NotSold_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v2_in: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_in_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v2_out: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_out_yes
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actUpdate_Unit_TechnicalRediscount
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v3: TdxBarButton
      Action = macUpdate_Unit_isSUN_v3_yes
      Category = 0
    end
    object bbUpdateKoeffSUNv3: TdxBarButton
      Action = macUpdateKoeffSUNv3
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v3_in: TdxBarButton
      Action = macUpdate_Unit_isSUN_v3_in_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v3_out: TdxBarButton
      Action = macUpdate_Unit_isSUN_v3_out_yes
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdate_ListDaySUN
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actUpdate_Unit_AlertRecounting
      Category = 0
    end
    object bbUpdate_ListDaySUN_pi: TdxBarButton
      Action = macUpdate_ListDaySUN_pi
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v4: TdxBarButton
      Action = macUpdate_Unit_isSUN_v4_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v4_in: TdxBarButton
      Action = macUpdate_Unit_isSUN_v4_in_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v4_out: TdxBarButton
      Action = macUpdate_Unit_isSUN_v4_out_yes
      Category = 0
    end
    object bbUpdateUnit_T_SUN: TdxBarButton
      Action = macUpdateUnit_T_SUN
      Category = 0
    end
    object bbUpdateUnit_SunIncome: TdxBarButton
      Action = macUpdateUnit_SunIncome
      Category = 0
    end
    object bbUpdateUnit_HT_Sun: TdxBarButton
      Action = macUpdateUnit_HT_Sun
      Category = 0
    end
    object bbUpdateUnit_LimitSUN: TdxBarButton
      Action = macUpdateUnit_LimitSUN
      Category = 0
    end
    object bbUpdate_SUN_v2_LockSale_Yes: TdxBarButton
      Action = macUpdate_SUN_v2_LockSale_Yes
      Category = 0
    end
    object bbUpdate_SUN_v2_LockSale_No: TdxBarButton
      Action = macUpdate_SUN_v2_LockSale_No
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'... '#1044#1072
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator3'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_in'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_out'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_Supplement_in_yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_Supplement_out_yes'
        end
        item
          Visible = True
          ItemName = 'dxBarButton16'
        end
        item
          Visible = True
          ItemName = 'dxBarButton13'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_NotSold'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2_in'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2_out'
        end
        item
          Visible = True
          ItemName = 'dxBarButton28'
        end
        item
          Visible = True
          ItemName = 'dxBarButton27'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3_in'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3_out'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4_in'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4_out'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SUN_v2_LockSale_Yes'
        end>
    end
    object dxBarSeparator1: TdxBarSeparator
      Category = 0
      Visible = ivAlways
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarSeparator2: TdxBarSeparator
      Category = 0
      Visible = ivAlways
    end
    object dxBarSeparator3: TdxBarSeparator
      Category = 0
      Visible = ivAlways
    end
    object bbUpdate_SUN_Lock: TdxBarButton
      Action = macUpdate_SUN_Lock
      Category = 0
      ImageIndex = 13
    end
    object bbUpdate_Unit_isSUN_No_list: TdxBarButton
      Action = macUpdate_Unit_isSUN_No_list
      Category = 0
    end
    object dxBarSubItem3: TdxBarSubItem
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'... '#1053#1077#1090
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_No_list'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator4'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2_No_list'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_in_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_out_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_Supplement_in_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_Supplement_out_no'
        end
        item
          Visible = True
          ItemName = 'dxBarButton17'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_NotSold_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2_in_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2_out_no'
        end
        item
          Visible = True
          ItemName = 'dxBarButton30'
        end
        item
          Visible = True
          ItemName = 'dxBarButton29'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator5'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3_in_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3_out_no'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator6'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4_in_no'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4_out_yes'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SUN_v2_LockSale_No'
        end>
    end
    object bbUpdate_Unit_isSUN_v2_No_list: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_No_list
      Category = 0
    end
    object dxBarSeparator4: TdxBarSeparator
      Category = 0
      Visible = ivAlways
    end
    object bbUpdate_Unit_isSUN_in_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_in_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_out_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_out_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_NotSold_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_NotSold_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v2_in_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_in_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v2_out_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_out_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v3_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_v3_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v3_in_no: TdxBarButton
      Action = actUpdate_Unit_isSUN_v3_in_no
      Category = 0
    end
    object dxBarSeparator5: TdxBarSeparator
      Category = 0
      Visible = ivAlways
    end
    object bbUpdate_Unit_isSUN_v3_out_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_v3_out_no
      Category = 0
    end
    object dxBarSeparator6: TdxBarSeparator
      Category = 0
      Visible = ivAlways
    end
    object bbUpdate_Unit_isSUN_v4_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_v4_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v4_out_yes: TdxBarButton
      Action = macUpdate_Unit_isSUN_v4_out_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v4_in_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_v4_in_no
      Category = 0
    end
    object dxBarSubItem4: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateKoeffSUN'
        end
        item
          Visible = True
          ItemName = 'bbUpdateKoeffSUNv3'
        end
        item
          Visible = True
          ItemName = 'bbUpdateUnit_T_SUN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateUnit_SunIncome'
        end
        item
          Visible = True
          ItemName = 'bbUpdateUnit_HT_Sun'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateUnit_LimitSUN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_ListDaySUN_pi'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SUN_Lock'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton23'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic2'
        end
        item
          Visible = True
          ItemName = 'bbisShareFromPrice'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end
        item
          Visible = True
          ItemName = 'dxBarButton18'
        end
        item
          Visible = True
          ItemName = 'dxBarButton19'
        end
        item
          Visible = True
          ItemName = 'dxBarButton20'
        end
        item
          Visible = True
          ItemName = 'dxBarButton25'
        end
        item
          Visible = True
          ItemName = 'dxBarButton26'
        end
        item
          Visible = True
          ItemName = 'dxBarButton31'
        end
        item
          Visible = True
          ItemName = 'dxBarButton32'
        end
        item
          Visible = True
          ItemName = 'dxBarButton34'
        end
        item
          Visible = True
          ItemName = 'dxBarButton33'
        end
        item
          Visible = True
          ItemName = 'dxBarButton35'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end>
    end
    object dxBarButton6: TdxBarButton
      Action = actDeySupplSun1
      Category = 0
    end
    object dxBarSeparator7: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
    end
    object dxBarButton7: TdxBarButton
      Action = actMonthSupplSun1
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton8: TdxBarButton
      Action = actUpdate_PercentSAUA
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = macUpdate_Unit_isSUA_No_list
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = macUpdate_Unit_isSUA_Yes_list
      Category = 0
    end
    object bbisShareFromPrice: TdxBarButton
      Action = actUpdate_isShareFromPrice
      Category = 0
    end
    object dxBarStatic2: TdxBarStatic
      Category = 0
      Visible = ivAlways
    end
    object bbUpdate_Unit_isSUN_Supplement_in_yes: TdxBarButton
      Action = macUpdate_Unit_isSUN_Supplement_in_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_Supplement_out_yes: TdxBarButton
      Action = macUpdate_Unit_isSUN_Supplement_out_yes
      Category = 0
    end
    object bbUpdate_Unit_isSUN_Supplement_in_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_Supplement_in_no
      Category = 0
    end
    object bbUpdate_Unit_isSUN_Supplement_out_no: TdxBarButton
      Action = macUpdate_Unit_isSUN_Supplement_out_no
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actUpdate_SunAllParam
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = macUpdate_isOutUKTZED_SUN1_No
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Action = macUpdate_isOutUKTZED_SUN1_Yes
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = macExecUpdate_isCheckUKTZED
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = macExecUpdate_isGoodsUKTZEDRRO
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Action = macUpdate_Unit_isSUN_Supplement_Priority_yes
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = macUpdate_Unit_isSUN_Supplement_Priority_no
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Action = macExecUpdate_isMessageByTime
      Category = 0
    end
    object dxBarButton19: TdxBarButton
      Action = macExecUpdate_isMessageByTimePD
      Category = 0
    end
    object dxBarButton20: TdxBarButton
      Action = macactUnit_isParticipDistribListDiff
      Category = 0
    end
    object dxBarButton21: TdxBarButton
      Action = macUnit_isPauseDistribListDiff
      Category = 0
    end
    object dxBarButton22: TdxBarButton
      Action = macUnit_isRequestDistribListDiff
      Category = 0
    end
    object dxBarButton23: TdxBarButton
      Action = actUpdate_TelegramId
      Category = 0
    end
    object dxBarButton24: TdxBarButton
      Action = actSendTelegramBotName
      Category = 0
    end
    object dxBarButton25: TdxBarButton
      Action = mactUpdate_isOnlyTimingSUN
      Category = 0
    end
    object dxBarButton26: TdxBarButton
      Action = mspUpdate_isErrorRROToVIP
      Category = 0
    end
    object dxBarButton27: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_Supplement_out_yes
      Category = 0
    end
    object dxBarButton28: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_Supplement_in_yes
      Category = 0
    end
    object dxBarButton29: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_Supplement_out_no
      Category = 0
    end
    object dxBarButton30: TdxBarButton
      Action = macUpdate_Unit_isSUN_v2_Supplement_in_no
      Category = 0
    end
    object dxBarButton31: TdxBarButton
      Action = mactUpdate_ShowMessageSite
      Category = 0
    end
    object dxBarButton32: TdxBarButton
      Action = mactUpdate_SupplementAddCash
      Category = 0
    end
    object dxBarButton33: TdxBarButton
      Action = mactUpdate_SUN_NotSoldIn
      Category = 0
    end
    object dxBarButton34: TdxBarButton
      Action = mactUpdate_SupplementAdd30Cash
      Category = 0
    end
    object dxBarButton35: TdxBarButton
      Action = mactUpdate_ExpressVIPConfirm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
  inherited PopupMenu: TPopupMenu
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Action = actUpdateisOver
    end
    object N4: TMenuItem
      Action = macUpdateisOverYes
    end
    object N5: TMenuItem
      Action = macUpdateisOverNo
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N7: TMenuItem
      Action = actUpdateisUploadBadm
    end
    object N8: TMenuItem
      Action = actUpdateisMarginCategory
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Action = macUpdateisGoodsCategoryYes
    end
    object N11: TMenuItem
      Action = macUpdateisGoodsCategoryNo
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object N13: TMenuItem
      Action = actUpdateisReport
    end
    object N14: TMenuItem
      Action = actUpdate_Unit_TechnicalRediscount
    end
    object N15: TMenuItem
      Action = actUpdate_Unit_AlertRecounting
    end
    object N16: TMenuItem
      Action = actUpdateisTopNo
    end
  end
  object spUpdate_Unit_isOver: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 99
  end
  object spUpdate_Unit_isOver_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOver'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 163
  end
  object spUpdate_Unit_isOver_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOver'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 219
  end
  object spUpdate_Unit_isUploadBadm: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isUploadBadm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUploadBadm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadBadm'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisUploadBadm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadBadm'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 131
  end
  object spUpdate_Unit_isMarginCategory: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isMarginCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMarginCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMarginCategory'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisMarginCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMarginCategory'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 203
  end
  object spUpdate_Unit_isReport: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isReport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 267
  end
  object spUpdate_Unit_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCreateDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CreateDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCloseDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CloseDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManagerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserManagerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManager2Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserManager2Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManager3Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserManager3Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AreaId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitRePriceId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitRePriceId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 123
  end
  object spUpdate_GoodsCategory_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isGoodsCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsCategory'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisGoodsCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsCategory'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 179
  end
  object spUpdate_GoodsCategory_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isGoodsCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsCategory'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisGoodsCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsCategory'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 227
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit_IsErased'
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
      end>
    PackSize = 1
    Left = 224
    Top = 192
  end
  object spUpdate_Unit_isSUN_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSua'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSua'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1336
    Top = 115
  end
  object spUpdate_Unit_isTopNo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isTopNo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTopNo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTopNo'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisTopNo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTopNo'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 339
  end
  object spUpdate_KoeffSUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_KoeffSUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffInSUN'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'KoeffInSUN'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffOutSUN'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'KoeffOutSUN'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 522
    Top = 320
  end
  object spUpdate_Unit_isSUN_v2_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 315
  end
  object spUpdate_Unit_isSUN_in_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_in'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_in'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1352
    Top = 243
  end
  object spUpdate_Unit_isSUN_NotSold_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_NotSold'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_NotSold'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_NotSold'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_NotSold'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1336
    Top = 203
  end
  object spUpdate_Unit_isSUN_v2_in_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 363
  end
  object spUpdate_Unit_isSUN_v2_out_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 403
  end
  object spUpdate_Unit_TechnicalRediscount: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_TechnicalRediscount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTechnicalRediscount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTechnicalRediscount'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisTechnicalRediscount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTechnicalRediscount'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 131
  end
  object spUpdate_Unit_isSUN_v3_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 299
  end
  object spUpdate_KoeffSUNv3: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_KoeffSUN_v3'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffInSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KoeffInSUN_v3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffOutSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KoeffOutSUN_v3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 522
    Top = 376
  end
  object spUpdate_Unit_isSUN_v3_in_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 419
  end
  object spUpdate_Unit_isSUN_v3_out_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 363
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ListDaySUN'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT1_SUN_v2'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT2_SUN_v2'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT1_SUN_v4'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v1'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v2'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v4'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv1'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv2'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv4'
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSUN_v1_Lock'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSUN_v2_Lock'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSUN_v4_Lock'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ValuesInt'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitSAUA'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentSAUA'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPercentSAUA'
        Value = ' '#1055#1088#1086#1094#1077#1085#1090' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1076#1083#1103' '#1057#1040#1059#1040' '
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitFrom'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'TelegramId'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TelegramBotToken'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 29
    Top = 146
  end
  object spUpdate_ListDaySUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_ListDaySUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inListDaySUN'
        Value = Null
        Component = FormParams
        ComponentItem = 'ListDaySUN'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 387
  end
  object spUpdate_Unit_AlertRecounting: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_AlertRecounting'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAlertRecounting'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAlertRecounting'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisAlertRecounting'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAlertRecounting'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 403
  end
  object spUpdate_ListDaySUN_pi: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_ListDaySUN_pi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inListDaySUN_pi'
        Value = ''
        Component = FormParams
        ComponentItem = 'ListDaySUN_pi'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 395
  end
  object spUpdate_Unit_isSUN_v4_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1080
    Top = 179
  end
  object spUpdate_Unit_isSUN_v4_in_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1080
    Top = 235
  end
  object spUpdate_Unit_isSUN_v4_out_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1072
    Top = 299
  end
  object spUpdate_Unit_T_SUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_T_SUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT1_SUN_v2'
        Value = Null
        Component = FormParams
        ComponentItem = 'inisT1_SUN_v2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT2_SUN_v2'
        Value = Null
        Component = FormParams
        ComponentItem = 'inisT2_SUN_v2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT1_SUN_v4'
        Value = Null
        Component = FormParams
        ComponentItem = 'inisT1_SUN_v4'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inT1_SUN_v2'
        Value = Null
        Component = FormParams
        ComponentItem = 'inT1_SUN_v2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inT2_SUN_v2'
        Value = Null
        Component = FormParams
        ComponentItem = 'inT2_SUN_v2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inT1_SUN_v4'
        Value = Null
        Component = FormParams
        ComponentItem = 'inT1_SUN_v4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 179
  end
  object spUpdate_Unit_SunIncome: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SunIncome'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v1'
        Value = False
        Component = FormParams
        ComponentItem = 'inis_v1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v2'
        Value = False
        Component = FormParams
        ComponentItem = 'inis_v2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v4'
        Value = False
        Component = FormParams
        ComponentItem = 'inis_v4'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSunIncome'
        Value = Null
        Component = FormParams
        ComponentItem = 'inSunIncome'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSun_v2Income'
        Value = Null
        Component = FormParams
        ComponentItem = 'inSun_v2Income'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSun_v4Income'
        Value = Null
        Component = FormParams
        ComponentItem = 'inSun_v4Income'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1104
    Top = 123
  end
  object spUpdate_HT_SUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_HT_SUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v1'
        Value = False
        Component = FormParams
        ComponentItem = 'inis_v1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v2'
        Value = False
        Component = FormParams
        ComponentItem = 'inis_v2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v4'
        Value = False
        Component = FormParams
        ComponentItem = 'inis_v4'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_All'
        Value = False
        Component = FormParams
        ComponentItem = 'inis_All'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHT_SUN_v1'
        Value = Null
        Component = FormParams
        ComponentItem = 'inHT_SUN_v1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHT_SUN_v2'
        Value = Null
        Component = FormParams
        ComponentItem = 'inHT_SUN_v2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHT_SUN_v4'
        Value = Null
        Component = FormParams
        ComponentItem = 'inHT_SUN_v4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHT_SUN_All'
        Value = Null
        Component = FormParams
        ComponentItem = 'inHT_SUN_All'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 131
  end
  object spUpdate_Unit_LimitSUN_N: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_LimitSUN_N'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimitSUN_N'
        Value = 'false'
        Component = FormParams
        ComponentItem = 'inLimitSUN_N'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 832
    Top = 115
  end
  object spUpdate_SUN_v2_LockSale_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SUN_v2_LockSale'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSUN_v2_LockSale'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSUN_v2_LockSale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_v2_LockSale'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 179
  end
  object spUpdate_SUN_v2_LockSale_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SUN_v2_LockSale'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSUN_v2_LockSale'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSUN_v2_LockSale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_v2_LockSale'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 227
  end
  object spUpdate_SUN_Lock: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SUN_Lock'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv1'
        Value = False
        Component = FormParams
        ComponentItem = 'inisv1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv2'
        Value = False
        Component = FormParams
        ComponentItem = 'inisv2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisv4'
        Value = False
        Component = FormParams
        ComponentItem = 'inisv4'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inv1_Lock'
        Value = Null
        Component = FormParams
        ComponentItem = 'inv1_Lock'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inV2_Lock'
        Value = Null
        Component = FormParams
        ComponentItem = 'inV2_Lock'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inV4_Lock'
        Value = Null
        Component = FormParams
        ComponentItem = 'inV4_Lock'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1064
    Top = 355
  end
  object spUpdate_Unit_isSUN_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSua'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSua'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1360
    Top = 115
  end
  object spUpdate_Unit_isSUN_v2_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 315
  end
  object spUpdate_Unit_isSUN_v2_in_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 371
  end
  object spUpdate_Unit_isSUN_in_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_in'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_in'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1336
    Top = 243
  end
  object spUpdate_Unit_isSUN_NotSold_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_NotSold'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_NotSold'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_NotSold'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_NotSold'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1368
    Top = 203
  end
  object spUpdate_Unit_isSUN_v2_out_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 403
  end
  object spUpdate_Unit_isSUN_v3_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 299
  end
  object spUpdate_Unit_isSUN_v3_out_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 355
  end
  object spUpdate_Unit_isSUN_v3_in_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 411
  end
  object spUpdate_Unit_isSUN_v4_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1136
    Top = 179
  end
  object spUpdate_Unit_isSUN_v4_in_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1160
    Top = 243
  end
  object spUpdate_Unit_isSUN_v4_out_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1152
    Top = 299
  end
  object spUpdate_DeySupplSun1: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_DeySupplSun1'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDeySupplSun1'
        Value = Null
        Component = FormParams
        ComponentItem = 'ValuesInt'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 363
  end
  object spUpdate_MonthSupplSun1: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_MonthSupplSun1'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonthSupplSun1'
        Value = Null
        Component = FormParams
        ComponentItem = 'ValuesInt'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1016
    Top = 403
  end
  object spUpdate_UnitSAUA: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_UnitSAUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitSAUA'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitSAUA'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentSAUA'
        Value = Null
        Component = FormParams
        ComponentItem = 'PercentSAUA'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 728
    Top = 323
  end
  object spClear_UnitSAUA: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_UnitSAUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitSAUA'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentSAUA'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 832
    Top = 323
  end
  object spUpdate_PercentSAUA: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_PercentSAUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentSAUA'
        Value = Null
        Component = FormParams
        ComponentItem = 'PercentSAUA'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 932
    Top = 323
  end
  object spUpdate_Unit_isSUA_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSua'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSua'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSua'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1360
    Top = 379
  end
  object spUpdate_Unit_isSUA_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSua'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSua'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSua'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1336
    Top = 379
  end
  object spUpdate_isShareFromPrice: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isShareFromPrice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisisShareFromPrice'
        Value = True
        Component = MasterCDS
        ComponentItem = 'isShareFromPrice'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1184
    Top = 355
  end
  object spUpdate_Unit_isSUN_Supplement_in_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_Supplement_in'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_Supplement_in'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_Supplement_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_Supplement_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1352
    Top = 275
  end
  object spUpdate_Unit_isSUN_Supplement_in_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_Supplement_in'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_Supplement_in'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_Supplement_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_Supplement_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1336
    Top = 275
  end
  object spUpdate_Unit_isSUN_out_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_out'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1360
    Top = 155
  end
  object spUpdate_Unit_isSUN_out_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_out'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1344
    Top = 155
  end
  object spUpdate_Unit_isSUN_Supplement_out_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_Supplement_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_Supplement_out'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_Supplement_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_Supplement_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1336
    Top = 299
  end
  object spUpdate_Unit_isSUN_Supplement_out_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_Supplement_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_Supplement_out'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_Supplement_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_Supplement_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1352
    Top = 299
  end
  object spUpdate_SunAllParam: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SunAllParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnnitFrom'
        Value = '0'
        Component = FormParams
        ComponentItem = 'UnitFrom'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1144
    Top = 411
  end
  object spUpdate_isOutUKTZED_SUN1_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOutUKTZED_SUN1'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOutUKTZED_SUN1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOutUKTZED_SUN1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOutUKTZED_SUN1'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 283
  end
  object spUpdate_isOutUKTZED_SUN1_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOutUKTZED_SUN1'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOutUKTZED_SUN1'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOutUKTZED_SUN1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOutUKTZED_SUN1'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 283
  end
  object spUpdate_isCheckUKTZED: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isCheckUKTZED'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCheckUKTZED'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isCheckUKTZED'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1200
    Top = 115
  end
  object spUpdate_isGoodsUKTZEDRRO: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isGoodsUKTZEDRRO'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsUKTZEDRRO'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsUKTZEDRRO'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1200
    Top = 163
  end
  object spUpdate_Unit_isSUN_Supplement_Priority_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_Supplement_Priority'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_Supplement_Priority'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_Supplement_Priority'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_Supplement_Priority'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1336
    Top = 323
  end
  object spUpdate_Unit_isSUN_Supplement_Priority_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_Supplement_Priority'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_Supplement_Priority'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_Supplement_Priority'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_Supplement_Priority'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1352
    Top = 323
  end
  object spUpdate_isMessageByTime: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isMessageByTime'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMessageByTime'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMessageByTime'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1200
    Top = 219
  end
  object spUpdate_isMessageByTimePD: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isMessageByTimePD'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMessageByTimePD'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMessageByTimePD'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1200
    Top = 275
  end
  object spUnit_isParticipDistribListDiff: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isParticipDistribListDiff'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisParticipDistribListDiff'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isParticipDistribListDiff'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 219
  end
  object spUnit_isPauseDistribListDiff: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isPauseDistribListDiff'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPauseDistribListDiff'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isPauseDistribListDiff'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 259
  end
  object spUnit_isRequestDistribListDiff: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isRequestDistribListDiff'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRequestDistribListDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPauseDistribListDiff'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 299
  end
  object spUpdate_TelegramId: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_TelegramId'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTelegramId'
        Value = Null
        Component = FormParams
        ComponentItem = 'TelegramId'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 99
  end
  object spGet_TelegramBotToken: TdsdStoredProc
    StoredProcName = 'gpSelect_CashSettings_TelegramBotToken'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outTelegramBotToken'
        Value = Null
        Component = FormParams
        ComponentItem = 'TelegramBotToken'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 139
  end
  object spUpdate_isOnlyTimingSUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOnlyTimingSUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOnlyTimingSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOnlyTimingSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOnlyTimingSUN'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 91
  end
  object spUpdate_isErrorRROToVIP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isErrorRROToVIP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisErrorRROToVIP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErrorRROToVIP'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisErrorRROToVIP'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 91
  end
  object spUpdate_isSUN_v2_Supplement_out_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_V2_Supplement_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2_Supplement_out'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2_Supplement_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_Supplement_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1088
    Top = 507
  end
  object spUpdate_isSUN_v2_Supplement_in_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_V2_Supplement_in'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2_Supplement_in'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2_Supplement_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_v2_Supplement_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1088
    Top = 459
  end
  object spUpdate_isSUN_v2_Supplement_in_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_V2_Supplement_in'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2_Supplement_in'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2_Supplement_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_v2_Supplement_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 752
    Top = 459
  end
  object spUpdate_isSUN_v2_Supplement_out_no: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_V2_Supplement_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2_Supplement_out'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2_Supplement_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_Supplement_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 744
    Top = 523
  end
  object spUpdate_ShowMessageSite: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_ShowMessageSite'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowMessageSite'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isShowMessageSite'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 274
    Top = 488
  end
  object spUpdate_SupplementAddCash: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SupplementAddCash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSupplementAddCash'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSupplementAddCash'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 442
    Top = 480
  end
  object spUpdate_SUN_NotSoldIn: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SUN_NotSoldIn'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSUN_NotSoldIn'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSUN_NotSoldIn'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 586
    Top = 464
  end
  object spUpdate_SupplementAdd30Cash: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SupplementAdd30Cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSupplementAdd30Cash'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSupplementAdd30Cash'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 442
    Top = 528
  end
  object spUpdate_ExpressVIPConfirm: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_ExpressVIPConfirm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisExpressVIPConfirm'
        Value = True
        Component = MasterCDS
        ComponentItem = 'isExpressVIPConfirm'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 912
    Top = 515
  end
end
