inherited ChoiceListDiffForm: TChoiceListDiffForm
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' '#1042#1080#1076#1072' '#1086#1090#1082#1072#1079#1072
  ClientHeight = 249
  ClientWidth = 361
  Position = poScreenCenter
  ExplicitWidth = 377
  ExplicitHeight = 288
  PixelsPerInch = 96
  TextHeight = 13
  object ListDiffGrid: TcxGrid [0]
    Left = 0
    Top = 0
    Width = 361
    Height = 208
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 360
    ExplicitHeight = 181
    object ListDiffGridDBTableView: TcxGridDBTableView
      OnDblClick = ListDiffGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ListDiffDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 232
      end
      object colMaxOrderAmount: TcxGridDBColumn
        Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072
        DataBinding.FieldName = 'MaxOrderAmount'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 89
      end
    end
    object ListDiffGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListDiffGridDBTableView
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 208
    Width = 361
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
  object ListDiffDS: TDataSource
    Left = 40
    Top = 32
  end
end
