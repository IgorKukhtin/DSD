inherited PromoForm: TPromoForm
  ActiveControl = edOperDate
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
  ClientHeight = 599
  ClientWidth = 1204
  ExplicitWidth = 1220
  ExplicitHeight = 637
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 139
    Width = 1204
    Height = 460
    ExplicitTop = 139
    ExplicitWidth = 1204
    ExplicitHeight = 460
    ClientRectBottom = 460
    ClientRectRight = 1204
    inherited tsMain: TcxTabSheet
      Caption = '&1. '#1058#1086#1074#1072#1088#1099
      ExplicitWidth = 1204
      ExplicitHeight = 436
      inherited cxGrid: TcxGrid
        Width = 1204
        Height = 255
        ExplicitWidth = 1204
        ExplicitHeight = 255
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
              Column = AmountOrderWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountInWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRetInWeight
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
              Column = AmountOrderWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountInWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRetInWeight
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object TradeMark: TcxGridDBColumn [0]
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
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
                Action = GoodsChoiceForm
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
                Action = GoodsKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsKindCompleteName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' ('#1087#1088#1080#1084'.)'
            DataBinding.FieldName = 'GoodsKindCompleteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindCompleteChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            Width = 80
          end
          object GoodsKindName_List: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            DataBinding.FieldName = 'GoodsKindName_List'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
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
          object Amount: TcxGridDBColumn [8]
            Caption = '% '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object PriceSale: TcxGridDBColumn [9]
            Caption = #1062#1077#1085#1072' '#1085#1072' '#1087#1086#1083#1082#1077
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price: TcxGridDBColumn [10]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceWithOutVAT: TcxGridDBColumn [11]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithOutVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object PriceWithVAT: TcxGridDBColumn [12]
            Caption = #1089' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object AmountReal: TcxGridDBColumn [13]
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
          object AmountRealWeight: TcxGridDBColumn [14]
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
          object AmountRetIn: TcxGridDBColumn [15]
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
          object AmountRetInWeight: TcxGridDBColumn [16]
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
          object AmountPlanMin: TcxGridDBColumn [17]
            Caption = #1055#1083#1072#1085' '#1084#1080#1085'.'
            DataBinding.FieldName = 'AmountPlanMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountPlanMinWeight: TcxGridDBColumn [18]
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
          object AmountPlanMax: TcxGridDBColumn [19]
            Caption = #1055#1083#1072#1085' '#1084#1072#1082#1089'.'
            DataBinding.FieldName = 'AmountPlanMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountPlanMaxWeight: TcxGridDBColumn [20]
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
          object AmountOrder: TcxGridDBColumn [21]
            Caption = #1047#1072#1103#1074#1082#1072' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountOrderWeight: TcxGridDBColumn [22]
            Caption = #1047#1072#1103#1074#1082#1072' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountOrderWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountOut: TcxGridDBColumn [23]
            Caption = #1055#1088#1086#1076#1072#1085#1086' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountOutWeight: TcxGridDBColumn [24]
            Caption = #1055#1088#1086#1076#1072#1085#1086' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountOutWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountIn: TcxGridDBColumn [25]
            Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountInWeight: TcxGridDBColumn [26]
            Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountInWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clAmountPlan1: TcxGridDBColumn [27]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 1'
            DataBinding.FieldName = 'AmountPlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1079#1072' '#1087#1085'.'
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan2: TcxGridDBColumn [28]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 2'
            DataBinding.FieldName = 'AmountPlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan3: TcxGridDBColumn [29]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 3'
            DataBinding.FieldName = 'AmountPlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan4: TcxGridDBColumn [30]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 4'
            DataBinding.FieldName = 'AmountPlan4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan5: TcxGridDBColumn [31]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 5'
            DataBinding.FieldName = 'AmountPlan5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan6: TcxGridDBColumn [32]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 6'
            DataBinding.FieldName = 'AmountPlan66'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan7: TcxGridDBColumn [33]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 7'
            DataBinding.FieldName = 'AmountPlan7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 263
        Width = 1204
        Height = 173
        Align = alBottom
        TabOrder = 1
        object cxSplitter1: TcxSplitter
          Left = 660
          Top = 1
          Width = 8
          Height = 171
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salRight
          Control = cxPageControl2
        end
        object cxPageControl1: TcxPageControl
          Left = 1
          Top = 1
          Width = 659
          Height = 171
          Align = alClient
          TabOrder = 1
          Properties.ActivePage = tsPartner
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 659
          ClientRectTop = 24
          object tsPartner: TcxTabSheet
            Caption = '2.1. '#1055#1072#1088#1090#1085#1077#1088#1099
            object cxGridPartner: TcxGrid
              Left = 0
              Top = 0
              Width = 659
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
                OptionsData.CancelOnExit = False
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
                      Action = PromoPartnerChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
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
                      Action = ContractChoiceForm
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
          object tsPromoPartnerList: TcxTabSheet
            Caption = '2.2. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            ImageIndex = 1
            object grPartnerList: TcxGrid
              Left = 0
              Top = 0
              Width = 659
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
        object cxPageControl2: TcxPageControl
          Left = 668
          Top = 1
          Width = 264
          Height = 171
          Align = alRight
          TabOrder = 2
          Properties.ActivePage = tsConditionPromo
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 264
          ClientRectTop = 24
          object tsConditionPromo: TcxTabSheet
            Caption = '&3. '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072
            object cxGridConditionPromo: TcxGrid
              Left = 0
              Top = 0
              Width = 264
              Height = 147
              Align = alClient
              PopupMenu = pmCondition
              TabOrder = 0
              object grtvConditionPromo: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = ConditionPromoDS
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
                OptionsData.CancelOnExit = False
                OptionsData.Inserting = False
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object cp_Amount: TcxGridDBColumn
                  Caption = '% '#1089#1082#1080#1076#1082#1080
                  DataBinding.FieldName = 'Amount'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 50
                end
                object ConditionPromoName: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'ConditionPromoName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = ConditionPromoChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 115
                end
                object cp_Comment: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object cp_isErased: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
                  DataBinding.FieldName = 'isErased'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 50
                end
              end
              object grlConditionPromo: TcxGridLevel
                GridView = grtvConditionPromo
              end
            end
          end
        end
        object cxPageControl3: TcxPageControl
          Left = 940
          Top = 1
          Width = 263
          Height = 171
          Align = alRight
          TabOrder = 3
          Properties.ActivePage = tsAdvertising
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 263
          ClientRectTop = 24
          object tsAdvertising: TcxTabSheet
            Caption = '&4. '#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072
            object grAdvertising: TcxGrid
              Left = 0
              Top = 0
              Width = 263
              Height = 147
              Align = alClient
              PopupMenu = pmAdvertising
              TabOrder = 0
              object grtvAdvertising: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = AdvertisingDS
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
                OptionsData.CancelOnExit = False
                OptionsData.Inserting = False
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object AdvertisingCode: TcxGridDBColumn
                  Caption = #1050#1086#1076
                  DataBinding.FieldName = 'AdvertisingCode'
                  PropertiesClassName = 'TcxCurrencyEditProperties'
                  Properties.DecimalPlaces = 0
                  Properties.DisplayFormat = '0.####;-0.####; ;'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 34
                end
                object AdvertisingName: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'AdvertisingName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = AdvertisingChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 130
                end
                object CommentAdvertising: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object IsErasedAdvertising: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083'.'
                  DataBinding.FieldName = 'IsErased'
                  Visible = False
                  Width = 55
                end
              end
              object grlAdvertising: TcxGridLevel
                GridView = grtvAdvertising
              end
            end
          end
        end
        object cxSplitter3: TcxSplitter
          Left = 932
          Top = 1
          Width = 8
          Height = 171
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salRight
          Control = cxPageControl3
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 255
        Width = 1204
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = Panel1
      end
    end
    object cxTabSheetCalc: TcxTabSheet
      Caption = #1050#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088
      ImageIndex = 2
      object cxGridCalc: TcxGrid
        Left = 0
        Top = 0
        Width = 1204
        Height = 436
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = False
        object cxGridDBTableViewCalc: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = CalcDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object calcNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object calcGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object calcGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object calcPriceIn: TcxGridDBColumn
            Caption = #1057#1077#1073'-'#1090#1100' '#1087#1088#1086#1076', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object calcAmountRetIn: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'AmountRetIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object calcContractCondition: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089' '#1089#1077#1090#1080', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'ContractCondition'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object calcAmountPlanMax: TcxGridDBColumn
            Caption = #1054#1090#1075#1088'. '#1064#1090
            DataBinding.FieldName = 'AmountPlanMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object calcSummaPlanMax: TcxGridDBColumn
            Caption = #1054#1090#1075'.'#1075#1088#1085
            DataBinding.FieldName = 'SummaPlanMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object calcPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089#1086#1074#1072#1103' , '#1075#1088#1085
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 140
          end
          object calcPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 119
          end
          object calcPromoCondition: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1087#1086' '#1076#1086#1087'.'#1089#1095#1077#1090#1091', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'PromoCondition'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
          object calcSummaProfit: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100', '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Options.FilteringPopup = False
            Width = 101
          end
          object Color_PriceIn: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PriceIn'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_RetIn: TcxGridDBColumn
            DataBinding.FieldName = 'Color_RetIn'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_ContractCond: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ContractCond'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_AmountPlanMax: TcxGridDBColumn
            DataBinding.FieldName = 'Color_AmountPlanMax'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_SummaPlanMax: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummaPlanMax'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_Price: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Price'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_PriceWithVAT: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PriceWithVAT'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_PromoCond: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PromoCond'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_SummaProfit: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummaProfit'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object calcGroupNum: TcxGridDBColumn
            DataBinding.FieldName = 'GroupNum'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewCalc
        end
      end
    end
    object cxTabSheetSign: TcxTabSheet
      Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 3
      object cxGridSign: TcxGrid
        Left = 0
        Top = 0
        Width = 1204
        Height = 436
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = False
        object cxGridDBTableViewSign: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = SignDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object sgOrd: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object sgUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object sgOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1076#1077#1081#1089#1090#1074#1080#1103
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object sgIsSign: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085' ('#1044#1072'/'#1053#1077#1090')'
            DataBinding.FieldName = 'isSign'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1087#1080#1089#1072#1085' ('#1044#1072'/'#1053#1077#1090')'
            Width = 80
          end
          object sclSignInternalName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100
            DataBinding.FieldName = 'SignInternalName'
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
            Width = 278
          end
          object sclisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableViewSign
        end
      end
    end
    object cxTabSheetPlan: TcxTabSheet
      Caption = #1055#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080
      ImageIndex = 4
      object cxGridPlan: TcxGrid
        Left = 0
        Top = 0
        Width = 1204
        Height = 436
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = False
        object cxGridDBTableViewPlan: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = PlanDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan1
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan2
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan3
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan4
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan5
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan6
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan7
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan1
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan2
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan3
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan4
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan5
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan6
            end
            item
              Format = '0,###'
              Kind = skSum
              Column = AmountPlan7
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object plTradeMark: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object plGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object plGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object plGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object plGoodsKindName_List: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            DataBinding.FieldName = 'GoodsKindName_List'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object plMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object AmountPlan1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 1'
            DataBinding.FieldName = 'AmountPlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1079#1072' '#1087#1085'.'
            Width = 55
          end
          object AmountPlan2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 2'
            DataBinding.FieldName = 'AmountPlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountPlan3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 3'
            DataBinding.FieldName = 'AmountPlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountPlan4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 4'
            DataBinding.FieldName = 'AmountPlan4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountPlan5: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 5'
            DataBinding.FieldName = 'AmountPlan5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountPlan6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 6'
            DataBinding.FieldName = 'AmountPlan66'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountPlan7: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072' 7'
            DataBinding.FieldName = 'AmountPlan7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object plisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
        object cxGridLevelPlan: TcxGridLevel
          GridView = cxGridDBTableViewPlan
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1204
    Height = 113
    TabOrder = 3
    ExplicitWidth = 1204
    ExplicitHeight = 113
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
      Top = 4
      ExplicitLeft = 8
      ExplicitTop = 4
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
      Top = 4
      ExplicitLeft = 89
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Top = 38
      ExplicitTop = 38
    end
    inherited ceStatus: TcxButtonEdit
      Top = 54
      TabStop = False
      TabOrder = 16
      ExplicitTop = 54
      ExplicitWidth = 170
      ExplicitHeight = 22
      Width = 170
    end
    object cxLabel4: TcxLabel
      Left = 380
      Top = 4
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103' '
    end
    object edPromoKind: TcxButtonEdit
      Left = 380
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 178
    end
    object cxLabel11: TcxLabel
      Left = 788
      Top = 4
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 788
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 125
    end
    object cxLabel5: TcxLabel
      Left = 195
      Top = 4
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
      Left = 278
      Top = 4
      Caption = #1040#1082#1094#1080#1103' '#1087#1086
    end
    object deEndPromo: TcxDateEdit
      Left = 278
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
    object deStartSale: TcxDateEdit
      Left = 195
      Top = 54
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 81
    end
    object cxLabel8: TcxLabel
      Left = 278
      Top = 38
      Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1087#1086
    end
    object deEndSale: TcxDateEdit
      Left = 278
      Top = 54
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 8
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
      TabOrder = 9
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
      TabOrder = 10
      Width = 87
    end
    object edCostPromo: TcxCurrencyEdit
      Left = 840
      Top = 54
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = False
      Properties.UseThousandSeparator = True
      TabOrder = 12
      Width = 73
    end
    object cxLabel12: TcxLabel
      Left = 811
      Top = 38
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103
    end
    object cxLabel13: TcxLabel
      Left = 579
      Top = 38
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 579
      Top = 54
      TabOrder = 11
      Width = 257
    end
    object cxLabel14: TcxLabel
      Left = 8
      Top = 75
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
      TabOrder = 13
      Width = 268
    end
    object cxLabel16: TcxLabel
      Left = 380
      Top = 75
      Caption = #1060#1048#1054' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1086#1090#1076#1077#1083')'
    end
    object edPersonal: TcxButtonEdit
      Left = 380
      Top = 90
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 178
    end
    object edUnit: TcxButtonEdit
      Left = 579
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 202
    end
    object cxLabel17: TcxLabel
      Left = 579
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel18: TcxLabel
      Left = 579
      Top = 74
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1048#1090#1086#1075')'
    end
    object edCommentMain: TcxTextEdit
      Left = 579
      Top = 90
      TabOrder = 15
      Width = 334
    end
    object deEndReturn: TcxDateEdit
      Left = 278
      Top = 90
      Hint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1074#1086#1079#1074#1088#1072#1090#1086#1074' '#1087#1086' '#1072#1082#1094#1080#1086#1085#1085#1086#1081' '#1094#1077#1085#1077
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 34
      Width = 83
    end
    object cxLabel3: TcxLabel
      Left = 278
      Top = 74
      Caption = #1042#1086#1079#1074#1088#1072#1090#1099' '#1087#1086
    end
    object cbChecked: TcxCheckBox
      Left = 1019
      Top = 54
      Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 36
      Width = 136
    end
    object cbPromo: TcxCheckBox
      Left = 1019
      Top = 18
      Hint = #1045#1089#1083#1080' '#1044#1072' - '#1101#1090#1086' '#1040#1082#1094#1080#1103', '#1053#1077#1090' - '#1058#1077#1085#1076#1077#1088#1099
      Caption = #1040#1082#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 37
      Width = 103
    end
    object cxLabel20: TcxLabel
      Left = 918
      Top = 38
      Caption = #1044#1072#1090#1072' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
    end
    object deCheck: TcxDateEdit
      Left = 918
      Top = 54
      Hint = #1044#1072#1090#1072' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 39
      Width = 97
    end
  end
  object deMonthPromo: TcxDateEdit [2]
    Left = 918
    Top = 18
    EditValue = 43070d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.EditFormat = 'dd.mm.yyyy'
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 97
  end
  object cxLabel19: TcxLabel [3]
    Left = 918
    Top = 4
    Caption = #1052#1077#1089#1103#1094' '#1072#1082#1094#1080#1080
  end
  object cxLabel21: TcxLabel [4]
    Left = 919
    Top = 74
    Caption = #1045#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
  end
  object edstrSign: TcxTextEdit [5]
    Left = 919
    Top = 90
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 125
  end
  object edstrSignNo: TcxTextEdit [6]
    Left = 1048
    Top = 90
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 128
  end
  object cxLabel22: TcxLabel [7]
    Left = 1048
    Top = 74
    Caption = #1054#1078#1080#1076#1072#1077#1090#1089#1103' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 312
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 312
  end
  inherited ActionList: TActionList
    Top = 311
    object actRefresh_Get: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_Movement_Promo_Calc: TdsdExecStoredProc [1]
      Category = 'Update_Promo_Data'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Promo_Calc
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Promo_Calc
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' ('#1082#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088')'
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' ('#1082#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088')'
    end
    object mactUpdate_Movement_Promo_Calc: TMultiAction [2]
      Category = 'Update_Promo_Data'
      TabSheet = cxTabSheetCalc
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actUpdate_Movement_Promo_Calc
        end
        item
          Action = actRefresh
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' ('#1082#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088')'
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' ('#1082#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088')'
      ImageIndex = 42
    end
    object actInsertUpdateMISignNO: TdsdExecStoredProc [3]
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_No
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_No
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 52
    end
    object actUpdatePlanDS: TdsdUpdateDataSet [4]
      Category = 'Plan'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Plan
      StoredProcList = <
        item
          StoredProc = spUpdate_Plan
        end
        item
        end>
      Caption = 'actUpdatePlanDS'
      DataSource = PlanDS
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
          StoredProc = spSelect_Movement_PromoPartner
        end
        item
          StoredProc = spSelect_MovementItem_PromoCondition
        end
        item
          StoredProc = spSelect_Movement_PromoAdvertising
        end
        item
          TabSheet = tsPromoPartnerList
          StoredProc = spSelect_MovementItem_PromoPartner
        end
        item
          StoredProc = spSelectMISign
        end
        item
          StoredProc = spSelectCalc
        end
        item
          StoredProc = spSelectPlan
        end>
    end
    object actInsertUpdateMISignNO1: TMultiAction [6]
      Category = 'Sign'
      TabSheet = cxTabSheetSign
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actInsertUpdateMISignNO
        end
        item
          Action = actRefresh_Get
        end>
      Caption = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 52
    end
    object InsertRecord: TInsertRecord [8]
      Category = 'Goods'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = GoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ImageIndex = 0
    end
    object actUpdateCalcDS: TdsdUpdateDataSet [9]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Calc
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Calc
        end
        item
        end>
      Caption = 'actUpdateCalcDS'
      DataSource = CalcDS
    end
    inherited actMISetErased: TdsdUpdateErased
      Category = 'Goods'
      TabSheet = tsMain
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1090#1086#1074#1072#1088'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 0
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'> ?'
    end
    object actPrint_Calc: TdsdPrintAction [11]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      Hint = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ImageIndex = 15
      DataSets = <
        item
          UserName = 'frxHead'
          IndexFieldNames = 'GroupNum;GoodsName;Num'
          GridView = cxGridDBTableViewCalc
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
          Component = edCommentMain
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.Value = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Category = 'Goods'
      TabSheet = tsMain
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
    object UpdateConditionDS: TdsdUpdateDataSet [13]
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMICondition
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMICondition
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = ConditionPromoDS
    end
    inherited actShowErased: TBooleanStoredProcAction
      TabSheet = tsMain
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Movement_PromoPartner
        end
        item
          StoredProc = spSelect_MovementItem_PromoCondition
        end>
    end
    object macInsertUpdate_MI_Param: TMultiAction [16]
      Category = 'Update_MI_Param'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_MI_Param
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1056#1072#1089#1095#1077#1090' = '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080' ?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085' '#1088#1072#1089#1095#1077#1090' = '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080' '
      Caption = #1056#1072#1089#1095#1077#1090' = '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080
      Hint = #1056#1072#1089#1095#1077#1090' = '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080
      ImageIndex = 44
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
        end>
    end
    object actInsertUpdate_MI_Param: TdsdExecStoredProc [19]
      Category = 'Update_MI_Param'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MI_Param
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MI_Param
        end>
      Caption = 'actInsertUpdate_MI_Param'
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelect_Movement_Promo_Print
      StoredProcList = <
        item
          StoredProc = spSelect_Movement_Promo_Print
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
        end
        item
          Name = 'CommentMain'
          Value = Null
          Component = edCommentMain
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1094#1080#1103
      ReportNameParam.Value = #1040#1082#1094#1080#1103
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      TabSheet = tsMain
    end
    object actPartnerProtocolOpenForm: TdsdOpenForm [26]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1055#1072#1088#1090#1085#1077#1088#1099'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1055#1072#1088#1090#1085#1077#1088#1099'>'
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
    object actConditionPromoProtocolOpenForm: TdsdOpenForm [27]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1044#1086#1087'. '#1089#1082#1080#1076#1082#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1044#1086#1087'. '#1089#1082#1080#1076#1082#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actAdvertisingProtocolOpenForm: TdsdOpenForm [28]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'AdvertisingName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
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
    object GoodsChoiceForm: TOpenChoiceForm
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
    object GoodsKindCompleteChoiceForm: TOpenChoiceForm
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
    object InsertRecordPartner: TInsertRecord
      Category = 'Partner'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewPartner
      Action = PromoPartnerChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1072#1088#1090#1085#1077#1088#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1072#1088#1090#1085#1077#1088#1072'>'
      ImageIndex = 0
    end
    object ErasedPartner: TdsdUpdateErased
      Category = 'Partner'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spErasedMIPartner
      StoredProcList = <
        item
          StoredProc = spErasedMIPartner
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1072#1088#1090#1085#1077#1088#1072'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1072#1088#1090#1085#1077#1088#1072'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = PartnerDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1055#1072#1088#1090#1085#1077#1088#1072'> ?'
    end
    object UnErasedPartner: TdsdUpdateErased
      Category = 'Partner'
      TabSheet = tsMain
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
    object PromoPartnerChoiceForm: TOpenChoiceForm
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
    object dsdUpdateDSPartner: TdsdUpdateDataSet
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIPartner
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIPartner
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = PartnerDS
    end
    object InsertCondition: TInsertRecord
      Category = 'Condition'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = grtvConditionPromo
      Action = ConditionPromoChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      ImageIndex = 0
    end
    object ErasedCondition: TdsdUpdateErased
      Category = 'Condition'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spErasedMICondition
      StoredProcList = <
        item
          StoredProc = spErasedMICondition
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ConditionPromoDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'> ?'
    end
    object UnErasedCondition: TdsdUpdateErased
      Category = 'Condition'
      TabSheet = tsMain
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
      DataSource = ConditionPromoDS
    end
    object ConditionPromoChoiceForm: TOpenChoiceForm
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ConditionPromoChoiceForm'
      FormName = 'TConditionPromoForm'
      FormNameParam.Value = 'TConditionPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ContractChoiceForm: TOpenChoiceForm
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
    object InsertRecordAdvertising: TInsertRecord
      Category = 'Advertising'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = grtvAdvertising
      Action = AdvertisingChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      ImageIndex = 0
    end
    object ErasedAdvertising: TdsdUpdateErased
      Category = 'Advertising'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spErasedAdvertising
      StoredProcList = <
        item
          StoredProc = spErasedAdvertising
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = AdvertisingDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'> ?'
    end
    object unErasedAdvertising: TdsdUpdateErased
      Category = 'Advertising'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spUnErasedAdvertising
      StoredProcList = <
        item
          StoredProc = spUnErasedAdvertising
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = AdvertisingDS
    end
    object AdvertisingChoiceForm: TOpenChoiceForm
      Category = 'Advertising'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'AdvertisingChoiceForm'
      FormName = 'TAdvertisingForm'
      FormNameParam.Value = 'TAdvertisingForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'AdvertisingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'AdvertisingCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'AdvertisingName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object UpdateDSAdvertising: TdsdUpdateDataSet
      Category = 'Advertising'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIAdvertising
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIAdvertising
        end>
      Caption = 'actUpdateMainDS'
      DataSource = AdvertisingDS
    end
    object actUpdate_Movement_Promo_Data: TdsdExecStoredProc
      Category = 'Update_Promo_Data'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Promo_Data
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Promo_Data
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1072#1082#1094#1080#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1072#1082#1094#1080#1080
    end
    object mactUpdate_Movement_Promo_Data: TMultiAction
      Category = 'Update_Promo_Data'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Movement_Promo_Data
        end
        item
          Action = actRefresh
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' -'#1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' + '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' -'#1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' + '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 45
    end
    object actPartnerListRefresh: TdsdDataSetRefresh
      Category = 'Partner'
      TabSheet = tsPromoPartnerList
      MoveParams = <>
      Enabled = False
      StoredProc = spSelect_MovementItem_PromoPartner
      StoredProcList = <
        item
          StoredProc = spSelect_MovementItem_PromoPartner
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object mactAddAllPartner: TMultiAction
      Category = 'Partner'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceRetailForm
        end
        item
          Action = actInsertUpdate_Movement_PromoPartnerFromRetail
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
    object actInsertUpdate_Movement_PromoPartnerFromRetail: TdsdExecStoredProc
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Movement_PromoPartnerFromRetail
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Movement_PromoPartnerFromRetail
        end>
      Caption = 'actInsertUpdate_Movement_PromoPartnerFromRetail'
    end
    object actInsertUpdateMISign: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign
        end
        item
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 58
    end
    object actInsertUpdateMISign1: TMultiAction
      Category = 'Sign'
      TabSheet = cxTabSheetSign
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actInsertUpdateMISign
        end
        item
          Action = actRefresh_Get
        end>
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 58
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1094#1077#1085#1086#1074#1099#1093' '#1072#1082#1094#1080#1081'>'
      Hint = #1054#1090#1095#1077#1090' <'#1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1094#1077#1085#1086#1074#1099#1093' '#1072#1082#1094#1080#1081'>'
      ImageIndex = 25
      FormName = 'TReport_Promo_ResultForm'
      FormNameParam.Value = 'TReport_Promo_ResultForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 'NULL'
          Component = deStartPromo
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 'NULL'
          Component = deEndPromo
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = 'Null'
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailId'
          Value = 'Null'
          Component = PartnerListCDS
          ComponentItem = 'RetailId'
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailName'
          Value = 'Null'
          Component = PartnerListCDS
          ComponentItem = 'RetailName'
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 272
  end
  inherited MasterCDS: TClientDataSet
    Top = 272
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoGoods'
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
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_MI_Param'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
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
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMISign'
        end
        item
          Visible = True
          ItemName = 'bbSignNO'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPartnerProtocol'
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
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPartnerListProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAdvertisingProtocol'
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
          ItemName = 'bbOpenReportForm'
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
          ItemName = 'bbPrint_Calc'
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
    inherited bbShowAll: TdxBarButton
      Visible = ivNever
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object dxBarButton1: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = InsertRecordPartner
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = ErasedPartner
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = UnErasedPartner
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = InsertCondition
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = UnErasedCondition
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = ErasedCondition
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = InsertRecordAdvertising
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = unErasedAdvertising
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = ErasedAdvertising
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = mactUpdate_Movement_Promo_Data
      Category = 0
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
      Action = actConditionPromoProtocolOpenForm
      Category = 0
    end
    object bbAdvertisingProtocol: TdxBarButton
      Action = actAdvertisingProtocolOpenForm
      Category = 0
    end
    object bbInsertUpdate_MI_Param: TdxBarButton
      Action = macInsertUpdate_MI_Param
      Category = 0
    end
    object bbMISign: TdxBarButton
      Action = actInsertUpdateMISign1
      Category = 0
    end
    object bbSignNO: TdxBarButton
      Action = actInsertUpdateMISignNO1
      Category = 0
    end
    object bbPrint_Calc: TdxBarButton
      Action = actPrint_Calc
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bb: TdxBarButton
      Action = mactUpdate_Movement_Promo_Calc
      Category = 0
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
    Left = 62
    Top = 361
  end
  inherited PopupMenu: TPopupMenu
    Left = 152
    Top = 312
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
      end>
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Top = 272
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Promo'
    Top = 272
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Promo'
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
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
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
        Name = 'PromoKindId'
        Value = Null
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoKindName'
        Value = Null
        Component = PromoKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = 'NULL'
        Component = deStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = 'NULL'
        Component = deEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartSale'
        Value = 'NULL'
        Component = deStartSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndSale'
        Value = 'NULL'
        Component = deEndSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndReturn'
        Value = 'NULL'
        Component = deEndReturn
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateStart'
        Value = 'NULL'
        Component = deOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = 'NULL'
        Component = deOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CostPromo'
        Value = Null
        Component = edCostPromo
        DataType = ftFloat
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
        Name = 'CommentMain'
        Value = Null
        Component = edCommentMain
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdvertisingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdvertisingName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeId'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeName'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MonthPromo'
        Value = 'NULL'
        Component = deMonthPromo
        DataType = ftDateTime
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
        Name = 'Checked'
        Value = Null
        Component = cbChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckDate'
        Value = 'NULL'
        Component = deCheck
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'strSign'
        Value = Null
        Component = edstrSign
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'strSignNo'
        Value = Null
        Component = edstrSignNo
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 264
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Promo'
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
        Name = 'inPromoKindId'
        Value = Null
        Component = PromoKindGuides
        ComponentItem = 'Key'
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
      end
      item
        Name = 'inStartPromo'
        Value = 'NULL'
        Component = deStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = 'NULL'
        Component = deEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartSale'
        Value = 'NULL'
        Component = deStartSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSale'
        Value = 'NULL'
        Component = deEndSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndReturn'
        Value = 'NULL'
        Component = deEndReturn
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateStart'
        Value = 'NULL'
        Component = deOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = 'NULL'
        Component = deOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonthPromo'
        Value = 'NULL'
        Component = deMonthPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCheckDate'
        Value = 'NULL'
        Component = deCheck
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = Null
        Component = cbChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCostPromo'
        Value = Null
        Component = edCostPromo
        DataType = ftFloat
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
        Name = 'inCommentMain'
        Value = Null
        Component = edCommentMain
        DataType = ftString
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
        Name = 'inPersonalTradeId'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 322
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    Left = 216
    Top = 264
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
        Control = deStartSale
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
        Control = edPromoKind
      end
      item
        Control = edUnit
      end
      item
        Control = edPriceList
      end
      item
        Control = edCostPromo
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
        Control = edCommentMain
      end
      item
        Control = deMonthPromo
      end
      item
        Control = cbPromo
      end
      item
        Control = cbChecked
      end
      item
        Control = deCheck
      end>
    Left = 256
    Top = 265
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 16
    Top = 360
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetErased'
    Left = 406
    Top = 232
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetUnErased'
    Left = 454
    Top = 232
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoGoods'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindCompleteId'
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
      end>
    Left = 448
    Top = 272
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 432
    Top = 328
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Left = 876
    Top = 196
  end
  object PriceListGuides: TdsdGuides
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
      end>
    Left = 748
    Top = 48
  end
  object PromoKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromoKind
    FormNameParam.Value = 'TPromoKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPromoKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PromoKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PromoKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 516
    Top = 8
  end
  object PersonalTradeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TPersonalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 148
    Top = 64
  end
  object PersonalGuides: TdsdGuides
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
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 460
    Top = 80
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = 'Null'
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 700
  end
  object spSelect_Movement_PromoPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoPartner'
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
    Left = 544
    Top = 328
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
    StoredProcName = 'gpMovement_PromoPartner_SetErased'
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
    Left = 510
    Top = 232
  end
  object spUnErasedMIPartner: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoPartner_SetUnErased'
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
    Left = 542
    Top = 232
  end
  object spInsertUpdateMIPartner: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoPartner'
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
        Component = PriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListName'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalMarketingId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalMarketingName'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalTradeId'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalTradeName'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 272
  end
  object dsdDBViewAddOnPartner: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPartner
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 142
    Top = 361
  end
  object ConditionPromoDS: TDataSource
    DataSet = ConditionPromoCDS
    Left = 784
    Top = 504
  end
  object ConditionPromoCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 744
    Top = 504
  end
  object spSelect_MovementItem_PromoCondition: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoCondition'
    DataSet = ConditionPromoCDS
    DataSets = <
      item
        DataSet = ConditionPromoCDS
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
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 328
  end
  object spInsertUpdateMICondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ConditionPromoCDS
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
        Name = 'inConditionPromoId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'ConditionPromoId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 280
  end
  object spUnErasedMICondition: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 702
    Top = 232
  end
  object spErasedMICondition: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 734
    Top = 216
  end
  object dsdDBViewAddOnConditionPromo: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = grtvConditionPromo
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 270
    Top = 385
  end
  object pmPartner: TPopupMenu
    Images = dmMain.ImageList
    Left = 208
    Top = 496
    object MenuItem1: TMenuItem
      Action = InsertRecordPartner
    end
    object MenuItem2: TMenuItem
      Action = ErasedPartner
    end
    object MenuItem3: TMenuItem
      Action = UnErasedPartner
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object MenuItem5: TMenuItem
      Action = actRefresh
    end
    object MenuItem6: TMenuItem
      Action = actGridToExcel
    end
  end
  object pmCondition: TPopupMenu
    Images = dmMain.ImageList
    Left = 592
    Top = 512
    object MenuItem7: TMenuItem
      Action = InsertCondition
    end
    object MenuItem8: TMenuItem
      Action = ErasedCondition
    end
    object MenuItem9: TMenuItem
      Action = UnErasedCondition
    end
    object MenuItem10: TMenuItem
      Caption = '-'
    end
    object MenuItem11: TMenuItem
      Action = actRefresh
    end
    object MenuItem12: TMenuItem
      Action = actGridToExcel
    end
  end
  object PrintHead: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 776
    Top = 232
  end
  object spSelect_Movement_Promo_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Promo_Print'
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
    Left = 776
    Top = 128
  end
  object AdvertisingCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 376
    Top = 496
  end
  object AdvertisingDS: TDataSource
    DataSet = AdvertisingCDS
    Left = 472
    Top = 496
  end
  object pmAdvertising: TPopupMenu
    Images = dmMain.ImageList
    Left = 840
    Top = 496
    object MenuItem13: TMenuItem
      Action = InsertRecordAdvertising
    end
    object MenuItem14: TMenuItem
      Action = ErasedAdvertising
    end
    object MenuItem15: TMenuItem
      Action = unErasedAdvertising
    end
    object MenuItem16: TMenuItem
      Caption = '-'
    end
    object MenuItem17: TMenuItem
      Action = actRefresh
    end
    object MenuItem18: TMenuItem
      Action = actGridToExcel
    end
  end
  object spErasedAdvertising: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoAdvertising_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 470
    Top = 392
  end
  object spUnErasedAdvertising: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoAdvertising_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 534
    Top = 400
  end
  object spInsertUpdateMIAdvertising: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoAdvertising'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = AdvertisingCDS
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
        Name = 'inAdvertisingId'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'AdvertisingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 440
  end
  object spSelect_Movement_PromoAdvertising: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoAdvertising'
    DataSet = AdvertisingCDS
    DataSets = <
      item
        DataSet = AdvertisingCDS
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
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 552
    Top = 504
  end
  object spUpdate_Movement_Promo_Data: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_Data'
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
    Left = 104
    Top = 216
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
    Left = 344
    Top = 520
  end
  object spSelect_MovementItem_PromoPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoPartner'
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
    Left = 64
    Top = 496
  end
  object dsdDBViewAddOnPartnerList: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = grtvPartnerList
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 478
    Top = 537
  end
  object spInsertUpdate_Movement_PromoPartnerFromRetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoPartnerFromRetail'
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
    Left = 886
    Top = 312
  end
  object spInsertUpdate_MI_Param: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Promo_Param'
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
    Left = 840
    Top = 256
  end
  object spInsertUpdateMISign_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Sign'
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
        Name = 'inisSign'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 227
  end
  object spInsertUpdateMISign: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Sign'
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
        Name = 'inisSign'
        Value = 'True'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
    Top = 291
  end
  object SignCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1080
    Top = 224
  end
  object SignDS: TDataSource
    DataSet = SignCDS
    Left = 1124
    Top = 222
  end
  object dsdDBViewAddOnSign: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 1128
    Top = 271
  end
  object spSelectMISign: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_IncomeFuel_Sign'
    DataSet = SignCDS
    DataSets = <
      item
        DataSet = SignCDS
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
    Left = 956
    Top = 392
  end
  object CalcCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1088
    Top = 320
  end
  object CalcDS: TDataSource
    DataSet = CalcCDS
    Left = 1132
    Top = 318
  end
  object dsdDBViewAddOnCalc: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewCalc
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = calcPriceIn
        BackGroundValueColumn = Color_PriceIn
        ColorValueList = <>
      end
      item
        ColorColumn = calcAmountRetIn
        BackGroundValueColumn = Color_RetIn
        ColorValueList = <>
      end
      item
        ColorColumn = calcContractCondition
        BackGroundValueColumn = Color_ContractCond
        ColorValueList = <>
      end
      item
        ColorColumn = calcAmountPlanMax
        BackGroundValueColumn = Color_AmountPlanMax
        ColorValueList = <>
      end
      item
        ColorColumn = calcPriceWithVAT
        BackGroundValueColumn = Color_PriceWithVAT
        ColorValueList = <>
      end
      item
        ColorColumn = calcPrice
        BackGroundValueColumn = Color_Price
        ColorValueList = <>
      end
      item
        ColorColumn = calcSummaPlanMax
        BackGroundValueColumn = Color_SummaPlanMax
        ColorValueList = <>
      end
      item
        ColorColumn = calcPromoCondition
        BackGroundValueColumn = Color_PromoCond
        ColorValueList = <>
      end
      item
        ColorColumn = calcSummaProfit
        BackGroundValueColumn = Color_SummaProfit
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
      end>
    SummaryItemList = <>
    Left = 1120
    Top = 383
  end
  object spSelectCalc: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_PromoGoods_Calc'
    DataSet = CalcCDS
    DataSets = <
      item
        DataSet = CalcCDS
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
    Left = 1068
    Top = 392
  end
  object spInsertUpdate_Calc: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PromoGoods_Calc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceIn'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'PriceIn'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNum'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'Num'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlanMax'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'AmountPlanMax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaPlanMax'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'SummaPlanMax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRetIn'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'AmountRetIn'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountContractCondition'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'ContractCondition'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummaProfit'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'SummaProfit'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 408
  end
  object spUpdate_Movement_Promo_Calc: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_Calc'
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
    Left = 704
    Top = 384
  end
  object spUpdate_Plan: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PromoGoods_Plan'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = PlanCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan1'
        Value = Null
        Component = PlanCDS
        ComponentItem = 'AmountPlan1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan2'
        Value = Null
        Component = PlanCDS
        ComponentItem = 'AmountPlan2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan3'
        Value = Null
        Component = PlanCDS
        ComponentItem = 'AmountPlan3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan4'
        Value = Null
        Component = PlanCDS
        ComponentItem = 'AmountPlan4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan5'
        Value = Null
        Component = PlanCDS
        ComponentItem = 'AmountPlan5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan6'
        Value = Null
        Component = PlanCDS
        ComponentItem = 'AmountPlan6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan7'
        Value = Null
        Component = PlanCDS
        ComponentItem = 'AmountPlan7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 216
  end
  object PlanCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1072
    Top = 480
  end
  object PlanDS: TDataSource
    DataSet = PlanCDS
    Left = 1116
    Top = 478
  end
  object spSelectPlan: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoGoods'
    DataSet = PlanCDS
    DataSets = <
      item
        DataSet = PlanCDS
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
    Left = 1020
    Top = 440
  end
  object dsdDBViewAddOnPlan: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPlan
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 1008
    Top = 487
  end
end
