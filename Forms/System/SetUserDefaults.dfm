inherited SetUserDefaultsForm: TSetUserDefaultsForm
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
  ClientHeight = 395
  ClientWidth = 847
  ExplicitWidth = 855
  ExplicitHeight = 422
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 847
    Height = 369
    ExplicitWidth = 847
    ExplicitHeight = 369
    ClientRectBottom = 369
    ClientRectRight = 847
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 847
      ExplicitHeight = 369
      inherited cxGrid: TcxGrid
        Width = 847
        Height = 369
        ExplicitWidth = 847
        ExplicitHeight = 369
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDefaultKey: TcxGridDBColumn
            Caption = #1050#1083#1102#1095
            DataBinding.FieldName = 'Key'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenDefaultsKeyForm
                Default = True
                Kind = bkEllipsis
              end>
            Width = 192
          end
          object colFormClassName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072
            DataBinding.FieldName = 'FormClassName'
            Width = 122
          end
          object colDescName: TcxGridDBColumn
            Caption = #1044#1045#1057#1050
            DataBinding.FieldName = 'DescName'
            Width = 97
          end
          object colUserKey: TcxGridDBColumn
            Caption = #1056#1086#1083#1100'/'#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenUserKeyForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Width = 211
          end
          object colValue: TcxGridDBColumn
            Caption = #1047#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'ObjectName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenObjectForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Width = 211
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object OpenDefaultsKeyForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenDefaultsKeyForm'
      FormName = 'TDefaultsKeyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KeyId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Key'
          DataType = ftString
        end>
      isShowModal = False
    end
    object OpenUserKeyForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenUserKeyForm'
      FormName = 'TUserKeyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object OpenObjectForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenObjectForm'
      FormName = 'TObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_DefaultValue'
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
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_DefaultValue'
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
        Name = 'indefaultkeyid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KeyId'
        ParamType = ptInput
      end
      item
        Name = 'inuserkey'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserId'
        ParamType = ptInput
      end
      item
        Name = 'indefaultvalue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ObjectId'
        DataType = ftBlob
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 456
    Top = 264
  end
end
