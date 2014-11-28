inherited ImportGroupForm: TImportGroupForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1084#1087#1086#1088#1090#1072'>'
  ClientHeight = 339
  ClientWidth = 578
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 586
  ExplicitHeight = 366
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 578
    Height = 313
    ExplicitWidth = 1184
    ExplicitHeight = 313
    ClientRectBottom = 313
    ClientRectRight = 578
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1184
      ExplicitHeight = 313
      inherited cxGrid: TcxGrid
        Width = 273
        Height = 313
        Align = alLeft
        ExplicitWidth = 273
        ExplicitHeight = 313
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Inserting = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1099' '#1079#1072#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 197
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 46
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 276
        Top = 0
        Width = 302
        Height = 313
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitLeft = 700
        ExplicitWidth = 484
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colName: TcxGridDBColumn
            Caption = #1047#1072#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ImportSettingsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object clIisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 48
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 273
        Top = 0
        Width = 3
        Height = 313
        AutoPosition = False
        Control = cxGrid
        ExplicitLeft = 297
        ExplicitTop = 16
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 168
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = cxGrid1
        Properties.Strings = (
          'Width')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectItems
        end>
    end
    object dsdUpdateMaster: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateImportGroup
      StoredProcList = <
        item
          StoredProc = spInsertUpdateImportGroup
        end>
      Caption = 'dsdUpdate'
      DataSource = MasterDS
    end
    object dsdUpdateChild: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateImportGroupItems
      StoredProcList = <
        item
          StoredProc = spInsertUpdateImportGroupItems
        end>
      Caption = 'dsdUpdateChild'
      DataSource = ChildDS
    end
    object dsdSetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedChild
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object dsdUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedChild
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object dsdUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
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
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
        end
        item
          Name = 'ImportSettingsItemsId'
          Component = ChildCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'ImportSettingsItemsName'
          Component = ChildCDS
          ComponentItem = 'Name'
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object ImportSettingsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      FormName = 'TImportSettingsForm'
      FormNameParam.Value = 'TImportSettingsForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Component = ChildCDS
          ComponentItem = 'ImportSettingsId'
        end
        item
          Name = 'TextValue'
          Component = ChildCDS
          ComponentItem = 'Name'
          DataType = ftString
        end>
      isShowModal = True
    end
    object ExecuteImportSettingsAction: TExecuteImportSettingsAction
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Component = ChildCDS
      ImportSettingsId.ComponentItem = 'ImportSettingsId'
    end
    object mactLoadPrice: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteImportSettingsAction
        end>
      View = cxGridDBTableView1
      QuestionBeforeExecute = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1080'? '
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1089#1077#1093
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportGroup'
    Left = 104
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbExecuteImportSettings'
        end
        item
          Visible = True
          ItemName = 'bbLoadAllPrice'
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
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
    end
    object bbUnErased: TdxBarButton
      Action = dsdUnErased
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
    end
    object bbSetErasedChild: TdxBarButton
      Action = dsdSetErasedChild
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
    end
    object bbUnErasedChild: TdxBarButton
      Action = dsdUnErasedChild
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbExecuteImportSettings: TdxBarButton
      Action = ExecuteImportSettingsAction
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072
      Category = 0
    end
    object bbLoadAllPrice: TdxBarButton
      Action = mactLoadPrice
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 192
  end
  object spInsertUpdateImportGroup: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportGroup'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inName'
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 123
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 464
    Top = 48
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ImportGroupId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 504
    Top = 64
  end
  object spSelectItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportGroupItems'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
    Params = <>
    Left = 424
    Top = 80
  end
  object spInsertUpdateImportGroupItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportGroupItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inImportSettingsId'
        Component = ChildCDS
        ComponentItem = 'ImportSettingsId'
        ParamType = ptInput
      end
      item
        Name = 'inImportGroupId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 424
    Top = 115
  end
  object dsdDBViewAddOnItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 416
    Top = 184
  end
  object spErasedUnErasedChild: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 352
    Top = 216
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 192
    Top = 192
  end
end
