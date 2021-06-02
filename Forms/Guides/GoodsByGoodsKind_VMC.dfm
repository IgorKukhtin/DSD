inherited GoodsByGoodsKind_VMCForm: TGoodsByGoodsKind_VMCForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1058#1086#1074#1072#1088' '#1080' '#1042#1080#1076' '#1090#1086#1074#1072#1088#1072'> ('#1042#1052#1057')'
  ClientHeight = 598
  ClientWidth = 1039
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1055
  ExplicitHeight = 636
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 56
    Width = 1039
    Height = 542
    ExplicitTop = 56
    ExplicitWidth = 1039
    ExplicitHeight = 542
    ClientRectBottom = 542
    ClientRectRight = 1039
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1039
      ExplicitHeight = 542
      inherited cxGrid: TcxGrid
        Width = 1039
        Height = 542
        ExplicitWidth = 1039
        ExplicitHeight = 542
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsData.Appending = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsPlatformName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
            DataBinding.FieldName = 'GoodsPlatformName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupAnalystName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
            DataBinding.FieldName = 'GoodsGroupAnalystName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 106
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 160
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 172
          end
          object isGoodsTypeKind_Sh: TcxGridDBColumn
            Caption = #1064#1090#1091#1095#1085'.'
            DataBinding.FieldName = 'isGoodsTypeKind_Sh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1064#1090#1091#1095#1085#1099#1081'"'
            Width = 55
          end
          object isGoodsTypeKind_Nom: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083
            DataBinding.FieldName = 'isGoodsTypeKind_Nom'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081'"'
            Width = 60
          end
          object isGoodsTypeKind_Ves: TcxGridDBColumn
            Caption = #1053#1077#1085#1086#1084#1080#1085'.'
            DataBinding.FieldName = 'isGoodsTypeKind_Ves'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081'"'
            Width = 63
          end
          object WmsCellNum: TcxGridDBColumn
            Caption = #8470' '#1071#1095#1077#1081#1082#1080' '#1085#1072' '#1089#1082#1083#1072#1076#1077' '#1042#1052#1057
            DataBinding.FieldName = 'WmsCellNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object NormInDays: TcxGridDBColumn
            Caption = 'C'#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080', '#1076#1085'.'
            DataBinding.FieldName = 'NormInDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1074' '#1076#1085#1103#1093
            Width = 70
          end
          object WmsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1042#1052#1057'*'
            DataBinding.FieldName = 'WmsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1050#1086#1076' SKU '#1074' '#1042#1052#1057
            Options.Editing = False
            Width = 70
          end
          object WmsCodeCalc_Sh: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1042#1052#1057'* '#1096#1090'.'
            DataBinding.FieldName = 'WmsCodeCalc_Sh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' SKU '#1096#1090'. ('#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074' '#1042#1052#1057')'
            Options.Editing = False
            Width = 70
          end
          object WmsCodeCalc_Nom: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1042#1052#1057'* '#1085#1086#1084#1080#1085#1072#1083
            DataBinding.FieldName = 'WmsCodeCalc_Nom'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' SKU '#1085#1086#1084#1080#1085#1072#1083' ('#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074' '#1042#1052#1057')'
            Options.Editing = False
            Width = 70
          end
          object WmsCodeCalc_Ves: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1042#1052#1057'* '#1085#1077#1085#1086#1084#1080#1085#1072#1083
            DataBinding.FieldName = 'WmsCodeCalc_Ves'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' SKU '#1085#1077#1085#1086#1084#1080#1085#1072#1083' ('#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074' '#1042#1052#1057')'
            Options.Editing = False
            Width = 83
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1058#1086#1074#1072#1088')'
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object GoodsCode_basis: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1094#1077#1093')'
            DataBinding.FieldName = 'GoodsCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_basis: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1094#1077#1093')'
            DataBinding.FieldName = 'GoodsName_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_main: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsCode_main'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_main: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsName_main'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_Sh: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1080#1079' '#1082#1072#1090'. "'#1064#1090#1091#1095#1085#1099#1081'")'
            DataBinding.FieldName = 'GoodsCode_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1080#1079' '#1082#1072#1090'. "'#1064#1090#1091#1095#1085#1099#1081'")'
            Options.Editing = False
            Width = 82
          end
          object GoodsName_Sh: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1080#1079' '#1082#1072#1090'. "'#1064#1090#1091#1095#1085#1099#1081'")'
            DataBinding.FieldName = 'GoodsName_Sh'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoods_shOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' ('#1080#1079' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' "'#1064#1090#1091#1095#1085#1099#1081'")'
            Width = 85
          end
          object GoodsKindName_Sh: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1080#1079' '#1082#1072#1090'. "'#1064#1090#1091#1095#1085#1099#1081'")'
            DataBinding.FieldName = 'GoodsKindName_Sh'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKind_shOpenForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1080#1079' '#1082#1072#1090'. "'#1064#1090#1091#1095#1085#1099#1081'")'
            Width = 85
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1090#1086#1074'.'
            DataBinding.FieldName = 'Weight'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' '#1042#1077#1089' '#1090#1086#1074#1072#1088#1072' - '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1074#1072#1088#1086#1074
            Options.Editing = False
            Width = 45
          end
          object WeightPackage: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1072#1082'. '#1076#1083#1103' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightPackage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' 1-'#1086#1075#1086' '#1087#1072#1082#1077#1090#1072' '#1076#1083#1103' '#1059#1055#1040#1050#1054#1042#1050#1048
            Options.Editing = False
            Width = 50
          end
          object WeightPackageSticker: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1072#1082'. '#1076#1083#1103' '#1069#1058'.'
            DataBinding.FieldName = 'WeightPackageSticker'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' 1-'#1086#1075#1086' '#1087#1072#1082#1077#1090#1072' '#1076#1083#1103' '#1087#1077#1095'. '#1069#1058#1048#1050#1045#1058#1050#1048
            Options.Editing = False
            Width = 54
          end
          object WeightTotal: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086' - '#1074#1077#1089' '#1073#1088#1091#1090#1090#1086' - '#1088#1072#1089#1095#1077#1090' '#1082#1086#1083'-'#1074#1086' '#1096#1090'. '#1091#1087#1072#1082#1086#1074#1086#1082
            Options.Editing = False
            Width = 60
          end
          object WeightMin_Sh: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1074#1077#1089' 1 '#1077#1076'. '#1064#1090'.'
            DataBinding.FieldName = 'WeightMin_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            Width = 70
          end
          object WeightMax_Sh: TcxGridDBColumn
            Caption = #1052#1072#1093'. '#1074#1077#1089' 1 '#1077#1076'. '#1064#1090'.'
            DataBinding.FieldName = 'WeightMax_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            Width = 70
          end
          object WeightMin_Nom: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1074#1077#1089' 1 '#1077#1076'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightMin_Nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMax_Nom: TcxGridDBColumn
            Caption = #1052#1072#1093'. '#1074#1077#1089' 1 '#1077#1076'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightMax_Nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMin_Ves: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1074#1077#1089' 1 '#1077#1076'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightMin_Ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMax_Ves: TcxGridDBColumn
            Caption = #1052#1072#1093'. '#1074#1077#1089' 1 '#1077#1076'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightMax_Ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightAvg_Sh: TcxGridDBColumn
            Caption = 'C'#1088'. '#1074#1077#1089' 1 '#1077#1076'.  '#1064#1090'.'
            DataBinding.FieldName = 'WeightAvg_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1089#1088#1077#1076#1085#1080#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Width = 70
          end
          object WeightAvg_Nom: TcxGridDBColumn
            Caption = 'C'#1088'. '#1074#1077#1089' 1 '#1077#1076'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightAvg_Nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1089#1088#1077#1076#1085#1080#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Width = 70
          end
          object WeightAvg_Ves: TcxGridDBColumn
            Caption = 'C'#1088'. '#1074#1077#1089' 1 '#1077#1076'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightAvg_Ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1089#1088#1077#1076#1085#1080#1081' '#1074#1077#1089' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Width = 70
          end
          object isOrder: TcxGridDBColumn
            Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' '#1079#1072#1103#1074#1082#1072#1093
            DataBinding.FieldName = 'isOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isScaleCeh: TcxGridDBColumn
            Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' ScaleCeh'
            DataBinding.FieldName = 'isScaleCeh'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object isNotMobile: TcxGridDBColumn
            Caption = #1053#1045' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074' '#1052#1086#1073#1080#1083#1100#1085#1086#1084' '#1072#1075#1077#1085#1090#1077
            DataBinding.FieldName = 'isNotMobile'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object Tax_Sh: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083'. '#1064#1090'.'
            DataBinding.FieldName = 'Tax_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1064#1090'.'
            Width = 55
          end
          object Tax_Nom: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'Tax_Nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1053#1086#1084#1080#1085#1072#1083
            Width = 55
          end
          object Tax_Ves: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'Tax_Ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Width = 55
          end
          object Height: TcxGridDBColumn
            Caption = #1042#1099#1089#1086#1090#1072
            DataBinding.FieldName = 'Height'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1042#1099#1089#1086#1090#1072' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1090#1086#1074#1072#1088#1072
            Width = 55
          end
          object Length: TcxGridDBColumn
            Caption = #1044#1083#1080#1085#1072
            DataBinding.FieldName = 'Length'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1044#1083#1080#1085#1072' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1090#1086#1074#1072#1088#1072
            Width = 55
          end
          object Width: TcxGridDBColumn
            Caption = #1064#1080#1088#1080#1085#1072
            DataBinding.FieldName = 'Width'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1052#1057' - '#1064#1080#1088#1080#1085#1072' '#1086#1076#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099' '#1090#1086#1074#1072#1088#1072
            Width = 55
          end
          object GoodsBrandName: TcxGridDBColumn
            Caption = #1041#1088#1077#1085#1076
            DataBinding.FieldName = 'GoodsBrandName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1088#1077#1085#1076' '#1090#1086#1074#1072#1088#1072' '#1076#1083#1103' '#1042#1052#1057
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
            Width = 95
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object BoxCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1103#1097#1080#1082#1072' (E2/E3)'
            DataBinding.FieldName = 'BoxCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object BoxName: TcxGridDBColumn
            Caption = #1071#1097#1080#1082' (E2/E3)'
            DataBinding.FieldName = 'BoxName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = BoxChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountOnBox: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'. (E2/E3)'
            DataBinding.FieldName = 'CountOnBox'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object WeightOnBox: TcxGridDBColumn
            Caption = '***'#1047#1085#1072#1095#1077#1085#1080#1077' '#1042#1045#1057' '#1074' '#1103#1097'. (E2/E3)'
            DataBinding.FieldName = 'WeightOnBox'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1080#1083#1080' '#1074#1077#1089' '#1053#1077#1090#1090#1086' = '#1074#1074#1086#1076' '#1047#1053#1040#1063#1045#1053#1048#1045', '#1080#1083#1080' '#1074#1077#1089' '#1053#1077#1090#1090#1086' = '#1082#1086#1083'.'#1077#1076'.*'#1089#1088#1077#1076#1085#1080#1081' '#1074 +
              #1077#1089' ('#1074#1089#1077#1093' '#1082#1072#1090#1077#1075#1086#1088#1080#1081')'
            Width = 70
          end
          object BoxVolume: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1084' '#1103#1097'., '#1084'3. (E2/E3)'
            DataBinding.FieldName = 'BoxVolume'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 71
          end
          object BoxWeight: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'. (E2/E3)'
            DataBinding.FieldName = 'BoxWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1042#1077#1089' '#1087#1091#1089#1090#1086#1075#1086' '#1103#1097#1080#1082#1072' (E2/E3)'
            Options.Editing = False
            Width = 57
          end
          object BoxHeight: TcxGridDBColumn
            Caption = #1042#1099#1089#1086#1090#1072' '#1103#1097'. (E2/E3)'
            DataBinding.FieldName = 'BoxHeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxLength: TcxGridDBColumn
            Caption = #1044#1083#1080#1085#1072' '#1103#1097'. (E2/E3)'
            DataBinding.FieldName = 'BoxLength'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object BoxWidth: TcxGridDBColumn
            Caption = #1064#1080#1088#1080#1085#1072' '#1103#1097'. (E2/E3)'
            DataBinding.FieldName = 'BoxWidth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object WeightGross_Sh: TcxGridDBColumn
            Caption = '*'#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1064#1090'.'
            DataBinding.FieldName = 'WeightGross_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object WeightGross_Nom: TcxGridDBColumn
            Caption = '*'#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightGross_Nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object WeightGross_Ves: TcxGridDBColumn
            Caption = '*'#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightGross_Ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object WeightAvgGross_Sh: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1064#1090'.'
            DataBinding.FieldName = 'WeightAvgGross_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            Width = 70
          end
          object WeightAvgGross_Nom: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightAvgGross_Nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightAvgGross_Ves: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightAvgGross_Ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMinGross_Sh: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'.  '#1064#1090'.'
            DataBinding.FieldName = 'WeightMinGross_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            Width = 70
          end
          object WeightMinGross_Nom: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightMinGross_Nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083'.'
            Options.Editing = False
            Width = 70
          end
          object WeightMinGross_Ves: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightMinGross_Ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMaxGross_Sh: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'.  '#1064#1090'.'
            DataBinding.FieldName = 'WeightMaxGross_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            Width = 70
          end
          object WeightMaxGross_Nom: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightMaxGross_Nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMaxGross_Ves: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1103#1097'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightMaxGross_Ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightAvgNet_sh: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1064#1090'.'
            DataBinding.FieldName = 'WeightAvgNet_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            Width = 70
          end
          object WeightAvgNet_nom: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightAvgNet_nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightAvgNet_ves: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightAvgNet_ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMinNet_sh: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1064#1090'.'
            DataBinding.FieldName = 'WeightMinNet_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            Width = 70
          end
          object WeightMinNet_nom: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightMinNet_nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMinNet_ves: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightMinNet_ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMaxNet_sh: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1064#1090'.'
            DataBinding.FieldName = 'WeightMaxNet_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1090'.'
            Options.Editing = False
            Width = 70
          end
          object WeightMaxNet_nom: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1053#1086#1084'.'
            DataBinding.FieldName = 'WeightMaxNet_nom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object WeightMaxNet_ves: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1103#1097'. '#1053#1077#1085#1086#1084'.'
            DataBinding.FieldName = 'WeightMaxNet_ves'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086#1083#1085#1086#1075#1086' '#1103#1097#1080#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1053#1077#1085#1086#1084#1080#1085#1072#1083
            Options.Editing = False
            Width = 70
          end
          object BoxCode_2: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1103#1097#1080#1082#1072' ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'BoxCode_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object BoxName_2: TcxGridDBColumn
            Caption = #1071#1097#1080#1082' ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'BoxName_2'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = Box2ChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object CountOnBox_2: TcxGridDBColumn
            Caption = '***'#1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'. ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'CountOnBox_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object WeightOnBox_2: TcxGridDBColumn
            Caption = '***'#1047#1085#1072#1095#1077#1085#1080#1077' '#1042#1045#1057' '#1074' '#1103#1097'. ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'WeightOnBox_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1080#1083#1080' '#1074#1077#1089' '#1053#1077#1090#1090#1086' = '#1074#1074#1086#1076' '#1047#1053#1040#1063#1045#1053#1048#1045', '#1080#1083#1080' '#1074#1077#1089' '#1053#1077#1090#1090#1086' = '#1082#1086#1083'.'#1077#1076'.*'#1089#1088#1077#1076#1085#1080#1081' '#1074 +
              #1077#1089' ('#1076#1083#1103' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1058')'
            Width = 63
          end
          object BoxVolume_2: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1084' '#1103#1097'., '#1084'3. ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'BoxVolume_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 71
          end
          object BoxWeight_2: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1103#1097'. ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'BoxWeight_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1042#1077#1089' '#1087#1091#1089#1090#1086#1075#1086' '#1103#1097#1080#1082#1072' ('#1043#1086#1092#1088#1086')'
            Options.Editing = False
            Width = 57
          end
          object BoxHeight_2: TcxGridDBColumn
            Caption = #1042#1099#1089#1086#1090#1072' '#1103#1097'. ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'BoxHeight_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxLength_2: TcxGridDBColumn
            Caption = #1044#1083#1080#1085#1072' '#1103#1097'. ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'BoxLength_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object BoxWidth_2: TcxGridDBColumn
            Caption = #1064#1080#1088#1080#1085#1072' '#1103#1097'. ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'BoxWidth_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object WeightGross_2: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'WeightGross_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086' '#1089#1088#1077#1076#1085#1077#1084#1091' '#1074#1077#1089#1091' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1058' ('#1043#1086#1092#1088#1086')'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 73
          end
          object WeightAvgGross_2: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086' '#1089#1088'. '#1074#1077#1089#1091' ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'WeightAvgGross_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1073#1088#1091#1090#1090#1086' '#1087#1086' '#1089#1088#1077#1076#1085#1077#1084#1091' '#1074#1077#1089#1091' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1058' ('#1043#1086#1092#1088#1086')'
            Options.Editing = False
            Width = 76
          end
          object WeightAvgNet_2: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086' '#1089#1088'. '#1074#1077#1089#1091' ('#1043#1086#1092#1088#1086')'
            DataBinding.FieldName = 'WeightAvgNet_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1085#1077#1090#1090#1086' '#1087#1086' '#1089#1088#1077#1076#1085#1077#1084#1091' '#1074#1077#1089#1091' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1064#1058' ('#1043#1086#1092#1088#1086')'
            Options.Editing = False
            Width = 78
          end
          object BoxName_Retail1: TcxGridDBColumn
            Caption = #1071#1097#1080#1082' ('#1057#1077#1090#1100' 1)'
            DataBinding.FieldName = 'BoxName_Retail1'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = BoxRetailForm1
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object CountOnBox_Retail1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 1)'
            DataBinding.FieldName = 'CountOnBox_Retail1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object WeightOnBox_Retail1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1082#1075'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 1)'
            DataBinding.FieldName = 'WeightOnBox_Retail1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 63
          end
          object BoxName_Retail2: TcxGridDBColumn
            Caption = #1071#1097#1080#1082' ('#1057#1077#1090#1100' 2)'
            DataBinding.FieldName = 'BoxName_Retail2'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = BoxRetailForm2
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object CountOnBox_Retail2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 2)'
            DataBinding.FieldName = 'CountOnBox_Retail2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object WeightOnBox_Retail2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1082#1075'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 2)'
            DataBinding.FieldName = 'WeightOnBox_Retail2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 63
          end
          object BoxName_Retail3: TcxGridDBColumn
            Caption = #1071#1097#1080#1082' ('#1057#1077#1090#1100' 3)'
            DataBinding.FieldName = 'BoxName_Retail3'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = BoxRetailForm3
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object CountOnBox_Retail3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 3)'
            DataBinding.FieldName = 'CountOnBox_Retail3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object WeightOnBox_Retail3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1082#1075'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 3)'
            DataBinding.FieldName = 'WeightOnBox_Retail3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 63
          end
          object BoxName_Retail4: TcxGridDBColumn
            Caption = #1071#1097#1080#1082' ('#1057#1077#1090#1100' 4)'
            DataBinding.FieldName = 'BoxName_Retail4'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = BoxRetailForm4
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object CountOnBox_Retail4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 4)'
            DataBinding.FieldName = 'CountOnBox_Retail4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object WeightOnBox_Retail4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1082#1075'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 4)'
            DataBinding.FieldName = 'WeightOnBox_Retail4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 63
          end
          object BoxName_Retail5: TcxGridDBColumn
            Caption = #1071#1097#1080#1082' ('#1057#1077#1090#1100' 5)'
            DataBinding.FieldName = 'BoxName_Retail5'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = BoxRetailForm5
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object CountOnBox_Retail51: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 5)'
            DataBinding.FieldName = 'CountOnBox_Retail5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object WeightOnBox_Retail5: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1082#1075'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 5)'
            DataBinding.FieldName = 'WeightOnBox_Retail5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 63
          end
          object BoxName_Retail6: TcxGridDBColumn
            Caption = #1071#1097#1080#1082' ('#1057#1077#1090#1100' 6)'
            DataBinding.FieldName = 'BoxName_Retail6'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = BoxRetailForm6
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 66
          end
          object CountOnBox_Retail6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1077#1076'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 6)'
            DataBinding.FieldName = 'CountOnBox_Retail6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 61
          end
          object WeightOnBox_Retail6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1082#1075'. '#1074' '#1103#1097'.  ('#1057#1077#1090#1100' 6)'
            DataBinding.FieldName = 'WeightOnBox_Retail6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 63
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
          object Id: TcxGridDBColumn
            Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
            DataBinding.FieldName = 'Id'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
      object cxLabel27: TcxLabel
        Left = 617
        Top = 149
        Caption = #1041#1088#1077#1085#1076' '#1090#1086#1074#1072#1088#1072
      end
      object edGoodsBrand: TcxButtonEdit
        Left = 697
        Top = 148
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 157
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 1039
    Height = 30
    Align = alTop
    TabOrder = 5
    object edRetail2: TcxButtonEdit
      Left = 215
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 120
    end
    object cxLabel3: TcxLabel
      Left = 174
      Top = 7
      Caption = #1057#1077#1090#1100' 2:'
    end
    object cxLabel6: TcxLabel
      Left = 5
      Top = 7
      Caption = #1057#1077#1090#1100' 1:'
    end
    object edRetail1: TcxButtonEdit
      Left = 48
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 120
    end
  end
  object cxLabel1: TcxLabel [2]
    Left = 340
    Top = 7
    Caption = #1057#1077#1090#1100' 3:'
  end
  object edRetail3: TcxButtonEdit [3]
    Left = 383
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 120
  end
  object cxLabel2: TcxLabel [4]
    Left = 509
    Top = 7
    Caption = #1057#1077#1090#1100' 4:'
  end
  object edRetail4: TcxButtonEdit [5]
    Left = 552
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 120
  end
  object cxLabel4: TcxLabel [6]
    Left = 678
    Top = 7
    Caption = #1057#1077#1090#1100' 5:'
  end
  object edRetail5: TcxButtonEdit [7]
    Left = 719
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 120
  end
  object cxLabel5: TcxLabel [8]
    Left = 844
    Top = 7
    Caption = #1057#1077#1090#1100' 6:'
  end
  object edRetail6: TcxButtonEdit [9]
    Left = 887
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 120
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = GuidesRetail1
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRetail2
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRetail3
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRetail4
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRetail5
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRetail6
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
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
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Value = Null
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Value = Null
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end>
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actGoods_shOpenChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId_sh'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName_sh'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode_sh'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsOpenChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = GoodsOpenChoice
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1103#1079#1100'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1103#1079#1100'>'
      ImageIndex = 0
    end
    object ProtocolGoodsPropertyBoxId_2: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1071#1097#1080#1082' ('#1043#1086#1092#1088#1086')'
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
          ComponentItem = 'GoodsPropertyBoxId_2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName_2'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProtocolGoodsPropertyBoxId: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1071#1097#1080#1082' (E2/E3)'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1071#1097#1080#1082' (E2/E3)'
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
          ComponentItem = 'GoodsPropertyBoxId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProtocolOpenForm: TdsdOpenForm
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
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object Box2ChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxChoiceForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId_2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName_2'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxCode_2'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object BoxRetailForm1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxChoiceForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId_Retail1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName_Retail1'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object BoxRetailForm2: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxChoiceForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId_Retail2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName_Retail2'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object BoxRetailForm3: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxChoiceForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId_Retail3'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName_Retail3'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object BoxRetailForm4: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxChoiceForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId_Retail4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName_Retail4'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object BoxRetailForm5: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxChoiceForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId_Retail5'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName_Retail5'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object BoxRetailForm6: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxChoiceForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId_Retail6'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName_Retail6'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ExecuteDialogUpdate: TExecuteDialog
      Category = 'UpdateDate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      ImageIndex = 77
      FormName = 'TGoodsByGoodsKind_VMCDialogForm'
      FormNameParam.Value = 'TGoodsByGoodsKind_VMCDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inWeightMin'
          Value = Null
          Component = FormParams
          ComponentItem = 'inWeightMin'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inWeightMax'
          Value = Null
          Component = FormParams
          ComponentItem = 'inWeightMax'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inHeight'
          Value = Null
          Component = FormParams
          ComponentItem = 'inHeight'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inLength'
          Value = Null
          Component = FormParams
          ComponentItem = 'inLength'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inWidth'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'inWidth'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inWeightMin'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'WeightMin'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inWeightMax'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'WeightMax'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inHeight'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Height'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inLength'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Length'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inWidth'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'Width'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateList: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spInsertUpdateList
      StoredProcList = <
        item
          StoredProc = spInsertUpdateList
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 77
      ShortCut = 16455
      RefreshOnTabSetChanges = True
    end
    object macUpdateList: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateList
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateList'
    end
    object macUpdate: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdate
        end
        item
          Action = macUpdateList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1076#1083#1103' '#1042#1052#1057' '#1042#1057#1045#1052' '#1090#1086#1074#1072#1088#1072#1084'?'
      InfoAfterExecute = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1076#1083#1103' '#1042#1052#1057' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1099
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 77
    end
    object actUpdateGoodsBrand: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateGoodsBrand
      StoredProcList = <
        item
          StoredProc = spUpdateGoodsBrand
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 27
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateGoodsBrandList: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateGoodsBrand
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateGoodsBrandList'
      ImageIndex = 27
    end
    object macUpdateGoodsBrand: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateGoodsBrandList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1041#1088#1077#1085#1076' '#1042#1057#1045#1052' '#1090#1086#1074#1072#1088#1072#1084'?'
      InfoAfterExecute = #1041#1088#1077#1085#1076' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1041#1088#1077#1085#1076
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1041#1088#1077#1085#1076
      ImageIndex = 27
    end
    object actUpdateSh_Yes: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateSh_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateSh_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macListUpdateSh_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateSh_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macUpdateSh_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateSh_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object actUpdateSh_No: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateSh_No
      StoredProcList = <
        item
          StoredProc = spUpdateSh_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macListUpdateSh_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateSh_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object macUpdateSh_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateSh_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1064#1090#1091#1095#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object actUpdateNom_Yes: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateNom_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateNom_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macListUpdateNom_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNom_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macUpdateNom_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateNom_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object actUpdateNom_No: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateNom_No
      StoredProcList = <
        item
          StoredProc = spUpdateNom_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macListUpdateNom_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNom_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object macUpdateNom_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateNom_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object actUpdateVes_Yes: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateVes_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateVes_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macListUpdateVes_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateVes_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object macUpdateVes_Yes: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateVes_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1044#1040' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 76
    end
    object actUpdateVes_No: TdsdDataSetRefresh
      Category = 'UpdateDate'
      MoveParams = <>
      StoredProc = spUpdateVes_No
      StoredProcList = <
        item
          StoredProc = spUpdateVes_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macListUpdateVes_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateVes_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object macUpdateVes_No: TMultiAction
      Category = 'UpdateDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macListUpdateVes_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081' - '#1053#1045#1058' '#1076#1083#1103' '#1042#1089#1077#1093
      ImageIndex = 58
    end
    object BoxChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxChoiceForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1086#1088#1075#1086#1074#1099#1077' '#1089#1077#1090#1080
      FormName = 'TGoodsByGK_VMCDialogForm'
      FormNameParam.Value = 'TGoodsByGK_VMCDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Retail1Id'
          Value = Null
          Component = GuidesRetail1
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail2Id'
          Value = Null
          Component = GuidesRetail2
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail3Id'
          Value = Null
          Component = GuidesRetail3
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail4Id'
          Value = Null
          Component = GuidesRetail4
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail5Id'
          Value = Null
          Component = GuidesRetail5
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail6Id'
          Value = Null
          Component = GuidesRetail6
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail1Name'
          Value = Null
          Component = GuidesRetail1
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail2Name'
          Value = Null
          Component = GuidesRetail2
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail3Name'
          Value = Null
          Component = GuidesRetail3
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail4Name'
          Value = Null
          Component = GuidesRetail4
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail5Name'
          Value = Null
          Component = GuidesRetail5
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail6Name'
          Value = Null
          Component = GuidesRetail6
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actGoodsKind_shOpenForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKind_shOpenForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_sh'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_sh'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsByGoodsKind_VMC'
    Params = <
      item
        Name = 'inRetail1Id'
        Value = Null
        Component = GuidesRetail1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail2Id'
        Value = Null
        Component = GuidesRetail2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail3Id'
        Value = Null
        Component = GuidesRetail3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail4Id'
        Value = Null
        Component = GuidesRetail4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail5Id'
        Value = Null
        Component = GuidesRetail5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail6Id'
        Value = Null
        Component = GuidesRetail6
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 136
    Top = 184
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
          ItemName = 'bbInsertRecord'
        end
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
          ItemName = 'bbUpdate'
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
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'bbUpdateGoodsBrand'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateSh_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateSh_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateNom_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateNom_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateVes_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateVes_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'bbProtocolGoodsPropertyBoxId'
        end
        item
          Visible = True
          ItemName = 'bbProtocolGoodsPropertyBoxId_2'
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
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdate: TdxBarButton
      Action = macUpdate
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'bbLabel27'
      Category = 0
      Hint = 'bbLabel27'
      Visible = ivAlways
      Control = cxLabel27
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'bbGoodsBrand'
      Category = 0
      Hint = 'bbGoodsBrand'
      Visible = ivAlways
      Control = edGoodsBrand
    end
    object bbUpdateGoodsBrand: TdxBarButton
      Action = macUpdateGoodsBrand
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1041#1088#1077#1085#1076' '#1042#1057#1045#1052
      Category = 0
    end
    object bbUpdateSh_Yes: TdxBarButton
      Action = macUpdateSh_Yes
      Category = 0
    end
    object bbUpdateSh_No: TdxBarButton
      Action = macUpdateSh_No
      Category = 0
    end
    object bbUpdateNom_Yes: TdxBarButton
      Action = macUpdateNom_Yes
      Category = 0
    end
    object bbUpdateNom_No: TdxBarButton
      Action = macUpdateNom_No
      Category = 0
    end
    object bbUpdateVes_Yes: TdxBarButton
      Action = macUpdateVes_Yes
      Category = 0
    end
    object bbUpdateVes_No: TdxBarButton
      Action = macUpdateVes_No
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
      ImageIndex = 35
    end
    object bbProtocolGoodsPropertyBoxId: TdxBarButton
      Action = ProtocolGoodsPropertyBoxId
      Category = 0
    end
    object bbProtocolGoodsPropertyBoxId_2: TdxBarButton
      Action = ProtocolGoodsPropertyBoxId_2
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 176
    Top = 208
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind_VMC'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId_sh'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId_sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_sh'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId_2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Height'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLength'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Length'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Width'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNormInDays'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NormInDays'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountOnBox'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountOnBox'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightOnBox'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountOnBox_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountOnBox_2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightOnBox_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox_2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightGross_sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightGross_sh'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightGross_nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightGross_nom'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightGross_ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightGross_ves'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightGross_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightGross_2'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightAvg_Sh'
        Value = 'Felse'
        Component = MasterCDS
        ComponentItem = 'WeightAvg_Sh'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightAvg_Nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvg_Nom'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightAvg_Ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvg_Ves'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTax_Sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Tax_Sh'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTax_Nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Tax_Nom'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTax_Ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Tax_Ves'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightMin_Sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightMin_Sh'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightMax_Sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightMax_Sh'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightMin_Nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightMin_Nom'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightMax_Nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightMax_Nom'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightMin_Ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightMin_Ves'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightMax_Ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightMax_Ves'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsTypeKind_Sh'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsTypeKind_Nom'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsTypeKind_Ves'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWmsCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WmsCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWmsCodeCalc_Sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WmsCodeCalc_Sh'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWmsCodeCalc_Nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WmsCodeCalc_Nom'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWmsCodeCalc_Ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WmsCodeCalc_Ves'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWmsCellNum'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WmsCellNum'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail1Id'
        Value = Null
        Component = GuidesRetail1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail2Id'
        Value = Null
        Component = GuidesRetail2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail3Id'
        Value = Null
        Component = GuidesRetail3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail4Id'
        Value = Null
        Component = GuidesRetail4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail5Id'
        Value = Null
        Component = GuidesRetail5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetail6Id'
        Value = Null
        Component = GuidesRetail6
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBoxId_Retail1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId_Retail1'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBoxId_Retail2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId_Retail2'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBoxId_Retail3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId_Retail3'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBoxId_Retail4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId_Retail4'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBoxId_Retail5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId_Retail5'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBoxId_Retail6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId_Retail6'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxName_Retail1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxName_Retail1'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxName_Retail2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxName_Retail2'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxName_Retail3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxName_Retail3'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxName_Retail4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxName_Retail4'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxName_Retail5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxName_Retail5'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxName_Retail6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxName_Retail6'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountOnBox_Retail1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountOnBox_Retail1'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountOnBox_Retail2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountOnBox_Retail2'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountOnBox_Retail3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountOnBox_Retail3'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountOnBox_Retail4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountOnBox_Retail4'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountOnBox_Retail5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountOnBox_Retail5'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountOnBox_Retail6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountOnBox_Retail6'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWeightOnBox_Retail1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox_Retail1'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWeightOnBox_Retail2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox_Retail2'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWeightOnBox_Retail3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox_Retail3'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWeightOnBox_Retail4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox_Retail4'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWeightOnBox_Retail5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox_Retail5'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioWeightOnBox_Retail6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox_Retail6'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightOnBox'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightAvgGross_sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvgGross_sh'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightAvgGross_nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvgGross_nom'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightAvgGross_ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvgGross_ves'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightAvgNet_sh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvgNet_sh'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightAvgNet_nom'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvgNet_nom'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightAvgNet_ves'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvgNet_ves'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightOnBox_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightOnBox_2'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightAvgGross_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvgGross_2'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightAvgNet_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightAvgNet_2'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 152
  end
  object spInsertUpdateList: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind_VMC'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightMin'
        Value = Null
        Component = FormParams
        ComponentItem = 'inWeightMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightMax'
        Value = Null
        Component = FormParams
        ComponentItem = 'inWeightMax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeight'
        Value = Null
        Component = FormParams
        ComponentItem = 'inHeight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLength'
        Value = Null
        Component = FormParams
        ComponentItem = 'inLength'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth'
        Value = Null
        Component = FormParams
        ComponentItem = 'inWidth'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 400
    Top = 216
  end
  object GuidesGoodsBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsBrand
    FormNameParam.Value = 'TGoodsBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsBrandForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 768
    Top = 120
  end
  object spUpdateGoodsBrand: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_GoodsBrand'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsBrandId'
        Value = Null
        Component = GuidesGoodsBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 128
  end
  object spUpdateSh_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Sh'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Sh'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 240
  end
  object spUpdateNom_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Nom'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Nom'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 288
  end
  object spUpdateSh_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Sh'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Sh'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 240
  end
  object spUpdateVes_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Ves'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Ves'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 648
    Top = 336
  end
  object spUpdateNom_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Nom'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Nom'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 728
    Top = 296
  end
  object spUpdateVes_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Ves'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsTypeKind_Ves'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 720
    Top = 344
  end
  object GuidesRetail1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail1
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 65528
  end
  object GuidesRetail2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail2
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 65528
  end
  object GuidesRetail3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail3
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 65528
  end
  object GuidesRetail4: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail4
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 592
    Top = 3
  end
  object GuidesRetail5: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail5
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail5
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 917
    Top = 3
  end
  object GuidesRetail6: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail6
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail6
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail6
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 944
    Top = 2
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesRetail1
      end
      item
        Component = GuidesRetail2
      end
      item
        Component = GuidesRetail3
      end
      item
        Component = GuidesRetail4
      end
      item
        Component = GuidesRetail5
      end
      item
        Component = GuidesRetail6
      end>
    Left = 280
    Top = 216
  end
end
