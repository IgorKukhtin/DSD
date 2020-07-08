inherited HouseholdInventoryForm: THouseholdInventoryForm
  Caption = #1061#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1099#1081' '#1080#1085#1074#1077#1085#1090#1072#1088#1100
  ClientHeight = 374
  ClientWidth = 773
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 789
  ExplicitHeight = 413
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 773
    Height = 348
    ExplicitWidth = 833
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 773
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 833
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 773
        Height = 348
        ExplicitWidth = 833
        ExplicitHeight = 348
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 653
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Width = 92
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'THouseholdInventoryEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'THouseholdInventoryEditForm'
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_HouseholdInventory'
    Params = <
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
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
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Category = 0
      Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton2: TdxBarButton
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1083#1091#1095#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Category = 0
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1083#1091#1095#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1072#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1095#1072#1089#1090#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1072#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1095#1072#1089#1090#1100
      Visible = ivAlways
      ImageIndex = 52
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
  end
  inherited spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_HouseholdInventory_IsErased'
    Left = 56
    Top = 136
  end
end
