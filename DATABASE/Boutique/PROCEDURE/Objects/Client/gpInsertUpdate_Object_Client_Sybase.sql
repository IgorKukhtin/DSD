-- Function: gpInsertUpdate_Object_Client_Sybase (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client_Sybase (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client_Sybase (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Client_Sybase(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������> 
    IN inTotalCount               TFloat    ,    -- ����� ����������
    IN inTotalSumm                TFloat    ,    -- ����� �����
    IN inTotalSummDiscount        TFloat    ,    -- ����� ����� ������
    IN inTotalSummPay             TFloat    ,    -- ����� ����� ������
    IN inLastCount                TFloat    ,    -- ���������� � ��������� �������
    IN inLastSumm                 TFloat    ,    -- ����� ��������� �������
    IN inLastSummDiscount         TFloat    ,    -- ����� ������ � ��������� �������
    IN inLastDate                 TDateTime ,    -- ��������� ���� �������
    IN inLastUserID               Integer   ,    -- ������������ ��� ���������� ��������� �������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalCount(), ioId, inTotalCount);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSumm(), ioId, inTotalSumm);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSummDiscount(), ioId, inTotalSummDiscount);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSummPay(), ioId, inTotalSummPay);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastCount(), ioId, inLastCount);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSumm(), ioId, inLastSumm);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSummDiscount(), ioId, inLastSummDiscount);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_LastDate(), ioId, inLastDate);
   -- ��������� ����� � <������������ ��� ���������� ��������� �������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Client_LastUser(), ioId, inLastUserID);
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
09.05.17                                                           *
01.03.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Client()
