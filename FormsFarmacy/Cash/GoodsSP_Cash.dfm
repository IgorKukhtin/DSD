inherited GoodsSP_CashForm: TGoodsSP_CashForm
  Caption = #1058#1086#1074#1072#1088#1099' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1086#1074
  ClientHeight = 445
  ClientWidth = 746
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 762
  ExplicitHeight = 484
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 746
    Height = 419
    ExplicitWidth = 746
    ExplicitHeight = 419
    ClientRectBottom = 419
    ClientRectRight = 746
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 746
      ExplicitHeight = 419
      inherited cxGrid: TcxGrid
        Width = 746
        Height = 419
        ExplicitWidth = 746
        ExplicitHeight = 419
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 253
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PricePay: TcxGridDBColumn
            Caption = #1044#1086#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'PricePay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1072#1087#1090#1077#1082#1077
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object AmountRetail: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1089#1077#1090#1080
            DataBinding.FieldName = 'AmountRetail'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object ColSP: TcxGridDBColumn
            Caption = #8470' '#1079'/'#1087' (1)'
            DataBinding.FieldName = 'ColSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object IntenalSPName: TcxGridDBColumn
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' (2)'
            DataBinding.FieldName = 'IntenalSPName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object BrandSPName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' (3)'
            DataBinding.FieldName = 'BrandSPName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object KindOutSPName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' (4)'
            DataBinding.FieldName = 'KindOutSPName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object Pack: TcxGridDBColumn
            Caption = #1057#1080#1083#1072' '#1076#1110#1111' ('#1076#1086#1079#1091#1074#1072#1085#1085#1103') (5)'
            DataBinding.FieldName = 'Pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object CountSP: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1086#1076#1080#1085#1080#1094#1100' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1091' '#1089#1087#1086#1078#1080#1074#1095#1110#1081' '#1091#1087#1072#1082#1086#1074#1094#1110' (6)'
            DataBinding.FieldName = 'CountSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GroupSP: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1080' '#1074#1110#1076#1096#1082#1086#1076#1091'-'#1074#1072#1085#1085#1103' '#8211' '#1030' '#1072#1073#1086' '#1030#1030
            DataBinding.FieldName = 'GroupSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object CodeATX: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1040#1058#1061' (7)'
            DataBinding.FieldName = 'CodeATX'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object MakerSP: TcxGridDBColumn
            Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072', '#1082#1088#1072#1111#1085#1072' (8)'
            DataBinding.FieldName = 'MakerSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object ReestrSP: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1080#1081' '#1079#1072#1089#1110#1073' (9)'
            DataBinding.FieldName = 'ReestrSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 116
          end
          object ReestrDateSP: TcxGridDBColumn
            Caption = 
              #1044#1072#1090#1072' '#1079#1072#1082#1110#1085#1095#1077#1085#1085#1103' '#1089#1090#1088#1086#1082#1091' '#1076#1110#1111' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100 +
              #1082#1080#1081' '#1079#1072#1089#1110#1073' (10)'
            DataBinding.FieldName = 'ReestrDateSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 121
          end
          object PriceOptSP: TcxGridDBColumn
            Caption = #1054#1087#1090#1086#1074#1086'- '#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (11)'
            DataBinding.FieldName = 'PriceOptSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object PriceRetSP: TcxGridDBColumn
            Caption = #1056#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (12)'
            DataBinding.FieldName = 'PriceRetSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object DailyNormSP: TcxGridDBColumn
            Caption = #1044#1086#1073#1086#1074#1072' '#1076#1086#1079#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1072' '#1042#1054#1054#1047' (13)'
            DataBinding.FieldName = 'DailyNormSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object DailyCompensationSP: TcxGridDBColumn
            Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1076#1086#1073#1086#1074#1086#1111' '#1076#1086#1079#1080' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (14)'
            DataBinding.FieldName = 'DailyCompensationSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object PriceSP: TcxGridDBColumn
            Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (15)'
            DataBinding.FieldName = 'PriceSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object PaymentSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1072' '#1076#1086#1087#1083#1072#1090#1080' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (16)'
            DataBinding.FieldName = 'PaymentSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object DosageIdSP: TcxGridDBColumn
            Caption = 'DosageID '#1083#1110#1082#1072#1088'. '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'DosageIdSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'DosageID '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
            Options.Editing = False
            Width = 63
          end
          object NumeratorUnitSP: TcxGridDBColumn
            Caption = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091' '#1089#1080#1083#1080' '#1076#1110#1111
            DataBinding.FieldName = 'NumeratorUnitSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091' '#1089#1080#1083#1080' '#1076#1110#1111
            Options.Editing = False
            Width = 60
          end
          object DenumeratorValueSP: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1089#1091#1090#1085#1086#1089#1090#1110
            DataBinding.FieldName = 'DenumeratorValueSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object DenumeratorUnitSP: TcxGridDBColumn
            Caption = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091' '#1089#1091#1090#1085#1086#1089#1090#1110
            DataBinding.FieldName = 'DenumeratorUnitSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091' '#1089#1091#1090#1085#1086#1089#1090#1110
            Options.Editing = False
            Width = 60
          end
        end
      end
      object edMedicalProgramSP: TcxButtonEdit
        Left = 402
        Top = 119
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 296
      end
      object cxLabel5: TcxLabel
        Left = 402
        Top = 101
        Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 216
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
    object actGoodsUnitRetail: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      ShortCut = 13
      ImageIndex = 28
      FormName = 'TGoodsUnitRetail_CashForm'
      FormNameParam.Value = 'TGoodsUnitRetail_CashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MedicalProgramSPId'
          Value = Null
          Component = GuidesMedicalProgramSP
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MedicalProgramSPName'
          Value = Null
          Component = GuidesMedicalProgramSP
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsSP_Cash'
    Params = <
      item
        Name = 'inMedicalProgramSPId'
        Value = Null
        Component = GuidesMedicalProgramSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
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
          ItemName = 'bbGridToExcel'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end>
    end
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
    object dxBarButton1: TdxBarButton
      Action = actGoodsUnitRetail
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel5
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edMedicalProgramSP
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actGoodsUnitRetail
      end>
    Left = 368
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 256
    Top = 104
  end
  object GuidesMedicalProgramSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMedicalProgramSP
    FormNameParam.Value = 'TMedicalProgramSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMedicalProgramSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMedicalProgramSP
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMedicalProgramSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 601
    Top = 123
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesMedicalProgramSP
      end>
    Left = 496
    Top = 208
  end
end
