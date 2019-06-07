inherited CreditLimitDistributorForm: TCreditLimitDistributorForm
  Caption = #1050#1088#1077#1076#1080#1090#1085#1099#1077' '#1083#1080#1084#1080#1090#1099' '#1087#1086' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1086#1088#1091
  ClientHeight = 339
  ClientWidth = 600
  AddOnFormData.isAlwaysRefresh = False
  ExplicitWidth = 616
  ExplicitHeight = 378
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 600
    Height = 313
    ExplicitWidth = 522
    ExplicitHeight = 313
    ClientRectBottom = 313
    ClientRectRight = 600
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 522
      ExplicitHeight = 313
      inherited cxGrid: TcxGrid
        Left = 3
        Width = 597
        Height = 313
        ExplicitLeft = 3
        ExplicitWidth = 519
        ExplicitHeight = 313
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.FocusCellOnCycle = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsSelection.InvertSelect = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object ProviderName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'ProviderName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 232
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' '#1085#1072#1096#1077
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 186
          end
          object CreditLimit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090#1085#1099#1081' '#1083#1080#1084#1080#1090
            DataBinding.FieldName = 'CreditLimit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object isErased: TcxGridDBColumn
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 0
        Width = 3
        Height = 313
        Control = cxGrid
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
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TCreditLimitDistributorEditForm'
      FormNameParam.Value = 'TCreditLimitDistributorEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TCreditLimitDistributorEditForm'
      FormNameParam.Value = 'TCreditLimitDistributorEditForm'
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
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 72
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_CreditLimitJuridical'
    Left = 112
    Top = 64
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
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
      Left = 368
      Top = 112
    end
    object bbSetErased: TdxBarButton
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Category = 0
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1077#1088#1077#1097#1077#1090#1072' '#1053#1058#1047
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErased: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1077#1097#1077#1090#1072' '#1053#1058#1047
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object bbSetErasedChild: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErasedChild: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object bbdsdChoiceGuides: TdxBarButton
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Visible = ivAlways
      ImageIndex = 7
    end
    object dxBarButton1: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = 'MultiAction1'
      Category = 0
      Visible = ivAlways
      ImageIndex = 2
    end
    object dxBarButton4: TdxBarButton
      Caption = 'MultiAction2'
      Category = 0
      Visible = ivAlways
      ImageIndex = 8
    end
    object dxBarButton5: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbInsertUpdateMovement: TdxBarButton
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1077#1085#1080#1103' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1072#1079#1076#1085#1080#1082#1086#1074
      Category = 0
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1077#1085#1080#1103' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1072#1079#1076#1085#1080#1082#1086#1074
      Visible = ivAlways
      ImageIndex = 14
      ShortCut = 113
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    Left = 280
    Top = 192
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 72
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'IdAdd'
    IdParam.MultiSelectSeparator = ','
    ControlList = <
      item
      end
      item
      end>
    Left = 448
    Top = 105
  end
end
