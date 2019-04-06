inherited ChoiceGoodsAnalogForm: TChoiceGoodsAnalogForm
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' '#1072#1085#1072#1083#1086#1075#1086#1074
  ClientHeight = 288
  ClientWidth = 351
  Position = poScreenCenter
  ExplicitWidth = 367
  ExplicitHeight = 327
  PixelsPerInch = 96
  TextHeight = 13
  object ChoiceGoodsGrid: TcxGrid [0]
    Left = 0
    Top = 0
    Width = 351
    Height = 247
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 360
    ExplicitHeight = 181
    object ChoiceGoodsDBTableView: TcxGridDBTableView
      OnDblClick = ChoiceGoodsDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ChoiceGoodsDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
      end
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 250
      end
    end
    object ChoiceGoodsLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ChoiceGoodsDBTableView
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 247
    Width = 351
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 181
    ExplicitWidth = 360
    object bbCancel: TcxButton
      Left = 221
      Top = 6
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
    end
    object bbOk: TcxButton
      Left = 63
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 104
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 256
    Top = 104
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 167
    Top = 103
  end
  object ChoiceGoodsDS: TDataSource
    DataSet = ChoiceGoodsCDS
    Left = 160
    Top = 32
  end
  object ChoiceGoodsCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'AlternativeCDSIndexId'
        Fields = 'Id'
      end>
    Params = <>
    StoreDefs = True
    Left = 48
    Top = 32
  end
end
