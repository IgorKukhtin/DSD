inherited DiscountDialogForm: TDiscountDialogForm
  ActiveControl = ceDiscountExternal
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' - '#1055#1088#1086#1077#1082#1090' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
  ClientHeight = 375
  ClientWidth = 556
  Position = poScreenCenter
  ExplicitWidth = 562
  ExplicitHeight = 404
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 8
    Width = 41
    Height = 13
    Caption = #1055#1088#1086#1077#1082#1090':'
  end
  object Label2: TLabel [1]
    Left = 295
    Top = 8
    Width = 115
    Height = 13
    Caption = #8470' '#1076#1080#1089#1082#1086#1085#1090#1085#1086#1081' '#1082#1072#1088#1090#1099':'
  end
  inherited bbOk: TcxButton
    Left = 134
    Top = 336
    Anchors = [akLeft, akBottom]
    ModalResult = 0
    OnClick = bbOkClick
    ExplicitLeft = 134
    ExplicitTop = 339
  end
  inherited bbCancel: TcxButton
    Left = 344
    Top = 336
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 344
    ExplicitTop = 336
  end
  object ceDiscountExternal: TcxButtonEdit [4]
    Left = 16
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1084#1077#1085#1077#1076#1078#1077#1088#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 2
    Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1087#1088#1086#1077#1082#1090#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Width = 265
  end
  object edCardNumber: TcxTextEdit [5]
    Left = 295
    Top = 27
    TabOrder = 3
    Width = 250
  end
  object ListGoodsGrid: TcxGrid [6]
    Left = 3
    Top = 72
    Width = 550
    Height = 249
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    object ListGoodsGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = RemainsDiscountDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colGoodsName
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 309
      end
      object colPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00; -,0.00; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 64
      end
      object colAmount: TcxGridDBColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082'.'
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000;-,0.000; ;'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 68
      end
    end
    object ListGoodsGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListGoodsGridDBTableView
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 112
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 112
  end
  inherited ActionList: TActionList
    Top = 111
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'URL'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Service'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 112
  end
  object DiscountExternalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDiscountExternal
    FormNameParam.Value = 'TDiscountExternal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDiscountExternal_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DiscountExternalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DiscountExternalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    OnAfterChoice = DiscountExternalGuidesAfterChoice
    Left = 128
    Top = 16
  end
  object spDiscountExternal_Search: TdsdStoredProc
    StoredProcName = 'gpGet_Object_DiscountExternal_Search'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiscountExternalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiscountExternalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 438
    Top = 112
  end
  object spLoadRemainsDiscount: TdsdStoredProc
    StoredProcName = 'gpSelect_DiscountExternal_RemainsUnit'
    DataSet = RemainsDiscountCDS
    DataSets = <
      item
        DataSet = RemainsDiscountCDS
      end>
    Params = <>
    PackSize = 1
    Left = 438
    Top = 168
  end
  object RemainsDiscountDS: TDataSource
    DataSet = RemainsDiscountCDS
    Left = 304
    Top = 192
  end
  object RemainsDiscountCDS: TClientDataSet
    Aggregates = <>
    Filter = 'ObjectId = 0'
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    StoreDefs = True
    Left = 208
    Top = 192
  end
end
