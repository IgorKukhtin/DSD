inherited PromoSaleForm: TPromoSaleForm
  ActiveControl = edOperDate
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1086#1089#1090' '#1055#1088#1086#1076#1072#1078'>'
  ClientHeight = 716
  ClientWidth = 1540
  ExplicitWidth = 1556
  ExplicitHeight = 755
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 145
    Width = 1540
    Height = 571
    ExplicitTop = 145
    ExplicitWidth = 1540
    ExplicitHeight = 571
    ClientRectBottom = 571
    ClientRectRight = 1540
    inherited tsMain: TcxTabSheet
      Caption = '&1. '#1058#1086#1074#1072#1088#1099
      ExplicitWidth = 1540
      ExplicitHeight = 547
      inherited cxGrid: TcxGrid
        Width = 1540
        Height = 366
        ExplicitWidth = 1540
        ExplicitHeight = 366
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPlanMinWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPlanMaxWeight
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
              Column = AmountRetInWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealPromoWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReal_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight_diff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPlanMinWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPlanMaxWeight
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
              Column = AmountRetInWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealPromoWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountReal_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight_diff
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
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
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object TradeMark: TcxGridDBColumn [0]
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceTradeMark
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object GoodsName: TcxGridDBColumn [2]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn [3]
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1088#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1072#1082#1094#1080#1080')'
            Width = 90
          end
          object GoodsKindCompleteName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            DataBinding.FieldName = 'GoodsKindCompleteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindCompleteChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            Width = 85
          end
          object GoodsKindName_List: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            DataBinding.FieldName = 'GoodsKindName_List'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            Options.Editing = False
            Width = 77
          end
          object MeasureName: TcxGridDBColumn [6]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object GoodComment: TcxGridDBColumn [7]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PriceSale: TcxGridDBColumn [8]
            Caption = #1062#1077#1085#1072' '#1085#1072' '#1087#1086#1083#1082#1077', '#1075#1088#1085
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperPriceList: TcxGridDBColumn [9]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1073#1077#1079' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077' '#1073#1077#1079' '#1091#1095#1077#1090#1072' % '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1075#1086#1074#1086#1088')'
            Width = 70
          end
          object Price: TcxGridDBColumn [10]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077' ('#1076#1086#1075'.)'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1073#1077#1079' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077' '#1089' '#1091#1095#1077#1090#1086#1084' % '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1075#1086#1074#1086#1088')'
            Width = 70
          end
          object CountForPrice: TcxGridDBColumn [11]
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1094#1077#1085#1077
            Width = 55
          end
          object PriceWithOutVAT: TcxGridDBColumn [12]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithOutVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##########;-,0.##########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object PriceWithVAT: TcxGridDBColumn [13]
            Caption = #1089' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##########;-,0.##########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object AmountReal: TcxGridDBColumn [14]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountReal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRealWeight: TcxGridDBColumn [15]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' '#1042#1077#1089
            DataBinding.FieldName = 'AmountRealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRealPromo: TcxGridDBColumn [16]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' ('#1072#1082#1094#1080#1103')'
            DataBinding.FieldName = 'AmountRealPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRealPromoWeight: TcxGridDBColumn [17]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' ('#1072#1082#1094#1080#1103') '#1042#1077#1089
            DataBinding.FieldName = 'AmountRealPromoWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountReal_diff: TcxGridDBColumn [18]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' ('#1085#1077' '#1072#1082#1094#1080#1103')'
            DataBinding.FieldName = 'AmountReal_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRealWeight_diff: TcxGridDBColumn [19]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076'  ('#1085#1077' '#1072#1082#1094#1080#1103') '#1042#1077#1089
            DataBinding.FieldName = 'AmountRealWeight_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRetIn: TcxGridDBColumn [20]
            Caption = #1042#1086#1079#1074#1088'. '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountRetIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRetInWeight: TcxGridDBColumn [21]
            Caption = #1042#1086#1079#1074#1088'. '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' '#1042#1077#1089
            DataBinding.FieldName = 'AmountRetInWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPlanMin: TcxGridDBColumn [22]
            Caption = #1055#1083#1072#1085' '#1084#1080#1085'.'
            DataBinding.FieldName = 'AmountPlanMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountPlanMinWeight: TcxGridDBColumn [23]
            Caption = #1055#1083#1072#1085' '#1084#1080#1085'. '#1042#1077#1089
            DataBinding.FieldName = 'AmountPlanMinWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPlanMax: TcxGridDBColumn [24]
            Caption = #1055#1083#1072#1085' '#1084#1072#1082#1089'.'
            DataBinding.FieldName = 'AmountPlanMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountPlanMaxWeight: TcxGridDBColumn [25]
            Caption = #1055#1083#1072#1085' '#1084#1072#1082#1089'. '#1042#1077#1089
            DataBinding.FieldName = 'AmountPlanMaxWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 374
        Width = 1540
        Height = 173
        Align = alBottom
        TabOrder = 1
        object cxPageControl1: TcxPageControl
          Left = 1
          Top = 1
          Width = 1193
          Height = 171
          Align = alClient
          TabOrder = 0
          Properties.ActivePage = tsPartner
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 1193
          ClientRectTop = 24
          object tsPartner: TcxTabSheet
            Caption = '2.1. '#1055#1072#1088#1090#1085#1077#1088#1099
            object cxGridPartner: TcxGrid
              Left = 0
              Top = 0
              Width = 1193
              Height = 147
              Align = alClient
              PopupMenu = pmPartner
              TabOrder = 0
              object cxGridDBTableViewPartner: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = PartnerDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsCustomize.DataRowSizing = True
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Inserting = False
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object AreaName: TcxGridDBColumn
                  Caption = #1056#1077#1075#1080#1086#1085
                  DataBinding.FieldName = 'AreaName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 70
                end
                object PartnerCode: TcxGridDBColumn
                  Caption = #1050#1086#1076
                  DataBinding.FieldName = 'PartnerCode'
                  PropertiesClassName = 'TcxCurrencyEditProperties'
                  Properties.DecimalPlaces = 0
                  Properties.DisplayFormat = '0.####;-0.####; ;'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 28
                end
                object PartnerName: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'PartnerName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = actPromoSalePartnerChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 104
                end
                object PartnerDescName: TcxGridDBColumn
                  Caption = #1069#1083#1077#1084#1077#1085#1090
                  DataBinding.FieldName = 'PartnerDescName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 58
                end
                object Juridical_Name: TcxGridDBColumn
                  Caption = #1070#1088'. '#1083#1080#1094#1086
                  DataBinding.FieldName = 'Juridical_Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 80
                end
                object Retail_Name: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100
                  DataBinding.FieldName = 'Retail_Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 80
                end
                object ContractCode: TcxGridDBColumn
                  Caption = #1050#1086#1076' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractCode'
                  PropertiesClassName = 'TcxCurrencyEditProperties'
                  Properties.DecimalPlaces = 0
                  Properties.DisplayFormat = '0.####;-0.####; ;'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 70
                end
                object RetailName_inf: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100' ('#1080#1085#1092'.)'
                  DataBinding.FieldName = 'RetailName_inf'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  HeaderHint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
                  Width = 80
                end
                object ContractName: TcxGridDBColumn
                  Caption = #8470' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = actContractChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 55
                end
                object ContractTagName: TcxGridDBColumn
                  Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractTagName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 70
                end
                object Comment: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 91
                end
                object isErased: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
                  DataBinding.FieldName = 'isErased'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 50
                end
              end
              object cxGridLevelPartner: TcxGridLevel
                GridView = cxGridDBTableViewPartner
              end
            end
          end
          object tsPromoSalePartnerList: TcxTabSheet
            Caption = '2.2. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            ImageIndex = 1
            object grPartnerList: TcxGrid
              Left = 0
              Top = 0
              Width = 1193
              Height = 147
              Align = alClient
              TabOrder = 0
              LookAndFeel.NativeStyle = True
              LookAndFeel.SkinName = 'UserSkin'
              object grtvPartnerList: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = PartnerLisrDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Editing = False
                OptionsData.Inserting = False
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object PartnerListRetailName: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100
                  DataBinding.FieldName = 'RetailName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object PartnerListJuridicalName: TcxGridDBColumn
                  Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
                  DataBinding.FieldName = 'JuridicalName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 100
                end
                object PartnerListCode: TcxGridDBColumn
                  Caption = #1050#1086#1076
                  DataBinding.FieldName = 'Code'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 38
                end
                object PartnerListName: TcxGridDBColumn
                  Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
                  DataBinding.FieldName = 'Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 182
                end
                object PartnerListAreaName: TcxGridDBColumn
                  Caption = #1056#1077#1075#1080#1086#1085
                  DataBinding.FieldName = 'AreaName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 98
                end
                object PartnerListContractCode: TcxGridDBColumn
                  Caption = #1050#1086#1076' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractCode'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 48
                end
                object PartnerListContractName: TcxGridDBColumn
                  Caption = #8470' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 48
                end
                object PartnerListContractTagName: TcxGridDBColumn
                  Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractTagName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object PartnerListIsErased: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083#1077#1085
                  DataBinding.FieldName = 'IsErased'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 47
                end
              end
              object grlPartnerList: TcxGridLevel
                GridView = grtvPartnerList
              end
            end
          end
        end
        object cxSplitter5: TcxSplitter
          Left = 1194
          Top = 1
          Width = 8
          Height = 171
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salRight
          Control = cxPageControl4
          Visible = False
        end
        object cxPageControl4: TcxPageControl
          Left = 1202
          Top = 1
          Width = 337
          Height = 171
          Align = alRight
          TabOrder = 2
          Visible = False
          Properties.ActivePage = cxTabSheetInfoMoney
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 337
          ClientRectTop = 24
          object cxTabSheetInfoMoney: TcxTabSheet
            Caption = '&5. '#1057#1090#1072#1090#1100#1080' '#1079#1072#1090#1088#1072#1090
            object cxGridInfoMoney: TcxGrid
              Left = 0
              Top = 0
              Width = 337
              Height = 147
              Align = alClient
              TabOrder = 0
              Visible = False
              object cxGridDBTableViewInfoMoney: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = InfoMoneyDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsCustomize.DataRowSizing = True
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Inserting = False
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object Name_ch5: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 162
                end
                object InfoMoneyCode_ch5: TcxGridDBColumn
                  Caption = #1050#1086#1076' '#1089#1090#1072#1090#1100#1080
                  DataBinding.FieldName = 'InfoMoneyCode'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 67
                end
                object InfoMoneyName_ch5: TcxGridDBColumn
                  Caption = #1057#1090#1072#1090#1100#1103
                  DataBinding.FieldName = 'InfoMoneyName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = actChoiceInfoMoneyMarket
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 160
                end
              end
              object cxGridLevelInfoMoney: TcxGridLevel
                GridView = cxGridDBTableViewInfoMoney
              end
            end
          end
        end
      end
      object cxSplitter4: TcxSplitter
        Left = 0
        Top = 366
        Width = 1540
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = Panel1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1540
    Height = 119
    TabOrder = 3
    ExplicitWidth = 1540
    ExplicitHeight = 119
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 18
      TabStop = False
      ExplicitLeft = 8
      ExplicitTop = 18
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 2
      ExplicitLeft = 8
      ExplicitTop = 2
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Top = 18
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      ExplicitLeft = 89
      ExplicitTop = 18
      ExplicitWidth = 88
      Width = 88
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      Top = 2
      ExplicitLeft = 89
      ExplicitTop = 2
    end
    inherited cxLabel15: TcxLabel
      Top = 38
      ExplicitTop = 38
    end
    inherited ceStatus: TcxButtonEdit
      Top = 54
      TabStop = False
      TabOrder = 11
      ExplicitTop = 54
      ExplicitWidth = 170
      ExplicitHeight = 22
      Width = 170
    end
    object cxLabel11: TcxLabel
      Left = 572
      Top = 2
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 572
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 225
    end
    object cxLabel5: TcxLabel
      Left = 195
      Top = 2
      Caption = #1040#1082#1094#1080#1103' '#1089
    end
    object deStartPromo: TcxDateEdit
      Left = 195
      Top = 18
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 81
    end
    object cxLabel6: TcxLabel
      Left = 285
      Top = 2
      Caption = #1040#1082#1094#1080#1103' '#1087#1086
    end
    object deEndPromo: TcxDateEdit
      Left = 282
      Top = 18
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 81
    end
    object cxLabel7: TcxLabel
      Left = 195
      Top = 38
      Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1089
    end
    object cxLabel8: TcxLabel
      Left = 285
      Top = 38
      Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1087#1086
    end
    object deEndSale: TcxDateEdit
      Left = 285
      Top = 54
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 83
    end
    object cxLabel9: TcxLabel
      Left = 380
      Top = 38
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1089
    end
    object deOperDateStart: TcxDateEdit
      Left = 380
      Top = 54
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 6
      Width = 87
    end
    object cxLabel10: TcxLabel
      Left = 471
      Top = 38
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1086
    end
    object deOperDateEnd: TcxDateEdit
      Left = 471
      Top = 54
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 87
    end
    object cxLabel13: TcxLabel
      Left = 572
      Top = 38
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 572
      Top = 54
      Properties.MaxLength = 255
      TabOrder = 8
      Width = 225
    end
    object cxLabel14: TcxLabel
      Left = 8
      Top = 74
      Caption = #1060#1048#1054' ('#1082#1086#1084#1084#1077#1088#1095#1077#1089#1082#1080#1081' '#1086#1090#1076#1077#1083')'
    end
    object edPersonalTrade: TcxButtonEdit
      Left = 8
      Top = 90
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Style.BorderColor = 16764159
      Style.Color = clWindow
      TabOrder = 9
      Width = 268
    end
    object cxLabel16: TcxLabel
      Left = 285
      Top = 75
      Caption = #1060#1048#1054' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1086#1090#1076#1077#1083')'
    end
    object edPersonal: TcxButtonEdit
      Left = 285
      Top = 90
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Style.BorderColor = 13041606
      TabOrder = 10
      Width = 273
    end
    object cxLabel24: TcxLabel
      Left = 572
      Top = 74
      Hint = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080' '#1044#1086#1075'.'
      Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'.'
      ParentShowHint = False
      ShowHint = True
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 572
      Top = 90
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      TabOrder = 26
      Width = 103
    end
    object cxLabel28: TcxLabel
      Left = 380
      Top = 2
      Caption = #1055#1086' '#1076#1072#1090#1077
    end
    object cbOperDateOrder_text: TcxTextEdit
      Left = 380
      Top = 18
      Properties.MaxLength = 255
      Properties.ReadOnly = True
      TabOrder = 28
      Width = 178
    end
    object cbNotBudgPromo: TcxCheckBox
      Left = 814
      Top = 55
      Caption = #1042#1085#1077' '#1073#1102#1076#1078#1077#1090#1072
      TabOrder = 29
      Width = 94
    end
    object cxLabel30: TcxLabel
      Left = 814
      Top = 2
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1042#1085#1077' '#1073#1102#1076#1078#1077#1090#1072
    end
    object edNotBudgPromo: TcxButtonEdit
      Left = 814
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 183
    end
    object deStartSale: TcxDateEdit
      Left = 195
      Top = 54
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 32
      Width = 81
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 139
    Top = 360
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 288
  end
  inherited ActionList: TActionList
    Left = 239
    Top = 191
    object actInsertRecordInfoMoney: TInsertRecord [0]
      Category = 'InfoMoney'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewInfoMoney
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090'>'
      ImageIndex = 0
    end
    object actPromoDiscountKindChoiceForm: TOpenChoiceForm [1]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actPromoDiscountKindChoiceForm'
      FormName = 'TPromoDiscountKindForm'
      FormNameParam.Value = 'TPromoDiscountKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoDiscountKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoDiscountKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actErasedInfoMoney: TdsdUpdateErased [2]
      Category = 'InfoMoney'
      MoveParams = <>
      StoredProc = spErasedInfoMoney
      StoredProcList = <
        item
          StoredProc = spErasedInfoMoney
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = InfoMoneyDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090'> ?'
    end
    object actunErasedInfoMoney: TdsdUpdateErased [3]
      Category = 'InfoMoney'
      MoveParams = <>
      StoredProc = spUnErasedInfoMoney
      StoredProcList = <
        item
          StoredProc = spUnErasedInfoMoney
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = InfoMoneyDS
    end
    object actChoiceInfoMoneyMarket: TOpenChoiceForm [4]
      Category = 'InfoMoney'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceInfoMoney'
      FormName = 'TInfoMoney_ObjectDescForm'
      FormNameParam.Value = 'TInfoMoney_ObjectDescForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = InfoMoneyCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = InfoMoneyCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inDescCode'
          Value = 'zc_Movement_InfoMoney'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindOutChoiceForm: TOpenChoiceForm [5]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindOutChoiceForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_out'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_out'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsOutChoiceForm: TOpenChoiceForm [6]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsOutChoiceForm'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId_out'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode_out'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName_out'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDSInfoMoney: TdsdUpdateDataSet [7]
      Category = 'InfoMoney'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_PromoSaleInfoMoney
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_PromoSaleInfoMoney
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = InfoMoneyDS
    end
    object actChoiceTradeMark: TOpenChoiceForm [8]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceTradeMark'
      FormName = 'TTradeMarkForm'
      FormNameParam.Value = 'TTradeMarkForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TradeMarkId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TradeMarkName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceGoodsGroupPropertyP: TOpenChoiceForm [9]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoodsGroupPropertyP'
      FormName = 'TGoodsGroupProperty_ObjectForm'
      FormNameParam.Value = 'TGoodsGroupProperty_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyId_Parent'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyName_Parent'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceGoodsGroupDirection: TOpenChoiceForm [10]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoodsGroupDirection'
      FormName = 'TGoodsGroupDirectionForm'
      FormNameParam.Value = 'TGoodsGroupDirectionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupDirectionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupDirectionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceGoodsGroupPropertyParent: TOpenChoiceForm [11]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoodsGroupProperty'
      FormName = 'TGoodsGroupProperty_ObjectForm'
      FormNameParam.Value = 'TGoodsGroupProperty_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyId_Parent'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyName_Parent'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupPropertyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupPropertyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyName'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_Movement_isTaxPromo: TdsdExecStoredProc [12]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = #1047#1072#1084#1077#1085#1080#1090#1100' % '#1057#1082#1080#1076#1082#1080' <=> % '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      Hint = #1047#1072#1084#1077#1085#1080#1090#1100' % '#1057#1082#1080#1076#1082#1080' <=> % '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      ImageIndex = 27
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1084#1077#1085#1080#1090#1100' % '#1057#1082#1080#1076#1082#1080' <=> % '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
    end
    object actRefreshCalc: TdsdDataSetRefresh [13]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInfoMoneyProtocolOpenForm: TdsdOpenForm [14]
      Category = 'InfoMoney'
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1057#1090#1072#1090#1100#1080' '#1079#1072#1090#1088#1072#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1086' '#1057#1090#1072#1090#1100#1080' '#1079#1072#1090#1088#1072#1090'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = InfoMoneyCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = InfoMoneyCDS
          ComponentItem = 'InfoMoneyName_CostPromo'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefresh_Get: TdsdDataSetRefresh [15]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdateCalcDS2: TdsdUpdateDataSet [16]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end
        item
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdateCalcDS'
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Movement_PromoSalePartner
        end
        item
          StoredProc = spSelect_MovementItem_PromoSalePartner
        end>
    end
    inherited actMISetErased: TdsdUpdateErased
      Category = 'Goods'
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 0
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'> ?'
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Category = 'Goods'
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 0
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
        end>
    end
    object actPrint_Calc: TdsdPrintAction [22]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088' - '#1089#1082#1080#1076#1082#1072
      ImageIndex = 15
      DataSets = <
        item
          UserName = 'frxHead'
          IndexFieldNames = 'GoodsName;Num'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = ''
          Component = edComment
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CommentMain'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo_Condition'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.Value = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Calc2: TdsdPrintAction [23]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088' - % '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      ImageIndex = 15
      DataSets = <
        item
          UserName = 'frxHead'
          IndexFieldNames = 'GoodsName;Num'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = ''
          Component = edComment
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CommentMain'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo_Condition'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.Value = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Movement_PromoSalePartner
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelect
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelect_Movement_PromoSale_Print
      StoredProcList = <
        item
          StoredProc = spSelect_Movement_PromoSale_Print
        end>
      DataSets = <
        item
          DataSet = PrintHead
          UserName = 'frxHead'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = Null
          Component = edComment
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1094#1080#1103
      ReportNameParam.Value = #1040#1082#1094#1080#1103
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1058#1086#1074#1072#1088'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1058#1086#1074#1072#1088'>'
    end
    object actPartnerProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1086' '#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGoodsKindChoiceForm: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
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
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TradeMarkName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindCompleteChoiceForm: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindCompleteChoiceForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecord: TInsertRecord
      Category = 'Goods'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ImageIndex = 0
    end
    object InsertRecordTM: TInsertRecord
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actChoiceTradeMark
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072'>'
      ImageIndex = 0
    end
    object InsertRecordGGPP: TInsertRecord
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actChoiceGoodsGroupPropertyParent
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1040#1085#1072#1083#1080#1090#1080#1082#1072'-1>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1040#1085#1072#1083#1080#1090#1080#1082#1072'-1>'
      ImageIndex = 0
    end
    object actInsertRecordPartner: TInsertRecord
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewPartner
      Action = actPromoSalePartnerChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      ImageIndex = 0
    end
    object actErasedPartner: TdsdUpdateErased
      Category = 'Partner'
      MoveParams = <>
      StoredProc = spErasedMIPartner
      StoredProcList = <
        item
          StoredProc = spErasedMIPartner
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = PartnerDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1055#1072#1088#1090#1085#1077#1088#1072'> ?'
    end
    object actUnErasedPartner: TdsdUpdateErased
      Category = 'Partner'
      MoveParams = <>
      StoredProc = spUnErasedMIPartner
      StoredProcList = <
        item
          StoredProc = spUnErasedMIPartner
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = PartnerDS
    end
    object actPromoSalePartnerChoiceForm: TOpenChoiceForm
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenChoiceForm1'
      FormName = 'TPromoPartnerForm'
      FormNameParam.Value = 'TPromoPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Juridical_Name'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Juridical_Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail_Name'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Retail_Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDSPartner: TdsdUpdateDataSet
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIPartner
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIPartner
        end
        item
          StoredProc = spUpdate_PromoSalePartner_ChangePercent
        end>
      Caption = 'actUpdateMainDS'
      DataSource = PartnerDS
    end
    object actContractChoiceForm: TOpenChoiceForm
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPartnerListRefresh: TdsdDataSetRefresh
      Category = 'Partner'
      MoveParams = <>
      Enabled = False
      StoredProc = spSelect_MovementItem_PromoSalePartner
      StoredProcList = <
        item
          StoredProc = spSelect_MovementItem_PromoSalePartner
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object mactAddAllPartner: TMultiAction
      Category = 'Partner'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceRetailForm
        end
        item
          Action = actInsertUpdate_Movement_PromoSalePartnerFromRetail
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1093' <'#1055#1072#1088#1090#1085#1077#1088#1086#1074'> '#1080' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1074#1089#1077#1093' '#1082#1086#1085 +
        #1090#1088#1072#1075#1077#1085#1090#1086#1074' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' <'#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080'> ?'
      InfoAfterExecute = 
        #1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' <'#1055#1072#1088#1090#1085#1077#1088#1099'> '#1091#1076#1072#1083#1077#1085#1099' '#1080' '#1076#1086#1073#1072#1074#1083#1077#1085#1099' '#1042#1057#1045' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' <'#1058#1086#1088#1075#1086 +
        #1074#1086#1081' '#1089#1077#1090#1080'>'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1089#1077#1093' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1086#1074' '#1076#1083#1103' <'#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1089#1077#1093' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1086#1074' '#1076#1083#1103' <'#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080'>'
      ImageIndex = 74
    end
    object actChoiceRetailForm: TOpenChoiceForm
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceRetailForm'
      FormName = 'TRetailForm'
      FormNameParam.Value = 'TRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'RetailId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertUpdate_Movement_PromoSalePartnerFromRetail: TdsdExecStoredProc
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Movement_PromoSalePartnerFromRetail
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Movement_PromoSalePartnerFromRetail
        end>
      Caption = 'actInsertUpdate_Movement_PromoSalePartnerFromRetail'
    end
    object actUpdateChangePercent: TdsdUpdateDataSet
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIPartner
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIPartner
        end>
      Caption = 'actUpdateChangePercent'
      DataSource = PartnerDS
    end
    object macChangePercent: TMultiAction
      Category = 'Partner'
      MoveParams = <>
      ActionList = <
        item
          Action = actChangePercentDialog
        end
        item
          Action = actUpdateChangePercent
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' (-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' (-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
      ImageIndex = 43
    end
    object actChangePercentDialog: TExecuteDialog
      Category = 'Partner'
      MoveParams = <>
      Caption = 'actChangePercentDialog'
      FormName = 'TChangePercentDialogForm'
      FormNameParam.Value = 'TChangePercentDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inChangePercent'
          Value = Null
          Component = edChangePercent
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object InsertRecordGGP: TInsertRecord
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actChoiceGoodsGroupProperty
      Params = <>
      Caption = '9'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1040#1085#1072#1083#1080#1090#1080#1082#1072' 2>'
      ImageIndex = 0
    end
    object InsertRecordGD: TInsertRecord
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actChoiceGoodsGroupDirection
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077'>'
      ImageIndex = 0
    end
    object actChoiceGoodsGroupProperty: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoodsGroupProperty'
      FormName = 'TGoodsGroupPropertyForm'
      FormNameParam.Value = 'TGoodsGroupPropertyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParentId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyId_Parent'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParentName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupPropertyName_Parent'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 256
  end
  inherited MasterCDS: TClientDataSet
    Top = 272
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoSaleGoods'
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
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Top = 272
  end
  inherited BarManager: TdxBarManager
    Top = 271
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbInsertRecord'
        end
        item
          Visible = True
          ItemName = 'bsGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordPartner'
        end
        item
          Visible = True
          ItemName = 'bsPartner'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChangePercent'
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
    inherited dxBarStatic: TdxBarStatic
      Caption = '  '
      Hint = ' '
      ShowCaption = False
    end
    inherited bbShowAll: TdxBarButton
      Visible = ivNever
    end
    inherited bbStatic: TdxBarStatic
      Caption = '  '
      Hint = '  '
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbInsertRecordPartner: TdxBarButton
      Action = actInsertRecordPartner
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actErasedPartner
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUnErasedPartner
      Category = 0
    end
    object bbInsertCondition: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Visible = ivAlways
      ImageIndex = 0
    end
    object dxBarButton6: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 46
    end
    object dxBarButton7: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object dxBarButton8: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Visible = ivAlways
      ImageIndex = 0
    end
    object dxBarButton9: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 46
    end
    object dxBarButton10: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object dxBarButton11: TdxBarButton
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' + '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Category = 0
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' + '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Visible = ivAlways
      ImageIndex = 45
    end
    object dxBarButton12: TdxBarButton
      Action = mactAddAllPartner
      Category = 0
    end
    object bbPartnerProtocol: TdxBarButton
      Action = actPartnerProtocolOpenForm
      Category = 0
    end
    object bbPartnerListProtocol: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bsGoods: TdxBarSubItem
      Caption = #1058#1086#1074#1072#1088
      Category = 0
      Visible = ivAlways
      ItemLinks = <
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
          ItemName = 'bbMovementItemProtocol'
        end>
    end
    object bsPartner: TdxBarSubItem
      Caption = #1055#1072#1088#1090#1085#1077#1088
      Category = 0
      Visible = ivAlways
      ItemLinks = <
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
          ItemName = 'bbPartnerProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end>
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChangePercent: TdxBarButton
      Action = macChangePercent
      Category = 0
    end
    object bbsInfoMoney: TdxBarSubItem
      Caption = #1057#1090#1072#1090#1100#1080' '#1079#1072#1090#1088#1072#1090
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbErasedInfoMoney'
        end
        item
          Visible = True
          ItemName = 'bbunErasedInfoMoney'
        end
        item
          Visible = True
          ItemName = 'bbInfoMoneyProtocolOpen'
        end>
    end
    object bbErasedInfoMoney: TdxBarButton
      Action = actErasedInfoMoney
      Category = 0
    end
    object bbInsertRecordInfoMoney: TdxBarButton
      Action = actInsertRecordInfoMoney
      Category = 0
    end
    object bbunErasedInfoMoney: TdxBarButton
      Action = actunErasedInfoMoney
      Category = 0
    end
    object bbInfoMoneyProtocolOpen: TdxBarButton
      Action = actInfoMoneyProtocolOpenForm
      Category = 0
    end
    object ddsUpdate: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object Separator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbInsertRecordTM: TdxBarButton
      Action = InsertRecordTM
      Category = 0
    end
    object bb: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      Visible = ivAlways
      ImageIndex = 35
    end
    object dxBarButton1: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Category = 0
      Enabled = False
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Visible = ivAlways
      ImageIndex = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    Left = 70
    Top = 337
  end
  inherited PopupMenu: TPopupMenu
    Left = 16
    Top = 552
    object N2: TMenuItem [0]
      Action = InsertRecord
    end
    object N3: TMenuItem [1]
      Action = actMISetErased
    end
    object N4: TMenuItem [2]
      Action = actMISetUnErased
    end
    object N5: TMenuItem [3]
      Caption = '-'
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
        Name = 'TotalSumm'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'isComplete_PromoStateKind'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = 'False'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 392
  end
  inherited StatusGuides: TdsdGuides
    Left = 152
    Top = 240
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_PromoSale'
    Left = 48
    Top = 24
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PromoSale'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = False
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
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
        Name = 'PriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = Null
        Component = deStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = Null
        Component = deEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartSale'
        Value = Null
        Component = deStartSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndSale'
        Value = Null
        Component = deEndSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateStart'
        Value = Null
        Component = deOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = Null
        Component = deOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeName'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull'
        Value = Null
        Component = FormParams
        ComponentItem = 'InvNumberFull'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateOrder_text'
        Value = Null
        Component = cbOperDateOrder_text
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotBudgPromo'
        Value = Null
        Component = cbNotBudgPromo
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'NotBudgPromoId'
        Value = Null
        Component = GuidesNotBudgPromo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NotBudgPromoName'
        Value = Null
        Component = GuidesNotBudgPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 192
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoSale'
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
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartPromo'
        Value = Null
        Component = deStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = Null
        Component = deEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartSale'
        Value = Null
        Component = deStartSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSale'
        Value = Null
        Component = deEndSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateStart'
        Value = Null
        Component = deOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = Null
        Component = deOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotBudgPromo'
        Value = Null
        Component = cbNotBudgPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNotBudgPromoId'
        Value = Null
        Component = GuidesNotBudgPromo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 18
    Top = 192
  end
  inherited GuidesFiller: TGuidesFiller
    Left = 192
    Top = 272
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = deStartPromo
      end
      item
        Control = deEndPromo
      end
      item
        Control = deEndSale
      end
      item
        Control = deOperDateStart
      end
      item
        Control = deOperDateEnd
      end
      item
        Control = edPriceList
      end
      item
        Control = edPersonalTrade
      end
      item
        Control = edPersonal
      end
      item
        Control = edComment
      end
      item
        Control = cbNotBudgPromo
      end
      item
        Control = edNotBudgPromo
      end>
    Left = 256
    Top = 265
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 56
    Top = 416
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PromoSale_SetErased'
    Left = 374
    Top = 192
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PromoSale_SetUnErased'
    Left = 462
    Top = 200
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoSaleGoods'
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
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPriceList'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceSale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithOutVAT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceWithOutVAT'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithVAT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceWithVAT'
        DataType = ftFloat
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
        Name = 'inAmountReal'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountReal'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountRealWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountRealWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlanMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlanMinWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMinWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlanMax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlanMaxWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMaxWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsKindCompleteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindCompleteId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindCompleteName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindCompleteName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTradeMarkName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TradeMarkName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 248
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 384
    Top = 368
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Left = 636
    Top = 196
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 652
    Top = 16
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TPersonal_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 108
    Top = 56
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TPersonalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 316
    Top = 80
  end
  object spSelect_Movement_PromoSalePartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoSalePartner'
    DataSet = PartnerCDS
    DataSets = <
      item
        DataSet = PartnerCDS
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
    Left = 336
    Top = 416
  end
  object PartnerCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 120
    Top = 512
  end
  object PartnerDS: TDataSource
    DataSet = PartnerCDS
    Left = 192
    Top = 520
  end
  object spErasedMIPartner: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoSalePartner_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 502
    Top = 256
  end
  object spUnErasedMIPartner: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoSalePartner_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 582
    Top = 224
  end
  object spInsertUpdateMIPartner: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoSalePartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailName_inf'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'RetailName_inf'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListName'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalMarketingId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalMarketingName'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalTradeName'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 272
  end
  object dsdDBViewAddOnPartner: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPartner
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 238
    Top = 337
  end
  object pmPartner: TPopupMenu
    Images = dmMain.ImageList
    Left = 72
    Top = 552
    object MenuItem1: TMenuItem
      Action = actInsertRecordPartner
    end
    object MenuItem2: TMenuItem
      Action = actErasedPartner
    end
    object MenuItem3: TMenuItem
      Action = actUnErasedPartner
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object MenuItem5: TMenuItem
      Action = actRefresh
    end
  end
  object PrintHead: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 944
    Top = 304
  end
  object spSelect_Movement_PromoSale_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoSale_Print'
    DataSet = PrintHead
    DataSets = <
      item
        DataSet = PrintHead
      end>
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
    Left = 832
    Top = 232
  end
  object PartnerListCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 272
    Top = 520
  end
  object PartnerLisrDS: TDataSource
    DataSet = PartnerListCDS
    Left = 336
    Top = 536
  end
  object spSelect_MovementItem_PromoSalePartner: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoSalePartner'
    DataSet = PartnerListCDS
    DataSets = <
      item
        DataSet = PartnerListCDS
      end>
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
    Left = 144
    Top = 448
  end
  object dsdDBViewAddOnPartnerList: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = grtvPartnerList
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 446
    Top = 553
  end
  object spInsertUpdate_Movement_PromoSalePartnerFromRetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoSalePartnerFromRetail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = FormParams
        ComponentItem = 'RetailId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1118
    Top = 352
  end
  object spInsertUpdate_MI_Param: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PromoSale_Param'
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
    Left = 1112
    Top = 272
  end
  object cxEditRepository1: TcxEditRepository
    Left = 688
    Top = 464
    object cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem
      Properties.DisplayFormat = ',0.## %;-,0.## %'
    end
    object cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
    end
  end
  object spUpdate_Movement_ChangePercent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_PromoSale_ChangePercent'
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
        Name = 'inChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 656
  end
  object spUpdate_PromoSalePartner_ChangePercent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_PromoSalePartner_ChangePercent'
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
        Name = 'outChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 616
  end
  object InfoMoneyDS: TDataSource
    DataSet = InfoMoneyCDS
    Left = 984
    Top = 624
  end
  object InfoMoneyCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 920
    Top = 624
  end
  object dsdDBViewAddOnInfoMoney: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewInfoMoney
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1024
    Top = 599
  end
  object spSelect_PromoInfoMoney: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoSaleInfoMoney'
    DataSet = InfoMoneyCDS
    DataSets = <
      item
        DataSet = InfoMoneyCDS
      end>
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
    Left = 960
    Top = 584
  end
  object spInsertUpdate_PromoSaleInfoMoney: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoSaleInfoMoney'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = InfoMoneyCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = InfoMoneyCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescId'
        Value = Null
        Component = InfoMoneyCDS
        ComponentItem = 'DescId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 888
    Top = 592
  end
  object spErasedInfoMoney: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoSaleInfoMoney_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = InfoMoneyCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = InfoMoneyCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 622
    Top = 664
  end
  object spUnErasedInfoMoney: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoSaleInfoMoney_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = InfoMoneyCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = InfoMoneyCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 726
    Top = 664
  end
  object spInsertUpdateMIMaster_out: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoSaleGoods'
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
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPriceList'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceSale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithOutVAT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceWithOutVAT'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithVAT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceWithVAT'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceTender'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceTender'
        DataType = ftFloat
        ParamType = ptInput
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
        Name = 'inAmountReal'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountReal'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountRealWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountRealWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlanMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlanMinWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMinWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlanMax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlanMaxWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMaxWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTaxRetIn'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TaxRetIn'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountMarket'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountMarket'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummOutMarket'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummOutMarket'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummInMarket'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummInMarket'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsKindCompleteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindCompleteId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindCompleteName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindCompleteName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoDiscountKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PromoDiscountKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTradeMarkId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TradeMarkId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupPropertyId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupPropertyId_Parent'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupDirectionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupDirectionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTradeMarkName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TradeMarkName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsGroupPropertyName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupPropertyName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsGroupPropertyName_Parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupPropertyName_Parent'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsGroupDirectionName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupDirectionName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 368
  end
  object GuidesNotBudgPromo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edNotBudgPromo
    FormNameParam.Value = 'TNotBudgPromoForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TNotBudgPromoForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesNotBudgPromo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesNotBudgPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 940
    Top = 24
  end
end
