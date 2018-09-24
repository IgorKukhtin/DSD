inherited PriceListLoad_AddForm: TPriceListLoad_AddForm
  Caption = #1060#1086#1088#1084#1072' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074' ('#1082#1086#1083'-'#1074#1086' '#1087#1086#1079#1080#1094#1080#1081')'
  ClientHeight = 399
  ClientWidth = 788
  AddOnFormData.Params = FormParams
  ExplicitWidth = 804
  ExplicitHeight = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 788
    Height = 373
    ExplicitWidth = 788
    ExplicitHeight = 373
    ClientRectBottom = 373
    ClientRectRight = 788
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 788
      ExplicitHeight = 373
      inherited cxGrid: TcxGrid
        Width = 788
        Height = 373
        ExplicitWidth = 788
        ExplicitHeight = 373
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = JuridicalName
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1075#1080#1086#1085' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 64
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 164
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentVert = vaCenter
            Width = 152
          end
          object MemberName: TcxGridDBColumn
            Caption = #1054#1090#1074'. '#1079#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1087#1088#1072#1081#1089
            Options.Editing = False
            Width = 87
          end
          object IsMoved: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1085#1077#1089#1077#1085#1086
            DataBinding.FieldName = 'IsMoved'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object NDSinPrice: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'NDSinPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object Amount_all: TcxGridDBColumn
            Caption = #1055#1086#1079#1080#1094#1080#1081' '#1074' '#1087#1088#1072#1081#1089#1077
            DataBinding.FieldName = 'Amount_all'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1079#1080#1094#1080#1081' '#1074' '#1087#1088#1072#1081#1089#1077' '#1074#1089#1077#1075#1086
            Options.Editing = False
            Width = 70
          end
          object Amount_tied: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1074'. '#1087#1086#1079'.'
            DataBinding.FieldName = 'Amount_tied'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080#1074#1103#1079#1072#1085#1085#1099#1093' '#1087#1086#1079#1080#1094#1080#1081
            Options.Editing = False
            Width = 70
          end
          object Amount_untied: TcxGridDBColumn
            Caption = #1053#1077#1090' '#1087#1088#1080#1074#1103#1079#1086#1082' '#1087#1086' '#1087#1086#1079'.'
            DataBinding.FieldName = 'Amount_untied'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1085#1077#1087#1088#1080#1074#1103#1079#1072#1085#1085#1099#1093' '#1087#1086#1079#1080#1094#1080#1081
            Options.Editing = False
            Width = 70
          end
        end
      end
      object cxLabel5: TcxLabel
        Left = 548
        Top = 60
        Caption = #1056#1077#1075#1080#1086#1085
      end
      object edArea: TcxButtonEdit
        Left = 548
        Top = 78
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 164
      end
    end
  end
  inherited ActionList: TActionList
    object actOpenPriceList: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1079#1072#1075#1088#1091#1078#1077#1085#1085#1086#1075#1086' '#1087#1088#1072#1081#1089#1072
      ShortCut = 13
      ImageIndex = 1
      FormName = 'TPriceListItemsLoadForm'
      FormNameParam.Value = 'TPriceListItemsLoadForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
    object actOneLoadPriceList: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGoods
      StoredProcList = <
        item
          StoredProc = spUpdateGoods
        end
        item
          StoredProc = spLoadPriceList
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
    end
    object actLoadPriceList: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGoods
      StoredProcList = <
        item
          StoredProc = spUpdateGoods
        end
        item
          StoredProc = spLoadPriceList
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
      ImageIndex = 27
      InfoAfterExecute = #1055#1088#1072#1081#1089' '#1091#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1077#1085
    end
    object mactLoadPrice1: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOneLoadPriceList
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
      ImageIndex = 27
    end
    object mactLoadPriceList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mactLoadPrice1
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1055#1088#1072#1081#1089#1099' '#1091#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
      ImageIndex = 27
    end
    object actDeletePriceListLoad: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete
      StoredProcList = <
        item
          StoredProc = spDelete
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
      Hint = #1059#1076#1072#1083#1077#1085#1080#1077' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actGetMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetMovement
      StoredProcList = <
        item
          StoredProc = spGetMovement
        end>
      Caption = #1086#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 8
    end
    object actOpenMovementPriceList: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      ShortCut = 115
      ImageIndex = 8
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object MacGetMovement: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetMovement
        end
        item
          Action = actOpenMovementPriceList
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'>'
      ImageIndex = 28
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LoadPriceList_Add'
    Top = 80
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbGetMovement'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpen'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
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
          ItemName = 'bbText'
        end
        item
          Visible = True
          ItemName = 'bbedArea'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoadPriceList'
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
    object bbOpen: TdxBarButton
      Action = actOpenPriceList
      Category = 0
    end
    object bbLoadPriceList: TdxBarButton
      Action = actLoadPriceList
      Category = 0
    end
    object bbDelete: TdxBarButton
      Action = actDeletePriceListLoad
      Category = 0
    end
    object bbGetMovement: TdxBarButton
      Action = MacGetMovement
      Category = 0
    end
    object bbText: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel5
    end
    object bbedArea: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edArea
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenPriceList
      end>
    SearchAsFilter = False
  end
  inherited PopupMenu: TPopupMenu
    object N3: TMenuItem
      Action = mactLoadPriceList
    end
  end
  object spLoadPriceList: TdsdStoredProc
    StoredProcName = 'gpLoadPriceList'
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
      end>
    PackSize = 1
    Left = 216
    Top = 152
  end
  object spUpdateGoods: TdsdStoredProc
    StoredProcName = 'gpUpdatePartnerGoods'
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
      end>
    PackSize = 1
    Left = 216
    Top = 120
  end
  object spDelete: TdsdStoredProc
    StoredProcName = 'gpDelete_Movement_LoadPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPriceListId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 72
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 432
    Top = 120
  end
  object spGetMovement: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_by_LoadPriceList'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'outId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
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
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 72
  end
  object GuidesArea: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 104
  end
end
