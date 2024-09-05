inherited PromoTradeForm: TPromoTradeForm
  ActiveControl = edOperDate
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1088#1077#1081#1076'-'#1084#1072#1088#1082#1077#1090#1080#1085#1075'>'
  ClientHeight = 707
  ClientWidth = 1161
  ExplicitWidth = 1177
  ExplicitHeight = 746
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 139
    Width = 1161
    Height = 568
    ExplicitTop = 139
    ExplicitWidth = 1161
    ExplicitHeight = 568
    ClientRectBottom = 568
    ClientRectRight = 1161
    inherited tsMain: TcxTabSheet
      Caption = '&1. '#1058#1086#1074#1072#1088#1099
      ExplicitWidth = 1161
      ExplicitHeight = 544
      inherited cxGrid: TcxGrid
        Width = 1161
        Height = 355
        ExplicitWidth = 1161
        ExplicitHeight = 355
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
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
          object TradeMarkName: TcxGridDBColumn [0]
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
          object GoodsGroupPropertyName: TcxGridDBColumn [1]
            Caption = ' '#9#1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '
            DataBinding.FieldName = 'GoodsGroupPropertyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 2'
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupPropertyName_Parent: TcxGridDBColumn [2]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088')'
            DataBinding.FieldName = 'GoodsGroupPropertyName_Parent'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoodsGroupProperty
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 1'
            Width = 100
          end
          object GoodsGroupDirectionName: TcxGridDBColumn [3]
            Caption = #1040#1085#1072#1083#1080#1090'. '#1075#1088'. '#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'GoodsGroupDirectionName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoodsGroupDirection
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1072#1103' '#1075#1088#1091#1087#1087#1072' '#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            Width = 104
          end
          object GoodsCode: TcxGridDBColumn [4]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object GoodsName: TcxGridDBColumn [5]
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
          object GoodsKindName: TcxGridDBColumn [6]
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
          object MeasureName: TcxGridDBColumn [7]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object GoodComment: TcxGridDBColumn [8]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount: TcxGridDBColumn [9]
            Caption = #1050#1086#1083'-'#1074#1086', '#1082#1075
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Summ: TcxGridDBColumn [10]
            Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 94
          end
          object PartnerCount: TcxGridDBColumn [11]
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1058#1058
            DataBinding.FieldName = 'PartnerCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 363
        Width = 1161
        Height = 173
        Align = alBottom
        TabOrder = 1
        object cxPageControl1: TcxPageControl
          Left = 1
          Top = 1
          Width = 564
          Height = 171
          Align = alClient
          TabOrder = 0
          Properties.ActivePage = tsPartner
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 564
          ClientRectTop = 24
          object tsPartner: TcxTabSheet
            Caption = '2.1. '#1055#1072#1088#1090#1085#1077#1088#1099
            object cxGridPartner: TcxGrid
              Left = 0
              Top = 0
              Width = 564
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
                      Action = actPromoPartnerChoiceForm
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
          object tsPromoPartnerList: TcxTabSheet
            Caption = '2.2. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            ImageIndex = 1
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object grPartnerList: TcxGrid
              Left = 0
              Top = 0
              Width = 564
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
        object cxPageControl3: TcxPageControl
          Left = 573
          Top = 1
          Width = 587
          Height = 171
          Align = alRight
          TabOrder = 1
          Properties.ActivePage = tsAdvertising
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 587
          ClientRectTop = 24
          object tsAdvertising: TcxTabSheet
            Caption = '&4. '#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072
            object grAdvertising: TcxGrid
              Left = 0
              Top = 0
              Width = 587
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
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
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
                      Action = actAdvertisingChoiceForm
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
          Left = 565
          Top = 1
          Width = 8
          Height = 171
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salRight
          Control = cxPageControl3
        end
      end
      object cxSplitter4: TcxSplitter
        Left = 0
        Top = 355
        Width = 1161
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = Panel1
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 536
        Width = 1161
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
      end
    end
    object cxTabSheetSign: TcxTabSheet
      Caption = '3.'#1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 4
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxGridSign: TcxGrid
        Left = 0
        Top = 0
        Width = 1161
        Height = 544
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
  end
  inherited DataPanel: TPanel
    Width = 1161
    Height = 113
    TabOrder = 3
    ExplicitWidth = 1161
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
      TabOrder = 13
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
      Left = 191
      Top = 4
      Caption = #1040#1082#1094#1080#1103' '#1089
    end
    object deStartPromo: TcxDateEdit
      Left = 191
      Top = 18
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 81
    end
    object cxLabel6: TcxLabel
      Left = 285
      Top = 4
      Caption = #1040#1082#1094#1080#1103' '#1087#1086
    end
    object deEndPromo: TcxDateEdit
      Left = 281
      Top = 18
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 87
    end
    object cxLabel9: TcxLabel
      Left = 191
      Top = 38
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1089
    end
    object deOperDateStart: TcxDateEdit
      Left = 191
      Top = 54
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 81
    end
    object cxLabel10: TcxLabel
      Left = 281
      Top = 38
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1086
    end
    object deOperDateEnd: TcxDateEdit
      Left = 281
      Top = 54
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 8
      Width = 87
    end
    object edCostPromo: TcxCurrencyEdit
      Left = 788
      Top = 54
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = False
      Properties.UseThousandSeparator = True
      TabOrder = 10
      Width = 125
    end
    object cxLabel12: TcxLabel
      Left = 788
      Top = 38
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103
    end
    object cxLabel13: TcxLabel
      Left = 571
      Top = 38
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 571
      Top = 54
      Properties.MaxLength = 255
      TabOrder = 9
      Width = 202
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
      TabOrder = 11
      Width = 170
    end
    object cxLabel16: TcxLabel
      Left = 380
      Top = 38
      Caption = #1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090
    end
    object edPromoItem: TcxButtonEdit
      Left = 380
      Top = 54
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Style.BorderColor = 13041606
      TabOrder = 12
      Width = 178
    end
    object edContract: TcxButtonEdit
      Left = 571
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
      Left = 571
      Top = 4
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel24: TcxLabel
      Left = 191
      Top = 74
      Hint = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080' '#1044#1086#1075'.'
      Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'.'
      ParentShowHint = False
      ShowHint = True
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 191
      Top = 90
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      TabOrder = 29
      Width = 177
    end
  end
  object cxLabel21: TcxLabel [2]
    Left = 380
    Top = 74
    Caption = #1045#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
  end
  object edStrSign: TcxTextEdit [3]
    Left = 380
    Top = 90
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 178
  end
  object edStrSignNo: TcxTextEdit [4]
    Left = 571
    Top = 90
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 154
  end
  object cxLabel22: TcxLabel [5]
    Left = 571
    Top = 74
    Caption = #1054#1078#1080#1076#1072#1077#1090#1089#1103' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
  end
  object cxLabel25: TcxLabel [6]
    Left = 735
    Top = 74
    Hint = #1052#1086#1076#1077#1083#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1081' '#1087#1086#1076#1087#1080#1089#1080
    Caption = #1052#1086#1076#1077#1083#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1081' '#1087#1086#1076#1087#1080#1089#1080
    ParentShowHint = False
    ShowHint = True
  end
  object edSignInternal: TcxButtonEdit [7]
    Left = 735
    Top = 90
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 178
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 139
    Top = 352
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 288
  end
  inherited ActionList: TActionList
    Left = 239
    Top = 191
    object actInsUpPromoPlan_Child_calc: TdsdExecStoredProc [0]
      Category = 'Plan'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'actInsUpPromoStat_Master_calc'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
      ImageIndex = 30
    end
    object macInsUpPromoPlan_Child_calc: TMultiAction [1]
      Category = 'Plan'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsUpPromoPlan_Child_calc
        end>
      QuestionBeforeExecute = 
        #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1040#1082#1094#1080#1103'? '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1073 +
        #1091#1076#1091#1090' '#1091#1076#1072#1083#1077#1085#1099'.'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1040#1082#1094#1080#1103' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1040#1082#1094#1080#1103
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1040#1082#1094#1080#1103
      ImageIndex = 30
    end
    object actInsUpPromoPlan_Master_calc: TdsdExecStoredProc [2]
      Category = 'Plan'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'actInsUpPromoStat_Master_calc'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1076#1072#1078
      ImageIndex = 41
    end
    object actErasedInvoice: TdsdUpdateErased [3]
      Category = 'Invoice'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090'> ?'
    end
    object actChoiceTradeMark: TOpenChoiceForm [4]
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
    object actChoiceGoodsGroupProperty: TOpenChoiceForm [5]
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
        end>
      isShowModal = True
    end
    object actChoiceGoodsGroupDirection: TOpenChoiceForm [6]
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
    object actUpdatePlanDS: TdsdUpdateDataSet [7]
      Category = 'Plan'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'actUpdatePlanDS'
    end
    object macInsUpPromoPlan_Master_calc: TMultiAction [8]
      Category = 'Plan'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsUpPromoPlan_Master_calc
        end>
      QuestionBeforeExecute = 
        #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1076#1072#1078' '#1040#1082#1094#1080#1103'? '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1073#1091#1076#1091#1090' '#1091 +
        #1076#1072#1083#1077#1085#1099'.'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1076#1072#1078' '#1040#1082#1094#1080#1103' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1076#1072#1078' '#1040#1082#1094#1080#1103
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1055#1083#1072#1085' '#1087#1088#1086#1076#1072#1078' '#1040#1082#1094#1080#1103
      ImageIndex = 41
    end
    object actUnErasedInvoice: TdsdUpdateErased [9]
      Category = 'Invoice'
      MoveParams = <>
      StoredProcList = <
        item
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
    object actInsertUpdate_MI_PriceCalc: TdsdExecStoredProc [10]
      Category = 'Update_MI_Param'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end
        item
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1062#1077#1085#1099' '#1089'/'#1089' ('#1087#1083#1072#1085'/'#1092#1072#1082#1090')'
      Hint = #1056#1072#1089#1095#1077#1090' '#1062#1077#1085#1099' '#1089'/'#1089' ('#1087#1083#1072#1085'/'#1092#1072#1082#1090')'
      ImageIndex = 76
    end
    object actUpdate_MI_ContractCondition: TdsdExecStoredProc [11]
      Category = 'Update_MI_Param'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1041#1086#1085#1091#1089#1072' '#1089#1077#1090#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1041#1086#1085#1091#1089#1072' '#1089#1077#1090#1080
      ImageIndex = 76
    end
    object actRefreshInvoice: TdsdDataSetRefresh [12]
      Category = 'Invoice'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_Movement_isTaxPromo: TdsdExecStoredProc [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end
        item
        end>
      Caption = #1047#1072#1084#1077#1085#1080#1090#1100' % '#1057#1082#1080#1076#1082#1080' <=> % '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      Hint = #1047#1072#1084#1077#1085#1080#1090#1100' % '#1057#1082#1080#1076#1082#1080' <=> % '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      ImageIndex = 27
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1084#1077#1085#1080#1090#1100' % '#1057#1082#1080#1076#1082#1080' <=> % '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
    end
    object actRefreshCalc: TdsdDataSetRefresh [14]
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
    object actInsertRecordPromoStateKind: TInsertRecord [15]
      Category = 'PromoStateKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Action = actPromoStateKindChoice
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      ImageIndex = 0
    end
    object actRefresh_Get: TdsdDataSetRefresh [16]
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
    object actMISetErasedPromoStateKind: TdsdUpdateErased [17]
      Category = 'PromoStateKind'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spGet
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077'> ?'
    end
    object actMISetUnErasedPromoStateKind: TdsdUpdateErased [18]
      Category = 'PromoStateKind'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spGet
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
    object actInsertUpdateMISignNo: TdsdExecStoredProc [19]
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_No
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_No
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
    end
    object actUpdatePromoStateKindDS: TdsdUpdateDataSet [20]
      Category = 'PromoStateKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdatePromoStateKindDS'
    end
    object actUpdateCalcDS2: TdsdUpdateDataSet [21]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet
      StoredProcList = <
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
          StoredProc = spSelectMISign
        end>
    end
    object mactInsertUpdateMISignNo: TMultiAction [23]
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignNo
        end
        item
          Action = actRefresh_Get
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 52
    end
    object actUpdateDataSetMessage: TdsdUpdateDataSet [24]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMessage
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMessage
        end>
      Caption = 'actUpdateDataSetMessage'
    end
    object InsertRecord: TInsertRecord [26]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ImageIndex = 0
    end
    object actUpdateCalcDS: TdsdUpdateDataSet [27]
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
    object actOpenProtocoPromoStateKind: TdsdOpenForm [28]
      Category = 'PromoStateKind'
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'PromoStateKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited actMISetErased: TdsdUpdateErased
      Category = 'Goods'
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 0
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'> ?'
    end
    object actPrint_Calc: TdsdPrintAction [30]
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
    object actPrint_Calc2: TdsdPrintAction [31]
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
    object actUpdateConditionDS: TdsdUpdateDataSet [33]
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = ConditionPromoDS
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spSelectMISign
        end>
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
        end
        item
        end
        item
        end
        item
        end
        item
        end
        item
        end>
    end
    object actOpenFormPromoContractBonus_Detail: TdsdOpenForm [37]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1041#1086#1085#1091#1089' '#1089#1077#1090#1080
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1041#1086#1085#1091#1089' '#1089#1077#1090#1080
      ImageIndex = 42
      FormName = 'TPromoContractBonus_DetailForm'
      FormNameParam.Value = 'TPromoContractBonus_DetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberFull'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macInsertUpdate_MI_Param: TMultiAction [38]
      Category = 'Update_MI_Param'
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
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080
      ImageIndex = 44
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelect
        end
        item
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
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1094#1080#1103
      ReportNameParam.Value = #1040#1082#1094#1080#1103
    end
    object actInsertUpdate_MI_Param: TdsdExecStoredProc [41]
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
    object actPromoStateKindChoice: TOpenChoiceForm [45]
      Category = 'PromoStateKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PromoStateKind_byMessageForm'
      FormName = 'TPromoStateKindForm'
      FormNameParam.Value = 'TPromoStateKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'PromoStateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'PromoStateKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1058#1086#1074#1072#1088'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1058#1086#1074#1072#1088'>'
    end
    object actPartnerProtocolOpenForm: TdsdOpenForm [49]
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
    object actConditionPromoProtocolOpenForm: TdsdOpenForm [50]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' % '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
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
    object actAdvertisingProtocolOpenForm: TdsdOpenForm [51]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
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
    object actInsertRecordPartner: TInsertRecord
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewPartner
      Action = actPromoPartnerChoiceForm
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
    object actPromoPartnerChoiceForm: TOpenChoiceForm
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
      StoredProcList = <
        item
        end
        item
          StoredProc = spUpdate_PromoPartner_ChangePercent
        end>
      Caption = 'actUpdateMainDS'
      DataSource = PartnerDS
    end
    object actInsertCondition: TInsertRecord
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Action = actConditionPromoChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      ImageIndex = 0
    end
    object actErasedCondition: TdsdUpdateErased
      Category = 'Condition'
      MoveParams = <>
      StoredProcList = <
        item
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
    object actUnErasedCondition: TdsdUpdateErased
      Category = 'Condition'
      MoveParams = <>
      StoredProcList = <
        item
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
    object actConditionPromoChoiceForm: TOpenChoiceForm
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
    object actInsertRecordAdvertising: TInsertRecord
      Category = 'Advertising'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = grtvAdvertising
      Action = actAdvertisingChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      ImageIndex = 0
    end
    object actErasedAdvertising: TdsdUpdateErased
      Category = 'Advertising'
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
    object actunErasedAdvertising: TdsdUpdateErased
      Category = 'Advertising'
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
    object actAdvertisingChoiceForm: TOpenChoiceForm
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
    object actUpdateDSAdvertising: TdsdUpdateDataSet
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
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' + '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' + '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 45
    end
    object actPartnerListRefresh: TdsdDataSetRefresh
      Category = 'Partner'
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
      StoredProcList = <
        item
        end>
      Caption = 'actInsertUpdate_Movement_PromoPartnerFromRetail'
    end
    object actUpdateChangePercent: TdsdUpdateDataSet
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_ChangePercent
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_ChangePercent
        end
        item
        end>
      Caption = 'actUpdateChangePercent'
      DataSource = PartnerDS
    end
    object actInsertUpdateMISignYes: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_Yes
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_Yes
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignYes: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignYes
        end
        item
          Action = actRefresh_Get
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
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
          Value = Null
          Component = deStartPromo
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = Null
          Component = deEndPromo
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = 'Null'
          Component = GuidesContract
          ComponentItem = 'Key'
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = Null
          Component = GuidesContract
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
        end
        item
          Name = 'InvNumberFull'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberFull'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUserChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'User_byMessageForm'
      FormName = 'TUser_byMessageForm'
      FormNameParam.Value = 'TUser_byMessageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isQuestion'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenReport_SaleReturn_byPromo: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1055#1088#1086#1076#1072#1078#1072'/'#1042#1086#1079#1074#1088#1072#1090
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1055#1088#1086#1076#1072#1078#1072'/'#1042#1086#1079#1074#1088#1072#1090
      ImageIndex = 26
      FormName = 'TReport_SaleReturn_byPromoForm'
      FormNameParam.Value = 'TReport_SaleReturn_byPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_SignInternal_One: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
          StoredProc = spUpdate_SignInternal_One
        end
        item
          StoredProc = spSelectMISign
        end
        item
        end
        item
          StoredProc = spGet
        end>
      Caption = #1054#1044#1048#1053' '#1087#1086#1076#1087#1080#1089#1072#1085#1090' '#1074' '#1040#1082#1094#1080#1080
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1044#1053#1054#1043#1054' '#1087#1086#1076#1087#1080#1089#1072#1085#1090#1072' '#1074' '#1040#1082#1094#1080#1080
      ImageIndex = 47
    end
    object actUpdate_SignInternal_Two: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
          StoredProc = spUpdate_SignInternal_Two
        end
        item
          StoredProc = spSelectMISign
        end
        item
        end
        item
          StoredProc = spGet
        end>
      Caption = #1044#1042#1040' '#1087#1086#1076#1087#1080#1089#1072#1085#1090#1072' '#1074' '#1040#1082#1094#1080#1080
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1044#1042#1059#1061' '#1087#1086#1076#1087#1080#1089#1072#1085#1090#1086#1074' '#1074' '#1040#1082#1094#1080#1080
      ImageIndex = 48
    end
    object actPrint_CalcAll: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      Hint = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHead
          UserName = 'frxHead'
          IndexFieldNames = 'GoodsName;GoodsKindName;Num'
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
    object macUpdate_calc: TMultiAction
      Category = 'Update_MI_Param'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_MI_PriceCalc
        end
        item
          Action = actUpdate_MI_ContractCondition
        end
        item
          Action = actRefreshCalc
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1062#1077#1085#1099' '#1089'/'#1089' ('#1087#1083#1072#1085'/'#1092#1072#1082#1090') '#1080' '#1041#1086#1085#1091#1089#1072' '#1089#1077#1090#1080
      Hint = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1062#1077#1085#1099' '#1089'/'#1089' ('#1087#1083#1072#1085'/'#1092#1072#1082#1090') '#1080' '#1041#1086#1085#1091#1089#1072' '#1089#1077#1090#1080
      ImageIndex = 76
    end
    object actUpdate_SignInternal_Three: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
          StoredProc = spUpdate_SignInternal_Three
        end
        item
          StoredProc = spSelectMISign
        end
        item
        end
        item
          StoredProc = spGet
        end>
      Caption = #1058#1056#1048' '#1087#1086#1076#1087#1080#1089#1072#1085#1090#1072' '#1074' '#1040#1082#1094#1080#1080
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1058#1056#1045#1061' '#1087#1086#1076#1087#1080#1089#1072#1085#1090#1086#1074' '#1074' '#1040#1082#1094#1080#1080
      ImageIndex = 49
    end
    object macUpdatePromoStateKind_Complete: TMultiAction
      Category = 'Update_PromoStateKind'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetPromoStateKind_Complete
        end
        item
          Action = actPromoManagerDialog
        end
        item
          Action = actUpdateMovement_PromoStateKind
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1077
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1077' - '#1054#1090#1076#1077#1083' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
    end
    object macUpdatePromoStateKind_Return: TMultiAction
      Category = 'Update_PromoStateKind'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetPromoStateKind_Return
        end
        item
          Action = actPromoManagerDialog
        end
        item
          Action = actUpdateMovement_PromoStateKind
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1077
      Hint = #1054#1090#1082#1083#1086#1085#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1077' - '#1074#1077#1088#1085#1091#1090#1100' '#1040#1082#1094#1080#1102' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1103
    end
    object actGetPromoStateKind_Complete: TdsdDataSetRefresh
      Category = 'Update_PromoStateKind'
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.Component = FormParams
          FromParam.ComponentItem = 'isComplete_PromoStateKind_true'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isComplete_PromoStateKind'
          ToParam.DataType = ftBoolean
          ToParam.ParamType = ptInput
          ToParam.MultiSelectSeparator = ','
        end>
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
    object actGetPromoStateKind_Return: TdsdDataSetRefresh
      Category = 'Update_PromoStateKind'
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.Component = FormParams
          FromParam.ComponentItem = 'isComplete_PromoStateKind_false'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isComplete_PromoStateKind'
          ToParam.DataType = ftBoolean
          ToParam.ParamType = ptInput
          ToParam.MultiSelectSeparator = ','
        end>
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
    object actPromoManagerDialog: TExecuteDialog
      Category = 'Update_PromoStateKind'
      MoveParams = <>
      Caption = 'actPromoManagerDialog'
      FormName = 'TPromoManagerDialogForm'
      FormNameParam.Value = 'TPromoManagerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementItemId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementItemId_PromoStateKind_true'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoStateKindId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PromoStateKindId'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoStateKindName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoStateKindName'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment_PromoStateKind'
          Value = Null
          Component = FormParams
          ComponentItem = 'Comment_PromoStateKind'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateMovement_PromoStateKind: TdsdExecStoredProc
      Category = 'Update_PromoStateKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = 'actUpdateMovement_PromoStateKind'
    end
    object actInsertInvoice: TdsdInsertUpdateAction
      Category = 'Invoice'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
      ImageIndex = 0
      FormName = 'TPromoInvoiceForm'
      FormNameParam.Value = 'TPromoInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inParentId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 43831d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSetRefresh = actRefreshInvoice
      IdFieldName = 'Id'
    end
    object actUpdateInvoice: TdsdInsertUpdateAction
      Category = 'Invoice'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
      ImageIndex = 1
      FormName = 'TPromoInvoiceForm'
      FormNameParam.Value = 'TPromoInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inParentId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 43831d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefreshInvoice
      IdFieldName = 'Id'
    end
    object actUnCompleteInvoice: TdsdChangeMovementStatus
      Category = 'Invoice'
      MoveParams = <>
      Enabled = False
      StoredProcList = <
        item
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>'
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>'
      ImageIndex = 11
      Status = mtUncomplete
    end
    object actSetErasedInvoice: TdsdChangeMovementStatus
      Category = 'Invoice'
      MoveParams = <>
      Enabled = False
      StoredProcList = <
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>'
      ImageIndex = 13
      Status = mtDelete
    end
    object actCompleteInvoice: TdsdChangeMovementStatus
      Category = 'Invoice'
      MoveParams = <>
      Enabled = False
      StoredProcList = <
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>'
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>'
      ImageIndex = 12
      Status = mtComplete
    end
    object actInsUpPromoStat_Master_calc: TdsdExecStoredProc
      Category = 'Stat'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'actInsUpPromoStat_Master_calc'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
      ImageIndex = 40
    end
    object macInsUpPromoStat_Master_calc: TMultiAction
      Category = 'Stat'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsUpPromoStat_Master_calc
        end
        item
        end>
      QuestionBeforeExecute = 
        #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1079#1072' 5 '#1085#1077#1076#1077#1083#1100'? '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1073#1091 +
        #1076#1091#1090' '#1091#1076#1072#1083#1077#1085#1099'.'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1079#1072' 5 '#1085#1077#1076#1077#1083#1100' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1079#1072' 5 '#1085#1077#1076#1077#1083#1100
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1079#1072' 5 '#1085#1077#1076#1077#1083#1100
      ImageIndex = 40
    end
  end
  inherited MasterDS: TDataSource
    Top = 272
  end
  inherited MasterCDS: TClientDataSet
    Top = 272
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoTradeGoods'
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
          ItemName = 'dxBarStatic'
        end
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
          ItemName = 'bsCalc'
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
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbChangePercent'
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
          ItemName = 'bbOpenReport_SaleReturn_byPromo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bsSign'
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
      Action = actInsertCondition
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actUnErasedCondition
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actErasedCondition
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actInsertRecordAdvertising
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actunErasedAdvertising
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actErasedAdvertising
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
    object bbInsertUpdateMISignYes: TdxBarButton
      Action = mactInsertUpdateMISignYes
      Category = 0
    end
    object bbInsertUpdateMISignNo: TdxBarButton
      Action = mactInsertUpdateMISignNo
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
    object bbInsertRecordPromoStateKind: TdxBarButton
      Action = actInsertRecordPromoStateKind
      Category = 0
    end
    object bbSetErasedPromoStateKind: TdxBarButton
      Action = actMISetErasedPromoStateKind
      Category = 0
    end
    object bbSetUnErasedPromoStateKind: TdxBarButton
      Action = actMISetUnErasedPromoStateKind
      Category = 0
    end
    object bbProtocoPromoStateKind: TdxBarButton
      Action = actOpenProtocoPromoStateKind
      Category = 0
    end
    object bbPrint_Calc2: TdxBarButton
      Action = actPrint_Calc2
      Category = 0
    end
    object bbUpdate_Movement_isTaxPromo: TdxBarButton
      Action = actUpdate_Movement_isTaxPromo
      Category = 0
    end
    object bbOpenReport_SaleReturn_byPromo: TdxBarButton
      Action = actOpenReport_SaleReturn_byPromo
      Category = 0
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
    object bsConditionPromo: TdxBarSubItem
      Caption = '% '#1076#1086#1087'.'#1089#1082#1080#1076#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
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
          ItemName = 'bbPartnerListProtocol'
        end>
    end
    object bsAdvertising: TdxBarSubItem
      Caption = #1056#1077#1082#1083#1072#1084#1085'. '#1087#1086#1076#1076'.'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
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
          ItemName = 'bbAdvertisingProtocol'
        end>
    end
    object bsPromoStateKind: TdxBarSubItem
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdate_SignInternal_One'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SignInternal_Two'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SignInternal_Three'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedPromoStateKind'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedPromoStateKind'
        end
        item
          Visible = True
          ItemName = 'bbProtocoPromoStateKind'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbUpdatePromoStateKind_Return'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator3'
        end
        item
          Visible = True
          ItemName = 'bbUpdatePromoStateKind_Complete'
        end>
    end
    object bsCalc: TdxBarSubItem
      Caption = #1056#1072#1089#1095#1077#1090
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdate_MI_Param'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_MI_ContractCondition'
        end>
    end
    object bsSign: TdxBarSubItem
      Caption = #1055#1086#1076#1087#1080#1089#1100
      Category = 0
      Visible = ivNever
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignYes'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignNo'
        end>
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbUpdate_SignInternal_One: TdxBarButton
      Action = actUpdate_SignInternal_One
      Category = 0
    end
    object bbUpdate_SignInternal_Two: TdxBarButton
      Action = actUpdate_SignInternal_Two
      Category = 0
    end
    object bbPrint_CalcAll: TdxBarButton
      Action = actPrint_CalcAll
      Category = 0
    end
    object bbChangePercent: TdxBarButton
      Action = macChangePercent
      Category = 0
    end
    object bbUpdate_MI_ContractCondition: TdxBarButton
      Action = macUpdate_calc
      Category = 0
    end
    object bbOpenFormPromoContractBonus_Detail: TdxBarButton
      Action = actOpenFormPromoContractBonus_Detail
      Category = 0
    end
    object bbUpdate_SignInternal_Three: TdxBarButton
      Action = actUpdate_SignInternal_Three
      Category = 0
    end
    object dxBarSeparator2: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbUpdatePromoStateKind_Complete: TdxBarButton
      Action = macUpdatePromoStateKind_Complete
      Category = 0
    end
    object bbUpdatePromoStateKind_Return: TdxBarButton
      Action = macUpdatePromoStateKind_Return
      Category = 0
    end
    object dxBarSeparator3: TdxBarSeparator
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbInvoice: TdxBarSubItem
      Caption = #1057#1095#1077#1090#1072
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateInvoice'
        end
        item
          Visible = True
          ItemName = 'bbCompleteInvoice'
        end
        item
          Visible = True
          ItemName = 'bbUnCompleteInvoice'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedInvoice'
        end>
    end
    object bbInsertInvoice: TdxBarButton
      Action = actInsertInvoice
      Category = 0
    end
    object bbUpdateInvoice: TdxBarButton
      Action = actUpdateInvoice
      Category = 0
    end
    object bbCompleteInvoice: TdxBarButton
      Action = actCompleteInvoice
      Category = 0
    end
    object bbUnCompleteInvoice: TdxBarButton
      Action = actUnCompleteInvoice
      Category = 0
    end
    object bbSetErasedInvoice: TdxBarButton
      Action = actSetErasedInvoice
      Category = 0
    end
    object bbInsUpPromoStat_Master_calc: TdxBarButton
      Action = macInsUpPromoStat_Master_calc
      Category = 0
    end
    object bbInsUpPromoPlan_Master_calc: TdxBarButton
      Action = macInsUpPromoPlan_Master_calc
      Category = 0
    end
    object bbInsUpPromoPlan_Child_calc: TdxBarButton
      Action = macInsUpPromoPlan_Child_calc
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
    Left = 78
    Top = 361
  end
  inherited PopupMenu: TPopupMenu
    Left = 32
    Top = 600
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
        Name = 'isComplete_PromoStateKind_true'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isComplete_PromoStateKind_false'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementItemId_PromoStateKind_true'
        Value = Null
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
    StoredProcName = 'gpUpdate_Status_PromoTrade'
    Top = 272
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PromoTrade'
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
        Name = 'ContractId'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = Null
        Component = GuidesContract
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
        Component = GuidesPromoKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoItemId'
        Value = Null
        Component = GuidesPromoItem
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoItemName'
        Value = Null
        Component = GuidesPromoItem
        ComponentItem = 'TextValue'
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
        Name = 'CostPromo'
        Value = Null
        Component = edCostPromo
        DataType = ftFloat
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
        Name = 'strSign'
        Value = Null
        Component = edStrSign
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'strSignNo'
        Value = Null
        Component = edStrSignNo
        DataType = ftString
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
        Name = 'SignInternalId'
        Value = Null
        Component = GuidesSignInternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SignInternalName'
        Value = Null
        Component = GuidesSignInternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 264
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoTrade'
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
        Name = 'inContractId'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoItemId'
        Value = Null
        Component = GuidesPromoItem
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoKindId'
        Value = Null
        Component = GuidesPromoKind
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
        Name = 'outPriceListName'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalTradetName'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 282
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
        Control = deOperDateStart
      end
      item
        Control = deOperDateEnd
      end
      item
        Control = edPromoKind
      end
      item
        Control = edContract
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
        Control = edPromoItem
      end
      item
        Control = edComment
      end
      item
        Control = edSignInternal
      end>
    Left = 256
    Top = 265
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 24
    Top = 384
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PromoTrade_SetErased'
    Left = 374
    Top = 192
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PromoTrade_SetUnErased'
    Left = 462
    Top = 200
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoTradeGoods'
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
    Left = 408
    Top = 248
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 456
    Top = 296
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
    Left = 932
  end
  object GuidesPromoKind: TdsdGuides
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
        Component = GuidesPromoKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPromoKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 460
    Top = 8
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
    Left = 100
    Top = 72
  end
  object GuidesPromoItem: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromoItem
    FormNameParam.Value = 'TPromoItemForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPromoItemForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPromoItem
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPromoItem
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 492
    Top = 40
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    Key = 'Null'
    FormNameParam.Value = 'TContract_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContract_ObjectForm'
    PositionDataSet = 'MasterCDS'
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
    Left = 676
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
    Left = 384
    Top = 440
  end
  object PartnerCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 216
    Top = 480
  end
  object PartnerDS: TDataSource
    DataSet = PartnerCDS
    Left = 296
    Top = 488
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
    Left = 430
    Top = 432
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
    Left = 454
    Top = 392
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
    Left = 206
    Top = 345
  end
  object ConditionPromoDS: TDataSource
    DataSet = ConditionPromoCDS
    Left = 776
    Top = 552
  end
  object ConditionPromoCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 720
    Top = 552
  end
  object pmPartner: TPopupMenu
    Images = dmMain.ImageList
    Left = 96
    Top = 600
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
    Left = 800
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
    Left = 952
    Top = 376
  end
  object AdvertisingCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 1000
    Top = 472
  end
  object AdvertisingDS: TDataSource
    DataSet = AdvertisingCDS
    Left = 1064
    Top = 472
  end
  object pmAdvertising: TPopupMenu
    Images = dmMain.ImageList
    Left = 1040
    Top = 584
    object MenuItem13: TMenuItem
      Action = actInsertRecordAdvertising
    end
    object MenuItem14: TMenuItem
      Action = actErasedAdvertising
    end
    object MenuItem15: TMenuItem
      Action = actunErasedAdvertising
    end
    object MenuItem16: TMenuItem
      Caption = '-'
    end
    object MenuItem17: TMenuItem
      Action = actRefresh
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
    Left = 958
    Top = 448
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
    Left = 886
    Top = 432
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
    Left = 1104
    Top = 432
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
    Top = 552
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
    Left = 128
    Top = 208
  end
  object PartnerListCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 712
    Top = 408
  end
  object PartnerLisrDS: TDataSource
    DataSet = PartnerListCDS
    Left = 336
    Top = 536
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
    Left = 120
    Top = 432
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
  object spInsertUpdate_MI_Param: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PromoTrade_Param'
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
    Left = 800
    Top = 288
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 211
  end
  object spInsertUpdateMISign_Yes: TdsdStoredProc
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 267
  end
  object SignCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 992
    Top = 192
  end
  object SignDS: TDataSource
    DataSet = SignCDS
    Left = 1020
    Top = 214
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 904
    Top = 295
  end
  object spSelectMISign: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Sign'
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
    Top = 216
  end
  object spInsertUpdateMIMessage: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Message'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
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
        Name = 'inUserId_Top'
        Value = ''
        Component = GuidesPromoItem
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioUserId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisQuestion'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAnswer'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisQuestionRead'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAnswerRead'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 552
    Top = 603
  end
  object PromoStateKindDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 888
    Top = 520
  end
  object GuidesSignInternal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSignInternal
    Key = 'Null'
    FormNameParam.Value = 'TSignInternalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSignInternalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = 'Null'
        Component = GuidesSignInternal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSignInternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 644
    Top = 80
  end
  object spUpdate_SignInternal_One: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_SignInternal'
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
        Name = 'inCountNum'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignInternalId'
        Value = Null
        Component = GuidesSignInternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignInternalName'
        Value = Null
        Component = GuidesSignInternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStrSign'
        Value = 'False'
        Component = edStrSign
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStrSignNo'
        Value = 'False'
        Component = edStrSignNo
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 136
  end
  object spUpdate_SignInternal_Two: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_SignInternal'
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
        Name = 'inCountNum'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignInternalId'
        Value = Null
        Component = GuidesSignInternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignInternalName'
        Value = Null
        Component = GuidesSignInternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStrSign'
        Value = 'False'
        Component = edStrSign
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStrSignNo'
        Value = 'False'
        Component = edStrSignNo
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 136
  end
  object cxEditRepository1: TcxEditRepository
    Left = 1112
    Top = 296
    object cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem
      Properties.DisplayFormat = ',0.## %;-,0.## %'
    end
    object cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
    end
  end
  object spUpdate_Movement_ChangePercent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_ChangePercent'
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
    Left = 640
    Top = 272
  end
  object dsdDBViewAddOnAdvertising: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = grtvAdvertising
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
    Left = 952
    Top = 335
  end
  object spUpdate_PromoPartner_ChangePercent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_PromoPartner_ChangePercent'
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
  object spUpdate_SignInternal_Three: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_SignInternal'
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
        Name = 'inCountNum'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignInternalId'
        Value = 'Null'
        Component = GuidesSignInternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignInternalName'
        Value = ''
        Component = GuidesSignInternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStrSign'
        Value = ''
        Component = edStrSign
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStrSignNo'
        Value = ''
        Component = edStrSignNo
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 928
    Top = 136
  end
end
