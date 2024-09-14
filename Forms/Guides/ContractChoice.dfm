inherited ContractChoiceForm: TContractChoiceForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072'>'
  ClientHeight = 496
  ClientWidth = 853
  AddOnFormData.Params = FormParams
  ExplicitWidth = 869
  ExplicitHeight = 535
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 853
    Height = 470
    ExplicitWidth = 853
    ExplicitHeight = 470
    ClientRectBottom = 470
    ClientRectRight = 853
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 853
      ExplicitHeight = 470
      inherited cxGrid: TcxGrid
        Width = 853
        Height = 470
        ExplicitWidth = 853
        ExplicitHeight = 470
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
          object ContractStateKindName: TcxGridDBColumn
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
            Width = 76
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ContractKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CurrencyName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072
            DataBinding.FieldName = 'CurrencyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'. '#1083'.'
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '(-)% '#1089#1082'. (+)% '#1085#1072#1094
            DataBinding.FieldName = 'ChangePercent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ContractComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractComment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isRealEx: TcxGridDBColumn
            Caption = #1060#1080#1079'. '#1086#1073#1084#1077#1085
            DataBinding.FieldName = 'isRealEx'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1079'. '#1086#1073#1084#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 46
          end
          object isNotTareReturning: TcxGridDBColumn
            Caption = #1053#1077#1090' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1090#1072#1088#1099
            DataBinding.FieldName = 'isNotTareReturning'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
        end
      end
    end
  end
  object cxLabel6: TcxLabel [1]
    Left = 172
    Top = 78
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
  end
  object edJuridical: TcxButtonEdit [2]
    Left = 279
    Top = 76
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 245
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
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
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName_all'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName_all'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalBasisId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalBasisId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalBasisName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalBasisName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractTagId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractTagName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChangePercent'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CurrencyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CurrencyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractStateKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractStateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractStateKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractStateKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RetailId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RetailName'
          DataType = ftString
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
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1079#1072#1082#1088#1099#1090#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1079#1072#1082#1088#1099#1090#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
  end
  inherited MasterDS: TDataSource
    Top = 82
  end
  inherited MasterCDS: TClientDataSet
    Top = 82
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractChoice'
    Params = <
      item
        Name = 'inPaidKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inPaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 82
  end
  inherited BarManager: TdxBarManager
    Top = 82
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
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbJuridicalLabel'
        end
        item
          Visible = True
          ItemName = 'bbJuridical'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoice'
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
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbJuridicalLabel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
      Control = cxLabel6
    end
    object bbJuridical: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
      Control = edJuridical
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inPaidKindId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 152
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 88
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = JuridicalGuides
      end>
    Left = 304
    Top = 88
  end
end
