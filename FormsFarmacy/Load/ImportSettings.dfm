inherited ImportSettingsForm: TImportSettingsForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1084#1087#1086#1088#1090#1072'>'
  ClientHeight = 339
  ClientWidth = 921
  ExplicitWidth = 937
  ExplicitHeight = 378
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 921
    Height = 311
    ExplicitTop = 28
    ExplicitWidth = 921
    ExplicitHeight = 311
    ClientRectBottom = 307
    ClientRectRight = 917
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitWidth = 913
      ExplicitHeight = 303
      inherited cxGrid: TcxGrid
        Width = 593
        Height = 303
        Align = alLeft
        ExplicitWidth = 593
        ExplicitHeight = 303
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 34
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object clDirectory: TcxGridDBColumn
            Caption = #1044#1080#1088#1077#1082#1090#1086#1088#1080#1103' '#1079#1072#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'Directory'
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = JuridicalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object clContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContractChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clFileTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1092#1072#1081#1083#1072
            DataBinding.FieldName = 'FileTypeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = FileTypeKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object clImportTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
            DataBinding.FieldName = 'ImportTypeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ImportTypeItemsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object clStartRow: TcxGridDBColumn
            Caption = #1055#1077#1088#1074#1072#1103' '#1089#1090#1088#1086#1082#1072' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1076#1083#1103' Excel'
            DataBinding.FieldName = 'StartRow'
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            HeaderAlignmentVert = vaCenter
            Width = 26
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 596
        Top = 0
        Width = 317
        Height = 303
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        ExplicitLeft = 593
        ExplicitWidth = 320
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
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clIName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
            DataBinding.FieldName = 'Name'
            Width = 100
          end
          object clImportTypeItemsName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1084#1087#1086#1088#1090#1072
            DataBinding.FieldName = 'ImportTypeItemsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ImportTypeItemsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Width = 100
          end
          object clIisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Width = 30
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 593
        Top = 0
        Width = 3
        Height = 303
        AutoPosition = False
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
      StoredProc = spInsertUpdateImportType
      StoredProcList = <
        item
          StoredProc = spInsertUpdateImportType
        end>
      Caption = 'dsdUpdate'
      DataSource = MasterDS
    end
    object dsdUpdateChild: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateImportTypeItems
      StoredProcList = <
        item
          StoredProc = spInsertUpdateImportTypeItems
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
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
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
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object ImportTypeItemsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ImportTypeItemsChoiceForm'
      FormName = 'TImportTypeForm'
      FormNameParam.Value = 'TImportTypeForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'ImportTypeItemsId'
          Component = ChildCDS
          ComponentItem = 'ImportTypeItemsId'
        end
        item
          Name = 'ImportTypeItemsName'
          Component = ChildCDS
          ComponentItem = 'ImportTypeItemsName'
          DataType = ftString
        end>
      isShowModal = True
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
    object FileTypeKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'FileTypeKindChoiceForm'
      FormName = 'TFileTypeKindForm'
      FormNameParam.Value = 'TFileTypeKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Component = MasterCDS
          ComponentItem = 'FileTypeKindId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'FileTypeKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object ContractChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'JuridicalChoiceForm'
      FormName = 'TContractForm'
      FormNameParam.Value = 'TContractForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object JuridicalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'JuridicalChoiceForm'
      FormName = 'TJuridicalForm'
      FormNameParam.Value = 'TJuridicalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end>
      isShowModal = True
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
    StoredProcName = 'gpSelect_Object_ImportSettings'
    Left = 104
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 80
    DockControlHeights = (
      0
      0
      28
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedChild'
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
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 192
  end
  object spInsertUpdateImportType: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inFileTypeId'
        Component = MasterCDS
        ComponentItem = 'FileTypeId'
        ParamType = ptInput
      end
      item
        Name = 'inImportTypeId'
        Component = MasterCDS
        ComponentItem = 'ImportTypeId'
        ParamType = ptInput
      end
      item
        Name = 'inStartRow'
        Component = MasterCDS
        ComponentItem = 'StartRow'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inDirectory'
        Component = MasterCDS
        ComponentItem = 'Directory'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 123
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 624
    Top = 64
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ImportSettingsId '
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 688
    Top = 72
  end
  object spSelectItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportSettingsItems'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
    Params = <>
    Left = 784
    Top = 80
  end
  object spInsertUpdateImportTypeItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportSettingsItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inName'
        Component = ChildCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inImportSettingsId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inImportTypeItemsId'
        Component = ChildCDS
        ComponentItem = 'ImportTypeItemsId'
        ParamType = ptInput
      end>
    Left = 792
    Top = 155
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
    Left = 648
    Top = 192
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
    Left = 632
    Top = 136
  end
end
