inherited ReturnInForm: TReturnInForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1074#1089#1077')>'
  ClientHeight = 645
  ClientWidth = 1304
  ExplicitWidth = 1320
  ExplicitHeight = 684
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 195
    Width = 1304
    Height = 450
    ExplicitTop = 195
    ExplicitWidth = 1304
    ExplicitHeight = 450
    ClientRectBottom = 450
    ClientRectRight = 1304
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1304
      ExplicitHeight = 426
      inherited cxGrid: TcxGrid
        Width = 1304
        Height = 288
        ExplicitWidth = 1304
        ExplicitHeight = 288
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
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSummVat
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChildDiff
              Sorted = True
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_find
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
              Column = Price
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSummVat
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChildDiff
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_find
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn [3]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object GoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PartionGoods: TcxGridDBColumn [5]
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object MeasureName: TcxGridDBColumn [6]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsRealCode: TcxGridDBColumn [7]
            Caption = #1050#1086#1076' '#1090#1086#1074'.('#1092#1072#1082#1090' '#1086#1090#1075#1088')'
            DataBinding.FieldName = 'GoodsRealCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074'.('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            Options.Editing = False
            Width = 74
          end
          object GoodsRealName: TcxGridDBColumn [8]
            Caption = #1058#1086#1074#1072#1088' ('#1092#1072#1082#1090' '#1086#1090#1075#1088')'
            DataBinding.FieldName = 'GoodsRealName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            Options.Editing = False
            Width = 78
          end
          object GoodsKindRealName: TcxGridDBColumn [9]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1086#1090#1075#1088')'
            DataBinding.FieldName = 'GoodsKindRealName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            Options.Editing = False
            Width = 89
          end
          object Amount_find: TcxGridDBColumn [10]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083'.'#1086#1089#1085#1086#1074#1072#1085#1080#1077')'
            DataBinding.FieldName = 'Amount_find'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076' '#1086#1089#1085#1086#1074#1072#1085#1080#1077' '#1074#1086#1079#1074#1088#1072#1090' '#1085#1072' '#1089#1082#1083#1072#1076')'
            Options.Editing = False
            Width = 60
          end
          object Amount: TcxGridDBColumn [11]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object AmountPartner: TcxGridDBColumn [12]
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Count: TcxGridDBColumn [13]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AmountChild: TcxGridDBColumn [14]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1074#1103#1079#1082#1072')'
            DataBinding.FieldName = 'AmountChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object AmountChildDiff: TcxGridDBColumn [15]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1079#1085#1080#1094#1072')'
            DataBinding.FieldName = 'AmountChildDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object ChangePercent: TcxGridDBColumn [16]
            Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Price: TcxGridDBColumn [17]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object PriceIn: TcxGridDBColumn [18]
            Caption = #1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'. ('#1089#1093#1077#1084#1072' '#1055#1072#1074#1080#1083#1100#1086#1085#1099')'
            Options.Editing = False
            Width = 70
          end
          object PricePromo: TcxGridDBColumn [19]
            Caption = #1062#1077#1085#1072' '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'PricePromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Price_Pricelist: TcxGridDBColumn [20]
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price_Pricelist'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Price_Pricelist_vat: TcxGridDBColumn [21]
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price_Pricelist_vat'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isCheck_Pricelist: TcxGridDBColumn [22]
            Caption = #1054#1096#1080#1073#1082#1072' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'isCheck_Pricelist'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object AmountSumm: TcxGridDBColumn [23]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object AmountSummVat: TcxGridDBColumn [24]
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'AmountSummVat'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object PartionMovementName: TcxGridDBColumn [25]
            Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'PartionMovementName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actSaleJournalChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 145
          end
          object MovementPromo: TcxGridDBColumn [26]
            Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'MovementPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object CountForPrice: TcxGridDBColumn [27]
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Value5: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073
            DataBinding.FieldName = 'Value5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object Value10: TcxGridDBColumn
            Caption = #1082#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073' - '#1074#1090#1086#1088#1086#1081' '#1089#1088#1086#1082
            DataBinding.FieldName = 'Value10'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object SubjectDocName: TcxGridDBColumn
            Caption = #1054#1089#1085'. '#1076#1083#1103' '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'SubjectDocName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
            Options.Editing = False
            Width = 136
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 296
        Width = 1304
        Height = 130
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = childAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = childAmountPartner
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = childAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = childAmountPartner
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object isError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object childGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object childGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 209
          end
          object childGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object childAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1080#1074#1103#1079#1082#1072')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object childAmountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object childPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ChangePercent_Sale: TcxGridDBColumn
            Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'.'
            DataBinding.FieldName = 'ChangePercent_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MovementPromo_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'MovementPromo_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DescName_Sale: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'DescName_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'InvNumber'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceSale
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InvNumber_Master: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumber_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumberPartner_Master: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDate_Master: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ContractCode_Sale: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ContractCode_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object ContractName_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ContractName_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object ContractCode_Tax: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'ContractCode_Tax'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object ContractName_Tax: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'ContractName_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object DocumentTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'DocumentTaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 160
          end
          object FromName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ToCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ToCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MovementId_sale: TcxGridDBColumn
            Caption = 'Id1'
            DataBinding.FieldName = 'MovementId_sale'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object MovementItemId_sale: TcxGridDBColumn
            Caption = 'Id2'
            DataBinding.FieldName = 'MovementItemId_sale'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 288
        Width = 1304
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
    object cxTabSheetTaxCorrective: TcxTabSheet
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
      ImageIndex = 2
      object l: TcxGrid
        Left = 0
        Top = 0
        Width = 1304
        Height = 426
        Align = alClient
        TabOrder = 0
        object lDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = TaxCorrectiveDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummMVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummPVAT
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummMVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummPVAT
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colStatus: TcxGridDBColumn
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
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colIsError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'IsError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'TaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clincInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object clincInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object colInvNumberPartner_Child: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Child'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actTaxJournalChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object colOperDate_Child: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object colPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object colOKPO_From: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_From'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object colPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object colVATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colTotalSummVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colTotalSummMVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummMVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colTotalSummPVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummPVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object colContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colChecked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object colDocument: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085
            DataBinding.FieldName = 'Document'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 29
          end
          object colIsEDI: TcxGridDBColumn
            Caption = 'EXITE'
            DataBinding.FieldName = 'isEDI'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object colIsElectron: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088'.'
            DataBinding.FieldName = 'isElectron'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object colIsMedoc: TcxGridDBColumn
            Caption = #1052#1077#1076#1086#1082
            DataBinding.FieldName = 'IsMedoc'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
        end
        object lLevel: TcxGridLevel
          GridView = lDBTableView
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086
      ImageIndex = 2
      object cxGridDetail: TcxGrid
        Left = 0
        Top = 0
        Width = 1304
        Height = 288
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableViewDetail: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS_Reason
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch2
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch2
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName_ch2
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object ord: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'ord'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object GoodsGroupNameFull_ch2: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_ch2: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName_ch2: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 182
          end
          object GoodsKindName_ch2: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MeasureName_ch2: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount_ch2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SubjectDocCode_ch2: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1086#1089#1085'.'#1076#1083#1103' '#1074#1086#1079#1074'.'
            DataBinding.FieldName = 'SubjectDocCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object SubjectDocName_ch2: TcxGridDBColumn
            Caption = #1054#1089#1085'.'#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'SubjectDocName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actSubjectDocChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
            Width = 124
          end
          object ReasonCode_ch2: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' ('#1082#1086#1076')'
            DataBinding.FieldName = 'ReasonCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object ReasonName_ch2: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'ReasonName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReasonOpenForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 124
          end
          object ReturnKindName_ch2: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'ReturnKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReturnKindOpenForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 159
          end
          object isErased_ch2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object Value5_ch2: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073
            DataBinding.FieldName = 'Value5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object Value10_ch2: TcxGridDBColumn
            Caption = #1082#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073' - '#1074#1090#1086#1088#1086#1081' '#1089#1088#1086#1082
            DataBinding.FieldName = 'Value10'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object StartDate_ch2: TcxGridDBColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object EndDate_ch2: TcxGridDBColumn
            Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086
            DataBinding.FieldName = 'EndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridLevelDetail: TcxGridLevel
          GridView = cxGridDBTableViewDetail
        end
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 296
        Width = 1304
        Height = 130
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS_Reason
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_ch3
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner_ch3
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object isError_ch3: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsCode_ch3: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName_ch3: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 209
          end
          object GoodsKindName_ch3: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object Amount_ch3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1080#1074#1103#1079#1082#1072')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object AmountPartner_ch3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Price_ch3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ChangePercent_Sale_ch3: TcxGridDBColumn
            Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'.'
            DataBinding.FieldName = 'ChangePercent_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MovementPromo_Sale_ch3: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'MovementPromo_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DescName_Sale_ch3: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'DescName_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumber_ch3: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'InvNumber'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceSale
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InvNumberPartner_ch3: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InvNumber_Master_ch3: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumber_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumberPartner_Master_ch3: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate_ch3: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDatePartner_ch3: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDate_Master_ch3: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ContractCode_Sale_ch3: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ContractCode_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object ContractName_Sale_ch3: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ContractName_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object ContractCode_Tax_ch3: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'ContractCode_Tax'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object ContractName_Tax_ch3: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'ContractName_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object DocumentTaxKindName_ch3: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'DocumentTaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 160
          end
          object FromName_ch3: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ToCode_ch3: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ToCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ToName_ch3: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object JuridicalName_ch3: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MovementId_sale_ch3: TcxGridDBColumn
            Caption = 'Id1'
            DataBinding.FieldName = 'MovementId_sale'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object MovementItemId_sale_ch3: TcxGridDBColumn
            Caption = 'Id2'
            DataBinding.FieldName = 'MovementItemId_sale'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object isErased_ch3: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 288
        Width = 1304
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid2
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1304
    Height = 169
    TabOrder = 3
    ExplicitWidth = 1304
    ExplicitHeight = 169
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Properties.ReadOnly = False
      ExplicitLeft = 8
      ExplicitWidth = 114
      Width = 114
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 212
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 212
    end
    inherited cxLabel2: TcxLabel
      Left = 212
      Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
      ExplicitLeft = 212
      ExplicitWidth = 71
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      Caption = '*'#1057#1090#1072#1090#1091#1089
      ExplicitTop = 45
      ExplicitWidth = 46
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      TabOrder = 8
      ExplicitTop = 63
      ExplicitWidth = 114
      ExplicitHeight = 22
      Width = 114
    end
    object cxLabel3: TcxLabel
      Left = 496
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edTo: TcxButtonEdit
      Left = 496
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 132
    end
    object edFrom: TcxButtonEdit
      Left = 320
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 170
    end
    object cxLabel4: TcxLabel
      Left = 320
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edContract: TcxButtonEdit
      Left = 759
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 98
    end
    object cxLabel9: TcxLabel
      Left = 759
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel6: TcxLabel
      Left = 635
      Top = 5
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 635
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 118
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 320
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 128
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 450
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 450
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 496
      Top = 63
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 132
    end
    object cxLabel8: TcxLabel
      Left = 496
      Top = 45
      Caption = '(-)% '#1057#1082#1080#1076' (+)% '#1053#1072#1094
    end
    object edOperDatePartner: TcxDateEdit
      Left = 213
      Top = 63
      EditValue = 42181d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 13
      Width = 100
    end
    object cxLabel10: TcxLabel
      Left = 212
      Top = 45
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
    end
    object edIsChecked: TcxCheckBox
      Left = 631
      Top = 45
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 22
      Width = 118
    end
    object edPriceList: TcxButtonEdit
      Left = 761
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 96
    end
    object cxLabel11: TcxLabel
      Left = 761
      Top = 85
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object cxLabel12: TcxLabel
      Left = 123
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 123
      Top = 23
      TabOrder = 14
      Width = 84
    end
    object edInvNumberMark: TcxTextEdit
      Left = 123
      Top = 63
      TabOrder = 26
      Width = 84
    end
    object cxLabel13: TcxLabel
      Left = 123
      Top = 45
      Caption = #8470' '#1079'.'#1084'.'
    end
    object cxLabel20: TcxLabel
      Left = 865
      Top = 5
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object edContractTag: TcxButtonEdit
      Left = 865
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 29
      Width = 97
    end
    object cxLabel19: TcxLabel
      Left = 320
      Top = 85
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#8470' ('#1087#1088#1086#1076#1072#1078#1072')'
    end
    object edInvNumberSale: TcxButtonEdit
      Left = 320
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 171
    end
    object cxLabel18: TcxLabel
      Left = 867
      Top = 85
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 867
      Top = 103
      TabOrder = 33
      Width = 97
    end
    object cxLabel21: TcxLabel
      Left = 8
      Top = 85
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#8470' ('#1074#1086#1079#1074#1088#1072#1090' '#1085#1072' '#1089#1082#1083#1072#1076')'
    end
    object edInvNumberParent: TcxButtonEdit
      Left = 8
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 35
      Width = 199
    end
    object cbPartner: TcxCheckBox
      Left = 213
      Top = 103
      Hint = #1040#1082#1090' '#1085#1077#1076#1086#1074#1086#1079#1072
      Caption = #1040#1082#1090' '#1085#1077#1076#1086#1074#1086#1079#1072
      Properties.ReadOnly = False
      TabOrder = 36
      Width = 100
    end
    object edJuridicalFrom: TcxButtonEdit
      Left = 321
      Top = 41
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 37
      Visible = False
      Width = 64
    end
    object edReestrKind: TcxButtonEdit
      Left = 1115
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 38
      Width = 144
    end
    object cxLabel26: TcxLabel
      Left = 1115
      Top = 45
      Caption = #1042#1080#1079#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
    end
    object cbPrinted: TcxCheckBox
      Left = 631
      Top = 81
      Caption = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1085' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 40
      Width = 128
    end
    object cxLabel28: TcxLabel
      Left = 1115
      Top = 130
      Caption = #1058#1080#1087' '#1074#1086#1079#1074#1088#1072#1090#1072
      Visible = False
    end
    object edReturnKind: TcxButtonEdit
      Left = 1115
      Top = 145
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 42
      Visible = False
      Width = 144
    end
    object cxLabel29: TcxLabel
      Left = 720
      Top = 127
      Caption = #1055#1088#1072#1081#1089' '#1074#1093'.'
    end
    object edPriceListIn: TcxButtonEdit
      Left = 720
      Top = 145
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 44
      Width = 137
    end
    object cxLabel30: TcxLabel
      Left = 319
      Top = 130
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
    end
    object edSubjectDoc: TcxButtonEdit
      Left = 320
      Top = 145
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 46
      Width = 381
    end
    object cbisWeighing_inf: TcxCheckBox
      Left = 213
      Top = 145
      Hint = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' '#1076#1072'/'#1085#1077#1090
      Caption = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 47
      Width = 100
    end
    object edParPartnerValue: TcxCurrencyEdit
      Left = 1044
      Top = 103
      EditValue = 1.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Properties.ReadOnly = False
      TabOrder = 48
      Width = 68
    end
    object cxLabel32: TcxLabel
      Left = 1044
      Top = 85
      Caption = #1053#1086#1084#1080#1085#1072#1083
    end
  end
  object edDocumentTaxKind: TcxButtonEdit [2]
    Left = 867
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 97
  end
  object cxLabel5: TcxLabel [3]
    Left = 867
    Top = 45
    Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
  end
  object cxLabel14: TcxLabel [4]
    Left = 1044
    Top = 45
    Caption = #1042#1072#1083'.'#1094#1077#1085#1072
  end
  object edCurrencyDocument: TcxButtonEdit [5]
    Left = 1044
    Top = 63
    Hint = #1042#1072#1083#1102#1090#1072' ('#1094#1077#1085#1072')'
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 9
    Width = 68
  end
  object cxLabel16: TcxLabel [6]
    Left = 970
    Top = 85
    Caption = #1050#1091#1088#1089
  end
  object edCurrencyPartnerValue: TcxCurrencyEdit [7]
    Left = 970
    Top = 103
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    Properties.ReadOnly = False
    TabOrder = 11
    Width = 68
  end
  object cxLabel17: TcxLabel [8]
    Left = 970
    Top = 45
    Caption = #1042#1072#1083'.'#1087#1086#1082'.'
  end
  object edCurrencyPartner: TcxButtonEdit [9]
    Left = 970
    Top = 63
    Hint = #1042#1072#1083#1102#1090#1072' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 13
    Width = 68
  end
  object cbCalcAmountPartner: TcxCheckBox [10]
    Left = 497
    Top = 97
    Caption = #1056#1072#1089#1095#1077#1090' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
    Properties.ReadOnly = False
    State = cbsChecked
    TabOrder = 14
    Width = 215
  end
  object cbPromo: TcxCheckBox [11]
    Left = 631
    Top = 64
    Caption = #1040#1082#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 102
  end
  object edStartDateTax: TcxDateEdit [12]
    Left = 761
    Top = 62
    EditValue = 42181d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 16
    Width = 96
  end
  object cxLabel22: TcxLabel [13]
    Left = 761
    Top = 45
    Caption = #1053#1072#1095'. '#1076#1072#1090#1072' '#1087#1088#1086#1076#1072#1078
  end
  object cbList: TcxCheckBox [14]
    Left = 497
    Top = 114
    Caption = #1087#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1054#1089#1085#1086#1074'. '#8470' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 18
    Width = 204
  end
  object cxLabel23: TcxLabel [15]
    Left = 1115
    Top = 5
    Caption = #1042#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
  end
  object edMember: TcxButtonEdit [16]
    Left = 1115
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 144
  end
  object cxLabel24: TcxLabel [17]
    Left = 1115
    Top = 85
    Caption = #1060#1048#1054' ('#1084#1086#1073'. '#1072#1075#1077#1085#1090')'
  end
  object edMemberInsertName: TcxButtonEdit [18]
    Left = 1115
    Top = 103
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 144
  end
  object cxLabel25: TcxLabel [19]
    Left = 970
    Top = 5
    Caption = #1069#1082#1089#1087#1077#1076#1080#1090#1086#1088' ('#1079#1072#1103#1074#1082#1072')'
  end
  object edMemberExp: TcxButtonEdit [20]
    Left = 970
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 142
  end
  object cxLabel31: TcxLabel [21]
    Left = 8
    Top = 127
    Caption = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099
  end
  object edInvNumberOrderReturnTare: TcxButtonEdit [22]
    Left = 8
    Top = 145
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 199
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 448
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = actAddMask
        Properties.Strings = (
          'Caption'
          'Category'
          'Hint'
          'ImageIndex'
          'InfoAfterExecute'
          'MoveParams'
          'Name'
          'QuestionBeforeExecute'
          'SecondaryShortCuts'
          'ShortCut'
          'StoredProc'
          'StoredProcList'
          'TabSheet'
          'Tag')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 64
    Top = 408
  end
  inherited ActionList: TActionList
    Left = 31
    Top = 248
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end
        item
          StoredProc = spSelectTaxCorrective
        end
        item
          StoredProc = spSelectDetail
        end
        item
          StoredProc = spSelect_MI_Child_reason
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    inherited actMISetUnErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end>
    end
    object actOpenReportCheckAmountForm: TdsdOpenForm [7]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1074' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1074' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      ImageIndex = 26
      FormName = 'TReport_CheckAmount_ReturnInToSaleForm'
      FormNameParam.Value = 'TReport_CheckAmount_ReturnInToSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportCheckForm: TdsdOpenForm [8]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      ImageIndex = 24
      FormName = 'TReport_Check_ReturnInToSaleForm'
      FormNameParam.Value = 'TReport_Check_ReturnInToSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportForm: TdsdOpenForm [9]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 25
      FormName = 'TReport_Goods_SalebyReturnInForm'
      FormNameParam.Value = 'TReport_Goods_SalebyReturnInForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = Null
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = Null
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = 'False'
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = Null
          Component = GuidesJuridicalFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = Null
          Component = GuidesJuridicalFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = 'False'
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Name = 'inGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPrice'
          Value = 0.000000000000000000
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractId'
          Value = Null
          Component = GuidesContract
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractName'
          Value = Null
          Component = GuidesContract
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Name = 'inGoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenTax: TdsdOpenForm [10]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      ImageIndex = 26
      FormName = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'DocumentChildId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate_Child'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenTaxCorrective: TdsdOpenForm [11]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 1
      FormName = 'TTaxCorrectiveForm'
      FormNameParam.Value = 'TTaxCorrectiveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateTaxCorrectiveDS: TdsdUpdateDataSet [12]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpUpdateTaxCorrective
      StoredProcList = <
        item
          StoredProc = gpUpdateTaxCorrective
        end>
      Caption = 'actUpdateTaxCorrectiveDS'
      DataSource = TaxCorrectiveDS
    end
    object actUpdateDetailDS: TdsdUpdateDataSet [14]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild
        end
        item
          StoredProc = spSelect_MI_Child
        end>
      Caption = 'actUpdateDetailDS'
      DataSource = DetailDS
    end
    object actUnCompleteTaxCorrective: TdsdChangeMovementStatus [15]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementUnCompleteTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementUnCompleteTaxCorrective
        end
        item
          StoredProc = spSelectTaxCorrective
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = TaxCorrectiveDS
    end
    object actSetErasedTaxCorrective: TdsdChangeMovementStatus [16]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementSetErasedTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementSetErasedTaxCorrective
        end
        item
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 13
      Status = mtDelete
      DataSource = TaxCorrectiveDS
    end
    object actCompleteTaxCorrective: TdsdChangeMovementStatus [17]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementCompleteTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementCompleteTaxCorrective
        end
        item
          StoredProc = spSelectTaxCorrective
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 12
      Status = mtComplete
      DataSource = TaxCorrectiveDS
    end
    object actPrintAkt: TdsdPrintAction [18]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintAkt
      StoredProcList = <
        item
          StoredProc = spSelectPrintAkt
        end>
      Caption = #1040#1082#1090' '#1074#1086#1079#1074#1088#1072#1090#1072
      Hint = #1040#1082#1090' '#1074#1086#1079#1074#1088#1072#1090#1072
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAkt'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReturnInAkt'
      ReportNameParam.Name = #1040#1082#1090' '#1074#1086#1079#1074#1088#1072#1090#1072
      ReportNameParam.Value = 'PrintMovement_ReturnInAkt'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_TaxCorrective'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportName'
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_TaxCorrective_Us: TdsdPrintAction [20]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Us
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Us
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ReportNameParam.Value = 'PrintMovement_TaxCorrective'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_TaxCorrective_Client: TdsdPrintAction [21]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1082#1083#1080#1077#1085#1090#1091')'
      ReportNameParam.Value = 'PrintMovement_TaxCorrective'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object macUpdateMovementSubjectDoc: TMultiAction [23]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenSubjectDocForm
        end
        item
          Action = actUpdateMovementSubjectDoc
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
      ImageIndex = 80
    end
    object macMemberOpenForm: TMultiAction [24]
      Category = 'Member'
      MoveParams = <>
      ActionList = <
        item
          Action = actMemberOpenForm
        end
        item
          Action = actUpdateMovementMember
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
      ImageIndex = 55
    end
    object actUpdateMovementSubjectDoc: TdsdExecStoredProc [25]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovementSubjectDoc
      StoredProcList = <
        item
          StoredProc = spUpdateMovementSubjectDoc
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
      ImageIndex = 80
    end
    object actOpenSubjectDocForm: TOpenChoiceForm [26]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
      ImageIndex = 80
      FormName = 'TSubjectDocForm'
      FormNameParam.Value = 'TSubjectDocForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = ''
          Component = GuidesSubjectDoc
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = ''
          Component = GuidesSubjectDoc
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macContractOpenForm: TMultiAction [27]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actContractOpenForm
        end
        item
          Action = actUpdateMovementContract
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#8470' '#1076#1086#1075#1086#1074#1086#1088#1072' ('#1074' '#1079#1072#1082#1088#1099#1090#1086#1084' '#1087#1077#1088#1080#1086#1076#1077')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#8470' '#1076#1086#1075#1086#1074#1086#1088#1072' ('#1074' '#1079#1072#1082#1088#1099#1090#1086#1084' '#1087#1077#1088#1080#1086#1076#1077')'
      ImageIndex = 43
    end
    object actContractOpenForm: TOpenChoiceForm [28]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      ImageIndex = 43
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MasterJuridicalId'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
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
          Name = 'ContractTagName'
          Value = Null
          Component = GuidesContractTag
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateMovementMember: TdsdExecStoredProc [29]
      Category = 'Member'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovementMember
      StoredProcList = <
        item
          StoredProc = spUpdateMovementMember
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
    end
    object mactPrintAkt: TMultiAction [30]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrintAkt
        end>
      Caption = #1040#1082#1090' '#1074#1086#1079#1074#1088#1072#1090#1072
      Hint = #1040#1082#1090' '#1074#1086#1079#1074#1088#1072#1090#1072
      ImageIndex = 15
    end
    object actUpdateMovementContract: TdsdExecStoredProc [31]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovementContract
      StoredProcList = <
        item
          StoredProc = spUpdateMovementContract
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
    end
    object mactPrintPriceCorr: TMultiAction [32]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintProcNamePriceCorr
        end
        item
          Action = actPrint
        end>
      Caption = #1050#1054#1056#1045#1043#1059#1070#1063#1040' '#1058#1054#1042#1040#1056#1053#1040' '#1053#1040#1050#1051#1040#1044#1053#1040
      Hint = #1050#1054#1056#1045#1043#1059#1070#1063#1040' '#1058#1054#1042#1040#1056#1053#1040' '#1053#1040#1050#1051#1040#1044#1053#1040
      ImageIndex = 16
    end
    object mactPrint: TMultiAction [33]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintProcName
        end
        item
          Action = actPrint
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      ShortCut = 16464
    end
    object actPrint_ReturnIn_by_TaxCorrective: TdsdPrintAction [34]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' ('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081' '#1082' '#1082#1086#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072#1084')'
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103' ('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081' '#1082' '#1082#1086#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072#1084')'
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReturnIn_By_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1082#1083#1080#1077#1085#1090#1091')'
      ReportNameParam.Value = 'PrintMovement_ReturnIn_By_TaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actTaxJournalChoice: TOpenChoiceForm [38]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TaxJournalSelectForm'
      FormName = 'TTaxJournalChoiceForm'
      FormNameParam.Value = 'TTaxJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'DocumentChildId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'InvNumberPartner_Child'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate_Tax'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate_Child'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'FromId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'PartnerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object MIChildProtocolOpenForm: TdsdOpenForm [39]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1088#1080#1074#1103#1079#1082#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1088#1080#1074#1103#1079#1082#1080'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      TabSheet = tsMain
    end
    inherited actAddMask: TdsdExecStoredProc
      TabSheet = tsMain
    end
    object actSPPrintProcNamePriceCorr: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNamePriceCorr
      StoredProcList = <
        item
          StoredProc = spGetReportNamePriceCorr
        end>
      Caption = 'actSPPrintProcName'
    end
    object actSPPrintProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName
      StoredProcList = <
        item
          StoredProc = spGetReportName
        end>
      Caption = 'actSPPrintProcName'
    end
    object actTaxCorrective: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTaxCorrective
      StoredProcList = <
        item
          StoredProc = spTaxCorrective
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>'
      ImageIndex = 41
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089 +
        ' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>?'
      InfoAfterExecute = 
        #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088 +
        #1080#1074#1103#1079#1082#1086#1081')>.'
    end
    object actCorrective: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCorrective
      StoredProcList = <
        item
          StoredProc = spCorrective
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>'
      ImageIndex = 42
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073 +
        #1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>?'
      InfoAfterExecute = 
        #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' ' +
        #1087#1088#1080#1074#1103#1079#1082#1080')>.'
    end
    object actSubjectDocChoiceForm: TOpenChoiceForm
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actSubjectDocChoice'
      FormName = 'TSubjectDocForm'
      FormNameParam.Value = 'TSubjectDocForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'SubjectDocId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'SubjectDocCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'SubjectDocName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReasonId'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReasonId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReasonName'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReasonName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actSaleJournalChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TSaleJournalChoiceForm'
      FormName = 'TSaleJournalChoiceForm'
      FormNameParam.Value = 'TSaleJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionMovementName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Partion'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsChoice'
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
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
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
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupNameFull'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TGoodsKind_ObjectForm'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
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
    object actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNameTaxCorrective
      StoredProcList = <
        item
          StoredProc = spGetReportNameTaxCorrective
        end>
    end
    object mactPrint_TaxCorrective_Client: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxCorrectiveProcName
        end
        item
          Action = actPrint_TaxCorrective_Client
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
    end
    object mactPrint_TaxCorrective_Us: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxCorrectiveProcName
        end
        item
          Action = actPrint_TaxCorrective_Us
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
    end
    object actUpdateAmountPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_ReturnIn_AmountPartner
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_ReturnIn_AmountPartner
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1091#1083#1080#1090#1100' '#1087#1086' '#1074#1089#1077#1084#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'"'
      Hint = #1054#1073#1085#1091#1083#1080#1090#1100' '#1087#1086' '#1074#1089#1077#1084#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'"'
      ImageIndex = 39
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1073#1085#1091#1083#1080#1090#1100' '#1087#1086' '#1074#1089#1077#1084#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077 +
        #1083#1103'"?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'" '#1086#1073#1085#1091#1083#1077#1085#1086' '#1087#1086' '#1074#1089#1077#1084#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1091
    end
    object actUpdatePrice: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spUpdate_MI_ReturnIn_Price
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1087#1088#1072#1081#1089#1072
      Hint = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1087#1088#1072#1081#1089#1072
      ImageIndex = 44
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1080#1089#1087#1088#1072#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1087#1088#1072#1081#1089#1072'?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1094#1077#1085' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1087#1088#1072#1081#1089#1072'.'
    end
    object actChoiceSale_reason: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Report_Goods_SalebyReturnIn_ChoiceForm'
      FormName = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.Name = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.Value = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'MovementId_sale'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementItemId'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'MovementItemId_sale'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsId'
          Value = Null
          Component = DetailDS_Reason
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          Component = DetailDS_Reason
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPrice'
          Value = Null
          Component = DetailDS_Reason
          ComponentItem = 'Price'
          DataType = ftFloat
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
        end
        item
          Name = 'inContractName'
          Value = ''
          Component = GuidesContract
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindId'
          Value = Null
          Component = DetailDS_Reason
          ComponentItem = 'GoodsKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindName'
          Value = Null
          Component = DetailDS_Reason
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindName'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToCode'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'ToCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberPartner'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'InvNumberPartner'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartner'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'OperDatePartner'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberPartner_Master'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'InvNumberPartner_Master'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate_Master'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'OperDate_Master'
          DataType = ftDateTime
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountPartner'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'AmountPartner'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'Price'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Master'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'InvNumber_Master'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxKindName'
          Value = Null
          Component = ChildCDS_Reason
          ComponentItem = 'DocumentTaxKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateAuto: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAuto
      StoredProcList = <
        item
          StoredProc = spUpdateAuto
        end
        item
          StoredProc = spSelect_MI_Child
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>'
      ImageIndex = 7
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>.'
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actChoiceSale: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Report_Goods_SalebyReturnIn_ChoiceForm'
      FormName = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.Name = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.Value = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'MovementId_sale'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementItemId'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'MovementItemId_sale'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Name = 'inGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
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
        end
        item
          Name = 'inContractName'
          Value = ''
          Component = GuidesContract
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindId'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = GuidesJuridicalFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToCode'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ToCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberPartner'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'InvNumberPartner'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartner'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'OperDatePartner'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberPartner_Master'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'InvNumberPartner_Master'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate_Master'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'OperDate_Master'
          DataType = ftDateTime
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountPartner'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'AmountPartner'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Master'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'InvNumber_Master'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxKindName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'DocumentTaxKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actMemberOpenForm: TOpenChoiceForm
      Category = 'Member'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
      ImageIndex = 55
      FormName = 'TMemberPosition_ObjectForm'
      FormNameParam.Value = 'TMemberPosition_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = ''
          Component = GuidesMember
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = ''
          Component = GuidesMember
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterPositionId'
          Value = '8466'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSPSavePrintState: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSavePrintState
      StoredProcList = <
        item
          StoredProc = spSavePrintState
        end>
      Caption = 'actSPSavePrintState'
    end
    object actOpenSale_child: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072'>'
      ImageIndex = 24
      FormName = 'TSaleForm'
      FormNameParam.Value = 'TSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'MovementId_sale'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrinted'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenTax_child: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      ImageIndex = 26
      FormName = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'MovementId_tax'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'OperDate_Master'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReasonOpenForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ReasonForm'
      FormName = 'TReasonForm'
      FormNameParam.Value = 'TReasonForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReasonId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReasonName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReasonCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReturnKindId'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReturnKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReturnKindName'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReturnKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactUpdateMaskSend: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendJournalChoiceMasc
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      ImageIndex = 59
    end
    object actReturnKindOpenForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ReturnKindForm'
      FormName = 'TReturnKindForm'
      FormNameParam.Value = 'TReturnKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReturnKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS_Reason
          ComponentItem = 'ReturnKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDetailDS_Reason: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIDetail
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIDetail
        end
        item
          StoredProc = spSelectDetail
        end>
      Caption = 'actUpdateDetailDS'
      DataSource = DetailDS_Reason
    end
    object actUpdateMask: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMask
      StoredProcList = <
        item
          StoredProc = spUpdateMask
        end>
      Caption = 'actUpdateMask'
    end
    object mactUpdateMaskSale: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaleJournalChoiceMasc
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 30
    end
    object actSendJournalChoiceMasc: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'SendJournalChoice'
      FormName = 'TSendJournalChoiceForm'
      FormNameParam.Value = 'TSendJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGet_checkopen_Sale: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      AfterAction = actOpenSale_child
      PostDataSetBeforeExecute = False
      StoredProc = spGet_checkopen_Sale
      StoredProcList = <
        item
          StoredProc = spGet_checkopen_Sale
        end>
      Caption = 'actGet_checkopen_Sale'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072'>'
      ImageIndex = 24
    end
    object actGet_checkopen_Tax: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      AfterAction = actOpenTax_child
      PostDataSetBeforeExecute = False
      StoredProc = spGet_checkopen_Tax
      StoredProcList = <
        item
          StoredProc = spGet_checkopen_Tax
        end>
      Caption = 'actGet_checkopen_Sale'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      ImageIndex = 26
    end
    object actInsert_MI_byOrderReturnTare: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI_byOrderReturnTare
      StoredProcList = <
        item
          StoredProc = spInsert_MI_byOrderReturnTare
        end>
      Caption = 'actInsert_MI_byOrderReturnTare'
    end
    object actSaleJournalChoiceMasc: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'SaleJournalChoice'
      FormName = 'TSaleJournalChoiceForm'
      FormNameParam.Value = 'TSaleJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 24
    Top = 384
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 464
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ReturnIn'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = '0'
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 231
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbCorrective'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdatePrice'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbContractOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMemberOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMovementSubjectDoc'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountPartner'
        end
        item
          Visible = True
          ItemName = 'bbCompleteTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbUnCompleteTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaskSale'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaskSend'
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
          ItemName = 'bbGet_checkopen_Sale'
        end
        item
          Visible = True
          ItemName = 'bbGet_checkopen_Tax'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportForm'
        end
        item
          Visible = True
          ItemName = 'bbReportCheck'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportCheckAmount'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenTax'
        end
        item
          Visible = True
          ItemName = 'bbOpenTaxCorrective'
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
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbPrintPriceCorr'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Return_By_TaxCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTaxCorrective_Client'
        end
        item
          Visible = True
          ItemName = 'bbPrintTaxCorrective_Us'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintAkt'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocol'
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
    inherited bbPrint: TdxBarButton
      Action = mactPrint
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
    end
    object bbTaxCorrective: TdxBarButton
      Action = actTaxCorrective
      Category = 0
    end
    object bbCorrective: TdxBarButton
      Action = actCorrective
      Category = 0
    end
    object bbPrintTaxCorrective_Client: TdxBarButton
      Action = mactPrint_TaxCorrective_Client
      Category = 0
    end
    object bbPrintTaxCorrective_Us: TdxBarButton
      Action = mactPrint_TaxCorrective_Us
      Category = 0
    end
    object bbPrint_Return_By_TaxCorrective: TdxBarButton
      Action = actPrint_ReturnIn_by_TaxCorrective
      Category = 0
    end
    object bbCompleteTaxCorrective: TdxBarButton
      Action = actCompleteTaxCorrective
      Category = 0
    end
    object bbSetErasedTaxCorrective: TdxBarButton
      Action = actSetErasedTaxCorrective
      Category = 0
    end
    object bbUnCompleteTaxCorrective: TdxBarButton
      Action = actUnCompleteTaxCorrective
      Category = 0
    end
    object bbCalcAmountPartner: TdxBarControlContainerItem
      Caption = #1056#1072#1089#1095#1077#1090' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Category = 0
      Hint = #1056#1072#1089#1095#1077#1090' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Visible = ivAlways
      Control = cbCalcAmountPartner
    end
    object bbOpenTaxCorrective: TdxBarButton
      Action = actOpenTaxCorrective
      Category = 0
    end
    object bbUpdatePrice: TdxBarButton
      Action = actUpdatePrice
      Category = 0
    end
    object bbPrintPriceCorr: TdxBarButton
      Action = mactPrintPriceCorr
      Category = 0
    end
    object bbUpdateAmountPartner: TdxBarButton
      Action = actUpdateAmountPartner
      Category = 0
    end
    object bbOpenTax: TdxBarButton
      Action = actOpenTax
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actUpdateAuto
      Category = 0
    end
    object bbReportCheck: TdxBarButton
      Action = actOpenReportCheckForm
      Category = 0
    end
    object bbOpenReportCheckAmount: TdxBarButton
      Action = actOpenReportCheckAmountForm
      Category = 0
    end
    object bbMIChildProtocol: TdxBarButton
      Action = MIChildProtocolOpenForm
      Category = 0
    end
    object bbContractOpenForm: TdxBarButton
      Action = macContractOpenForm
      Category = 0
    end
    object bbMemberOpenForm: TdxBarButton
      Action = macMemberOpenForm
      Category = 0
    end
    object bbPrintAkt: TdxBarButton
      Action = actPrintAkt
      Category = 0
    end
    object bbGet_checkopen_Sale: TdxBarButton
      Action = actGet_checkopen_Sale
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072'>'
      Category = 0
    end
    object bbGet_checkopen_Tax: TdxBarButton
      Action = actGet_checkopen_Tax
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      Category = 0
    end
    object bbUpdateMovementSubjectDoc: TdxBarButton
      Action = macUpdateMovementSubjectDoc
      Category = 0
    end
    object bbUpdateMaskSale: TdxBarButton
      Action = mactUpdateMaskSale
      Category = 0
    end
    object bbUpdateMaskSend: TdxBarButton
      Action = mactUpdateMaskSend
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColumnEnterList = <
      item
        Column = GoodsName
      end
      item
        Column = Amount
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 4
      end>
    Left = 582
    Top = 345
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportName'
        Value = 'PrintMovement_ReturnInAkt'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTaxCorrective'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 240
  end
  inherited StatusGuides: TdsdGuides
    Tag = 123
    Left = 56
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ReturnIn'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateSale'
        Value = Null
        Component = edStartDateTax
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberExpName'
        Value = Null
        Component = GuidesMemberExp
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 24
    Top = 48
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnIn'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberMark'
        Value = ''
        Component = edInvNumberMark
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentId'
        Value = Null
        Component = GuidesParentChoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Parent'
        Value = Null
        Component = GuidesParentChoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerValue'
        Value = 0.000000000000000000
        Component = edCurrencyPartnerValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParPartnerValue'
        Value = Null
        Component = edParPartnerValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = GuidesContractTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyDocumentId'
        Value = ''
        Component = GuidesCurrencyDocument
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyDocumentName'
        Value = ''
        Component = GuidesCurrencyDocument
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerId'
        Value = ''
        Component = GuidesCurrencyPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerName'
        Value = ''
        Component = GuidesCurrencyPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Checked'
        Value = False
        Component = edIsChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = '0'
        Component = PriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentTaxKindId'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentTaxKindName'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Partion'
        Value = Null
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionMovementName'
        Value = Null
        Component = GuidesSaleChoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDateTax'
        Value = Null
        Component = edStartDateTax
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isList'
        Value = Null
        Component = cbList
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_From'
        Value = Null
        Component = GuidesJuridicalFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_From'
        Value = Null
        Component = GuidesJuridicalFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReestrKindName'
        Value = Null
        Component = edReestrKind
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberInsertName'
        Value = Null
        Component = edMemberInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPrinted'
        Value = Null
        Component = cbPrinted
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberExpId'
        Value = Null
        Component = GuidesMemberExp
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberExpName'
        Value = Null
        Component = GuidesMemberExp
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReasonId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReasonName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnKindId'
        Value = Null
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnKindName'
        Value = Null
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListInId'
        Value = Null
        Component = GuidesPriceListIn
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListInName'
        Value = Null
        Component = GuidesPriceListIn
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocId'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocName'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isWeighing_inf'
        Value = Null
        Component = cbisWeighing_inf
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_OrderReturnTare'
        Value = Null
        Component = GuidesOrderReturnTare
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_OrderReturnTare'
        Value = Null
        Component = GuidesOrderReturnTare
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 264
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ReturnIn'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberMark'
        Value = ''
        Component = edInvNumberMark
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = GuidesParentChoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = False
        Component = edIsChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = Null
        Component = cbList
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = GuidesPaidKind
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
      end
      item
        Name = 'inCurrencyDocumentId'
        Value = ''
        Component = GuidesCurrencyDocument
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyPartnerId'
        Value = ''
        Component = GuidesCurrencyPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCurrencyPartnerValue'
        Value = Null
        Component = edCurrencyPartnerValue
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioParPartnerValue'
        Value = Null
        Component = edParPartnerValue
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderReturnTare'
        Value = Null
        Component = GuidesOrderReturnTare
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 328
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 264
    Top = 264
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edInvNumberPartner
      end
      item
        Control = edInvNumberMark
      end
      item
        Control = edOperDate
      end
      item
        Control = edOperDatePartner
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
        Control = edChangePercent
      end
      item
        Control = edPaidKind
      end
      item
        Control = edContract
      end
      item
        Control = edContractTag
      end
      item
        Control = edIsChecked
      end
      item
        Control = edDocumentTaxKind
      end
      item
        Control = edCurrencyDocument
      end
      item
        Control = edCurrencyPartner
      end
      item
        Control = edCurrencyPartnerValue
      end
      item
        Control = edCurrencyPartnerValue
      end
      item
        Control = edParPartnerValue
      end
      item
        Control = cbPartner
      end
      item
        Control = edInvNumberParent
      end
      item
        Control = ceComment
      end
      item
        Control = cbList
      end
      item
        Control = edInvNumberOrderReturnTare
      end
      item
        Control = edReturnKind
      end>
    Left = 376
    Top = 305
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 560
    Top = 288
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ReturnIn_SetErased'
    Left = 694
    Top = 344
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ReturnIn_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ReturnIn'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
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
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPartner'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalcAmountPartner'
        Value = Null
        Component = cbCalcAmountPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSummVat'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSummVat'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PartionTop'
        Value = Null
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PartionMI'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Partion'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
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
        Name = 'inAssetId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId_Partion'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Partion'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartionMovementName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionMovementName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementPromo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementPromo'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberExpName'
        Value = Null
        Component = GuidesMemberExp
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPricePromo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PricePromo'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsRealCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsRealName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindRealName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindRealName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 392
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ReturnIn'
    Params = <
      item
        Name = 'ioId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
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
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPartner'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalcAmountPartner'
        Value = Null
        Component = cbCalcAmountPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PartionTop'
        Value = Null
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PartionMI'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Partion'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
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
        Name = 'inAssetId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId_Partion'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Partion'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartionMovementName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionMovementName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementPromo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementPromo'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPricePromo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PricePromo'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsRealCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsRealName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindRealName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindRealName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 312
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 788
    Top = 276
  end
  object RefreshDispatcher: TRefreshDispatcher
    CheckIdParam = True
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
        Component = PriceListGuides
      end
      item
        Component = GuidesParentChoice
      end>
    Left = 464
    Top = 360
  end
  object spSelectPrintTaxCorrective_Us: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisClientCopy'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 250
    Top = 442
  end
  object spSelectPrintTaxCorrective_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisClientCopy'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 426
    Top = 458
  end
  object spCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId_inf'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateTax'
        Value = Null
        Component = edStartDateTax
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxLink'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindId'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 308
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 469
    Top = 294
  end
  object GuidesDocumentTaxKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentTaxKind
    FormNameParam.Value = 'TDocumentTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 888
    Top = 48
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    Key = '0'
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = PriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = GuidesCurrencyDocument
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = GuidesCurrencyDocument
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 788
    Top = 64
  end
  object spTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId_inf'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateTax'
        Value = Null
        Component = edStartDateTax
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxLink'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindId'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = ''
        Component = GuidesDocumentTaxKind
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 336
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        DataType = ftString
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
      end>
    Left = 816
    Top = 65531
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 444
    Top = 258
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnIn_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 322
    Top = 274
  end
  object spGetReportName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnIn_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTypeName'
        Value = 'zc_Movement_ReturnIn'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_ReturnIn_ReportName'
        Value = 'PrintMovement_TaxCorrective'
        Component = FormParams
        ComponentItem = 'ReportName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 392
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 539
    Top = 4
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TContractChoicePartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoicePartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = Null
        Component = GuidesContractTag
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = GuidesContractTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 1
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
    Left = 680
    Top = 20
  end
  object GuidesCurrencyDocument: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyDocument
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyDocument
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyDocument
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1128
    Top = 288
  end
  object GuidesCurrencyPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyPartner
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyPartner
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 784
    Top = 64
  end
  object TaxCorrectiveCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 624
    Top = 274
  end
  object TaxCorrectiveDS: TDataSource
    DataSet = TaxCorrectiveCDS
    Left = 733
    Top = 266
  end
  object gpUpdateTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_DocChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'InvNumberPartner'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovement_ChildId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'DocumentChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 819
    Top = 266
  end
  object spSelectTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_DocChild'
    DataSet = TaxCorrectiveCDS
    DataSets = <
      item
        DataSet = TaxCorrectiveCDS
      end>
    Params = <
      item
        Name = 'inDocumentMasterId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 898
    Top = 266
  end
  object spMovementCompleteTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ouStatusCode'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 888
    Top = 321
  end
  object spMovementSetErasedTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 984
    Top = 281
  end
  object spMovementUnCompleteTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 289
  end
  object TaxCorrectiveViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = lDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 775
    Top = 388
  end
  object GuidesContractTag: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTag
    FormNameParam.Value = 'TContractTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContractTag
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContractTag
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 923
    Top = 12
  end
  object spGetReportNameTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TaxCorrective_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_TaxCorrective_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTaxCorrective'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 408
  end
  object GuidesSaleChoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberSale
    Key = '0'
    FormNameParam.Value = 'TSaleJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSaleJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesSaleChoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = 42005d
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 332
    Top = 72
  end
  object GuidesParentChoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberParent
    Key = '0'
    FormNameParam.Value = 'TReturnInJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReturnInJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesParentChoice
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesParentChoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 140
    Top = 40
  end
  object spUpdate_MI_ReturnIn_Price: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_ReturnIn_Price'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 408
  end
  object spGetReportNamePriceCorr: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnIn_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTypeName'
        Value = 'zc_Movement_ReturnIn_Corr'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_ReturnIn_ReportName'
        Value = 'PrintMovement_TaxCorrective'
        Component = FormParams
        ComponentItem = 'ReportName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 392
  end
  object spUpdate_MI_ReturnIn_AmountPartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_ReturnIn_AmountPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 480
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 272
    Top = 552
  end
  object DetailDS: TDataSource
    DataSet = DetailCDS
    Left = 352
    Top = 552
  end
  object spSelect_MI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemChild_ReturnIn'
    DataSet = DetailCDS
    DataSets = <
      item
        DataSet = DetailCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 544
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = 0.000000000000000000
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 222
    Top = 585
  end
  object spUpdateAuto: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_Auto'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateSale'
        Value = 42181d
        Component = edStartDateTax
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 364
  end
  object GuidesJuridicalFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalFrom
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 425
    Top = 16
  end
  object spUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ReturnIn_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Sale'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId_sale'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'MovementItemId_sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 512
  end
  object spUpdateMovementContract: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
    PackSize = 1
    Left = 114
    Top = 272
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 1178
    Top = 35
  end
  object spUpdateMovementMember: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_Member'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 946
    Top = 384
  end
  object spSavePrintState: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_Print'
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
        Name = 'inNewPrinted'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = False
        Component = cbPrinted
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 576
    Top = 464
  end
  object GuidesMemberExp: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberExp
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberExp
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberExp
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 1062
    Top = 65531
  end
  object spSelectPrintAkt: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnIn_PrintAkt'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1130
    Top = 346
  end
  object spSelectDetail: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ReturnIn_Detail'
    DataSet = DetailCDS_Reason
    DataSets = <
      item
        DataSet = DetailCDS_Reason
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1056
    Top = 352
  end
  object DBViewAddOnDetail: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewDetail
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <
      item
        Column = ReasonCode_ch2
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <
      item
        Column = Amount_ch2
      end
      item
        Column = ReasonCode_ch2
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1126
    Top = 297
  end
  object spInsertUpdateMIDetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ReturnIn_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailCDS_Reason
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = DetailCDS_Reason
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = DetailCDS_Reason
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId_top'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId'
        Value = Null
        Component = DetailCDS_Reason
        ComponentItem = 'SubjectDocId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocCode'
        Value = Null
        Component = DetailCDS_Reason
        ComponentItem = 'SubjectDocCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = DetailCDS_Reason
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 984
    Top = 536
  end
  object spInsertMaskMIDetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ReturnIn_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = DetailCDS_Reason
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = DetailCDS_Reason
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId_top'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 904
    Top = 520
  end
  object GuidesReturnKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReturnKind
    FormNameParam.Value = 'TReturnKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReturnKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReturnKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1200
    Top = 128
  end
  object DetailCDS_Reason: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    MasterFields = 'Id'
    Params = <>
    Left = 1128
    Top = 392
  end
  object DetailDS_Reason: TDataSource
    DataSet = DetailCDS_Reason
    Left = 1224
    Top = 384
  end
  object spSelect_MI_Child_reason: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemChild_ReturnIn'
    DataSet = ChildCDS_Reason
    DataSets = <
      item
        DataSet = ChildCDS_Reason
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 560
  end
  object dsdDBViewAddOn2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 758
    Top = 577
  end
  object ChildCDS_Reason: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'ParentId'
    MasterSource = DetailDS_Reason
    PacketRecords = 0
    Params = <>
    Left = 712
    Top = 552
  end
  object ChildDS_Reason: TDataSource
    DataSet = ChildCDS_Reason
    Left = 776
    Top = 552
  end
  object dsdDBViewAddOn3: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 598
    Top = 585
  end
  object spUpdateMIChild_reason: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ReturnIn_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildCDS_Reason
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS_Reason
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS_Reason
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Sale'
        Value = Null
        Component = ChildCDS_Reason
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId_sale'
        Value = Null
        Component = ChildCDS_Reason
        ComponentItem = 'MovementItemId_sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 560
  end
  object spGet_checkopen_Sale: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_checkopen'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'MovementId_sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'outFormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1267
    Top = 234
  end
  object spGet_checkopen_Tax: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_checkopen'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'MovementId_tax'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'outFormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1267
    Top = 274
  end
  object spInsert_MI_byOrderReturnTare: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_ReturnIn_byOrderReturnTare'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Order'
        Value = '0'
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 530
    Top = 272
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = edInvNumberSale
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Action = actInsert_MI_byOrderReturnTare
    Left = 704
    Top = 264
  end
  object GuidesPriceListIn: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceListIn
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceListIn
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceListIn
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 988
    Top = 80
  end
  object GuidesSubjectDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSubjectDoc
    FormNameParam.Value = 'TSubjectDocForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSubjectDocForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 128
  end
  object spUpdateMovementSubjectDoc: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_SubjectDoc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 98
    Top = 368
  end
  object GuidesOrderReturnTare: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrderReturnTare
    Key = '0'
    FormNameParam.Value = 'TOrderReturnTareJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderReturnTareJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesOrderReturnTare
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesOrderReturnTare
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 100
    Top = 112
  end
  object spUpdateMask: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ReturnIn_isMask'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId '
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementMaskId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 443
  end
end
