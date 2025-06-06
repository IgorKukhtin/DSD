object ProductionUnionForm: TProductionUnionForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1073#1086#1088#1082#1072'>'
  ClientHeight = 601
  ClientWidth = 1084
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
    Width = 1084
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 9
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 70
    end
    object cxLabel1: TcxLabel
      Left = 9
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'
    end
    object edOperDate: TcxDateEdit
      Left = 85
      Top = 23
      EditValue = 42160d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 94
    end
    object cxLabel2: TcxLabel
      Left = 85
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 186
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 223
    end
    object edTo: TcxButtonEdit
      Left = 417
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 225
    end
    object cxLabel3: TcxLabel
      Left = 186
      Top = 5
      Hint = #1054#1090' '#1082#1086#1075#1086
      Caption = #1054#1090' '#1082#1086#1075#1086
      ParentShowHint = False
      ShowHint = True
    end
    object cxLabel4: TcxLabel
      Left = 415
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object cxLabel11: TcxLabel
      Left = 9
      Top = 45
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 10
      Top = 62
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
      Width = 170
    end
    object cxLabel16: TcxLabel
      Left = 875
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 875
      Top = 62
      TabOrder = 11
      Width = 216
    end
    object cxLabel12: TcxLabel
      Left = 875
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 875
      Top = 23
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 111
    end
    object cxLabel13: TcxLabel
      Left = 994
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 994
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
    object cxLabel5: TcxLabel
      Left = 186
      Top = 46
      Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
    end
    object ceParent: TcxButtonEdit
      Left = 186
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 223
    end
    object cxLabel6: TcxLabel
      Left = 650
      Top = 5
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1091#1089#1083#1091#1075
    end
    object edPartner: TcxButtonEdit
      Left = 650
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 216
    end
    object cxLabel7: TcxLabel
      Left = 415
      Top = 46
      Caption = '***'#8470' '#1057#1095#1077#1090#1072
    end
    object edInvNumberInvoice: TcxTextEdit
      Left = 415
      Top = 63
      TabOrder = 21
      Width = 153
    end
    object cxLabel8: TcxLabel
      Left = 574
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 574
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 68
    end
    object cbChangeReceipt: TcxCheckBox
      Left = 650
      Top = 62
      Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1095'. '#1074' '#1096#1072#1073#1083#1086#1085#1077' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 24
      Width = 209
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 132
    Width = 1084
    Height = 400
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 400
    ClientRectRight = 1084
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object Panel_all: TPanel
        Left = 0
        Top = 0
        Width = 1084
        Height = 376
        Align = alClient
        Caption = 'Panel_all'
        TabOrder = 0
        object cxSplitter_Bottom_Child: TcxSplitter
          Left = 1
          Top = 252
          Width = 1082
          Height = 8
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salBottom
          Control = cxGrid_Child
        end
        object cxGrid_Child: TcxGrid
          Left = 1
          Top = 260
          Width = 1082
          Height = 115
          Align = alBottom
          TabOrder = 1
          LookAndFeel.Kind = lfStandard
          LookAndFeel.NativeStyle = False
          LookAndFeel.SkinName = ''
          object cxGridDBTableViewChild: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ChildDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Filter.Active = True
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount_ch1
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Value_ch1
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Value_service_ch1
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount_diff_ch1
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Summ_ch1
              end>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount_ch1
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Value_ch1
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Value_service_ch1
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Amount_diff_ch1
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Summ_ch1
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.IncSearch = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderHeight = 40
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object NPP_ch1: TcxGridDBColumn
              Caption = #8470' '#1087'/'#1087
              DataBinding.FieldName = 'NPP'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.##;-,0.##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 40
            end
            object ReceiptLevelName_ch1: TcxGridDBColumn
              Caption = 'Level'
              DataBinding.FieldName = 'ReceiptLevelName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 75
            end
            object GoodsGroupNameFull_ch1: TcxGridDBColumn
              Caption = #1043#1088#1091#1087#1087#1072
              DataBinding.FieldName = 'GoodsGroupNameFull'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
              Options.Editing = False
              Width = 150
            end
            object GoodsGroupName_ch1: TcxGridDBColumn
              Caption = '***'#1043#1088#1091#1087#1087#1072
              DataBinding.FieldName = 'GoodsGroupName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 172
            end
            object ObjectCode_ch1: TcxGridDBColumn
              Caption = 'Interne Nr'
              DataBinding.FieldName = 'ObjectCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
              Options.Editing = False
              Width = 60
            end
            object Article_ch1: TcxGridDBColumn
              Caption = 'Artikel Nr'
              DataBinding.FieldName = 'Article'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 70
            end
            object ObjectName_ch1: TcxGridDBColumn
              Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'/'#1059#1079#1083#1099
              DataBinding.FieldName = 'ObjectName'
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
              Width = 200
            end
            object DescName_ch1: TcxGridDBColumn
              Caption = #1069#1083#1077#1084#1077#1085#1090
              DataBinding.FieldName = 'DescName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Comment_goods_ch1: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1050#1086#1084#1087#1083'.)'
              DataBinding.FieldName = 'Comment_goods'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
              Options.Editing = False
              Width = 120
            end
            object ProdColorName_ch1: TcxGridDBColumn
              Caption = 'Farbe'
              DataBinding.FieldName = 'ProdColorName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object MeasureName_ch1: TcxGridDBColumn
              Caption = #1045#1076'. '#1080#1079#1084'.'
              DataBinding.FieldName = 'MeasureName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object Amount_ch1: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')'
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 8
              Properties.DisplayFormat = ',0.########;-,0.########; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 80
            end
            object ForCount_ch1: TcxGridDBColumn
              DataBinding.FieldName = 'ForCount'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Price_ch1: TcxGridDBColumn
              Caption = #1062#1077#1085#1072' '#1089'/'#1089
              DataBinding.FieldName = 'Price'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 2
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Summ_ch1: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089
              DataBinding.FieldName = 'Summ'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 2
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Value_ch1: TcxGridDBColumn
              DataBinding.FieldName = 'Value'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
              Options.Editing = False
              Width = 45
            end
            object Value_service_ch1: TcxGridDBColumn
              Caption = 'Value (service)'
              DataBinding.FieldName = 'Value_service'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
              Options.Editing = False
              Width = 63
            end
            object Amount_diff_ch1: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' ('#1086#1090#1082'.)'
              DataBinding.FieldName = 'Amount_diff'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1050#1086#1083'-'#1074#1086' ('#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077')'
              Options.Editing = False
              Width = 133
            end
            object ProdOptionsName_ch1: TcxGridDBColumn
              Caption = #1054#1087#1094#1080#1103
              DataBinding.FieldName = 'ProdOptionsName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderGlyphAlignmentHorz = taCenter
              Options.Editing = False
              Width = 80
            end
            object ProdColorPatternName_ch1: TcxGridDBColumn
              Caption = #1069#1083#1077#1084#1077#1085#1090' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088#1072
              DataBinding.FieldName = 'ProdColorPatternName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderGlyphAlignmentHorz = taCenter
              Options.Editing = False
              Width = 80
            end
            object ColorPatternName_ch1: TcxGridDBColumn
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
            object Comment_ch1: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderGlyphAlignmentHorz = taCenter
              Options.Editing = False
              Width = 100
            end
            object IsErased_ch1: TcxGridDBColumn
              Caption = #1059#1076#1072#1083#1077#1085
              DataBinding.FieldName = 'isErased'
              Visible = False
              Width = 60
            end
            object Color_value_ch1: TcxGridDBColumn
              DataBinding.FieldName = 'Color_value'
              Visible = False
              Options.Editing = False
              VisibleForCustomization = False
              Width = 60
            end
            object Color_Level_ch1: TcxGridDBColumn
              DataBinding.FieldName = 'Color_Level'
              Visible = False
              Options.Editing = False
              VisibleForCustomization = False
              Width = 30
            end
          end
          object cxGridLevel2: TcxGridLevel
            GridView = cxGridDBTableViewChild
          end
        end
        object cxGrid_Detail: TcxGrid
          Left = 1
          Top = 137
          Width = 1082
          Height = 115
          Align = alBottom
          TabOrder = 2
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
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Hours_plan_ch4
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
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Hours_plan_ch4
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
              Width = 80
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
            object PartnerName_ch4: TcxGridDBColumn
              Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1091#1089#1083#1091#1075
              DataBinding.FieldName = 'PartnerName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 103
            end
            object PersonalCode_ch4: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'PersonalCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
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
            object Hours_plan_ch4: TcxGridDBColumn
              Caption = #1055#1083#1072#1085' '#1095#1072#1089#1086#1074
              DataBinding.FieldName = 'Hours_plan'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Hours_ch4: TcxGridDBColumn
              Caption = #1060#1072#1082#1090' '#1095#1072#1089#1086#1074
              DataBinding.FieldName = 'Hours'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 70
            end
            object OperPrice_ch4: TcxGridDBColumn
              Caption = #1062#1077#1085#1072' '#1079#1072' '#1095'.'
              DataBinding.FieldName = 'OperPrice'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 80
            end
            object Summ_ch4: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1060#1072#1082#1090
              DataBinding.FieldName = 'Summ'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 88
            end
            object Amount_ch4: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' ('#1088#1072#1089#1095#1077#1090')'
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object Comment_ch4: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
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
        object cxSplitter_Bottom_Detail: TcxSplitter
          Left = 1
          Top = 129
          Width = 1082
          Height = 8
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salBottom
          Control = cxGrid_Detail
        end
        object cxGrid: TcxGrid
          Left = 1
          Top = 1
          Width = 1082
          Height = 128
          Align = alClient
          TabOrder = 0
          object cxGridDBTableViewMaster: TcxGridDBTableView
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
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Summ
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
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = Summ
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
            object Ord: TcxGridDBColumn
              Caption = #8470' '#1087'/'#1087
              DataBinding.FieldName = 'Ord'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object DescName: TcxGridDBColumn
              Caption = #1069#1083#1077#1084#1077#1085#1090
              DataBinding.FieldName = 'DescName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object ObjectCode: TcxGridDBColumn
              Caption = 'Interne Nr'
              DataBinding.FieldName = 'ObjectCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 90
            end
            object Article: TcxGridDBColumn
              Caption = 'Artikel Nr'
              DataBinding.FieldName = 'Article'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Action = actUpdateChoiceFormReceiptGoods
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object GoodsName: TcxGridDBColumn
              Caption = #1059#1079#1077#1083'/'#1051#1086#1076#1082#1072
              DataBinding.FieldName = 'ObjectName'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Action = actUpdateChoiceFormReceiptGoods
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 155
            end
            object CIN: TcxGridDBColumn
              Caption = 'CIN Nr.'
              DataBinding.FieldName = 'CIN'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object ProdColorName: TcxGridDBColumn
              Caption = 'Farbe'
              DataBinding.FieldName = 'ProdColorName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object Comment_goods: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1059#1079#1077#1083')'
              DataBinding.FieldName = 'Comment_goods'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 150
            end
            object EngineNum: TcxGridDBColumn
              Caption = 'Engine Nr.'
              DataBinding.FieldName = 'EngineNum'
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
              Width = 80
            end
            object EngineName: TcxGridDBColumn
              Caption = 'Engine'
              DataBinding.FieldName = 'EngineName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
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
              Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')'
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 70
            end
            object Price: TcxGridDBColumn
              Caption = #1062#1077#1085#1072' '#1089'/'#1089
              DataBinding.FieldName = 'Price'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object Summ: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089
              DataBinding.FieldName = 'Summ'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object ReceiptProdModelName: TcxGridDBColumn
              Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080'/'#1059#1079#1077#1083
              DataBinding.FieldName = 'ReceiptProdModelName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 148
            end
            object InvNumberFull_OrderClient: TcxGridDBColumn
              Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
              DataBinding.FieldName = 'InvNumberFull_OrderClient'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Action = actOrderClientChoiceForm
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Width = 150
            end
            object ProductName_OrderClient: TcxGridDBColumn
              Caption = 'Boat'
              DataBinding.FieldName = 'ProductName_OrderClient'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Action = actOrderClientChoiceForm
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderGlyphAlignmentHorz = taCenter
              HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Width = 100
            end
            object FromName_OrderClient: TcxGridDBColumn
              Caption = 'Kunden'
              DataBinding.FieldName = 'FromName_OrderClient'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 120
            end
            object CIN_OrderClient: TcxGridDBColumn
              Caption = 'CIN Nr.'
              DataBinding.FieldName = 'CIN_OrderClient'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 100
            end
            object Comment: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 125
            end
            object InsertName: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076#1072#1083
              DataBinding.FieldName = 'InsertName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object InsertDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
              DataBinding.FieldName = 'InsertDate'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
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
          object cxGridLevel: TcxGridLevel
            GridView = cxGridDBTableViewMaster
          end
        end
      end
    end
    object cxTabSheetDetail: TcxTabSheet
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086
      ImageIndex = 1
      object cxGrid2: TcxGrid
        Left = 0
        Top = 0
        Width = 1084
        Height = 376
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
              Column = Hours_plan_ch5
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
              Column = Hours_plan_ch5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ch54
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ReceiptServiceName_ch5
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
            Width = 70
          end
          object ReceiptServiceName_ch5: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1072#1073#1086#1090
            DataBinding.FieldName = 'ReceiptServiceName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReceiptServiceChoiceForm_DetAll
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
            Visible = False
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
            Caption = #1060#1072#1082#1090' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'Hours'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object Hours_plan_ch5: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'Hours_plan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Summ_ch54: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1060#1072#1082#1090
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
                Action = actUpdateChoiceFormOrderClientItem
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
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')'
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
    object cxTabSheetScan: TcxTabSheet
      Caption = #1057#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1085#1072' '#1084#1086#1073'. '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072#1093
      ImageIndex = 2
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 1084
        Height = 376
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView_Scan: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ScanDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Scan_Amount
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
              Column = Scan_Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = Scan_GoodsName
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
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object Scan_Ord: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Scan_GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object Scan_EAN: TcxGridDBColumn
            DataBinding.FieldName = 'EAN'
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
            HeaderHint = 'EAN'
            Width = 106
          end
          object Scan_Article: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object Scan_Article_all: TcxGridDBColumn
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
            Options.Editing = False
            Width = 70
          end
          object Scan_GoodsCode: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Scan_GoodsName: TcxGridDBColumn
            Caption = #1059#1079#1077#1083'/'#1051#1086#1076#1082#1072
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
            Width = 268
          end
          object Scan_MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object Scan_Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1092#1072#1082#1090' '#1074' '#1084#1072#1075#1072#1079#1080#1085#1077' ('#1073#1077#1079' '#1076#1086#1083#1075#1086#1074')'
            Width = 70
          end
          object Scan_OperDate_protocol: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1055#1088#1086#1090#1086#1082#1086#1083')'
            DataBinding.FieldName = 'OperDate_protocol'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1086#1087#1077#1088#1072#1094#1080#1080' ('#1055#1088#1086#1090#1086#1082#1086#1083')'
            Options.Editing = False
            Width = 100
          end
          object Scan_UserName_protocol: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1055#1088#1086#1090#1086#1082#1086#1083')'
            DataBinding.FieldName = 'UserName_protocol'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1086#1087#1077#1088#1072#1094#1080#1080' ('#1055#1088#1086#1090#1086#1082#1086#1083')'
            Options.Editing = False
            Width = 100
          end
          object Scan_isErased: TcxGridDBColumn
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
          GridView = cxGridDBTableView_Scan
        end
      end
    end
  end
  object Panel_btn: TPanel
    Left = 0
    Top = 532
    Width = 1084
    Height = 69
    Align = alBottom
    TabOrder = 6
    object btnInsertUpdateMovement: TcxButton
      Left = 24
      Top = 5
      Width = 155
      Height = 25
      Action = actInsertUpdateMovement
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btntAdd_limit: TcxButton
      Left = 374
      Top = 5
      Width = 120
      Height = 25
      Action = actUpdateChoiceFormOrderClientItem
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object btnCompleteMovement: TcxButton
      Left = 510
      Top = 5
      Width = 150
      Height = 25
      Action = actCompleteMovement
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object btnUnCompleteMovement: TcxButton
      Left = 510
      Top = 36
      Width = 150
      Height = 25
      Action = actUnCompleteMovement
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object btnSetErased: TcxButton
      Left = 374
      Top = 36
      Width = 120
      Height = 25
      Action = actSetErased
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object btnShowAll: TcxButton
      Left = 836
      Top = 5
      Width = 150
      Height = 25
      Action = actShowAll_child
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object btnInsertAction: TcxButton
      Left = 215
      Top = 5
      Width = 147
      Height = 25
      Action = actInsertRecordOrderClientItem
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object btnUpdateAction: TcxButton
      Left = 215
      Top = 36
      Width = 147
      Height = 25
      Action = mactInsertRecordReceiptGoods
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object btnCompleteMovement_andSave: TcxButton
      Left = 24
      Top = 36
      Width = 155
      Height = 25
      Action = mactCompleteMovement_andSave
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
    end
    object btnFormClose: TcxButton
      Left = 836
      Top = 36
      Width = 150
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object cxButton4: TcxButton
      Left = 683
      Top = 5
      Width = 132
      Height = 25
      Action = actSetVisible_Grid_Child
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
    end
    object cxButton5: TcxButton
      Left = 683
      Top = 36
      Width = 132
      Height = 25
      Action = actSetVisible_Grid_Detail
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll_child
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isScan'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 246
    Top = 295
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionUnion_Master'
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 183
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
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
    Left = 22
    Top = 231
    DockControlHeights = (
      0
      0
      35
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
          ItemName = 'bbsView'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsDoc'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsUzel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsBoat'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsGoods'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsWork'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
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
    object bbShowAll_child: TdxBarButton
      Action = actShowAll_child
      Category = 0
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbGridToExel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = actSetUnErased
      Category = 0
    end
    object bbMIContainer: TdxBarButton
      Action = actMIContainer
      Category = 0
    end
    object bbMovementItemProtocol: TdxBarButton
      Action = actMovementItemProtocolOpenForm
      Category = 0
    end
    object bbPrintCalc: TdxBarButton
      Action = actPrintCalc
      Category = 0
    end
    object bbPrintStickerTermo: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1072' '#1090#1077#1088#1084#1086#1087#1088#1080#1085#1090#1077#1088' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1085#1072' '#1090#1077#1088#1084#1086#1087#1088#1080#1085#1090#1077#1088' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Visible = ivAlways
      ImageIndex = 20
    end
    object bbSetErasedChild: TdxBarButton
      Action = actSetErasedChild
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
    end
    object bbSetUnErasedChild: TdxBarButton
      Action = actSetUnErasedChild
      Category = 0
    end
    object bbInsertRecordChild: TdxBarButton
      Action = actInsertRecordChild
      Category = 0
    end
    object bbChildProtocol: TdxBarButton
      Action = actMovementItemChildProtocolOpenForm
      Category = 0
    end
    object bbUpdate_MI_Child: TdxBarButton
      Action = actUpdate_MI_Child
      Category = 0
    end
    object bbInsertRecordDetail: TdxBarButton
      Action = actInsertRecordDetail
      Category = 0
    end
    object bbSetErasedDetail: TdxBarButton
      Action = actSetErasedDetail
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
    end
    object bbSetUnErasedDetail: TdxBarButton
      Action = actSetUnErasedDetail
      Category = 0
    end
    object bbInsertRecordOrderClientItem: TdxBarButton
      Action = actInsertRecordOrderClientItem
      Category = 0
    end
    object bbUpdateChoiceFormOrderClientItem: TdxBarButton
      Action = actUpdateChoiceFormOrderClientItem
      Category = 0
    end
    object bbInsertRecordBoat: TdxBarButton
      Action = actInsertRecord_Boat
      Category = 0
    end
    object bbOrderClientInsertBoatForm: TdxBarButton
      Action = actUpdateChoiceFormBoat
      Category = 0
    end
    object bbInsertRecordDetailAll: TdxBarButton
      Action = actInsertRecordDetail_All
      Category = 0
    end
    object bbSetErasedDetail_All: TdxBarButton
      Action = actSetErasedDetail_All
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
    end
    object bbSetUnErasedDetail_All: TdxBarButton
      Action = SetUnErasedDetail_All
      Category = 0
    end
    object bbMIDetailAllProtocolOpenForm: TdxBarButton
      Action = actMIDetailAllProtocolOpenForm
      Category = 0
    end
    object bbMIDetailProtocolOpenForm: TdxBarButton
      Action = actMIDetailProtocolOpenForm
      Category = 0
    end
    object bbsUzel: TdxBarSubItem
      Caption = #1059#1079#1077#1083
      Category = 0
      Visible = ivAlways
      ImageIndex = 7
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordOrderClientItem'
        end
        item
          Visible = True
          ItemName = 'bbUpdateChoiceFormOrderClientItem'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordReceiptGoods'
        end
        item
          Visible = True
          ItemName = 'bbUpdateChoiceFormReceiptGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_bySend'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end>
    end
    object dxBarSeparator: TdxBarSeparator
      Caption = 'dxBarSeparator'
      Category = 0
      Hint = 'dxBarSeparator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbsBoat: TdxBarSubItem
      Caption = #1051#1086#1076#1082#1072
      Category = 0
      Visible = ivAlways
      ImageIndex = 7
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordBoat'
        end
        item
          Visible = True
          ItemName = 'bbOrderClientInsertBoatForm'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end>
    end
    object bbsGoods: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      Category = 0
      Visible = ivAlways
      ImageIndex = 39
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordChild'
        end
        item
          Visible = True
          ItemName = 'bbactGoods_ReceiptServiceChoiceForm_Child'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
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
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbChildProtocol'
        end>
    end
    object bbsWork: TdxBarSubItem
      Caption = #1056#1072#1073#1086#1090#1099
      Category = 0
      Visible = ivAlways
      ImageIndex = 84
      ItemLinks = <
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
          ItemName = 'bbChoiceFormReceiptService'
        end
        item
          Visible = True
          ItemName = 'bbReceiptServiceChoiceForm_DetAll'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
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
          ItemName = 'dxBarSeparator'
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
    object bbactGoods_ReceiptServiceChoiceForm_Child: TdxBarButton
      Action = actGoodsChoiceForm
      Category = 0
    end
    object bbChoiceFormReceiptService: TdxBarButton
      Action = actChoiceFormReceiptService
      Category = 0
    end
    object bbReceiptServiceChoiceForm_DetAll: TdxBarButton
      Action = actReceiptServiceChoiceForm_DetAll
      Category = 0
    end
    object bbErasedMI_Master: TdxBarButton
      Action = mactErasedMI_Master
      Category = 0
    end
    object bbOpenOrderClientForm: TdxBarButton
      Action = actOpenOrderClientForm
      Category = 0
    end
    object bbInsertUpdate_bySend: TdxBarButton
      Action = mactInsertUpdate_bySend
      Category = 0
    end
    object bbReport_Goods_master: TdxBarButton
      Action = actReport_Goods_master
      Category = 0
    end
    object bbReport_Goods_child: TdxBarButton
      Action = actReport_Goods_child
      Category = 0
    end
    object bbInsertRecordReceiptGoods: TdxBarButton
      Action = mactInsertRecordReceiptGoods
      Category = 0
    end
    object bbUpdateChoiceFormReceiptGoods: TdxBarButton
      Action = actUpdateChoiceFormReceiptGoods
      Category = 0
    end
    object bbsView: TdxBarSubItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088
      Category = 0
      Visible = ivAlways
      ImageIndex = 83
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbShowAll_child'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end>
    end
    object bbsDoc: TdxBarSubItem
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 8
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_MI_Child'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_MI_Child_byOrder'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_MI_Child_byReceipt'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbErasedMI_Master'
        end>
    end
    object bbsOpenForm: TdxBarSubItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 24
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbOpenOrderClientForm'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods_master'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods_child'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbMIContainer'
        end>
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrintCalc'
        end>
    end
    object bbUpdate_MI_Child_byOrder: TdxBarButton
      Action = mactUpdate_MI_Child_byOrder
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1088#1072#1089#1093#1086#1076#1072' '#1087#1086' '#1079#1072#1082#1072#1079#1091' '#1085#1072' '#1087#1088#1086#1080#1079#1074'.'
      Category = 0
    end
    object bbUpdate_MI_Child_byReceipt: TdxBarButton
      Action = mactUpdate_MI_Child_byReceipt
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = actSetVisible_Grid_Child
        Properties.Strings = (
          'Value')
      end
      item
        Component = actSetVisible_Grid_Detail
        Properties.Strings = (
          'Value')
      end
      item
        Component = cxGrid_Child
        Properties.Strings = (
          'Height'
          'Top')
      end
      item
        Component = cxGrid_Detail
        Properties.Strings = (
          'Height'
          'Top')
      end
      item
        Component = cxSplitter_Bottom_Child
        Properties.Strings = (
          'Top')
      end
      item
        Component = cxSplitter_Bottom_Detail
        Properties.Strings = (
          'Top')
      end
      item
        Component = Panel_btn
        Properties.Strings = (
          'Top')
      end
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
    Top = 272
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 231
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
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actInsertRecordChild: TInsertRecord
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableViewChild
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 0
    end
    object actRefresh_Child: TdsdDataSetRefresh
      Category = 'Child'
      MoveParams = <>
      StoredProc = spSelectMIChild
      StoredProcList = <
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGoodsChoiceForm: TOpenChoiceForm
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
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
          StoredProc = spSelectMIChild
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
    object actRefreshMI_Master: TdsdDataSetRefresh
      Category = 'GoodsNode'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actSetVisibleScan
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
        end
        item
          StoredProc = spSelectMI_Detail
        end
        item
          StoredProc = spSelectMI_DetailAll
        end
        item
          StoredProc = spSelectScan
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 90
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrintCalc: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1094#1080#1103
      ImageIndex = 17
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'InvNumber_OrderClient;NPP_1;NPP_2;NPP_3'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42160d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ProductionUnionCalc'
      ReportNameParam.Value = 'PrintMovement_ProductionUnionCalc'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ProductionUnion'
      ReportNameParam.Value = 'PrintMovement_ProductionUnion'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid_Child
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actInsertRecord_Boat: TInsertRecord
      Category = 'Boat'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableViewMaster
      Action = actUpdateChoiceFormBoat
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1051#1086#1076#1082#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1051#1086#1076#1082#1072'>'
      ImageIndex = 0
    end
    object actSetErased_Boat: TdsdUpdateErased
      Category = 'Boat'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object actInsertRecordOrderClientItem: TInsertRecord
      Category = 'GoodsNode'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableViewMaster
      Action = actUpdateChoiceFormOrderClientItem
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1079#1077#1083'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1079#1077#1083'>'
      ImageIndex = 0
    end
    object actUpdateChoiceFormOrderClientItem: TOpenChoiceForm
      Category = 'GoodsNode'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1059#1079#1077#1083'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1059#1079#1077#1083'>'
      ImageIndex = 1
      FormName = 'TOrderClientJournalChoiceItemForm'
      FormNameParam.Value = 'TOrderClientJournalChoiceItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
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
          Name = 'ProductName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProductName_OrderClient'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName_OrderClient'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptGoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'GoodsNode'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actSetErased: TdsdUpdateErased
      Category = 'GoodsNode'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1059#1079#1077#1083'/'#1051#1086#1076#1082#1072'>'
      ImageIndex = 2
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
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
          StoredProc = spSelectMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actSetErasedChild: TdsdUpdateErased
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIchild
      StoredProcList = <
        item
          StoredProc = spErasedMIchild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 2
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
    end
    object actSetUnErasedChild: TdsdUpdateErased
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIchild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIchild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object actSetUnErased_Boat: TdsdUpdateErased
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
    object actSetUnErased: TdsdUpdateErased
      Category = 'GoodsNode'
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
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
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
      ImageIndex = 77
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
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 76
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
      ImageIndex = 52
      Status = mtDelete
      Guides = StatusGuides
    end
    object actMIContainer: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 57
      FormName = 'TMovementItemContainerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMovementItemChildProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
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
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1055#1088#1086#1090#1086#1082#1086#1083
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1059#1079#1077#1083'/'#1051#1086#1076#1082#1072'>'
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
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_MI_Child: TdsdExecStoredProc
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_Child
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_Child
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1088#1072#1089#1093#1086#1076
      Hint = #1055#1077#1088#1077#1089#1095#1077#1090' '#1088#1072#1089#1093#1086#1076
      ImageIndex = 27
    end
    object actShowAll_child: TBooleanStoredProcAction
      Category = 'Child'
      MoveParams = <>
      StoredProc = spSelectMIChild
      StoredProcList = <
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082'('#1088#1072#1089#1093#1086#1076')'
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082'('#1088#1072#1089#1093#1086#1076')'
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082'.'
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdate_MI_Child_byOrder: TdsdExecStoredProc
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_Child_byOrder
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_Child_byOrder
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1087#1086' '#1079#1072#1082#1072#1079#1091' '#1085#1072' '#1087#1088#1086#1080#1079#1074'.'
      Hint = #1055#1077#1088#1077#1089#1095#1077#1090' '#1087#1086' '#1079#1072#1082#1072#1079#1091' '#1085#1072' '#1087#1088#1086#1080#1079#1074'.'
      ImageIndex = 47
    end
    object actUpdate_MI_Child_byReceipt: TdsdExecStoredProc
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_Child_byReceipt
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_Child_byReceipt
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1087#1086' '#1096#1072#1073#1083#1086#1085#1091
      Hint = #1055#1077#1088#1077#1089#1095#1077#1090' '#1087#1086' '#1096#1072#1073#1083#1086#1085#1091
      ImageIndex = 48
    end
    object actUpdateChoiceFormBoat: TOpenChoiceForm
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
          Value = Null
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
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName_OrderClient'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isEnabled'
          Value = Null
          DataType = ftBoolean
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptProdModelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptGoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
        end
        item
          Name = 'OperPrice_PU'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'OperPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Summ_PU'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'Summ'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
    object actSetErasedDetail: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIDetail
      StoredProcList = <
        item
          StoredProc = spErasedMIDetail
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      ImageIndex = 2
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
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
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    object actInsertRecordDetail_All: TInsertRecord
      Category = 'Detail'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView_DetAll
      Action = actProductionUnionMasterChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      ImageIndex = 0
    end
    object actProductionUnionMasterChoiceForm: TOpenChoiceForm
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'MasterChoiceForm'
      FormName = 'TProductionUnionMasterChoiceForm'
      FormNameParam.Value = 'TProductionUnionMasterChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
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
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_OrderClient'
          Value = '0'
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_OrderClient'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42160d
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
    object actReceiptServiceChoiceForm_DetAll: TOpenChoiceForm
      Category = 'Detail'
      TabSheet = cxTabSheetDetail
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
    object actUpdateDetail_All: TdsdUpdateDataSet
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
      Caption = 'actUpdateMasterDS'
      DataSource = DetailDS_All
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
    object actSetErasedDetail_All: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedMIDetailAll
      StoredProcList = <
        item
          StoredProc = spErasedMIDetailAll
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'>'
      ImageIndex = 2
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      DataSource = DetailDS_All
    end
    object SetUnErasedDetail_All: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = cxTabSheetDetail
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
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS_All
    end
    object actMIDetailAllProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1056#1072#1073#1086#1090#1099'>'
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
    object actMIDetailProtocolOpenForm: TdsdOpenForm
      Category = 'Protocol'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1056#1072#1073#1086#1090#1099'>'
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
    object mactErasedMI_Master: TMultiAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      ActionList = <
        item
          Action = mactErasedMI_Master_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'?'
      InfoAfterExecute = #1057#1090#1088#1086#1082#1080' '#1091#1076#1072#1083#1077#1085#1099
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 52
    end
    object mactErasedMI_Master_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetErased
        end>
      View = cxGridDBTableViewMaster
      Caption = 'mactErasedMI_Master_list'
    end
    object actOpenOrderClientForm: TdsdOpenForm
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
          Value = 42160d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object mactInsertUpdate_bySend: TMultiAction
      Category = 'GoodsNode'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendInsertForm
        end
        item
          Action = actInsertUpdate_bySend
        end
        item
          Action = actRefreshMI_Master
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1087#1086#1083#1085#1080#1090#1100' '#1091#1079#1083#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1091#1079#1083#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1091#1079#1083#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ImageIndex = 47
    end
    object actSendInsertForm: TOpenChoiceForm
      Category = 'GoodsNode'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'SendJournalForm'
      FormName = 'TSendJournalChoiceForm'
      FormNameParam.Value = 'TSendJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementId_Send'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertUpdate_bySend: TdsdExecStoredProc
      Category = 'GoodsNode'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_bySend
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_bySend
        end
        item
        end>
      Caption = 'actInsert_MI_Send'
    end
    object actReport_Goods_master: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1076#1074#1080#1078#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      Hint = #1054#1090#1095#1077#1090' <'#1076#1074#1080#1078#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> '#1055#1088#1080#1093#1086#1076
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_Goods_child: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1076#1074#1080#1078#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      Hint = #1054#1090#1095#1077#1090' <'#1076#1074#1080#1078#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> '#1056#1072#1089#1093#1086#1076
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Article'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'ObjectCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object mactInsertRecordReceiptGoods: TMultiAction
      Category = 'GoodsNode'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertRecordReceiptGoods
        end
        item
          Action = actRefreshMI_Master
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1079#1077#1083' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1079#1077#1083' ('#1089#1087#1080#1089#1086#1082')'
      ImageIndex = 0
    end
    object actInsertRecordReceiptGoods: TInsertRecord
      Category = 'GoodsNode'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewMaster
      Action = actUpdateChoiceFormReceiptGoods
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1079#1077#1083' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1079#1077#1083' ('#1089#1087#1080#1089#1086#1082')'
    end
    object actUpdateChoiceFormReceiptGoods: TOpenChoiceForm
      Category = 'GoodsNode'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1079#1077#1083' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1091#1079#1077#1083' ('#1089#1087#1080#1089#1086#1082')'
      ImageIndex = 1
      FormName = 'TReceiptGoodsChoiceForm'
      FormNameParam.Value = 'TReceiptGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptProdModelName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOrderClientChoiceForm: TOpenChoiceForm
      Category = 'GoodsNode'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOrderClientChoiceForm'
      FormName = 'TOrderClientJournalChoiceForm'
      FormNameParam.Value = 'TOrderClientJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_OrderClient'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberFull_OrderClient'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProductName_OrderClient'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CIN'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CIN'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName_OrderClient'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ImageIndex = 87
    end
    object mactUpdate_MI_Child_byOrder_list: TMultiAction
      Category = 'Child'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_MI_Child_byOrder
        end>
      View = cxGridDBTableViewMaster
      Caption = 'mactUpdate_MI_Child_byOrder_list'
      ImageIndex = 47
    end
    object mactUpdate_MI_Child_byOrder: TMultiAction
      Category = 'Child'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdate_MI_Child_byOrder_list
        end
        item
          Action = actRefresh_Child
        end>
      QuestionBeforeExecute = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1077#1088#1077#1089#1095#1077#1090' '#1088#1072#1089#1093#1086#1076#1072' '#1087#1086' '#1079#1072#1082#1072#1079#1091' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'?'
      InfoAfterExecute = #1055#1077#1088#1077#1089#1095#1077#1090' '#1074#1099#1087#1086#1083#1085#1077#1085
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1087#1086' '#1079#1072#1082#1072#1079#1091' '#1085#1072' '#1087#1088#1086#1080#1079#1074'.'
      Hint = #1055#1077#1088#1077#1089#1095#1077#1090' '#1087#1086' '#1079#1072#1082#1072#1079#1091' '#1085#1072' '#1087#1088#1086#1080#1079#1074'.'
      ImageIndex = 47
    end
    object mactUpdate_MI_Child_byReceipt_list: TMultiAction
      Category = 'Child'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_MI_Child_byReceipt
        end>
      View = cxGridDBTableViewMaster
      Caption = 'mactUpdate_MI_Child_byReceipt_list'
      ImageIndex = 48
    end
    object mactUpdate_MI_Child_byReceipt: TMultiAction
      Category = 'Child'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdate_MI_Child_byReceipt_list
        end
        item
          Action = actRefresh_Child
        end>
      QuestionBeforeExecute = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1077#1088#1077#1089#1095#1077#1090' '#1088#1072#1089#1093#1086#1076#1072' '#1087#1086' '#1096#1072#1073#1083#1086#1085#1091'?'
      InfoAfterExecute = #1055#1077#1088#1077#1089#1095#1077#1090' '#1074#1099#1087#1086#1083#1085#1077#1085
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1088#1072#1089#1093#1086#1076#1072' '#1087#1086' '#1096#1072#1073#1083#1086#1085#1091
      Hint = #1055#1077#1088#1077#1089#1095#1077#1090' '#1088#1072#1089#1093#1086#1076#1072' '#1087#1086' '#1096#1072#1073#1083#1086#1085#1091
      ImageIndex = 48
    end
    object mactCompleteMovement_andSave: TMultiAction
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMovement
        end
        item
          Action = actRefresh
        end
        item
          Action = actCompleteMovement
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' + '#1055#1088#1086#1074#1077#1089#1090#1080
      ImageIndex = 86
    end
    object actSetVisible_Grid_Detail: TBooleanSetVisibleAction
      MoveParams = <>
      Value = False
      Components = <
        item
          Component = cxSplitter_Bottom_Detail
        end
        item
          Component = cxGrid_Detail
        end>
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1056#1072#1073#1086#1090#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1073#1086#1090#1099
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1056#1072#1073#1086#1090#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1073#1086#1090#1099
      ImageIndexTrue = 25
      ImageIndexFalse = 26
    end
    object actSetVisible_Grid_Child: TBooleanSetVisibleAction
      MoveParams = <>
      Value = False
      Components = <
        item
          Component = cxSplitter_Bottom_Child
        end
        item
          Component = cxGrid_Child
        end>
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1057#1073#1086#1088#1082#1091
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1057#1073#1086#1088#1082#1091
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1057#1073#1086#1088#1082#1091
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1057#1073#1086#1088#1082#1091
      ImageIndexTrue = 31
      ImageIndexFalse = 32
    end
    object actSetVisibleScan: TdsdSetVisibleAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetVisibleScan'
      SetVisibleParams = <
        item
          Component = cxTabSheetScan
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isScan'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end>
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 46
    Top = 351
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 351
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
    Left = 528
    Top = 8
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 448
    Top = 224
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ProductionUnion'
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
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptProdModelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptProdModelId'
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
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 102
    Top = 327
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewMaster
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 483
    Top = 177
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 342
    Top = 263
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ProductionUnion'
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
        Name = 'inParentId'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        ParamType = ptInput
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
        Name = 'inInvNumberInvoice'
        Value = Null
        Component = edInvNumberInvoice
        DataType = ftString
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
    Left = 202
    Top = 184
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
        Control = edOperDate
      end
      item
        Control = ceParent
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = ceComment
      end
      item
        Control = edInvNumberInvoice
      end>
    GetStoredProc = spGet
    ActionAfterExecute = actRefresh
    Left = 344
    Top = 217
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionUnion'
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
        DataType = ftString
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
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
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
        Name = 'MovementId_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberInvoice'
        Value = Null
        Component = edInvNumberInvoice
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isScan'
        Value = Null
        Component = FormParams
        ComponentItem = 'isScan'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 240
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 494
    Top = 242
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 144
    Top = 224
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_SetErased'
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
    Left = 574
    Top = 201
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_SetUnErased'
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
    Left = 622
    Top = 200
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
    StoredProcName = 'gpUpdate_Status_ProductionUnion'
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
    Left = 52
    Top = 48
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 736
    Top = 201
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 254
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnion_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
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
    Left = 815
    Top = 208
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 566
    Top = 333
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 537
    Top = 341
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild
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
        ColorColumn = Value_ch1
        BackGroundValueColumn = Color_value_ch1
        ColorValueList = <>
      end
      item
        ValueColumn = Color_Level_ch1
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 328
    Top = 360
  end
  object spSelectMIChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionUnion_Child'
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
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll_child
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
    Left = 386
    Top = 357
  end
  object spErasedMIchild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_SetErased_Child'
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
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 462
    Top = 408
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
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 304
  end
  object spUnErasedMIchild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_SetUnErased_Child'
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
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 470
    Top = 352
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Child'
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
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ObjectId'
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
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioForCount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ForCount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChangeReceipt'
        Value = Null
        Component = cbChangeReceipt
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 230
    Top = 343
  end
  object GuidesParent: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TOrderClientJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderClientJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesParent
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 267
    Top = 63
  end
  object spUpdate_MI_Child: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inParentId'
        Value = 0
        Component = MasterCDS
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
      end>
    PackSize = 1
    Left = 158
    Top = 367
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 104
    Top = 455
  end
  object DetailDS: TDataSource
    DataSet = DetailCDS
    Left = 142
    Top = 455
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 67
    Top = 505
  end
  object spInsertUpdateMIDetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Detail'
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
    Left = 166
    Top = 495
  end
  object spUnErasedMIDetail: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_SetUnErased_Detail'
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
    Left = 246
    Top = 479
  end
  object spErasedMIDetail: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_SetErased_Detail'
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
    Left = 374
    Top = 471
  end
  object spSelectMI_Detail: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionUnion_Detail'
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
        Component = actShowAll_child
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
    Left = 120
    Top = 535
  end
  object spSelectMI_DetailAll: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionUnion_Detail'
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
        Component = actShowAll_child
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
    Left = 680
    Top = 383
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 995
    Top = 425
  end
  object DetailDS_All: TDataSource
    DataSet = DetailCDS_All
    Left = 846
    Top = 343
  end
  object DetailCDS_All: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 808
    Top = 335
  end
  object spUnErasedMIDetail_All: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_SetUnErased_Detail'
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
    Left = 718
    Top = 431
  end
  object spErasedMIDetailAll: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnion_SetErased_Detail'
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
    Left = 782
    Top = 463
  end
  object spInsertUpdateMIDetailAll: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Detail'
    DataSet = DetailCDS_All
    DataSets = <
      item
        DataSet = DetailCDS_All
      end>
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
    Left = 702
    Top = 335
  end
  object spInsertUpdate_bySend: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionUnion_Master_bySend'
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
        Name = 'inMovementId_Send'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_Send'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 358
    Top = 159
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 767
    Top = 9
  end
  object spUpdate_MI_Child_byOrder: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_Child_byOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
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
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 958
    Top = 271
  end
  object spUpdate_MI_Child_byReceipt: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_Child_byReceipt'
    DataSets = <>
    OutputType = otResult
    Params = <
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
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptProdModelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptProdModelId'
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
      end>
    PackSize = 1
    Left = 966
    Top = 319
  end
  object ScanDS: TDataSource
    DataSet = ScanCDS
    Left = 630
    Top = 471
  end
  object ScanCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 560
    Top = 471
  end
  object spSelectScan: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionUnion_Scan'
    DataSet = ScanCDS
    DataSets = <
      item
        DataSet = ScanCDS
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 471
  end
  object DBViewAddOnScan: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView_Scan
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
      end
      item
      end>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 574
    Top = 409
  end
end
