object SendJournalForm: TSendJournalForm
  Left = 0
  Top = 0
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
  ClientHeight = 427
  ClientWidth = 733
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 733
    Height = 41
    Align = alTop
    TabOrder = 1
    object deStart: TcxDateEdit
      Left = 106
      Top = 12
      EditValue = 41395d
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 97
    end
    object deEnd: TcxDateEdit
      Left = 325
      Top = 11
      EditValue = 41395d
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 91
    end
    object cxLabel1: TcxLabel
      Left = 9
      Top = 13
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 210
      Top = 13
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 67
    Width = 733
    Height = 360
    Align = alClient
    PopupMenu = PopupMenu
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
      DataController.Filter.TranslateBetween = True
      DataController.Filter.TranslateIn = True
      DataController.Filter.TranslateLike = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colStatus: TcxGridDBColumn
        Caption = #1057#1090#1072#1090#1091#1089
        DataBinding.FieldName = 'StatusCode'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = dmMain.ImageList
        Properties.Items = <
          item
            Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
            ImageIndex = 11
            Value = 1
          end
          item
            Description = #1055#1088#1086#1074#1077#1076#1077#1085
            ImageIndex = 12
            Value = 2
          end
          item
            Description = #1059#1076#1072#1083#1077#1085
            ImageIndex = 13
            Value = 3
          end>
        HeaderAlignmentVert = vaCenter
      end
      object colInvNumber: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object colOperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentVert = vaCenter
        Width = 47
      end
      object colFromName: TcxGridDBColumn
        Caption = #1054#1090' '#1082#1086#1075#1086
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentVert = vaCenter
        Width = 140
      end
      object colToName: TcxGridDBColumn
        Caption = #1050#1086#1084#1091
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentVert = vaCenter
        Width = 140
      end
      object colTotalCount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'TotalCount'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 24
    Top = 136
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 136
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
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
    Left = 8
    Top = 64
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
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
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
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
      ImageIndex = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
      ImageIndex = 1
    end
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object bbUnComplete: TdxBarButton
      Action = actUnComplete
      Category = 0
    end
    object bbDelete: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 80
    Top = 56
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      FormName = 'TSendForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      FormName = 'TSendForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object actUnComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = DataSource
    end
    object actComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      StoredProcList = <
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = DataSource
    end
    object actSetErased: TdsdChangeMovementStatus
      Category = 'DSDLib'
      StoredProc = spMovementChangeStatus
      StoredProcList = <
        item
          StoredProc = spMovementChangeStatus
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 24
    Top = 176
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 112
    Top = 56
    object N1: TMenuItem
      Action = actComplete
    end
    object N2: TMenuItem
      Action = actUnComplete
    end
  end
  object spMovementChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStatusCode'
        Component = ClientDataSet
        ComponentItem = 'StatusCode'
        ParamType = ptInput
      end>
    Left = 72
    Top = 232
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 136
    Top = 200
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 168
    Top = 256
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 488
    Top = 24
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 576
    Top = 24
  end
end
