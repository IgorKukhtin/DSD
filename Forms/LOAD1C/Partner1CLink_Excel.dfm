inherited Partner1CLink_ExcelForm: TPartner1CLink_ExcelForm
  Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' : '#1055#1088#1086#1075#1088#1072#1084#1084#1072' + 1'#1057' + Excel'
  ClientHeight = 401
  ClientWidth = 1020
  ExplicitWidth = 1036
  ExplicitHeight = 436
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
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clJuridicalGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083'.'
            DataBinding.FieldName = 'JuridicalGroupName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colJuridicalId: TcxGridDBColumn
            DataBinding.FieldName = 'JuridicalId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clJuridicalNameExcel: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' Excel'
            DataBinding.FieldName = 'JuridicalNameExcel'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clJuridicalNameExcel_find: TcxGridDBColumn
            Caption = #1070#1088'.'#1083'. '#1087#1086#1080#1089#1082' '#1087#1086' '#1054#1050#1055#1054' Excel'
            DataBinding.FieldName = 'JuridicalNameExcel_find'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
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
          object colOKPO1C: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' 1'#1057
            DataBinding.FieldName = 'OKPO1C'
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
          object clOKPOExcel: TcxGridDBColumn
            Caption = 'OKPO Excel'
            DataBinding.FieldName = 'OKPOExcel'
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
          object clIsOKPO1C_OKPO: TcxGridDBColumn
            Caption = #1054#1096'. '#1054#1050#1055#1054' 1'#1089'+'#1087#1088'.'
            DataBinding.FieldName = 'isOKPO1C_OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clIsOKPO1C_OKPOExcel: TcxGridDBColumn
            Caption = #1054#1096'. '#1054#1050#1055#1054' 1'#1089'+'#1101#1082#1089'.'
            DataBinding.FieldName = 'isOKPO1C_OKPOExcel'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clIsOKPOExcel_OKPO: TcxGridDBColumn
            Caption = #1054#1096'. '#1054#1050#1055#1054' '#1087#1088'.+'#1101#1082#1089'.'
            DataBinding.FieldName = 'isOKPOExcel_OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clINN: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN'
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
          object clINN1C: TcxGridDBColumn
            Caption = #1048#1053#1053' 1'#1057
            DataBinding.FieldName = 'INN1C'
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
          object colPartnerId: TcxGridDBColumn
            DataBinding.FieldName = 'PartnerId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colPartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PartnerCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.IncSearch = False
            Width = 45
          end
          object colPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.IncSearch = False
            Width = 120
          end
          object clPartnerNameCalcExcel: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' '#1053#1054#1042#1067#1049
            DataBinding.FieldName = 'PartnerNameCalcExcel'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colPartnerName1C: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' 1'#1057
            DataBinding.FieldName = 'PartnerName1C'
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
          object clPartnerNameExcel: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' Excel'
            DataBinding.FieldName = 'PartnerNameExcel'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colClientCode1C: TcxGridDBColumn
            Caption = #1050#1086#1076' 1'#1057
            DataBinding.FieldName = 'ClientCode1C'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clPartner1CLinkId: TcxGridDBColumn
            DataBinding.FieldName = 'Partner1CLinkId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colBranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clKodBranchExcel: TcxGridDBColumn
            Caption = #1092#1080#1083#1080#1072#1083' Excel'
            DataBinding.FieldName = 'KodBranchExcel'
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
          object clAccountName_all: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName_all'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemName'
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
          object index: TcxGridDBColumn
            Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1080#1085#1076#1077#1082#1089
            DataBinding.FieldName = 'index'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object citytype: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1075#1086' '#1087#1091#1085#1082#1090#1072
            DataBinding.FieldName = 'citytype'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object cityname: TcxGridDBColumn
            Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
            DataBinding.FieldName = 'cityname'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object regiontype: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1088#1072#1081#1086#1085', '#1086#1073#1083#1072#1089#1090#1100')'
            DataBinding.FieldName = 'regiontype'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object region: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085', '#1054#1073#1083#1072#1089#1090#1100
            DataBinding.FieldName = 'region'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object streettype: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1091#1083#1080#1094#1072', '#1087#1088#1086#1089#1087#1077#1082#1090')'
            DataBinding.FieldName = 'streettype'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object streetname: TcxGridDBColumn
            Caption = #1059#1083#1080#1094#1072', '#1087#1088#1086#1089#1087#1077#1082#1090
            DataBinding.FieldName = 'streetname'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object house: TcxGridDBColumn
            Caption = #1044#1086#1084
            DataBinding.FieldName = 'house'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object house1: TcxGridDBColumn
            Caption = #1082#1086#1088#1087#1091#1089
            DataBinding.FieldName = 'house1'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object house2: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1082#1074#1072#1088#1090#1080#1088#1072', '#1086#1092#1080#1089')'
            DataBinding.FieldName = 'house2'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object house3: TcxGridDBColumn
            Caption = #8470' '#1082#1074#1072#1088#1090#1080#1088#1072', '#1086#1092#1080#1089
            DataBinding.FieldName = 'house3'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt1name: TcxGridDBColumn
            Caption = #1079#1072#1082#1072#1079' '#1060#1048#1054
            DataBinding.FieldName = 'kontakt1name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt1tel: TcxGridDBColumn
            Caption = #1079#1072#1082#1072#1079' '#1090#1077#1083'.'
            DataBinding.FieldName = 'kontakt1tel'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt1email: TcxGridDBColumn
            Caption = #1079#1072#1082#1072#1079' email'
            DataBinding.FieldName = 'kontakt1email'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt2name: TcxGridDBColumn
            Caption = #1087#1077#1088#1074#1080#1095#1082#1072' '#1060#1048#1054
            DataBinding.FieldName = 'kontakt2name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt2tel: TcxGridDBColumn
            Caption = #1087#1077#1088#1074#1080#1095#1082#1072' '#1090#1077#1083'.'
            DataBinding.FieldName = 'kontakt2tel'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt2email: TcxGridDBColumn
            Caption = #1087#1077#1088#1074#1080#1095#1082#1072' email'
            DataBinding.FieldName = 'kontakt2email'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt3name: TcxGridDBColumn
            Caption = #1072#1082#1090#1099' '#1089#1074#1077#1088#1082#1080' '#1060#1048#1054
            DataBinding.FieldName = 'kontakt3name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt3tel: TcxGridDBColumn
            Caption = #1072#1082#1090#1099' '#1089#1074#1077#1088#1082#1080' '#1090#1077#1083'.'
            DataBinding.FieldName = 'kontakt3tel'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object kontakt3email: TcxGridDBColumn
            Caption = #1072#1082#1090#1099' '#1089#1074#1077#1088#1082#1080' email'
            DataBinding.FieldName = 'kontakt3email'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
      end
      object edBranch: TcxButtonEdit
        Left = 192
        Top = 16
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
        Top = 0
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
      FormName = 'TBranchLinkForm'
      FormNameParam.Value = 'TBranchLinkForm'
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
    object actChoicePartnerForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoicePartnerForm'
      FormName = 'TPartner1CLinkPlaceForm'
      FormNameParam.Value = 'TPartner1CLinkPlaceForm'
      FormNameParam.DataType = ftString
      GuiParams = <
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
          ParamType = ptInput
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'MasterJuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'MasterJuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Partner1CLink_Excel'
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
    inherited bbRefresh: TdxBarButton [2]
    end
    object dxBarControlContainerItem: TdxBarControlContainerItem [3]
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edBranch
    end
    object bbBranchLabel: TdxBarControlContainerItem [4]
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 224
    Top = 208
  end
  object BranchLinkGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranchLinkForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranchLinkForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchLinkGuides
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
        Component = BranchLinkGuides
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
end
