inherited SupplierFailuresForm: TSupplierFailuresForm
  Caption = #1054#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 339
  ClientWidth = 942
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
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
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1088#1086#1082' 0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isSupplierFailures: TcxGridDBColumn
            Caption = #1054#1090#1082#1072#1079' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'isSupplierFailures'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
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
          object DateUpdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateUpdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 117
          end
          object UserUpdate: TcxGridDBColumn
            Caption = #1050#1090#1086' '#1080#1079#1084#1077#1085#1080#1083
            DataBinding.FieldName = 'UserUpdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 118
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
      object edSupplierFailures: TcxDateEdit
        Left = 653
        Top = 71
        EditValue = 42132d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 2
        Width = 100
      end
      object cxLabel2: TcxLabel
        Left = 653
        Top = 53
        Caption = #1054#1090#1082#1072#1079#1099' '#1085#1072' '#1076#1072#1090#1091
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
      end
      item
        Component = edSupplierFailures
        Properties.Strings = (
          'Date')
      end>
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 103
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
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
    object mactUpdate_SupplierFailures: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_SupplierFailures
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'"'
      ImageIndex = 52
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = edSupplierFailures
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdate_SupplierFailures: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SupplierFailures
      StoredProcList = <
        item
          StoredProc = spUpdate_SupplierFailures
        end>
      Caption = 'actUpdate_SupplierFailures'
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 24
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_PriceList_SupplierFailures'
    Params = <
      item
        Name = 'inOperdate'
        Value = Null
        Component = edSupplierFailures
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 232
    Top = 88
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
          ItemName = 'dxBarButton5'
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
          ItemName = 'bbRefresh'
        end
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
          ItemName = 'bbUpdate_SupplierFailures'
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
    inherited dxBarStatic: TdxBarStatic
      Left = 368
      Top = 112
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
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object dxBarButton2: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbUpdate_SupplierFailures: TdxBarButton
      Action = mactUpdate_SupplierFailures
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel2
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edSupplierFailures
    end
    object dxBarButton5: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 336
    Top = 168
  end
  inherited PopupMenu: TPopupMenu
    Left = 192
  end
  object spUpdate_SupplierFailures: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PriceList_SupplierFailures'
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
        Name = 'inisSupplierFailures'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSupplierFailures'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 232
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = edSupplierFailures
      end
      item
      end>
    Left = 336
    Top = 240
  end
end
