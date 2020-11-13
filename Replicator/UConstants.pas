unit UConstants;

interface

uses
  Winapi.Messages;

const
  // время
  c1Sec = 1000;
  c1SecDate = 1/24/60/60;
  c1MsecDate = c1SecDate/1000;
  c1Minute = c1Sec * 60;


  // thread
  cCreateSuspended = True;
  cCreateRunning   = False;

  // шаблоны сообщений
  cCrLf                = #13#10;
  c2CrLf               = cCrLf + cCrLf;
  cExceptionMsg        = '[%s] %s';
  cThreadExceptionMsg  = '[%s] in thread %s - %s';
  cDateTimeShortStr    = 'yyyy-mm-dd hh:nn:ss';
  cDateTimeFileNameStr = 'yyyy-mm-dd_hh-nn-ss';
  cDateTimeStr         = 'yyyy-mm-dd hh:nn:ss_zzz';
  cDateTimeStrShort    = 'yyyy-mm-dd hh:nn:ss';
  cTimeStr             = 'hh:nn:ss_zzz';
  cTimeStrShort        = 'hh:nn:ss';

  // имена файлов
  cDefLogFileName = 'application.log';

  // Zero DateTime
  cZeroDateTime: TDateTime = 0;

  // сообщения Windows
  WM_NEED_UPDATE_GRIDS    = WM_USER + 1;
  WM_CHECK_REPLICA_MAXMIN = WM_USER + 2;

implementation

end.
