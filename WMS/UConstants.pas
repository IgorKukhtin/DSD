unit UConstants;

interface

uses
  Winapi.Messages;

const
  cINIFolder = 'SendDataWMS';

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

  // ����� ������
  cSvcLog       = 'service.log';
  cExportMsgLog = 'export.log';
  cImportMsgLog = 'import.log';


  // Error Xml Attribute not exists
  cErrXmlAttributeNotExists = Low(Integer);
  cErrStrXmlAttributeNotExists = 'Error XML Attribute not exists';

  // ������
  cStatusReady = 'ready';
  cStatusDone  = 'done';
  cStatusError = 'error';

  // Zero DateTime
  cZeroDateTime: TDateTime = 0;

  // ����� ������� �������
  cpnOrderStatusChanged = 'order_status_changed';
  cpnReceivingResult    = 'receiving_result';

  // ����� ������� ��������
  cpnWmsMovementASNLoad  = 'wms_Movement_ASN_LOAD';
  cpnWmsObjectClient     = 'wms_Object_CLIENT';
  cpnWmsObjectPack       = 'wms_Object_PACK';
  cpnWmsObjectSKU        = 'wms_Object_SKU';
  cpnWmsObjectSKUCode    = 'wms_Object_SKU_CODE';
  cpnWmsObjectSKUGroup   = 'wms_Object_SKU_GROUP';
  cpnWmsObjectUser       = 'wms_Object_USER';
  cpnWmsMovementIncoming = 'wms_Movement_INCOMING';
  cpnWmsMovementOrder    = 'wms_Movement_ORDER';

  // ��� ��������, ������� ����������� � ��� ������� xml-�������  ������ ��������
  cWms_message_Id_Attr = 'wms_message_id';

  // ����, ������� � ������� ����������� ������ � ���. WMS.from_host_header_message
  cStartDate_TrackingError_from_host_header_message = '12.07.2020';

  // ���� ������ �������
  cImpErrZero             = 0;
  cImpErrWrongType        = 1; // �������� �������� ������ ����� ������������ ���
  cImpErrInvalidDateTime  = 2; // �������� ������ ����
  cImpErrAttrNotExists    = 3; // ������� � �������� ������ �� ������ � ������
  cImpErrWrongPacketData  = 4; // ������ �������� �� ����� ��������� ������ ������

  // �������� ������ �������
  cImpErrDescr_NotInteger   = '"%s" �� ����� ���� ������������� � Integer ��������; ';
  cImpErrDescr_NotNumeric   = '"%s" �� ����� ���� ������������� � �������� ��������; ';
  cImpErrDescr_InvalidDate  = '"%s" �������� �������� ������ ����. ��������� ������ � ������� "dd-mm-yyyy hh:mm"; ';
  cImpErrDecr_AttrNotExists = '������� "%s" ����������� � ���������';

  // ����������� ����� � ������ ��������� �� ������, ������� ����� ������������
  cSystemErrWords: array[0..0] of string = ('[FireDAC][Phys][PG][libpq]');

  // ��������� Windows
  WM_NEED_UPDATE_GRIDS = WM_USER + 1;

implementation

end.
