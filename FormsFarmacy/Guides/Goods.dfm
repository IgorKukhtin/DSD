inherited GoodsForm: TGoodsForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1089#1077#1090#1080
  ClientHeight = 544
  ClientWidth = 1165
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1181
  ExplicitHeight = 583
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1165
    Height = 518
    ExplicitWidth = 1165
    ExplicitHeight = 417
    ClientRectBottom = 518
    ClientRectRight = 1165
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1165
      ExplicitHeight = 417
      inherited cxGrid: TcxGrid
        Width = 1165
        Height = 518
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
            Caption = #1053#1077' '#1076#1077#1083#1080#1090#1100' '#1085#1072' '#1082#1072#1089#1089#1072#1093
            DataBinding.FieldName = 'AllowDivision'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1076#1077#1083#1080#1090#1100' '#1085#1072' '#1082#1072#1089#1089#1072#1093
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
          object Multiplicity: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080' ('#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1076#1077#1083#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'Multiplicity'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isMultiplicityError: TcxGridDBColumn
            Caption = #1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'isMultiplicityError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object isUkrainianTranslation: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1074#1086#1076' '#1085#1072' '#1091#1082#1088' '#1103#1079#1099#1082
            DataBinding.FieldName = 'isUkrainianTranslation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object FormDispensingName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'FormDispensingName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object NumberPlates: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1089#1090#1080#1085' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'NumberPlates'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object QtyPackage: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'QtyPackage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object isRecipe: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
            DataBinding.FieldName = 'isRecipe'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object isExpDateExcSite: TcxGridDBColumn
            Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')'
            DataBinding.FieldName = 'isExpDateExcSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object isHideOnTheSite: TcxGridDBColumn
            Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1085#1072' '#1089#1072#1081#1090#1077' '#1085#1077#1090' '#1085#1072#1083#1080#1095#1080#1103' '#1080' '#1087#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'isHideOnTheSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1088#1099#1074#1072#1090#1100' '#1085#1072' '#1089#1072#1081#1090#1077' '#1085#1077#1090' '#1074' '#1085#1072#1083#1080#1095#1080#1080' '#1080' '#1074' '#1087#1086#1089#1090#1072#1074#1082#1072#1093
            Options.Editing = False
            Width = 78
          end
          object DiscontSiteStart: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1086' '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'DiscontSiteStart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object DiscontSiteEnd: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'DiscontSiteEnd'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object DiscontAmountSite: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'DiscontAmountSite'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object DiscontPercentSite: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'DiscontPercentSite'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
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
    object actUpdate_Goods_LimitSun: TdsdDataSetRefresh [0]
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
    object ExecuteDialogGoods_LimitSum: TExecuteDialog [2]
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
    object macUpdateGoods_LimitSUN_list: TMultiAction [4]
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
    object macUpdate_isNot_Sun_v4_yes: TMultiAction [5]
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
    object macUpdateGoods_LimitSUN: TMultiAction [6]
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
    object actSimpleUpdateNot_v4_yes: TMultiAction [7]
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
    object actUpdate_isNot_Sun_v4_Yes: TdsdExecStoredProc [8]
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
    object macUpdateNot_v2_Yes: TMultiAction [9]
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
    object actSimpleUpdateNot_v2_Yes: TMultiAction [10]
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
    object actUpdate_isNOT_v2_Yes: TdsdExecStoredProc [11]
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
    object macUpdate_isNot_Sun_v4_No: TMultiAction [12]
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
    object actSimpleUpdateNot_v4_No: TMultiAction [13]
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
    object actUpdate_isNot_Sun_v4_No: TdsdExecStoredProc [14]
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
    object macUpdate_isSun_v3_yes: TMultiAction [15]
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
    object actSimpleUpdate_isSUN_v3_yes: TMultiAction [16]
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
    object actUpdate_isSun_v3_yes: TdsdExecStoredProc [17]
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
    object macUpdate_isSun_v3_No: TMultiAction [18]
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
    object actSimpleUpdate_isSUN_v3_No: TMultiAction [19]
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
    object actUpdate_isSun_v3_No: TdsdExecStoredProc [20]
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
    object InsertRecord1: TInsertRecord [23]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Params = <>
      Caption = 'InsertRecord1'
    end
    object macUpdateNot_v2_No: TMultiAction [24]
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
    object actSimpleUpdateNot_v2_No: TMultiAction [25]
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
    object actUpdate_isSun_v2_No: TdsdExecStoredProc [26]
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
    object macSimpleUpdateNDS: TMultiAction [30]
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
    object mactAfterInsert: TMultiAction [31]
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
    object macUpdateNDS: TMultiAction [32]
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
    object actUpdateNDS: TdsdExecStoredProc [33]
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
    object macUpdateNot_Yes: TMultiAction [34]
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
          StoredProc = spUpdate_inResolution_224
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
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
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
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"?'
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
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
    object maUpdate_isOnlySP: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isOnlySP
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
      ImageIndex = 79
    end
    object actExecUpdate_isOnlySP: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isOnlySP_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_isOnlySP_Revert
        end>
      Caption = 'actExecClearUnitSupplementSUN1Out'
    end
    object actUpdate_Multiplicity: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = astExecuteDialogMultiplicity
      ActionList = <
        item
          Action = actExecUpfdate_Multiplicity
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      ImageIndex = 43
    end
    object actExecUpfdate_Multiplicity: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Multiplicity
      StoredProcList = <
        item
          StoredProc = spUpdate_Multiplicity
        end>
      Caption = 'actExecUpfdate_Multiplicity'
    end
    object astExecuteDialogMultiplicity: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogUpdate_PercentWagesStore'
      FormName = 'TAmountDialogForm'
      FormNameParam.Value = 'TAmountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Amount'
          Value = Null
          Component = FormParams
          ComponentItem = 'Multiplicity'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = 
            #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082 +
            #1083#1072#1076#1086#1074#1097#1080#1082#1072
          Component = FormParams
          ComponentItem = 'MultiplicityLabel'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object maUpdate_isMultiplicityError: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isMultiplicityError
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      ImageIndex = 79
    end
    object actExecUpdate_isMultiplicityError: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMultiplicityError_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_isMultiplicityError_Revert
        end>
      Caption = 'actExecUpdate_isMultiplicityError'
    end
    object actDialogPercentMarkup: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDialogPercentMarkup'
      FormName = 'TAmountDialogForm'
      FormNameParam.Value = 'TAmountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Amount'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PercentMarkup'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1080#1076#1072#1078#1077'"'
          Component = FormParams
          ComponentItem = 'PercentMarkupLabel'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macPercentMarkup: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actDialogPercentMarkup
      ActionList = <
        item
          Action = actStoredProcPercentMarkup
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "% '#1085#1072#1094#1077#1085#1082#1080'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "% '#1085#1072#1094#1077#1085#1082#1080'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 43
    end
    object actStoredProcPercentMarkup: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePercentMarkup
      StoredProcList = <
        item
          StoredProc = spUpdatePercentMarkup
        end>
      Caption = 'actStoredProcPercentMarkup'
    end
    object actUpdateAdditional: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'>'
      ShortCut = 16499
      ImageIndex = 43
      FormName = 'TGoodsAdditionalEditForm'
      FormNameParam.Value = 'TGoodsAdditionalEditForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = spRefreshOneRecord
      IdFieldName = 'Id'
    end
    object ProtocolOpenMainForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
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
          ComponentItem = 'GoodsMainId'
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
    object actUpdateGoodsAdditional: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGoodsAdditional
      StoredProcList = <
        item
          StoredProc = spUpdateGoodsAdditional
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
    end
    object actDialogGoodsAdditional: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_MakerName'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_FormDispensing'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_NumberPlates'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_QtyPackage'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_IsRecipe'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      Caption = 'actDialogGoodsAdditional'
      FormName = 'TGoodsAdditionalEditDialogForm'
      FormNameParam.Value = 'TGoodsAdditionalEditDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MakerName'
          Value = ''
          Component = FormParams
          ComponentItem = 'MakerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FormDispensingId'
          Value = Null
          Component = FormParams
          ComponentItem = 'FormDispensingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'NumberPlates'
          Value = Null
          Component = FormParams
          ComponentItem = 'NumberPlates'
          MultiSelectSeparator = ','
        end
        item
          Name = 'QtyPackage'
          Value = Null
          Component = FormParams
          ComponentItem = 'QtyPackage'
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsRecipe'
          Value = Null
          Component = FormParams
          ComponentItem = 'IsRecipe'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_MakerName'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_MakerName'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_FormDispensing'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_FormDispensing'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_NumberPlates'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_NumberPlates'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_QtyPackage'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_QtyPackage'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_IsRecipe'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_IsRecipe'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object mactUpdateGoodsAdditional: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actDialogGoodsAdditional
      ActionList = <
        item
          Action = actUpdateGoodsAdditional
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 43
    end
    object mactUpdate_isExpDateExcSite: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isExpDateExcSite
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')"'
      ImageIndex = 79
    end
    object actExecUpdate_isExpDateExcSite: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inExpDateExcSite_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_inExpDateExcSite_Revert
        end>
      Caption = 'actExecUpdate_isExpDateExcSite'
    end
    object actSiteDiscontDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSiteDiscontDialog'
      FormName = 'TSiteDiscontDialogForm'
      FormNameParam.Value = 'TSiteDiscontDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'DiscontSiteStart'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscontSiteStart'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscontSiteEnd'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscontSiteEnd'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscontPercentSite'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscontPercentSite'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscontAmountSite'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscontAmountSite'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_SiteDiscont: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SiteDiscont
      StoredProcList = <
        item
          StoredProc = spUpdate_SiteDiscont
        end>
      Caption = 'actUpdate_SiteDiscont'
    end
    object mactSiteDiscont: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actSiteDiscontDialog
      ActionList = <
        item
          Action = actUpdate_SiteDiscont
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      ImageIndex = 43
    end
    object actUpdate_isFirst_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isFirst_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isFirst_Yes
        end>
      Caption = 'ExecUpdate_isInvisibleSUN'
    end
    object mactUpdate_isFirst_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_isFirst_Yes
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      ImageIndex = 79
    end
    object actUpdate_isFirst_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isFirst_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isFirst_No
        end>
      Caption = 'ExecUpdate_isInvisibleSUN'
    end
    object mactUpdate_isFirst_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_isFirst_No
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      ImageIndex = 77
    end
    object actUpdate_isSecond_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSecond_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isSecond_Yes
        end>
      Caption = 'ExecUpdate_isInvisibleSUN'
    end
    object mactUpdate_isSecond_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_isSecond_Yes
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      ImageIndex = 79
    end
    object actUpdate_isSecond_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSecond_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isSecond_No
        end>
      Caption = 'ExecUpdate_isInvisibleSUN'
    end
    object mactUpdate_isSecond_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_isSecond_No
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      ImageIndex = 77
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
          ItemName = 'bbUpdateAdditional'
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
          ItemName = 'dxBarButton14'
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
          ItemName = 'bbUpdateExceptionUKTZED'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inPresent_Revert'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'dxBarButton16'
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
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarButton13'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end
        item
          Visible = True
          ItemName = 'dxBarButton17'
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
          ItemName = 'bbSetClose'
        end
        item
          Visible = True
          ItemName = 'bbisResolution_224_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inTop_Yes'
        end
        item
          Visible = True
          ItemName = 'bbtUpdate_isFirst_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSecond_Yes'
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
          ItemName = 'bbClearClose'
        end
        item
          Visible = True
          ItemName = 'bbinResolution_224_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inTop_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isFirst_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSecond_No'
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
      Action = maUpdate_isOnlySP
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actUpdate_Multiplicity
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = maUpdate_isMultiplicityError
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Action = macPercentMarkup
      Category = 0
    end
    object bbUpdateAdditional: TdxBarButton
      Action = actUpdateAdditional
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = ProtocolOpenMainForm
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = mactUpdateGoodsAdditional
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Action = mactUpdate_isExpDateExcSite
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = mactSiteDiscont
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object bbtUpdate_isFirst_Yes: TdxBarButton
      Action = mactUpdate_isFirst_Yes
      Category = 0
    end
    object bbUpdate_isSecond_Yes: TdxBarButton
      Action = mactUpdate_isSecond_Yes
      Category = 0
    end
    object bbUpdate_isFirst_No: TdxBarButton
      Action = mactUpdate_isFirst_No
      Category = 0
    end
    object bbUpdate_isSecond_No: TdxBarButton
      Action = mactUpdate_isSecond_No
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
      end
      item
        Name = 'MakerName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MakerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FormDispensingId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FormDispensingName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NumberPlates'
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'QtyPackage'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRecipe'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isRecipe'
        DataType = ftBoolean
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
        Name = 'MakerName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = '0'
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsRecipe'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontSiteStart'
        Value = '01.01.2016'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontSiteEnd'
        Value = '01.01.2016'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontPercentSite'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontAmountSite'
        Value = Null
        DataType = ftFloat
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
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LastPriceDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLastPriceOldDate'
        Value = Null
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
    Top = 144
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
    Top = 320
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
        Value = Null
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
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = 0.000000000000000000
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
    Left = 64
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
    Top = 344
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
    Left = 360
    Top = 96
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
    Left = 736
    Top = 352
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
    Left = 736
    Top = 304
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
    Left = 216
    Top = 376
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
    Left = 344
    Top = 376
  end
  object spUpdate_isOnlySP_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isOnlySP_Revert'
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
        Name = 'inisOnlySP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOnlySP'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 368
  end
  object spUpdate_Multiplicity: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Multiplicity'
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
        Name = 'inMultiplicity'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'Multiplicity'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 144
  end
  object spUpdate_isMultiplicityError_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isMultiplicityError_Revert'
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
        Name = 'inisMultiplicityError'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMultiplicityError'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 216
  end
  object spUpdatePercentMarkup: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_PercentMarkup'
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
        Name = 'inPercentMarkup'
        Value = Null
        Component = FormParams
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 155
  end
  object spUpdateGoodsAdditional: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsAdditionalFilter'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerName'
        Value = ''
        Component = FormParams
        ComponentItem = 'MakerName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_MakerName'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFormDispensingId'
        Value = ''
        Component = FormParams
        ComponentItem = 'FormDispensingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_FormDispensing'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumberPlates'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'NumberPlates'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_NumberPlates'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQtyPackage'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'QtyPackage'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_QtyPackage'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRecipe'
        Value = False
        Component = FormParams
        ComponentItem = 'IsRecipe'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_IsRecipe'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 200
  end
  object spUpdate_inExpDateExcSite_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inExpDateExcSite_Revert'
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
        Name = 'inisExpDateExcSite'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isExpDateExcSite'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 368
  end
  object spUpdate_SiteDiscont: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_SiteDiscont'
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
        Name = 'inDiscontSiteStart'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscontSiteStart'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscontSiteEnd'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscontSiteEnd'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscontPercentSite'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscontPercentSite'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscontAmountSite'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscontAmountSite'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 376
  end
  object spUpdate_isFirst_No: TdsdStoredProc
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 435
  end
  object spUpdate_isFirst_Yes: TdsdStoredProc
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 435
  end
  object spUpdate_isSecond_No: TdsdStoredProc
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 435
  end
  object spUpdate_isSecond_Yes: TdsdStoredProc
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 435
  end
end
