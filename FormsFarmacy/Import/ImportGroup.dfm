inherited ImportGroupForm: TImportGroupForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1084#1087#1086#1088#1090#1072'>'
  ClientHeight = 345
  ClientWidth = 767
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 783
  ExplicitHeight = 383
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 767
    Height = 319
    ExplicitWidth = 767
    ExplicitHeight = 319
    ClientRectBottom = 319
    ClientRectRight = 767
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 767
      ExplicitHeight = 319
      inherited cxGrid: TcxGrid
        Width = 273
        Height = 319
        Align = alLeft
        ExplicitWidth = 273
        ExplicitHeight = 319
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1099' '#1079#1072#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 197
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 46
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 276
        Top = 0
        Width = 491
        Height = 319
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
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
            Properties.ReadOnly = True
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
        Height = 319
        AutoPosition = False
        Control = cxGrid
      end
      object cxLabel3: TcxLabel
        Left = 307
        Top = 100
        Caption = #1056#1077#1075#1080#1086#1085':'
      end
    end
  end
  object edArea: TcxButtonEdit [1]
    Left = 315
    Top = 155
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 5
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1088#1077#1075#1080#1086#1085'>'
    Width = 234
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
      PostDataSetBeforeExecute = False
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
      PostDataSetBeforeExecute = False
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
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ImportSettingsItemsId'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ImportSettingsItemsName'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Name'
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object ImportSettingsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TImportSettingsForm'
      FormNameParam.Value = 'TImportSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'ImportSettingsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ExecuteImportSettingsAction: TExecuteImportSettingsAction
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = ChildCDS
      ImportSettingsId.ComponentItem = 'ImportSettingsId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inAreaId'
          Value = Null
          Component = GuidesArea
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end>
    end
    object macGUILoadPrice: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = mactLoadPrice
        end
        item
        end>
      QuestionBeforeExecute = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1042#1057#1045' '#1079#1072#1075#1088#1091#1079#1082#1080'? '
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1087#1086' '#1042#1057#1045#1052' '#1101#1083#1077#1084#1077#1085#1090#1072#1084
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1089#1077#1093
    end
    object mactLoadPrice: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteImportSettingsAction
        end
        item
          Action = actProtocol
        end>
      View = cxGridDBTableView1
    end
    object actProtocol: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Protocol_LoadPriceList
      StoredProcList = <
        item
          StoredProc = spUpdate_Protocol_LoadPriceList
        end>
      Caption = 'actProtocol'
    end
    object macExecuteImportSettings_Protocol: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteImportSettingsAction
        end
        item
          Action = actProtocol
        end
        item
        end>
      QuestionBeforeExecute = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1086#1076#1085#1086#1084#1091' '#1101#1083#1077#1084#1077#1085#1090#1091'? '
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1087#1086' '#1086#1076#1085#1086#1084#1091' '#1101#1083#1077#1084#1077#1085#1090#1091
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      FormName = 'TImportGroupEditForm'
      FormNameParam.Value = 'TImportGroupEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TImportGroupEditForm'
      FormNameParam.Value = 'TImportGroupEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actProtocolMaster: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1043#1088#1091#1087#1087' '#1079#1072#1075#1088#1091#1079#1082#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1043#1088#1091#1087#1087' '#1079#1072#1075#1088#1091#1079#1082#1080'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocolChild: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1047#1072#1075#1088#1091#1079#1082#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1047#1072#1075#1088#1091#1079#1082#1080'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbUpdate'
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
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
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
          ItemName = 'bbProtocolMaster'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolChild'
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
      Action = macExecuteImportSettings_Protocol
      Category = 0
    end
    object bbLoadAllPrice: TdxBarButton
      Action = macGUILoadPrice
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel3
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edArea
    end
    object bbUpdate: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbProtocolMaster: TdxBarButton
      Action = actProtocolMaster
      Category = 0
    end
    object bbProtocolChild: TdxBarButton
      Action = actProtocolChild
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
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
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
    PackSize = 1
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
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inImportSettingsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ImportSettingsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inImportGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 131
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
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
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
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 192
  end
  object spUpdate_Protocol_LoadPriceList: TdsdStoredProc
    StoredProcName = 'gpUpdate_Protocol_LoadPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inImportSettingsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ImportSettingsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 64
  end
  object spRefreshMovementItemLastPriceList_View: TdsdStoredProc
    StoredProcName = 'lpRefreshMovementItemLastPriceList_View'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 544
    Top = 208
  end
  object GuidesArea: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 528
    Top = 120
  end
end
