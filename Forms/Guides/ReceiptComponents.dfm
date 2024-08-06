object ReceiptComponentsForm: TReceiptComponentsForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1057#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099'>'
  ClientHeight = 406
  ClientWidth = 1152
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 1152
    Height = 375
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
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
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090' ('#1087#1086#1083#1100#1079'.)'
        DataBinding.FieldName = 'Code'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 39
      end
      object ReceiptCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
        DataBinding.FieldName = 'ReceiptCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
        DataBinding.FieldName = 'Name'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 173
      end
      object StartDate: TcxGridDBColumn
        Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072
        DataBinding.FieldName = 'StartDate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object EndDate: TcxGridDBColumn
        Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072
        DataBinding.FieldName = 'EndDate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077', '#1087#1088#1080#1093#1086#1076')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GoodsGroupAnalystName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
        DataBinding.FieldName = 'GoodsGroupAnalystName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsTagName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object TradeMarkName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'TradeMarkName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 67
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'. ('#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'GoodsKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsKindCompleteName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055' ('#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'GoodsKindCompleteName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object IsMain: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085'.'
        DataBinding.FieldName = 'isMain'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object TaxExit: TcxGridDBColumn
        Caption = '% '#1074#1099#1093'.'
        DataBinding.FieldName = 'TaxExit'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object TaxLoss: TcxGridDBColumn
        Caption = '% '#1087#1086#1090#1077#1088#1100
        DataBinding.FieldName = 'TaxLoss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object ValueWeight: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1077#1089', '#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'ValueWeight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Value: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'Value'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
      end
      object TotalWeightMain: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1089#1099#1088#1100#1103' (100 '#1082#1075', '#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'TotalWeightMain'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object TotalWeight: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' ('#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'TotalWeight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object ReceiptKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
        DataBinding.FieldName = 'ReceiptKindName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 77
      end
      object Code_Parent_Receipt: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1087#1086#1080#1089#1082', '#1087#1086#1083#1100#1079'.)'
        DataBinding.FieldName = 'Code_Parent_Receipt'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object ReceiptCode_Parent_Receipt: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'ReceiptCode_Parent_Receipt'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Name_Parent_Receipt: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'Name_Parent_Receipt'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isMain_Parent_Receipt: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085'. ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'isMain_Parent_Receipt'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object GoodsCode_Parent_Receipt: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'GoodsCode_Parent_Receipt'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsName_Parent_Receipt: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'GoodsName_Parent_Receipt'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object MeasureName_Parent_Receipt: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'. ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'MeasureName_Parent'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsKindName_Parent_Receipt: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'GoodsKindName_Parent_Receipt'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object ReceiptCode_Parent_old: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1075#1083'. '#1088#1077#1094#1077#1087#1090'. ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'ReceiptCode_Parent_old'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Code_Parent_old: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1075#1083'. '#1088#1077#1094#1077#1087#1090'. ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'Code_Parent_old'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Name_Parent_old: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085#1072#1103' '#1088#1077#1094#1077#1087#1090#1091#1088#1072' ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'Name_Parent_old'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object GoodsCode_Parent_old: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'GoodsCode_Parent_old'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsName_Parent_old: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'GoodsName_Parent_old'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsKindName_Parent_old: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'GoodsKindName_Parent_old'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object EndDate_Parent_old: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086' ('#1080#1089#1090#1086#1088#1080#1103')'
        DataBinding.FieldName = 'EndDate_Parent_old'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085' ('#1087#1088#1080#1093'.)'
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object GroupNumber_Child: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#8470' ('#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'GroupNumber_Child'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsCode_Child: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'GoodsCode_Child'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.;-0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsName_Child: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1088#1072#1089#1093#1086#1076')'
        DataBinding.FieldName = 'GoodsName_Child'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = Goods_ObjectChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 155
      end
      object MeasureName_Child: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'. ('#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'MeasureName_Child'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 52
      end
      object GoodsKindName_Child: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'GoodsKindName_Child'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ReceiptChildChoiceForm
            Caption = 'GoodsKindChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 150
      end
      object ValueWeight_calc_Child: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1077#1089', '#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'ValueWeight_calc_Child'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Value_Child: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'Value_Child'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object isTaxExit_Child: TcxGridDBColumn
        Caption = #1047#1072#1074#1080#1089#1080#1090' '#1086#1090' % '#1074#1099#1093'.'
        DataBinding.FieldName = 'isTaxExit_Child'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isWeightMain_Child: TcxGridDBColumn
        Caption = #1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)'
        DataBinding.FieldName = 'isWeightMain_Child'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object ReceiptLevelName: TcxGridDBColumn
        Caption = #1069#1090#1072#1087#1099' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
        DataBinding.FieldName = 'ReceiptLevelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 138
      end
      object InsertDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076', '#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'InsertDate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 48
      end
      object InsertName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076', '#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'InsertName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object UpdateDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088', '#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'UpdateDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 88
      end
      object UpdateName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088', '#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'UpdateName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 113
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 200
      end
      object isErased_Child: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085' ('#1088#1072#1089#1093'.)'
        DataBinding.FieldName = 'isErased_Child'
        Visible = False
        Width = 60
      end
      object Color_calc: TcxGridDBColumn
        DataBinding.FieldName = 'Color_calc'
        Visible = False
        VisibleForCustomization = False
        Width = 55
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxBottomSplitter: TcxSplitter
    Left = 0
    Top = 401
    Width = 1152
    Height = 5
    AlignSplitter = salBottom
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 56
    Top = 96
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    MasterFields = 'Id'
    Params = <>
    Left = 64
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
    Left = 296
    Top = 112
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
    Left = 152
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbUpdateTaxExit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbUpdateWeightMain'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbProtocolChild'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '    '
      Category = 0
      Hint = '    '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbInsertRecCCK: TdxBarButton
      Action = InsertRecordCCK
      Category = 0
    end
    object bbIsPeriod: TdxBarControlContainerItem
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Category = 0
      Hint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Visible = ivAlways
    end
    object bbStartDate: TdxBarControlContainerItem
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1077#1088#1080#1086#1076#1072
      Category = 0
      Hint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1077#1088#1080#1086#1076#1072
      Visible = ivAlways
    end
    object bbEnd: TdxBarControlContainerItem
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
      Category = 0
      Hint = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
      Visible = ivAlways
    end
    object bbEndDate: TdxBarControlContainerItem
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1087#1077#1088#1080#1086#1076#1072
      Category = 0
      Hint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1087#1077#1088#1080#1086#1076#1072
      Visible = ivAlways
    end
    object bbIsEndDate: TdxBarControlContainerItem
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1086' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
      Category = 0
      Hint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1086' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
      Visible = ivAlways
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintDetail: TdxBarButton
      Action = actPrintDetail
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbProtocolChild: TdxBarButton
      Action = ProtocolOpenFormChild
      Category = 0
    end
    object bbUpdateTaxExit: TdxBarButton
      Action = actUpdateTaxExit
      Category = 0
    end
    object bbUpdateWeightMain: TdxBarButton
      Action = actUpdateWeightMain
      Category = 0
    end
    object bbSetErasedReceiptChild: TdxBarButton
      Action = dsdSetErasedReceiptChild
      Category = 0
    end
    object bb: TdxBarButton
      Action = dsdSetUnErasedReceiptChild
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 224
    Top = 136
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
      FormName = 'TReceiptEditForm'
      FormNameParam.Value = 'TReceiptEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InMaskId'
          Value = 'True'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TReceiptEditForm'
      FormNameParam.Value = 'TReceiptEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMaskId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
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
      FormName = 'TReceiptEditForm'
      FormNameParam.Value = 'TReceiptEditForm'
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
          Name = 'InMaskId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedReceipt
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedReceipt
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedReceipt
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedReceipt
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
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
    object ReceiptChildChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ReceiptChildForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_Child'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_Child'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
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
    object Goods_ObjectChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectChoiceForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId_Child'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName_Child'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object InsertRecordCCK: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Action = Goods_ObjectChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099'>'
      ImageIndex = 0
    end
    object actReceiptChild: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateReceiptChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateReceiptChild
        end>
      Caption = 'actUpdateDataSetCCK'
      DataSource = MasterDS
    end
    object ProtocolOpenFormChild: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1057#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1057#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
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
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1056#1077#1094#1077#1087#1090#1091#1088#1099'>'
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
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actUpdateWeightMain: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateWeightMain
      StoredProcList = <
        item
          StoredProc = spUpdateWeightMain
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)  '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)  '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 58
    end
    object actPrint: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spPrintReceipt
      StoredProcList = <
        item
          StoredProc = spPrintReceipt
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'Master'
          IndexFieldNames = 'ReceiptCode;ReceiptId;GroupNumber;InfoMoneyName;GoodsName'
        end>
      Params = <>
      ReportName = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintDetail: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spPrintReceiptChildDetail
      StoredProcList = <
        item
          StoredProc = spPrintReceiptChildDetail
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'Master'
        end
        item
          UserName = 'Client'
          IndexFieldNames = 'GroupNumber;GoodsName'
        end>
      Params = <>
      ReportName = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateTaxExit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateTaxExit
      StoredProcList = <
        item
          StoredProc = spUpdateTaxExit
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1047#1072#1074#1080#1089#1080#1090' '#1086#1090' % '#1074#1099#1093'.  '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1047#1072#1074#1080#1089#1080#1090' '#1086#1090' % '#1074#1099#1093'.  '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 52
    end
    object dsdSetErasedReceiptChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedReceiptChild
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedReceiptChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
    end
    object dsdSetUnErasedReceiptChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedReceiptChild
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedReceiptChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptComponents'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inReceiptId'
        Value = 0
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
      end>
    PackSize = 1
    Left = 392
    Top = 120
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 104
    Top = 208
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased_Child'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actUpdate
      end
      item
        Action = dsdChoiceGuides
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
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
        ColorColumn = GroupNumber_Child
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode_Child
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName_Child
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MeasureName_Child
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsKindName_Child
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = ValueWeight_calc_Child
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Value_Child
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isTaxExit_Child
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isWeightMain_Child
        ValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = InfoMoneyName
        ValueColumn = Color_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <
      item
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 272
    Top = 184
  end
  object spInsertUpdateReceiptChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReceiptChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptChildId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Value_Child'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outValueWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ValueWeight_Child'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsWeightMain'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isWeightMain_Child'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxExit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTaxExit_Child'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartDate_Child'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EndDate_Child'
        DataType = ftDateTime
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
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId_Child'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_Child'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 728
    Top = 192
  end
  object PeriodChoice: TPeriodChoice
    Left = 480
    Top = 120
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 480
    Top = 168
  end
  object spPrintReceiptChildDetail: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PrintReceiptChildDetail'
    DataSets = <
      item
      end>
    Params = <
      item
        Name = 'ReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1080
    Top = 120
  end
  object PrintMasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 420
    Top = 273
  end
  object spPrintReceipt: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Receipt_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    Params = <
      item
        Name = 'inReceiptId'
        Value = '0'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1080
    Top = 169
  end
  object spUpdateTaxExit: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_isBoolean'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'ReceiptChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioParam'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isTaxExit_Child'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesc'
        Value = 'zc_ObjectBoolean_ReceiptChild_TaxExit'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 642
    Top = 125
  end
  object spUpdateWeightMain: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_isBoolean'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioParam'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isWeightMain_Child'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesc'
        Value = 'zc_ObjectBoolean_ReceiptChild_WeightMain'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 786
    Top = 133
  end
  object spErasedUnErasedReceiptChild: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ReceiptChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 120
  end
  object spErasedUnErasedReceipt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Receipt'
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
      end>
    PackSize = 1
    Left = 112
    Top = 272
  end
  object spUpdateReal: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_isBoolean'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioParam'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReal_Child'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesc'
        Value = 'zc_ObjectBoolean_ReceiptChild_Real'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 610
    Top = 189
  end
end
