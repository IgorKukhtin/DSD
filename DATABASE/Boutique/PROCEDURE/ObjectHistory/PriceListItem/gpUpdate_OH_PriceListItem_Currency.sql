-- Function: gpUpdate_OH_PriceListItem_Currency (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_OH_PriceListItem_Currency (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_OH_PriceListItem_Currency(
    IN inId                     Integer,    -- ���� ������� <������� �������>
    IN inCurrencyId             Integer,    -- ������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), inId, inCurrencyId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.20         *
*/

-- ����
--