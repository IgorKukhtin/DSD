unit UConstants;

interface

const
  cINIFolder = 'SendDataWMS';

  // �����
  c1Sec = 1000;

  // ������� ���������
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
  cImpErrWrongType        = 1; // �������� �������� ������ ����� ������������ ���
  cImpErrInvalidDateTime  = 2; // �������� ������ ����
  cImpErrAttrNotExists    = 3; // ������� � �������� ������ �� ������ � ������
  cImpErrWrongPacketData  = 4; // ������ �������� �� ����� ��������� ������ ������

  // Import error description
  cImpErrDescr_NotInteger   = '"%s" contain not Integer value; ';
  cImpErrDescr_NotNumeric   = '"%s" contain not Numeric value; ';
  cImpErrDescr_InvalidDate  = '"%s" contain invalid DateTime string. Expected date string in format "dd-mm-yyyy hh:mm"; ';
  cImpErrDecr_AttrNotExists = 'Attribute "%s" not exist in message';

implementation

end.
