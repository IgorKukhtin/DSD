inherited GoodsForm: TGoodsForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1089#1077#1090#1080
  ClientHeight = 443
  ClientWidth = 1166
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1182
  ExplicitHeight = 482
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1166
    Height = 417
    ExplicitWidth = 1166
    ExplicitHeight = 417
    ClientRectBottom = 417
    ClientRectRight = 1166
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1166
      ExplicitHeight = 417
      inherited cxGrid: TcxGrid
        Width = 1166
        Height = 417
        ExplicitWidth = 1166
        ExplicitHeight = 417
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = Name
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
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
          object IdBarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'IdBarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1072#1087#1090#1077#1082#1072')'
            Options.Editing = False
            Width = 90
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100')'
            Options.Editing = False
            Width = 110
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
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
          object PairSunDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1080#1085#1093#1088'. '#1074' '#1087#1077#1088#1077#1084'. '#1076#1083#1103' '#1090#1086#1074' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
            DataBinding.FieldName = 'PairSunDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1089#1080#1085#1093#1088'. '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1076#1083#1103#1058#1086#1074#1072#1088#1072' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
            Options.Editing = False
            Width = 97
          end
          object MinimumLot: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0; ; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1088#1072#1090#1085#1086#1089#1090#1100' ('#1084#1080#1085'.'#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077')'
            Options.Editing = False
            Width = 77
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
          object isPublished: TcxGridDBColumn
            Caption = #1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isPublished'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.AllowGrayed = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            Options.Editing = False
            Width = 86
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
          object isMarketToday: TcxGridDBColumn
            Caption = #1045#1089#1090#1100' '#1085#1072' '#1088#1099#1085#1082#1077' '#1089#1077#1075#1086#1076#1085#1103
            DataBinding.FieldName = 'isMarketToday'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1090#1100' '#1085#1072' '#1088#1099#1085#1082#1077' '#1089#1077#1075#1086#1076#1085#1103' ('#1044#1072'/'#1053#1077#1090')'
            Options.Editing = False
            Width = 70
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
          object LastPriceDate: TcxGridDBColumn
            Caption = #1055#1086#1089#1083#1077#1076'. '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            DataBinding.FieldName = 'LastPriceDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 65
          end
          object LastPriceOldDate: TcxGridDBColumn
            Caption = #1055#1088#1077#1076#1087#1086#1089#1083#1077#1076'. '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            DataBinding.FieldName = 'LastPriceOldDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1087#1086#1089#1083#1077#1076#1085#1103#1103' '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 85
          end
          object CountDays: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085'. ('#1085#1072#1083#1080#1095#1080#1077' '#1085#1072' '#1088#1099#1085#1082#1077')'
            DataBinding.FieldName = 'CountDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1084#1077#1078#1076#1091' '#1076#1072#1090#1072#1084#1080' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 66
          end
          object CountDays_inf: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085'. '#1053#1045#1058' '#1085#1072' '#1088#1099#1085#1082#1077
            DataBinding.FieldName = 'CountDays_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1053#1045#1058' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 66
          end
          object CountPrice: TcxGridDBColumn
            Caption = #1053#1072' '#1088#1099#1085#1082#1077' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
            DataBinding.FieldName = 'CountPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072' '#1088#1099#1085#1082#1077' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
            Options.Editing = False
            Width = 60
          end
          object PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.## ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 84
          end
          object Price: TcxGridDBColumn
            AlternateCaption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            Options.Editing = False
            Width = 70
          end
          object RetailCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'RetailCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 70
          end
          object RetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'RetailName'
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
          object isNotUploadSites: TcxGridDBColumn
            Caption = #1053#1077' '#1074#1099#1075#1088#1091#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1072#1081#1090#1086#1074
            DataBinding.FieldName = 'isNotUploadSites'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1074#1099#1075#1088#1091#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1072#1081#1090#1086#1074' ('#1074' '#1074#1099#1075#1088#1091#1079#1082#1072#1093' '#1076#1083#1103' '#1082#1086#1085#1090#1088' '#1072#1075#1077#1085#1090#1086#1074')'
            Width = 60
          end
          object DoesNotShare: TcxGridDBColumn
            Caption = #1053#1077' '#1076#1077#1083#1080#1090#1100' ('#1092#1072#1088#1084#1072#1094#1077#1074#1090#1099')'
            DataBinding.FieldName = 'DoesNotShare'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1076#1077#1083#1080#1090#1100' ('#1092#1072#1088#1084#1072#1094#1077#1074#1090#1099')'
            Width = 60
          end
          object AllowDivision: TcxGridDBColumn
            Caption = #1044#1077#1083#1080#1090#1100' '#1085#1072' '#1082#1072#1089#1089#1072#1093
            DataBinding.FieldName = 'AllowDivision'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1083#1080#1090#1100' '#1085#1072' '#1082#1072#1089#1089#1072#1093
          end
          object GoodsAnalog: TcxGridDBColumn
            Caption = #1040#1085#1072#1083#1086#1075#1080' '#1087#1086' '#1076#1077#1081#1089#1090#1074#1091#1102#1097#1077#1084#1091' '#1074#1077#1097#1077#1089#1090#1074#1091
            DataBinding.FieldName = 'GoodsAnalog'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.MaxLength = 255
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1086#1075' '#1090#1086#1074#1072#1088#1072
            Width = 99
          end
          object GoodsAnalogATC: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1040#1058#1057
            DataBinding.FieldName = 'GoodsAnalogATC'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.MaxLength = 255
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object GoodsActiveSubstance: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074#1091#1102#1097#1077#1077' '#1074#1077#1097#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'GoodsActiveSubstance'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.MaxLength = 255
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object NotTransferTime: TcxGridDBColumn
            Caption = #1053#1077' '#1087#1077#1088#1077#1074#1086#1076#1080#1090#1100' '#1074' '#1089#1088#1086#1082#1080
            DataBinding.FieldName = 'NotTransferTime'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1087#1077#1088#1077#1074#1086#1076#1080#1090#1100' '#1074' '#1089#1088#1086#1082#1080
            Options.Editing = False
            Width = 78
          end
          object isSUN_v3: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053
            DataBinding.FieldName = 'isSUN_v3'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1069#1082#1089#1087#1088#1077#1089#1089
            Options.Editing = False
            Width = 50
          end
          object KoeffSUN_v3: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1069'-'#1057#1059#1053
            DataBinding.FieldName = 'KoeffSUN_v3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1086' '#1057#1059#1053' - '#1069#1082#1089#1087#1088#1077#1089#1089
            Options.Editing = False
            Width = 70
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
          object isExceptionUKTZED: TcxGridDBColumn
            Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1059#1050#1058#1042#1069#1044
            DataBinding.FieldName = 'isExceptionUKTZED'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086' '#1059#1050#1058#1042#1069#1044
            Options.Editing = False
            Width = 81
          end
          object isPresent: TcxGridDBColumn
            Caption = #1055#1086#1076#1072#1088#1086#1082
            DataBinding.FieldName = 'isPresent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1072#1088#1086#1082'. '#1041#1083#1086#1082#1080#1088#1091#1077#1090#1100#1089#1103' '#1087#1088#1086#1076#1072#1078#1072' '#1085#1072' '#1082#1072#1089#1089#1072#1093
            Options.Editing = False
            Width = 61
          end
          object SummaWages: TcxGridDBColumn
            Caption = #1047#1072' 1 '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1047#1055
            DataBinding.FieldName = 'SummaWages'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091
            Options.Editing = False
            Width = 76
          end
          object PercentWages: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1047#1055
            DataBinding.FieldName = 'PercentWages'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091
            Options.Editing = False
            Width = 80
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
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 255
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
    object InsertRecord1: TInsertRecord [26]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Params = <>
      Caption = 'InsertRecord1'
    end
    object macUpdateNot_v2_No: TMultiAction [27]
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
    object actSimpleUpdateNot_v2_No: TMultiAction [28]
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
    object actUpdate_isSun_v2_No: TdsdExecStoredProc [29]
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
    object macSimpleUpdateNDS: TMultiAction [33]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNDS
        end>
      View = cxGridDBTableView
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
    end
    object mactAfterInsert: TMultiAction [34]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = InsertRecord1
        end
        item
          Action = spRefreshOnInsert
        end
        item
          Action = DataSetPost1
        end>
      Caption = 'mactAfterInsert'
    end
    object macUpdateNDS: TMultiAction [35]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macSimpleUpdateNDS
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072'? '
      InfoAfterExecute = #1053#1044#1057' '#1086#1073#1085#1086#1074#1083#1077#1085#1086' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      ImageIndex = 76
    end
    object actUpdateNDS: TdsdExecStoredProc [36]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_NDS
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_NDS
        end>
      Caption = 'actUpdateNDS'
    end
    object macUpdateNot_Yes: TMultiAction [37]
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
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
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
    object DataSetInsert1: TDataSetInsert
      Category = 'Dataset'
      Caption = '&Insert'
      Hint = 'Insert'
      ImageIndex = 73
      DataSource = MasterDS
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
    object DataSetPost1: TDataSetPost
      Category = 'Dataset'
      Caption = 'P&ost'
      Hint = 'Post'
      ImageIndex = 74
      DataSource = MasterDS
    end
    object spRefreshOnInsert: TdsdExecStoredProc
      Category = 'Refresh'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetOnInsert
      StoredProcList = <
        item
          StoredProc = spGetOnInsert
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
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_isFirst
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_isFirst
        end
        item
          StoredProc = spUpdate_Goods_isSecond
        end
        item
          StoredProc = spUpdate_Goods_isNotUploadSites
        end
        item
          StoredProc = spUpdate_Goods_DoesNotShare
        end
        item
          StoredProc = spUpdate_Goods_AllowDivision
        end
        item
          StoredProc = spUpdate_Goods_Analog
        end
        item
          StoredProc = spUpdate_Goods_isNot
        end
        item
          StoredProc = spUpdate_inResolution_224
        end
        item
          StoredProc = spUpdate_isInvisibleSUN
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
    object actPublished: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_Published
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_Published
        end>
      Caption = 'actPublished'
    end
    object actSimplePublishedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPublished
        end>
      View = cxGridDBTableView
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
    end
    object macUpdateNotMarion_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdateNotMarion_No
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058
      ImageIndex = 77
    end
    object macUpdateNotMarion_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUpdateNotMarion_Yes
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072
      ImageIndex = 76
    end
    object actUpdateNotMarion_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateNotMarion_No
      StoredProcList = <
        item
          StoredProc = spUpdateNotMarion_No
        end>
      Caption = 'actUpdateNotMarion_Yes'
    end
    object actUpdateNotMarion_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateNotMarion_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateNotMarion_Yes
        end>
      Caption = 'actUpdateNotMarion_Yes'
    end
    object actSimpleUpdateNotMarion_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNotMarion_No
        end>
      View = cxGridDBTableView
      Caption = #1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085
      Hint = #1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085
    end
    object actSimpleUpdateNotMarion_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNotMarion_Yes
        end>
      View = cxGridDBTableView
      Caption = #1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085
      Hint = #1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085
    end
    object actPublishedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimplePublishedList
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      ImageIndex = 58
    end
    object actUpdate_CountPrice: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CountPrice
      StoredProcList = <
        item
          StoredProc = spUpdate_CountPrice
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
      QuestionBeforeExecute = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1074'-'#1074#1086' '#1050#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1089#1077#1090#1103#1084'?'
      InfoAfterExecute = #1050#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074' '#1086#1073#1085#1086#1074#1083#1077#1085#1086
    end
    object actGetImportSetting_Goods_Price: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_Goods_Price
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_Goods_Price
        end>
      Caption = 'actGetImportSetting_Goods_Price'
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
    object actStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Goods_Price
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1094#1077#1085' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1062#1077#1085#1099' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1062#1077#1085#1099
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1062#1077#1085#1099
      ImageIndex = 41
    end
    object actSetClose: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = maSetClose
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"? '
      InfoAfterExecute = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      ImageIndex = 79
    end
    object maSetClose: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isClose_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = 'maSetClose'
    end
    object actUpdate_isClose_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isClose_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isClose_Yes
        end>
      Caption = 'actUpdate_isClose_Yes'
    end
    object actClearClose: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = maClearClose
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"? '
      InfoAfterExecute = #1057#1085#1103#1090' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      ImageIndex = 58
    end
    object maClearClose: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isClose_No
        end>
      View = cxGridDBTableView
      Caption = #1057#1085#1103#1090#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = 'maClearClose'
    end
    object actUpdate_isClose_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isClose_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isClose_No
        end>
      Caption = 'actUpdate_isClose_No'
    end
    object actisResolution_224_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mainResolution_224_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"? '
      InfoAfterExecute = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      ImageIndex = 79
    end
    object mainResolution_224_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_inResolution_224_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = 'maSetClose'
    end
    object actUpdate_inResolution_224_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inResolution_224_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_inResolution_224_Yes
        end>
      Caption = 'actUpdate_inResolution_224_Yes'
    end
    object actinResolution_224_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mainResolution_224_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"? '
      InfoAfterExecute = #1057#1085#1103#1090' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      ImageIndex = 58
    end
    object mainResolution_224_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_inResolution_224_No
        end>
      View = cxGridDBTableView
      Caption = #1057#1085#1103#1090#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = 'maClearClose'
    end
    object actUpdate_inResolution_224_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inResolution_224_No
      StoredProcList = <
        item
          StoredProc = spUpdate_inResolution_224_No
        end>
      Caption = 'actUpdate_inResolution_224_No'
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
    object actUpdate_inTop_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGoodsTopDialog
        end
        item
          Action = maUpdate_inTop_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"? '
      InfoAfterExecute = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      ImageIndex = 79
    end
    object maUpdate_inTop_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecUpdate_inTop_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = 'maSetClose'
    end
    object actExecUpdate_inTop_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_inTop_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_inTop_Yes
        end>
      Caption = 'actUpdate_inResolution_224_Yes'
    end
    object actUpdate_inTop_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = maUpdate_inTop_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"? '
      InfoAfterExecute = #1057#1085#1103#1090' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      ImageIndex = 58
    end
    object maUpdate_inTop_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecUpdate_inTop_No
        end>
      View = cxGridDBTableView
      Caption = #1057#1085#1103#1090#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = 'maClearClose'
    end
    object actExecUpdate_inTop_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_inTop_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_inTop_No
        end>
      Caption = 'actUpdate_inResolution_224_No'
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
    object actUpdateExceptionUKTZED: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = execUpdate_ExceptionUKTZED
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      ImageIndex = 79
    end
    object execUpdate_ExceptionUKTZED: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inExceptionUKTZED_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_inExceptionUKTZED_Revert
        end>
      Caption = 'execUpdate_ExceptionUKTZED'
    end
    object actUpdate_inPresent_Revert: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = execUpdate_inPresent_Revert
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      ImageIndex = 79
    end
    object execUpdate_inPresent_Revert: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inPresent_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_inPresent_Revert
        end>
      Caption = 'execUpdate_inPresent_Revert'
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
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091'"'
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
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091'"'
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
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 24
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Retail'
    Params = <
      item
        Name = 'inContractId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
          ItemName = 'bbUpdate_GoodsPairSun'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_CountPrice'
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
      Action = actPublishedList
      Category = 0
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
      Action = macUpdateNDS
      Category = 0
    end
    object bbUpdate_CountPrice: TdxBarButton
      Action = actUpdate_CountPrice
      Category = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1089#1077#1090#1103#1084
      Style = dmMain.cxContentStyle
      PaintStyle = psCaption
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbUpdateNotMarion_Yes: TdxBarButton
      Action = macUpdateNotMarion_Yes
      Category = 0
    end
    object bbUpdateNotMarion_No: TdxBarButton
      Action = macUpdateNotMarion_No
      Category = 0
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
      Action = actSetClose
      Category = 0
    end
    object bbClearClose: TdxBarButton
      Action = actClearClose
      Category = 0
    end
    object bbinResolution_224_No: TdxBarButton
      Action = actinResolution_224_No
      Category = 0
    end
    object bbisResolution_224_Yes: TdxBarButton
      Action = actisResolution_224_Yes
      Category = 0
    end
    object bbUpdate_inTop_Yes: TdxBarButton
      Action = actUpdate_inTop_Yes
      Category = 0
    end
    object bbUpdate_inTop_No: TdxBarButton
      Action = actUpdate_inTop_No
      Category = 0
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
      Action = actUpdateExceptionUKTZED
      Category = 0
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
          ItemName = 'bbUpdateExceptionUKTZED'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inPresent_Revert'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
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
      Action = actUpdateExceptionUKTZED
      Category = 0
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateNotMarion_Yes'
        end
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
          ItemName = 'bbSetClose'
        end
        item
          Visible = True
          ItemName = 'bbisResolution_224_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inTop_Yes'
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
          ItemName = 'bbUpdateNotMarion_No'
        end
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
          ItemName = 'bbClearClose'
        end
        item
          Visible = True
          ItemName = 'bbinResolution_224_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inTop_No'
        end>
    end
    object dxBarSubItem4: TdxBarSubItem
      Action = actUpdate_inPresent_Revert
      Category = 0
      ItemLinks = <>
    end
    object bbUpdate_inPresent_Revert: TdxBarButton
      Action = actUpdate_inPresent_Revert
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actUpdate_SummaWages
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdate_PercentWages
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
        ColorColumn = PercentMarkup
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
        ColorColumn = MinimumLot
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
        ColorColumn = Price
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
        ColorColumn = isPublished
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
      end
      item
        ColorColumn = ConditionsKeepName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
    SearchAsFilter = False
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 256
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MeasureId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'NdsKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'NDSKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinimumLot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinimumLot'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isClose'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTop'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTop'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MorionCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MorionCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BarCode'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 144
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
        Value = 0c
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = 0c
        DataType = ftFloat
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
        Name = 'SummaWages'
        Value = 0c
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelSummaWages'
        Value = #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentWages'
        Value = 0c
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPercentWages'
        Value = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 64
  end
  object spGetOnInsert: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
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
        Name = 'Name'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NdsKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NDSKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MorionCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MorionCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BarCode'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 208
  end
  object spUpdate_Goods_MinimumLot: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_MinimumLot'
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
        Name = 'inMinimumLot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinimumLot'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 288
  end
  object spUpdate_Goods_isFirst: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isFirst'
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
        Name = 'inisFirst'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isFirst'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outColor'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Color_calc'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 176
  end
  object spUpdate_Goods_isSecond: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isSecond'
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
        Name = 'inisSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSecond'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outColor'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Color_calc'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 248
  end
  object spUpdate_Goods_Published: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Published'
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
        Name = 'outisPublished'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPublished'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 107
  end
  object spUpdate_Goods_LastPriceOld: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_LastPriceOld'
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
        Name = 'inLastPriceDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'LastPriceDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLastPriceOldDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'LastPriceOldDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountDays'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountDays'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 176
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 440
    Top = 88
  end
  object spUpdate_Goods_NDS: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_NDS'
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
        Name = 'inNDS'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NDS'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNDS_PriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NDS_PriceList'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 808
    Top = 200
  end
  object spUpdate_CountPrice: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_CountPrice'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 840
    Top = 104
  end
  object spUpdate_Goods_isNotUploadSites: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNotUploadSites'
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
        Name = 'inisNotUploadSites'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotUploadSites'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotUploadSites'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotUploadSites'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 312
  end
  object spUpdate_Goods_DoesNotShare: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_DoesNotShare'
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
        Name = 'inDoesNotShare'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DoesNotShare'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDoesNotShare'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DoesNotShare'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 264
  end
  object spGetImportSetting_Goods_Price: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsForm;zc_Object_ImportSetting_Goods_Price'
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
    Left = 360
    Top = 128
  end
  object spUpdate_Goods_AllowDivision: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_AllowDivision'
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
        Name = 'ioAllowDivision'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AllowDivision'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 328
  end
  object spUpdate_Goods_Analog: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Analog'
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
        Name = 'ioAnalog'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsAnalog'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAnalogATC'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsAnalogATC'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioActiveSubstance'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsActiveSubstance'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 336
  end
  object spUpdateNotMarion_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_NotMarion'
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
        Name = 'inisNotMarion'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotMarion'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotMarion'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 83
  end
  object spUpdateNotMarion_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_NotMarion'
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
        Name = 'inisNotMarion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotMarion'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotMarion'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 107
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
    Left = 928
    Top = 99
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
    Left = 928
    Top = 163
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
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'isNot'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 227
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
    Left = 1024
    Top = 83
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
    Left = 1024
    Top = 131
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
    Left = 992
    Top = 291
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
    Left = 984
    Top = 227
  end
  object spUpdate_isClose_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isClose'
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
        Name = 'inisClose'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 904
    Top = 331
  end
  object spUpdate_isClose_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isClose'
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
        Name = 'inisClose'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 808
    Top = 331
  end
  object spUpdate_inResolution_224: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inResolution_224'
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
        Name = 'ioisResolution_224'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isResolution_224'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 296
  end
  object spUpdate_inResolution_224_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inResolution_224'
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
        Name = 'ioisResolution_224'
        Value = True
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 184
  end
  object spUpdate_inResolution_224_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inResolution_224'
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
        Name = 'ioisResolution_224'
        Value = False
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 232
  end
  object spUpdate_Goods_inTop_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inTop'
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
        Name = 'inisTop'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentMarkup'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 248
  end
  object spUpdate_Goods_inTop_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inTop'
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
        Name = 'inisTop'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentMarkup'
        Value = Null
        Component = FormParams
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = FormParams
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 192
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
    Left = 1080
    Top = 211
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
    Left = 1088
    Top = 155
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
      end>
    PackSize = 1
    Left = 1080
    Top = 315
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
    Left = 80
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
    Left = 216
    Top = 352
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
    Left = 1096
    Top = 267
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
      end>
    PackSize = 1
    Left = 408
    Top = 344
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
    Left = 664
    Top = 368
  end
  object spUpdate_inExceptionUKTZED_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inExceptionUKTZED_Revert'
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
        Name = 'inisExceptionUKTZED'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isExceptionUKTZED'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 376
  end
  object spUpdate_inPresent_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inPresent_Revert'
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
        Name = 'inisPresent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPresent'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 376
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
    Left = 712
    Top = 216
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
    Left = 712
    Top = 264
  end
end
