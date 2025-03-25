inherited Unit_ObjectForm: TUnit_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
  ClientHeight = 398
  ClientWidth = 702
  ExplicitWidth = 718
  ExplicitHeight = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 702
    Height = 372
    ExplicitWidth = 702
    ExplicitHeight = 372
    ClientRectBottom = 372
    ClientRectRight = 702
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 702
      ExplicitHeight = 372
      inherited cxGrid: TcxGrid
        Width = 702
        Height = 372
        ExplicitWidth = 702
        ExplicitHeight = 372
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
          object ParentName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'ParentName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object KATOTTG: TcxGridDBColumn
            Caption = #1050#1040#1058#1054#1058#1058#1043
            DataBinding.FieldName = 'KATOTTG'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GLN: TcxGridDBColumn
            DataBinding.FieldName = 'GLN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AddressEDIN: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089' '#1076#1083#1103' EDIN'
            DataBinding.FieldName = 'AddressEDIN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object Address: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089
            DataBinding.FieldName = 'Address'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CityName: TcxGridDBColumn
            Caption = #1043#1086#1088#1086#1076
            DataBinding.FieldName = 'CityName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CityKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'CityKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object RegionName: TcxGridDBColumn
            Caption = #1054#1073#1083#1072#1089#1090#1100
            DataBinding.FieldName = 'RegionName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 153
          end
          object ProvinceName: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085
            DataBinding.FieldName = 'ProvinceName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object BusinessName: TcxGridDBColumn
            Caption = #1041#1080#1079#1085#1077#1089
            DataBinding.FieldName = 'BusinessName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object DepartmentName: TcxGridDBColumn
            Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103
            DataBinding.FieldName = 'DepartmentName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object Department_twoName: TcxGridDBColumn
            Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 2 '#1088#1110#1074#1085#1103
            DataBinding.FieldName = 'Department_twoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RouteSortingName: TcxGridDBColumn
            Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
            DataBinding.FieldName = 'RouteSortingName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object SheetWorkTimeName: TcxGridDBColumn
            Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
            DataBinding.FieldName = 'SheetWorkTimeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
            Options.Editing = False
            Width = 149
          end
          object isCountCount: TcxGridDBColumn
            Caption = #1059#1095#1077#1090' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'isCountCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isPartionGP: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1080' '#1076#1083#1103' '#1043#1055' '#1080' '#1058#1091#1096#1077#1085#1082#1080
            DataBinding.FieldName = 'isPartionGP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1072#1088#1090#1080#1080' '#1076#1083#1103' '#1043#1055' '#1080' '#1058#1091#1096#1077#1085#1082#1080
            Options.Editing = False
            Width = 60
          end
          object isAvance: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1072#1074#1072#1085#1089#1072' '#1072#1074#1090#1086#1084#1072#1090'.'
            DataBinding.FieldName = 'isAvance'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1072#1074#1072#1085#1089#1072' '#1072#1074#1090#1086#1084#1072#1090'.'
            Options.Editing = False
            Width = 60
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
        end
      end
    end
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
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key_two'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue_two'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteSortingId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteSortingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteSortingName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteSortingName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actProtocol: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
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
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Top = 72
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
    Top = 72
  end
  inherited BarManager: TdxBarManager
    Top = 72
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
          ItemName = 'bbRefresh'
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
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbProtocol: TdxBarButton
      Action = actProtocol
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
end
