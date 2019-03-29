inherited GoodsToExpirationDateForm: TGoodsToExpirationDateForm
  Caption = #1054#1089#1090#1072#1090#1086#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
  ClientHeight = 336
  ClientWidth = 578
  AddOnFormData.isSingle = False
  ExplicitWidth = 594
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 13
  object ListGoodsGrid: TcxGrid [0]
    Left = 0
    Top = 0
    Width = 578
    Height = 336
    Align = alClient
    TabOrder = 0
    object ListGoodsGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ListGoodsDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colGoodsName
        end
        item
          Format = ',0.000'
          Kind = skSum
          Column = colAmout
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.Alignment.Horz = taRightJustify
        OnGetDataText = colGoodsCodeGetDataText
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 56
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        OnGetDataText = colGoodsNameGetDataText
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 286
      end
      object colAmout: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object colExpirationDate: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1093#1088#1072#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'ExpirationDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
    end
    object ListGoodsGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListGoodsGridDBTableView
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 291
    Top = 272
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 152
    Top = 272
  end
  inherited ActionList: TActionList
    Left = 63
    Top = 279
  end
  object ListGoodsDS: TDataSource
    DataSet = ListGoodsCDS
    Left = 360
    Top = 96
  end
  object ListGoodsCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'ExpirationDate'
    Params = <>
    StoreDefs = True
    Left = 288
    Top = 96
  end
end
