inherited GoodsByGoodsKindForm: TGoodsByGoodsKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1058#1086#1074#1072#1088' '#1080' '#1042#1080#1076' '#1090#1086#1074#1072#1088#1072'>'
  ClientHeight = 420
  ClientWidth = 1030
  ExplicitWidth = 1046
  ExplicitHeight = 459
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1030
    Height = 394
    ExplicitWidth = 1030
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 1030
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1030
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 1030
        Height = 394
        ExplicitWidth = 1030
        ExplicitHeight = 394
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
            Width = 88
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 132
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
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
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
            Width = 171
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
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object DaysQ: TcxGridDBColumn
            Caption = #1059#1084#1077#1085#1100#1096'. '#1044#1072#1090#1099' '#1087#1088#1086#1080#1079#1074' '#1074' '#1082#1072#1095#1077#1089#1090#1074'.'
            DataBinding.FieldName = 'DaysQ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1084#1077#1085#1100#1096#1077#1085#1080#1077' '#1085#1072' N '#1076#1085#1077#1081' '#1086#1090' '#1076#1072#1090#1099' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1082#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1084
            Width = 76
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1090#1086#1074'.'
            DataBinding.FieldName = 'Weight'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 45
          end
          object WeightPackage: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1072#1082'. '#1076#1083#1103' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightPackage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' 1-'#1086#1075#1086' '#1087#1072#1082#1077#1090#1072' '#1076#1083#1103' '#1059#1055#1040#1050#1054#1042#1050#1048
            Width = 70
          end
          object WeightPackageSticker: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1072#1082'. '#1076#1083#1103' '#1069#1058'.'
            DataBinding.FieldName = 'WeightPackageSticker'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' 1-'#1086#1075#1086' '#1087#1072#1082#1077#1090#1072' '#1076#1083#1103' '#1087#1077#1095'. '#1069#1058#1048#1050#1045#1058#1050#1048
            Width = 70
          end
          object WeightTotal: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object ChangePercentAmount: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'ChangePercentAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object WeightMin: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1074#1077#1089
            DataBinding.FieldName = 'WeightMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object WeightMax: TcxGridDBColumn
            Caption = #1052#1072#1093'. '#1074#1077#1089
            DataBinding.FieldName = 'WeightMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object Height: TcxGridDBColumn
            Caption = #1042#1099#1089#1086#1090#1072
            DataBinding.FieldName = 'Height'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Length: TcxGridDBColumn
            Caption = #1044#1083#1080#1085#1072
            DataBinding.FieldName = 'Length'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Width: TcxGridDBColumn
            Caption = #1064#1080#1088#1080#1085#1072
            DataBinding.FieldName = 'Width'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object NormRem: TcxGridDBColumn
            Caption = #1053#1086#1088#1084'. '#1086#1089#1090', '#1090#1086#1085#1085
            DataBinding.FieldName = 'NormRem'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1088#1084#1072#1090#1080#1074#1085#1099#1077' '#1086#1089#1090#1072#1090#1082#1080', '#1090#1086#1085#1085
            Options.Editing = False
            Width = 80
          end
          object NormOut: TcxGridDBColumn
            Caption = #1053#1086#1088#1084'. '#1087#1086#1090#1088#1077#1073#1083'./'#1084#1077#1089'., '#1090#1086#1085#1085
            DataBinding.FieldName = 'NormOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1088#1084#1072#1090#1080#1074#1085#1086#1077' '#1087#1086#1090#1088#1077#1073#1083#1077#1085#1080#1077' '#1074' '#1084#1077#1089#1103#1094', '#1090#1086#1085#1085
            Options.Editing = False
            Width = 80
          end
          object NormPack: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1099' '#1091#1087'. ('#1074' '#1082#1075'/'#1095#1072#1089')'
            DataBinding.FieldName = 'NormPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1088#1084#1099' '#1091#1087#1072#1082#1086#1074#1099#1074#1072#1085#1080#1103' ('#1074' '#1082#1075'/'#1095#1072#1089')'
            Options.Editing = False
            Width = 70
          end
          object GoodsCode_basis: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1094#1077#1093')'
            DataBinding.FieldName = 'GoodsCode_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_basis: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1094#1077#1093')'
            DataBinding.FieldName = 'GoodsName_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_main: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsCode_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_main: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsName_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object isCheck_basis: TcxGridDBColumn
            Caption = #1088#1072#1079#1085'. ('#1094#1077#1093')'
            DataBinding.FieldName = 'isCheck_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isCheck_main: TcxGridDBColumn
            Caption = #1088#1072#1079#1085'. ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'isCheck_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ReceiptName: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
            DataBinding.FieldName = 'ReceiptName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ReceiptChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ReceiptGPCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1089#1093'. '#1090#1091#1096'.)'
            DataBinding.FieldName = 'ReceiptGPCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1089#1093#1077#1084#1072' '#1089' '#1090#1091#1096#1077#1085#1082#1086#1081')'
            Options.Editing = False
            Width = 55
          end
          object ReceiptGPName: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072' ('#1089#1093'. '#1090#1091#1096'.)'
            DataBinding.FieldName = 'ReceiptGPName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ReceiptGPChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1094#1077#1087#1090#1091#1088#1072' ('#1089#1093#1077#1084#1072' '#1089' '#1090#1091#1096#1077#1085#1082#1086#1081')'
            Width = 100
          end
          object GoodsSubCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087'/'#1088')'
            DataBinding.FieldName = 'GoodsSubCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 61
          end
          object GoodsSubName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsSubName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsSubOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 155
          end
          object GoodsKindSubName: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindSubName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindSubChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Width = 70
          end
          object MeasureSubName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'MeasureSubName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090'.-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 62
          end
          object GoodsSubSendCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087'. '#1087'/'#1088')'
            DataBinding.FieldName = 'GoodsSubSendCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1084#1077#1097'.'#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 61
          end
          object GoodsSubSendName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1084'. '#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsSubSendName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsSubSendOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1084#1077#1097'.'#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Width = 155
          end
          object GoodsKindSubSendName: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1077#1088#1077#1084'. '#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindSubSendName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindSubSendChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1084#1077#1097'. '#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Width = 70
          end
          object MeasureSubSendName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.  ('#1087#1077#1088#1077#1084'. '#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'MeasureSubSendName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1084#1077#1097'. '#1087#1077#1088#1077#1089#1086#1088#1090'.-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 62
          end
          object GoodsSubCode_Br: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087'.'#1092'./'#1088')'
            DataBinding.FieldName = 'GoodsSubCode_Br'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' '#1085#1072' '#1092#1080#1083#1080#1072#1083#1072#1093' -'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 61
          end
          object GoodsSubName_Br: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsSubName_Br'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsSubOpenChoice_Br
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 155
          end
          object GoodsKindSubSendName_Br: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1077#1088#1077#1084'. '#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindSubSendName_Br'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindSubSendChoiceForm_Br
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1084#1077#1097'. '#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' '#1085#1072' '#1092#1080#1083#1080#1072#1083#1072#1093' -'#1088#1072#1089#1093#1086#1076')'
            Width = 70
          end
          object GoodsPackCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1091#1087#1072#1082'. '#1075#1083#1072#1074#1085'.)'
            DataBinding.FieldName = 'GoodsPackCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1043#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1087#1072#1082#1086#1074#1082#1080
            Options.Editing = False
            Width = 61
          end
          object GoodsPackName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1091#1087#1072#1082'., '#1075#1083#1072#1074#1085#1099#1081')'
            DataBinding.FieldName = 'GoodsPackName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsPackOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1083#1072#1074#1085#1099#1081' '#1058#1086#1074#1072#1088' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1087#1072#1082#1086#1074#1082#1080
            Width = 155
          end
          object GoodsKindPackName: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1091#1087#1072#1082'., '#1075#1083#1072#1074#1085#1099#1081')'
            DataBinding.FieldName = 'GoodsKindPackName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindPackChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1083#1072#1074#1085#1099#1081' '#1042#1080#1076' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1087#1072#1082#1086#1074#1082#1080
            Width = 70
          end
          object MeasurePackName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.  ('#1091#1087#1072#1082'., '#1075#1083#1072#1074#1085#1099#1081')'
            DataBinding.FieldName = 'MeasurePackName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1043#1083#1072#1074#1085#1086#1075#1086' '#1058#1086#1074#1072#1088#1072' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1087#1072#1082#1086#1074#1082#1080
            Options.Editing = False
            Width = 62
          end
          object isOrder: TcxGridDBColumn
            Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' '#1079#1072#1103#1074#1082#1072#1093
            DataBinding.FieldName = 'isOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object isScaleCeh: TcxGridDBColumn
            Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' ScaleCeh'
            DataBinding.FieldName = 'isScaleCeh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object isNotMobile: TcxGridDBColumn
            Caption = #1053#1045' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074' '#1052#1086#1073#1080#1083#1100#1085#1086#1084' '#1072#1075#1077#1085#1090#1077
            DataBinding.FieldName = 'isNotMobile'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object IsNewQuality: TcxGridDBColumn
            Caption = #1053#1086#1074#1072#1103' '#1076#1077#1082#1083#1072#1088'.'
            DataBinding.FieldName = 'IsNewQuality'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1074#1072#1103' '#1076#1077#1082#1083#1072#1088#1072#1094#1080#1103' '#1089' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1084' "'#1042#1078#1080#1090#1080' '#1076#1086'"'
            Options.Editing = False
            Width = 70
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1054#1055
            Options.Editing = False
            Width = 70
          end
          object isNotPack: TcxGridDBColumn
            Caption = #1053#1077' '#1091#1087#1072#1082#1086#1074#1099#1074#1072#1090#1100
            DataBinding.FieldName = 'isNotPack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1054#1055
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
          object GoodsBrandName: TcxGridDBColumn
            Caption = #1041#1088#1077#1085#1076
            DataBinding.FieldName = 'GoodsBrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1088#1077#1085#1076' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 70
          end
          object isGoodsTypeKind_Sh: TcxGridDBColumn
            Caption = #1064#1090#1091#1095#1085#1099#1081
            DataBinding.FieldName = 'isGoodsTypeKind_Sh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1064#1090#1091#1095#1085#1099#1081'"'
            Options.Editing = False
            Width = 60
          end
          object isGoodsTypeKind_Nom: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081
            DataBinding.FieldName = 'isGoodsTypeKind_Nom'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081'"'
            Options.Editing = False
            Width = 60
          end
          object isGoodsTypeKind_Ves: TcxGridDBColumn
            Caption = #1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081
            DataBinding.FieldName = 'isGoodsTypeKind_Ves'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081'"'
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
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
        end
        item
          StoredProc = spUpdate_isParam
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object GoodsPackOpenChoice: TOpenChoiceForm
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
          ComponentItem = 'GoodsPackId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsPackName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsPackCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasurePackName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsSubSendOpenChoice: TOpenChoiceForm
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
          ComponentItem = 'GoodsSubSendId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubSendName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubSendCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureSubSendName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsSubOpenChoice_Br: TOpenChoiceForm
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
          ComponentItem = 'GoodsSubId_Br'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubName_Br'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubCode_Br'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureSubName_Br'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsSubOpenChoice: TOpenChoiceForm
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
          ComponentItem = 'GoodsSubId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSubCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureSubName'
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
    object GoodsKindPackChoiceForm: TOpenChoiceForm
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
          ComponentItem = 'GoodsKindPackId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindPackName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindSubSendChoiceForm_Br: TOpenChoiceForm
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
          ComponentItem = 'GoodsKindSubSendId_Br'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindSubSendName_Br'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindSubSendChoiceForm: TOpenChoiceForm
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
          ComponentItem = 'GoodsKindSubSendId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindSubSendName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindSubChoiceForm: TOpenChoiceForm
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
          ComponentItem = 'GoodsKindSubId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindSubName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ReceiptGPChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TReceipt_ObjectForm'
      FormName = 'TReceipt_ObjectForm'
      FormNameParam.Value = 'TReceipt_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptGPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptGPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ReceiptChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TReceipt_ObjectForm'
      FormName = 'TReceipt_ObjectForm'
      FormNameParam.Value = 'TReceipt_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          ParamType = ptInput
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
    object actUpdateNewQuality: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdateNewQuality
      StoredProcList = <
        item
          StoredProc = spUpdateNewQuality
        end>
      Caption = #1059#1089#1090#1085#1086#1074#1080#1090#1100' "'#1042#1078#1080#1090#1080' '#1076#1086'" ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1059#1089#1090#1085#1086#1074#1080#1090#1100' "'#1042#1078#1080#1090#1080' '#1076#1086'" ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 77
      ShortCut = 16505
      RefreshOnTabSetChanges = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 40
  end
  inherited MasterCDS: TClientDataSet
    Top = 40
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsByGoodsKind'
    Top = 40
  end
  inherited BarManager: TdxBarManager
    Left = 48
    Top = 120
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateNewQuality'
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
      ShowCaption = False
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdateNewQuality: TdxBarButton
      Action = actUpdateNewQuality
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1042#1078#1080#1090#1080' '#1076#1086'" ('#1044#1072'/'#1053#1077#1090')'
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind'
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
        Name = 'inGoodsSubId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsSubId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindSubId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindSubId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSubSendId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsSubSendId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindSubSendId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindSubSendId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPackId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsPackId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindPackId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindPackId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSubId_Br'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsSubId_Br'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindSubSendId_Br'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindSubSendId_Br'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceipGPtId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptGPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightPackage'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightPackage'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightPackageSticker'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightPackageSticker'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightTotal'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightTotal'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercentAmount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaysQ'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DaysQ'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsNotPack'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsNotPack'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 112
  end
  object spUpdate_isParam: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_isOrder_isScaleCeh'
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
        Name = 'inisOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOrder'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisScaleCeh'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isScaleCeh'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 112
  end
  object spUpdateNewQuality: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_isNewQuality'
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
        Name = 'inIsNewQuality'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsNewQuality'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 176
  end
end
