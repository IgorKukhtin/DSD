inherited PartionGoodsAssetChoiceForm: TPartionGoodsAssetChoiceForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1086#1074' (OC)>'
  ClientHeight = 399
  ClientWidth = 853
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 869
  ExplicitHeight = 438
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 57
    Width = 853
    Height = 342
    ExplicitTop = 57
    ExplicitWidth = 853
    ExplicitHeight = 342
    ClientRectBottom = 342
    ClientRectRight = 853
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 853
      ExplicitHeight = 342
      inherited cxGrid: TcxGrid
        Width = 853
        Height = 342
        ExplicitWidth = 853
        ExplicitHeight = 342
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
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            Width = 80
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 244
          end
          object InvNumber: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 147
          end
          object PartNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091
            DataBinding.FieldName = 'PartNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PartionModelName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100
            DataBinding.FieldName = 'PartionModelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderGlyphAlignmentVert = vaTop
            Width = 60
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 176
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object StorageName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'StorageName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object UnitName_Storage: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
            DataBinding.FieldName = 'UnitName_Storage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 126
          end
          object BranchName_Storage: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
            DataBinding.FieldName = 'BranchName_Storage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object AreaUnitName_Storage: TcxGridDBColumn
            Caption = #1059#1095#1072#1089#1090#1086#1082' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
            DataBinding.FieldName = 'AreaUnitName_Storage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object Room_Storage: TcxGridDBColumn
            Caption = #1050#1072#1073#1080#1085#1077#1090' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
            DataBinding.FieldName = 'Room_Storage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object Address_Storage: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089' ('#1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103')'
            DataBinding.FieldName = 'Address_Storage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 127
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 853
    Height = 31
    Align = alTop
    TabOrder = 5
    object edGoods: TcxButtonEdit
      Left = 433
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 300
    end
    object cxLabel3: TcxLabel
      Left = 393
      Top = 7
      Caption = #1058#1086#1074#1072#1088
    end
  end
  object cxLabel1: TcxLabel [2]
    Left = 4
    Top = 7
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit [3]
    Left = 94
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 283
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 200
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Left = 95
    inherited ChoiceGuides: TdsdChoiceGuides
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
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageId'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartion'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Amount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionModelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionModelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionModelName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionModelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName_Storage'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName_Storage'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchName_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AreaUnitName_Storage'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaUnitName_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Room_Storage'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Room_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Address_Storage'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Address_Storage'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
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
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 82
  end
  inherited MasterCDS: TClientDataSet
    Top = 82
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PartionGoodsAsset'
    Params = <
      item
        Name = 'inGoodsId'
        Value = '0'
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = '0'
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 82
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 66
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
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
          ItemName = 'bbChoice'
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
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 600
    Top = 120
  end
  inherited PopupMenu: TPopupMenu
    Left = 160
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inUnitId'
        Value = '0'
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '0'
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 152
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 576
    Top = 3
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end
      item
        Component = GoodsGuides
      end>
    Left = 712
    Top = 120
  end
end
