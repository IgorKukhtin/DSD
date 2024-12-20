inherited MainInventoryForm: TMainInventoryForm
  Action = actExit
  Caption = #1042#1099#1093#1086#1076
  ClientHeight = 397
  ClientWidth = 840
  Menu = MainMenu
  OnClick = actExitExecute
  OnClose = nil
  OnCreate = FormCreate
  OnDestroy = ParentFormDestroy
  ExplicitWidth = 856
  ExplicitHeight = 456
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel [0]
    Left = 0
    Top = 0
    Width = 840
    Height = 397
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 0
    object PageControl: TcxPageControl
      Left = 1
      Top = 1
      Width = 838
      Height = 395
      Align = alClient
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 0
      Properties.ActivePage = tsInfo
      Properties.CustomButtons.Buttons = <>
      ClientRectBottom = 391
      ClientRectLeft = 4
      ClientRectRight = 834
      ClientRectTop = 24
      object tsStart: TcxTabSheet
        Caption = #1057#1090#1072#1088#1090#1086#1074#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072
        ImageIndex = 0
      end
      object tsInventory: TcxTabSheet
        Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077
        ImageIndex = 1
        object cxGridChild: TcxGrid
          Left = 0
          Top = 65
          Width = 830
          Height = 302
          Align = alClient
          TabOrder = 0
          LookAndFeel.ScrollbarMode = sbmClassic
          object cxGridChildDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            ScrollbarAnnotations.CustomAnnotations = <>
            DataController.DataSource = MasterDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = #1057#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = ChildGoodsName
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = ChildAmount
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = chAmountGoods
              end>
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
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.Content = dmMain.cxContentStyle
            Styles.Footer = dmMain.cxFooterStyle
            Styles.Header = dmMain.cxHeaderStyle
            Styles.Inactive = dmMain.cxSelection
            object ChildIsSend: TcxGridDBColumn
              Caption = #1054#1090#1087#1088'.'
              DataBinding.FieldName = 'IsSend'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 40
            end
            object ChildisLast: TcxGridDBColumn
              Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1081
              DataBinding.FieldName = 'isLast'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.DisplayChecked = '1'
              Properties.DisplayUnchecked = '0'
              Properties.ValueChecked = '1'
              Properties.ValueUnchecked = '0'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 54
            end
            object ChildNum: TcxGridDBColumn
              Caption = #8470' '#1087'.'#1087'.'
              DataBinding.FieldName = 'Num'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 39
            end
            object ChildGoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'GoodsCode'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 54
            end
            object ChildGoodsName: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088
              DataBinding.FieldName = 'GoodsName'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 199
            end
            object chAmountGoods: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1080#1085#1074#1077#1085#1090'.'
              DataBinding.FieldName = 'AmountGoods'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 61
            end
            object ChildAmount: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1089#1082#1072#1085'.'
              DataBinding.FieldName = 'Amount'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 59
            end
            object ChildUserName: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
              DataBinding.FieldName = 'UserName'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 121
            end
            object ChildDate_Insert: TcxGridDBColumn
              Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
              DataBinding.FieldName = 'Date_Insert'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 143
            end
          end
          object cxGridChildLevel: TcxGridLevel
            GridView = cxGridChildDBTableView
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 830
          Height = 65
          Align = alTop
          ShowCaption = False
          TabOrder = 1
          object edBarCode: TcxTextEdit
            Left = 14
            Top = 38
            TabOrder = 1
            OnDblClick = edBarCodeDblClick
            OnKeyDown = edBarCodeKeyDown
            Width = 161
          end
          object ceAmount: TcxCurrencyEdit
            Left = 220
            Top = 38
            EditValue = 1.000000000000000000
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            TabOrder = 0
            OnKeyDown = edBarCodeKeyDown
            Width = 90
          end
          object cxLabel4: TcxLabel
            Left = 16
            Top = 23
            Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
          end
          object cxLabel5: TcxLabel
            Left = 220
            Top = 22
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          end
          object ceAmountAdd: TcxCurrencyEdit
            Left = 727
            Top = 39
            TabStop = False
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            Properties.ReadOnly = True
            TabOrder = 4
            Width = 90
          end
          object cxLabel6: TcxLabel
            Left = 735
            Top = 23
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          end
          object edGoodsCode: TcxTextEdit
            Left = 335
            Top = 39
            TabStop = False
            Properties.ReadOnly = True
            TabOrder = 6
            Width = 66
          end
          object cxLabel7: TcxLabel
            Left = 335
            Top = 22
            Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1081' '#1076#1086#1073#1072#1074#1083#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088
          end
          object edGoodsName: TcxTextEdit
            Left = 407
            Top = 39
            TabStop = False
            Properties.ReadOnly = True
            TabOrder = 8
            Width = 314
          end
          object cxLabel1: TcxLabel
            Left = 16
            Top = 3
            Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1086#1090
          end
          object edOperDate: TcxDateEdit
            Left = 125
            Top = 2
            TabStop = False
            EditValue = 45033d
            TabOrder = 10
            Width = 121
          end
          object cxButton1: TcxButton
            Left = 181
            Top = 37
            Width = 33
            Height = 25
            Action = actGoodsInventory
            PaintStyle = bpsGlyph
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
            TabStop = False
          end
          object edUnitName: TcxButtonEdit
            Left = 252
            Top = 2
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            TabOrder = 12
            Width = 565
          end
        end
      end
      object tsInventoryManual: TcxTabSheet
        Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1088#1091#1095#1085#1086#1081' '#1074#1074#1086#1076
        ImageIndex = 3
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 830
          Height = 53
          Align = alTop
          ShowCaption = False
          TabOrder = 0
          object cxLabel11: TcxLabel
            Left = 43
            Top = 5
            Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1086#1090
          end
          object edOperDateManual: TcxDateEdit
            Left = 152
            Top = 4
            TabStop = False
            EditValue = 45033d
            TabOrder = 1
            Width = 108
          end
          object cxButton2: TcxButton
            Left = -1
            Top = 0
            Width = 33
            Height = 25
            Action = actShowAll
            PaintStyle = bpsGlyph
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            TabStop = False
          end
          object edUnitNameManual: TcxButtonEdit
            Left = 269
            Top = 4
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            TabOrder = 3
            Width = 532
          end
          object TextEdit: TcxTextEdit
            Left = 1
            Top = 31
            Align = alBottom
            TabOrder = 4
            DesignSize = (
              828
              21)
            Width = 828
          end
        end
        object cxGridManual: TcxGrid
          Left = 0
          Top = 53
          Width = 830
          Height = 314
          Align = alClient
          TabOrder = 1
          LookAndFeel.ScrollbarMode = sbmClassic
          ExplicitLeft = 1
          ExplicitTop = 58
          object cxGridDBTableView2: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            ScrollbarAnnotations.CustomAnnotations = <>
            DataController.DataSource = ManualDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = #1057#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = ManualcxGoodsName
              end
              item
                Format = ',0.####;-,0.####; ;'
                Kind = skSum
                Column = ManualRemains
              end
              item
                Format = ',0.####;-,0.####; ;'
                Kind = skSum
                Column = ManualAmount
              end>
            DataController.Summary.SummaryGroups = <>
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.Content = dmMain.cxContentStyle
            Styles.Footer = dmMain.cxFooterStyle
            Styles.Header = dmMain.cxHeaderStyle
            Styles.Inactive = dmMain.cxSelection
            object ManualGoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'GoodsCode'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 92
            end
            object ManualcxGoodsName: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088
              DataBinding.FieldName = 'GoodsName'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 444
            end
            object ManualPrice: TcxGridDBColumn
              Caption = #1062#1077#1085#1072
              DataBinding.FieldName = 'Price'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00;-,0.00; ;'
              HeaderAlignmentHorz = taCenter
              Width = 120
            end
            object ManualRemains: TcxGridDBColumn
              Caption = #1054#1089#1090#1072#1090#1086#1082
              DataBinding.FieldName = 'Remains'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 140
            end
            object ManualAmount: TcxGridDBColumn
              Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
              DataBinding.FieldName = 'Amount'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Styles.Content = dmMain.cxHeaderL1Style
              Styles.Header = dmMain.cxHeaderStyle
              Width = 140
            end
          end
          object cxGridLevel2: TcxGridLevel
            GridView = cxGridDBTableView2
          end
        end
      end
      object tsInfo: TcxTabSheet
        Caption = #1048#1090#1086#1075#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
        ImageIndex = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 830
          Height = 34
          Align = alTop
          ShowCaption = False
          TabOrder = 0
          object cxLabel10: TcxLabel
            Left = 96
            Top = 6
            Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1086#1090
          end
          object edOperDateInfo: TcxDateEdit
            Left = 205
            Top = 5
            TabStop = False
            EditValue = 45033d
            Properties.ReadOnly = True
            TabOrder = 1
            Width = 121
          end
          object edUnitNameInfo: TcxTextEdit
            Left = 332
            Top = 5
            TabStop = False
            Properties.ReadOnly = True
            TabOrder = 2
            Width = 465
          end
          object cxButton3: TcxButton
            Left = 13
            Top = 3
            Width = 33
            Height = 25
            Action = actRefreshItog
            PaintStyle = bpsGlyph
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            TabStop = False
          end
          object cxButton4: TcxButton
            Left = 52
            Top = 3
            Width = 33
            Height = 25
            Action = actInsert_InventoryCheck
            PaintStyle = bpsGlyph
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            TabStop = False
          end
        end
        object cxGridInfo: TcxGrid
          Left = 0
          Top = 34
          Width = 830
          Height = 333
          Align = alClient
          TabOrder = 1
          LookAndFeel.ScrollbarMode = sbmClassic
          object cxGridDBTableView1: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            ScrollbarAnnotations.CustomAnnotations = <>
            DataController.DataSource = InfoDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = #1057#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = InfoGoodsName
              end
              item
                Format = ',0.####;-,0.####; ;'
                Kind = skSum
                Column = InfoRemains
              end
              item
                Format = ',0.####;-,0.####; ;'
                Kind = skSum
                Column = InfoAmount
              end
              item
                Format = ',0.####;-,0.####; '
                Kind = skSum
                Column = InfoDeficit
              end
              item
                Format = ',0.####;-,0.####; '
                Kind = skSum
                Column = InfoProficit
              end
              item
                Format = ',0.00;-,0.00; ;'
                Kind = skSum
                Column = InfoDiffSumm
              end
              item
                Format = ',0.00;-,0.00; ;'
                Kind = skSum
                Column = InfoRemains_Summ
              end
              item
                Format = ',0.00;-,0.00; ;'
                Kind = skSum
                Column = InfoSumm
              end
              item
                Format = ',0.####;-,0.####; ;'
                Kind = skSum
                Column = InfoAmountUser
              end
              item
                Format = ',0.00;-,0.00; ;'
                Kind = skSum
                Column = InfoDeficitSumm
              end
              item
                Format = ',0.00;-,0.00; ;'
                Kind = skSum
                Column = InfoProficitSumm
              end
              item
                Format = '+ ,0.####;- ,0.####; ;'
                Kind = skSum
                Column = InfoDiff
              end
              item
                Format = ',0.####;-,0.####; ;'
                Kind = skSum
                Column = InfoRemainsCurr
              end>
            DataController.Summary.SummaryGroups = <>
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
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.Content = dmMain.cxContentStyle
            Styles.Footer = dmMain.cxFooterStyle
            Styles.Header = dmMain.cxHeaderStyle
            Styles.Inactive = dmMain.cxSelection
            object InfoGoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'GoodsCode'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 44
            end
            object InfoGoodsName: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088
              DataBinding.FieldName = 'GoodsName'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 219
            end
            object InfoisCheck: TcxGridDBColumn
              Caption = #1063#1077#1082
              DataBinding.FieldName = 'isCheck'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.DisplayChecked = '1'
              Properties.DisplayUnchecked = '0'
              Properties.ValueChecked = '1'
              Properties.ValueUnchecked = '0'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 41
            end
            object InfoExpirationDate: TcxGridDBColumn
              Caption = #1052#1080#1085'. '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
              DataBinding.FieldName = 'ExpirationDate'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 67
            end
            object InfoRemainsCurr: TcxGridDBColumn
              Caption = #1058#1077#1082#1091#1097#1080#1081' '#1086#1089#1090#1072#1090#1086#1082
              DataBinding.FieldName = 'RemainsCurr'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderHint = #1058#1077#1082#1091#1097#1080#1081' '#1086#1089#1090#1072#1090#1086#1082' ('#1091#1095#1080#1090#1099#1074#1072#1077#1090' '#1074#1089#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1076#1085#1080' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080')'
              Options.Editing = False
              Width = 68
            end
            object InfoRemains: TcxGridDBColumn
              Caption = #1056#1072#1089#1095'. '#1054#1089#1090#1072#1090#1086#1082
              DataBinding.FieldName = 'Remains'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderHint = #1056#1072#1089#1095'. '#1054#1089#1090#1072#1090#1086#1082' ('#1085#1072' '#1076#1077#1085#1100' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1074#1094#1080#1080')'
              Options.Editing = False
              Width = 67
            end
            object InfoPrice: TcxGridDBColumn
              Caption = #1062#1077#1085#1072
              DataBinding.FieldName = 'Price'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00;-,0.00; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 49
            end
            object InfoRemains_Summ: TcxGridDBColumn
              Caption = 'C'#1091#1084#1084#1072' '#1088#1072#1089#1095'. '#1086#1089#1090'.'
              DataBinding.FieldName = 'Remains_Summ'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00;-,0.00; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 72
            end
            object InfoAmount: TcxGridDBColumn
              Caption = #1060#1072#1082#1090' '#1080#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082
              DataBinding.FieldName = 'Amount'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 71
            end
            object InfoSumm: TcxGridDBColumn
              Caption = 'C'#1091#1084#1084#1072' '#1092#1072#1082#1090' '#1086#1089#1090'.'
              DataBinding.FieldName = 'Summ'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00;-,0.00; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 65
            end
            object InfoAmountUser: TcxGridDBColumn
              Caption = #1060#1072#1082#1090'. '#1086#1089#1090#1072#1090#1086#1082' ('#1090#1077#1082'. '#1087#1086#1083#1100#1079'.)'
              DataBinding.FieldName = 'AmountUser'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Styles.Content = dmMain.cxHeaderL1Style
              Styles.GroupSummary = dmMain.cxHeaderStyle
              Styles.Header = dmMain.cxHeaderStyle
              Width = 73
            end
            object InfoCountUser: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1083#1100#1079'.'
              DataBinding.FieldName = 'CountUser'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 0
              Properties.DisplayFormat = ',0;-,0; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 59
            end
            object InfoDeficit: TcxGridDBColumn
              Caption = #1053#1077#1076#1086#1089#1090#1072#1095#1072
              DataBinding.FieldName = 'Deficit'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; '
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 68
            end
            object InfoDeficitSumm: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1085#1077#1076#1086#1089#1090#1072#1095#1080
              DataBinding.FieldName = 'DeficitSumm'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00;-,0.00; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 66
            end
            object InfoProficit: TcxGridDBColumn
              Caption = #1048#1079#1083#1080#1096#1077#1082
              DataBinding.FieldName = 'Proficit'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; '
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 61
            end
            object InfoProficitSumm: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1080#1079#1083#1080#1096#1082#1072
              DataBinding.FieldName = 'ProficitSumm'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00;-,0.00; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 67
            end
            object InfoDiff: TcxGridDBColumn
              Caption = #1056#1072#1079#1085#1080#1094#1072
              DataBinding.FieldName = 'Diff'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = '+ ,0.####;- ,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 65
            end
            object InfoDiffSumm: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1088#1072#1079#1085#1080#1094#1099
              DataBinding.FieldName = 'DiffSumm'
              DataBinding.IsNullValueType = True
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00;-,0.00; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 79
            end
            object InfoMIComment: TcxGridDBColumn
              Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
              DataBinding.FieldName = 'MIComment'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Styles.Content = dmMain.cxHeaderL1Style
              Styles.Header = dmMain.cxHeaderStyle
              Width = 69
            end
            object InfoisAuto: TcxGridDBColumn
              Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
              DataBinding.FieldName = 'isAuto'
              DataBinding.IsNullValueType = True
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 60
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxGridDBTableView1
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 19
    Top = 136
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
    Top = 192
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 15
    Top = 71
    inherited actRefresh: TdsdDataSetRefresh
      ShortCut = 0
    end
    object actDoLoadData: TAction
      Category = 'DSDLib'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      OnExecute = actDoLoadDataExecute
    end
    object actUnitChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUnitChoice'
      FormName = 'TUnitLocalForm'
      FormNameParam.Value = 'TUnitLocalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actLoadData: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actDoLoadData
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
    end
    object actReCreteInventDate: TAction
      Category = 'DSDLib'
      Caption = 'actReCreteInventDate'
      OnExecute = actReCreteInventDateExecute
    end
    object actDataDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDataDialog'
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDate'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actDoCreateInventory: TAction
      Category = 'DSDLib'
      Caption = 'actDoCreateInventory'
      OnExecute = actDoCreateInventoryExecute
    end
    object mactCreteNewInvent: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actReCreteInventDate
        end
        item
          Action = actDataDialog
        end
        item
          Action = actUnitChoice
        end
        item
          Action = actDoCreateInventory
        end>
      Caption = #1053#1072#1095#1072#1090#1100' '#1085#1086#1074#1091#1102' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1102
    end
    object actContinueInvent: TAction
      Category = 'DSDLib'
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080' ('#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1086#1074')'
      OnExecute = actContinueInventExecute
    end
    object actContinueInventManual: TAction
      Category = 'DSDLib'
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080' ('#1088#1091#1095#1085#1086#1081' '#1074#1074#1086#1076')'
      OnExecute = actContinueInventManualExecute
    end
    object actExit: TAction
      Category = 'DSDLib'
      Caption = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actInfoInvent: TAction
      Category = 'DSDLib'
      Caption = #1048#1090#1086#1075#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      OnExecute = actInfoInventExecute
    end
    object actGoodsInventory: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actSetFocusededBarCode
      PostDataSetBeforeExecute = False
      Caption = #1053#1072#1081#1090#1080' '#1090#1086#1074#1072#1088' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
      Hint = #1053#1072#1081#1090#1080' '#1090#1086#1074#1072#1088' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
      ImageIndex = 27
      FormName = 'TGoodsInventoryForm'
      FormNameParam.Value = 'TGoodsInventoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BarCode'
          Value = Null
          Component = edBarCode
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSetFocusededBarCode: TdsdSetFocusedAction
      Category = 'DSDLib'
      MoveParams = <>
      ControlName.Value = 'edBarCode'
      ControlName.DataType = ftString
      ControlName.MultiSelectSeparator = ','
    end
    object actSetFocusedAmount: TdsdSetFocusedAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetFocusedAmount'
      ControlName.Value = 'ceAmount'
      ControlName.DataType = ftString
      ControlName.MultiSelectSeparator = ','
    end
    object actSendInventChild: TAction
      Category = 'DSDLib'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      OnExecute = actSendInventChildExecute
    end
    object mactSendInvent: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_MI_Inventory
        end
        item
          Action = actUpdateSend
        end>
      DataSource = SendInventDS
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1086#1074' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1086#1074' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
    end
    object actInsert_MI_Inventory: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI_Inventory
      StoredProcList = <
        item
          StoredProc = spInsert_MI_Inventory
        end>
      Caption = 'actInsert_MI_Inventory'
    end
    object actUpdateSend: TAction
      Category = 'DSDLib'
      Caption = 'actUpdateSend'
      OnExecute = actUpdateSendExecute
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actSetFocusedManualAmount
      StoredProc = spSelectManual
      StoredProcList = <
        item
          StoredProc = spSelectManual
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1089' '#1085#1072#1083#1080#1095#1080#1077#1084' '#1080' '#1080#1085#1074#1077#1085#1090#1072#1088#1077#1079#1080#1088#1086#1074#1072#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1089' '#1085#1072#1083#1080#1095#1080#1077#1084' '#1080' '#1080#1085#1074#1077#1085#1090#1072#1088#1077#1079#1080#1088#1086#1074#1072#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actSetFocusedManualAmount: TdsdSetFocusedAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actSetEditAmount
      Caption = 'actSetFocusedAmount'
      ControlName.Value = 'ManualAmount'
      ControlName.DataType = ftString
      ControlName.MultiSelectSeparator = ','
    end
    object actSetEditAmount: TAction
      Category = 'DSDLib'
      Caption = 'actSetEditAmount'
      OnExecute = actSetEditAmountExecute
    end
    object actRefreshItog: TAction
      Category = 'DSDLib'
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 115
      OnExecute = actRefreshItogExecute
    end
    object actInsert_InventoryCheck: TAction
      Category = 'DSDLib'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074#1089#1077' '#1095#1077#1082#1080' '#1079#1072' '#1076#1077#1085#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074#1089#1077' '#1095#1077#1082#1080' '#1079#1072' '#1076#1077#1085#1100
      ImageIndex = 30
      OnExecute = actInsert_InventoryCheckExecute
    end
    object actSetFocusedInfoAmount: TdsdSetFocusedAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetFocusedInfoAmount'
      ControlName.Value = 'InfoAmountUser'
      ControlName.DataType = ftString
      ControlName.MultiSelectSeparator = ','
    end
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 169
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 336
    Top = 241
  end
  object MainMenu: TMainMenu
    Images = dmMain.ImageList
    Left = 232
    Top = 72
    object N3: TMenuItem
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      object N4: TMenuItem
        Action = mactCreteNewInvent
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Action = actContinueInvent
      end
      object N9: TMenuItem
        Action = actContinueInventManual
      end
      object N11: TMenuItem
        Action = actInfoInvent
      end
    end
    object N1: TMenuItem
      Caption = #1054#1073#1084#1077#1085' '#1076#1072#1085#1085#1099#1084#1080
      object N2: TMenuItem
        Action = actLoadData
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object N8: TMenuItem
        Action = actSendInventChild
      end
    end
    object N10: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = actExitExecute
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 256
  end
  object spGet_User_IsAdmin: TdsdStoredProc
    StoredProcName = 'gpGet_User_IsAdmin'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_User_IsAdmin'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 142
  end
  object spSelectChilg: TdsdStoredProcSQLite
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    SQLList = <
      item
        SQL.Strings = (
          'SELECT IC.Id            AS Id'
          '     , IC.GoodsId       AS GoodsId'
          '     , G.Code           AS GoodsCode'
          '     , G.Name           AS GoodsName'
          '     , IC.Amount        AS Amount'
          '     , ICS.AmountGoods  AS AmountGoods'
          '     , IC.DateInput     AS Date_Insert'
          '     , us.Name          AS UserName'
          '     , IC.IsSend        AS IsSend'
          
            '     , CAST (ROW_NUMBER() OVER (ORDER BY IC.DateInput) AS Intege' +
            'r) AS Num'
          
            '     , CASE WHEN CAST (ROW_NUMBER() OVER (PARTITION BY IC.GoodsI' +
            'd ORDER BY IC.GoodsId, IC.DateInput DESC) AS Integer) = 1 THEN 1' +
            ' ELSE 0 END  AS isLast'
          
            '     , CASE WHEN COALESCE (IC.CheckId, 0) = 0 THEN 0 ELSE 1 END ' +
            'AS isCheck'
          'FROM InventoryChild AS IC'
          '     LEFT JOIN Goods AS G ON G.Id = IC.GoodsId'
          '     LEFT JOIN UserSettings AS us ON us.Id = IC.UserInputId'
          
            '     LEFT JOIN (SELECT IC.GoodsId, MAX(IC.DateInput) AS DateInpu' +
            't, CAST(SUM(IC.Amount) AS Float) AS AmountGoods '
          
            '                FROM InventoryChild AS IC GROUP BY IC.Inventory,' +
            ' IC.GoodsId) AS ICS ON ICS.DateInput = IC.DateInput  '
          
            '                                                                ' +
            '                   AND ICS.GoodsId = IC.GoodsId  '
          'WHERE IC.Inventory = :inId'
          'ORDER BY IC.DateInput DESC')
      end>
    Left = 341
    Top = 105
  end
  object InfoDS: TDataSource
    DataSet = InfoCDS
    Left = 528
    Top = 257
  end
  object InfoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = InfoCDSBeforePost
    AfterPost = InfoCDSAfterPost
    OnPostError = InfoCDSPostError
    Left = 528
    Top = 185
  end
  object spSelectInfo: TdsdStoredProcSQLite
    DataSet = InfoCDS
    DataSets = <
      item
        DataSet = InfoCDS
      end>
    Params = <
      item
        Name = 'inInventory'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    ParamKeyField = 'GoodsId'
    SQLList = <
      item
        SQL.Strings = (
          'SELECT ID.Id'
          '     , COALESCE (ID.GoodsId, IC.GoodsId) AS GoodsId'
          '     , G.Code   AS GoodsCode'
          '     , G.Name  AS GoodsName'
          '     , ID.RemainsCurr'
          '     , ID.Remains '
          '     , ID.ExpirationDate'
          '     , CAST(COALESCE(ID.Price, R.Price, 0) AS Float)    AS Price'
          
            '     , CAST(COALESCE (ID.Remains, 0) * COALESCE(ID.Price, R.Pric' +
            'e, 0) AS Float)   AS Remains_Summ'
          
            '     , CAST(COALESCE (ID.Amount, 0) + COALESCE (IC.Amount, 0) AS' +
            ' Float)  AS Amount'
          
            '     , CAST((COALESCE (ID.Amount, 0) + COALESCE (IC.Amount, 0)) ' +
            '* COALESCE(ID.Price, R.Price, 0) AS Float)   AS Summ'
          
            '     , CAST(COALESCE (ID.AmountUser, 0) + COALESCE (IC.Amount, 0' +
            ') AS Float)                         AS AmountUser'
          
            '     , CAST(COALESCE (ID.CountUser, 0) + CASE WHEN COALESCE (IC.' +
            'GoodsId, 0) <> 0 THEN 1 ELSE 0 END AS Integer) AS CountUser'
          
            '     , CAST(CASE WHEN COALESCE (ID.Remains, 0) > CAST(COALESCE (' +
            'ID.Amount, 0) + COALESCE (IC.Amount, 0) AS Float)'
          
            '                 THEN COALESCE (ID.Remains, 0) - CAST(COALESCE (' +
            'ID.Amount, 0) + COALESCE (IC.Amount, 0) AS Float)'
          
            '                 ELSE 0 END AS Float)                           ' +
            '                            AS Deficit'
          
            '     , CAST(CASE WHEN COALESCE (ID.Remains, 0) > CAST(COALESCE (' +
            'ID.Amount, 0) + COALESCE (IC.Amount, 0) AS Float)'
          
            '                 THEN (COALESCE (ID.Remains, 0) - CAST(COALESCE ' +
            '(ID.Amount, 0) + COALESCE (IC.Amount, 0) AS Float)) * COALESCE(I' +
            'D.Price, R.Price, 0)'
          
            '                 ELSE 0 END AS Float)                           ' +
            '                            AS DeficitSumm'
          
            '     , CAST(CASE WHEN CAST(COALESCE (ID.Amount, 0) + COALESCE (I' +
            'C.Amount, 0) AS Float) > COALESCE (ID.Remains, 0)'
          
            '                 THEN CAST(COALESCE (ID.Amount, 0) + COALESCE (I' +
            'C.Amount, 0) AS Float) - COALESCE (ID.Remains, 0)'
          
            '                 ELSE 0 END AS Float)                           ' +
            '                            AS Proficit'
          
            '     , CAST(CASE WHEN CAST(COALESCE (ID.Amount, 0) + COALESCE (I' +
            'C.Amount, 0) AS Float) > COALESCE (ID.Remains, 0)'
          
            '                 THEN (CAST(COALESCE (ID.Amount, 0) + COALESCE (' +
            'IC.Amount, 0) AS Float) - COALESCE (ID.Remains, 0)) * COALESCE(I' +
            'D.Price, R.Price, 0)'
          
            '                 ELSE 0 END AS Float)                           ' +
            '                            AS ProficitSumm'
          
            '     , CAST(( CAST(COALESCE (ID.Amount, 0) + COALESCE (IC.Amount' +
            ', 0) - COALESCE (ID.Remains, 0) AS Float)) AS Float) AS Diff'
          
            '     , CAST(( CAST(COALESCE (ID.Amount, 0) + COALESCE (IC.Amount' +
            ', 0) - COALESCE (ID.Remains, 0) AS Float))'
          
            '                 * COALESCE(ID.Price, R.Price, 0) AS Float)     ' +
            '                                           AS DiffSumm'
          '     , ID.MIComment'
          '     , ID.isAuto'
          
            '     , COALESCE(ICC.isCheck, 0)                                 ' +
            '                                                  AS isCheck'
          'FROM InventoryDate AS ID'
          '     FULL JOIN (SELECT IC.GoodsId       AS GoodsId'
          
            #9#9#9#9'     , CAST(COALESCE (SUM(IC.Amount), 0.0) as Float)  AS Amo' +
            'unt'
          
            #9#9#9#9'FROM InventoryChild AS IC                                   ' +
            ' '
          #9#9#9#9'WHERE IC.Inventory = :inInventory'
          #9#9#9#9'  AND IC.IsSend = '#39'N'#39
          #9#9#9#9'GROUP BY IC.GoodsId) AS IC ON IC.GoodsId = ID.GoodsId '
          
            '    INNER JOIN Goods AS G ON G.id = COALESCE (ID.GoodsId, IC.Goo' +
            'dsId) '
          '     LEFT JOIN (SELECT IC.GoodsId       AS GoodsId'
          
            #9#9#9#9'     , CASE WHEN MAX(COALESCE(IC.CheckId, 0)) > 0 THEN 1 ELS' +
            'E 0 END AS isCheck'
          
            #9#9#9#9'FROM InventoryChild AS IC                                   ' +
            ' '
          #9#9#9#9'WHERE IC.Inventory = :inInventory'
          #9#9#9#9'GROUP BY IC.GoodsId) AS ICC ON ICC.GoodsId = ID.GoodsId '
          
            '    LEFT JOIN Remains AS R ON R.Goodsid = COALESCE (ID.GoodsId, ' +
            'IC.GoodsId)'
          #9'                     AND R.UnitId  =  :inUnitId'
          'WHERE ID.UnitId =  :inUnitId OR COALESCE (IC.GoodsId, 0) <> 0'
          'ORDER BY 3')
      end>
    Left = 525
    Top = 121
  end
  object DBViewAddOnInfo: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 733
    Top = 185
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridChildDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 645
    Top = 249
  end
  object SendInventDS: TDataSource
    DataSet = SendInventCDS
    Left = 736
    Top = 241
  end
  object SendInventCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 632
    Top = 177
  end
  object spSendInvent: TdsdStoredProcSQLite
    DataSet = SendInventCDS
    DataSets = <
      item
        DataSet = SendInventCDS
      end>
    Params = <
      item
        Name = 'inInventory'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    SQLList = <
      item
        SQL.Strings = (
          
            'SELECT i.UnitId, i.OperDate, ic.Id, ic.GoodsId, ic.Amount, CAST(' +
            'ic.DateInput AS TVarChar) AS DateInput, ic.UserInputId, ic.Check' +
            'Id '
          'FROM InventoryChild AS ic'
          '     INNER JOIN Inventory AS i ON i.ID = ic.Inventory'
          'WHERE ic.IsSend = '#39'N'#39
          'ORDER BY ic.DateInput')
      end>
    Left = 629
    Top = 121
  end
  object spInsert_MI_Inventory: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_FarmacyInventory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = SendInventCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = SendInventCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = SendInventCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = SendInventCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateInput'
        Value = ''
        Component = SendInventCDS
        ComponentItem = 'DateInput'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserInputId'
        Value = 0.000000000000000000
        Component = SendInventCDS
        ComponentItem = 'UserInputId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCheckId'
        Value = Null
        Component = SendInventCDS
        ComponentItem = 'CheckId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 123
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitName
    FormNameParam.Value = 'TUnitLocalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitLocalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
    Top = 32
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateIventory
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edUnitName
      end>
    Left = 136
    Top = 201
  end
  object spUpdateIventory: TdsdStoredProcSQLite
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inInventory'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
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
    PackSize = 1
    SQLList = <
      item
        SQL.Strings = (
          'UPDATE Inventory SET OperDate = :inOperDate, UnitId = :inUnitId'
          'WHERE Inventory.ID = :inInventory'
          'RETURNING *;')
      end>
    Left = 133
    Top = 257
  end
  object GuidesUnitManual: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitNameManual
    FormNameParam.Value = 'TUnitLocalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitLocalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitManual
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitManual
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 704
    Top = 32
  end
  object HeaderSaverManual: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateIventoryManual
    ControlList = <
      item
        Control = edOperDateManual
      end
      item
        Control = edUnitNameManual
      end>
    Left = 256
    Top = 201
  end
  object spUpdateIventoryManual: TdsdStoredProcSQLite
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inInventory'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnitManual
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 45033d
        Component = edOperDateManual
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    SQLList = <
      item
        SQL.Strings = (
          'UPDATE Inventory SET OperDate = :inOperDate, UnitId = :inUnitId'
          'WHERE Inventory.ID = :inInventory'
          'RETURNING *;')
      end>
    Left = 253
    Top = 257
  end
  object spSelectManual: TdsdStoredProcSQLite
    DataSet = ManualCDS
    DataSets = <
      item
        DataSet = ManualCDS
      end>
    Params = <
      item
        Name = 'inInventory'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    ParamKeyField = 'GoodsId'
    SQLList = <
      item
        SQL.Strings = (
          'SELECT G.Id             AS GoodsId'
          '     , G.Code           AS GoodsCode'
          '     , G.Name           AS GoodsName'
          '     , R.Remains        AS Remains'
          '     , R.Price          AS Price'
          '     , CAST(COALESCE (SUM(IC.Amount), 0.0) as Float)  AS Amount'
          'FROM  Goods AS G'
          
            '     LEFT JOIN InventoryChild AS IC ON IC.Inventory = :inInvento' +
            'ry'
          '                                   AND IC.GoodsId = G.Id '
          '     LEFT JOIN Remains AS R ON R.GoodsId = G.id'
          '                           AND R.UnitId =  :inUnitId '
          
            'WHERE (COALESCE  (R.Remains, IC.Amount) <> 0) OR (:inisShowAll =' +
            ' '#39'Y'#39')'
          'GROUP BY G.Id'
          '       , G.Code'
          '       , G.Name '
          '       , R.Remains'
          'ORDER BY G.Name')
      end>
    Left = 429
    Top = 121
  end
  object ManualCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    OnPostError = ManualCDSPostError
    Left = 424
    Top = 177
  end
  object ManualDS: TDataSource
    DataSet = ManualCDS
    Left = 424
    Top = 257
  end
  object DBViewAddOnManual: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 357
    Top = 305
  end
  object FieldFilter: TdsdFieldFilter
    TextEdit = TextEdit
    DataSet = ManualCDS
    Column = ManualcxGoodsName
    ColumnList = <
      item
        Column = ManualcxGoodsName
      end
      item
        Column = ManualGoodsCode
      end>
    CheckBoxList = <>
    Left = 248
    Top = 120
  end
  object spUpdate_Comment: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Inventory_Comment'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
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
    Left = 136
    Top = 318
  end
  object InventoryCheckCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    OnPostError = ManualCDSPostError
    Left = 488
    Top = 33
  end
  object spInventoryCheck: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_InventoryLocalCheck'
    DataSet = InventoryCheckCDS
    DataSets = <
      item
        DataSet = InventoryCheckCDS
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 38
  end
  object spUnitComplInventFull: TdsdStoredProc
    StoredProcName = 'gpUpdate_Inventory_UnitComplInventFull'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 310
  end
end
