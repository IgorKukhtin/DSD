inherited PromoForm: TPromoForm
  ActiveControl = edOperDate
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
  ClientHeight = 599
  ClientWidth = 1204
  ExplicitWidth = 1220
  ExplicitHeight = 634
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
              Column = colAmountRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountPlanMinWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountPlanMaxWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountOrderWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountOutWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountInWeight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountPlanMinWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountPlanMaxWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountOrderWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountOutWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountInWeight
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colTradeMark: TcxGridDBColumn [0]
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colGoodsCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object colGoodsName: TcxGridDBColumn [2]
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
          object colGoodsKindName: TcxGridDBColumn [3]
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
          object colMeasureName: TcxGridDBColumn [4]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object colGoodComment: TcxGridDBColumn [5]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colAmount: TcxGridDBColumn [6]
            Caption = '% '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colPriceSale: TcxGridDBColumn [7]
            Caption = #1062#1077#1085#1072' '#1085#1072' '#1087#1086#1083#1082#1077
            DataBinding.FieldName = 'PriceSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colPrice: TcxGridDBColumn [8]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colPriceWithOutVAT: TcxGridDBColumn [9]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithOutVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object colPriceWithVAT: TcxGridDBColumn [10]
            Caption = #1089' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object colAmountReal: TcxGridDBColumn [11]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountReal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colAmountRealWeight: TcxGridDBColumn [12]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' '#1042#1077#1089
            DataBinding.FieldName = 'AmountRealWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colAmountPlanMin: TcxGridDBColumn [13]
            Caption = #1055#1083#1072#1085' '#1084#1080#1085'.'
            DataBinding.FieldName = 'AmountPlanMin'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colAmountPlanMinWeight: TcxGridDBColumn [14]
            Caption = #1055#1083#1072#1085' '#1084#1080#1085'. '#1042#1077#1089
            DataBinding.FieldName = 'AmountPlanMinWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colAmountPlanMax: TcxGridDBColumn [15]
            Caption = #1055#1083#1072#1085' '#1084#1072#1082#1089'.'
            DataBinding.FieldName = 'AmountPlanMax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colAmountPlanMaxWeight: TcxGridDBColumn [16]
            Caption = #1055#1083#1072#1085' '#1084#1072#1082#1089'. '#1042#1077#1089
            DataBinding.FieldName = 'AmountPlanMaxWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colAmountOrder: TcxGridDBColumn [17]
            Caption = #1047#1072#1103#1074#1082#1072' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountOrder'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colAmountOrderWeight: TcxGridDBColumn [18]
            Caption = #1047#1072#1103#1074#1082#1072' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountOrderWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colAmountOut: TcxGridDBColumn [19]
            Caption = #1055#1088#1086#1076#1072#1085#1086' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountOut'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colAmountOutWeight: TcxGridDBColumn [20]
            Caption = #1055#1088#1086#1076#1072#1085#1086' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountOutWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colAmountIn: TcxGridDBColumn [21]
            Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountIn'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colAmountInWeight: TcxGridDBColumn [22]
            Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountInWeight'
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
                object colp_Area: TcxGridDBColumn
                  Caption = #1056#1077#1075#1080#1086#1085
                  DataBinding.FieldName = 'AreaName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 70
                end
                object colp_PartnerCode: TcxGridDBColumn
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
                object colp_PartnerName: TcxGridDBColumn
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
                object colp_PartnerDescName: TcxGridDBColumn
                  Caption = #1069#1083#1077#1084#1077#1085#1090
                  DataBinding.FieldName = 'PartnerDescName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 58
                end
                object colJuridical_Name: TcxGridDBColumn
                  Caption = #1070#1088'. '#1083#1080#1094#1086
                  DataBinding.FieldName = 'Juridical_Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 80
                end
                object colRetail_Name: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100
                  DataBinding.FieldName = 'Retail_Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 80
                end
                object colContractCode: TcxGridDBColumn
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
                object colContractName: TcxGridDBColumn
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
                object colContractTagName: TcxGridDBColumn
                  Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractTagName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 70
                end
                object colp_Comment: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 91
                end
                object colp_isErased: TcxGridDBColumn
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
                object colPartnerListRetailName: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100
                  DataBinding.FieldName = 'RetailName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object colPartnerListJuridicalName: TcxGridDBColumn
                  Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
                  DataBinding.FieldName = 'JuridicalName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 100
                end
                object colPartnerListCode: TcxGridDBColumn
                  Caption = #1050#1086#1076
                  DataBinding.FieldName = 'Code'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 38
                end
                object colPartnerListName: TcxGridDBColumn
                  Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
                  DataBinding.FieldName = 'Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 182
                end
                object colPartnerListAreaName: TcxGridDBColumn
                  Caption = #1056#1077#1075#1080#1086#1085
                  DataBinding.FieldName = 'AreaName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 98
                end
                object colPartnerListContractCode: TcxGridDBColumn
                  Caption = #1050#1086#1076' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractCode'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 48
                end
                object colPartnerListContractName: TcxGridDBColumn
                  Caption = #8470' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 48
                end
                object colPartnerListContractTagName: TcxGridDBColumn
                  Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractTagName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object colPartnerListIsErased: TcxGridDBColumn
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
                object colcp_Amount: TcxGridDBColumn
                  Caption = '% '#1089#1082#1080#1076#1082#1080
                  DataBinding.FieldName = 'Amount'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 50
                end
                object colcp_ConditionPromoName: TcxGridDBColumn
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
                object colcp_Comment: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object colcp_isErased: TcxGridDBColumn
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
                object colAdvertisingCode: TcxGridDBColumn
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
                object colAdvertisingName: TcxGridDBColumn
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
                object colCommentAdvertising: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object colIsErasedAdvertising: TcxGridDBColumn
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
      Top = 91
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
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
      Top = 91
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
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 312
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 312
  end
  inherited ActionList: TActionList
    Top = 311
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
        end>
    end
    object InsertRecord: TInsertRecord [2]
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
    object UpdateConditionDS: TdsdUpdateDataSet [5]
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
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
        end>
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
    object InsertRecordPartner: TInsertRecord
      Category = 'Partner'
      TabSheet = tsPartner
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
      TabSheet = tsPartner
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
      TabSheet = tsPartner
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
      TabSheet = tsConditionPromo
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
      TabSheet = tsConditionPromo
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
      TabSheet = tsConditionPromo
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
      TabSheet = tsAdvertising
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
      TabSheet = tsAdvertising
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
      TabSheet = tsAdvertising
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
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Movement_Promo_Data
        end
        item
          Action = actRefresh
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1072#1082#1094#1080#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1072#1082#1094#1080#1080
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbRefresh'
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
          ItemName = 'bbPrint'
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
    Left = 456
    Top = 336
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
    Left = 132
    Top = 96
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
    Left = 476
    Top = 64
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
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
    Left = 160
    Top = 512
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
    Left = 702
    Top = 176
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
    Left = 214
    Top = 353
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
    Left = 584
    Top = 488
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
    Left = 728
    Top = 128
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
    Left = 424
    Top = 504
  end
  object AdvertisingDS: TDataSource
    DataSet = AdvertisingCDS
    Left = 464
    Top = 504
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
    Left = 510
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
    Left = 504
    Top = 464
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
    Left = 504
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
    Left = 112
    Top = 168
  end
  object PartnerListCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 304
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
    Left = 264
    Top = 536
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
    Left = 422
    Top = 553
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
    Left = 902
    Top = 312
  end
end
