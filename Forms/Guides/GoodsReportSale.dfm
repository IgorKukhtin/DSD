object GoodsReportSaleForm: TGoodsReportSaleForm
  Left = 0
  Top = 0
  Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080
  ClientHeight = 425
  ClientWidth = 1042
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 83
    Width = 1042
    Height = 342
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch7
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Promo7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Branch7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Order7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderPromo7
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch1
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch2
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch3
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch4
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch5
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch6
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = OrderBranch7
        end
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = GoodsName
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 118
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
        Options.Editing = False
        Width = 52
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 86
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 84
      end
      object Amount1: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1087#1085'.'
        DataBinding.FieldName = 'Amount1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1087#1085'.'
        Options.Editing = False
        Width = 95
      end
      object Amount2: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1074#1090'.'
        DataBinding.FieldName = 'Amount2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1074#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Amount3: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1089#1088'.'
        DataBinding.FieldName = 'Amount3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1089#1088'.'
        Options.Editing = False
        Width = 95
      end
      object Amount4: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1095#1090'.'
        DataBinding.FieldName = 'Amount4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1095#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Amount5: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1087#1090'.'
        DataBinding.FieldName = 'Amount5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1087#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Amount6: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1089#1073'.'
        DataBinding.FieldName = 'Amount6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1089#1073'.'
        Options.Editing = False
        Width = 95
      end
      object Amount7: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1074#1089'.'
        DataBinding.FieldName = 'Amount7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1074#1089'.'
        Options.Editing = False
        Width = 95
      end
      object Promo1: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1040#1082#1094#1080#1080' '#1079#1072' '#1087#1085'.'
        DataBinding.FieldName = 'Promo1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1087#1085'.'
        Options.Editing = False
        Width = 95
      end
      object Promo2: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1040#1082#1094#1080#1080' '#1079#1072' '#1074#1090'.'
        DataBinding.FieldName = 'Promo2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1074#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Promo3: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1040#1082#1094#1080#1080' '#1079#1072' '#1089#1088'.'
        DataBinding.FieldName = 'Promo3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1089#1088'.'
        Options.Editing = False
        Width = 95
      end
      object Promo4: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1040#1082#1094#1080#1080' '#1079#1072' '#1095#1090'.'
        DataBinding.FieldName = 'Promo4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1095#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Promo5: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1040#1082#1094#1080#1080' '#1079#1072' '#1087#1090'.'
        DataBinding.FieldName = 'Promo5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1087#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Promo6: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1040#1082#1094#1080#1080' '#1079#1072' '#1089#1073'.'
        DataBinding.FieldName = 'Promo6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1089#1073'.'
        Options.Editing = False
        Width = 95
      end
      object Promo7: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1040#1082#1094#1080#1080' '#1079#1072' '#1074#1089'.'
        DataBinding.FieldName = 'Promo7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1074#1089'.'
        Options.Editing = False
        Width = 95
      end
      object Branch1: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1077#1084'. '#1087#1086' '#1094#1077#1085#1077'  '#1088#1072#1089#1093'. '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1087#1085'.'
        DataBinding.FieldName = 'Branch1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1087#1086' '#1094#1077#1085#1077' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1087#1085'.'
        Options.Editing = False
        Width = 95
      end
      object Branch2: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1077#1084'. '#1087#1086' '#1094#1077#1085#1077'  '#1088#1072#1089#1093'. '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1074#1090'.'
        DataBinding.FieldName = 'Branch2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1087#1086' '#1094#1077#1085#1077' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1074#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Branch3: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1077#1084'. '#1087#1086' '#1094#1077#1085#1077'  '#1088#1072#1089#1093'. '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1089#1088'.'
        DataBinding.FieldName = 'Branch3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1087#1086' '#1094#1077#1085#1077' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1089#1088'.'
        Options.Editing = False
        Width = 95
      end
      object Branch4: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1077#1084'. '#1087#1086' '#1094#1077#1085#1077'  '#1088#1072#1089#1093'. '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1095#1090'.'
        DataBinding.FieldName = 'Branch4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1087#1086' '#1094#1077#1085#1077' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1095#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Branch5: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1077#1084'. '#1087#1086' '#1094#1077#1085#1077'  '#1088#1072#1089#1093'. '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1087#1090'.'
        DataBinding.FieldName = 'Branch5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1087#1086' '#1094#1077#1085#1077' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1087#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Branch6: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1077#1084'. '#1087#1086' '#1094#1077#1085#1077'  '#1088#1072#1089#1093'. '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1089#1073'.'
        DataBinding.FieldName = 'Branch6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1087#1086' '#1094#1077#1085#1077' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1089#1073'.'
        Options.Editing = False
        Width = 95
      end
      object Branch7: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1077#1084'. '#1087#1086' '#1094#1077#1085#1077'  '#1088#1072#1089#1093'. '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1074#1089'.'
        DataBinding.FieldName = 'Branch7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1087#1086' '#1094#1077#1085#1077' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1092#1080#1083#1080#1072#1083' '#1079#1072' '#1074#1089'.'
        Options.Editing = False
        Width = 95
      end
      object Order1: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1079#1072' '#1087#1085'.'
        DataBinding.FieldName = 'Order1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1087#1085'.'
        Options.Editing = False
        Width = 95
      end
      object Order2: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1079#1072' '#1074#1090'.'
        DataBinding.FieldName = 'Order2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1074#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Order3: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1079#1072' '#1089#1088'.'
        DataBinding.FieldName = 'Order3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1089#1088'.'
        Options.Editing = False
        Width = 95
      end
      object Order4: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1079#1072' '#1095#1090'.'
        DataBinding.FieldName = 'Order4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1095#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Order5: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1079#1072' '#1087#1090'.'
        DataBinding.FieldName = 'Order5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1087#1090'.'
        Options.Editing = False
        Width = 95
      end
      object Order6: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1079#1072' '#1089#1073'.'
        DataBinding.FieldName = 'Order6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1089#1073'.'
        Options.Editing = False
        Width = 95
      end
      object Order7: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1079#1072' '#1074#1089'.'
        DataBinding.FieldName = 'Order7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1073#1077#1079' '#1040#1082#1094#1080#1080#1081' '#1079#1072' '#1074#1089'.'
        Options.Editing = False
        Width = 95
      end
      object OrderPromo1: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1040#1082#1094#1080#1103' '#1079#1072' '#1087#1085'.'
        DataBinding.FieldName = 'OrderPromo1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1087#1085'.'
        Options.Editing = False
        Width = 95
      end
      object OrderPromo2: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1040#1082#1094#1080#1103' '#1079#1072' '#1074#1090'.'
        DataBinding.FieldName = 'OrderPromo2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1074#1090'.'
        Options.Editing = False
        Width = 95
      end
      object OrderPromo3: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1040#1082#1094#1080#1103' '#1079#1072' '#1089#1088'.'
        DataBinding.FieldName = 'OrderPromo3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1089#1088'.'
        Options.Editing = False
        Width = 95
      end
      object OrderPromo4: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1040#1082#1094#1080#1103' '#1079#1072' '#1095#1090'.'
        DataBinding.FieldName = 'OrderPromo4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1095#1090'.'
        Options.Editing = False
        Width = 95
      end
      object OrderPromo5: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1040#1082#1094#1080#1103' '#1079#1072' '#1087#1090'.'
        DataBinding.FieldName = 'OrderPromo5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1087#1090'.'
        Options.Editing = False
        Width = 95
      end
      object OrderPromo6: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1040#1082#1094#1080#1103' '#1079#1072' '#1089#1073'.'
        DataBinding.FieldName = 'OrderPromo6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1089#1073'.'
        Options.Editing = False
        Width = 95
      end
      object OrderPromo7: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1040#1082#1094#1080#1103' '#1079#1072' '#1074#1089'.'
        DataBinding.FieldName = 'OrderPromo7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080' '#1079#1072' '#1074#1089'.'
        Options.Editing = False
        Width = 95
      end
      object OrderBranch1: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1060#1080#1083#1080#1072#1083' '#1079#1072' '#1087#1085'.'
        DataBinding.FieldName = 'OrderBranch1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1060#1048#1051#1048#1040#1051' '#1079#1072' '#1087#1085'.'
        Options.Editing = False
        Width = 95
      end
      object OrderBranch2: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1060#1080#1083#1080#1072#1083' '#1079#1072' '#1074#1090'.'
        DataBinding.FieldName = 'OrderBranch2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1060#1048#1051#1048#1040#1051' '#1079#1072' '#1074#1090'.'
        Options.Editing = False
        Width = 95
      end
      object OrderBranch3: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1060#1080#1083#1080#1072#1083' '#1079#1072' '#1089#1088'.'
        DataBinding.FieldName = 'OrderBranch3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1060#1048#1051#1048#1040#1051' '#1079#1072' '#1089#1088'.'
        Options.Editing = False
        Width = 95
      end
      object OrderBranch4: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1060#1080#1083#1080#1072#1083' '#1079#1072' '#1095#1090'.'
        DataBinding.FieldName = 'OrderBranch4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1060#1048#1051#1048#1040#1051' '#1079#1072' '#1095#1090'.'
        Options.Editing = False
        Width = 95
      end
      object OrderBranch5: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1060#1080#1083#1080#1072#1083' '#1079#1072' '#1087#1090'.'
        DataBinding.FieldName = 'OrderBranch5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1060#1048#1051#1048#1040#1051' '#1079#1072' '#1087#1090'.'
        Options.Editing = False
        Width = 95
      end
      object OrderBranch6: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1060#1080#1083#1080#1072#1083' '#1079#1072' '#1089#1073'.'
        DataBinding.FieldName = 'OrderBranch6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1060#1048#1051#1048#1040#1051' '#1079#1072' '#1089#1073'.'
        Options.Editing = False
        Width = 95
      end
      object OrderBranch7: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1086#1082' '#1060#1080#1083#1080#1072#1083' '#1079#1072' '#1074#1089'.'
        DataBinding.FieldName = 'OrderBranch7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1072#1093' '#1090#1086#1083#1100#1082#1086' '#1060#1048#1051#1048#1040#1051' '#1079#1072' '#1074#1089'.'
        Options.Editing = False
        Width = 95
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 1042
    Height = 57
    Align = alTop
    TabOrder = 2
    object cxLabel1: TcxLabel
      Left = 5
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072
    end
    object deStart: TcxDateEdit
      Left = 5
      Top = 23
      EditValue = 43040d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 86
    end
    object cxLabel2: TcxLabel
      Left = 102
      Top = 6
      Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072
    end
    object deEnd: TcxDateEdit
      Left = 102
      Top = 23
      EditValue = 43040d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 84
    end
    object cxLabel3: TcxLabel
      Left = 197
      Top = 6
      Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088#1077#1082#1090'.'
    end
    object deUpdate: TcxDateEdit
      Left = 197
      Top = 23
      EditValue = 43040d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 85
    end
    object cxLabel9: TcxLabel
      Left = 291
      Top = 6
      Caption = #1050#1086#1083'-'#1074#1086' '#1085#1077#1076'. '#1074' c'#1090#1072#1090'.'
    end
    object ceWeek: TcxCurrencyEdit
      Left = 291
      Top = 24
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 104
    end
  end
  object cxLabel4: TcxLabel
    Left = 403
    Top = 6
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
  end
  object edUpdateName: TcxButtonEdit
    Left = 403
    Top = 24
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 270
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 24
    Top = 216
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 160
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
    Left = 288
    Top = 104
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
    Left = 168
    Top = 104
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate'
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
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 0
      ShortCut = 45
    end
    object bbEdit: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbErased: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbUpdateIsOfficial: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1092#1080#1094#1080#1072#1083#1100#1085#1086' '#1044#1072'/'#1053#1077#1090'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1092#1080#1094#1080#1072#1083#1100#1085#1086' '#1044#1072'/'#1053#1077#1090'"'
      Visible = ivAlways
      ImageIndex = 52
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdateParams: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1085#1086#1088#1084' '#1072#1074#1090#1086
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1085#1086#1088#1084' '#1072#1074#1090#1086
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbInsertUpdate: TdxBarButton
      Action = macInsertUpdate
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_GoodsReportSaleInf
      StoredProcList = <
        item
          StoredProc = spGet_GoodsReportSaleInf
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ProtocolOpenForm: TdsdOpenForm
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
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountFuel'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'AmountFuel'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Reparation'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Reparation'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'LimitMoney'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'LimitMoney'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'LimitDistance'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'LimitDistance'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actInsertUpdate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actInsertUpdate'
      ImageIndex = 27
    end
    object macInsertUpdate: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate
        end
        item
          Action = actRefresh
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 27
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsReportSale'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 512
    Top = 272
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 160
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 208
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 264
    Top = 272
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42370d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 224
  end
  object GuidesUpdate: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUpdateName
    Key = '0'
    FormNameParam.Value = 'TMemberPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 506
    Top = 65534
  end
  object spGet_GoodsReportSaleInf: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsReportSaleInf'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'StartDate'
        Value = 43040d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 43040d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = 43040d
        Component = deUpdate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Week'
        Value = 0.000000000000000000
        Component = ceWeek
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateId'
        Value = '0'
        Component = GuidesUpdate
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = ''
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 184
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsReportSale'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 656
    Top = 264
  end
end
