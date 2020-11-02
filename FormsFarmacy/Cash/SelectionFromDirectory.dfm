inherited SelectionFromDirectoryForm: TSelectionFromDirectoryForm
  Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
  ClientHeight = 372
  ClientWidth = 405
  OnCreate = ParentFormCreate
  OnKeyDown = ParentFormKeyDown
  ExplicitWidth = 421
  ExplicitHeight = 411
  PixelsPerInch = 96
  TextHeight = 13
  object SelectionFromDirectoryGrid: TcxGrid [0]
    Left = 0
    Top = 25
    Width = 405
    Height = 347
    Align = alClient
    TabOrder = 1
    object SelectionFromDirectoryGridDBTableView: TcxGridDBTableView
      OnDblClick = SelectionFromDirectoryGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = SelectionFromDirectoryDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colName
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        OnCustomDrawCell = colNameCustomDrawCell
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 251
      end
      object colSecond: TcxGridDBColumn
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 140
        IsCaptionAssigned = True
      end
    end
    object SelectionFromDirectoryGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = SelectionFromDirectoryGridDBTableView
    end
  end
  object pnl1: TPanel [1]
    Left = 0
    Top = 0
    Width = 405
    Height = 25
    Align = alTop
    TabOrder = 0
    DesignSize = (
      405
      25)
    object edt1: TEdit
      Left = 1
      Top = 1
      Width = 403
      Height = 23
      Align = alClient
      AutoSelect = False
      TabOrder = 0
      OnChange = edt1Change
      OnDblClick = edt1DblClick
      OnExit = edt1Exit
      ExplicitHeight = 21
    end
    object ProgressBar1: TProgressBar
      Left = 339
      Top = 12
      Width = 57
      Height = 9
      Anchors = [akTop, akRight]
      BarColor = clMedGray
      TabOrder = 1
      Visible = False
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 248
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 304
    Top = 248
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 183
    Top = 247
    object actRefreshForm: TAction
      Category = 'DSDLib'
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      ImageIndex = 4
      OnExecute = actRefreshFormExecute
    end
  end
  object SelectionFromDirectoryDS: TDataSource
    DataSet = SelectionFromDirectoryCDS
    Left = 312
    Top = 176
  end
  object SelectionFromDirectoryCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 312
    Top = 112
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 312
    Top = 48
  end
  object spSelect_SelectionFromDirectory: TdsdStoredProc
    DataSet = SelectionFromDirectoryCDS
    DataSets = <
      item
        DataSet = SelectionFromDirectoryCDS
      end>
    Params = <>
    PackSize = 1
    Left = 64
    Top = 104
  end
end
