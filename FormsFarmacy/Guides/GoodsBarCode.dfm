object GoodsBarCodeForm: TGoodsBarCodeForm
  Left = 0
  Top = 0
  Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076#1099' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1077#1081
  ClientHeight = 406
  ClientWidth = 815
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 815
    Height = 380
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitWidth = 789
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.Content = dmMain.cxContentStyle
      Styles.Inactive = dmMain.cxSelection
      Styles.Selection = dmMain.cxSelection
      Styles.Footer = dmMain.cxFooterStyle
      Styles.Header = dmMain.cxHeaderStyle
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Id: TcxGridDBColumn
        Caption = #1048#1044
        DataBinding.FieldName = 'Id'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object GoodsId: TcxGridDBColumn
        Caption = #1048#1044' '#1085#1072#1096#1077#1075#1086' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsId'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object GoodsMainId: TcxGridDBColumn
        Caption = #1048#1044' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsMainId'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object GoodsBarCodeId: TcxGridDBColumn
        Caption = #1048#1044' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1072
        DataBinding.FieldName = 'GoodsBarCodeId'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object GoodsJuridicalId: TcxGridDBColumn
        Caption = #1048#1044' '#1090#1086#1074#1072#1088#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        DataBinding.FieldName = 'GoodsJuridicalId'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object JuridicalId: TcxGridDBColumn
        Caption = #1048#1044' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        DataBinding.FieldName = 'JuridicalId'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1085#1072#1096#1077#1075#1086' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 77
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1096#1077#1075#1086' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 200
      end
      object ProducerName: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'ProducerName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 120
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 100
      end
      object BarCode: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
        DataBinding.FieldName = 'BarCode'
        HeaderAlignmentHorz = taCenter
        Width = 120
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 150
      end
      object ErrorText: TcxGridDBColumn
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1086#1096#1080#1073#1082#1080
        DataBinding.FieldName = 'ErrorText'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 240
      end
      object CodeUKTZED: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1050#1058' '#1047#1045#1044' (main)'
        DataBinding.FieldName = 'CodeUKTZED'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel3: TcxLabel
    Left = 309
    Top = 86
    Caption = #1070#1088'.'#1083#1080#1094#1086':'
  end
  object edJuridical: TcxButtonEdit
    Left = 367
    Top = 85
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 6
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1102#1088'.'#1083#1080#1094#1086'>'
    Width = 234
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 88
    Top = 108
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 156
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 212
    Top = 108
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 212
    Top = 160
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 823
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarButtonRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarButtonLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'dxBarButtonGridToExcel'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarButtonRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object dxBarButtonGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarButtonLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbStartLoad2: TdxBarButton
      Action = actStartLoad_Price
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
      Control = edJuridical
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 296
    Top = 160
    object actStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1072#1085#1085#1099#1093' '#1087#1086' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1072#1084'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1072#1084
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1072#1084
      ImageIndex = 41
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inObjectId'
          Value = '0'
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
    end
    object actStartLoad_Price: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actTest
        end
        item
          Action = actGetImportSetting_Price
        end
        item
          Action = actDoLoad_Price
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1072#1085#1085#1099#1093' '#1087#1086' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1072#1084' '#1080#1079' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086 +
        #1084#1091' '#1070#1088'.'#1083#1080#1094#1091'?'
      Caption = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1072#1084' '#1080#1079' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1070#1088'.' +
        #1083#1080#1094#1091
      Hint = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1072#1084' '#1080#1079' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1070#1088'.' +
        #1083#1080#1094#1091
      ImageIndex = 74
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGetImportSetting_Price: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_Price
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_Price
        end>
      Caption = 'actGetImportSetting_Price'
    end
    object actDoLoad_Price: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Price'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inJuridicalId'
          Value = '0'
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actTest: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = dsdStoredProc1
      StoredProcList = <
        item
          StoredProc = dsdStoredProc1
        end>
      Caption = 'actTest'
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsBarCode'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 88
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 212
    Top = 220
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsBarCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 87
    Top = 270
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsBarCodeForm;zc_Object_ImportSetting_BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 212
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsUploadId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsSpecConditionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_Price'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 108
  end
  object spInsertUpdateLoad: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsBarCode_Load'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProducerName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ProducerName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'JuridicalName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 515
    Top = 266
  end
  object spGetImportSettingId_Price: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsBarCodeForm;zc_Object_ImportSetting_BarCode_Price'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId_Price'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 172
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 528
    Top = 80
  end
  object spInsertUpdateLoad_Price: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsBarCode_Load_Price'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommonCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CommonCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProducerName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ProducerName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 675
    Top = 234
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsBarCode_Load_Price_Test'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 683
    Top = 290
  end
end
