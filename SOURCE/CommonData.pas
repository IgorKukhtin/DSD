unit CommonData;

//  � ������ �������� ���������� ���������� ��� ����������
interface
uses Authentication, WinApi.Messages;

var
  gc_User: TUser;  // ������������, ��� ������� ����� � ���������
  gc_ProgramName: String = 'Project.exe'; // �������� ���������
  gc_allowLocalConnection: Boolean = False;
  gc_BreakingConnection: Boolean = False;
  gc_CorrectPositionForms: Boolean = True;

CONST
  UM_THREAD_EXCEPTION = WM_USER + 101;
  UM_LOCAL_CONNECTION = WM_USER + 102;

implementation

end.
