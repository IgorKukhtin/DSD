-- Function: gpInsertUpdate_Object_GoodsGroupPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroupPromo(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroupPromo(
 INOUT ioId                  Integer   ,    -- ���� ������� <������ �������>
    IN inCode                Integer   ,    -- ��� ������� <������ �������>
    IN inName                TVarChar  ,    -- �������� ������� <������ �������>
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Object_GoodsGroupPromo());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_GoodsGroupPromo());
   
   -- !!! �������� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsGroupPromo(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroupPromo(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsGroupPromo(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsGroup(Integer, Integer, TVarChar, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.07.19                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroupPromo()