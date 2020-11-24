-- Function: gpInsertUpdate_Object_ContractGoods_byPriceList  ()

DROP FUNCTION IF EXISTS gpUpdate_Object_ContractGoods_Price0(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ContractGoods_Price0(
    IN inId        Integer   ,    -- 
   OUT outPrice    TFloat    ,    --
    IN inSession   TVarChar       -- ������ ������������
)
 RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractGoods());
   
   IF COALESCE (inId,0) = 0
   THEN
       RETURN;
   END IF;
   
   outPrice := 0;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractGoods_Price(), inId, outPrice);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.11.20         *
*/

-- ����
--