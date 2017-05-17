object Report_MovementPriceListForm: TReport_MovementPriceListForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1088#1072#1081#1089#1072#1084
  ClientHeight = 414
  ClientWidth = 954
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
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 954
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edDateStart: TcxDateEdit
      Left = 7
      Top = 20
      EditValue = 42705d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 89
    end
    object cxLabel2: TcxLabel
      Left = 7
      Top = 2
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
    object edJuridical1: TcxButtonEdit
      Left = 114
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 194
    end
    object cxLabel4: TcxLabel
      Left = 114
      Top = 2
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 1'
    end
    object cxLabel3: TcxLabel
      Left = 523
      Top = 2
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 3'
    end
    object edJuridical3: TcxButtonEdit
      Left = 523
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 194
    end
  end
  object deEnd: TcxDateEdit
    Left = 7
    Top = 61
    EditValue = 42735d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel7: TcxLabel
    Left = 7
    Top = 43
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel1: TcxLabel
    Left = 319
    Top = 2
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 2'
  end
  object edJuridical2: TcxButtonEdit
    Left = 319
    Top = 20
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 194
  end
  object cxLabel5: TcxLabel
    Left = 114
    Top = 43
    Caption = #1044#1086#1075#1086#1074#1086#1088'  ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' 1)'
  end
  object edContract1: TcxButtonEdit
    Left = 114
    Top = 61
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 194
  end
  object cxLabel6: TcxLabel
    Left = 319
    Top = 43
    Caption = #1044#1086#1075#1086#1074#1086#1088'  ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' 2)'
  end
  object edContract2: TcxButtonEdit
    Left = 319
    Top = 61
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 194
  end
  object cxLabel8: TcxLabel
    Left = 523
    Top = 43
    Caption = #1044#1086#1075#1086#1074#1086#1088'  ('#1087#1086#1089#1090#1072#1074#1097#1080#1082' 3)'
  end
  object edContract3: TcxButtonEdit
    Left = 523
    Top = 61
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 194
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 115
    Width = 954
    Height = 299
    Align = alClient
    TabOrder = 15
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
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
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = clGoodsName
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
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clGoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object clGoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object clGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object clCommonCode: TcxGridDBColumn
        Caption = #1082#1086#1076' '#1052#1086#1088#1080#1086#1085
        DataBinding.FieldName = 'CommonCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clGoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object cPrice_1_1: TcxGridDBColumn
        Caption = '1 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_1: TcxGridDBColumn
        Caption = '1 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_1: TcxGridDBColumn
        Caption = '1 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_2: TcxGridDBColumn
        Caption = '2 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_2: TcxGridDBColumn
        Caption = '2 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_2: TcxGridDBColumn
        Caption = '2 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_3: TcxGridDBColumn
        Caption = '3 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_3: TcxGridDBColumn
        Caption = '3 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_3: TcxGridDBColumn
        Caption = '3 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_4: TcxGridDBColumn
        Caption = '4 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_4: TcxGridDBColumn
        Caption = '4 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_4: TcxGridDBColumn
        Caption = '4 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_5: TcxGridDBColumn
        Caption = '5 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_5: TcxGridDBColumn
        Caption = '5 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_5: TcxGridDBColumn
        Caption = '5 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_6: TcxGridDBColumn
        Caption = '6 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_6: TcxGridDBColumn
        Caption = '6 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_6: TcxGridDBColumn
        Caption = '6 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_7: TcxGridDBColumn
        Caption = '7 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_7: TcxGridDBColumn
        Caption = '7 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_7: TcxGridDBColumn
        Caption = '7 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_8: TcxGridDBColumn
        Caption = '8 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_8'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_8: TcxGridDBColumn
        Caption = '8 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_8'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_8: TcxGridDBColumn
        Caption = '8 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_8'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_9: TcxGridDBColumn
        Caption = '9 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_9'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_9: TcxGridDBColumn
        Caption = '9 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_9'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_9: TcxGridDBColumn
        Caption = '9 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_9'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_10: TcxGridDBColumn
        Caption = '10 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_10'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_10: TcxGridDBColumn
        Caption = '10 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_10'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_10: TcxGridDBColumn
        Caption = '10 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_10'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_11: TcxGridDBColumn
        Caption = '11 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_11'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_11: TcxGridDBColumn
        Caption = '11 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_11'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_11: TcxGridDBColumn
        Caption = '11 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_11'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_12: TcxGridDBColumn
        Caption = '12 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_12'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_12: TcxGridDBColumn
        Caption = '12 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_12'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_12: TcxGridDBColumn
        Caption = '12 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_12'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_13: TcxGridDBColumn
        Caption = '13 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_13'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_13: TcxGridDBColumn
        Caption = '13 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_13'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_13: TcxGridDBColumn
        Caption = '13 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_13'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_14: TcxGridDBColumn
        Caption = '14 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_14'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_14: TcxGridDBColumn
        Caption = '14 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_14'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_14: TcxGridDBColumn
        Caption = '14 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_14'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_15: TcxGridDBColumn
        Caption = '15 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_15'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_15: TcxGridDBColumn
        Caption = '15 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_15'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_15: TcxGridDBColumn
        Caption = '15 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_15'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_16: TcxGridDBColumn
        Caption = '16 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_16'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_16: TcxGridDBColumn
        Caption = '16 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_16'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_16: TcxGridDBColumn
        Caption = '16 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_16'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_17: TcxGridDBColumn
        Caption = '17 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_17'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_17: TcxGridDBColumn
        Caption = '17 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_17'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_17: TcxGridDBColumn
        Caption = '17 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_17'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_18: TcxGridDBColumn
        Caption = '18 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_18'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_18: TcxGridDBColumn
        Caption = '18 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_18'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_18: TcxGridDBColumn
        Caption = '18 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_18'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_19: TcxGridDBColumn
        Caption = '19 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_19'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_19: TcxGridDBColumn
        Caption = '19 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_19'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_19: TcxGridDBColumn
        Caption = '19 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_19'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_20: TcxGridDBColumn
        Caption = '20 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_20'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_20: TcxGridDBColumn
        Caption = '20 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_20'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_20: TcxGridDBColumn
        Caption = '20 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_20'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_21: TcxGridDBColumn
        Caption = '21 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_21'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_21: TcxGridDBColumn
        Caption = '21 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_21'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_21: TcxGridDBColumn
        Caption = '21 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_21'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_22: TcxGridDBColumn
        Caption = '22 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_22'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_22: TcxGridDBColumn
        Caption = '22 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_22'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_22: TcxGridDBColumn
        Caption = '22 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_22'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_23: TcxGridDBColumn
        Caption = '23 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_23'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_23: TcxGridDBColumn
        Caption = '23 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_23'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_23: TcxGridDBColumn
        Caption = '23 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_23'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_24: TcxGridDBColumn
        Caption = '24 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_24'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_24: TcxGridDBColumn
        Caption = '24 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_24'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_24: TcxGridDBColumn
        Caption = '24 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_24'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_25: TcxGridDBColumn
        Caption = '25 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_25'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_25: TcxGridDBColumn
        Caption = '25 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_25'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_25: TcxGridDBColumn
        Caption = '25 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_25'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_26: TcxGridDBColumn
        Caption = '26 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_26'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_26: TcxGridDBColumn
        Caption = '26 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_26'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_26: TcxGridDBColumn
        Caption = '26 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_26'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_27: TcxGridDBColumn
        Caption = '27 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_27'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_27: TcxGridDBColumn
        Caption = '27 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_27'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_27: TcxGridDBColumn
        Caption = '27 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_27'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_28: TcxGridDBColumn
        Caption = '28 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_28'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_28: TcxGridDBColumn
        Caption = '28 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_28'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_28: TcxGridDBColumn
        Caption = '28 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_28'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_29: TcxGridDBColumn
        Caption = '29 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_29'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_29: TcxGridDBColumn
        Caption = '29 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_29'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_29: TcxGridDBColumn
        Caption = '29 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_29'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_30: TcxGridDBColumn
        Caption = '30 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_30'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_30: TcxGridDBColumn
        Caption = '30 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_30'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_30: TcxGridDBColumn
        Caption = '30 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_30'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object cPrice_1_31: TcxGridDBColumn
        Caption = '31 ('#1087#1086#1089#1090'.1)'
        DataBinding.FieldName = 'Price_1_31'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_2_31: TcxGridDBColumn
        Caption = '31 ('#1087#1086#1089#1090'.2)'
        DataBinding.FieldName = 'Price_2_31'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object cPrice_3_31: TcxGridDBColumn
        Caption = '31 ('#1087#1086#1089#1090'.3)'
        DataBinding.FieldName = 'Price_3_31'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object Color1: TcxGridDBColumn
        DataBinding.FieldName = 'Color1'
        Visible = False
        VisibleForCustomization = False
        Width = 60
      end
      object Color2: TcxGridDBColumn
        DataBinding.FieldName = 'Color2'
        Visible = False
        VisibleForCustomization = False
        Width = 40
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'JuridicalId_1'
        Value = Null
        Component = GuidesJuridical1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_1'
        Value = Null
        Component = GuidesJuridical1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_2'
        Value = Null
        Component = GuidesJuridical2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_2'
        Value = Null
        Component = GuidesJuridical2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_3'
        Value = Null
        Component = GuidesJuridical3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_3'
        Value = Null
        Component = GuidesJuridical3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_1'
        Value = Null
        Component = GuidesContract1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_1'
        Value = Null
        Component = GuidesContract1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_2'
        Value = Null
        Component = GuidesContract2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_2'
        Value = Null
        Component = GuidesContract2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId_3'
        Value = Null
        Component = GuidesContract3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName_3'
        Value = Null
        Component = GuidesContract3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 182
    Top = 159
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_PriceList'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 0d
        Component = edDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId_1'
        Value = ''
        Component = GuidesJuridical1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId_2'
        Value = ''
        Component = GuidesJuridical2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId_3'
        Value = ''
        Component = GuidesJuridical3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId_1'
        Value = ''
        Component = GuidesContract1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId_2'
        Value = ''
        Component = GuidesContract2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId_3'
        Value = ''
        Component = GuidesContract3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
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
    Left = 46
    Top = 279
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
      FloatLeft = 409
      FloatTop = 390
      FloatClientWidth = 51
      FloatClientHeight = 93
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
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
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = edDateStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesJuridical1
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesJuridical2
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesJuridical3
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesContract1
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesContract2
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesContract3
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 41
    Top = 192
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 131
    Top = 279
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
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
          Component = edDateStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
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
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_MovementPriceList_DialogForm'
      FormNameParam.Value = 'TReport_MovementPriceList_DialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = edDateStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_1'
          Value = ''
          Component = GuidesJuridical1
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_1'
          Value = ''
          Component = GuidesJuridical1
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_2'
          Value = ''
          Component = GuidesJuridical2
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_2'
          Value = ''
          Component = GuidesJuridical2
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_3'
          Value = ''
          Component = GuidesJuridical3
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_3'
          Value = ''
          Component = GuidesJuridical3
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_1'
          Value = Null
          Component = GuidesContract1
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_1'
          Value = Null
          Component = GuidesContract1
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_2'
          Value = Null
          Component = GuidesContract2
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_2'
          Value = Null
          Component = GuidesContract2
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_3'
          Value = Null
          Component = GuidesContract3
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_3'
          Value = Null
          Component = GuidesContract3
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 478
    Top = 231
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 400
    Top = 247
  end
  object GuidesJuridical1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical1
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 240
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 632
    Top = 216
  end
  object GuidesJuridical2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical2
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 448
    Top = 65528
  end
  object GuidesJuridical3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical3
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical3
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 648
    Top = 8
  end
  object GuidesContract1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract1
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 48
  end
  object GuidesContract3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract3
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract3
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 664
    Top = 48
  end
  object GuidesContract2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract2
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 456
    Top = 48
  end
  object ChildDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = cPrice_1_1
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_1
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_1
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_3
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_3
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_3
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_5
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_5
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_5
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_7
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_7
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_7
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_9
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_9
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_9
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_11
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_11
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_11
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_13
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_13
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_13
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_15
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_15
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_15
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_17
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_17
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_17
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_19
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_19
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_19
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_21
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_21
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_21
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_23
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_23
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_23
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_25
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_25
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_25
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_27
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_27
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_27
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_29
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_29
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_29
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_1_31
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_2_31
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end
      item
        ColorColumn = cPrice_3_31
        BackGroundValueColumn = Color1
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 744
    Top = 192
  end
end
