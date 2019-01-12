-- Function: gpUpdate_CashSerialNumber()

DROP FUNCTION IF EXISTS gpUpdate_CashSerialNumber (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_CashSerialNumber(
    IN inFiscalNumber  TVarChar,   -- ���������� �����
    IN inSerialNumber  TVarChar,   -- ��������� �����
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbUserId := lpGetUserBySession (inSession);
    
    IF EXISTS(SELECT 1 FROM Object WHERE DescId = zc_Object_CashRegister() AND ValueData = inFiscalNumber)  
    THEN
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CashRegister_SerialNumber(), Object.Id, inSerialNumber)
      FROM Object WHERE Object.DescId = zc_Object_CashRegister() AND Object.ValueData = inFiscalNumber;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 11.01.19         *
*/
