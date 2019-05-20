
-- Function: gpUpdate_Object_GoodsTypeKind  (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsTypeKind (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsTypeKind(
    IN inId                Integer   ,    -- ���� ������� <> 
    IN inShortName         TVarChar  ,    -- 
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_GoodsTypeKind());
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsTypeKind_ShortName(), inId, inShortName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.19         * 
*/

-- ����
--