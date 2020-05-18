inherited UnitForOrderInternalPromoForm: TUnitForOrderInternalPromoForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'> ('#1079#1072#1103#1074#1082#1080' '#1074#1085'. ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099'))'
  ClientHeight = 420
  ClientWidth = 531
  ExplicitWidth = 547
  ExplicitHeight = 458
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 531
    Height = 394
    ExplicitWidth = 699
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 531
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 699
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 531
        Height = 394
        ExplicitWidth = 699
        ExplicitHeight = 394
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 184
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 123
          end
          object isOrderPromo: TcxGridDBColumn
            Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099')'
            DataBinding.FieldName = 'isOrderPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099')'
            Options.Editing = False
            Width = 92
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object macUpdateisOrderPromo_No: TMultiAction [2]
      Category = 'OrderPromo'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateisOrderPromoL_No
        end
        item
          Action = actRefresh
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1053#1077#1090
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1053#1077#1090
      ImageIndex = 58
    end
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
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
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
          Name = 'KeyList'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValuelist'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'ceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object macUpdateisOrderPromo_Yes: TMultiAction
      Category = 'OrderPromo'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateisOrderPromoL_Yes
        end
        item
          Action = actRefresh
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1044#1072
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1044#1072
      ImageIndex = 76
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
    object actUpdateOrderPromo_No: TdsdExecStoredProc
      Category = 'OrderPromo'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_OrderPromo_No
      StoredProcList = <
        item
          StoredProc = spUpdate_OrderPromo_No
        end>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1053#1077#1090
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1053#1077#1090
    end
    object actUpdateOrderPromo_Yes: TdsdExecStoredProc
      Category = 'OrderPromo'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_OrderPromo_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_OrderPromo_Yes
        end>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1044#1072
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1044#1072
    end
    object macUpdateisOrderPromoL_No: TMultiAction
      Category = 'OrderPromo'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateOrderPromo_No
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1053#1077#1090
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1053#1077#1090
      ImageIndex = 58
    end
    object macUpdateisOrderPromoL_Yes: TMultiAction
      Category = 'OrderPromo'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateOrderPromo_Yes
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1044#1072
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1079#1072#1082#1072#1079' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099') - '#1044#1072
      ImageIndex = 76
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitForOrderInternalPromo'
    Params = <
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 128
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
          ItemName = 'bbUpdateisGoodsCategoryYes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisGoodsCategoryNo'
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
    object bbUpdateisGoodsCategoryYes: TdxBarButton
      Action = macUpdateisOrderPromo_Yes
      Category = 0
    end
    object bbUpdateisGoodsCategoryNo: TdxBarButton
      Action = macUpdateisOrderPromo_No
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
  object spUpdate_OrderPromo_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_OrderPromo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrderPromo'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 155
  end
  object spUpdate_OrderPromo_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_OrderPromo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrderPromo'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 203
  end
end
