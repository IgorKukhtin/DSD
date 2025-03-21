inherited GoodsByGoodsKindForm: TGoodsByGoodsKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1058#1086#1074#1072#1088' '#1080' '#1042#1080#1076' '#1090#1086#1074#1072#1088#1072'>'
  ClientHeight = 420
  ClientWidth = 1071
  ExplicitWidth = 1087
  ExplicitHeight = 459
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1071
    Height = 394
    ExplicitWidth = 1071
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 1071
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1071
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 1071
        Height = 394
        ExplicitWidth = 1071
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
            Width = 53
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
          object GoodsKindNewName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1085#1086#1074#1099#1081')'
            DataBinding.FieldName = 'GoodsKindNewName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindNewChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1085#1086#1074#1099#1081')'
            Width = 77
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
          object NormInDays: TcxGridDBColumn
            Caption = '***'#1089#1088#1086#1082' '#1074' '#1076#1085#1103#1093
            DataBinding.FieldName = 'NormInDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077', '#1076#1083#1103' '#1074#1080#1076#1072' '#1090#1086#1074#1072#1088#1072' - '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1074' '#1076#1085#1103#1093
            Options.Editing = False
            Width = 70
          end
          object Value1_gk: TcxGridDBColumn
            Caption = '***'#1042#1080#1076' '#1086#1073#1086#1083#1086#1085#1082#1080', '#8470'4'
            DataBinding.FieldName = 'Value1_gk'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077', '#1076#1083#1103' '#1074#1080#1076#1072' '#1090#1086#1074#1072#1088#1072' - '#1042#1080#1076' '#1086#1073#1086#1083#1086#1085#1082#1080', '#8470'4'
            Options.Editing = False
            Width = 70
          end
          object Value11_gk: TcxGridDBColumn
            Caption = '*** '#1042#1080#1076' '#1087#1072#1082#1091#1074#1072#1085#1085#1103'/'#1089#1090#1072#1085' '#1087#1088#1086#1076#1091#1082#1094#1110#1111' '
            DataBinding.FieldName = 'Value11_gk'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077', '#1076#1083#1103' '#1074#1080#1076#1072' '#1090#1086#1074#1072#1088#1072' - '#1042#1080#1076' '#1087#1072#1082#1091#1074#1072#1085#1085#1103'/'#1089#1090#1072#1085' '#1087#1088#1086#1076#1091#1082#1094#1110#1111' '
            Options.Editing = False
            Width = 70
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
          object WeightPackageKorob: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1072#1082'. '#1076#1083#1103' '#1082#1086#1088#1086#1073'.'
            DataBinding.FieldName = 'WeightPackageKorob'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' 1-'#1086#1075#1086' '#1087#1072#1082#1077#1090#1072' '#1076#1083#1103' '#1050#1054#1056#1054#1041#1050#1048
            Width = 70
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
            Caption = '1.1.'#1050#1086#1076' ('#1094#1077#1093')'
            DataBinding.FieldName = 'GoodsCode_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_basis: TcxGridDBColumn
            Caption = '1.1.'#1053#1072#1079#1074#1072#1085#1080#1077' ('#1094#1077#1093')'
            DataBinding.FieldName = 'GoodsName_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_main: TcxGridDBColumn
            Caption = '2.1.'#1050#1086#1076' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsCode_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName_main: TcxGridDBColumn
            Caption = '2.1.'#1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsName_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_basis_old: TcxGridDBColumn
            Caption = '1.2.'#1050#1086#1076' ('#1094#1077#1093') ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'GoodsCode_basis_old'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object GoodsName_basis_old: TcxGridDBColumn
            Caption = '1.2.'#1053#1072#1079#1074#1072#1085#1080#1077' ('#1094#1077#1093') ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'GoodsName_basis_old'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_main_old: TcxGridDBColumn
            Caption = '2.2.'#1050#1086#1076' ('#1085#1072' '#1091#1087#1072#1082'.) ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'GoodsCode_main_old'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object GoodsName_main_old: TcxGridDBColumn
            Caption = '2.2.'#1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1091#1087#1072#1082'.) ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'GoodsName_main_old'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object EndDate_old: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'EndDate_old'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086' '#1082#1072#1082#1086#1081' '#1076#1072#1090#1099' '#1074#1082#1083#1102#1095#1080#1090#1077#1083#1100#1085#1086' '#1076#1077#1081#1089#1090#1074#1086#1074#1072#1083#1080' '
            Options.Editing = False
            Width = 69
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
          object GoodsSubDate: TcxGridDBColumn
            Caption = '3.1.'#1044#1072#1090#1072' ('#1087#1077#1088#1077#1089#1086#1088'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsSubDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072', '#1089' '#1082#1086#1090#1086#1088#1086#1081' '#1092#1086#1088#1084#1080#1088#1091#1077#1090#1089#1103' '#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' - '#1088#1072#1089#1093#1086#1076
            Width = 80
          end
          object isNotDate: TcxGridDBColumn
            Caption = '3.1.'#1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1090#1091' ('#1087'/'#1088')'
            DataBinding.FieldName = 'isNotDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1090#1091' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' - '#1088#1072#1089#1093#1086#1076')'
            Width = 70
          end
          object GoodsSubCode: TcxGridDBColumn
            Caption = '3.1.'#1050#1086#1076' '#1090#1086#1074'. ('#1087'/'#1088')'
            DataBinding.FieldName = 'GoodsSubCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 61
          end
          object GoodsSubName: TcxGridDBColumn
            Caption = '3.1.'#1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
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
            Caption = '3.1.'#1042#1080#1076' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
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
            Caption = '3.1.'#1045#1076'. '#1080#1079#1084'.  ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'MeasureSubName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090'.-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 62
          end
          object GoodsSubSendCode: TcxGridDBColumn
            Caption = '3.2.'#1050#1086#1076' '#1090#1086#1074'. ('#1087'. '#1087'/'#1088')'
            DataBinding.FieldName = 'GoodsSubSendCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1084#1077#1097'.'#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 61
          end
          object GoodsSubSendName: TcxGridDBColumn
            Caption = '3.2.'#1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1084'. '#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
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
            Caption = '3.2.'#1042#1080#1076' ('#1087#1077#1088#1077#1084'. '#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
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
            Caption = '3.2.'#1045#1076'. '#1080#1079#1084'.  ('#1087#1077#1088#1077#1084'. '#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'MeasureSubSendName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1084#1077#1097'. '#1087#1077#1088#1077#1089#1086#1088#1090'.-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 62
          end
          object GoodsSubCode_Br: TcxGridDBColumn
            Caption = '4.1.'#1050#1086#1076' '#1090#1086#1074'. ('#1087'.'#1092'./'#1088')'
            DataBinding.FieldName = 'GoodsSubCode_Br'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' '#1085#1072' '#1092#1080#1083#1080#1072#1083#1072#1093' -'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 61
          end
          object GoodsSubName_Br: TcxGridDBColumn
            Caption = '4.1.'#1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076')'
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
            Caption = '4.1.'#1042#1080#1076' '#1090'.('#1087#1077#1088#1077#1084'. '#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076')'
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
            Caption = '1.3.'#1050#1086#1076' '#1090#1086#1074'. ('#1091#1087#1072#1082'. '#1075#1083#1072#1074#1085'.)'
            DataBinding.FieldName = 'GoodsPackCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1043#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1087#1072#1082#1086#1074#1082#1080
            Options.Editing = False
            Width = 61
          end
          object GoodsPackName: TcxGridDBColumn
            Caption = '1.3.'#1058#1086#1074#1072#1088' ('#1091#1087#1072#1082'., '#1075#1083#1072#1074#1085#1099#1081')'
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
            Caption = '1.3.'#1042#1080#1076' ('#1091#1087#1072#1082'., '#1075#1083#1072#1074#1085#1099#1081')'
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
            Caption = '1.3.'#1045#1076'. '#1080#1079#1084'.  ('#1091#1087#1072#1082'., '#1075#1083#1072#1074#1085#1099#1081')'
            DataBinding.FieldName = 'MeasurePackName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1043#1083#1072#1074#1085#1086#1075#1086' '#1058#1086#1074#1072#1088#1072' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1087#1072#1082#1086#1074#1082#1080
            Options.Editing = False
            Width = 62
          end
          object GoodsRealCode: TcxGridDBColumn
            Caption = '3.3.'#1050#1086#1076' '#1090#1086#1074'.('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            DataBinding.FieldName = 'GoodsRealCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            Options.Editing = False
            Width = 71
          end
          object GoodsRealName: TcxGridDBColumn
            Caption = '3.3.'#1058#1086#1074#1072#1088' ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            DataBinding.FieldName = 'GoodsRealName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsRealOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1083#1072#1074#1085#1099#1081' '#1058#1086#1074#1072#1088' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1087#1072#1082#1086#1074#1082#1080
            Width = 155
          end
          object GoodsKindRealName: TcxGridDBColumn
            Caption = '3.3.'#1042#1080#1076' '#1090#1086#1074'. ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            DataBinding.FieldName = 'GoodsKindRealName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindRealChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            Width = 70
          end
          object MeasureRealName: TcxGridDBColumn
            Caption = '3.3.'#1045#1076'. '#1080#1079#1084'. ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            DataBinding.FieldName = 'MeasureRealName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object GoodsIncomeCode: TcxGridDBColumn
            Caption = '5.1.'#1050#1086#1076' '#1090#1086#1074'.  ('#1092#1072#1082#1090' '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsIncomeCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object GoodsIncomeName: TcxGridDBColumn
            Caption = '5.1.'#1058#1086#1074#1072#1088' ('#1092#1072#1082#1090' '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsIncomeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsIncomeOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 155
          end
          object GoodsKindIncomeName: TcxGridDBColumn
            Caption = '5.1.'#1042#1080#1076' ('#1092#1072#1082#1090' '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindIncomeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindIncomeChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1087#1088#1080#1093#1086#1076')'
            Width = 70
          end
          object MeasureIncomeName: TcxGridDBColumn
            Caption = '5.1.'#1045#1076'. '#1080#1079#1084'. ('#1092#1072#1082#1090' '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'MeasureIncomeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1087#1088#1080#1093#1086#1076')'
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
          object isRK: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1056#1050
            DataBinding.FieldName = 'isRK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
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
          object isPackOrder: TcxGridDBColumn
            Caption = #1053#1077#1090' '#1086#1075#1088#1072#1085#1080#1095'. '#1085#1072' '#1091#1087#1072#1082
            DataBinding.FieldName = 'isPackOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077#1090' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082'.'
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
          object GoodsBrandName: TcxGridDBColumn
            Caption = #1041#1088#1077#1085#1076
            DataBinding.FieldName = 'GoodsBrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1088#1077#1085#1076' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 70
          end
          object PackLimit: TcxGridDBColumn
            Caption = #1054#1075#1088'. '#1074' '#1076#1085'. '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082
            DataBinding.FieldName = 'PackLimit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082
            Options.Editing = False
            Width = 80
          end
          object isPackLimit: TcxGridDBColumn
            Caption = #1054#1075#1088'. '#1074' '#1076#1085'. '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082' ('#1044#1072'/'#1053#1077#1090')'
            DataBinding.FieldName = 'isPackLimit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082' ('#1044#1072'/'#1053#1077#1090')'
            Options.Editing = False
            Width = 80
          end
          object isEtiketka: TcxGridDBColumn
            Caption = #1057#1093'. '#1089' '#1101#1090#1080#1082'. '#1087#1088#1080' '#1087#1077#1088#1077#1089#1086#1088#1090'.'
            DataBinding.FieldName = 'isEtiketka'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1093#1077#1084#1072' '#1089' '#1101#1090#1080#1082#1077#1090#1082#1086#1081' '#1087#1088#1080' '#1087#1077#1088#1077#1089#1086#1088#1090#1077
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
    end
  end
  inherited ActionList: TActionList
    object actGetImportSetting_GoodsKindNew: TdsdExecStoredProc [0]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_GoodsKindNew
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_GoodsKindNew
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1053#1086#1074#1099#1077') '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1053#1086#1074#1099#1077') '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object macStartLoadGoodsKindNew: TMultiAction [1]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_GoodsKindNew
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1053#1086#1074#1099#1077') '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1053#1086#1074#1099#1077') '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1053#1086#1074#1099#1077') '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 30
      WithoutNext = True
    end
    object actGetImportSettingPK: TdsdExecStoredProc [2]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_PK
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_PK
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1056#1050' = '#1044#1072' '#1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1056#1050' = '#1044#1072' '#1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object macStartLoadPK: TMultiAction [5]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingPK
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1056#1050' = '#1044#1072' '#1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1056#1050' = '#1044#1072' '#1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1056#1050' = '#1044#1072' '#1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 27
      WithoutNext = True
    end
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
    object GoodsRealOpenChoice: TOpenChoiceForm
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
          ComponentItem = 'GoodsRealId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsRealName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsRealCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureRealName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
    object GoodsKindNewChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TGoodsKindNewForm'
      FormName = 'TGoodsKindNewForm'
      FormNameParam.Value = 'TGoodsKindNewForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindNewId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindNewName'
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
    object GoodsKindRealChoiceForm: TOpenChoiceForm
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
          ComponentItem = 'GoodsKindRealId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindRealName'
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
    object GoodsIncomeOpenChoice: TOpenChoiceForm
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
          ComponentItem = 'GoodsIncomeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsIncomeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsIncomeCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureIncomeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindIncomeChoiceForm: TOpenChoiceForm
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
          ComponentItem = 'GoodsKindIncomeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindIncomeName'
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
    object actUpdate_isEtiketka: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_isEtiketka
      StoredProcList = <
        item
          StoredProc = spUpdate_isEtiketka
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1089#1090#1085#1086#1074#1080#1090#1100' "'#1057#1093#1077#1084#1072' '#1089' '#1101#1090#1080#1082#1077#1090#1082#1086#1081' '#1087#1088#1080' '#1087#1077#1088#1077#1089#1086#1088#1090#1077'" ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1059#1089#1090#1085#1086#1074#1080#1090#1100' "'#1057#1093#1077#1084#1072' '#1089' '#1101#1090#1080#1082#1077#1090#1082#1086#1081' '#1087#1088#1080' '#1087#1077#1088#1077#1089#1086#1088#1090#1077'" ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 76
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actOpenUnitPeresortForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1089#1086#1088#1090' '#1087#1086' '#1089#1082#1083#1072#1076#1072#1084
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1089#1086#1088#1090' '#1087#1086' '#1089#1082#1083#1072#1076#1072#1084
      ImageIndex = 25
      FormName = 'TUnitPeresortForm'
      FormNameParam.Value = 'TUnitPeresortForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
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
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
      Hint = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080'  '#1042#1080#1076' '#1090'.('#1087#1077#1088#1077#1084'. '#1087#1077#1088 +
        #1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080#1079' '#1092#1072#1081#1083#1072
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
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080'  '#1042#1080#1076' '#1090#1086#1074'.('#1087#1077#1088#1077#1084'. '#1087 +
        #1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080'  '#1042#1080#1076' '#1090'.('#1087#1077#1088#1077#1084'. '#1087#1077#1088 +
        #1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080'  '#1042#1080#1076' '#1090'.('#1087#1077#1088#1077#1084'. '#1087#1077#1088 +
        #1077#1089#1086#1088#1090'. '#1085#1072' '#1092#1080#1083'.- '#1088#1072#1089#1093#1086#1076') '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
    object actUpdate_PackOrder: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_PackOrder
      StoredProcList = <
        item
          StoredProc = spUpdate_PackOrder
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1053#1077#1090' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082'." ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1053#1077#1090' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082'." ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 85
      ShortCut = 116
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
    Left = 104
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
          ItemName = 'bbUpdate_PackOrder'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isEtiketka'
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
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadPK'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadGoodsKindNew'
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
          ItemName = 'bbOpenUnitPeresortForm'
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
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Category = 0
    end
    object bbStartLoadPK: TdxBarButton
      Action = macStartLoadPK
      Category = 0
    end
    object bbStartLoadGoodsKindNew: TdxBarButton
      Action = macStartLoadGoodsKindNew
      Category = 0
    end
    object bbUpdate_PackOrder: TdxBarButton
      Action = actUpdate_PackOrder
      Category = 0
    end
    object bbOpenUnitPeresortForm: TdxBarButton
      Action = actOpenUnitPeresortForm
      Category = 0
    end
    object bbUpdate_isEtiketka: TdxBarButton
      Action = actUpdate_isEtiketka
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
        Name = 'inGoodsRealId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindRealId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindRealId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindNewId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindNewId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsIncomeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsIncomeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindIncomeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindIncomeId'
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
        Name = 'inWeightPackageKorob'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightPackageKorob'
        DataType = ftFloat
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
        Name = 'inGoodsSubDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsSubDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotDate'
        DataType = ftBoolean
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
      end
      item
        Name = 'inisRK'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isRK'
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
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 664
    Top = 136
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsByGoodsKind_BrForm;zc_Object_ImportSetting_GoodsByGoodsKin' +
          'd_Br'
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
    Left = 664
    Top = 200
  end
  object spGetImportSettingId_PK: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsByGoodsKind_PKForm;zc_Object_ImportSetting_GoodsByGoodsKin' +
          'd_PK'
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
    Left = 840
    Top = 200
  end
  object spGetImportSettingId_GoodsKindNew: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsByGoodsKind_GoodsKindNewForm;zc_Object_ImportSetting_Goods' +
          'ByGoodsKind_GoodsKindNew'
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
    Left = 664
    Top = 272
  end
  object spUpdate_PackOrder: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_isPackOrder'
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
        Name = 'inIsPackOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsPackOrder'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 264
  end
  object spUpdate_isEtiketka: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_isEtiketka'
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
        Name = 'inisEtiketka'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isEtiketka'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 272
  end
end
