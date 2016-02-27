-- Function: gpInsertUpdate_ObjectHistory_Price ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_Price (Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_Price (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_Price(
 INOUT ioId           Integer,    -- ���� ������� <������� ������� ������>
    IN inPriceId      Integer,    -- �����
    IN inOperDate     TDateTime,  -- ���� �������� ������
    IN inPrice        TFloat,     -- ����
    IN inMCSValue     TFloat,     -- ���
    IN inMCSPeriod    TFloat,     -- ���������� ���� ��� ������� ���(������)
    IN inMCSDay       TFloat,     -- ��������� ����� ���� ���
    IN inSession      TVarChar    -- ������ ������������
)
  RETURNS integer AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- ��������
   IF COALESCE (inPriceId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� <�����>.';
   END IF;
   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_Price(), inPriceId, inOperDate, vbUserId);
   -- ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_Price_Value(), ioId, inPrice);
   -- ���
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_Price_MCSValue(), ioId, inMCSValue);
   
   -- ���������� ���� ��� ������� ���
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_Price_MCSPeriod(), ioId, inMCSPeriod);
   -- ��������� ����� ���� ���
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_Price_MCSDay(), ioId, inMCSDay);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.02.16         *
 04.07.14         *

*/
