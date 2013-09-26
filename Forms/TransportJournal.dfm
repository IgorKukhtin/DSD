inherited TransportJournalForm: TTransportJournalForm
  Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
  ClientHeight = 427
  ClientWidth = 1276
  ExplicitWidth = 1292
  ExplicitHeight = 462
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1276
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 579
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
      EditValue = 41395d
      TabOrder = 1
      Width = 121
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 67
    Width = 1276
    Height = 360
    Align = alClient
    PopupMenu = PopupMenu
    TabOrder = 0
    ExplicitWidth = 579
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
      OptionsView.HeaderHeight = 40
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
        Width = 55
      end
      object InvNumber: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentVert = vaCenter
        Width = 47
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CarTrailerName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' ('#1087#1088#1080#1094#1077#1087')'
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PersonalDriver: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'PersonalDriverName'
        Width = 70
      end
      object PersonalDriverMoreName: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100', '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081
        DataBinding.FieldName = 'PersonalDriverMoreName'
        Width = 70
      end
      object UnitForwardingName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1052#1077#1089#1090#1086' '#1086#1090#1087#1088#1072#1074#1082#1080')'
        DataBinding.FieldName = 'UnitForwardingName'
        Width = 60
      end
      object StartRunPlan: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1074#1099#1077#1079#1076#1072' '#1087#1083#1072#1085
        DataBinding.FieldName = 'StartRunPlan'
        Width = 45
      end
      object EndRunPlan: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1087#1083#1072#1085
        DataBinding.FieldName = 'EndRunPlan'
        Width = 45
      end
      object StartRun: TcxGridDBColumn
        Caption = ' '#1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1074#1099#1077#1079#1076#1072' '#1092#1072#1082#1090
        DataBinding.FieldName = 'StartRun'
        Width = 45
      end
      object EndRun: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1092#1072#1082#1090
        DataBinding.FieldName = 'EndRun'
        Width = 45
      end
      object HoursWork: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074
        DataBinding.FieldName = 'HoursWork'
        Width = 45
      end
      object HoursAdd: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1076#1086#1073#1072#1074#1083#1077#1085#1085#1099#1093' '#1095#1072#1089#1086#1074
        DataBinding.FieldName = 'HoursAdd'
        Width = 45
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        Width = 70
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
          'Action'
          'ActiveControl'
          'Align'
          'AlignWithMargins'
          'AlphaBlend'
          'AlphaBlendValue'
          'Anchors'
          'AutoScroll'
          'AutoSize'
          'BiDiMode'
          'BorderIcons'
          'BorderStyle'
          'BorderWidth'
          'Caption'
          'ClientHeight'
          'ClientWidth'
          'Color'
          'Constraints'
          'Ctl3D'
          'Cursor'
          'CustomHint'
          'DefaultMonitor'
          'DockSite'
          'DoubleBuffered'
          'DragKind'
          'DragMode'
          'Enabled'
          'Font'
          'FormStyle'
          'GlassFrame'
          'Height'
          'HelpContext'
          'HelpFile'
          'HelpKeyword'
          'HelpType'
          'Hint'
          'HorzScrollBar'
          'Icon'
          'KeyPreview'
          'Left'
          'Margins'
          'Menu'
          'Name'
          'ObjectMenuItem'
          'OldCreateOrder'
          'Padding'
          'ParentBiDiMode'
          'ParentCustomHint'
          'ParentFont'
          'PixelsPerInch'
          'PopupMenu'
          'PopupMode'
          'PopupParent'
          'Position'
          'PrintScale'
          'Scaled'
          'ScreenSnap'
          'ShowHint'
          'SnapBuffer'
          'Tag'
          'Top'
          'Touch'
          'TransparentColor'
          'TransparentColorValue'
          'UseDockManager'
          'VertScrollBar'
          'Visible'
          'Width'
          'WindowMenu'
          'WindowState')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 8
    Top = 32
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
          ItemName = 'bbBarStatic'
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
          ItemName = 'bbBarStatic'
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
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
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
    object bbBarStatic: TdxBarStatic
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
      ImageIndex = 0
      FormName = 'TTransportForm'
      GuiParams = <
        item
          Name = 'Id'
          DataType = ftInteger
          ParamType = ptOutput
          Value = '0'
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TTransportForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftInteger
          ParamType = ptInput
        end>
      isShowModal = False
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
      DataSource = DataSource
      Status = mtUncomplete
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
      DataSource = DataSource
      Status = mtComplete
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
      DataSource = DataSource
      Status = mtDelete
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
    StoredProcName = 'gpSelect_Movement_Transport'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        Value = 41395d
      end
      item
        Name = 'inEndDate'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        Value = 41395d
      end>
    Left = 24
    Top = 176
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Transport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        DataType = ftInteger
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
        DataType = ftInteger
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
        DataType = ftInteger
        ParamType = ptInput
      end>
    Left = 72
    Top = 320
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 160
    Top = 232
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    Left = 160
    Top = 200
  end
end
