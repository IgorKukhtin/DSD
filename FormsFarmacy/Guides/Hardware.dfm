inherited HardwareForm: THardwareForm
  Caption = #1040#1087#1087#1072#1088#1072#1090#1085#1072#1103' '#1095#1072#1089#1090#1100' '
  ClientHeight = 374
  ClientWidth = 833
  AddOnFormData.isAlwaysRefresh = True
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
            Width = 50
          end
          object Identifier: TcxGridDBColumn
            Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
            DataBinding.FieldName = 'Identifier'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object isLicense: TcxGridDBColumn
            Caption = #1051#1080#1094#1077#1085#1079#1080#1103' '#1085#1072' '#1055#1050
            DataBinding.FieldName = 'isLicense'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object isSmartphone: TcxGridDBColumn
            Caption = #1057#1084#1072#1088#1090#1092#1086#1085
            DataBinding.FieldName = 'isSmartphone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object isModem: TcxGridDBColumn
            Caption = '3G/4G '#1084#1086#1076#1077#1084
            DataBinding.FieldName = 'isModem'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isBarcodeScanner: TcxGridDBColumn
            Caption = #1057#1082#1072#1085#1085#1077#1088' '#1096'/'#1082
            DataBinding.FieldName = 'isBarcodeScanner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object ComputerName: TcxGridDBColumn
            Caption = ' '#1048#1084#1103' '#1082#1086#1084#1087#1102#1090#1077#1088#1072
            DataBinding.FieldName = 'ComputerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 123
          end
          object isCashRegister: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'isCashRegister'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 163
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
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
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
      FormName = 'THardwareEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'THardwareEditForm'
    end
    inherited ProtocolOpenForm: TdsdOpenForm
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
          ComponentItem = 'Identifier'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actDeleteHardware: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteHardware
      StoredProcList = <
        item
          StoredProc = spDeleteHardware
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1072#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1095#1072#1089#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1072#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1095#1072#1089#1090#1100
      ImageIndex = 52
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1072#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1095#1072#1089#1090#1100'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Hardware'
    Params = <
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
          ItemName = 'bbShowErased'
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
          ItemName = 'dxBarButton3'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Category = 0
      Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton2: TdxBarButton
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1083#1091#1095#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Category = 0
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1083#1091#1095#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actDeleteHardware
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
  end
  object spDeleteHardware: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_Hardware'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 152
  end
end
