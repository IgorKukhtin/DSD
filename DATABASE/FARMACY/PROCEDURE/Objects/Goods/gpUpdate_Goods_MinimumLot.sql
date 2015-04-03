-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_MinimumLot(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_MinimumLot(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inMinimumLot          TFloat    ,    -- ��������� ��������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COLAESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   IF inMinimumLot = 0 THEN 
      inMinimumLot := NULL;
   END IF;   	

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_MinimumLot(), inId, inMinimumLot);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Goods_MinimumLot(Integer, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.11.14                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
