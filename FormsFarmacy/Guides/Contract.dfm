inherited ContractForm: TContractForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072'>'
  ClientWidth = 828
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 844
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 828
    ExplicitWidth = 828
    ClientRectRight = 828
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 828
      inherited cxGrid: TcxGrid
        Width = 828
        ExplicitWidth = 828
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
          object BankAccountName: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 134
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
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
            Width = 69
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object MemberName: TcxGridDBColumn
            Caption = #1054#1090#1074'. '#1079#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1087#1088#1072#1081#1089
            Options.Editing = False
            Width = 89
          end
          object isReport: TcxGridDBColumn
            Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
            DataBinding.FieldName = 'isReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077' "'#1075#1088#1072#1092#1080#1082' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1094#1077#1085#1099' '#1087#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1091'"'
            Options.Editing = False
            Width = 90
          end
          object isMorionCode: TcxGridDBColumn
            Caption = #1048#1084#1087#1086#1088#1090' '#1082#1086#1076#1086#1074' '#1052#1086#1088#1080#1086#1085#1072' '#1080#1079' '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'isMorionCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1084#1087#1086#1088#1090' '#1082#1086#1076#1086#1074' '#1052#1086#1088#1080#1086#1085#1072' '#1080#1079' '#1087#1088#1072#1081#1089#1072
            Options.Editing = False
            Width = 90
          end
          object isBarCode: TcxGridDBColumn
            Caption = #1048#1084#1087#1086#1088#1090' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1086#1074' '#1080#1079' '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'isBarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1084#1087#1086#1088#1090' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1086#1074' '#1080#1079' '#1087#1088#1072#1081#1089#1072
            Options.Editing = False
            Width = 90
          end
          object isPartialPay: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1095#1072#1089#1090#1103#1084#1080
            DataBinding.FieldName = 'isPartialPay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object GroupMemberSPName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094#1080#1077#1085#1090#1072' ('#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090')'
            DataBinding.FieldName = 'GroupMemberSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object PercentSP: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
            DataBinding.FieldName = 'PercentSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1089#1082#1080#1076#1082#1080' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
            Options.Editing = False
            Width = 86
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1089#1085'. '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1086#1089#1085#1086#1074#1085#1086#1075#1086' '#1076#1086#1075#1086#1074#1086#1088#1072
            Options.Editing = False
            Width = 86
          end
          object OrderSumm: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'OrderSumm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object OrderSummComment: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'OrderSummComment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object OrderTime: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1074#1088#1077#1084#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'OrderTime'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
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
            Width = 88
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
    object actUpdateMainDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_OrderParam
      StoredProcList = <
        item
          StoredProc = spUpdate_OrderParam
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
    object actUpdate_isMorionCode: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMorionCode
      StoredProcList = <
        item
          StoredProc = spUpdate_isMorionCode
        end>
      Caption = #1048#1084#1087#1086#1088#1090' '#1082#1086#1076#1086#1074' '#1052#1086#1088#1080#1086#1085#1072' '#1080#1079' '#1087#1088#1072#1081#1089#1072' '#1044#1072'/'#1053#1077#1090
      Hint = #1048#1084#1087#1086#1088#1090' '#1082#1086#1076#1086#1074' '#1052#1086#1088#1080#1086#1085#1072' '#1080#1079' '#1087#1088#1072#1081#1089#1072' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 76
    end
    object actUpdate_isBarCode: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isBarCode
      StoredProcList = <
        item
          StoredProc = spUpdate_isBarCode
        end>
      Caption = #1048#1084#1087#1086#1088#1090' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1086#1074' '#1080#1079' '#1087#1088#1072#1081#1089#1072' '#1044#1072'/'#1053#1077#1090
      Hint = #1048#1084#1087#1086#1088#1090' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1086#1074' '#1080#1079' '#1087#1088#1072#1081#1089#1072' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 77
    end
  end
  inherited MasterDS: TDataSource
    Top = 96
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
    inherited Bar: TdxBar
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
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisReport'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isMorionCode'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isBarCode'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end>
    end
    object bbUpdateisReport: TdxBarButton
      Action = actUpdateisReport
      Category = 0
    end
    object bbUpdate_isMorionCode: TdxBarButton
      Action = actUpdate_isMorionCode
      Category = 0
    end
    object bbUpdate_isBarCode: TdxBarButton
      Action = actUpdate_isBarCode
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
    Left = 528
    Top = 232
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
        Value = False
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 99
  end
  object spUpdate_OrderParam: TdsdStoredProc
    StoredProcName = 'gpUpdate_Contract_OrderParam'
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
        Name = 'inOrderSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OrderSumm'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderSummComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OrderSummComment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderTime'
        Value = 'TRUE'
        Component = MasterCDS
        ComponentItem = 'OrderTime'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 171
  end
  object spUpdate_isBarCode: TdsdStoredProc
    StoredProcName = 'gpUpdate_Contract_isBarCode'
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
        Name = 'inisBarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isBarCode'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisBarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isBarCode'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 139
  end
  object spUpdate_isMorionCode: TdsdStoredProc
    StoredProcName = 'gpUpdate_Contract_isMorionCode'
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
        Name = 'inisMorionCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMorionCode'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisMorionCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMorionCode'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 672
    Top = 91
  end
end
