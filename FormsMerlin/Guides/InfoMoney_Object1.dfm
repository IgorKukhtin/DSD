inherited InfoMoney_ObjectForm: TInfoMoney_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1057#1090#1072#1090#1100#1080' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 374
  ClientWidth = 624
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 640
  ExplicitHeight = 412
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 624
    Height = 348
    ExplicitWidth = 624
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 624
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 624
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 624
        Height = 348
        ExplicitWidth = 624
        ExplicitHeight = 348
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
          object GroupNameFull: TcxGridDBColumn
            Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1099
            DataBinding.FieldName = 'GroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 126
          end
          object ParentName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'ParentName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 116
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 172
          end
          object isUserAll: TcxGridDBColumn
            Caption = #1044#1086#1089#1090#1091#1087' '#1042#1089#1077#1084
            DataBinding.FieldName = 'isUserAll'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1089#1090#1091#1087' '#1042#1089#1077#1084' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 60
          end
          object isService: TcxGridDBColumn
            Caption = #1055#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1102
            DataBinding.FieldName = 'isService'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1102' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 83
          end
          object InfoMoneyKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1055#1088#1080#1093#1086#1076'/ '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'InfoMoneyKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TInsertUpdateChoiceAction
      Enabled = False
      FormName = 'TCashEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TCashEditForm'
    end
    inherited dsdSetUnErased: TdsdUpdateErased
      Enabled = False
    end
    inherited dsdSetErased: TdsdUpdateErased
      Enabled = False
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
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
          Name = 'isUserAll'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isUserAll'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isService'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isService'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyKindid'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyKindid'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyKindName'
          DataType = ftString
          ParamType = ptInput
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
    Left = 56
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_InfoMoney'
    Params = <
      item
        Name = 'inIsShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 80
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
          BeginGroup = True
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
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbEdit: TdxBarButton
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end>
  end
end
