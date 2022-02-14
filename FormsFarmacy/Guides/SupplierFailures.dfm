inherited SupplierFailuresForm: TSupplierFailuresForm
  Caption = #1054#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 339
  ClientWidth = 942
  AddOnFormData.isAlwaysRefresh = False
  ExplicitWidth = 958
  ExplicitHeight = 378
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 942
    Height = 313
    ExplicitWidth = 942
    ExplicitHeight = 313
    ClientRectBottom = 313
    ClientRectRight = 942
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 942
      ExplicitHeight = 313
      inherited cxGrid: TcxGrid
        Left = 3
        Width = 939
        Height = 313
        ExplicitLeft = 3
        ExplicitWidth = 939
        ExplicitHeight = 313
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
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
            Width = 36
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'actOpenUser'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 191
          end
          object GoodsJuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'GoodsJuridicalCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object GoodsJuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsJuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'actOpenJuridical'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 209
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 134
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
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
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object dsdUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
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
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    StoredProcName = 'gpSelect_Object_SupplierFailures'
    Params = <
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
          ItemName = 'bbSetErased'
        end
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
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarButton3'
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
      Action = dsdSetErased
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
    end
    object bbUnErased: TdxBarButton
      Action = dsdUnErased
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
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
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton1: TdxBarButton
      Action = dsdUnErased
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 192
  end
  object spInsertUpdateSupplierFailures: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_SupplierFailures'
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
        Name = 'inCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriorities  '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Priorities'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 123
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
