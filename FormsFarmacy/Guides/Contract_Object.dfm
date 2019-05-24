inherited Contract_ObjectForm: TContract_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072'>'
  ClientWidth = 798
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 814
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 798
    ExplicitWidth = 798
    ClientRectRight = 798
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 798
      inherited cxGrid: TcxGrid
        Width = 798
        ExplicitWidth = 798
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Name: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 123
          end
          object JuridicalBasisName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalBasisName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 145
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 212
          end
          object Percent: TcxGridDBColumn
            Caption = '% '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'Percent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object Percent_Juridical: TcxGridDBColumn
            Caption = '% '#1082#1086#1088#1088'. '#1085#1072#1094#1077#1085#1082#1080' '#1102#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'Percent_Juridical'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object SigningDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1076#1087#1080#1089'.'
            DataBinding.FieldName = 'SigningDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
            Options.Editing = False
            Width = 60
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'EndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object Deferment: TcxGridDBColumn
            Caption = #1054#1090#1089#1088#1086#1095#1082#1072
            DataBinding.FieldName = 'Deferment'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object isReport: TcxGridDBColumn
            Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
            DataBinding.FieldName = 'isReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077' "'#1075#1088#1072#1092#1080#1082' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1094#1077#1085#1099' '#1087#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1091'"'
            Width = 90
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 268
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'TContractEditForm'
      FormNameParam.Value = 'TContractEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TContractEditForm'
      FormNameParam.Value = 'TContractEditForm'
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Name'
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
        end>
    end
    object actUpdateisReport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Contract_isReport
      StoredProcList = <
        item
          StoredProc = spUpdate_Contract_isReport
        end>
      Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077' '#1044#1072'/'#1053#1077#1090
      Hint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 52
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Contract_isReport
      StoredProcList = <
        item
          StoredProc = spUpdate_Contract_isReport
        end>
      Caption = 'dsdUpdatePrice'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Contract'
    Left = 88
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
    object bbUpdateisReport: TdxBarButton
      Action = actUpdateisReport
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
  end
  object spUpdate_Contract_isReport: TdsdStoredProc
    StoredProcName = 'gpUpdate_Contract_isReport'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Name = 'inisReport'
        Value = 'False'
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotParam'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 99
  end
end
