inherited MoneyPlace_ObjectForm: TMoneyPlace_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
  ClientHeight = 480
  ClientWidth = 759
  ExplicitWidth = 775
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 759
    Height = 380
    ExplicitTop = 59
    ExplicitWidth = 759
    ExplicitHeight = 380
    ClientRectBottom = 380
    ClientRectRight = 759
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 759
      ExplicitHeight = 380
      inherited cxGrid: TcxGrid
        Width = 759
        Height = 380
        ExplicitWidth = 759
        ExplicitHeight = 380
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
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 300
          end
          object ItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = '***'#1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TaxKind_Value: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'TaxKind_Value'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1053#1044#1057
            DataBinding.FieldName = 'TaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TaxKindName_Info: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1053#1044#1057
            DataBinding.FieldName = 'TaxKindName_Info'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TaxKindName_Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1053#1044#1057
            DataBinding.FieldName = 'TaxKindName_Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TaxNumber: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#8470
            DataBinding.FieldName = 'TaxNumber'
            Visible = False
            Width = 70
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 20
          end
        end
      end
    end
  end
  object Panel_btn: TPanel [1]
    Left = 0
    Top = 439
    Width = 759
    Height = 41
    Align = alBottom
    TabOrder = 5
    object btnFormClose: TcxButton
      Left = 218
      Top = 8
      Width = 90
      Height = 25
      Action = actFormClose
      TabOrder = 0
    end
    object btnChoiceGuides: TcxButton
      Left = 85
      Top = 8
      Width = 90
      Height = 25
      Action = actChoiceGuides
      TabOrder = 1
    end
    object btnInsert_Partner: TcxButton
      Left = 375
      Top = 8
      Width = 120
      Height = 25
      Action = mactInsert_Partner
      TabOrder = 2
    end
    object btnInsert_client: TcxButton
      Left = 534
      Top = 8
      Width = 120
      Height = 25
      Action = mactInsert_client
      TabOrder = 3
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 0
    Width = 759
    Height = 33
    Align = alTop
    TabOrder = 6
    object lbSearchName: TcxLabel
      Left = 6
      Top = 6
      Caption = #1055#1086#1080#1089#1082' '#1053#1072#1079#1074#1072#1085#1080#1077':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchName: TcxTextEdit
      Left = 125
      Top = 7
      TabOrder = 1
      DesignSize = (
        200
        21)
      Width = 200
    end
  end
  inherited ActionList: TActionList
    inherited actChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
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
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
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
          Name = 'InvoiceKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvoiceKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvoiceKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_order'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_order'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_invoice'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_invoice'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount_Invoice'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TaxNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKind_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TaxKind_Value'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TaxKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TaxKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actInsert_client: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 16434
      ImageIndex = 0
      FormName = 'TClientEditForm'
      FormNameParam.Value = 'TClientEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate_client: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
      FormName = 'TClientEditForm'
      FormNameParam.Value = 'TClientEditForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate_partner: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert_Partner: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 16433
      ImageIndex = 0
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object mactInsert_Partner: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_Partner
        end>
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
      ImageIndex = 47
    end
    object mactInsert_client: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_client
        end>
      Caption = #1050#1083#1080#1077#1085#1090
      ImageIndex = 48
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MoneyPlace'
    Top = 80
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbLieferanten'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbKunden'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbInsert_Partner: TdxBarButton
      Action = actInsert_Partner
      Category = 0
    end
    object bbInsert_client: TdxBarButton
      Action = actInsert_client
      Category = 0
    end
    object bbUpdate_client: TdxBarButton
      Action = actUpdate_client
      Category = 0
    end
    object bbLieferanten: TdxBarSubItem
      Caption = 'Lieferanten'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert_Partner'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_partner'
        end>
    end
    object bbKunden: TdxBarSubItem
      Caption = 'Kunden'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert_client'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_client'
        end>
    end
    object bbUpdate_partner: TdxBarButton
      Action = actUpdate_partner
      Category = 0
    end
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchName
    DataSet = MasterCDS
    Column = Name
    ColumnList = <
      item
        Column = Name
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 416
    Top = 112
  end
end
