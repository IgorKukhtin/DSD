object PartnerAddressForm: TPartnerAddressForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1040#1076#1088#1077#1089' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072'>'
  ClientHeight = 464
  ClientWidth = 1058
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 1058
    Height = 438
    Align = alClient
    TabOrder = 1
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ceCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taRightJustify
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 23
      end
      object ceName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 97
      end
      object ceAddress: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089
        DataBinding.FieldName = 'Address'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object ceJuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 73
      end
      object clOKPO: TcxGridDBColumn
        Caption = #1054#1050#1055#1054
        DataBinding.FieldName = 'OKPO'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 52
      end
      object colRegionName: TcxGridDBColumn
        Caption = #1054#1073#1083#1072#1089#1090#1100
        DataBinding.FieldName = 'RegionName'
        HeaderAlignmentVert = vaCenter
        Width = 28
      end
      object colProvinceName: TcxGridDBColumn
        Caption = #1056#1072#1081#1086#1085'  '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1075#1086' '#1087#1091#1085#1082#1090#1072
        DataBinding.FieldName = 'ProvinceName'
        Width = 45
      end
      object colPostalCode: TcxGridDBColumn
        Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1080#1085#1076#1077#1082#1089
        DataBinding.FieldName = 'PostalCode'
        HeaderAlignmentVert = vaCenter
        Width = 42
      end
      object colCityKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1075#1086' '#1087#1091#1085#1082#1090#1072
        DataBinding.FieldName = 'CityKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = CityKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 34
      end
      object colCityName: TcxGridDBColumn
        Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
        DataBinding.FieldName = 'CityName'
        HeaderAlignmentVert = vaCenter
        Width = 27
      end
      object colProvinceCityName: TcxGridDBColumn
        Caption = #1056#1072#1081#1086#1085' '#1074' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1084' '#1087#1091#1085#1082#1090#1077
        DataBinding.FieldName = 'ProvinceCityName'
        HeaderAlignmentVert = vaCenter
        Width = 68
      end
      object colStreetKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' ('#1091#1083#1080#1094#1072', '#1087#1088#1086#1089#1087#1077#1082#1090')'
        DataBinding.FieldName = 'StreetKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StreetKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 33
      end
      object clStreetName: TcxGridDBColumn
        Caption = #1059#1083#1080#1094#1072
        DataBinding.FieldName = 'StreetName'
        HeaderAlignmentVert = vaCenter
        Width = 41
      end
      object clHouseNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1084#1072
        DataBinding.FieldName = 'HouseNumber'
        HeaderAlignmentVert = vaCenter
        Width = 44
      end
      object clCaseNumber: TcxGridDBColumn
        Caption = #8470' '#1082#1086#1088#1087#1091#1089#1072
        DataBinding.FieldName = 'CaseNumber'
        HeaderAlignmentVert = vaCenter
        Width = 43
      end
      object clRoomNumber: TcxGridDBColumn
        Caption = #8470' '#1082#1074#1072#1088#1090#1080#1088#1099
        DataBinding.FieldName = 'RoomNumber'
        HeaderAlignmentVert = vaCenter
        Width = 33
      end
      object ceisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object colShortName: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'ShortName'
        HeaderAlignmentVert = vaCenter
        Width = 31
      end
      object colOrder_Name: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1060#1048#1054
        DataBinding.FieldName = 'Order_Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceOrderForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 53
      end
      object colOrder_Phone: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1090#1077#1083'.'
        DataBinding.FieldName = 'Order_Phone'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceOrderForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 27
      end
      object colOrder_Mail: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' email'
        DataBinding.FieldName = 'Order_Mail'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceOrderForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 22
      end
      object colDoc_Name: TcxGridDBColumn
        Caption = #1055#1077#1088#1074#1080#1095#1082#1072' '#1060#1048#1054
        DataBinding.FieldName = 'Doc_Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceDocForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object colDoc_Phone: TcxGridDBColumn
        Caption = #1055#1077#1088#1074#1080#1095#1082#1072' '#1090#1077#1083'.'
        DataBinding.FieldName = 'Doc_Phone'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceDocForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 22
      end
      object colDoc_Mail: TcxGridDBColumn
        Caption = #1055#1077#1088#1074#1080#1095#1082#1072' email'
        DataBinding.FieldName = 'Doc_Mail'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceDocForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 22
      end
      object colAct_Name: TcxGridDBColumn
        Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1060#1048#1054
        DataBinding.FieldName = 'Act_Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceActForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 24
      end
      object colAct_Phone: TcxGridDBColumn
        Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1090#1077#1083'.'
        DataBinding.FieldName = 'Act_Phone'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceActForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 22
      end
      object colAct_Mail: TcxGridDBColumn
        Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' email'
        DataBinding.FieldName = 'Act_Mail'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceActForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Width = 22
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel6: TcxLabel
    Left = 172
    Top = 78
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
  end
  object edJuridical: TcxButtonEdit
    Left = 143
    Top = 36
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 245
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 40
    Top = 120
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 192
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    Left = 296
    Top = 120
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 152
    Top = 112
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
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
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbJuridicalLabel'
        end
        item
          Visible = True
          ItemName = 'bbJuridicalGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
      Enabled = False
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
      Enabled = False
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
      Enabled = False
    end
    object bbGridToExel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
      Enabled = False
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbJuridicalLabel: TdxBarControlContainerItem
      Caption = 'JuridicalLabel'
      Category = 0
      Hint = 'JuridicalLabel'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bbJuridicalGuides: TdxBarControlContainerItem
      Caption = 'JuridicalGuides'
      Category = 0
      Hint = 'JuridicalGuides'
      Visible = ivAlways
      Control = edJuridical
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'JuridicalId'
          Value = ''
          Component = JuridicalGuides
          ComponentItem = 'Key'
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object PriceListPromoChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'PriceListPromoChoiceForm'
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'PriceListPromoId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'PriceListPromoName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object StreetKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'StreetChoiceForm'
      FormName = 'TStreetKindForm'
      FormNameParam.Value = 'TStreetKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'StreetKindId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'StreetKindName'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = True
    end
    object CityKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'CityKindChoiceForm'
      FormName = 'TCityKindForm'
      FormNameParam.Value = 'TCityKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'CityKindId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'CityKindName'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = True
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Name'
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
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
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
      DataSource = DataSource
    end
    object ContactPersonChoiceActForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ContactPersonChoiceForm'
      FormName = 'TContactPersonChoiceForm'
      FormNameParam.Value = 'TContactPersonChoiceForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContactPersonKindId'
          Component = MasterCDS
          ComponentItem = 'Act_ContactPersonKindId'
          ParamType = ptInput
        end
        item
          Name = 'ContactPersonKindName'
          Component = MasterCDS
          ComponentItem = 'Act_ContactPersonKindName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Act_Name'
          DataType = ftString
        end
        item
          Name = 'phone'
          Component = MasterCDS
          ComponentItem = 'Act_phone'
          DataType = ftString
        end
        item
          Name = 'mail'
          Component = MasterCDS
          ComponentItem = 'Act_mail'
          DataType = ftString
        end>
      isShowModal = True
    end
    object ContactPersonChoiceOrderForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ContactPersonChoiceForm'
      FormName = 'TContactPersonChoiceForm'
      FormNameParam.Value = 'TContactPersonChoiceForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContactPersonKindId'
          Component = MasterCDS
          ComponentItem = 'Order_ContactPersonKindId'
          ParamType = ptInput
        end
        item
          Name = 'ContactPersonKindName'
          Component = MasterCDS
          ComponentItem = 'Order_ContactPersonKindName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Order_Name'
          DataType = ftString
        end
        item
          Name = 'phone'
          Component = MasterCDS
          ComponentItem = 'Order_phone'
          DataType = ftString
        end
        item
          Name = 'mail'
          Component = MasterCDS
          ComponentItem = 'Order_mail'
          DataType = ftString
        end>
      isShowModal = True
    end
    object ContactPersonChoiceDocForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ContactPersonChoiceForm'
      FormName = 'TContactPersonChoiceForm'
      FormNameParam.Value = 'TContactPersonChoiceForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContactPersonKindId'
          Component = MasterCDS
          ComponentItem = 'Doc_ContactPersonKindId'
          ParamType = ptInput
        end
        item
          Name = 'ContactPersonKindName'
          Component = MasterCDS
          ComponentItem = 'Doc_ContactPersonKindName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'doc_Name'
          DataType = ftString
        end
        item
          Name = 'phone'
          Component = MasterCDS
          ComponentItem = 'Doc_phone'
          DataType = ftString
        end
        item
          Name = 'mail'
          Component = MasterCDS
          ComponentItem = 'doc_mail'
          DataType = ftString
        end>
      isShowModal = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Partner_Address'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 80
    Top = 216
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 424
    Top = 216
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 464
    Top = 288
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 424
    Top = 152
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner_Address'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
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
        Name = 'inRegionName'
        Component = MasterCDS
        ComponentItem = 'RegionName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inProvinceName'
        Component = MasterCDS
        ComponentItem = 'ProvinceName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCityName'
        Component = MasterCDS
        ComponentItem = 'CityName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCityKindId'
        Component = MasterCDS
        ComponentItem = 'CityKindId'
        ParamType = ptInput
      end
      item
        Name = 'inProvinceCityName'
        Component = MasterCDS
        ComponentItem = 'ProvinceCityName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPostalCode'
        Component = MasterCDS
        ComponentItem = 'PostalCode'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inStreetName'
        Component = MasterCDS
        ComponentItem = 'StreetName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inStreetKindId'
        Component = MasterCDS
        ComponentItem = 'StreetKindId'
        ParamType = ptInput
      end
      item
        Name = 'inHouseNumber'
        Component = MasterCDS
        ComponentItem = 'HouseNumber'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCaseNumber'
        Component = MasterCDS
        ComponentItem = 'CaseNumber'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inRoomNumber'
        Component = MasterCDS
        ComponentItem = 'RoomNumber'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inShortName'
        Component = MasterCDS
        ComponentItem = 'ShortName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOrdeName'
        Component = MasterCDS
        ComponentItem = 'Order_Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOrderPhone'
        Component = MasterCDS
        ComponentItem = 'Order_Phone'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOrderMail'
        Component = MasterCDS
        ComponentItem = 'Order_Mail'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDocName'
        Component = MasterCDS
        ComponentItem = 'Doc_Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDocPhone'
        Component = MasterCDS
        ComponentItem = 'Doc_Phone'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDocMail'
        Component = MasterCDS
        ComponentItem = 'Doc_Mail'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inActName'
        Component = MasterCDS
        ComponentItem = 'Act_Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inActPhone'
        Component = MasterCDS
        ComponentItem = 'Act_Phone'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inActMail'
        Component = MasterCDS
        ComponentItem = 'Act_Mail'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 88
    Top = 344
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 528
    Top = 144
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = JuridicalGuides
      end>
    Left = 288
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 384
    Top = 112
  end
end
