object MobilePartner_ObjectForm: TMobilePartner_ObjectForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1086#1095#1077#1082' '#1076#1086#1089#1090#1072#1074#1082#1080' >'
  ClientHeight = 464
  ClientWidth = 915
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 915
    Height = 438
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -8
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = ceName
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 50
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ceCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 35
      end
      object ceName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object ceAddress: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089
        DataBinding.FieldName = 'Address'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object clGPSN: TcxGridDBColumn
        Caption = 'GPS '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1090#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080' ('#1096#1080#1088#1086#1090#1072')'
        DataBinding.FieldName = 'GPSN'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 115
      end
      object clGPSE: TcxGridDBColumn
        Caption = 'GPS '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1090#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080' ('#1076#1086#1083#1075#1086#1090#1072')'
        DataBinding.FieldName = 'GPSE'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 117
      end
      object clDebtSum: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072' ('#1085#1072#1084')'
        DataBinding.FieldName = 'DebtSum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clOverSum: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1076#1086#1083#1075#1072' ('#1085#1072#1084')'
        DataBinding.FieldName = 'OverSum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clOverDays: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1086#1089#1088#1086#1095#1082#1080' ('#1085#1072#1084')'
        DataBinding.FieldName = 'OverDays'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 85
      end
      object clPrepareDayCount: TcxGridDBColumn
        Caption = #1047#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1085#1080#1084#1072#1077#1090#1089#1103' '#1079#1072#1082#1072#1079
        DataBinding.FieldName = 'PrepareDayCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 110
      end
      object ceJuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object clRouteName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 150
      end
      object ContractCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object clContractName: TcxGridDBColumn
        Caption = #1044#1086#1075#1086#1074#1086#1088
        DataBinding.FieldName = 'ContractName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object clPriceListName: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
        DataBinding.FieldName = 'PriceListName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'PriceListChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 84
      end
      object clPriceListName_ret: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1042#1086#1079#1074#1088#1072#1090#1072
        DataBinding.FieldName = 'PriceListName_ret'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'PriceListPromoChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 86
      end
      object clisSync: TcxGridDBColumn
        Caption = #1057#1080#1085#1093#1088#1086#1085#1080#1079#1080#1088#1091#1077#1090#1089#1103
        DataBinding.FieldName = 'isSync'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clSchedule: TcxGridDBColumn
        Caption = #1043#1088#1072#1092#1080#1082' '#1087#1086#1089#1077#1097#1077#1085#1080#1103
        DataBinding.FieldName = 'Schedule'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 94
      end
      object colValue1: TcxGridDBColumn
        Caption = #1055#1085
        DataBinding.FieldName = 'Value1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 25
      end
      object colValue2: TcxGridDBColumn
        Caption = #1042#1090
        DataBinding.FieldName = 'Value2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 25
      end
      object colValue3: TcxGridDBColumn
        Caption = #1057#1088
        DataBinding.FieldName = 'Value3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 25
      end
      object colValue4: TcxGridDBColumn
        Caption = #1063#1090
        DataBinding.FieldName = 'Value4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 25
      end
      object colValue5: TcxGridDBColumn
        Caption = #1055#1090
        DataBinding.FieldName = 'Value5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 25
      end
      object colValue6: TcxGridDBColumn
        Caption = #1057#1073
        DataBinding.FieldName = 'Value6'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 25
      end
      object colValue7: TcxGridDBColumn
        Caption = #1042#1089
        DataBinding.FieldName = 'Value7'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 25
      end
      object ceisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel3: TcxLabel
    Left = 579
    Top = 134
    Caption = #1058#1086#1088#1075#1086#1074#1099#1081' '#1072#1075#1077#1085#1090':'
  end
  object edPersonalTrade: TcxButtonEdit
    Left = 668
    Top = 133
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 247
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 40
    Top = 120
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 192
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
    Left = 296
    Top = 120
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
    Top = 112
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
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
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
    object bbGridToExel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbJuridicalLabel: TdxBarControlContainerItem
      Caption = 'JuridicalLabel'
      Category = 0
      Hint = 'JuridicalLabel'
      Visible = ivAlways
    end
    object bbJuridicalGuides: TdxBarControlContainerItem
      Caption = 'JuridicalGuides'
      Category = 0
      Hint = 'JuridicalGuides'
      Visible = ivAlways
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
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
      Control = edPersonalTrade
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_PersonalTrade
      StoredProcList = <
        item
          StoredProc = spGet_PersonalTrade
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Partner_Mobile'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
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
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 464
    Top = 288
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 424
    Top = 152
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PersonalTradeGuides
      end>
    Left = 288
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MasterJuridicalId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 112
  end
  object PersonalTradeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    Key = '0'
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 703
    Top = 136
  end
  object spGet_PersonalTrade: TdsdStoredProc
    StoredProcName = 'gpGetMobile_Object_Const'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'MemberId'
        Value = '0'
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 152
  end
end
