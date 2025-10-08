﻿object ProdOptions_TranslateForm: TProdOptions_TranslateForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1054#1087#1094#1080#1080' '#1087#1077#1088#1077#1074#1086#1076'>'
  ClientHeight = 411
  ClientWidth = 881
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = actChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 63
    Width = 881
    Height = 309
    Align = alClient
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
        end
        item
          Format = ',0.00##'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EKPrice
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EKPriceWVAT
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = BasisPrice
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = BasisPriceWVAT
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = SalePrice
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = SalePriceWVAT
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
        end
        item
          Format = ',0.00##'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EKPrice
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EKPriceWVAT
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = BasisPrice
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = BasisPriceWVAT
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = SalePrice
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = SalePriceWVAT
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
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
      object NPP: TcxGridDBColumn
        Caption = #8470' '#1087'/'#1087
        DataBinding.FieldName = 'NPP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object MaterialOptionsName: TcxGridDBColumn
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1054#1087#1094#1080#1081
        DataBinding.FieldName = 'MaterialOptionsName'
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
        Width = 150
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 43
      end
      object CodeVergl: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1079#1072#1084#1077#1085#1099
        DataBinding.FieldName = 'CodeVergl'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1074#1079#1072#1080#1084#1086#1079#1072#1084#1077#1085#1099
        Options.Editing = False
        Width = 70
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 150
      end
      object ProdColorName: TcxGridDBColumn
        Caption = 'Farbe'
        DataBinding.FieldName = 'ProdColorName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceFormProdColor_goods
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object ProdColorPatternName: TcxGridDBColumn
        Caption = #1069#1083#1077#1084#1077#1085#1090' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088#1072
        DataBinding.FieldName = 'ProdColorPatternName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceFormProdColorPattern
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object BrandName: TcxGridDBColumn
        Caption = #1052#1072#1088#1082#1072
        DataBinding.FieldName = 'BrandName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object ModelName: TcxGridDBColumn
        Caption = 'Model'
        DataBinding.FieldName = 'ModelName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceFormModel
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object ProdEngineName: TcxGridDBColumn
        Caption = 'Engine'
        DataBinding.FieldName = 'ProdEngineName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 172
      end
      object GoodsCode: TcxGridDBColumn
        Caption = 'Interne Nr'
        DataBinding.FieldName = 'GoodsCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
        Options.Editing = False
        Width = 70
      end
      object Article: TcxGridDBColumn
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
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
        DataBinding.FieldName = 'GoodsName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceFormGoods
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object EKPrice: TcxGridDBColumn
        Caption = 'Netto EK (Art.)'
        DataBinding.FieldName = 'EKPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057' (Artikel)'
        Options.Editing = False
        Width = 70
      end
      object EKPriceWVAT: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (Art.)'
        DataBinding.FieldName = 'EKPriceWVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1053#1044#1057' (Artikel)'
        Options.Editing = False
        Width = 70
      end
      object BasisPrice: TcxGridDBColumn
        Caption = 'Ladenpreis (Art.)'
        DataBinding.FieldName = 'BasisPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089' (Artikel)'
        Options.Editing = False
        Width = 70
      end
      object BasisPriceWVAT: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089' (Art.)'
        DataBinding.FieldName = 'BasisPriceWVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089' (Artikel)'
        Options.Editing = False
        Width = 70
      end
      object Amount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' ('#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077')'
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
      object SalePrice: TcxGridDBColumn
        Caption = 'Ladenpreis (Opt.) ('#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082')'
        DataBinding.FieldName = 'SalePrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089' (Options) ('#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082')'
        Options.Editing = False
        Width = 124
      end
      object SalePrice_pr: TcxGridDBColumn
        Caption = 'Ladenpreis (Opt.) ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'SalePrice_pr'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089' (Options)'
        Options.Editing = False
        Width = 70
      end
      object StartDate_pr: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1089' ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'StartDate_pr'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 53
      end
      object SalePriceWVAT: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089' (Opt.)'
        DataBinding.FieldName = 'SalePriceWVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1085#1076#1089' (Options)'
        Options.Editing = False
        Width = 70
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        Visible = False
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
      object Id_Site: TcxGridDBColumn
        Caption = 'Id '#1057#1072#1081#1090
        DataBinding.FieldName = 'Id_Site'
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
        Options.Editing = False
        Width = 70
      end
      object NPP_pcp: TcxGridDBColumn
        Caption = '***'#8470' '#1087'/'#1087
        DataBinding.FieldName = 'NPP_pcp'
        Visible = False
        HeaderHint = #8470' '#1087'/'#1087' - '#1087#1088#1080#1086#1088#1080#1090#1077#1090' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1054#1087#1094#1080#1081
        Options.Editing = False
        Width = 55
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
      object Value1: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076' 1'
        DataBinding.FieldName = 'Value1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object Value2: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076' 2'
        DataBinding.FieldName = 'Value2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object Value3: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076' 3'
        DataBinding.FieldName = 'Value3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object Value4: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076' 4'
        DataBinding.FieldName = 'Value4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel6: TcxLabel
    Left = 245
    Top = 91
    Caption = 'Model:'
  end
  object edProdModel: TcxButtonEdit
    Left = 192
    Top = 138
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 122
  end
  object Panel_btn: TPanel
    Left = 0
    Top = 372
    Width = 881
    Height = 39
    Align = alBottom
    TabOrder = 3
    object btnInsert: TcxButton
      Left = 546
      Top = 6
      Width = 90
      Height = 26
      Action = actInsert
      TabOrder = 0
    end
    object btnUpdate: TcxButton
      Left = 650
      Top = 6
      Width = 90
      Height = 25
      Action = actUpdate
      TabOrder = 1
    end
    object btnChoiceGuides: TcxButton
      Left = 9
      Top = 6
      Width = 90
      Height = 25
      Action = actChoiceGuides
      TabOrder = 2
    end
    object btnSetErased: TcxButton
      Left = 752
      Top = 6
      Width = 90
      Height = 25
      Action = actSetErased
      TabOrder = 3
    end
    object btnFormClose: TcxButton
      Left = 111
      Top = 6
      Width = 90
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object btnSetNull_GuidesClient: TcxButton
      Left = 233
      Top = 6
      Width = 146
      Height = 25
      Action = actSetNull_GuidesModel
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object btnClientChoiceForm: TcxButton
      Left = 390
      Top = 6
      Width = 117
      Height = 25
      Action = actModelChoiceForm
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 881
    Height = 37
    Align = alTop
    TabOrder = 5
    object cxLabel2: TcxLabel
      Left = 8
      Top = 10
      Caption = #1055#1077#1088#1077#1074#1086#1076' 1:'
    end
    object edLanguage1: TcxButtonEdit
      Left = 75
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 144
    end
    object cxLabel3: TcxLabel
      Left = 230
      Top = 10
      Caption = #1055#1077#1088#1077#1074#1086#1076' 2:'
    end
    object cxLabel4: TcxLabel
      Left = 446
      Top = 10
      Caption = #1055#1077#1088#1077#1074#1086#1076' 3:'
    end
    object edLanguage2: TcxButtonEdit
      Left = 293
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 144
    end
    object edLanguage3: TcxButtonEdit
      Left = 510
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 144
    end
    object cxLabel5: TcxLabel
      Left = 665
      Top = 10
      Caption = #1055#1077#1088#1077#1074#1086#1076' 4:'
    end
    object edLanguage4: TcxButtonEdit
      Left = 731
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 144
    end
  end
  object cxLabel1: TcxLabel
    Left = 320
    Top = 139
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090':'
  end
  object edPriceList: TcxButtonEdit
    Left = 391
    Top = 138
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Text = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072
    Width = 106
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 56
    Top = 224
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 184
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = GuidesProdModel
        Properties.Strings = (
          'Key'
          'TextValue')
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
    Left = 88
    Top = 88
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
    Left = 48
    Top = 88
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
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
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
          ItemName = 'dxBarControlContainerItem4'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem5'
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
      Category = 0
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
      Action = actShowErased
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bbModel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edProdModel
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbPriceListGoods: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      Visible = ivAlways
      ImageIndex = 28
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object dxBarControlContainerItem5: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edPriceList
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 8
    Top = 104
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 90
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TProdOptionsEditForm'
      FormNameParam.Value = 'TProdOptionsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdModelId'
          Value = Null
          Component = GuidesProdModel
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdModelName'
          Value = Null
          Component = GuidesProdModel
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = Null
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
          Name = 'inPriceListName'
          Value = Null
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis'#1057'hangePrice'
          Value = Null
          DataType = ftBoolean
          ParamType = ptInput
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
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TProdOptionsEditForm'
      FormNameParam.Value = 'TProdOptionsEditForm'
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
          Name = 'MaskId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPriceListId'
          Value = '2773'
          Component = GuidesPriceList
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPriceListName'
          Value = Null
          Component = GuidesPriceList
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis'#1057'hangePrice'
          Value = Null
          DataType = ftBoolean
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
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 49220
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
      ShortCut = 49220
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
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BasisPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPriceWVAT'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BasisPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SalePrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SalePrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SalePriceWVAT'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SalePriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId_choice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId_choice'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaterialOptionsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MaterialOptionsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaterialOptionsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MaterialOptionsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1054#1050
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 80
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
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
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
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actModelChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1052#1086#1076#1077#1083#1100
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1052#1086#1076#1077#1083#1100
      ImageIndex = 7
      FormName = 'TProdModelForm'
      FormNameParam.Value = 'TProdModelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = ''
          Component = GuidesProdModel
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ModelName_full'
          Value = ''
          Component = GuidesProdModel
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceFormModel: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormModel'
      FormName = 'TProdModelForm'
      FormNameParam.Value = 'TProdModelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ModelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ModelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BrandId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BrandName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdEngineId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdEngineId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdEngineName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdEngineName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdColorPattern: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColorPattern'
      FormName = 'TProdColorPatternForm'
      FormNameParam.Value = 'TProdColorPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorPatternId'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorPatternName'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormGoods'
      FormName = 'TGoods_ChoiceForm'
      FormNameParam.Value = 'TGoods_ChoiceForm'
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
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
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPriceWVAT'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EKPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BasisPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'BasisPriceWVAT'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BasisPriceWVAT'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdColor_goods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdColor_goods'
      FormName = 'TProdColor_goodsForm'
      FormNameParam.Value = 'TProdColor_goodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EKPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EKPrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceFormProdOptions_сomment: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceFormProdOptions_'#1089'omment'
      FormName = 'TProdOptions_CommentForm'
      FormNameParam.Value = 'TProdOptions_CommentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Comment'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorPatternId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProdColorPatternName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProdColorPatternName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorPatternId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ColorPatternName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorPatternName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ShortCut = 16429
      ImageIndex = 54
      FormName = 'TProdOptionsEditForm'
      FormNameParam.Value = 'TProdOptionsEditForm'
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
          Name = 'MaskId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
      ImageIndex = 52
    end
    object actSetNull_GuidesModel: TdsdSetDefaultParams
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1052#1086#1076#1077#1083#1080
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1052#1086#1076#1077#1083#1080
      ImageIndex = 24
      DefaultParams = <
        item
          Param.Value = ''
          Param.Component = GuidesProdModel
          Param.ComponentItem = 'Id'
          Param.MultiSelectSeparator = ','
          Value = 0
        end
        item
          Param.Value = ''
          Param.Component = GuidesProdModel
          Param.ComponentItem = 'TextValue'
          Param.DataType = ftString
          Param.MultiSelectSeparator = ','
          Value = ''
        end>
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProdOptions'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inModelId'
        Value = Null
        Component = GuidesProdModel
        ComponentItem = 'Key'
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
        Name = 'inLanguageId1'
        Value = Null
        Component = GuidesLanguage1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageId2'
        Value = Null
        Component = GuidesLanguage2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageId3'
        Value = Null
        Component = GuidesLanguage3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageId4'
        Value = Null
        Component = GuidesLanguage4
        ComponentItem = 'Key'
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
    Left = 80
    Top = 136
  end
  object spErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdOptions'
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
    Left = 688
    Top = 184
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 288
    Top = 200
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 104
    Top = 248
  end
  object spUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ProdOptions'
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
    Left = 688
    Top = 232
  end
  object GuidesProdModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProdModel
    FormNameParam.Value = 'TProdModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName_full'
        Value = ''
        Component = GuidesProdModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 72
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ModelId'
        Value = ''
        Component = GuidesProdModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName_full'
        Value = ''
        Component = GuidesProdModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = '2773'
        Component = GuidesPriceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 112
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesProdModel
      end
      item
        Component = GuidesPriceList
      end
      item
        Component = GuidesLanguage1
      end
      item
        Component = GuidesLanguage2
      end
      item
        Component = GuidesLanguage3
      end
      item
        Component = GuidesLanguage4
      end>
    Left = 536
    Top = 128
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Translate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageId1'
        Value = Null
        Component = GuidesLanguage1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageId2'
        Value = Null
        Component = GuidesLanguage2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageId3'
        Value = Null
        Component = GuidesLanguage3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageId4'
        Value = Null
        Component = GuidesLanguage4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Value1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Value2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Value3'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Value4'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_ProdOptions'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 168
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    TextValue = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPriceList
        ComponentItem = 'Key'
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
    Left = 400
    Top = 144
  end
  object GuidesLanguage1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLanguage1
    FormNameParam.Value = 'TLanguageForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLanguageForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLanguage1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLanguage1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
  end
  object GuidesLanguage2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLanguage2
    FormNameParam.Value = 'TLanguageForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLanguageForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLanguage2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLanguage2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
  end
  object GuidesLanguage3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLanguage3
    FormNameParam.Value = 'TLanguageForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLanguageForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLanguage3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLanguage3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
  end
  object GuidesLanguage4: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLanguage4
    FormNameParam.Value = 'TLanguageForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLanguageForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLanguage4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLanguage4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 800
  end
end
