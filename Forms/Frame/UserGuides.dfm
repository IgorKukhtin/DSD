object UserGuidesFrame: TUserGuidesFrame
  Left = 0
  Top = 0
  Width = 143
  Height = 21
  TabOrder = 0
  object edUser: TcxButtonEdit
    Left = 0
    Top = 0
    Align = alClient
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 0
    Text = 'edUser'
    ExplicitHeight = 32
    Width = 143
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 64
    Top = 65533
  end
end
