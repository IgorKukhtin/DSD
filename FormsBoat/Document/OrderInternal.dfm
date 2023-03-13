object OrderInternalForm: TOrderInternalForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1082#1072#1079' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'>'
  ClientHeight = 654
  ClientWidth = 1088
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 1088
    Height = 93
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 14
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 151
    end
    object cxLabel1: TcxLabel
      Left = 14
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'
    end
    object edOperDate: TcxDateEdit
      Left = 171
      Top = 23
      EditValue = 42160d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 91
    end
    object cxLabel2: TcxLabel
      Left = 171
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 992
      Top = 50
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Visible = False
      Width = 198
    end
    object edTo: TcxButtonEdit
      Left = 791
      Top = 82
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Visible = False
      Width = 128
    end
    object cxLabel3: TcxLabel
      Left = 1034
      Top = 50
      Hint = #1054#1090' '#1082#1086#1075#1086
      Caption = #1054#1090' '#1082#1086#1075#1086
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object cxLabel4: TcxLabel
      Left = 1087
      Top = 54
      Caption = 'Lieferanten'
      Visible = False
    end
    object cxLabel11: TcxLabel
      Left = 14
      Top = 46
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 14
      Top = 63
      Properties.Buttons = <
        item
          Action = actCompleteMovement
          Kind = bkGlyph
        end
        item
          Action = actUnCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = actDeleteMovement
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 151
    end
    object cxLabel16: TcxLabel
      Left = 273
      Top = 5
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 273
      Top = 23
      TabOrder = 11
      Width = 491
    end
    object cxLabel17: TcxLabel
      Left = 773
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 773
      Top = 23
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 146
    end
    object cxLabel18: TcxLabel
      Left = 928
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 928
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 146
    end
    object cxLabel15: TcxLabel
      Left = 273
      Top = 46
      Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
    end
    object cxLabel6: TcxLabel
      Left = 580
      Top = 46
      Caption = 'Boat'
    end
    object edProduct: TcxButtonEdit
      Left = 580
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 494
    end
    object edOrderClient: TcxButtonEdit
      Left = 273
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 301
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 119
    Width = 1088
    Height = 535
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 535
    ClientRectRight = 1088
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1088
        Height = 511
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 0
        object cxGrid_Master: TcxGrid
          Left = 1
          Top = 1
          Width = 1086
          Height = 206
          Align = alTop
          TabOrder = 1
          object cxGrid_MasterDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = MasterDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount
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
                Column = Amount
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
                Format = 'C'#1090#1088#1086#1082': ,0'
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
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsData.Appending = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object Ord: TcxGridDBColumn
              Caption = #8470' '#1087'/'#1087
              DataBinding.FieldName = 'Ord'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 50
            end
            object isEnabled: TcxGridDBColumn
              Caption = 'Yes/no'
              DataBinding.FieldName = 'isEnabled'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 38
            end
            object GoodsGroupNameFull: TcxGridDBColumn
              Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
              DataBinding.FieldName = 'GoodsGroupNameFull'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 120
            end
            object GoodsGroupName: TcxGridDBColumn
              Caption = #1043#1088#1091#1087#1087#1072
              DataBinding.FieldName = 'GoodsGroupName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 120
            end
            object DescName: TcxGridDBColumn
              Caption = #1069#1083#1077#1084#1077#1085#1090
              DataBinding.FieldName = 'DescName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 64
            end
            object Article: TcxGridDBColumn
              Caption = 'Artikel Nr'
              DataBinding.FieldName = 'Article'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Caption = 'GoodsForm'
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object EAN: TcxGridDBColumn
              DataBinding.FieldName = 'EAN'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Caption = 'GoodsForm'
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = 'EAN'
              Options.Editing = False
              Width = 106
            end
            object GoodsCode: TcxGridDBColumn
              Caption = 'Interne Nr'
              DataBinding.FieldName = 'GoodsCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object GoodsName: TcxGridDBColumn
              Caption = #1059#1079#1077#1083'/'#1051#1086#1076#1082#1072
              DataBinding.FieldName = 'GoodsName'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Action = actChoiceFormOrderClientItem
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 200
            end
            object ProdColorName_goods: TcxGridDBColumn
              Caption = 'Farbe'
              DataBinding.FieldName = 'ProdColorName_goods'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Comment_goods: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1059#1079#1077#1083')'
              DataBinding.FieldName = 'Comment_goods'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object MeasureName: TcxGridDBColumn
              Caption = #1045#1076'. '#1080#1079#1084'.'
              DataBinding.FieldName = 'MeasureName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 45
            end
            object Amount: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.########;-,0.########; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 70
            end
            object Amount_unit: TcxGridDBColumn
              Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074
              DataBinding.FieldName = 'Amount_unit'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Comment: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 150
            end
            object FromName: TcxGridDBColumn
              Caption = 'Kunden'
              DataBinding.FieldName = 'FromName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 120
            end
            object InvNumberFull_OrderClient: TcxGridDBColumn
              Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
              DataBinding.FieldName = 'InvNumberFull_OrderClient'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Width = 70
            end
            object CIN: TcxGridDBColumn
              Caption = 'CIN Nr.'
              DataBinding.FieldName = 'CIN'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 100
            end
            object ProductName: TcxGridDBColumn
              Caption = 'Boat'
              DataBinding.FieldName = 'ProductName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderGlyphAlignmentHorz = taCenter
              HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 100
            end
            object InsertName: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
              DataBinding.FieldName = 'InsertName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076#1072#1085#1080#1077
              Options.Editing = False
              Width = 70
            end
            object InsertDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072'/'#1074#1088'. ('#1089#1086#1079#1076'.)'
              DataBinding.FieldName = 'InsertDate'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1077
              Options.Editing = False
              Width = 70
            end
            object Article_all: TcxGridDBColumn
              Caption = '***Artikel Nr'
              DataBinding.FieldName = 'Article_all'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              Visible = False
              Width = 70
            end
            object isErased: TcxGridDBColumn
              Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
              DataBinding.FieldName = 'isErased'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
          end
          object cxGrid_MasterLevel: TcxGridLevel
            GridView = cxGrid_MasterDBTableView
          end
        end
        object cxGrid_Child: TcxGrid
          Left = 1
          Top = 393
          Width = 1086
          Height = 117
          Align = alBottom
          TabOrder = 2
          object cxGridDBTableView_child: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ChildDS
            DataController.Filter.Options = [fcoCaseInsensitive]
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
                Column = AmountReserv_ch3
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount_ch3
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = AmountSend_ch3
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
                Format = 'C'#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = GoodsName_ch3
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = AmountReserv_ch3
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount_ch3
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = AmountSend_ch3
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
            object ReceiptLevelName_ch3: TcxGridDBColumn
              Caption = 'Level'
              DataBinding.FieldName = 'ReceiptLevelName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object GoodsCode_ch3: TcxGridDBColumn
              Caption = 'Interne Nr'
              DataBinding.FieldName = 'GoodsCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Article_ch3: TcxGridDBColumn
              Caption = 'Artikel Nr'
              DataBinding.FieldName = 'Article'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object GoodsName_ch3: TcxGridDBColumn
              Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
              DataBinding.FieldName = 'GoodsName'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Caption = 'actGoodsChoiceForm'
                  Default = True
                  Hint = 'actGoodsChoiceForm'
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 155
            end
            object ProdColorName_goods_ch3: TcxGridDBColumn
              Caption = 'Farbe'
              DataBinding.FieldName = 'ProdColorName_goods'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object Amount_ch3: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.########;-,0.########; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' ('#1096#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080')'
              Width = 70
            end
            object AmountReserv_ch3: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074
              DataBinding.FieldName = 'AmountReserv'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.########;-,0.########; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1050#1086#1083'-'#1074#1086' '#1088#1077#1079#1077#1088#1074
              Options.Editing = False
              Width = 70
            end
            object AmountSend_ch3: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' /'#1087#1077#1088#1077#1084#1077#1097'.'
              DataBinding.FieldName = 'AmountSend'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.########;-,0.########; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076' /'#1087#1077#1088#1077#1084#1077#1097'.'
              Options.Editing = False
              Width = 100
            end
            object ProdOptionsName_ch3: TcxGridDBColumn
              Caption = #1054#1087#1094#1080#1103
              DataBinding.FieldName = 'ProdOptionsName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderGlyphAlignmentHorz = taCenter
              Options.Editing = False
              Width = 100
            end
            object ProdColorPatternName_ch3: TcxGridDBColumn
              Caption = #1069#1083#1077#1084#1077#1085#1090' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088#1072
              DataBinding.FieldName = 'ProdColorPatternName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderGlyphAlignmentHorz = taCenter
              Options.Editing = False
              Width = 58
            end
            object ColorPatternName_ch3: TcxGridDBColumn
              Caption = #1064#1072#1073#1083#1086#1085
              DataBinding.FieldName = 'ColorPatternName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderGlyphAlignmentHorz = taCenter
              HeaderHint = #1064#1072#1073#1083#1086#1085' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088#1072
              Options.Editing = False
              Width = 58
            end
            object Comment_goods_ch3: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1050#1086#1084#1087#1083'.)'
              DataBinding.FieldName = 'Comment_goods'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
              Options.Editing = False
              Width = 100
            end
            object UnitName_ch3: TcxGridDBColumn
              Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
              DataBinding.FieldName = 'UnitName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 108
            end
            object isErased_ch3: TcxGridDBColumn
              Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
              DataBinding.FieldName = 'isErased'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
          end
          object cxGridLevel3: TcxGridLevel
            GridView = cxGridDBTableView_child
          end
        end
        object cxTopSplitter: TcxSplitter
          Left = 1
          Top = 207
          Width = 1086
          Height = 8
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salTop
          Control = cxGrid_Master
        end
        object cxGrid_Detail: TcxGrid
          Left = 1
          Top = 215
          Width = 1086
          Height = 170
          Align = alClient
          TabOrder = 0
          object cxGridDBTableView_Det: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = DetailDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount_ch4
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
                Column = Hours_ch4
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Summ_ch4
              end>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount_ch4
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
                Format = 'C'#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = PersonalName_ch4
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
                Column = Hours_ch4
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Summ_ch4
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
            object Article_ch4: TcxGridDBColumn
              Caption = 'Artikel Nr'
              DataBinding.FieldName = 'Article'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object ReceiptServiceCode_ch4: TcxGridDBColumn
              Caption = 'Interne Nr'
              DataBinding.FieldName = 'ReceiptServiceCode'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object ReceiptServiceName_ch4: TcxGridDBColumn
              Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1072#1073#1086#1090
              DataBinding.FieldName = 'ReceiptServiceName'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Action = actChoiceFormReceiptService
                  Default = True
                  Kind = bkEllipsis
                end>
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 141
            end
            object PersonalCode_ch4: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'PersonalCode'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object PersonalName_ch4: TcxGridDBColumn
              Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
              DataBinding.FieldName = 'PersonalName'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Action = actPersonalChoiceForm
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 149
            end
            object Amount_ch4: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' ('#1088#1072#1089#1095#1077#1090')'
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object OperPrice_ch4: TcxGridDBColumn
              Caption = #1062#1077#1085#1072' '#1079#1072' '#1095'.'
              DataBinding.FieldName = 'OperPrice'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 80
            end
            object Hours_ch4: TcxGridDBColumn
              Caption = #1055#1083#1072#1085' '#1095#1072#1089#1086#1074
              DataBinding.FieldName = 'Hours'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 95
            end
            object Summ_ch4: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1055#1083#1072#1085
              DataBinding.FieldName = 'Summ'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 88
            end
            object Comment_ch4: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 80
            end
            object isErased_ch4: TcxGridDBColumn
              Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
              DataBinding.FieldName = 'isErased'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
          end
          object cxGridLevel_Det: TcxGridLevel
            GridView = cxGridDBTableView_Det
          end
        end
        object cxSplitter2: TcxSplitter
          Left = 1
          Top = 385
          Width = 1086
          Height = 8
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salBottom
          Control = cxGrid_Child
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086
      ImageIndex = 1
      object cxGrid2: TcxGrid
        Left = 0
        Top = 0
        Width = 1088
        Height = 511
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView_DetAll: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS_All
          DataController.Filter.Options = [fcoCaseInsensitive]
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
              Column = Amount_ch5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Hours_ch5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ch54
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
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
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
              Column = Amount_ch5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Hours_ch5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ch54
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
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object Article_ReceiptService_ch5: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article_ReceiptService'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReceiptServiceCode_ch5: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'ReceiptServiceCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ReceiptServiceName_ch5: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1072#1073#1086#1090
            DataBinding.FieldName = 'ReceiptServiceName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormReceiptService_DetAll
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 141
          end
          object PersonalCode_ch5: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object PersonalName_ch5: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'PersonalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPersonalChoiceForm_DetAll
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 149
          end
          object Amount_ch5: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperPrice_ch5: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072' '#1095'.'
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Hours_ch5: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'Hours'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object Summ_ch54: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1083#1072#1085
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object Comment_ch5: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object isErased_ch5: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object DescName_master_ch5: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'DescName_master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object Article_master_ch5: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article_master'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'GoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsCode_master_ch5: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'GoodsCode_master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName_master_ch5: TcxGridDBColumn
            Caption = #1059#1079#1077#1083'/'#1051#1086#1076#1082#1072
            DataBinding.FieldName = 'GoodsName_master'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormOrderClientItem
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object Amount_master_ch5: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount_master'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumberFull_OrderClient_ch5: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumberFull_OrderClient'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1079#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 70
          end
          object CIN_OrderClient_ch5: TcxGridDBColumn
            Caption = 'CIN Nr.'
            DataBinding.FieldName = 'CIN_OrderClient'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProductName_OrderClient_ch5: TcxGridDBColumn
            Caption = 'Boat'
            DataBinding.FieldName = 'ProductName_OrderClient'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object FromName_OrderClient_ch5: TcxGridDBColumn
            Caption = 'Kunden'
            DataBinding.FieldName = 'FromName_OrderClient'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090' '#1082#1086#1075#1086
            Options.Editing = False
            Width = 120
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView_DetAll
        end
      end
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInputOutput
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
        Name = 'FormName'
        Value = 'TOrderClientForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = 'true'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementItemId'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 870
    Top = 119
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderInternal_Master'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'Key'
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
    PackSize = 1
    Left = 288
    Top = 183
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 6
    Top = 231
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordGoods'
        end
        item
          Visible = True
          ItemName = 'BarSubItemGoods'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbb'
        end
        item
          Visible = True
          ItemName = 'BarSubItemBoat'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordDetail'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordDetailAll'
        end
        item
          Visible = True
          ItemName = 'BarSubItemReceiptService'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordChild'
        end
        item
          Visible = True
          ItemName = 'BarSubItemGoodsChild'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbErasedMI_Master'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintSticker'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbGridToExel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbMIContainer: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Visible = ivAlways
      ImageIndex = 57
    end
    object bbMovementItemProtocol: TdxBarButton
      Action = actMIMasterProtocolOpenForm
      Category = 0
    end
    object bbShowErasedCost: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Category = 0
      Enabled = False
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Visible = ivAlways
      ImageIndex = 64
    end
    object bbPrintSticker: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbMIContainerCost: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1079#1072#1090#1088#1072#1090'>'
      Category = 0
      Enabled = False
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1079#1072#1090#1088#1072#1090'>'
      Visible = ivAlways
      ImageIndex = 57
    end
    object bbMIChildProtocolOpenForm: TdxBarButton
      Action = actMIChildProtocolOpenForm
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenForm
      Category = 0
    end
    object bbErasedMI_Master: TdxBarButton
      Action = macErasedMI_Master
      Category = 0
      ImageIndex = 52
    end
    object bbSetErasedChild: TdxBarButton
      Action = SetErasedChild
      Category = 0
    end
    object bbSetUnErasedChild: TdxBarButton
      Action = SetUnErasedChild
      Category = 0
    end
    object bbb: TdxBarButton
      Action = actInsertRecordBoat
      Category = 0
    end
    object bbUpdateRecordBoat: TdxBarButton
      Action = actChoiceFormOrderClient
      Category = 0
    end
    object bbInsertRecordGoods: TdxBarButton
      Action = actInsertRecordGoods
      Category = 0
    end
    object bbChoiceFormOrderClientItem: TdxBarButton
      Action = actChoiceFormOrderClientItem
      Category = 0
    end
    object bbInsertRecordDetail: TdxBarButton
      Action = actInsertRecordDetail
      Category = 0
    end
    object bbInsertRecordDetailAll: TdxBarButton
      Action = actInsertRecordDetailAll
      Category = 0
    end
    object bbChoiceFormReceiptService: TdxBarButton
      Action = actChoiceFormReceiptService
      Category = 0
    end
    object bbChoiceFormReceiptService_DetAll: TdxBarButton
      Action = actChoiceFormReceiptService_DetAll
      Category = 0
    end
    object bbSetErasedDetail: TdxBarButton
      Action = actSetErasedDetail
      Category = 0
    end
    object bbSetErasedDetail_All: TdxBarButton
      Action = actSetErasedDetail_All
      Category = 0
    end
    object bbSetUnErasedDetail: TdxBarButton
      Action = actSetUnErasedDetail
      Category = 0
    end
    object bbSetUnErasedDetail_All: TdxBarButton
      Action = SetUnErasedDetail_All
      Category = 0
    end
    object bbMIDetailProtocolOpenForm: TdxBarButton
      Action = actMIDetailProtocolOpenForm
      Category = 0
    end
    object bbMIDetailAllProtocolOpenForm: TdxBarButton
      Action = actMIDetailAllProtocolOpenForm
      Category = 0
    end
    object BarSubItemBoat: TdxBarSubItem
      Caption = #1051#1086#1076#1082#1072
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateRecordBoat'
        end
        item
          Visible = True
          ItemName = 'BarSubItemBoatSep1'
        end
        item
          Visible = True
          ItemName = 'bbSetErased_boat'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased_boat'
        end
        item
          Visible = True
          ItemName = 'BarSubItemBoatSep2'
        end
        item
          Visible = True
          ItemName = 'bbMIMasterBoatProtocolOpenForm'
        end>
    end
    object BarSubItemGoods: TdxBarSubItem
      Caption = #1059#1079#1077#1083
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbChoiceFormOrderClientItem'
        end
        item
          Visible = True
          ItemName = 'BarSubItemGoodsSep1'
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
          ItemName = 'BarSubItemGoodsSep2'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end>
    end
    object BarSubItemReceiptService: TdxBarSubItem
      Caption = #1056#1072#1073#1086#1090#1099
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbChoiceFormReceiptService'
        end
        item
          Visible = True
          ItemName = 'bbChoiceFormReceiptService_DetAll'
        end
        item
          Visible = True
          ItemName = 'BarSubItemDetailSep1'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedDetail'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedDetail_All'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedDetail'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedDetail_All'
        end
        item
          Visible = True
          ItemName = 'BarSubItemDetailSep2'
        end
        item
          Visible = True
          ItemName = 'bbMIDetailProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbMIDetailAllProtocolOpenForm'
        end>
    end
    object BarSubItemGoodsChild: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbOpenGoodsChoiceForm'
        end
        item
          Visible = True
          ItemName = 'BarSubItemChildSep1'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedChild'
        end
        item
          Visible = True
          ItemName = 'BarSubItemChildSep2'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocolOpenForm'
        end>
    end
    object BarSubItemGoodsSep1: TdxBarSeparator
      Caption = 'BarSubItemGoodsSep1'
      Category = 0
      Hint = 'BarSubItemGoodsSep1'
      Visible = ivAlways
      ShowCaption = False
    end
    object BarSubItemGoodsSep2: TdxBarSeparator
      Caption = 'BarSubItemGoodsSep2'
      Category = 0
      Hint = 'BarSubItemGoodsSep2'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbSetErased_boat: TdxBarButton
      Action = actSetErased_boat
      Category = 0
    end
    object bbSetUnErased_boat: TdxBarButton
      Action = actSetUnErased_boat
      Category = 0
    end
    object bbMIMasterBoatProtocolOpenForm: TdxBarButton
      Action = actMIMasterBoatProtocolOpenForm
      Category = 0
    end
    object BarSubItemBoatSep1: TdxBarSeparator
      Caption = 'BarSubItemBoatSep1'
      Category = 0
      Hint = 'BarSubItemBoatSep1'
      Visible = ivAlways
      ShowCaption = False
    end
    object BarSubItemBoatSep2: TdxBarSeparator
      Caption = 'BarSubItemBoatSep2'
      Category = 0
      Hint = 'BarSubItemBoatSep2'
      Visible = ivAlways
      ShowCaption = False
    end
    object BarSubItemDetailSep1: TdxBarSeparator
      Caption = 'BarSubItemDetailSep1'
      Category = 0
      Hint = 'BarSubItemDetailSep1'
      Visible = ivAlways
      ShowCaption = False
    end
    object BarSubItemDetailSep2: TdxBarSeparator
      Caption = 'BarSubItemDetailSep2'
      Category = 0
      Hint = 'BarSubItemDetailSep2'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbInsertRecordChild: TdxBarButton
      Action = actInsertRecordChild
      Category = 0
    end
    object bbOpenGoodsChoiceForm: TdxBarButton
      Action = acChoiceFormGoods_child
      Category = 0
    end
    object BarSubItemChildSep1: TdxBarSeparator
      Caption = 'BarSubItemChildSep1'
      Category = 0
      Hint = 'BarSubItemChildSep1'
      Visible = ivAlways
      ShowCaption = False
    end
    object BarSubItemChildSep2: TdxBarSeparator
      Caption = 'BarSubItemChildSep2'
      Category = 0
      Hint = 'BarSubItemChildSep2'
      Visible = ivAlways
      ShowCaption = False
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 113
    Top = 224
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 59
    Top = 215
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actMIDetailAllProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'ReceiptServiceName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMI_Child
        end
        item
          StoredProc = spSelectMI_Detail
        end
        item
          StoredProc = spSelectMI_DetailAll
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actSetErasedDetail: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIDetail
      StoredProcList = <
        item
          StoredProc = spErasedMIDetail
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
    end
    object actUpdateDetailDS: TdsdUpdateDataSet
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIDetail
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIDetail
        end
        item
          StoredProc = spSelectMI_Detail
        end>
      Caption = 'actUpdateDetailDS'
      DataSource = DetailDS
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMI_Detail
        end
        item
          StoredProc = spSelectMI_DetailAll
        end
        item
          StoredProc = spSelectMI_Child
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1091#1079#1083#1099' '#1080#1079' '#1079#1072#1082#1072#1079#1072
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1091#1079#1083#1099' '#1080#1079' '#1079#1072#1082#1072#1079#1072
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1091#1079#1083#1099' '#1080#1079' '#1079#1072#1082#1072#1079#1072
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1091#1079#1083#1099' '#1080#1079' '#1079#1072#1082#1072#1079#1072
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actSetUnErasedDetail: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIDetail
      StoredProcList = <
        item
          StoredProc = spUnErasedMIDetail
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    object actSetErasedDetail_All: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedMIDetailAll
      StoredProcList = <
        item
          StoredProc = spErasedMIDetailAll
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS_All
    end
    object actUpdateDetailDS_All: TdsdUpdateDataSet
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIDetailAll
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIDetailAll
        end
        item
          StoredProc = spSelectMI_DetailAll
        end
        item
          StoredProc = spSelectMI_Detail
        end>
      Caption = 'actUpdateDetailDS_All'
      DataSource = DetailDS_All
    end
    object SetUnErasedDetail_All: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      StoredProc = spUnErasedMIDetail_All
      StoredProcList = <
        item
          StoredProc = spUnErasedMIDetail_All
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS_All
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMI_Child
        end
        item
          StoredProc = spSelectMI_Detail
        end
        item
          StoredProc = spSelectMI_DetailAll
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'InvNumber_OrderClient;NPP_1;NPP_2;NPP_3'
        end>
      Params = <>
      ReportName = 'PrintMovement_OrderInternal'
      ReportNameParam.Value = 'PrintMovement_OrderInternal'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object SetErasedChild: TdsdUpdateErased
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
    end
    object actMIChildProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMIDetailProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083'>'
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
          ComponentItem = 'ReceiptServiceName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1059#1079#1077#1083'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object actSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actMIMasterProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
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
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertRecordDetail: TInsertRecord
      Category = 'Detail'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView_Det
      Action = actChoiceFormReceiptService
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      ImageIndex = 0
    end
    object actInsertRecordDetailAll: TInsertRecord
      Category = 'Detail'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView_DetAll
      Action = acChoiceFormOrderInternalMaster_DetAll
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1059#1079#1077#1083'/'#1051#1086#1076#1082#1072
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1059#1079#1077#1083'/'#1051#1086#1076#1082#1072
      ImageIndex = 0
    end
    object actChoiceFormReceiptService: TOpenChoiceForm
      Category = 'Detail'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      ImageIndex = 1
      FormName = 'TReceiptServiceForm'
      FormNameParam.Value = 'TReceiptServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ReceiptServiceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ReceiptServiceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ReceiptServiceCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertRecordGoods: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGrid_MasterDBTableView
      Action = actChoiceFormOrderClientItem
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1079#1077#1083'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1079#1077#1083'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object actInsertRecordBoat: TInsertRecord
      Category = 'Boat'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGrid_MasterDBTableView
      Action = actChoiceFormOrderClient
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1051#1086#1076#1082#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1051#1086#1076#1082#1072'>'
      ImageIndex = 0
    end
    object actChoiceFormOrderClientItem: TOpenChoiceForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1059#1079#1077#1083'>'
      ImageIndex = 1
      FormName = 'TOrderClientJournalChoiceItemForm'
      FormNameParam.Value = 'TOrderClientJournalChoiceItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ProductId'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberFull_OrderClient'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isEnabled'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isEnabled'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsChildOnly'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072'>'
      ImageIndex = 28
      FormName = 'TOrderClientForm'
      FormNameParam.Value = 'TOrderClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
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
    object macErasedMI_Master_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetErased
        end>
      View = cxGrid_MasterDBTableView
      Caption = 'macErasedMI_Master_list'
    end
    object macErasedMI_Master: TMultiAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      ActionList = <
        item
          Action = macErasedMI_Master_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'?'
      InfoAfterExecute = #1057#1090#1088#1086#1082#1080' '#1091#1076#1072#1083#1077#1085#1099
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object actChoiceFormReceiptService_DetAll: TOpenChoiceForm
      Category = 'Detail'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      ImageIndex = 1
      FormName = 'TReceiptServiceForm'
      FormNameParam.Value = 'TReceiptServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'ReceiptServiceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'ReceiptServiceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'ReceiptServiceCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object acChoiceFormOrderInternalMaster_DetAll: TOpenChoiceForm
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'acChoiceFormOrderInternalMaster_DetAll'
      FormName = 'TOrderInternalMasterChoiceForm'
      FormNameParam.Value = 'TOrderInternalMasterChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_OrderClient'
          Value = Null
          Component = GuidesOrderClient
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_OrderClient'
          Value = Null
          Component = GuidesOrderClient
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParentId'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'ParentId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'GoodsName_master'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'Amount_master'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull_OrderClient'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'InvNumberFull_OrderClient'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CIN'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'CIN_OrderClient'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'ProductName_OrderClient'
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'FromName_OrderClient'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'Article_master'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'DescName_master'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPersonalChoiceForm: TOpenChoiceForm
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PersonalForm'
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'PersonalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'PersonalCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPersonalChoiceForm_DetAll: TOpenChoiceForm
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PersonalFormAll'
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'PersonalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'PersonalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = DetailCDS_All
          ComponentItem = 'PersonalCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object SetUnErasedChild: TdsdUpdateErased
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object actChoiceFormOrderClient: TOpenChoiceForm
      Category = 'Boat'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1051#1086#1076#1082#1072'>'
      ImageIndex = 1
      FormName = 'TOrderClientJournalChoiceForm'
      FormNameParam.Value = 'TOrderClientJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberFull_OrderClient'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsEnabled'
          Value = True
          Component = MasterCDS
          ComponentItem = 'IsEnabled'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSetErased_boat: TdsdUpdateErased
      Category = 'Boat'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object actSetUnErased_boat: TdsdUpdateErased
      Category = 'Boat'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actMIMasterBoatProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
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
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertRecordChild: TInsertRecord
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView_child
      Action = acChoiceFormGoods_child
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 0
    end
    object acChoiceFormGoods_child: TOpenChoiceForm
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 1
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'Child'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end
        item
          StoredProc = spSelectMI_Detail
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object actUnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object actDeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 646
    Top = 183
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 584
    Top = 183
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
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
      end
      item
        Name = 'PaidKindId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 1048
    Top = 48
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 576
    Top = 208
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderInternal'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_OrderClient'
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
        Value = 'khkh'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
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
        Name = 'inIsEnabled'
        Value = True
        Component = MasterCDS
        ComponentItem = 'IsEnabled'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 222
    Top = 255
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 878
    Top = 47
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderInternal'
    DataSets = <>
    OutputType = otResult
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
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
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
    PackSize = 1
    Left = 226
    Top = 48
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edInvNumber
      end
      item
      end
      item
        Control = edOperDate
      end
      item
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
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
        Control = ceComment
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
    GetStoredProc = spGet
    Left = 200
    Top = 201
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderInternal'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'Key'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
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
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_OrderClient'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_all'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 184
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 454
    Top = 34
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 864
    Top = 32
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 486
    Top = 192
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 430
    Top = 240
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 39
    Top = 40
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderInternal'
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
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 100
    Top = 32
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKind_Value'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 752
    Top = 24
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 924
    Top = 137
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1028
    Top = 86
  end
  object spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderInternal'
    DataSets = <>
    OutputType = otResult
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
        Name = 'ioOperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
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
        Name = 'inIsEnabled'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isEnabled'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 302
    Top = 231
  end
  object PrintItemsColorCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1004
    Top = 158
  end
  object spSelectPrintOffer: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_OfferPrint'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 696
    Top = 264
  end
  object spSelectPrintStructure: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_StructurePrint'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1048
    Top = 200
  end
  object spSelectPrintOrderConfirmation: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Product_OrderConfirmationPrint'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsColorCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1048
    Top = 256
  end
  object spSelectMI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderInternal_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
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
    Left = 200
    Top = 559
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 396
    Top = 407
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 454
    Top = 399
  end
  object actDBViewAddOnChild: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView_child
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 296
    Top = 392
  end
  object spInsert_MI_byOrderClient: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_OrderInternal_byOrderClient'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptGoodsId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 586
    Top = 264
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGrid_MasterDBTableView
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 728
    Top = 192
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 440
  end
  object GuidesProduct: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProduct
    DisableGuidesOpen = True
    FormNameParam.Value = 'TProductForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProductForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CIN'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 624
    Top = 48
  end
  object GuidesOrderClient: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderClient
    Key = '0'
    FormNameParam.Value = 'TOrderClientJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderClientJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderClient
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_all'
        Value = ''
        Component = GuidesOrderClient
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName_Full'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 56
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternal_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
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
    Left = 848
    Top = 192
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 632
    Top = 559
  end
  object DetailDS: TDataSource
    DataSet = DetailCDS
    Left = 694
    Top = 559
  end
  object DetailViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView_Det
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
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 6
      end>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 747
    Top = 553
  end
  object spSelectMI_Detail: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderInternal_Detail'
    DataSet = DetailCDS
    DataSets = <
      item
        DataSet = DetailCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = Null
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
    PackSize = 1
    Left = 216
    Top = 399
  end
  object spInsertUpdateMIDetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_OrderInternal_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'PersonalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptServiceName'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'ReceiptServiceName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHours'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Hours'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumm'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 62
    Top = 415
  end
  object spErasedMIDetail: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetErased_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 318
    Top = 511
  end
  object spUnErasedMIDetail: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetUnErased_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 150
    Top = 415
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetErased_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 606
    Top = 383
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetUnErased_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 550
    Top = 391
  end
  object DetailCDS_All: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 896
    Top = 447
  end
  object DetailDS_All: TDataSource
    DataSet = DetailCDS_All
    Left = 950
    Top = 447
  end
  object DetailViewAddOn_All: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView_DetAll
    OnDblClickActionList = <
      item
      end>
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
        DataSummaryItemIndex = 6
      end>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 1003
    Top = 449
  end
  object spSelectMI_DetailAll: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderInternal_Detail'
    DataSet = DetailCDS_All
    DataSets = <
      item
        DataSet = DetailCDS_All
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
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
    PackSize = 1
    Left = 896
    Top = 503
  end
  object spInsertUpdateMIDetailAll: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_OrderInternal_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'PersonalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptServiceName'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'ReceiptServiceName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHours'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'Hours'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumm'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'Summ'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 990
    Top = 383
  end
  object spErasedMIDetailAll: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetErased_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 910
    Top = 359
  end
  object spUnErasedMIDetail_All: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetUnErased_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailCDS_All
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 846
    Top = 391
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_OrderInternal_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ReceiptLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inColorPatternId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ProdColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptionsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ProdOptionsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountReserv'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountReserv'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSend'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountSend'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inForCount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ForCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 54
    Top = 543
  end
end
