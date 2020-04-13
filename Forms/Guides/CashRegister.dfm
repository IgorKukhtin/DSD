inherited CashRegisterForm: TCashRegisterForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1050#1072#1089#1089#1086#1074#1099#1093' '#1072#1087#1087#1072#1088#1072#1090#1086#1074'>'
  ClientHeight = 374
  ClientWidth = 833
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 849
  ExplicitHeight = 413
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 833
    Height = 348
    ExplicitWidth = 833
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 833
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 833
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 833
        Height = 348
        ExplicitWidth = 833
        ExplicitHeight = 348
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 145
          end
          object SerialNumber: TcxGridDBColumn
            Caption = #1057#1077#1088'. '#1085#1086#1084#1077#1088
            DataBinding.FieldName = 'SerialNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object clCashRegisterKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1082#1072#1089#1089#1099
            DataBinding.FieldName = 'CashRegisterKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object TimePUSHFinal1: TcxGridDBColumn
            Caption = #1042#1077#1095#1077#1088#1085#1077#1077' PUSH 1'
            DataBinding.FieldName = 'TimePUSHFinal1'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'HH:NN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object TimePUSHFinal2: TcxGridDBColumn
            Caption = #1042#1077#1095#1077#1088#1085#1077#1077' PUSH 2'
            DataBinding.FieldName = 'TimePUSHFinal2'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'HH:NN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 163
          end
          object TaxRate: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'TaxRate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object GetHardwareData: TcxGridDBColumn
            Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
            DataBinding.FieldName = 'GetHardwareData'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
            Options.Editing = False
            Width = 72
          end
          object ComputerName: TcxGridDBColumn
            Caption = #1048#1084#1103' '#1082#1086#1084#1087#1102#1090#1077#1088#1072
            DataBinding.FieldName = 'ComputerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object BaseBoardProduct: TcxGridDBColumn
            Caption = #1052#1072#1090#1077#1088#1080#1085#1089#1082#1072#1103' '#1087#1083#1072#1090#1072' '
            DataBinding.FieldName = 'BaseBoardProduct'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object ProcessorName: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1089#1089#1086#1088
            DataBinding.FieldName = 'ProcessorName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object DiskDriveModel: TcxGridDBColumn
            Caption = #1046#1077#1089#1090#1082#1080#1081' '#1044#1080#1089#1082' '
            DataBinding.FieldName = 'DiskDriveModel'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object PhysicalMemory: TcxGridDBColumn
            Caption = #1054#1087#1077#1088#1072#1090#1080#1074#1085#1072#1103' '#1087#1072#1084#1103#1090#1100
            DataBinding.FieldName = 'PhysicalMemory'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Width = 92
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'TCashRegisterEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TCashRegisterEditForm'
    end
    object actUpdate_GetHardwareData_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_GetHardwareData_Yes
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080'"?'
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      ImageIndex = 79
    end
    object actExecUpdate_GetHardwareData_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GetHardwareData_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_GetHardwareData_Yes
        end>
      Caption = 'actExecUpdate_GetHardwareData_Yes'
    end
    object actUpdate_GetHardwareData_No: TMultiAction
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_GetHardwareData_No
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080'"?'
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1083#1091#1095#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1083#1091#1095#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      ImageIndex = 76
    end
    object actExecUpdate_GetHardwareData_No: TdsdExecStoredProc
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GetHardwareData_No
      StoredProcList = <
        item
          StoredProc = spUpdate_GetHardwareData_No
        end>
      Caption = 'actExecUpdate_GetHardwareData_No'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_CashRegister'
  end
  inherited BarManager: TdxBarManager
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actUpdate_GetHardwareData_Yes
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actUpdate_GetHardwareData_No
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
  end
  object spUpdate_GetHardwareData_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_CashRegister_GetHardwareData'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGetHardwareData'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 120
  end
  object spUpdate_GetHardwareData_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_CashRegister_GetHardwareData'
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
        Name = 'inGetHardwareData'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 184
  end
end
