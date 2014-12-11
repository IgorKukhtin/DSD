inherited DefaultsKeyForm: TDefaultsKeyForm
  Caption = #1050#1083#1102#1095#1080' '#1076#1077#1092#1086#1083#1090#1086#1074
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Focusable = False
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Width = 575
        Height = 282
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colKey: TcxGridDBColumn
            Caption = #1050#1083#1102#1095
            DataBinding.FieldName = 'Key'
            Options.Editing = False
          end
          object colFormClassName: TcxGridDBColumn
            Caption = #1050#1083#1072#1089#1089' '#1092#1086#1088#1084#1099
            DataBinding.FieldName = 'FormClassName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenFormsForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
          end
          object colDescName: TcxGridDBColumn
            Caption = #1044#1045#1057#1050
            DataBinding.FieldName = 'DescName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenUnionDescForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
          end
        end
      end
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Key'
          DataType = ftString
        end>
    end
    object OpenFormsForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'OpenFormsForm'
      FormName = 'TFormsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FormClassName'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object InsertUpdateKey: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateKey
      StoredProcList = <
        item
          StoredProc = spInsertUpdateKey
        end>
      DataSource = MasterDS
    end
    object OpenUnionDescForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'OpenUnionDescForm'
      FormName = 'TUnionDescForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DescName'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_DefaultKey'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object DefaultKey: TDefaultKey
    Params = <
      item
        Name = 'FormClassName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FormClassName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'DescName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DescName'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 208
    Top = 72
  end
  object spInsertUpdateKey: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_DefaultKey'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inkey'
        Value = ''
        Component = DefaultKey
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inkeydata'
        Value = '{}'
        Component = DefaultKey
        ComponentItem = 'JSONKey'
        DataType = ftBlob
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 360
    Top = 160
  end
end
