object ReceiptProdModelForm: TReceiptProdModelForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1052#1086#1076#1077#1083#1080'>'
  ClientHeight = 443
  ClientWidth = 1293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ChoiceAction = actChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMaster: TPanel
    Left = 0
    Top = 26
    Width = 1293
    Height = 209
    Align = alTop
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 0
    object cxGrid: TcxGrid
      Left = 0
      Top = 17
      Width = 1293
      Height = 192
      Align = alClient
      PopupMenu = PopupMenu
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSource
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = BasisPrice
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = BasisPriceWVAT
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = Name
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = BasisPrice
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = BasisPriceWVAT
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object isMain: TcxGridDBColumn
          Caption = #1043#1083#1072#1074#1085#1099#1081' ('#1076#1072'/'#1085#1077#1090')'
          DataBinding.FieldName = 'isMain'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1043#1083#1072#1074#1085#1099#1081' ('#1076#1072'/'#1085#1077#1090')'
          Options.Editing = False
          Width = 72
        end
        object Code: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 43
        end
        object UserCode: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079'. '#1050#1086#1076
          DataBinding.FieldName = 'UserCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1081' '#1050#1086#1076
          Options.Editing = False
          Width = 92
        end
        object Name: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'Name'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 189
        end
        object ModelName: TcxGridDBColumn
          Caption = #1052#1086#1076#1077#1083#1100
          DataBinding.FieldName = 'ModelName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object BrandName: TcxGridDBColumn
          Caption = #1052#1072#1088#1082#1072
          DataBinding.FieldName = 'BrandName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object EngineName: TcxGridDBColumn
          Caption = 'Engine'
          DataBinding.FieldName = 'EngineName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1052#1086#1090#1086#1088
          Options.Editing = False
          Width = 80
        end
        object EKPrice_summ: TcxGridDBColumn
          Caption = 'Total EK'
          DataBinding.FieldName = 'EKPrice_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1058#1054#1043#1054' '#1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object BasisPrice: TcxGridDBColumn
          Caption = 'Ladenpreis'
          DataBinding.FieldName = 'BasisPrice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089
          Options.Editing = False
          Width = 70
        end
        object BasisPriceWVAT: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
          DataBinding.FieldName = 'BasisPriceWVAT'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089
          Options.Editing = False
          Width = 70
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 179
        end
        object InsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InsertName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object UpdateDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object UpdateName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object isErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 78
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 1293
      Height = 17
      Align = alTop
      Caption = #1057#1073#1086#1088#1082#1072' '#1084#1086#1076#1077#1083#1080
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 1
    end
    object lbReceiptLevel: TcxLabel
      Left = 338
      Top = 23
      Hint = #1069#1090#1072#1087' '#1089#1073#1086#1088#1082#1080
      Caption = 'Level:'
      ParentShowHint = False
      ShowHint = True
    end
    object edReceiptLevel: TcxButtonEdit
      Left = 415
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 140
    end
    object lbModel: TcxLabel
      Left = 664
      Top = 23
      Caption = 'Model:'
    end
    object edModel: TcxButtonEdit
      Left = 706
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 151
    end
    object lbSearchArticle: TcxLabel
      Left = 203
      Top = 93
      Caption = #1055#1086#1080#1089#1082' Artikel Nr : '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchArticle: TcxTextEdit
      Left = 200
      Top = 119
      TabOrder = 7
      DesignSize = (
        125
        21)
      Width = 125
    end
  end
  object PanelProdColorPattern: TPanel
    Left = 781
    Top = 240
    Width = 512
    Height = 203
    Align = alRight
    BevelEdges = [beLeft]
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 1
    object cxGridProdColorPattern: TcxGrid
      Left = 0
      Top = 17
      Width = 510
      Height = 186
      Align = alClient
      PopupMenu = PopupMenuOption
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableViewProdColorPattern: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ProdColorPatternDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch2
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = ProdColorGroupName_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch2
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch2
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object NPP_ch2: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object ProdColorGroupName_ch2: TcxGridDBColumn
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
          DataBinding.FieldName = 'ProdColorGroupName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'actChoiceFormProdColorPattern'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103
          Width = 127
        end
        object ProdColorPatternName_ch2: TcxGridDBColumn
          Caption = #1069#1083#1077#1084#1077#1085#1090
          DataBinding.FieldName = 'ProdColorPatternName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'actChoiceFormProdColorPattern'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 58
        end
        object ProdColorName_ch2: TcxGridDBColumn
          Caption = 'Farbe'
          DataBinding.FieldName = 'ProdColorName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object Value_ch2: TcxGridDBColumn
          DataBinding.FieldName = 'Value'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077
          Width = 50
        end
        object GoodsGroupNameFull_ch2: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
          DataBinding.FieldName = 'GoodsGroupNameFull'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 150
        end
        object GoodsGroupName_ch2: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 172
        end
        object GoodsCode_ch2: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'GoodsCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
          Options.Editing = False
          Width = 55
        end
        object Article_ch2: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object GoodsName_ch2: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Options.Editing = False
          Width = 110
        end
        object MeasureName_ch2: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object EKPrice_ch2: TcxGridDBColumn
          Caption = 'Netto EK'
          DataBinding.FieldName = 'EKPrice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 50
        end
        object EKPriceWVAT_ch2: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ_ch2: TcxGridDBColumn
          Caption = 'Total EK'
          DataBinding.FieldName = 'EKPrice_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ_ch2: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object InsertDate_ch2: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InsertName_ch2: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object UpdateDate_ch2: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object UpdateName_ch2: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object Comment_ch2: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 179
        end
        object isErased_ch2: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 78
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableViewProdColorPattern
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 510
      Height = 17
      Align = alTop
      Caption = 'Boat Structure'
      Color = clLime
      ParentBackground = False
      TabOrder = 1
    end
  end
  object PanelGoods: TPanel
    Left = 0
    Top = 240
    Width = 773
    Height = 203
    Align = alClient
    BevelEdges = [beLeft]
    BevelOuter = bvNone
    TabOrder = 2
    object cxGridGoods: TcxGrid
      Left = 0
      Top = 17
      Width = 773
      Height = 186
      Align = alClient
      PopupMenu = PopupMenuColor
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      LookAndFeel.SkinName = 'UserSkin'
      object cxGridDBTableViewGoods: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = GoodsDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = Value_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = Value_service_ch1
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'C'#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = ObjectName_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = Value_ch1
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = Value_service_ch1
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Appending = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsView.CellAutoHeight = True
        OptionsView.Footer = True
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object isCheck_ch1: TcxGridDBColumn
          Caption = #1055#1088#1086#1074#1077#1088#1077#1085
          DataBinding.FieldName = 'isCheck'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object ReceiptLevelName_ch1: TcxGridDBColumn
          Caption = 'Level'
          DataBinding.FieldName = 'ReceiptLevelName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormReceiptLevel_ch1
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 75
        end
        object NPP_ch1: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
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
        object ObjectCode_ch1: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'ObjectCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object Article_ch1: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object Article_all_ch1: TcxGridDBColumn
          Caption = '***Artikel Nr'
          DataBinding.FieldName = 'Article_all'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object GoodsGroupNameFull_ch1: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
          DataBinding.FieldName = 'GoodsGroupNameFull'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 150
        end
        object GoodsGroupName_ch1: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 172
        end
        object ObjectName_ch1: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' / '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
          DataBinding.FieldName = 'ObjectName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actChoiceFormGoods
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 152
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
        object ProdColorName_ch1: TcxGridDBColumn
          Caption = 'Farbe'
          DataBinding.FieldName = 'ProdColorName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object Value_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Value'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          Width = 50
        end
        object Value_service_ch1: TcxGridDBColumn
          Caption = 'Value (service)'
          DataBinding.FieldName = 'Value_service'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
          Options.Editing = False
          Width = 63
        end
        object EKPrice_ch1: TcxGridDBColumn
          Caption = 'Netto EK'
          DataBinding.FieldName = 'EKPrice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 50
        end
        object EKPriceWVAT_ch1: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ_ch1: TcxGridDBColumn
          Caption = 'Total EK'
          DataBinding.FieldName = 'EKPrice_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ_ch1: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object OperDate_protocol_ch1: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103
          DataBinding.FieldName = 'OperDate_protocol'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1087#1088#1086#1090#1086#1082#1086#1083')'
          Options.Editing = False
          Width = 80
        end
        object UserName_protocol_ch1: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1088#1086#1090#1086#1082#1086#1083')'
          DataBinding.FieldName = 'UserName_protocol'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1088#1086#1090#1086#1082#1086#1083')'
          Options.Editing = False
          Width = 80
        end
        object InsertDate_ch1: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InsertName_ch1: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object UpdateDate_ch1: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object UpdateName_ch1: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object Comment_ch1: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 179
        end
        object PartnerName_ch1: TcxGridDBColumn
          Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
          DataBinding.FieldName = 'PartnerName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object UnitName_ch1: TcxGridDBColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object isErased_ch1: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 78
        end
        object Id_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Id'
          Visible = False
          VisibleForCustomization = False
          Width = 60
        end
        object Color_value_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Color_value'
          Visible = False
          VisibleForCustomization = False
          Width = 60
        end
        object Color_Level_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Color_Level'
          Visible = False
          VisibleForCustomization = False
          Width = 60
        end
        object Color_isCheck_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Color_isCheck'
          Visible = False
          VisibleForCustomization = False
          Width = 55
        end
        object Bold_isReceiptGoods_ch1: TcxGridDBColumn
          DataBinding.FieldName = 'Bold_isReceiptGoods'
          Visible = False
          VisibleForCustomization = False
          Width = 60
        end
      end
      object ChildView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = GoodsChildDS
        DataController.DetailKeyFieldNames = 'ReceiptProdModelChildId'
        DataController.MasterKeyFieldNames = 'Id'
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch3
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch3
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPrice_summ_ch3
          end
          item
            Format = ',0.00##'
            Kind = skSum
            Column = EKPriceWVAT_summ_ch3
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.ImageList
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        Styles.Content = dmMain.cxContentStyle
        Styles.Inactive = dmMain.cxSelection
        Styles.Selection = dmMain.cxSelection
        Styles.Footer = dmMain.cxFooterStyle
        Styles.Header = dmMain.cxHeaderStyle
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object NPP_ch3: TcxGridDBColumn
          Caption = #8470' '#1087'/'#1087
          DataBinding.FieldName = 'NPP'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object GoodsCode_ch3: TcxGridDBColumn
          Caption = 'Interne Nr'
          DataBinding.FieldName = 'GoodsCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object Article_ch3: TcxGridDBColumn
          Caption = 'Artikel Nr'
          DataBinding.FieldName = 'Article'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object GoodsGroupNameFull_ch3: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
          DataBinding.FieldName = 'GoodsGroupNameFull'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 150
        end
        object GoodsGroupName_ch3: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 172
        end
        object GoodsName_ch3: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
          DataBinding.FieldName = 'GoodsName'
          Options.Editing = False
          Width = 70
        end
        object MeasureName_ch3: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object ProdColorName_ch3: TcxGridDBColumn
          Caption = 'Farbe'
          DataBinding.FieldName = 'ProdColorName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object Value_ch3: TcxGridDBColumn
          DataBinding.FieldName = 'Value'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077
          Width = 50
        end
        object EKPrice_ch3: TcxGridDBColumn
          Caption = 'Netto EK'
          DataBinding.FieldName = 'EKPrice'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 50
        end
        object EKPriceWVAT_ch3: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPrice_summ_ch3: TcxGridDBColumn
          Caption = 'Total EK'
          DataBinding.FieldName = 'EKPrice_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object EKPriceWVAT_summ_ch3: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          DataBinding.FieldName = 'EKPriceWVAT_summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1053#1044#1057
          Options.Editing = False
          Width = 70
        end
        object PartnerName_ch3: TcxGridDBColumn
          Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
          DataBinding.FieldName = 'PartnerName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object UnitName_ch3: TcxGridDBColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object ReceiptProdModelChildId_ch3: TcxGridDBColumn
          DataBinding.FieldName = 'GoodsId_parent'
          Visible = False
          VisibleForCustomization = False
          Width = 60
        end
      end
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBTableViewGoods
        object cxGridGoodsLevel1: TcxGridLevel
          GridView = ChildView
        end
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 773
      Height = 17
      Align = alTop
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' / '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
      Color = clAqua
      ParentBackground = False
      TabOrder = 1
    end
  end
  object cxTopSplitter: TcxSplitter
    Left = 0
    Top = 235
    Width = 1293
    Height = 5
    AlignSplitter = salTop
    Control = PanelMaster
  end
  object cxRightSplitter: TcxSplitter
    Left = 773
    Top = 240
    Width = 8
    Height = 203
    AlignSplitter = salRight
    Control = PanelProdColorPattern
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 608
    Top = 128
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 560
    Top = 136
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
    Left = 64
    Top = 144
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
    Left = 144
    Top = 128
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSearchArticleLabel'
        end
        item
          Visible = True
          ItemName = 'bbSearchArticle'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'BarSubItemBoat'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'BarSubItemColor'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'BarSubItemOption'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbModelLabel'
        end
        item
          Visible = True
          ItemName = 'bbModel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReceiptLevelLabel'
        end
        item
          Visible = True
          ItemName = 'bbReceiptLevel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
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
          ItemName = 'bbChoice'
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
          ItemName = 'bbPrintStructure'
        end
        item
          Visible = True
          ItemName = 'bbPrintStructureGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
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
    object bbToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoice: TdxBarButton
      Action = actChoiceGuides
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAllErased
      Category = 0
    end
    object bbInsertRecordProdColorItems: TdxBarButton
      Action = actInsertRecordGoods
      Category = 0
    end
    object bbInsertRecordProdOptItems: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Enabled = False
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbSetErasedColor: TdxBarButton
      Action = actSetErasedGoods
      Category = 0
    end
    object bbSetUnErasedColor: TdxBarButton
      Action = actSetUnErasedGoods
      Category = 0
    end
    object bbSetErasedOpt: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 16430
    end
    object bbSetUnErasedOpt: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 16430
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbShowAllColorItems: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Visible = ivAlways
      ImageIndex = 63
    end
    object bbShowAllOptItems: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077' '#1096#1072#1073#1083#1086#1085#1099
      Visible = ivAlways
      ImageIndex = 63
    end
    object BarSubItemBoat: TdxBarSubItem
      Caption = #1064#1072#1073#1083#1086#1085
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end>
    end
    object BarSubItemColor: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' / '#1056#1072#1073#1086#1090#1099
      Category = 0
      Hint = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' / '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordProdColorItems'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedColor'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedColor'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordGoods_limit'
        end>
    end
    object BarSubItemOption: TdxBarSubItem
      Caption = 'Boat Structure'
      Category = 0
      Visible = ivNever
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertRecordProdOptItems'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedOpt'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedOpt'
        end>
    end
    object bbShowAllBoatSale: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1083#1086#1076#1082#1080' (+'#1087#1088#1086#1076#1072#1085#1085#1099#1077')'
      Visible = ivAlways
      ImageIndex = 63
    end
    object bbReceiptLevelLabel: TdxBarControlContainerItem
      Caption = 'bbReceiptLevelLabel'
      Category = 0
      Visible = ivAlways
      Control = lbReceiptLevel
    end
    object bbReceiptLevel: TdxBarControlContainerItem
      Caption = 'bbReceiptLevel'
      Category = 0
      Visible = ivAlways
      Control = edReceiptLevel
    end
    object bbModelLabel: TdxBarControlContainerItem
      Caption = 'bbModelLabel'
      Category = 0
      Visible = ivAlways
      Control = lbModel
    end
    object bbModel: TdxBarControlContainerItem
      Caption = 'bbModel'
      Category = 0
      Visible = ivAlways
      Control = edModel
    end
    object bbSearchArticleLabel: TdxBarControlContainerItem
      Caption = 'bbSearchArticleLabel'
      Category = 0
      Visible = ivAlways
      Control = lbSearchArticle
    end
    object bbSearchArticle: TdxBarControlContainerItem
      Caption = 'bbSearchArticle'
      Category = 0
      Visible = ivAlways
      Control = edSearchArticle
    end
    object bbPrintStructureGoods: TdxBarButton
      Action = actPrintStructureGoods
      Category = 0
    end
    object bbPrintStructure: TdxBarButton
      Action = actPrintStructure
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbInsertRecordGoods_limit: TdxBarButton
      Action = actInsertRecordGoods_limit
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 24
    Top = 104
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Goods
        end
        item
          StoredProc = spSelect_ProdColorPattern
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      FormName = 'TReceiptProdModelEditForm'
      FormNameParam.Value = 'TReceiptProdModelEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
      FormName = 'TReceiptProdModelEditForm'
      FormNameParam.Value = 'TReceiptProdModelEditForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErased
      StoredProcList = <
        item
          StoredProc = spErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object actSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErased
      StoredProcList = <
        item
          StoredProc = spUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actProtocol: TdsdOpenForm
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
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowAllErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Goods
        end
        item
          StoredProc = spSelect_ProdColorPattern
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actInsertRecordGoods: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewGoods
      Action = actChoiceFormGoods
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object actInsertRecordGoods_limit: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewGoods
      Action = actChoiceFormGoods_limit
      Params = <>
      Caption = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      Hint = '***'#1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 54
    end
    object actUpdateDataSetGoods: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Goods
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Goods
        end
        item
          StoredProc = spSelect_Goods
        end
        item
          StoredProc = spSelect_ProdColorPattern
        end>
      Caption = 'actUpdateDataSetGoods'
      DataSource = GoodsDS
    end
    object actSetErasedGoods: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedGoods
      StoredProcList = <
        item
          StoredProc = spErasedGoods
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = GoodsDS
    end
    object actSetUnErasedGoods: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedGoods
      StoredProcList = <
        item
          StoredProc = spUnErasedGoods
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = GoodsDS
    end
    object actChoiceFormGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods'
      FormName = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.Value = 'TUnion_Goods_ReceiptServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ObjectCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormGoods_limit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods'
      FormName = 'TUnion_Goods_ReceiptService_limitForm'
      FormNameParam.Value = 'TUnion_Goods_ReceiptService_limitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ObjectCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormReceiptLevel_ch1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormReceiptLevel_ch1'
      FormName = 'TReceiptLevelForm'
      FormNameParam.Value = 'TReceiptLevelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ReceiptLevelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GoodsCDS
          ComponentItem = 'ReceiptLevelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintStructure: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintStructure
      StoredProcList = <
        item
          StoredProc = spSelectPrintStructure
        end>
      Caption = 'Print Structure'
      Hint = 'Print Structure'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NPP;GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReceiptProdModel_Structure'
      ReportNameParam.Value = 'PrintReceiptProdModel_Structure'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PictureFields.Strings = (
        'photo1')
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
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inReceiptProdModelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inReceiptLevelId_top'
          Value = Null
          Component = GuidesReceiptLevel
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actStartLoad: TMultiAction
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
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1072#1085#1085#1099#1093' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
    end
    object actPrintStructureGoods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintStructureGoods
      StoredProcList = <
        item
          StoredProc = spSelectPrintStructureGoods
        end>
      Caption = 'Print Structure Goods'
      Hint = 'PrintStructure Goods'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NPP;GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintReceiptProdModel_StructureGoods'
      ReportNameParam.Value = 'PrintReceiptProdModel_StructureGoods'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PictureFields.Strings = (
        'photo1')
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptProdModel'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 120
  end
  object spErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptProdModel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 80
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 352
    Top = 120
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 656
    Top = 112
  end
  object spUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptProdModel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 128
  end
  object ProdColorPatternCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ReceiptProdModelId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 896
    Top = 360
  end
  object ProdColorPatternDS: TDataSource
    DataSet = ProdColorPatternCDS
    Left = 888
    Top = 320
  end
  object dsdDBViewAddOnProdColorPattern: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewProdColorPattern
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 1088
    Top = 296
  end
  object GoodsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ReceiptProdModelId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 240
    Top = 352
  end
  object GoodsDS: TDataSource
    DataSet = GoodsCDS
    Left = 320
    Top = 336
  end
  object dsdDBViewAddOnGoods: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewGoods
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ValueColumn = Color_Level_ch1
        ColorValueList = <>
        ValueBoldColumn = Bold_isReceiptGoods_ch1
      end
      item
        ColorColumn = Value_ch1
        BackGroundValueColumn = Color_value_ch1
        ColorValueList = <>
      end
      item
        ColorColumn = isCheck_ch1
        BackGroundValueColumn = Color_isCheck_ch1
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 376
    Top = 352
  end
  object spSelect_Goods: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptProdModelChild_Goods'
    DataSet = GoodsCDS
    DataSets = <
      item
        DataSet = GoodsCDS
      end
      item
        DataSet = GoodsChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 104
    Top = 312
  end
  object spSelect_ProdColorPattern: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptProdModelChild_ProdColorPattern'
    DataSet = ProdColorPatternCDS
    DataSets = <
      item
        DataSet = ProdColorPatternCDS
      end>
    Params = <
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowAllErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 288
  end
  object spInsertUpdate_Goods: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReceiptProdModelChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptProdModelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId_top'
        Value = Null
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'ReceiptLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioValue_service'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'Value_service'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEKPrice_summ'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'EKPrice_summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEKPriceWVAT_summ'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'EKPriceWVAT_summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outReceiptLevelName'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'ReceiptLevelName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsCheck'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'isCheck'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 24
    Top = 320
  end
  object spInsertUpdate_ProdColorPattern: TdsdStoredProc
    DataSet = ProdColorPatternCDS
    DataSets = <
      item
        DataSet = ProdColorPatternCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ProdColorPatternCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ProdColorPatternCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptProdModelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorPatternCDS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'ReceiptLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = ProdColorPatternCDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1184
    Top = 264
  end
  object spErasedGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdColorPattern'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 344
  end
  object spUnErasedGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdColorPattern'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = GoodsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 320
  end
  object spErasedProdColorPattern: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorPatternCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 888
    Top = 240
  end
  object spUnErasedProdColorPattern: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ProdColorPatternCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1000
    Top = 256
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName_full'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 760
    Top = 120
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
          'TReceiptProdModelChildForm;zc_Object_ImportSetting_ReceiptProdMo' +
          'delChild'
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
    Left = 888
    Top = 136
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 352
    Top = 184
    object N1: TMenuItem
      Action = actRefresh
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    end
    object N2: TMenuItem
      Action = actInsert
    end
    object N4: TMenuItem
      Action = actUpdate
    end
    object N3: TMenuItem
      Action = actSetErased
    end
    object N5: TMenuItem
      Action = actSetUnErased
    end
  end
  object PopupMenuColor: TPopupMenu
    Images = dmMain.ImageList
    Left = 440
    Top = 184
    object MenuItem2: TMenuItem
      Action = actInsertRecordGoods
    end
    object MenuItem3: TMenuItem
      Action = actSetErasedGoods
    end
    object MenuItem4: TMenuItem
      Action = actSetUnErasedGoods
    end
  end
  object PopupMenuOption: TPopupMenu
    Images = dmMain.ImageList
    Left = 496
    Top = 208
    object MenuItem1: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Enabled = False
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object MenuItem5: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 16430
    end
    object MenuItem6: TMenuItem
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 16430
    end
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ChildView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 208
    Top = 352
  end
  object GoodsChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ReceiptProdModelChildId'
    MasterFields = 'Id'
    MasterSource = GoodsDS
    PacketRecords = 0
    Params = <>
    Left = 64
    Top = 392
  end
  object GoodsChildDS: TDataSource
    DataSet = GoodsChildCDS
    Left = 136
    Top = 392
  end
  object GuidesReceiptLevel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReceiptLevel
    FormNameParam.Value = 'TReceiptLevelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptLevelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReceiptLevel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 520
    Top = 48
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesReceiptLevel
      end
      item
        Component = GuidesModel
      end>
    Left = 936
    Top = 56
  end
  object GuidesModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edModel
    FormNameParam.Value = 'TProdModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName_full'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 815
    Top = 50
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = GoodsCDS
    Column = Article_all_ch1
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 352
    Top = 240
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1012
    Top = 89
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1012
    Top = 142
  end
  object PrintItemsColorCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1012
    Top = 198
  end
  object spSelectPrintStructureGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptProdModel_Print'
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
        Name = 'inReceiptProdModelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = Null
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1104
    Top = 88
  end
  object spSelectPrintStructure: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptProdModel_Print'
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
        Name = 'inReceiptProdModelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptLevelId'
        Value = ''
        Component = GuidesReceiptLevel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1136
    Top = 136
  end
end
