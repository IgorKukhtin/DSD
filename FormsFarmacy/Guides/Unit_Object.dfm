inherited Unit_ObjectForm: TUnit_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
  ClientHeight = 420
  ClientWidth = 926
  ExplicitWidth = 942
  ExplicitHeight = 458
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 926
    Height = 394
    ExplicitWidth = 926
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 926
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 926
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 926
        Height = 394
        ExplicitWidth = 926
        ExplicitHeight = 394
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsSelection.MultiSelect = True
          OptionsView.Footer = False
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
            Options.Editing = False
            Width = 70
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object Address: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089
            DataBinding.FieldName = 'Address'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProvinceCityName: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085
            DataBinding.FieldName = 'ProvinceCityName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenAreaForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object TaxService: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080
            DataBinding.FieldName = 'TaxService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object TaxServiceNigth: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080' '#1085#1086#1095#1100
            DataBinding.FieldName = 'TaxServiceNigth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object isRepriceAuto: TcxGridDBColumn
            Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072
            DataBinding.FieldName = 'isRepriceAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
            Options.Editing = False
            Width = 70
          end
          object isOver: TcxGridDBColumn
            Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
            DataBinding.FieldName = 'isOver'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080
            Options.Editing = False
            Width = 88
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object Id: TcxGridDBColumn
            Caption = 'UnitId'
            DataBinding.FieldName = 'Id'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object isUploadBadm: TcxGridDBColumn
            Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090'. '#1041#1040#1044#1052
            DataBinding.FieldName = 'isUploadBadm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1041#1040#1044#1052
            Options.Editing = False
            Width = 89
          end
          object Num_byReportBadm: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'. ('#1041#1072#1044#1052')'
            DataBinding.FieldName = 'Num_byReportBadm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isMarginCategory: TcxGridDBColumn
            Caption = #1060#1086#1088#1084'. '#1074' '#1087#1088#1086#1089#1084'. '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'isMarginCategory'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 115
          end
          object isReport: TcxGridDBColumn
            Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
            DataBinding.FieldName = 'isReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
            Options.Editing = False
            Width = 72
          end
          object CreateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'. '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'CreateDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object CloseDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1082#1088'. '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'CloseDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object UserManagerName: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'UserManagerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUserForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'MemberName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUserForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
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
          Name = 'KeyList'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValuelist'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actProtocolOpenForm: TdsdOpenForm
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
    object actUpdateisReport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isReport
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isReport
        end>
      Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
      Hint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
      ImageIndex = 38
    end
    object actUpdateisMarginCategory: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isMarginCategory
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isMarginCategory
        end>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
      ImageIndex = 77
    end
    object actUpdateisUploadBadm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isUploadBadm
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isUploadBadm
        end>
      Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1041#1040#1044#1052
      Hint = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1041#1040#1044#1052' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 76
    end
    object actUpdateisOver: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072'/'#1053#1077#1090
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072'/'#1053#1077#1090
    end
    object spUpdateisOverNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver_No
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1053#1077#1090
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1053#1077#1090
    end
    object spUpdateisOverYes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver_Yes
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072
    end
    object macUpdateisOverNo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisOverNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1053#1077#1090
      ImageIndex = 58
    end
    object macUpdateisOverYes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisOverYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1044#1072
      ImageIndex = 52
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
    object actOpenAreaForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TAreaForm'
      FormName = 'TAreaForm'
      FormNameParam.Value = 'TAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenUserForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManagerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManagerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_Params
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_Params
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
    Params = <
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 80
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
          ItemName = 'bb'
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
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisOver'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisOverList'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisOverNoList'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisUploadBadm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbisMarginCategory'
        end
        item
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
          ItemName = 'bbProtocolOpenForm'
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
      ShowCaption = False
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbUpdateisOver: TdxBarButton
      Action = actUpdateisOver
      Category = 0
      ImageIndex = 72
    end
    object bbUpdateisOverList: TdxBarButton
      Action = macUpdateisOverYes
      Category = 0
    end
    object bbUpdateisOverNoList: TdxBarButton
      Action = macUpdateisOverNo
      Category = 0
    end
    object bbUpdateisUploadBadm: TdxBarButton
      Action = actUpdateisUploadBadm
      Category = 0
    end
    object bbisMarginCategory: TdxBarButton
      Action = actUpdateisMarginCategory
      Category = 0
    end
    object bbUpdateisReport: TdxBarButton
      Action = actUpdateisReport
      Category = 0
    end
    object bb: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
  object spUpdate_Unit_isOver: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
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
        Name = 'inisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 99
  end
  object spUpdate_Unit_isOver_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
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
        Name = 'inisOver'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 163
  end
  object spUpdate_Unit_isOver_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
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
        Name = 'inisOver'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 219
  end
  object spUpdate_Unit_isUploadBadm: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isUploadBadm'
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
        Name = 'inisUploadBadm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadBadm'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisUploadBadm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadBadm'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 131
  end
  object spUpdate_Unit_isMarginCategory: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isMarginCategory'
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
        Name = 'inisMarginCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMarginCategory'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisMarginCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMarginCategory'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 203
  end
  object spUpdate_Unit_isReport: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isReport'
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
        Name = 'inisReport'
        Value = Null
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
      end>
    PackSize = 1
    Left = 648
    Top = 267
  end
  object spUpdate_Unit_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_Params'
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
        Name = 'ioCreateDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'CreateDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCloseDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'CloseDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManagerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserManagerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AreaId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 307
  end
end
