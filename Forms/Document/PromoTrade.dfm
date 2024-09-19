inherited PromoTradeForm: TPromoTradeForm
  ActiveControl = edOperDate
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1088#1077#1081#1076'-'#1084#1072#1088#1082#1077#1090#1080#1085#1075'>'
  ClientHeight = 715
  ClientWidth = 1164
  ExplicitWidth = 1180
  ExplicitHeight = 754
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 179
    Width = 1164
    Height = 536
    ExplicitTop = 179
    ExplicitWidth = 1164
    ExplicitHeight = 536
    ClientRectBottom = 536
    ClientRectRight = 1164
    inherited tsMain: TcxTabSheet
      Caption = '&1. '#1058#1086#1074#1072#1088#1099
      ExplicitWidth = 1164
      ExplicitHeight = 512
      inherited cxGrid: TcxGrid
        Width = 1164
        Height = 285
        ExplicitLeft = 3
        ExplicitTop = -86
        ExplicitWidth = 1164
        ExplicitHeight = 285
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
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = AmountSale
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = SummSale
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = AmountReturnIn
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = Summ
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
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = AmountSale
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = SummSale
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = AmountReturnIn
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = '0.####'
              Kind = skSum
              Column = Summ
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Ord: TcxGridDBColumn [0]
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object GoodsGroupDirectionName: TcxGridDBColumn [1]
            Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'GoodsGroupDirectionName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoodsGroupDirection
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1072#1103' '#1075#1088#1091#1087#1087#1072' '#1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            Width = 125
          end
          object GoodsGroupPropertyName_Parent: TcxGridDBColumn [2]
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupPropertyName_Parent'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoodsGroupPropertyParent
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 1'
            Width = 109
          end
          object GoodsGroupPropertyName: TcxGridDBColumn [3]
            Caption = #1055#1086#1076#1075#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupPropertyName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoodsGroupProperty
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 2'
            Width = 100
          end
          object TradeMarkName: TcxGridDBColumn [4]
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
          object PartnerName: TcxGridDBColumn [5]
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoicePartner
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 124
          end
          object GoodsCode: TcxGridDBColumn [6]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object GoodsName: TcxGridDBColumn [7]
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
          object MeasureName: TcxGridDBColumn [8]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object GoodsKindName: TcxGridDBColumn [9]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
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
            Width = 90
          end
          object Amount: TcxGridDBColumn [10]
            Caption = #1050#1086#1083'-'#1074#1086', '#1082#1075
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Summ: TcxGridDBColumn [11]
            Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 94
          end
          object PartnerCount: TcxGridDBColumn [12]
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1058#1058
            DataBinding.FieldName = 'PartnerCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object Comment: TcxGridDBColumn [13]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object AmountSale: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078' (3'#1084'.)'
            DataBinding.FieldName = 'AmountSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078' ('#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' 3'#1084'.)'
            Width = 80
          end
          object SummSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078' (3'#1084'.)'
            DataBinding.FieldName = 'SummSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072#1087#1088#1086#1076#1072#1078' ('#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' 3'#1084'.)'
            Width = 80
          end
          object AmountReturnIn: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1084' '#1074#1086#1079#1074#1088#1072#1090#1099' (3'#1084'.)'
            DataBinding.FieldName = 'AmountReturnIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1098#1077#1084' '#1074#1086#1079#1074#1088#1072#1090#1099' ('#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1079#1072' 3'#1084'.)'
            Width = 80
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 293
        Width = 1164
        Height = 219
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 291
        object cxPageControl1: TcxPageControl
          Left = 712
          Top = 1
          Width = 451
          Height = 217
          Align = alRight
          TabOrder = 0
          Properties.ActivePage = tsPartner
          Properties.CustomButtons.Buttons = <>
          ExplicitLeft = 710
          ExplicitTop = -2
          ClientRectBottom = 217
          ClientRectRight = 451
          ClientRectTop = 24
          object tsPartner: TcxTabSheet
            Caption = '2.3.'#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1077
            ExplicitLeft = -6
            ExplicitWidth = 336
            object cxGridMov3: TcxGrid
              Left = 0
              Top = 0
              Width = 451
              Height = 193
              Align = alClient
              TabOrder = 0
              ExplicitLeft = -2
              ExplicitTop = -3
              object cxGridDBTableViewMov3: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = Mov3DS
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
                object Name_ch3: TcxGridDBColumn
                  Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 236
                end
                object Value_ch3: TcxGridDBColumn
                  Caption = #1047#1085#1072#1095#1077#1085#1080#1077
                  DataBinding.FieldName = 'Value'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = actChoiceMember
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 202
                end
              end
              object cxGridLevelMov3: TcxGridLevel
                GridView = cxGridDBTableViewMov3
              end
            end
          end
        end
        object cxPageControl3: TcxPageControl
          Left = 295
          Top = 1
          Width = 409
          Height = 217
          Align = alClient
          TabOrder = 1
          Properties.ActivePage = tsAdvertising
          Properties.CustomButtons.Buttons = <>
          ExplicitWidth = 457
          ClientRectBottom = 217
          ClientRectRight = 409
          ClientRectTop = 24
          object tsAdvertising: TcxTabSheet
            Caption = '2.2. '#1048#1089#1090#1086#1088#1080#1103' '#1082#1083#1080#1077#1085#1090#1072
            ExplicitWidth = 587
            object cxGridMov2: TcxGrid
              Left = 0
              Top = 0
              Width = 409
              Height = 193
              Align = alClient
              TabOrder = 0
              ExplicitLeft = -56
              ExplicitTop = 3
              object cxGridDBTableViewMov2: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = Mov2DS
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
                object Name_ch2: TcxGridDBColumn
                  Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 256
                end
                object Value_ch2: TcxGridDBColumn
                  Caption = #1047#1085#1072#1095#1077#1085#1080#1077
                  DataBinding.FieldName = 'Value'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 130
                end
              end
              object cxGridLevelMov2: TcxGridLevel
                GridView = cxGridDBTableViewMov2
              end
            end
          end
        end
        object cxSplitter3: TcxSplitter
          Left = 704
          Top = 1
          Width = 8
          Height = 217
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salRight
          Control = cxPageControl1
          ExplicitLeft = 698
          ExplicitTop = -2
        end
        object cxSplitter1: TcxSplitter
          Left = 287
          Top = 1
          Width = 8
          Height = 217
          HotZoneClassName = 'TcxMediaPlayer8Style'
          Control = cxPageControl2
          ExplicitLeft = 337
        end
        object cxPageControl2: TcxPageControl
          Left = 1
          Top = 1
          Width = 286
          Height = 217
          Align = alLeft
          TabOrder = 4
          Properties.ActivePage = cxTabSheet1
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 217
          ClientRectRight = 286
          ClientRectTop = 24
          object cxTabSheet1: TcxTabSheet
            Caption = '2.1.'#1050#1086#1084#1084#1077#1088#1095#1077#1089#1082#1080#1077' '#1091#1089#1083#1086#1074#1080#1103
            ExplicitWidth = 336
            object cxGridMov1: TcxGrid
              Left = 0
              Top = 0
              Width = 286
              Height = 193
              Align = alClient
              TabOrder = 0
              ExplicitWidth = 336
              object cxGridDBTableViewMov1: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = Mov1DS
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
                object Name_ch1: TcxGridDBColumn
                  Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 176
                end
                object Value_ch1: TcxGridDBColumn
                  Caption = #1047#1085#1072#1095#1077#1085#1080#1077
                  DataBinding.FieldName = 'Value'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 82
                end
              end
              object cxGridLeveMov1: TcxGridLevel
                GridView = cxGridDBTableViewMov1
              end
            end
          end
        end
      end
      object cxSplitter4: TcxSplitter
        Left = 0
        Top = 285
        Width = 1164
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = Panel1
      end
    end
    object cxTabSheetSign: TcxTabSheet
      Caption = '3.'#1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 4
      object cxGridSign: TcxGrid
        Left = 0
        Top = 0
        Width = 1164
        Height = 512
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
    Width = 1164
    Height = 153
    TabOrder = 3
    ExplicitWidth = 1164
    ExplicitHeight = 153
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 18
      TabStop = False
      ExplicitLeft = 8
      ExplicitTop = 18
      ExplicitWidth = 169
      Width = 169
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 4
      ExplicitLeft = 8
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 8
      Top = 54
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      ExplicitLeft = 8
      ExplicitTop = 54
      ExplicitWidth = 169
      Width = 169
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 38
      ExplicitLeft = 8
      ExplicitTop = 38
    end
    inherited cxLabel15: TcxLabel
      Left = 7
      Top = 74
      ExplicitLeft = 7
      ExplicitTop = 74
    end
    inherited ceStatus: TcxButtonEdit
      Left = 7
      Top = 90
      TabStop = False
      TabOrder = 12
      ExplicitLeft = 7
      ExplicitTop = 90
      ExplicitWidth = 170
      ExplicitHeight = 22
      Width = 170
    end
    object cxLabel4: TcxLabel
      Left = 473
      Top = 38
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103' '
    end
    object edPromoKind: TcxButtonEdit
      Left = 473
      Top = 54
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 110
    end
    object cxLabel5: TcxLabel
      Left = 360
      Top = 74
      Caption = #1044#1072#1090#1072' '#1089
    end
    object deStartPromo: TcxDateEdit
      Left = 360
      Top = 90
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 102
    end
    object cxLabel6: TcxLabel
      Left = 473
      Top = 74
      Caption = #1044#1072#1090#1072' '#1087#1086
    end
    object deEndPromo: TcxDateEdit
      Left = 473
      Top = 90
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 110
    end
    object cxLabel9: TcxLabel
      Left = 593
      Top = 4
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1089
    end
    object deOperDateStart: TcxDateEdit
      Left = 593
      Top = 18
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 6
      Width = 81
    end
    object cxLabel10: TcxLabel
      Left = 683
      Top = 4
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1086
    end
    object deOperDateEnd: TcxDateEdit
      Left = 683
      Top = 18
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 87
    end
    object edCostPromo: TcxCurrencyEdit
      Left = 360
      Top = 54
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = False
      Properties.UseThousandSeparator = True
      TabOrder = 9
      Width = 102
    end
    object cxLabel12: TcxLabel
      Left = 360
      Top = 40
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103
    end
    object cxLabel13: TcxLabel
      Left = 360
      Top = 109
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 360
      Top = 126
      Properties.MaxLength = 255
      TabOrder = 8
      Width = 223
    end
    object cxLabel14: TcxLabel
      Left = 7
      Top = 111
      Caption = #1060#1048#1054' ('#1082#1086#1084#1084#1077#1088#1095#1077#1089#1082#1080#1081' '#1086#1090#1076#1077#1083')'
    end
    object edPersonalTrade: TcxButtonEdit
      Left = 8
      Top = 126
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Style.BorderColor = 16764159
      Style.Color = clWindow
      TabOrder = 10
      Width = 170
    end
    object cxLabel16: TcxLabel
      Left = 360
      Top = 4
      Caption = #1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090
    end
    object edPromoItem: TcxButtonEdit
      Left = 360
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Style.BorderColor = 13041606
      TabOrder = 11
      Width = 223
    end
    object edContract: TcxButtonEdit
      Left = 190
      Top = 90
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 156
    end
    object cxLabel17: TcxLabel
      Left = 191
      Top = 74
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel20: TcxLabel
      Left = 190
      Top = 111
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object edContractTag: TcxButtonEdit
      Left = 190
      Top = 126
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 156
    end
    object cxLabel3: TcxLabel
      Left = 190
      Top = 40
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
    end
    object ceJuridical: TcxButtonEdit
      Left = 190
      Top = 54
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 29
      Width = 156
    end
    object cxLabel7: TcxLabel
      Left = 190
      Top = 4
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
    end
    object ceRetail: TcxButtonEdit
      Left = 190
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 156
    end
  end
  object cxLabel21: TcxLabel [2]
    Left = 593
    Top = 109
    Caption = #1045#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
  end
  object edStrSign: TcxTextEdit [3]
    Left = 593
    Top = 126
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 177
  end
  object edStrSignNo: TcxTextEdit [4]
    Left = 593
    Top = 54
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 177
  end
  object cxLabel22: TcxLabel [5]
    Left = 593
    Top = 40
    Caption = #1054#1078#1080#1076#1072#1077#1090#1089#1103' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
  end
  object cxLabel25: TcxLabel [6]
    Left = 593
    Top = 74
    Hint = #1052#1086#1076#1077#1083#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1081' '#1087#1086#1076#1087#1080#1089#1080
    Caption = #1052#1086#1076#1077#1083#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1081' '#1087#1086#1076#1087#1080#1089#1080
    ParentShowHint = False
    ShowHint = True
  end
  object edSignInternal: TcxButtonEdit [7]
    Left = 593
    Top = 90
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 177
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
    Left = 287
    Top = 335
    object actChoicePartner: TOpenChoiceForm [0]
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoicePartner'
      FormName = 'TPartner_ObjectForm'
      FormNameParam.Value = 'TPartner_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateMov3DS: TdsdUpdateDataSet [1]
      Category = 'TradeSign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_PromoTradeSign
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_PromoTradeSign
        end
        item
          StoredProc = spSelect_PromoTradeSign
        end>
      Caption = 'actUpdateMov1DS'
      Hint = 'PromoTradeCondition'
      DataSource = Mov3DS
    end
    object actChoiceMember: TOpenChoiceForm [2]
      Category = 'TradeSign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceTradeMark'
      FormName = 'TMember_ChoiceForm'
      FormNameParam.Value = 'TMember_ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = Mov3CDS
          ComponentItem = 'ValueId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Mov3CDS
          ComponentItem = 'Value'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceTradeMark: TOpenChoiceForm [3]
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
    object actChoiceGoodsGroupProperty: TOpenChoiceForm [4]
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
    object actChoiceGoodsGroupPropertyParent: TOpenChoiceForm [5]
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
    object actUpdate_Movement_isTaxPromo: TdsdExecStoredProc [7]
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
    object actRefreshCalc: TdsdDataSetRefresh [8]
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
    object actRefresh_Get: TdsdDataSetRefresh [9]
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
    object actInsertUpdateMISignNo: TdsdExecStoredProc [10]
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
    object actUpdateMov1DS: TdsdUpdateDataSet [11]
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_PromoTradeCondition
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_PromoTradeCondition
        end
        item
          StoredProc = spSelect_PromoTradeCondition
        end>
      Caption = 'actUpdateMov1DS'
      Hint = 'PromoTradeCondition'
      DataSource = Mov1DS
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
          StoredProc = spSelect_PromoTradeCondition
        end
        item
          StoredProc = spSelect_PromoTradeHistory
        end
        item
          StoredProc = spSelect_PromoTradeSign
        end
        item
          StoredProc = spSelectMISign
        end>
    end
    object mactInsertUpdateMISignNo: TMultiAction [13]
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
    object actUpdateDataSetMessage: TdsdUpdateDataSet [14]
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
    object InsertRecord: TInsertRecord [16]
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
    object actUpdateCalcDS: TdsdUpdateDataSet [17]
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
    object actPrint_Calc: TdsdPrintAction [19]
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
    object actPrint_Calc2: TdsdPrintAction [20]
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
          StoredProc = spSelect_PromoTradeCondition
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
    object actOpenFormPromoContractBonus_Detail: TdsdOpenForm [25]
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
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1058#1086#1074#1072#1088'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1058#1086#1074#1072#1088'>'
    end
    object actPartnerProtocolOpenForm: TdsdOpenForm [34]
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
          Component = Mov1CDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = Mov1CDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actConditionPromoProtocolOpenForm: TdsdOpenForm [35]
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
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actAdvertisingProtocolOpenForm: TdsdOpenForm [36]
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
          Component = Mov2CDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = Mov2CDS
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
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailName'
          Value = 'Null'
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
    object actUpdate_PromoTradeHistory: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PromoTradeHistory
      StoredProcList = <
        item
          StoredProc = spUpdate_PromoTradeHistory
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_PromoTradeHistory
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1087#1088#1086#1076#1072#1078', '#1074#1086#1079#1074#1088#1072#1090#1072', '#1087#1088#1086#1089#1088#1086#1095'. '#1076#1077#1073#1077#1090'.'#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1087#1088#1086#1076#1072#1078', '#1074#1086#1079#1074#1088#1072#1090#1072', '#1087#1088#1086#1089#1088#1086#1095'. '#1076#1077#1073#1077#1090'.'#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080
      ImageIndex = 45
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1088#1086#1076#1072#1078', '#1074#1086#1079#1074#1088#1072#1090#1072', '#1087#1088#1086#1089#1088#1086#1095'. '#1076#1077#1073#1077 +
        #1090'.'#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080'?'
      InfoAfterExecute = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1099#1093' '#1074#1099#1087#1086#1083#1085#1077#1085
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting
      StoredProcList = <
        item
          StoredProc = spGetImportSetting
        end>
      Caption = 'actGetImportSetting'
    end
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
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
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088#1099'  '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088#1099'  '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
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
          ItemName = 'bbUpdate_PromoTradeHistory'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbStartLoad'
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
    object bbInsertUpdateMISignYes: TdxBarButton
      Action = mactInsertUpdateMISignYes
      Category = 0
    end
    object bbInsertUpdateMISignNo: TdxBarButton
      Action = mactInsertUpdateMISignNo
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
    object bsSign: TdxBarSubItem
      Caption = #1055#1086#1076#1087#1080#1089#1100
      Category = 0
      Visible = ivAlways
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
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1077
      Category = 0
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1077' - '#1054#1090#1076#1077#1083' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
      Visible = ivAlways
    end
    object bbUpdatePromoStateKind_Return: TdxBarButton
      Caption = #1054#1090#1082#1083#1086#1085#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1077
      Category = 0
      Hint = #1054#1090#1082#1083#1086#1085#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1077' - '#1074#1077#1088#1085#1091#1090#1100' '#1040#1082#1094#1080#1102' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1103
      Visible = ivAlways
    end
    object dxBarSeparator3: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbUpdate_PromoTradeHistory: TdxBarButton
      Action = actUpdate_PromoTradeHistory
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
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
    Top = 321
  end
  inherited PopupMenu: TPopupMenu
    Left = 688
    Top = 328
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
    Left = 584
    Top = 320
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
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
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
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
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
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 514
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
        Control = ceJuridical
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
        Name = 'inPartnerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerId'
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
        Name = 'inSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerCount'
        DataType = ftFloat
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
        ComponentItem = 'GoodsGroupPropertyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupPropertyId_Parent'
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
    Left = 400
    Top = 264
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
    Left = 516
    Top = 24
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    DisableGuidesOpen = True
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
    Left = 476
    Top = 65528
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    Key = 'Null'
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
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
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = Null
        Component = GuidesContractTag
        ComponentItem = 'Key'
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
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 236
    Top = 96
  end
  object spSelect_PromoTradeCondition: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoTradeCondition'
    DataSet = Mov1CDS
    DataSets = <
      item
        DataSet = Mov1CDS
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
    Left = 176
    Top = 616
  end
  object Mov1CDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 24
    Top = 632
  end
  object Mov1DS: TDataSource
    DataSet = Mov1CDS
    Left = 40
    Top = 576
  end
  object dsdDBViewAddOnMov1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewMov1
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
    Left = 110
    Top = 545
  end
  object PrintHead: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 768
    Top = 328
  end
  object spSelect_Movement_Promo_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoTrade_Print'
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
  object Mov2CDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 560
    Top = 560
  end
  object Mov2DS: TDataSource
    DataSet = Mov2CDS
    Left = 608
    Top = 560
  end
  object spErasedAdvertising: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoAdvertising_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = Mov2CDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = Mov2CDS
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
        Component = Mov2CDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = Mov2CDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 902
    Top = 344
  end
  object spInsertUpdateMIAdvertising: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoAdvertising'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = Mov2CDS
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
        Component = Mov2CDS
        ComponentItem = 'AdvertisingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = Mov2CDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1104
    Top = 432
  end
  object spSelect_PromoTradeHistory: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoTradeHistory'
    DataSet = Mov2CDS
    DataSets = <
      item
        DataSet = Mov2CDS
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
    Left = 656
    Top = 608
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
    Left = 856
    Top = 259
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
    Left = 1064
    Top = 144
  end
  object SignDS: TDataSource
    DataSet = SignCDS
    Left = 1100
    Top = 142
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
    Left = 1000
    Top = 343
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
    Left = 932
    Top = 256
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
    Left = 888
    Top = 83
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
    Left = 588
    Top = 64
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
    Left = 888
    Top = 24
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
    Left = 896
    Top = 40
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
  object dsdDBViewAddOnMov2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewMov2
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
    Left = 344
    Top = 583
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
    Left = 880
    Top = 16
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
    Left = 275
    Top = 108
  end
  object GuidesContractJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesContractJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesContractJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptResult
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 624
    Top = 241
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
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
    Left = 276
    Top = 49
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRetail
    DisableGuidesOpen = True
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 5
  end
  object spInsertUpdate_PromoTradeCondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoTradeCondition'
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
        Name = 'inOrd'
        Value = Null
        Component = Mov1CDS
        ComponentItem = 'Ord'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = Mov1CDS
        ComponentItem = 'Value'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 560
  end
  object spUpdate_PromoTradeHistory: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_PromoTradeHistory'
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
    Left = 520
    Top = 368
  end
  object Mov3DS: TDataSource
    DataSet = Mov3CDS
    Left = 808
    Top = 568
  end
  object Mov3CDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 792
    Top = 624
  end
  object dsdDBViewAddOnMov3: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
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
    Left = 878
    Top = 561
  end
  object spSelect_PromoTradeSign: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoTradeSign'
    DataSet = Mov3CDS
    DataSets = <
      item
        DataSet = Mov3CDS
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
    Left = 1040
    Top = 568
  end
  object spInsertUpdate_PromoTradeSign: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoTradeSign'
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
        Name = 'inOrd'
        Value = Null
        Component = Mov3CDS
        ComponentItem = 'Ord'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValueId'
        Value = Null
        Component = Mov3CDS
        ComponentItem = 'ValueId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = Mov3CDS
        ComponentItem = 'Value'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 624
  end
  object spGetImportSetting: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPromoTradeForm;zc_Object_ImportSetting_PromoTrade'
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
    Left = 1064
    Top = 16
  end
end
