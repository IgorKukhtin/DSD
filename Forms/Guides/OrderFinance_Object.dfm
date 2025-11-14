inherited OrderFinance_ObjectForm: TOrderFinance_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1042#1080#1076#1099' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1087#1083#1072#1090#1077#1078#1077#1081'>'
  ClientHeight = 345
  ClientWidth = 819
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 835
  ExplicitHeight = 384
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 819
    Height = 319
    ExplicitWidth = 903
    ExplicitHeight = 319
    ClientRectBottom = 319
    ClientRectRight = 819
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 903
      ExplicitHeight = 319
      inherited cxGrid: TcxGrid
        Left = 3
        Width = 816
        Height = 319
        ExplicitLeft = -6
        ExplicitWidth = 569
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
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 35
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 157
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1088'/'#1089#1095#1077#1090', '#1089' '#1082#1086#1090#1086#1088#1086#1075#1086' '#1084#1099' '#1087#1083#1072#1090#1080#1084
            Options.Editing = False
            Width = 125
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object MemberName_insert: TcxGridDBColumn
            Caption = #1060#1048#1054' - '#1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'MemberName_insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 110
          end
          object UnitName_insert: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080')'
            DataBinding.FieldName = 'UnitName_insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object PositionName_insert: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080')'
            DataBinding.FieldName = 'PositionName_insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 107
          end
          object MemberName_1: TcxGridDBColumn
            Caption = #1060#1048#1054' - '#1085#1072' '#1082#1086#1085#1090#1088#1086#1083#1077'-1'
            DataBinding.FieldName = 'MemberName_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 110
          end
          object MemberName_2: TcxGridDBColumn
            Caption = #1060#1048#1054' - '#1085#1072' '#1082#1086#1085#1090#1088#1086#1083#1077'-2'
            DataBinding.FieldName = 'MemberName_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 110
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 0
        Width = 3
        Height = 319
        AutoPosition = False
        Control = cxGrid
        ExplicitLeft = 569
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
      end>
  end
  inherited ActionList: TActionList
    Left = 63
    Top = 231
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
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
          Name = 'BankAccountId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankAccountName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankAccountNameAll'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountNameAll'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId_insert'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId_insert'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName_insert'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName_insert'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId_1'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId_1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName_1'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName_1'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId_2'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId_2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName_2'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName_2'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      FormName = 'TOrderFinanceEditForm'
      FormNameParam.Value = 'TOrderFinanceEditForm'
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
      ImageIndex = 1
      FormName = 'TOrderFinanceEditForm'
      FormNameParam.Value = 'TOrderFinanceEditForm'
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
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
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
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 8
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_OrderFinance'
    Params = <
      item
        Name = 'inisErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 104
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
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
          ItemName = 'bbProtocolMaster'
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
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErased: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object bbSetErasedChild: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErasedChild: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 46
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
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
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1047#1072#1075#1088#1091#1079#1082#1080'>'
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1047#1072#1075#1088#1091#1079#1082#1080'>'
      Visible = ivAlways
      ImageIndex = 34
    end
    object bbInsertRecordChild: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1087#1083#1072#1090#1077#1078#1077#1081
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1087#1083#1072#1090#1077#1078#1077#1081
      Visible = ivAlways
      ImageIndex = 0
    end
    object bb: TdxBarButton
      Action = actShowErased
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    Left = 280
    Top = 192
  end
  object spInsertUpdateOrderFinance: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_OrderFinance'
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
    Left = 336
    Top = 91
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
end
