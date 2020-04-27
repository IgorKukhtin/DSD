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
 --PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), OH_PriceListItem.Id, inCurrencyId)
   PERFORM lpInsertUpdate_ObjectHistoryLink (zc_ObjectHistoryLink_PriceListItem_Currency(), OH_PriceListItem_find.Id, inCurrencyId)
   FROM ObjectHistory AS OH_PriceListItem
        INNER JOIN ObjectHistory AS OH_PriceListItem_find
                                 ON OH_PriceListItem_find.ObjectId = OH_PriceListItem.ObjectId
   WHERE OH_PriceListItem.Id = inId
  ;

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