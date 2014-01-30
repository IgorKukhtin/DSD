object ContractForm: TContractForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072'>'
  ClientHeight = 473
  ClientWidth = 1170
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 1170
    Height = 303
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clComment
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clInvNumberArchive: TcxGridDBColumn
        Caption = #8470' '#1072#1088#1093#1080#1074'.'
        DataBinding.FieldName = 'InvNumberArchive'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object clInvNumber: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clJuridicalCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
        DataBinding.FieldName = 'JuridicalCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object clJuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = JuridicalChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object clOKPO: TcxGridDBColumn
        Caption = #1054#1050#1055#1054
        DataBinding.FieldName = 'OKPO'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object clPaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PaidKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object clSigningDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'SigningDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object clStartDate: TcxGridDBColumn
        Caption = #1044#1077#1081#1089#1090#1074'. '#1089
        DataBinding.FieldName = 'StartDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object clEndDate: TcxGridDBColumn
        Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
        DataBinding.FieldName = 'EndDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object clContractKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'ContractKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContractKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object clInfoMoneyGroupCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' '#1075#1088#1091#1087#1087#1099
        DataBinding.FieldName = 'InfoMoneyGroupCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object clInfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = InfoMoneyChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 113
      end
      object clInfoMoneyDestinationCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' '#1085#1072#1079#1085#1072#1095'.'
        DataBinding.FieldName = 'InfoMoneyDestinationCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object clInfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clInfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = InfoMoneyChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object clInfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = InfoMoneyChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clPersonalName: TcxGridDBColumn
        Caption = #1054#1090#1074'.'#1089#1086#1090#1088#1091#1076#1085#1080#1082
        DataBinding.FieldName = 'PersonalName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object clAreaName: TcxGridDBColumn
        Caption = #1056#1077#1075#1080#1086#1085
        DataBinding.FieldName = 'AreaName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object clContractArticleName: TcxGridDBColumn
        Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'ContractArticleName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object clContractStateKindName: TcxGridDBColumn
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'ContractStateKindName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object clJuridicalBasisName: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalBasisName'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object clComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object clIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxGridContractCondition: TcxGrid
    Left = 0
    Top = 329
    Width = 1170
    Height = 144
    Align = alBottom
    TabOrder = 5
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableViewContractCondition: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ContractConditionDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object cContractConditionKindName: TcxGridDBColumn
        Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'ContractConditionKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContractConditionKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 300
      end
      object clValue: TcxGridDBColumn
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'Value'
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object clsfcisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Width = 60
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableViewContractCondition
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 96
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    MasterFields = 'Id'
    Params = <>
    Left = 64
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = clComment
        Properties.Strings = (
          'Width')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 248
    Top = 72
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 152
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
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
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecCCK'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '    '
      Category = 0
      Hint = '    '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbInsertRecCCK: TdxBarButton
      Action = InsertRecordCCK
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 248
    Top = 136
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end
        item
          StoredProc = spSelectContractCondition
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object PaidKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'PaidKindChoiceForm'
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TContractEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'JuridicalId'
          Value = 0
        end
        item
          Name = 'JuridicalName'
          Value = ''
          DataType = ftString
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TContractEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'JuridicalId'
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'JuridicalName'
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object ContractKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'ContractKindChoiceForm'
      FormName = 'TContractKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'ContractKindId'
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'ContractKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
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
      DataSource = DataSource
    end
    object InfoMoneyChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'InfoMoneyChoiceForm'
      FormName = 'TInfoMoney_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyCode'
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyCode'
        end
        item
          Name = 'InfoMoneyGroupId'
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyGroupId'
        end
        item
          Name = 'InfoMoneyGroupName'
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyGroupName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object JuridicalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'JuridicalChoiceForm'
      FormName = 'TJuridical_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyId'
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'InfoMoneyName'
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'OKPO'
          Component = ClientDataSet
          ComponentItem = 'OKPO'
          DataType = ftString
        end
        item
          Name = 'JuridicalCode'
          Component = ClientDataSet
          ComponentItem = 'JuridicalCode'
        end>
      isShowModal = True
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
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
      DataSource = DataSource
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      Params = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = ClientDataSet
          ComponentItem = 'InvNumber'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ContractConditionKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'ContractConditionKindChoiceForm'
      FormName = 'TContractConditionKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindId'
        end
        item
          Name = 'TextValue'
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindName'
          DataType = ftString
        end
        item
          Name = 'inContractId'
          Value = 0
        end>
      isShowModal = False
    end
    object InsertRecordCCK: TInsertRecord
      Category = 'DSDLib'
      View = cxGridDBTableViewContractCondition
      Action = ContractConditionKindChoiceForm
      Caption = 'InsertRecordCCK'
      Hint = #1058#1080#1087' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 0
    end
    object actContractCondition: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateContractCondition
      StoredProcList = <
        item
          StoredProc = spInsertUpdateContractCondition
        end>
      Caption = 'actUpdateDataSetCCK'
      DataSource = ContractConditionDS
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = dsdStoredProc
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Contract'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    Left = 216
    Top = 224
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 104
    Top = 208
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 160
    Top = 160
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actUpdate
      end
      item
        Action = dsdChoiceGuides
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 272
    Top = 184
  end
  object ContractConditionDS: TDataSource
    DataSet = ContractConditionCDS
    Left = 102
    Top = 413
  end
  object ContractConditionCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ContractId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 225
    Top = 413
  end
  object spInsertUpdateContractCondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ContractConditionCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inValue'
        Component = ContractConditionCDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inContractConditionKindId'
        Component = ContractConditionCDS
        ComponentItem = 'ContractConditionKindId'
        ParamType = ptInput
      end>
    Left = 368
    Top = 416
  end
  object spSelectContractCondition: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractCondition'
    DataSet = ContractConditionCDS
    DataSets = <
      item
        DataSet = ContractConditionCDS
      end>
    Params = <>
    Left = 514
    Top = 397
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Component = ClientDataSet
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'inInvNumber'
        Component = ClientDataSet
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberArchive'
        Component = ClientDataSet
        ComponentItem = 'InvNumberArchive'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = ClientDataSet
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inSigningDate'
        Component = ClientDataSet
        ComponentItem = 'SigningDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inStartDate'
        Component = ClientDataSet
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Component = ClientDataSet
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Component = ClientDataSet
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalBasisId'
        Component = ClientDataSet
        ComponentItem = 'JuridicalBasisId'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Component = ClientDataSet
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
      end
      item
        Name = 'inContractKindId'
        Component = ClientDataSet
        ComponentItem = 'ContractKindId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Component = ClientDataSet
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalId'
        Component = ClientDataSet
        ComponentItem = 'PersonalId'
        ParamType = ptInput
      end
      item
        Name = 'inAreaId'
        Component = ClientDataSet
        ComponentItem = 'AreaId'
        ParamType = ptInput
      end
      item
        Name = 'inContractArticleId'
        Component = ClientDataSet
        ComponentItem = 'ContractArticleId'
        ParamType = ptInput
      end
      item
        Name = 'inContractStateKindId'
        Component = ClientDataSet
        ComponentItem = 'ContractStateKindId'
        ParamType = ptInput
      end>
    Left = 432
    Top = 176
  end
end
