inherited MakerForm: TMakerForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1054#1057
  ClientHeight = 382
  ClientWidth = 581
  ExplicitWidth = 589
  ExplicitHeight = 416
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 581
    Height = 356
    ExplicitWidth = 476
    ExplicitHeight = 350
    ClientRectBottom = 356
    ClientRectRight = 581
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 476
      ExplicitHeight = 350
      inherited cxGrid: TcxGrid
        Width = 581
        Height = 356
        ExplicitWidth = 476
        ExplicitHeight = 350
        inherited cxGridDBTableView: TcxGridDBTableView
          OnDblClick = nil
          OnKeyDown = nil
          OnKeyPress = nil
          OnCustomDrawCell = nil
          DataController.Filter.OnChanged = nil
          Images = dmMain.SortImageList
          OptionsData.Appending = True
          OptionsData.Inserting = True
          OptionsView.Footer = False
          OptionsView.GroupFooterMultiSummaries = True
          OptionsView.GroupSummaryLayout = gslStandard
          OptionsView.HeaderAutoHeight = False
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          OnColumnHeaderClick = nil
          OnCustomDrawColumnHeader = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentVert = vaCenter
            Width = 106
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Width = 257
          end
          object clCountryName: TcxGridDBColumn
            Caption = #1057#1090#1088#1072#1085#1072
            DataBinding.FieldName = 'CountryName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = CountryChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Width = 147
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 315
    Top = 64
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 191
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      Params = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
        end
        item
          Name = 'CountryId'
          Component = MasterCDS
          ComponentItem = 'CountryId'
        end
        item
          Name = 'CountryName'
          Component = MasterCDS
          ComponentItem = 'CountryName'
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ShortCut = 13
      ImageIndex = 7
      DataSource = MasterDS
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      View = cxGridDBTableView
      Caption = 'InsertRecord'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
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
      DataSource = MasterDS
    end
    object dsdUpdateErased1: TdsdUpdateErased
      Category = 'DSDLib'
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
      DataSource = MasterDS
    end
    object dsdUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObject
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObject
        end>
      Caption = 'dsdUpdateDataSet'
      DataSource = MasterDS
    end
    object CountryChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'CountryChoiceForm'
      FormName = 'TCountryForm'
      FormNameParam.Value = 'TCountryForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Component = MasterCDS
          ComponentItem = 'CountryId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'CountryName'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 40
  end
  inherited MasterCDS: TClientDataSet
    MasterFields = 'Id'
    PacketRecords = 0
    AfterInsert = nil
    Top = 72
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Maker'
    Left = 96
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 176
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
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbChoice'
        end>
    end
    object bbInsert: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbEdit: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdUpdateErased1
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 168
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
    Left = 400
    Top = 152
  end
  object spInsertUpdateObject: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Maker'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Name = 'inCountryId'
        Component = MasterCDS
        ComponentItem = 'CountryId'
        ParamType = ptInput
      end>
    Left = 240
    Top = 168
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Country'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Component = MasterCDS
        ComponentItem = 'Code'
      end
      item
        Name = 'Name'
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
      end>
    Left = 408
    Top = 72
  end
end
