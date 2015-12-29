-- Function: gpUpdate_Object_GoodsExternal()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsExternal(Integer,Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsExternal(
    IN inId                    Integer   ,     -- ���� ������� <������ �����> 
    IN inGoodsId               Integer   ,     -- �����
    IN inGoodsKindId           Integer   ,     -- ��� ������
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsExternal());

   -- �������� ����� ���
   IF inId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = inId); END IF;
  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsExternal_Goods(), inId, inGoodsId);  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsExternal_GoodsKind(), inId, inGoodsKindId);  


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.12.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_GoodsExternal(inId:=null, inCode:=null, inName:='�����', inSession:='2')