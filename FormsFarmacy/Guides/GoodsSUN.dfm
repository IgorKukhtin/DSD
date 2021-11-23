inherited GoodsSUNForm: TGoodsSUNForm
  Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1057#1059#1053
  ClientHeight = 443
  ClientWidth = 1165
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1181
  ExplicitHeight = 482
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1165
    Height = 417
    ExplicitWidth = 1165
    ExplicitHeight = 417
    ClientRectBottom = 417
    ClientRectRight = 1165
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1165
      ExplicitHeight = 417
      inherited cxGrid: TcxGrid
        Width = 1165
        Height = 417
        ExplicitWidth = 1165
        ExplicitHeight = 417
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = Name
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076
            Options.Editing = False
            Width = 80
          end
          object MorionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
            DataBinding.FieldName = 'MorionCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
            Options.Editing = False
            Width = 80
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1088#1091#1089'. '#1103#1079#1099#1082#1077')'
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 324
          end
          object NDSKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1053#1044#1057
            Options.Editing = False
            Width = 68
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057', %'
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1044#1057', %'
            Options.Editing = False
            Width = 68
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1076#1080#1085#1080#1094#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
            Options.Editing = False
            Width = 59
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 75
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 96
          end
          object GoodsPairSunCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
            DataBinding.FieldName = 'GoodsPairSunCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
            Options.Editing = False
            Width = 70
          end
          object GoodsPairSunName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
            DataBinding.FieldName = 'GoodsPairSunName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1072#1088#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1057#1059#1053
            Options.Editing = False
            Width = 80
          end
          object PairSunAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'PairSunAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object PairSunDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1080#1085#1093#1088'. '#1074' '#1087#1077#1088#1077#1084'. '#1076#1083#1103' '#1090#1086#1074' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
            DataBinding.FieldName = 'PairSunDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1089#1080#1085#1093#1088'. '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1076#1083#1103#1058#1086#1074#1072#1088#1072' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
            Options.Editing = False
            Width = 97
          end
          object IsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'IsClose'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 52
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1054#1055
            Options.Editing = False
            Width = 37
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '1-'#1074#1099#1073#1086#1088
            Width = 60
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090#1085#1099#1081' '#1074#1099#1073#1086#1088
            Width = 60
          end
          object isPromo: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            DataBinding.FieldName = 'isPromo'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            Options.Editing = False
            Width = 100
          end
          object isNot: TcxGridDBColumn
            Caption = #1053#1054#1058'- '#1085#1077#1087#1077#1088#1077#1084#1077#1097'. '#1086#1089#1090'.'
            DataBinding.FieldName = 'isNot'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1054#1058'- '#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' ('#1044#1072'/'#1053#1077#1090')'
            Width = 86
          end
          object isNot_Sun_v2: TcxGridDBColumn
            Caption = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084'. '#1086#1089#1090'. '#1076#1083#1103' '#1057#1059#1053'-v2'
            DataBinding.FieldName = 'isNot_Sun_v2'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2 ('#1044#1072'/'#1053#1077#1090')'
            Options.Editing = False
            Width = 86
          end
          object isNot_Sun_v4: TcxGridDBColumn
            Caption = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084'. '#1086#1089#1090'. '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048
            DataBinding.FieldName = 'isNot_Sun_v4'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2 '#1055#1048' ('#1044#1072'/'#1053#1077#1090')'
            Options.Editing = False
            Width = 86
          end
          object isNotMarion: TcxGridDBColumn
            Caption = #1053#1077' '#1087#1088#1080#1074#1103#1079'. '#1052#1072#1088#1080#1086#1085
            DataBinding.FieldName = 'isNotMarion'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.AllowGrayed = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1091#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1082#1086#1076#1086#1084' '#1052#1072#1088#1080#1086#1085
            Options.Editing = False
            Width = 86
          end
          object RetailCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 70
          end
          object RetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'Name'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 100
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1076#1072#1083#1077#1085
            Options.Editing = False
            Width = 51
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080')'
            Options.Editing = False
            Width = 48
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1088#1082#1090#1080#1088#1086#1074#1082#1080')'
            Options.Editing = False
            Width = 100
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' ('#1089#1086#1079#1076#1072#1085#1080#1103')'
            Options.Editing = False
            Width = 48
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1103')'
            Options.Editing = False
            Width = 70
          end
          object isSp: TcxGridDBColumn
            Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042' '#1089#1087#1080#1089#1082#1077' '#1087#1088#1086#1077#1082#1090#1072' '#171#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072#187
            Options.Editing = False
            Width = 60
          end
          object KoeffSUN_v1: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1057#1059#1053' v1'
            DataBinding.FieldName = 'KoeffSUN_v1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1057#1059#1053' v1'
            Options.Editing = False
            Width = 70
          end
          object KoeffSUN_v2: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1057#1059#1053' v2'
            DataBinding.FieldName = 'KoeffSUN_v2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1057#1059#1053' v2'
            Options.Editing = False
            Width = 70
          end
          object KoeffSUN_v4: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1057#1059#1053' v2-'#1055#1048
            DataBinding.FieldName = 'KoeffSUN_v4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1057#1059#1053' v2-'#1055#1048
            Options.Editing = False
            Width = 70
          end
          object KoeffSUN_Supplementv1: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1'
            DataBinding.FieldName = 'KoeffSUN_Supplementv1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object isResolution_224: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224'
            DataBinding.FieldName = 'isResolution_224'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object DateUpdateClose: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1079#1072#1082#1088#1099#1090#1080#1103
            DataBinding.FieldName = 'DateUpdateClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object isInvisibleSUN: TcxGridDBColumn
            Caption = #1053#1077#1074#1080#1076#1080#1084#1082#1072' '#1076#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053
            DataBinding.FieldName = 'isInvisibleSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object isSupplementSUN1: TcxGridDBColumn
            Caption = #1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1'
            DataBinding.FieldName = 'isSupplementSUN1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object UnitSupplementSUN1OutName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 1'
            DataBinding.FieldName = 'UnitSupplementSUN1OutName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object UnitSupplementSUN2OutName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 2'
            DataBinding.FieldName = 'UnitSupplementSUN2OutName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 129
          end
          object isSupplementSmudge: TcxGridDBColumn
            Caption = #1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1 '#1088#1072#1079#1084#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'isSupplementSmudge'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SupplementMin: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1072#1079#1072#1090#1100' '#1074' '#1076#1086#1087'. '#1057#1059#1053' '#1085#1077' '#1084#1077#1085#1077#1077' '#1095#1077#1084
            DataBinding.FieldName = 'SupplementMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object SupplementMinPP: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1072#1079#1072#1090#1100' '#1074' '#1076#1086#1087'. '#1057#1059#1053' '#1076#1083#1103' '#1072#1087#1090'. '#1087#1091#1085#1082#1090'. '#1085#1077' '#1084#1077#1085#1077#1077' '#1095#1077#1084
            DataBinding.FieldName = 'SupplementMinPP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object isAllowedPlatesSUN: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1083#1072#1089#1090#1080#1085#1082#1072#1084#1080' '#1074' '#1057#1059#1053
            DataBinding.FieldName = 'isAllowedPlatesSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object SummaWages: TcxGridDBColumn
            Caption = #1047#1072' 1 '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1047#1055' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072
            DataBinding.FieldName = 'SummaWages'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091
            Options.Editing = False
            Width = 85
          end
          object PercentWages: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1047#1055' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072
            DataBinding.FieldName = 'PercentWages'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091
            Options.Editing = False
            Width = 86
          end
          object SummaWagesStore: TcxGridDBColumn
            Caption = #1047#1072' 1 '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1047#1055' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'SummaWagesStore'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object PercentWagesStore: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1047#1055' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PercentWagesStore'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object isOnlySP: TcxGridDBColumn
            Caption = #1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
            DataBinding.FieldName = 'isOnlySP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object isUkrainianTranslation: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1074#1086#1076' '#1085#1072' '#1091#1082#1088' '#1103#1079#1099#1082
            DataBinding.FieldName = 'isUkrainianTranslation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 312
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
      end>
    Left = 48
    Top = 240
  end
  inherited ActionList: TActionList
    Left = 127
    Top = 247
    object actUpdate_GoodsPairSun: TdsdDataSetRefresh [0]
      Category = 'GoodsPairSun'
      MoveParams = <>
      StoredProc = spUpdate_GoodsPairSun
      StoredProcList = <
        item
          StoredProc = spUpdate_GoodsPairSun
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogGoodsPairSun: TExecuteDialog [1]
      Category = 'GoodsPairSun'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
      ImageIndex = 26
      FormName = 'TGoods_GoodsPairSun_EditForm'
      FormNameParam.Value = 'TGoods_GoodsPairSun_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inGoodsPairSunId'
          Value = Null
          Component = FormParams
          ComponentItem = 'inGoodsPairSunId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsPairSunCode'
          Value = Null
          Component = FormParams
          ComponentItem = 'inGoodsPairSunCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsPairSunName'
          Value = Null
          Component = FormParams
          ComponentItem = 'inGoodsPairSunName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPairSunAmount'
          Value = Null
          Component = FormParams
          ComponentItem = 'inPairSunAmount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdate_GoodsPairSun: TMultiAction [2]
      Category = 'GoodsPairSun'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogGoodsPairSun
        end
        item
          Action = actUpdate_GoodsPairSun
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
      ImageIndex = 48
    end
    object actUpdate_Goods_LimitSun: TdsdDataSetRefresh [3]
      Category = 'LimitSum'
      MoveParams = <>
      StoredProc = spUpdate_Goods_LimitSun_T
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_LimitSun_T
        end>
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    inherited actRefresh: TdsdDataSetRefresh
      Category = 'Refresh'
    end
    object ExecuteDialogGoods_LimitSum: TExecuteDialog [5]
      Category = 'LimitSum'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      ImageIndex = 26
      FormName = 'TGoods_LimitSUN_T_EditForm'
      FormNameParam.Value = 'TGoods_LimitSUN_T_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inLimitSUN_T1'
          Value = Null
          Component = FormParams
          ComponentItem = 'inLimitSUN_T1'
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
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateGoods_LimitSUN_list: TMultiAction [7]
      Category = 'LimitSum'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Goods_LimitSun
        end>
      View = cxGridDBTableView
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      ImageIndex = 43
    end
    object macUpdate_isNot_Sun_v4_yes: TMultiAction [8]
      Category = 'UpdateNot_v4'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdateNot_v4_yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> =' +
        ' '#1044#1040'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
      ImageIndex = 7
    end
    object macUpdateGoods_LimitSUN: TMultiAction [9]
      Category = 'LimitSum'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogGoods_LimitSum
        end
        item
          Action = macUpdateGoods_LimitSUN_list
        end
        item
          Action = actRefresh
        end>
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      ImageIndex = 43
    end
    object actSimpleUpdateNot_v4_yes: TMultiAction [10]
      Category = 'UpdateNot_v4'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isNot_Sun_v4_Yes
        end>
      View = cxGridDBTableView
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
      Hint = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
    end
    object actUpdate_isNot_Sun_v4_Yes: TdsdExecStoredProc [11]
      Category = 'UpdateNot_v4'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isNOT_v4_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isNOT_v4_Yes
        end>
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
    end
    object macUpdateNot_v2_Yes: TMultiAction [12]
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdateNot_v2_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1044#1072 +
        '? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1044#1072
      ImageIndex = 7
    end
    object actSimpleUpdateNot_v2_Yes: TMultiAction [13]
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isNOT_v2_Yes
        end>
      View = cxGridDBTableView
      Caption = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2 '#1044#1072
      Hint = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2 '#1044#1072
    end
    object actUpdate_isNOT_v2_Yes: TdsdExecStoredProc [14]
      Category = 'UpdateNot'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isNOT_v2_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isNOT_v2_Yes
        end>
      Caption = 'actUpdateHot_Yes'
    end
    object macUpdate_isNot_Sun_v4_No: TMultiAction [15]
      Category = 'UpdateNot_v4'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdateNot_v4_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> =' +
        ' '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
      ImageIndex = 77
    end
    object actSimpleUpdateNot_v4_No: TMultiAction [16]
      Category = 'UpdateNot_v4'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isNot_Sun_v4_No
        end>
      View = cxGridDBTableView
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
      Hint = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
    end
    object actUpdate_isNot_Sun_v4_No: TdsdExecStoredProc [17]
      Category = 'UpdateNot_v4'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isNot_v4_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isNot_v4_No
        end>
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
    end
    object macUpdate_isSun_v3_yes: TMultiAction [18]
      Category = 'v3'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdate_isSUN_v3_yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> = '#1044#1040'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' = '#1044#1040
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> = '#1044#1040
      ImageIndex = 79
    end
    object actSimpleUpdate_isSUN_v3_yes: TMultiAction [19]
      Category = 'v3'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isSun_v3_yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1044#1040
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1044#1040
    end
    object actUpdate_isSun_v3_yes: TdsdExecStoredProc [20]
      Category = 'v3'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSun_v3_yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isSun_v3_yes
        end>
      Caption = 'actUpdateNot_No'
    end
    object macUpdate_isSun_v3_No: TMultiAction [21]
      Category = 'v3'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdate_isSUN_v3_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> = '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' = '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> = '#1053#1045#1058
      ImageIndex = 58
    end
    object actSimpleUpdate_isSUN_v3_No: TMultiAction [22]
      Category = 'v3'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isSun_v3_No
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1053#1045#1058
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1053#1045#1058
    end
    object actUpdate_isSun_v3_No: TdsdExecStoredProc [23]
      Category = 'v3'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSun_v3_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isSun_v3_No
        end>
      Caption = 'actUpdateNot_No'
    end
    inherited actInsert: TInsertUpdateChoiceAction
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
        end>
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      DataSetRefresh = mactAfterInsert
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      DataSetRefresh = spRefreshOneRecord
    end
    object macUpdateNot_v2_No: TMultiAction [26]
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdateNot_v2_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1053#1045 +
        #1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1053#1045#1058
      ImageIndex = 77
    end
    object actSimpleUpdateNot_v2_No: TMultiAction [27]
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isSun_v2_No
        end>
      View = cxGridDBTableView
      Caption = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1053#1045#1058
      Hint = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1053#1045#1058
    end
    object actUpdate_isSun_v2_No: TdsdExecStoredProc [28]
      Category = 'UpdateNot'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isNot_v2_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isNot_v2_No
        end>
      Caption = 'actUpdateNot_No'
    end
    inherited dsdSetErased: TdsdUpdateErased
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1090#1086#1074#1072#1088'?'
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
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
        end>
    end
    object mactAfterInsert: TMultiAction [32]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
        end
        item
          Action = spRefreshOnInsert
        end
        item
        end>
      Caption = 'mactAfterInsert'
    end
    object macUpdateNot_Yes: TMultiAction [33]
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdateNot_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1044#1072'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1044#1072
      ImageIndex = 79
    end
    object actSimpleUpdateNot_Yes: TMultiAction
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNot_Yes
        end>
      View = cxGridDBTableView
      Caption = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1044#1072
      Hint = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1044#1072
    end
    object spRefreshOneRecord: TdsdDataSetRefresh
      Category = 'Refresh'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdateNot_Yes: TdsdExecStoredProc
      Category = 'UpdateNot'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateNot_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateNot_Yes
        end>
      Caption = 'actUpdateNot_Yes'
    end
    object macUpdateNot_No: TMultiAction
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdateNot_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058
      ImageIndex = 52
    end
    object actSimpleUpdateNot_No: TMultiAction
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNot_No
        end>
      View = cxGridDBTableView
      Caption = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1053#1045#1058
      Hint = #1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1053#1045#1058
    end
    object spRefreshOnInsert: TdsdExecStoredProc
      Category = 'Refresh'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'spRefreshOnInsert'
    end
    object actUpdateNot_No: TdsdExecStoredProc
      Category = 'UpdateNot'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateNot_No
      StoredProcList = <
        item
          StoredProc = spUpdateNot_No
        end>
      Caption = 'actUpdateNot_No'
    end
    object actGoodsTopDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actGoodsTopDialog'
      FormName = 'TGoodsTopDialogForm'
      FormNameParam.Value = 'TGoodsTopDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PercentMarkup'
          Value = Null
          Component = FormParams
          ComponentItem = 'PercentMarkup'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = FormParams
          ComponentItem = 'Price'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Goods_KoeffSUN: TdsdDataSetRefresh
      Category = 'KoeffSUN'
      MoveParams = <>
      StoredProc = spUpdate_Goods_KoeffSUN
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_KoeffSUN
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogGoods_KoeffSUN: TExecuteDialog
      Category = 'KoeffSUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      ImageIndex = 26
      FormName = 'TGoods_KoeffSUN_EditForm'
      FormNameParam.Value = 'TGoods_KoeffSUN_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inKoeffSUN_v1'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeffSUN_v1'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeffSUN_v2'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeffSUN_v2'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeffSUN_v4'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeffSUN_v4'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeffSUN_Supplementv1'
          Value = Null
          Component = FormParams
          ComponentItem = 'inKoeffSUN_Supplementv1'
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
          Name = 'inis_Supplementv1'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_Supplementv1'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateGoods_KoeffSUN_list: TMultiAction
      Category = 'KoeffSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Goods_KoeffSUN
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      ImageIndex = 43
    end
    object macUpdateGoods_KoeffSUN: TMultiAction
      Category = 'KoeffSUN'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogGoods_KoeffSUN
        end
        item
          Action = macUpdateGoods_KoeffSUN_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v2-'#1055#1048')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      ImageIndex = 43
    end
    object actUpdateInvisibleSUN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = ExecUpdate_isInvisibleSUN
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1074#1080#1076#1080#1084#1082#1072' '#1076#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053'"?? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1074#1080#1076#1080#1084#1082#1072' '#1076#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1074#1080#1076#1080#1084#1082#1072' '#1076#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053'"'
      ImageIndex = 79
    end
    object ExecUpdate_isInvisibleSUN: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isInvisibleSUN_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_isInvisibleSUN_Revert
        end>
      Caption = 'ExecUpdate_isInvisibleSUN'
    end
    object actUpdateisSupplementSUN1: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = execUpdate_SupplementSUN1
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      ImageIndex = 79
    end
    object execUpdate_SupplementSUN1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSupplementSUN1_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_isSupplementSUN1_Revert
        end>
      Caption = 'execUpdate_isSupplementSUN1'
    end
    object actUpdate_SummaWages: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialog_Update_SummaWages
      ActionList = <
        item
          Action = actExec_Update_SummaWages
        end>
      View = cxGridDBTableView
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076 +
        #1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076 +
        #1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      ImageIndex = 43
    end
    object actExec_Update_SummaWages: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SummaWages
      StoredProcList = <
        item
          StoredProc = spUpdate_SummaWages
        end>
      Caption = 'actExec_Update_SummaWages'
    end
    object actExecuteDialog_Update_SummaWages: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialog_Update_SummaWages'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = '0'
          Component = FormParams
          ComponentItem = 'SummaWages'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = Null
          Component = FormParams
          ComponentItem = 'LabelSummaWages'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_PercentWages: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialogUpdate_PercentWages
      ActionList = <
        item
          Action = actExec_Update_PercentWages
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      ImageIndex = 43
    end
    object actExec_Update_PercentWages: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = 'actExec_Update_PercentWages'
    end
    object actExecuteDialogUpdate_PercentWages: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogUpdate_PercentWages'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PercentWages'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = Null
          Component = FormParams
          ComponentItem = 'LabelPercentWages'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actGetImportSetting_Goods_inSupplementSUN1: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_Goods_inSupplementSUN1
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_Goods_inSupplementSUN1
        end>
      Caption = 'actGetImportSetting_Goods_Price'
    end
    object actDoLoadinSupplementSUN1: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
    end
    object macLoadinSupplementSUN1: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Goods_inSupplementSUN1
        end
        item
          Action = actDoLoadinSupplementSUN1
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1087#1088#1080#1079#1085#1072#1082#1086#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1082' '#1057#1059#1053'1?'
      InfoAfterExecute = #1055#1088#1080#1079#1085#1072#1082#1080' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1082' '#1057#1059#1053'1 '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1082' '#1057#1059#1053'1'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1082' '#1057#1059#1053'1'
      ImageIndex = 66
    end
    object actUpdate_SummaWagesStore: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialog_Update_SummaWagesStore
      ActionList = <
        item
          Action = actExec_Update_SummaWagesStore
        end>
      View = cxGridDBTableView
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087 +
        #1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087 +
        #1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      ImageIndex = 43
    end
    object actExec_Update_SummaWagesStore: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SummaWagesStore
      StoredProcList = <
        item
          StoredProc = spUpdate_SummaWagesStore
        end>
      Caption = 'actExec_Update_SummaWagesStore'
    end
    object actExecuteDialog_Update_SummaWagesStore: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialog_Update_SummaWagesStore'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'SummaWagesStore'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091
          Component = FormParams
          ComponentItem = 'LabelSummaWagesStore'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_PercentWagesStore: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialogUpdate_PercentWagesStore
      ActionList = <
        item
          Action = actExec_Update_PercentWagesStore
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      ImageIndex = 43
    end
    object actExec_Update_PercentWagesStore: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PercentWagesStore
      StoredProcList = <
        item
          StoredProc = spUpdate_PercentWagesStore
        end>
      Caption = 'actExec_Update_PercentWagesStore'
    end
    object actExecuteDialogUpdate_PercentWagesStore: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogUpdate_PercentWagesStore'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PercentWagesStore'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091
          Component = FormParams
          ComponentItem = 'LabelPercentWagesStore'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actSetUnitSupplementSUN1Out: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoiceUnitSupplementSUN1Out
      ActionList = <
        item
          Action = actExecSetUnitSupplementSUN1Out
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 1"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 1"'
      ImageIndex = 79
    end
    object actChoiceUnitSupplementSUN1Out: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceUnitSupplementSUN1Out'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitSupplementSUN1'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecSetUnitSupplementSUN1Out: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSetUnitSupplementSUN1Out
      StoredProcList = <
        item
          StoredProc = spSetUnitSupplementSUN1Out
        end>
      Caption = 'actExecSetUnitSupplementSUN1Out'
    end
    object actClearUnitSupplementSUN1Out: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecClearUnitSupplementSUN1Out
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 1"?'
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 1"'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 1"'
      ImageIndex = 76
    end
    object actExecClearUnitSupplementSUN1Out: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spClearUnitSupplementSUN1Out
      StoredProcList = <
        item
          StoredProc = spClearUnitSupplementSUN1Out
        end>
      Caption = 'actExecClearUnitSupplementSUN1Out'
    end
    object actSetUnitSupplementSUN2Out: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actChoiceUnitSupplementSUN1Out
      ActionList = <
        item
          Action = actExecSetUnitSupplementSUN2Out
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 2"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 2"'
      ImageIndex = 79
    end
    object actExecSetUnitSupplementSUN2Out: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSetUnitSupplementSUN2Out
      StoredProcList = <
        item
          StoredProc = spSetUnitSupplementSUN2Out
        end>
      Caption = 'actExecSetUnitSupplementSUN1Out'
    end
    object actClearUnitSupplementSUN2Out: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecClearUnitSupplementSUN2Out
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 3"?'
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 2"'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053' - 2"'
      ImageIndex = 76
    end
    object actExecClearUnitSupplementSUN2Out: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spClearUnitSupplementSUN2Out
      StoredProcList = <
        item
          StoredProc = spClearUnitSupplementSUN2Out
        end>
      Caption = 'actExecClearUnitSupplementSUN1Out'
    end
    object mactUpdate_inSupplementSmudge: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = execUpdate_inSupplementSmudge
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1 '#1088#1072#1079#1084#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1 '#1088#1072#1079#1084#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1 '#1088#1072#1079#1084#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088'"'
      ImageIndex = 79
    end
    object execUpdate_inSupplementSmudge: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inSupplementSmudge
      StoredProcList = <
        item
          StoredProc = spUpdate_inSupplementSmudge
        end>
      Caption = 'execUpdate_inSupplementSmudge'
    end
    object actExecuteDialog_SupplementMin: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialog_Update_SummaWagesStore'
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = Null
          Component = FormParams
          ComponentItem = 'SupplementMin'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1056#1072#1079#1084#1072#1079#1072#1090#1100' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1080' '#1057#1059#1053' '#1085#1077' '#1084#1077#1085#1077#1077' '#1095#1077#1084
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object mactUpdate_SupplementMin: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialog_SupplementMin
      ActionList = <
        item
          Action = actExec_Update_SupplementMin
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1056#1072#1079#1084#1072#1079#1072#1090#1100' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1080' '#1057#1059#1053' '#1085#1077' '#1084#1077#1085#1077#1077' '#1095#1077#1084'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1056#1072#1079#1084#1072#1079#1072#1090#1100' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1080' '#1057#1059#1053' '#1085#1077' '#1084#1077#1085#1077#1077' '#1095#1077#1084'"'
      ImageIndex = 43
    end
    object actExec_Update_SupplementMin: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SupplementMin
      StoredProcList = <
        item
          StoredProc = spUpdate_SupplementMin
        end>
      Caption = 'actExec_Update_SupplementMin'
    end
    object actExecuteDialog_SupplementMinPP: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialog_SupplementMinPP'
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = Null
          Component = FormParams
          ComponentItem = 'SupplementMin'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1056#1072#1079#1084#1072#1079#1072#1090#1100' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1080' '#1057#1059#1053' '#1076#1083#1103' '#1072#1087#1090#1077#1095#1085#1099#1093' '#1087#1091#1085#1082#1090#1086#1074' '#1085#1077' '#1084#1077#1085#1077#1077' '#1095#1077#1084
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object mactUpdate_SupplementMinPP: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialog_SupplementMinPP
      ActionList = <
        item
          Action = actExec_Update_SupplementMinPP
        end>
      View = cxGridDBTableView
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1056#1072#1079#1084#1072#1079#1072#1090#1100' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1080' '#1057#1059#1053' '#1076#1083#1103' '#1072#1087#1090#1077#1095#1085#1099#1093' '#1087#1091#1085#1082#1090 +
        #1086#1074' '#1085#1077' '#1084#1077#1085#1077#1077' '#1095#1077#1084'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1056#1072#1079#1084#1072#1079#1072#1090#1100' '#1074' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1080' '#1057#1059#1053' '#1076#1083#1103' '#1072#1087#1090#1077#1095#1085#1099#1093' '#1087#1091#1085#1082#1090 +
        #1086#1074' '#1085#1077' '#1084#1077#1085#1077#1077' '#1095#1077#1084'"'
      ImageIndex = 43
    end
    object actExec_Update_SupplementMinPP: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SupplementMinPP
      StoredProcList = <
        item
          StoredProc = spUpdate_SupplementMinPP
        end>
      Caption = 'actExec_Update_SupplementMinPP'
    end
    object mactUpdate_inAllowedPlatesSUN_Revert: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_inAllowedPlatesSUN_Revert
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1056#1072#1079#1088#1077#1096#1077#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1083#1072#1089#1090#1080#1085#1082#1072#1084#1080' '#1074' '#1057#1059#1053'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1056#1072#1079#1088#1077#1096#1077#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1083#1072#1089#1090#1080#1085#1082#1072#1084#1080' '#1074' '#1057#1059#1053'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1056#1072#1079#1088#1077#1096#1077#1085#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1083#1072#1089#1090#1080#1085#1082#1072#1084#1080' '#1074' '#1057#1059#1053'"'
      ImageIndex = 79
    end
    object actUpdate_inAllowedPlatesSUN_Revert: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inAllowedPlatesSUN_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_inAllowedPlatesSUN_Revert
        end>
      Caption = 'actUpdate_inAllowedPlatesSUN_Revert'
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 96
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 24
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_SUN'
    Left = 144
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 40
    Top = 168
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
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
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbChoiceGuides'
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
          ItemName = 'bsUpdate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateGoods_KoeffSUN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_GoodsPairSun'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbProtocolOpenForm'
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
      Style = dmMain.cxFooterStyle
      ShowCaption = False
    end
    object bbPublished: TdxBarButton
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Category = 0
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbLabel3: TdxBarControlContainerItem
      Caption = 'Label3'
      Category = 0
      Hint = 'Label3'
      Visible = ivAlways
    end
    object bbContract: TdxBarControlContainerItem
      Caption = 'Contract'
      Category = 0
      Hint = 'Contract'
      Visible = ivAlways
    end
    object bbUpdateNDS: TdxBarButton
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Category = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbUpdate_CountPrice: TdxBarButton
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
      Category = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1089#1077#1090#1103#1084
      Style = dmMain.cxContentStyle
      Visible = ivAlways
      PaintStyle = psCaption
    end
    object bbStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1062#1077#1085#1099
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1062#1077#1085#1099
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbUpdateNotMarion_Yes: TdxBarButton
      Caption = '<'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbUpdateNotMarion_No: TdxBarButton
      Caption = '<'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdateNot_Yes: TdxBarButton
      Action = macUpdateNot_Yes
      Category = 0
    end
    object bbUpdateNot_No: TdxBarButton
      Action = macUpdateNot_No
      Category = 0
    end
    object bbUpdateNot_v2_Yes: TdxBarButton
      Action = macUpdateNot_v2_Yes
      Category = 0
    end
    object bbUpdateNot_v2_No: TdxBarButton
      Action = macUpdateNot_v2_No
      Category = 0
    end
    object bbUpdate_isSun_v3_yes: TdxBarButton
      Action = macUpdate_isSun_v3_yes
      Category = 0
    end
    object bbUpdate_isSun_v3_No: TdxBarButton
      Action = macUpdate_isSun_v3_No
      Category = 0
    end
    object bbSetClose: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbClearClose: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbinResolution_224_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbisResolution_224_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_inTop_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_inTop_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbUpdate_isNot_Sun_v4_yes: TdxBarButton
      Action = macUpdate_isNot_Sun_v4_yes
      Category = 0
    end
    object bbUpdate_isNot_Sun_v4_No: TdxBarButton
      Action = macUpdate_isNot_Sun_v4_No
      Category = 0
    end
    object bbUpdateGoods_KoeffSUN: TdxBarButton
      Action = macUpdateGoods_KoeffSUN
      Category = 0
    end
    object bbUpdateGoods_LimitSUN: TdxBarButton
      Action = macUpdateGoods_LimitSUN
      Category = 0
    end
    object bbUpdate_GoodsPairSun: TdxBarButton
      Action = macUpdate_GoodsPairSun
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton1: TdxBarButton
      Action = actUpdateisSupplementSUN1
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bsUpdate: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateInvisibleSUN'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisSupplementSUN1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton16'
        end
        item
          Visible = True
          ItemName = 'dxBarButton19'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
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
          ItemName = 'dxBarButton17'
        end
        item
          Visible = True
          ItemName = 'dxBarButton18'
        end>
    end
    object bbUpdateInvisibleSUN: TdxBarButton
      Action = actUpdateInvisibleSUN
      Category = 0
    end
    object bbUpdateisSupplementSUN1: TdxBarButton
      Action = actUpdateisSupplementSUN1
      Category = 0
    end
    object bbUpdateExceptionUKTZED: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateNot_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateNot_v2_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isNot_Sun_v4_yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSun_v3_yes'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end>
    end
    object dxBarSubItem3: TdxBarSubItem
      Caption = #1057#1085#1103#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 58
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateNot_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdateNot_v2_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isNot_Sun_v4_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSun_v3_No'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end>
    end
    object dxBarSubItem4: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <>
    end
    object bbUpdate_inPresent_Revert: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton3: TdxBarButton
      Action = actUpdate_SummaWages
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdate_PercentWages
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = macLoadinSupplementSUN1
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actUpdate_SummaWagesStore
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actUpdate_PercentWagesStore
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actSetUnitSupplementSUN1Out
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actClearUnitSupplementSUN1Out
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton11: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton12: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton13: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "% '#1085#1072#1094#1077#1085#1082#1080'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "% '#1085#1072#1094#1077#1085#1082#1080'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarSubItem5: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton14: TdxBarButton
      Action = actSetUnitSupplementSUN2Out
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = actClearUnitSupplementSUN2Out
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Action = mactUpdate_inSupplementSmudge
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = mactUpdate_SupplementMin
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Action = mactUpdate_SupplementMinPP
      Category = 0
    end
    object dxBarButton19: TdxBarButton
      Action = mactUpdate_inAllowedPlatesSUN_Revert
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    ColorRuleList = <
      item
        ColorColumn = IsTop
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Code
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsGroupName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = IsClose
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isErased
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isFirst
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MeasureName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Name
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = NDSKindName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isSecond
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isPromo
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = RetailCode
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = RetailName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
    SearchAsFilter = False
    Left = 184
    Top = 208
  end
  inherited PopupMenu: TPopupMenu
    Left = 176
    Top = 240
  end
  inherited spErasedUnErased: TdsdStoredProc
    Left = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v1'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v2'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v4'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_Supplementv1'
        Value = 0.000000000000000000
        DataType = ftFloat
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
        Name = 'inis_Supplementv1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaWages'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelSummaWages'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090 +
          #1086#1083#1100#1085#1080#1082#1072
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentWages'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPercentWages'
        Value = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaWagesStore'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelSummaWagesStore'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082 +
          #1083#1072#1076#1086#1074#1097#1080#1082#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentWagesStore'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPercentWagesStore'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082 +
          #1083#1072#1076#1086#1074#1097#1080#1082#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitSupplementSUN1'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Multiplicity'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MultiplicityLabel'
        Value = #1042#1074#1077#1076#1080#1090#1077' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1080#1076#1072#1078#1077'"'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkupLabel'
        Value = #1042#1074#1077#1076#1080#1090#1077' % '#1085#1072#1094#1077#1085#1082#1080
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SupplementMin'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 64
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 120
    Top = 208
  end
  object spUpdateNot_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNOT'
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
        Name = 'inisNot'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 179
  end
  object spUpdateNot_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNot'
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
        Name = 'inisNot'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 235
  end
  object spUpdate_Goods_isNot: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNot'
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
        Name = 'inisNot'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isNot'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNot'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 115
  end
  object spUpdate_isNOT_v2_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNOT_Sun_v2'
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
        Name = 'inisNot_SUN_v2'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 808
    Top = 123
  end
  object spUpdate_isNot_v2_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNot_Sun_v2'
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
        Name = 'inisNot_SUN_v2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 179
  end
  object spUpdate_isSun_v3_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isSun_v3'
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
        Name = 'inisSUN_v3'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 187
  end
  object spUpdate_isSun_v3_yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isSun_v3'
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
        Name = 'inisSUN_v3'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 928
    Top = 123
  end
  object spUpdate_isNot_v4_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNot_Sun_v4'
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
        Name = 'inisNot_SUN_v4'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 307
  end
  object spUpdate_isNOT_v4_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNOT_Sun_v4'
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
        Name = 'inisNot_SUN_v4'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 243
  end
  object spUpdate_Goods_KoeffSUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_KoeffSUN'
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
        Name = 'inis_Supplementv1'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_Supplementv1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v1'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeffSUN_v1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v1'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeffSUN_v2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v4'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeffSUN_v4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_Supplementv1'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKoeffSUN_Supplementv1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 307
  end
  object spUpdate_isInvisibleSUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inInvisibleSUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInvisibleSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isInvisibleSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 360
  end
  object spUpdate_isInvisibleSUN_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inInvisibleSUN_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInvisibleSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isInvisibleSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 296
  end
  object spUpdate_Goods_LimitSun_T: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_LimitSUN_T'
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
        Name = 'inLimitSUN_T1'
        Value = Null
        Component = FormParams
        ComponentItem = 'inLimitSUN_T1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 251
  end
  object spUpdate_GoodsPairSun: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_GoodsPairSun'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPairSunId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inGoodsPairSunId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPairSunAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPairSunAmount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 168
  end
  object spUpdate_isSupplementSUN1_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inSupplementSUN1_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInvisibleSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSupplementSUN1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 336
  end
  object spUpdate_SummaWages: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_SummaWages'
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
        Name = 'inSummaWages'
        Value = Null
        Component = FormParams
        ComponentItem = 'SummaWages'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 120
  end
  object spUpdate_PercentWages: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_PercentWages'
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
        Name = 'inPercentWages'
        Value = Null
        Component = FormParams
        ComponentItem = 'PercentWages'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 168
  end
  object spGetImportSetting_Goods_inSupplementSUN1: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsForm;zc_Object_ImportSetting_inSupplementSUN1'
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
    Left = 328
    Top = 112
  end
  object spUpdate_PercentWagesStore: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_PercentWagesStore'
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
        Name = 'inPercentWagesStore'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'PercentWagesStore'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 272
  end
  object spUpdate_SummaWagesStore: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_SummaWagesStore'
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
        Name = 'inSummaWagesStore'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'SummaWagesStore'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 224
  end
  object spSetUnitSupplementSUN1Out: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_UnitSupplementSUN1Out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitSupplementSUN1Out'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitSupplementSUN1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 272
  end
  object spClearUnitSupplementSUN1Out: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_UnitSupplementSUN1Out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitSupplementSUN1'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 224
  end
  object spSetUnitSupplementSUN2Out: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_UnitSupplementSUN2Out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitSupplementSUN2Out'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitSupplementSUN1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 352
  end
  object spClearUnitSupplementSUN2Out: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_UnitSupplementSUN2Out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitSupplementSUN2'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 312
  end
  object spUpdate_inSupplementSmudge: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inSupplementSUN1Smudge'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSupplementSmudge'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSupplementSmudge'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 344
  end
  object spUpdate_SupplementMin: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_SupplementMin'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSupplementMin'
        Value = Null
        Component = FormParams
        ComponentItem = 'SupplementMin'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1056
    Top = 120
  end
  object spUpdate_SupplementMinPP: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_SupplementMinPP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSupplementMinPP'
        Value = Null
        Component = FormParams
        ComponentItem = 'SupplementMin'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1056
    Top = 176
  end
  object spUpdate_inAllowedPlatesSUN_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isAllowedPlatesSUN_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAllowedPlatesSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAllowedPlatesSUN'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1048
    Top = 240
  end
end
