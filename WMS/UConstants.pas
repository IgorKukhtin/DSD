unit UConstants;

interface

uses
  Winapi.Messages;

const
  cINIFolder = 'SendDataWMS';

  // время
  c1Sec = 1000;
  c1SecDate = 1/24/60/60;
  c1Minute = c1Sec * 60;

  // thread
  cCreateSuspended = True;
  cCreateRunning   = False;

  // шаблоны сообщений
  cExceptionMsg       = '[%s] %s';
  cThreadExceptionMsg = '[%s] in thread %s - %s';
  cDateTimeShortStr   = 'yyyy-mm-dd hh:nn:ss';
  cDateTimeStr        = 'yyyy-mm-dd hh:nn:ss_zzz';
  cTimeStr            = 'hh:nn:ss_zzz';

  // имена файлов
  cSvcLog       = 'service.log';
  cExportMsgLog = 'export.log';
  cImportMsgLog = 'import.log';


  // Error Xml Attribute not exists
  cErrXmlAttributeNotExists = Low(Integer);
  cErrStrXmlAttributeNotExists = 'Error XML Attribute not exists';

  // статус
  cStatusReady = 'ready';
  cStatusDone  = 'done';
  cStatusError = 'error';

  // Zero DateTime
  cZeroDateTime: TDateTime = 0;

  // имена пакетов импорта
  cpnOrderStatusChanged = 'order_status_changed';
  cpnReceivingResult    = 'receiving_result';

  // имена пакетов экспорта
  cpnWmsMovementASNLoad  = 'wms_Movement_ASN_LOAD';
  cpnWmsObjectClient     = 'wms_Object_CLIENT';
  cpnWmsObjectPack       = 'wms_Object_PACK';
  cpnWmsObjectSKU        = 'wms_Object_SKU';
  cpnWmsObjectSKUCode    = 'wms_Object_SKU_CODE';
  cpnWmsObjectSKUGroup   = 'wms_Object_SKU_GROUP';
  cpnWmsObjectUser       = 'wms_Object_USER';
  cpnWmsMovementIncoming = 'wms_Movement_INCOMING';
  cpnWmsMovementOrder    = 'wms_Movement_ORDER';

  // имя атрибута, который вставляется в уже готовый xml-элемент  пакета экспорта
  cWms_message_Id_Attr = 'wms_message_id';

  // дата, начиная с которой отслеживаем ошибки в таб. WMS.from_host_header_message
  cStartDate_TrackingError_from_host_header_message = '12.07.2020';

  // коды ошибок импорта
  cImpErrZero             = 0;
  cImpErrWrongType        = 1; // значение атрибута пакета имеет неправильный тип
  cImpErrInvalidDateTime  = 2; // неверный формат даты
  cImpErrAttrNotExists    = 3; // атрибут с заданным именем не найден в пакете
  cImpErrWrongPacketData  = 4; // ошибка возникла на этапе обработки данных пакета

  // описание ошибок импорта
  cImpErrDescr_NotInteger   = '"%s" не может быть преобразовано в Integer значение; ';
  cImpErrDescr_NotNumeric   = '"%s" не может быть преобразовано в числовое значение; ';
  cImpErrDescr_InvalidDate  = '"%s" содержит неверный формат даты. Ожидается строка в формате "dd-mm-yyyy hh:mm"; ';
  cImpErrDecr_AttrNotExists = 'Атрибут "%s" отсутствует в сообщении';

  // стандартные слова в тексте сообщения об ошибке, которые можно игнорировать
  cSystemErrWords: array[0..0] of string = ('[FireDAC][Phys][PG][libpq]');

  // сообщения Windows
  WM_NEED_UPDATE_GRIDS = WM_USER + 1;

implementation

end.
