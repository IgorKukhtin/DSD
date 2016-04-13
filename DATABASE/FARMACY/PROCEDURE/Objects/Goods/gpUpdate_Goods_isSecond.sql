-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSecond(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isSecond(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inisSecond            Boolean   ,    -- �����������-�����
   OUT outColor        Integer   ,
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

  
   IF inisSecond = TRUE 
   THEN
      outColor = 16440317  ; --zc_Color_Red();  --16380671
   ELSE 
      IF (select COALESCE(ObjectBoolean.ValueData, False) FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Goods_First() AND ObjectBoolean.ObjectId = inId) = True
      THEN
          outColor = zc_Color_GreenL();
      ELSE
          outColor = zc_Color_White();
      END IF;
   END IF;

   

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Second(), inId, inisSecond);

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.04.16         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
