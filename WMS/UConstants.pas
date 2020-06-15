unit UConstants;

interface

const
  cINIFolder = 'SendDataWMS';

  // время
  c1Sec = 1000;

  // шаблоны сообщений
  cExceptionMsg       = '[%s] %s';
  cThreadExceptionMsg = '[%s] in thread %s - %s';

  // Error Xml Attribute not exists
  cErrXmlAttributeNotExists = Low(Integer);
  cErrStrXmlAttributeNotExists = 'Error XML Attribute not exists';

  // Status
  cStatusReady = 'ready';
  cStatusDone  = 'done';
  cStatusError = 'error';

  // Zero DateTime
  cZeroDateTime: TDateTime = 0;

  // Import error codes
  cImpErrZero             = 0;
  cImpErrWrongType        = 1; // значение атрибута пакета имеет неправильный тип
  cImpErrInvalidDateTime  = 2; // неверный формат даты
  cImpErrAttrNotExists    = 3; // атрибут с заданным именем не найден в пакете
  cImpErrWrongPacketData  = 4; // ошибка возникла на этапе обработки данных пакета

  // Import error description
  cImpErrDescr_NotInteger   = '"%s" contain not Integer value; ';
  cImpErrDescr_NotNumeric   = '"%s" contain not Numeric value; ';
  cImpErrDescr_InvalidDate  = '"%s" contain invalid DateTime string. Expected date string in format "dd-mm-yyyy hh:mm"; ';
  cImpErrDecr_AttrNotExists = 'Attribute "%s" not exist in message';

implementation

end.
