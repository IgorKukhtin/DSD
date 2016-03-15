-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isFirst(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isFirst(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inisFirst             Boolean   ,    -- 1-�����
   OUT outColor              Integer   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
  
   IF inisFirst = TRUE 
   THEN
      outColor = zc_Color_GreenL();
   ELSE 
      outColor = zc_Color_White();
   END IF;


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_First(), inId, inisFirst);

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.03.16         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
