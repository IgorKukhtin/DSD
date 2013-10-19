object ReturnInJournalForm: TReturnInJournalForm
  Left = 0
  Top = 0
  Hint = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
  ClientHeight = 427
  ClientWidth = 1240
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  isAlwaysRefresh = False
  isFree = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1240
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object deStart: TcxDateEdit
      Left = 208
      Top = 8
      EditValue = 41395d
      TabOrder = 0
      Width = 121
    end
    object deEnd: TcxDateEdit
      Left = 352
      Top = 8
      EditValue = 41760d
      TabOrder = 1
      Width = 121
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 67
    Width = 1240
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
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
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
      end
      object colInvNumber: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'InvNumber'
        Width = 41
      end
      object colOperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        Width = 47
      end
      object colFromName: TcxGridDBColumn
        Caption = #1054#1090' '#1082#1086#1075#1086
        DataBinding.FieldName = 'FromName'
        Width = 140
      end
      object colToName: TcxGridDBColumn
        Caption = #1050#1086#1084#1091
        DataBinding.FieldName = 'ToName'
        Width = 140
      end
      object colTotalCount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'TotalCount'
      end
      object colTotalSumm: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1090#1072#1074#1097'.'
        DataBinding.FieldName = 'TotalSumm'
        Width = 80
      end
      object colChangePercent: TcxGridDBColumn
        Caption = '(-)% '#1057#1082', (+)% '#1053#1072#1094
        DataBinding.FieldName = 'ChangePercent'
        Width = 90
      end
      object colPriceWithVAT: TcxGridDBColumn
        Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' '
        DataBinding.FieldName = 'PriceWithVAT'
      end
      object colVATPercent: TcxGridDBColumn
        Caption = '% '#1053#1044#1057
        DataBinding.FieldName = 'VATPercent'
        Width = 45
      end
      object colTotalSummVAT: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
        DataBinding.FieldName = 'TotalSummVAT'
        Width = 60
      end
      object colTotalSummMVAT: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
        DataBinding.FieldName = 'TotalSummMVAT'
        Visible = False
        Width = 80
      end
      object colTotalSummPVAT: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
        DataBinding.FieldName = 'TotalSummPVAT'
        Width = 70
      end
      object colPaidKindName: TcxGridDBColumn
        Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        Width = 55
      end
      object colContractName: TcxGridDBColumn
        Caption = #1044#1086#1075#1086#1074#1086#1088
        DataBinding.FieldName = 'ContractName'
        Width = 55
      end
      object colCarName: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'CarName'
      end
      object colPersonalDriverName: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'PersonalDriverName'
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
        Component = colFromName
        Properties.Strings = (
          'SortIndex'
          'SortOrder'
          'Width')
      end
      item
        Component = colInvNumber
        Properties.Strings = (
          'SortIndex'
          'SortOrder'
          'Width')
      end
      item
        Component = colOperDate
        Properties.Strings = (
          'SortIndex'
          'SortOrder'
          'Width')
      end
      item
        Component = colStatus
        Properties.Strings = (
          'SortIndex'
          'SortOrder'
          'Width')
      end
      item
        Component = colToName
        Properties.Strings = (
          'SortIndex'
          'SortOrder'
          'Width')
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
    Top = 32
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
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 40
    Top = 32
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
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 72
    Top = 32
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
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      FormName = 'TReturnInForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      FormName = 'TReturnInForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object actUnComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      StoredProc = spMovementUnComplete
      StoredProcList = <
        item
          StoredProc = spMovementUnComplete
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = DataSource
    end
    object actComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = DataSource
    end
    object actSetErased: TdsdChangeMovementStatus
      Category = 'DSDLib'
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnIn'
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
        Value = 41760d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 24
    Top = 192
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ReturnIn'
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
        Name = 'inIsLastComplete'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 64
    Top = 232
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 104
    Top = 32
    object N1: TMenuItem
      Action = actComplete
    end
    object N2: TMenuItem
      Action = actUnComplete
    end
  end
  object spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 72
    Top = 272
  end
  object spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 72
    Top = 320
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    Left = 160
    Top = 224
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 192
    Top = 256
  end
end
