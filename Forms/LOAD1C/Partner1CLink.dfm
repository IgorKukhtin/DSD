inherited Partner1CLinkForm: TPartner1CLinkForm
  Caption = #1057#1074#1103#1079#1100' '#1089' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084#1080' 1'#1057
  ClientHeight = 401
  ClientWidth = 1020
  ExplicitWidth = 1036
  ExplicitHeight = 440
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1020
    Height = 375
    ExplicitWidth = 1020
    ExplicitHeight = 375
    ClientRectBottom = 375
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 375
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 375
        ExplicitWidth = 1020
        ExplicitHeight = 375
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clJuridicalGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083'.'
            DataBinding.FieldName = 'JuridicalGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clINN: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colPartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Options.IncSearch = False
            Width = 45
          end
          object colPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoicePartnerForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.IncSearch = False
            Width = 120
          end
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076' 1'#1057
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' 1'#1057
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object colName_find1C: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' 1'#1057' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'Name_find1C'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object colOKPO_find1C: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' 1'#1057' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'OKPO_find1C'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clINN_find1C: TcxGridDBColumn
            Caption = #1048#1053#1053' 1'#1057' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'INN_find1C'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colBranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceBranchForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object clContractStateKindName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractStateKindCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1055#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 12
                Value = 1
              end
              item
                Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 11
                Value = 2
              end
              item
                Description = #1047#1072#1074#1077#1088#1096#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
                ImageIndex = 66
                Value = 4
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colContractNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractNumber'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceContractForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clEndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'EndDate'
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
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
      end
      object edBranch: TcxButtonEdit
        Left = 192
        Top = 40
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 1
        Width = 250
      end
      object cxLabel1: TcxLabel
        Left = 224
        Top = 24
        Caption = #1060#1080#1083#1080#1072#1083
      end
    end
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
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actChoiceBranchForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceBranchForm'
      FormName = 'TBranchLinkForm'
      FormNameParam.Value = 'TBranchLinkForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertRecordEmpty: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
    end
    object actInsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Params = <
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ShortCut = 16429
      ImageIndex = 54
    end
    object actChoiceContractForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceContractForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertPartner: TInsertUpdateChoiceAction
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      ImageIndex = 1
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'PartnerId'
    end
    object actChoicePartnerForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoicePartnerForm'
      FormName = 'TPartner1CLinkPlaceForm'
      FormNameParam.Value = 'TPartner1CLinkPlaceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetPointName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetPointName
      StoredProcList = <
        item
          StoredProc = spGetPointName
        end>
      Caption = 'actGetPointName'
    end
    object actInsertPartner1CLink: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertPartner1CLink
      StoredProcList = <
        item
          StoredProc = spInsertPartner1CLink
        end>
    end
    object actInsertPartner1CLinkAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertPartner1CLink
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1093' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' '#1080#1079' 1'#1057'?'
      InfoAfterExecute = #1053#1086#1074#1099#1077' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1080' '#1080#1079' 1'#1057' '#1076#1086#1073#1072#1074#1083#1077#1085#1099'.'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1093' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' '#1080#1079' 1'#1057
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1093' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' '#1080#1079' 1'#1057
      ImageIndex = 41
    end
    object actUpdatePartner1CLink_Partner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePartner1CLink_Partner
      StoredProcList = <
        item
          StoredProc = spUpdatePartner1CLink_Partner
        end>
      Caption = 'actUpdatePartner1CLink_Partner'
    end
    object actUpdatePartner1CLink_PartnerAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdatePartner1CLink_Partner
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1070#1088'.'#1083#1080#1094#1072', '#1044#1086#1075#1086#1074#1086#1088#1072', '#1058#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080'?'
      InfoAfterExecute = #1053#1086#1074#1099#1077' '#1070#1088'.'#1083#1080#1094#1072', '#1044#1086#1075#1086#1074#1086#1088#1072', '#1058#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080' '#1089#1086#1079#1076#1072#1085#1099'.'
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1070#1088'.'#1083#1080#1094#1072', '#1044#1086#1075#1086#1074#1086#1088#1072', '#1058#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1070#1088'.'#1083#1080#1094#1072', '#1044#1086#1075#1086#1074#1086#1088#1072', '#1058#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080
      ImageIndex = 30
    end
  end
  inherited MasterDS: TDataSource
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Partner1CLink'
    Top = 48
  end
  inherited BarManager: TdxBarManager
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertEmptyRecord'
        end
        item
          Visible = True
          ItemName = 'bbAddRecord'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertPartner'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertPartner1CLink'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdatePartner1CLink_Partner'
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
          ItemName = 'bbBranchLabel'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem'
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
    inherited dxBarStatic: TdxBarStatic [1]
    end
    object bbInsertEmptyRecord: TdxBarButton [2]
      Action = actInsertRecordEmpty
      Category = 0
    end
    object bbAddRecord: TdxBarButton [3]
      Action = actInsertRecord
      Category = 0
    end
    object bbInsertPartner: TdxBarButton [4]
      Action = actInsertPartner
      Category = 0
    end
    inherited bbRefresh: TdxBarButton [5]
    end
    object dxBarControlContainerItem: TdxBarControlContainerItem [6]
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edBranch
    end
    object bbBranchLabel: TdxBarControlContainerItem [7]
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbInsertPartner1CLink: TdxBarButton
      Action = actInsertPartner1CLinkAll
      Category = 0
    end
    object bbUpdatePartner1CLink_Partner: TdxBarButton
      Action = actUpdatePartner1CLink_PartnerAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColumnAddOnList = <
      item
        Column = colCode
        onExitColumn.Active = True
        onExitColumn.AfterEmptyValue = True
        onExitColumn.Action = actGetPointName
      end>
    Left = 224
    Top = 208
  end
  object BranchLinkGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranchLinkForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranchLinkForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 120
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Partner1CLink'
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
        Name = 'inCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
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
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchTopId'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
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
        Name = 'inIsSybase'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 216
  end
  object spGetPointName: TdsdStoredProc
    StoredProcName = 'gpGet_PointName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 168
  end
  object spInsertPartner1CLink: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_Partner1CLink'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inBranchTopId'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 256
  end
  object spUpdatePartner1CLink_Partner: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner1CLink_Partner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inBranchTopId'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 312
  end
end
