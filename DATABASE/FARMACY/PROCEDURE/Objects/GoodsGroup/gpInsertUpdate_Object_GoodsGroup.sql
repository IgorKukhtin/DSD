-- Function: gpInsertUpdate_Object_GoodsGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
 INOUT ioId                  Integer   ,    -- ���� ������� <������ �������>
    IN inCode                Integer   ,    -- ��� ������� <������ �������>
    IN inName                TVarChar  ,    -- �������� ������� <������ �������>
    IN inParentId            Integer   ,    -- ������ �� ������ �������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_GoodsGroup());
   
   -- !!! �������� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsGroup(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroup(), Code_max);

   -- �������� ���� � ������
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_GoodsGroup_Parent(), inParentId);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsGroup(), inCode, inName);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsGroup_Parent(), ioId, inParentId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsGroup(Integer, Integer, TVarChar, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.05.13                                        * rem lpCheckUnique_Object_ValueData
 12.06.13          *
 16.06.13                                        * �������

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroup()