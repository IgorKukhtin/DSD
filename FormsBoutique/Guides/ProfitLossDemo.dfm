inherited ProfitLossDemoForm: TProfitLossDemoForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1052#1086#1076#1077#1083#1100' '#1086#1090#1095#1077#1090#1072' '#1076#1083#1103' '#1076#1077#1084#1086'-'#1074#1077#1088#1089#1080#1080'>'
  ClientHeight = 477
  ClientWidth = 586
  ExplicitWidth = 602
  ExplicitHeight = 515
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 586
    Height = 451
    ExplicitWidth = 586
    ExplicitHeight = 451
    ClientRectBottom = 451
    ClientRectRight = 586
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 586
      ExplicitHeight = 451
      inherited cxGrid: TcxGrid
        Width = 586
        Height = 451
        ExplicitWidth = 586
        ExplicitHeight = 451
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsSelection.MultiSelect = True
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 134
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 149
          end
          object ProfitLossCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090#1072#1090#1100#1080
            DataBinding.FieldName = 'ProfitLossCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ProfitLossName: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'ProfitLossName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 221
          end
          object Value: TcxGridDBColumn
            Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
            DataBinding.FieldName = 'Value'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
      end
      object edKoeff: TcxCurrencyEdit
        Left = 472
        Top = 78
        Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
        EditValue = '0'
        ParentShowHint = False
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####'
        ShowHint = True
        TabOrder = 1
        Width = 41
      end
      object cxLabel8: TcxLabel
        Left = 392
        Top = 79
        Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
        Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
      end
    end
  end
  inherited ActionList: TActionList
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
          ComponentItem = 'ProfitLossCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ProfitLossName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'KeyList'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValuelist'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'ProfitLossName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
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
          ComponentItem = 'ProfitLossName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Value_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Value_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
    end
    object macUpdate: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
      ImageIndex = 76
    end
    object macUpdate_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
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
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actOpenUserForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManagerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManagerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
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
    StoredProcName = 'gpSelect_Object_ProfitLossDemo'
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
          ItemName = 'bbChoice'
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
          ItemName = 'bbUpdateisOverList'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbUpdateisOverList: TdxBarButton
      Action = macUpdate
      Category = 0
    end
    object bbUpdateisOverNoList: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1053#1077#1090
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1053#1077#1090
      Visible = ivAlways
      ImageIndex = 58
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
      Control = cxLabel8
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edKoeff
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
  object spUpdate_Value_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProfitLossDemo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProfitLossId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ProfitLossId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = edKoeff
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 163
  end
end
