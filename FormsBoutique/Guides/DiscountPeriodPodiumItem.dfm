object DiscountPeriodPodiumItemForm: TDiscountPeriodPodiumItemForm
  Left = 0
  Top = 0
  Caption = #1057#1077#1079#1086#1085#1085#1099#1077' '#1089#1082#1080#1076#1082#1080' - '#1055#1088#1086#1089#1084#1086#1090#1088' / '#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1086#1089#1083#1077#1076#1085#1080#1093' '#1089#1082#1080#1076#1086#1082
  ClientHeight = 398
  ClientWidth = 963
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 91
    Width = 963
    Height = 307
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
          Format = ',0.####'
          Kind = skSum
          Column = Remains
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountDebt
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = RemainsAll
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Remains
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountDebt
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = RemainsAll
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
      object OperDate_Partion: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076
        DataBinding.FieldName = 'OperDate_Partion'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Options.Editing = False
        Width = 70
      end
      object InvNumber_Partion: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
        DataBinding.FieldName = 'InvNumber_Partion'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' - '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Options.Editing = False
        Width = 55
      end
      object BrandName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'BrandName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 95
      end
      object PeriodName: TcxGridDBColumn
        Caption = #1057#1077#1079#1086#1085
        DataBinding.FieldName = 'PeriodName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PeriodYear: TcxGridDBColumn
        Caption = #1043#1086#1076
        DataBinding.FieldName = 'PeriodYear'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object PartnerName: TcxGridDBColumn
        Caption = #1055#1086'c'#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'PartnerName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'GroupNameFull'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 100
      end
      object LabelName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'LabelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1040#1088#1090#1080#1082#1091#1083
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsSizeName: TcxGridDBColumn
        Caption = #1056#1072#1079#1084#1077#1088
        DataBinding.FieldName = 'GoodsSizeName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object StartDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1089
        DataBinding.FieldName = 'StartDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object EndDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1086
        DataBinding.FieldName = 'EndDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object ValueDiscount: TcxGridDBColumn
        Caption = '% '#1089#1082'.'
        DataBinding.FieldName = 'ValueDiscount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '% '#1057#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080
        Width = 70
      end
      object ValueNextDiscount: TcxGridDBColumn
        Caption = '% '#1089#1082'. 2'
        DataBinding.FieldName = 'ValueNextDiscount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '% '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1057#1077#1079#1086#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080
        Width = 70
      end
      object RemainsAll: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1080#1090#1086#1075#1086
        DataBinding.FieldName = 'RemainsAll'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082' '#1082#1086#1083'-'#1074#1086' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091' '#1089' '#1091#1095#1077#1090#1086#1084' '#1076#1086#1083#1075#1072
        Options.Editing = False
        Width = 70
      end
      object Remains: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1074' '#1084#1072#1075'.'
        DataBinding.FieldName = 'Remains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1086#1089#1090#1072#1090#1086#1082' '#1074' '#1084#1072#1075#1072#1079#1080#1085#1077
        Options.Editing = False
        Width = 70
      end
      object AmountDebt: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1076#1086#1083#1075
        DataBinding.FieldName = 'AmountDebt'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' - '#1076#1086#1083#1075#1080' '#1087#1086' '#1084#1072#1075#1072#1079#1080#1085#1091
        Options.Editing = False
        Width = 60
      end
      object CurrencyName_pl: TcxGridDBColumn
        Caption = #1042#1072#1083'. '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'CurrencyName_pl'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1072#1083#1102#1090#1072' '#1087#1088#1072#1081#1089#1072
        Options.Editing = False
        Width = 40
      end
      object OperPriceList: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089
        DataBinding.FieldName = 'OperPriceList'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
        Options.Editing = False
        Width = 70
      end
      object OperPriceList_disc: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1089' '#1091#1095'. '#1089#1082'.'
        DataBinding.FieldName = 'OperPriceList_disc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080
        Options.Editing = False
        Width = 70
      end
      object OperPriceList_grn: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1043#1056#1053
        DataBinding.FieldName = 'OperPriceList_grn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091', '#1043#1056#1053
        Options.Editing = False
        Width = 70
      end
      object OperPriceList_disc_grn: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1089' '#1091#1095'. '#1089#1082'. '#1043#1056#1053
        DataBinding.FieldName = 'OperPriceList_disc_grn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1043#1056#1053
        Options.Editing = False
        Width = 70
      end
      object CurrencyName: TcxGridDBColumn
        Caption = #1042#1072#1083'. '#1074#1093'.'
        DataBinding.FieldName = 'CurrencyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object OperPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1074#1093'.'
        DataBinding.FieldName = 'OperPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 65
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
      end
      object CompositionName: TcxGridDBColumn
        Caption = #1057#1086#1089#1090#1072#1074
        DataBinding.FieldName = 'CompositionName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsInfoName: TcxGridDBColumn
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsInfoName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object LineFabricaName: TcxGridDBColumn
        Caption = #1051#1080#1085#1080#1103
        DataBinding.FieldName = 'LineFabricaName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object FabrikaName: TcxGridDBColumn
        Caption = #1060#1072#1073#1088#1080#1082#1072
        DataBinding.FieldName = 'FabrikaName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 115
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 45
      end
      object UnitName_in: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
        DataBinding.FieldName = 'UnitName_in'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object UpdateDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
        DataBinding.FieldName = 'UpdateDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 48
      end
      object UpdateName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
        DataBinding.FieldName = 'UpdateName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InsertDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertDate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 48
      end
      object InsertName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object ObjectId: TcxGridDBColumn
        DataBinding.FieldName = 'ObjectId'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 20
      end
      object GoodsIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 20
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 26
    Width = 963
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object cxLabel1: TcxLabel
      Left = 4
      Top = 10
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 92
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Width = 202
    end
    object edShowDate: TcxDateEdit
      Left = 641
      Top = 9
      EditValue = 42856d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 82
    end
    object cxLabel2: TcxLabel
      Left = 529
      Top = 10
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1080#1076#1086#1082' '#1085#1072':'
    end
    object edPersent: TcxCurrencyEdit
      Left = 793
      Top = 36
      EditValue = '0'
      Properties.AssignedValues.MinValue = True
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.MaxLength = 4
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 31
    end
    object cxLabel5: TcxLabel
      Left = 4
      Top = 37
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
    end
    object edBrand: TcxButtonEdit
      Left = 92
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 202
    end
    object cxLabel6: TcxLabel
      Left = 306
      Top = 10
      Caption = #1057#1077#1079#1086#1085' :'
    end
    object edPeriod: TcxButtonEdit
      Left = 349
      Top = 9
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 165
    end
    object cxLabel7: TcxLabel
      Left = 301
      Top = 37
      Caption = #1043#1086#1076' '#1089' ...'
    end
    object cxLabel8: TcxLabel
      Left = 407
      Top = 37
      Caption = #1043#1086#1076' '#1087#1086' ...'
    end
    object edStartYear: TcxButtonEdit
      Left = 349
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 49
    end
    object edEndYear: TcxButtonEdit
      Left = 462
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 52
    end
    object cbSize: TcxCheckBox
      Left = 733
      Top = 9
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' '#1076#1077#1090#1072#1083#1100#1085#1086'('#1044#1072'/'#1053#1077#1090')'
      Caption = #1056#1072#1079#1084#1077#1088#1099' '#1076#1077#1090#1072#1083#1100#1085#1086
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
      Width = 131
    end
    object edPersentNext: TcxCurrencyEdit
      Left = 915
      Top = 36
      EditValue = '0'
      Properties.AssignedValues.MinValue = True
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.MaxLength = 4
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 31
    end
  end
  object cxLabel3: TcxLabel
    Left = 530
    Top = 63
    Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1082#1080#1076#1082#1080' '#1089':'
  end
  object edOperDate: TcxDateEdit
    Left = 641
    Top = 62
    EditValue = 42856d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 82
  end
  object cxLabel4: TcxLabel
    Left = 733
    Top = 63
    Caption = '% '#1089#1082#1080#1076#1082#1080':'
  end
  object cxLabel9: TcxLabel
    Left = 830
    Top = 63
    Caption = '% '#1076#1086#1087'. '#1089#1082#1080#1076#1082#1080':'
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = edOperDate
        Properties.Strings = (
          'Date')
      end
      item
        Component = edShowDate
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesUnit
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
      end
      item
        Component = GuidesStartYear
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesEndYear
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesBrand
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPeriod
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 400
    Top = 184
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
    Left = 224
    Top = 136
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
      FloatLeft = 416
      FloatTop = 259
      FloatClientWidth = 51
      FloatClientHeight = 59
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPriceListGoodsItem'
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
          ItemName = 'bbPriceListTaxDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAllNext'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
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
      NotDocking = [dsLeft]
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
    object bbToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '       '
      Category = 0
      Hint = '       '
      Visible = ivAlways
    end
    object bbPriceListGoodsItem: TdxBarButton
      Action = actDiscountPeriodGoods
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbPriceListTaxDialog: TdxBarButton
      Action = macUpdateAll
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
      ImageIndex = 3
      UnclickAfterDoing = False
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbUpdateAllNext: TdxBarButton
      Action = macUpdateAllNext
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 336
    Top = 160
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Current_Date
      StoredProcList = <
        item
          StoredProc = spGet_Current_Date
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
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actDiscountPeriodGoods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1089#1090#1086#1088#1080#1080
      ImageIndex = 28
      FormName = 'TDiscountPeriodGoodsPodiumItemForm'
      FormNameParam.Value = 'TDiscountPeriodGoodsPodiumItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = '0'
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
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
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1091#1089#1090#1099#1077' '#1089#1082#1080#1076#1082#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1087#1091#1089#1090#1099#1077' '#1089#1082#1080#1076#1082#1080
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
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
          Component = ClientDataSet
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_Print
      StoredProcList = <
        item
          StoredProc = spSelect_Print
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1088#1072#1081#1089#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1088#1072#1081#1089#1072
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'PriceListUnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowDate'
          Value = 42339d
          Component = edShowDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintObjectHistory_PriceListItem'
      ReportNameParam.Name = 'PrintObjectHistory_PriceListItem'
      ReportNameParam.Value = 'PrintObjectHistory_PriceListItem'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object spUpdatePersentNext: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateListNext
      StoredProcList = <
        item
          StoredProc = spInsertUpdateListNext
        end>
      Caption = #1044#1086#1087'. '#1057#1082#1080#1076#1082#1072
      Hint = #1044#1086#1087'. '#1057#1082#1080#1076#1082#1072
      ImageIndex = 27
    end
    object spUpdatePersent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateList
      StoredProcList = <
        item
          StoredProc = spInsertUpdateList
        end>
      Caption = #1057#1082#1080#1076#1082#1072
      Hint = #1057#1082#1080#1076#1082#1072
      ImageIndex = 74
    end
    object macUpdateAllNext: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPersentNext
        end
        item
          Action = macUpdatePersentNext
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1086#1087'. '#1089#1082#1080#1076#1082#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1086#1087'. '#1089#1082#1080#1076#1082#1091
      ImageIndex = 27
    end
    object macUpdateAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPersent
        end
        item
          Action = macUpdatePersent
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091
      ImageIndex = 74
    end
    object macUpdatePersentNext: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdatePersentNext
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1086#1087'. '#1089#1082#1080#1076#1082#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1086#1087'. '#1089#1082#1080#1076#1082#1091
      ImageIndex = 27
    end
    object macUpdatePersent: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdatePersent
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091
      ImageIndex = 74
    end
    object ExecuteDialogPersentNext: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' % '#1076#1086#1087'. '#1089#1082#1080#1076#1082#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' % '#1076#1086#1087'. '#1089#1082#1080#1076#1082#1080
      ImageIndex = 35
      FormName = 'TDiscountPersentDialogForm'
      FormNameParam.Value = 'TDiscountPersentDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ParamValue'
          Value = 0.000000000000000000
          Component = edPersentNext
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParamName'
          Value = '% '#1076#1086#1087'.'#1089#1082#1080#1076#1082#1080
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object ExecuteDialogPersent: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' % '#1089#1082#1080#1076#1082#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' % '#1089#1082#1080#1076#1082#1080
      ImageIndex = 35
      FormName = 'TDiscountPersentDialogForm'
      FormNameParam.Value = 'TDiscountPersentDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ParamValue'
          Value = ''
          Component = edPersent
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParamName'
          Value = '% '#1089#1082#1080#1076#1082#1080
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      ImageIndex = 35
      FormName = 'TDiscountPeriodItemDialogForm'
      FormNameParam.Value = 'TDiscountPeriodItemDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ShowDate'
          Value = 42736d
          Component = edShowDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandId'
          Value = ''
          Component = GuidesBrand
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = ''
          Component = GuidesBrand
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodId'
          Value = '0'
          Component = GuidesPeriod
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodName'
          Value = ''
          Component = GuidesPeriod
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYear'
          Value = '0'
          Component = GuidesStartYear
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYearText'
          Value = Null
          Component = GuidesStartYear
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = ''
          Component = GuidesEndYear
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYearText'
          Value = Null
          Component = GuidesEndYear
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSize'
          Value = Null
          Component = cbSize
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectHistory_DiscountPeriodItem'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodId'
        Value = Null
        Component = GuidesPeriod
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 41275d
        Component = edShowDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartYear'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndYear'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSize'
        Value = Null
        Component = cbSize
        DataType = ftBoolean
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
    Left = 144
    Top = 128
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <
      item
        Column = GoodsCode
        FindByFullValue = True
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <
      item
        Column = GoodsCode
      end
      item
        Column = ValueDiscount
      end>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 192
    Top = 256
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 296
    Top = 200
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = '0'
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
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
    Left = 208
    Top = 32
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
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
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
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
      end
      item
        Name = 'inValue'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ValueDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValueNext'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ValueNextDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLast'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 272
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesBrand
      end
      item
        Component = GuidesPeriod
      end
      item
        Component = GuidesStartYear
      end
      item
        Component = GuidesEndYear
      end
      item
        Component = edShowDate
      end>
    Left = 536
    Top = 168
  end
  object spSelect_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectHistory_DiscountPeriodItem_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42005d
        Component = edShowDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 144
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 270
  end
  object spInsertUpdateList: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42856d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = edPersent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValueNext'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ValueNextDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLast'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 304
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    Key = '0'
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesBrand
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 118
    Top = 42
  end
  object GuidesPeriod: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPeriod
    Key = '0'
    FormNameParam.Value = 'TPeriodForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPeriod
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPeriod
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 278
    Top = 26
  end
  object GuidesStartYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStartYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 442
    Top = 89
  end
  object GuidesEndYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEndYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesEndYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 493
    Top = 99
  end
  object spGet_Current_Date: TdsdStoredProc
    StoredProcName = 'gpGet_Current_Date'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_Current_Date'
        Value = 42856d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 224
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ParamName'
        Value = '% '#1089#1082#1080#1076#1082#1080
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 478
    Top = 259
  end
  object spInsertUpdateListNext: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42856d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = 0.000000000000000000
        Component = ClientDataSet
        ComponentItem = 'ValueDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValueNext'
        Value = Null
        Component = edPersentNext
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLast'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 304
  end
end
