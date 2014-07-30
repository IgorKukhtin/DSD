-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLink(Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsLink(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsMainId         Integer   ,    -- ������ �� ������� �����
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE vbGoodsId Integer;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   -- ���� �� ���� � inObjectId
   SELECT Object.Id INTO vbGoodsId
     FROM Object 
     JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                    AND ObjectLink.ChildObjectId = inObjectId
                    AND ObjectLink.DescId = zc_ObjectLink_Goods_Object()
     JOIN ObjectString ON ObjectString.ObjectId = Object.Id
                      AND ObjectString.DescId = zc_ObjectString_Goods_Code()
                      AND ObjectString.ValueData = inCode
    WHERE Object.DescId = zc_Object_Goods();   
   
    ioId := lpInsertUpdate_Object_Goods(vbGoodsId, inCode, inName, 0, 0, 0, inGoodsMainId, inObjectId, UserId);
  

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

	LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLink(Integer, TVarChar, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.07.14                        *

*/                                          

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
                                           