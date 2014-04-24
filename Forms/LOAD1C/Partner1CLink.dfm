inherited Partner1CLinkForm: TPartner1CLinkForm
  Caption = #1057#1074#1103#1079#1100' '#1089' '#1090#1086#1095#1082#1072#1084#1080' '#1076#1086#1089#1090#1072#1074#1082#1080' '#1089' 1'#1057
  ClientHeight = 401
  ClientWidth = 877
  ExplicitWidth = 885
  ExplicitHeight = 428
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 877
    Height = 375
    ExplicitWidth = 877
    ExplicitHeight = 375
    ClientRectBottom = 375
    ClientRectRight = 877
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 877
      ExplicitHeight = 375
      inherited cxGrid: TcxGrid
        Width = 877
        Height = 375
        ExplicitWidth = 877
        ExplicitHeight = 375
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            Options.Editing = False
            Width = 189
          end
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PartnerCode'
            Options.Editing = False
            Options.IncSearch = False
            Width = 65
          end
          object colName: TcxGridDBColumn
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
            Options.IncSearch = False
            Width = 239
          end
          object colDetailCode: TcxGridDBColumn
            Caption = #1050#1086#1076' 1'#1057
            DataBinding.FieldName = 'Code'
            Width = 58
          end
          object colDetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 1'#1057
            DataBinding.FieldName = 'Name'
            Width = 121
          end
          object colDetailBranch: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceBranchForm
                Default = True
                Kind = bkEllipsis
              end>
            Width = 107
          end
          object colDetailContract: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractNumber'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceContractForm
                Default = True
                Kind = bkEllipsis
              end>
            Width = 84
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
        Width = 177
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
      Caption = 'actChoiceBranchForm'
      FormName = 'TBranchForm'
      FormNameParam.Value = 'TBranchForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actInsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      View = cxGridDBTableView
      Params = <
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      ShortCut = 45
      ImageIndex = 0
    end
    object actChoiceContractForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoiceContractForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actInsertPartner: TInsertUpdateChoiceAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      ImageIndex = 27
      FormName = 'TPartnerJuridicalEditForm'
      FormNameParam.Value = 'TPartnerJuridicalEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'Id'
          Value = '0'
        end
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end>
      isShowModal = True
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'PartnerId'
      PostDataSetBeforeExecute = False
    end
    object actChoicePartnerForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoicePartnerForm'
      FormName = 'TPartnerForm'
      FormNameParam.Value = 'TPartnerForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actGetPointName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGetPointName
      StoredProcList = <
        item
          StoredProc = spGetPointName
        end>
      Caption = 'actGetPointName'
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
          ItemName = 'bbRefresh'
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
          ItemName = 'bbBranchLabel'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem'
        end>
    end
    object dxBarControlContainerItem: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edBranch
    end
    object bbAddRecord: TdxBarButton
      Action = actInsertRecord
      Category = 0
    end
    object bbInsertPartner: TdxBarButton
      Action = actInsertPartner
      Category = 0
    end
    object bbBranchLabel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColumnAddOnList = <
      item
        Column = colDetailCode
        onExitColumn.Active = True
        onExitColumn.AfterEmptyValue = True
        onExitColumn.Action = actGetPointName
      end>
    Left = 224
    Top = 208
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranchForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
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
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inCode'
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPartnerId'
        Component = MasterCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchTopId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inIsSybase'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Component = MasterCDS
        ComponentItem = 'Id'
      end
      item
        Name = 'BranchId'
        Component = MasterCDS
        ComponentItem = 'BranchId'
      end
      item
        Name = 'BranchName'
        Component = MasterCDS
        ComponentItem = 'BranchName'
        DataType = ftString
      end>
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
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'ioName'
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInputOutput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 344
    Top = 168
  end
end
