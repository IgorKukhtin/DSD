object Retail_PrintKindItemForm: TRetail_PrintKindItemForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1069#1083#1077#1084#1077#1085#1090#1099' '#1087#1077#1095#1072#1090#1080')>'
  ClientHeight = 379
  ClientWidth = 1022
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 1022
    Height = 353
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'UserSkin'
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceGoodsProperty
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 51
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object isMovement: TcxGridDBColumn
        Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
        DataBinding.FieldName = 'isMovement'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CountMovement: TcxGridDBColumn
        Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1082#1086#1083'. '#1082#1086#1087#1080#1081
        DataBinding.FieldName = 'CountMovement'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object isAccount: TcxGridDBColumn
        Caption = #1057#1095#1077#1090
        DataBinding.FieldName = 'isAccount'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CountAccount: TcxGridDBColumn
        Caption = #1057#1095#1077#1090' '#1082#1086#1083'. '#1082#1086#1087#1080#1081
        DataBinding.FieldName = 'CountAccount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object isTransport: TcxGridDBColumn
        Caption = #1058#1058#1053
        DataBinding.FieldName = 'isTransport'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CountTransport: TcxGridDBColumn
        Caption = #1058#1058#1053' '#1082#1086#1083'. '#1082#1086#1087#1080#1081
        DataBinding.FieldName = 'CountTransport'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object isQuality: TcxGridDBColumn
        Caption = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077
        DataBinding.FieldName = 'isQuality'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CountQuality: TcxGridDBColumn
        Caption = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1082#1086#1083'. '#1082#1086#1087#1080#1081
        DataBinding.FieldName = 'CountQuality'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object isPack: TcxGridDBColumn
        Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081
        DataBinding.FieldName = 'isPack'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CountPack: TcxGridDBColumn
        Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1082#1086#1083'. '#1082#1086#1087#1080#1081
        DataBinding.FieldName = 'CountPack'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object isSpec: TcxGridDBColumn
        Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
        DataBinding.FieldName = 'isSpec'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CountSpec: TcxGridDBColumn
        Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' '#1082#1086#1083'. '#1082#1086#1087#1080#1081
        DataBinding.FieldName = 'CountSpec'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object isTax: TcxGridDBColumn
        Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103
        DataBinding.FieldName = 'isTax'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CountTax: TcxGridDBColumn
        Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1082#1086#1083'. '#1082#1086#1087#1080#1081
        DataBinding.FieldName = 'CountTax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
      end
      object isTransportBill: TcxGridDBColumn
        Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103
        DataBinding.FieldName = 'isTransportBill'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CountTransportBill: TcxGridDBColumn
        Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103' '#1082#1086#1083'. '#1082#1086#1087#1080#1081
        DataBinding.FieldName = 'CountTransportBill'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.;-,0.; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel6: TcxLabel
    Left = 642
    Top = 134
    Caption = #1060#1080#1083#1080#1072#1083':'
  end
  object edBranch: TcxButtonEdit
    Left = 694
    Top = 133
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 236
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 144
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
    Left = 240
    Top = 88
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
    Left = 152
    Top = 88
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
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
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
          ItemName = 'bbBranchLabel'
        end
        item
          Visible = True
          ItemName = 'bbBranch'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbChoice'
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
    object bbSetErased: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbSetUnErased: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object bbToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '       '
      Category = 0
      Hint = '       '
      Visible = ivAlways
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbBranchLabel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bbBranch: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edBranch
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 264
    Top = 136
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TRetailEditForm'
      FormNameParam.Value = 'TRetailEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
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
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TRetailEditForm'
      FormNameParam.Value = 'TRetailEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate
      StoredProcList = <
        item
          StoredProc = spUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
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
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object actChoiceGoodsProperty: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoodsProperty'
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = 'TGoodsPropertyForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyName'
          DataType = ftString
        end>
      isShowModal = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Retail_PrintKindItem'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inBranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 144
    Top = 152
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 296
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 176
    Top = 216
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 48
    Top = 216
  end
  object spUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Retail_PrintKindItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'outBranchName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BranchName'
        DataType = ftString
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'ioisMovement'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isMovement'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioisAccount'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isAccount'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioisTransport'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isTransport'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioisQuality'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isQuality'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioisPack'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isPack'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioisSpec'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isSpec'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioisTax'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isTax'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioisTransportBill'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isTransportBill'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCountMovement'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountMovement'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCountAccount'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountAccount'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCountTransport'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountTransport'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCountQuality'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountQuality'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCountPack'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountPack'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCountSpec'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountSpec'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCountTax'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountTax'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCountTransportBill'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CountTransportBill'
        DataType = ftFloat
        ParamType = ptInputOutput
      end>
    PackSize = 1
    Left = 392
    Top = 120
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Member'
        DataType = ftString
      end>
    Left = 768
    Top = 120
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesBranch
      end
      item
        Component = edBranch
      end>
    Left = 400
    Top = 168
  end
end
