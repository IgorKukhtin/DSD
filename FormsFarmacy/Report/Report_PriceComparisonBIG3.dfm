inherited Report_PriceComparisonBIG3Form: TReport_PriceComparisonBIG3Form
  Caption = 'C'#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085' '#1089' '#1041#1048#1043'-3 ('#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084')'
  ClientHeight = 398
  ClientWidth = 1030
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1046
  ExplicitHeight = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 107
    Width = 1030
    Height = 291
    ExplicitTop = 107
    ExplicitWidth = 886
    ExplicitHeight = 291
    ClientRectBottom = 291
    ClientRectRight = 1030
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 886
      ExplicitHeight = 291
      inherited cxGrid: TcxGrid
        Left = 3
        Width = 1027
        Height = 291
        ExplicitLeft = 3
        ExplicitWidth = 883
        ExplicitHeight = 291
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1087#1080#1089#1077#1081' 0'
              Kind = skCount
              Column = GoodsName
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Caption = #1055#1088#1072#1081#1089
            end
            item
              Caption = #1041#1072#1076#1084
              Width = 152
            end
            item
              Caption = #1054#1087#1090#1080#1084#1072
              Width = 150
            end
            item
              Caption = #1042#1077#1085#1090#1072
              Width = 146
            end
            item
              Caption = #1051#1091#1095#1096#1072#1103' '#1088#1072#1079#1085#1080#1094#1072
              Width = 176
            end>
          object GoodsCode: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object GoodsName: TcxGridDBBandedColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 257
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Price: TcxGridDBBandedColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object Price1: TcxGridDBBandedColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object D1: TcxGridDBBandedColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'D1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Price2: TcxGridDBBandedColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 2
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object D2: TcxGridDBBandedColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'D2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 2
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Price3: TcxGridDBBandedColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 3
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object D3: TcxGridDBBandedColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'D3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 3
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object ContractNameBest: TcxGridDBBandedColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'ContractNameBest'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Content = dmMain.cxHeaderL4Style
            Width = 112
            Position.BandIndex = 4
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object DBest: TcxGridDBBandedColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'DBest'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+,0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Content = dmMain.cxHeaderL4Style
            Width = 63
            Position.BandIndex = 4
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 0
        Width = 3
        Height = 291
        Control = cxGrid
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 1030
    Height = 81
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 5
    ExplicitWidth = 886
    object edContractPriceList: TcxButtonEdit
      Left = 10
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 315
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 3
      Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090':'
    end
    object edAreaName: TcxTextEdit
      Left = 10
      Top = 49
      TabStop = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 151
    end
    object cxLabel1: TcxLabel
      Left = 346
      Top = 7
      Caption = #1041#1072#1076#1084':'
    end
    object cxDBTextEdit1: TcxDBTextEdit
      Left = 398
      Top = 6
      TabStop = False
      DataBinding.DataField = 'ContractName1'
      DataBinding.DataSource = MasterDS
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 289
    end
    object cxDBTextEdit2: TcxDBTextEdit
      Left = 693
      Top = 6
      TabStop = False
      DataBinding.DataField = 'AreaName1'
      DataBinding.DataSource = MasterDS
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 136
    end
    object cxDBTextEdit3: TcxDBTextEdit
      Left = 693
      Top = 30
      TabStop = False
      DataBinding.DataField = 'AreaName2'
      DataBinding.DataSource = MasterDS
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 136
    end
    object cxDBTextEdit4: TcxDBTextEdit
      Left = 398
      Top = 30
      TabStop = False
      DataBinding.DataField = 'ContractName2'
      DataBinding.DataSource = MasterDS
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 289
    end
    object cxLabel2: TcxLabel
      Left = 346
      Top = 31
      Caption = #1054#1087#1090#1080#1084#1072':'
    end
    object cxDBTextEdit5: TcxDBTextEdit
      Left = 693
      Top = 54
      TabStop = False
      DataBinding.DataField = 'AreaName3'
      DataBinding.DataSource = MasterDS
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 136
    end
    object cxDBTextEdit6: TcxDBTextEdit
      Left = 398
      Top = 54
      TabStop = False
      DataBinding.DataField = 'ContractName3'
      DataBinding.DataSource = MasterDS
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 289
    end
    object cxLabel4: TcxLabel
      Left = 346
      Top = 55
      Caption = #1042#1077#1085#1090#1072':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 387
    Top = 168
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = ContractPriceListGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = edAreaName
        Properties.Strings = (
          'Text')
      end>
    Left = 40
  end
  inherited ActionList: TActionList
    Left = 119
    object ExecuteDialog: TExecuteDialog [0]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TContractPriceListDialogForm'
      FormNameParam.Value = 'TContractPriceListDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ContractPriceListId'
          Value = ''
          Component = ContractPriceListGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractPriceListName'
          Value = ''
          Component = ContractPriceListGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AreaName'
          Value = False
          Component = edAreaName
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object dsdUpdateMaster: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'dsdUpdate'
      DataSource = MasterDS
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      StoredProcList = <
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    end
    object dsdUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actOpenUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenUnit'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenUser: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenUser'
      FormName = 'TUserNickForm'
      FormNameParam.Value = 'TUserNickForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    Left = 112
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 24
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_PriceComparisonBIG3'
    Params = <
      item
        Name = 'inLoadPriceListId'
        Value = Null
        Component = ContractPriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 280
    Top = 160
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
          ItemName = 'dxBarButton3'
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
    object dxBarButton1: TdxBarButton
      Action = dsdUnErased
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 216
  end
  inherited PopupMenu: TPopupMenu
    Left = 192
  end
  object ContractPriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractPriceList
    Key = '0'
    FormNameParam.Value = 'TContractPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = ContractPriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = Null
        Component = edAreaName
        MultiSelectSeparator = ','
      end>
    Left = 206
    Top = 20
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = ContractPriceListGuides
      end>
    Left = 280
    Top = 280
  end
end
