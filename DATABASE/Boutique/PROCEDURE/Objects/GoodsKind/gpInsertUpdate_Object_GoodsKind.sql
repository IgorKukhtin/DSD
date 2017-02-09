-- Function: gpInsertUpdate_Object_GoodsKind()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsKind();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsKind(
 INOUT ioId	                 Integer   ,   	-- ���� ������� < ��� ������> 
    IN inCode                Integer   ,    -- ��� ������� <��� ������> 
    IN inName                TVarChar  ,    -- �������� ������� <��� ������>
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;  
   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsKind());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_GoodsKind();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- �������� ���� ������������ ��� �������� <������������ ���� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsKind(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsKind(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsKind(), inCode, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);   

END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_GoodsKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;
  
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.06.13          *
 00.06.13          
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsKind()
                          