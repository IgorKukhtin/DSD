-- Function: gpUpdate_Object_GoodsByGoodsKind_Income (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_Income (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_Income(
    IN inId                    Integer  , -- ���� ������� <>
    IN inGoodsIncomeId         Integer  , -- ������ ���� ������
    IN inGoodsKindIncomeId     Integer  , -- ���� ������� ���� ������
    IN inSession               TVarChar 
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind());


   -- ��������� ����� � <������  (���� ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsIncome(), inId, inGoodsIncomeId);
   -- ��������� ����� � <���� �������  (���� ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome(), inId, inGoodsKindIncomeId);



   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  
 11.12.24         *
*/

-- ����
-- 