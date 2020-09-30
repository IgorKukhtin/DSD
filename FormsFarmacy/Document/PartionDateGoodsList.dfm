inherited PartionDateGoodsListForm: TPartionDateGoodsListForm
  Caption = #1054#1089#1090#1072#1090#1086#1082' '#1089#1088#1086#1082#1086#1074#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
  ClientHeight = 328
  ClientWidth = 568
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 584
  ExplicitHeight = 367
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 568
    Height = 302
    ExplicitWidth = 568
    ExplicitHeight = 302
    ClientRectBottom = 302
    ClientRectRight = 568
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 568
      ExplicitHeight = 302
      inherited cxGrid: TcxGrid
        Width = 568
        Height = 302
        ExplicitWidth = 568
        ExplicitHeight = 302
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 178
          end
          object ContainerID: TcxGridDBColumn
            Caption = #1048#1076#1077#1085#1090#1080#1092'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'ContainerID'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object PartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1089#1088#1086#1082#1072
            DataBinding.FieldName = 'PartionDateKindName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object Amount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
        end
      end
      object cbisAddNewLine: TcxCheckBox
        Left = 403
        Top = 55
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1086#1081' '#1089#1090#1088#1086#1082#1086#1081
        TabOrder = 1
        Width = 150
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 75
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 128
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 167
    inherited actRefresh: TdsdDataSetRefresh
      BeforeAction = actSetDefaultParams
    end
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContainerID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAddNewLine'
          Value = False
          Component = cbisAddNewLine
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
    end
    object actSetDefaultParams: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetDefaultParams'
      DefaultParams = <
        item
          Param.Name = 'isAddNewLine'
          Param.Value = Null
          Param.Component = cbisAddNewLine
          Param.DataType = ftBoolean
          Param.MultiSelectSeparator = ','
          Value = False
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 144
    Top = 120
  end
  inherited MasterCDS: TClientDataSet
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_PartionDateGoods'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 64
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
          ItemName = 'bbChoice'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbisAddNewLine
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 200
    Top = 176
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 120
  end
end
