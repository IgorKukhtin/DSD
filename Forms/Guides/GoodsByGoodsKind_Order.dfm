inherited GoodsByGoodsKind_OrderForm: TGoodsByGoodsKind_OrderForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1058#1086#1074#1072#1088' '#1080' '#1042#1080#1076' '#1090#1086#1074#1072#1088#1072'> ('#1079#1072#1103#1074#1082#1080')'
  ClientHeight = 420
  ClientWidth = 1030
  ExplicitWidth = 1046
  ExplicitHeight = 459
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1030
    Height = 394
    ExplicitWidth = 1030
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 1030
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1030
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 1030
        Height = 394
        ExplicitWidth = 1030
        ExplicitHeight = 394
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsData.Appending = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsPlatformName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
            DataBinding.FieldName = 'GoodsPlatformName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupAnalystName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
            DataBinding.FieldName = 'GoodsGroupAnalystName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 106
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 160
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 172
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsOpenChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 207
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object GoodsSubName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsSubName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object GoodsKindSubName: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1077#1088#1077#1089#1086#1088#1090'. - '#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindSubName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'-'#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 93
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1090#1086#1074'.'
            DataBinding.FieldName = 'Weight'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 45
          end
          object WeightPackage: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1072#1082'. '#1076#1083#1103' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightPackage'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' 1-'#1086#1075#1086' '#1087#1072#1082#1077#1090#1072' '#1076#1083#1103' '#1059#1055#1040#1050#1054#1042#1050#1048
            Options.Editing = False
            Width = 50
          end
          object WeightPackageSticker: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1072#1082'. '#1076#1083#1103' '#1069#1058'.'
            DataBinding.FieldName = 'WeightPackageSticker'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' 1-'#1086#1075#1086' '#1087#1072#1082#1077#1090#1072' '#1076#1083#1103' '#1087#1077#1095'. '#1069#1058#1048#1050#1045#1058#1050#1048
            Options.Editing = False
            Width = 54
          end
          object WeightTotal: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightMin: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1074#1077#1089
            DataBinding.FieldName = 'WeightMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object WeightMax: TcxGridDBColumn
            Caption = #1052#1072#1093'. '#1074#1077#1089
            DataBinding.FieldName = 'WeightMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object Height: TcxGridDBColumn
            Caption = #1042#1099#1089#1086#1090#1072
            DataBinding.FieldName = 'Height'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Length: TcxGridDBColumn
            Caption = #1044#1083#1080#1085#1072
            DataBinding.FieldName = 'Length'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Width: TcxGridDBColumn
            Caption = #1064#1080#1088#1080#1085#1072
            DataBinding.FieldName = 'Width'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1054#1055
            Options.Editing = False
            Width = 70
          end
          object isNotPack: TcxGridDBColumn
            Caption = #1053#1077' '#1091#1087#1072#1082#1086#1074#1099#1074#1072#1090#1100
            DataBinding.FieldName = 'isNotPack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1054#1055
            Width = 70
          end
          object NormPack: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1099' '#1091#1087'. ('#1074' '#1082#1075'/'#1095#1072#1089')'
            DataBinding.FieldName = 'NormPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1088#1084#1099' '#1091#1087#1072#1082#1086#1074#1099#1074#1072#1085#1080#1103' ('#1074' '#1082#1075'/'#1095#1072#1089')'
            Width = 70
          end
          object IsNewQuality: TcxGridDBColumn
            Caption = #1053#1086#1074#1072#1103' '#1076#1077#1082#1083#1072#1088'.'
            DataBinding.FieldName = 'IsNewQuality'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1074#1072#1103' '#1076#1077#1082#1083#1072#1088#1072#1094#1080#1103' '#1089' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1084' "'#1042#1078#1080#1090#1080' '#1076#1086'"'
            Options.Editing = False
            Width = 70
          end
          object isOrder: TcxGridDBColumn
            Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' '#1079#1072#1103#1074#1082#1072#1093
            DataBinding.FieldName = 'isOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 96
          end
          object isScaleCeh: TcxGridDBColumn
            Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' ScaleCeh'
            DataBinding.FieldName = 'isScaleCeh'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object isNotMobile: TcxGridDBColumn
            Caption = #1053#1045' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074' '#1052#1086#1073#1080#1083#1100#1085#1086#1084' '#1072#1075#1077#1085#1090#1077
            DataBinding.FieldName = 'isNotMobile'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object isRK: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1085#1072' '#1056#1050
            DataBinding.FieldName = 'isRK'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isPackOrder: TcxGridDBColumn
            Caption = #1053#1077#1090' '#1086#1075#1088#1072#1085#1080#1095'. '#1085#1072' '#1091#1087#1072#1082
            DataBinding.FieldName = 'isPackOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077#1090' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082'.'
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object GoodsBrandName: TcxGridDBColumn
            Caption = #1041#1088#1077#1085#1076
            DataBinding.FieldName = 'GoodsBrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1088#1077#1085#1076' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 70
          end
          object isGoodsTypeKind_Sh: TcxGridDBColumn
            Caption = #1064#1090#1091#1095#1085#1099#1081
            DataBinding.FieldName = 'isGoodsTypeKind_Sh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1064#1090#1091#1095#1085#1099#1081'"'
            Options.Editing = False
            Width = 60
          end
          object isGoodsTypeKind_Nom: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081
            DataBinding.FieldName = 'isGoodsTypeKind_Nom'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1053#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081'"'
            Options.Editing = False
            Width = 60
          end
          object cxGridDBTableViewColumn2: TcxGridDBColumn
            Caption = #1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081
            DataBinding.FieldName = 'isGoodsTypeKind_Ves'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072' "'#1053#1077#1085#1086#1084#1080#1085#1072#1083#1100#1085#1099#1081'"'
            Options.Editing = False
            Width = 60
          end
          object Id: TcxGridDBColumn
            Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076
            DataBinding.FieldName = 'Id'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
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
          object PackLimit: TcxGridDBColumn
            Caption = #1054#1075#1088'. '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'PackLimit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.####;-0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1079#1072#1087#1072#1089#1072' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091
            Options.Editing = False
            Width = 80
          end
          object isPackLimit: TcxGridDBColumn
            Caption = #1045#1089#1090#1100' '#1086#1075#1088'. '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'isPackLimit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091'"'
            Options.Editing = False
            Width = 80
          end
        end
      end
      object edPackLimit: TcxCurrencyEdit
        Left = 707
        Top = 86
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 1
        Width = 60
      end
      object cxLabel11: TcxLabel
        Left = 291
        Top = 62
        Hint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1079#1072#1087#1072#1089#1072' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082'.:'
        ParentShowHint = False
        ShowHint = True
      end
    end
  end
  inherited ActionList: TActionList
    Top = 271
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
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
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Value = Null
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Value = Null
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end>
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object GoodsOpenChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = GoodsOpenChoice
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1103#1079#1100'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1074#1103#1079#1100'>'
      ImageIndex = 0
    end
    object ProtocolOpenForm: TdsdOpenForm
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
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_PackOrder: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_PackOrder
      StoredProcList = <
        item
          StoredProc = spUpdate_PackOrder
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1053#1077#1090' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082'." ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1053#1077#1090' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082'." ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 85
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdateNewQuality: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdateNewQuality
      StoredProcList = <
        item
          StoredProc = spUpdateNewQuality
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1042#1078#1080#1090#1080' '#1076#1086'" ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1042#1078#1080#1090#1080' '#1076#1086'" ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 77
      ShortCut = 16505
      RefreshOnTabSetChanges = True
    end
    object actUpdate_Top_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Top_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Top_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1058#1054#1055'  '#1044#1072'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1058#1054#1055'  '#1044#1072'"'
      ImageIndex = 79
    end
    object actUpdate_Top_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Top_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Top_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1058#1054#1055'  '#1053#1077#1090'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1058#1054#1055'  '#1053#1077#1090'"'
      ImageIndex = 80
    end
    object actUpdate_PackLimit_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PackLimit_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_PackLimit_Yes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1054#1075#1088'. '#1074' '#1076#1085'. '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082' - '#1044#1072'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1054#1075#1088'. '#1074' '#1076#1085'. '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082' - '#1044#1072'"'
      ImageIndex = 76
    end
    object mactUpdate_PackLimit_Yes_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PackLimit_Yes
        end>
      View = cxGridDBTableView
      Caption = 'mactUpdate_PackLimit_Yes_list'
      ImageIndex = 76
    end
    object mactUpdate_PackLimit_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdate_PackLimit_Yes_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079 +
        #1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091'"?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1099
      Caption = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082#1086 +
        #1074#1082#1091'"'
      Hint = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082#1086 +
        #1074#1082#1091'"'
      ImageIndex = 76
    end
    object actUpdate_PackLimit_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isPackLimit_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isPackLimit_No
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1054#1075#1088'. '#1074' '#1076#1085'. '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082' - '#1053#1077#1090'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1054#1075#1088'. '#1074' '#1076#1085'. '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1091#1087#1072#1082' - '#1053#1077#1090'"'
      ImageIndex = 77
    end
    object mactUpdate_PackLimit_No_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PackLimit_No
        end>
      View = cxGridDBTableView
      Caption = 'mactUpdate_PackLimit_No_list'
      ImageIndex = 77
    end
    object mactUpdate_PackLimit_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdate_PackLimit_No_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1084#1077#1085#1080#1090#1100' '#1042#1057#1045#1052' "'#1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087 +
        #1072#1082#1086#1074#1082#1091'"?'
      InfoAfterExecute = #1054#1090#1084#1077#1085#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1042#1057#1045#1052' "'#1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091'"'
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1042#1057#1045#1052' "'#1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091'"'
      ImageIndex = 77
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 40
  end
  inherited MasterCDS: TClientDataSet
    Top = 40
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsByGoodsKind'
    Top = 40
  end
  inherited BarManager: TdxBarManager
    Top = 40
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
          ItemName = 'bbInsertRecord'
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
          ItemName = 'bbUpdateNewQuality'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Top'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Top_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PackOrder'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbTextPackLimit'
        end
        item
          Visible = True
          ItemName = 'bbPackLimit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PackLimit_Yes'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PackLimit_No'
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
          ItemName = 'bbProtocol'
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
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdateNewQuality: TdxBarButton
      Action = actUpdateNewQuality
      Category = 0
    end
    object bbUpdate_Top: TdxBarButton
      Action = actUpdate_Top_Yes
      Category = 0
    end
    object bbUpdate_Top_No: TdxBarButton
      Action = actUpdate_Top_No
      Category = 0
    end
    object bbUpdate_PackOrder: TdxBarButton
      Action = actUpdate_PackOrder
      Category = 0
    end
    object bbTextPackLimit: TdxBarControlContainerItem
      Caption = 'TextPackLimit'
      Category = 0
      Hint = 'bbText'
      Visible = ivAlways
      Control = cxLabel11
    end
    object bbPackLimit: TdxBarControlContainerItem
      Caption = 'edPackLimit'
      Category = 0
      Hint = 'edPackLimit'
      Visible = ivAlways
      Control = edPackLimit
    end
    object bbUpdate_PackLimit_Yes: TdxBarButton
      Action = mactUpdate_PackLimit_Yes
      Category = 0
    end
    object bbUpdate_PackLimit_No: TdxBarButton
      Action = mactUpdate_PackLimit_No
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind_isOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrder'
        Value = 'Felse'
        Component = MasterCDS
        ComponentItem = 'isOrder'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotMobile'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotMobile'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTop'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsTop'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsNotPack'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsNotPack'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNormPack'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NormPack'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 112
  end
  object spUpdateNewQuality: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_isNewQuality'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsNewQuality'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsNewQuality'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 176
  end
  object spUpdate_Top_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind_isOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOrder'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotMobile'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotMobile'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTop'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsTop'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTop'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 136
  end
  object spUpdate_Top_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind_isOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOrder'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotMobile'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotMobile'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTop'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsTop'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsTop'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 128
  end
  object spUpdate_PackOrder: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_isPackOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPackOrder'
        Value = True
        Component = MasterCDS
        ComponentItem = 'IsPackOrder'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 264
  end
  object spUpdate_PackLimit_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_PackLimit'
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
        Name = 'inPackLimit'
        Value = Null
        Component = edPackLimit
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPackLimit'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 232
  end
  object spUpdate_isPackLimit_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsByGoodsKind_PackLimit'
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
        Name = 'inPackLimit'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'PackLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPackLimit'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 185
  end
end
