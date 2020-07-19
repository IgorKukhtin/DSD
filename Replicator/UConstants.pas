unit UConstants;

interface

uses
  Winapi.Messages;

const
  // �����
  c1Sec = 1000;
  c1SecDate = 1/24/60/60;
  c1Minute = c1Sec * 60;

  // thread
  cCreateSuspended = True;
  cCreateRunning   = False;

  // ������� ���������
  cExceptionMsg       = '[%s] %s';
  cThreadExceptionMsg = '[%s] in thread %s - %s';
  cDateTimeShortStr   = 'yyyy-mm-dd hh:nn:ss';
  cDateTimeStr        = 'yyyy-mm-dd hh:nn:ss_zzz';
  cTimeStr            = 'hh:nn:ss_zzz';
  cTimeStrShort       = 'hh:nn:ss';

  // ����� ������


  // ��������� ��������



  // Zero DateTime
  cZeroDateTime: TDateTime = 0;

  // ��������� Windows
  WM_NEED_UPDATE_GRIDS = WM_USER + 1;

implementation

end.
