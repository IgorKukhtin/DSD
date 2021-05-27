-- Function: gpInsertUpdate_Object_GoodsKindWeighing()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsKindWeighing();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsKindWeighing(
 INOUT ioId	         Integer,   	-- ���� ������� <������� ���������>
    IN inCode        Integer,       -- �������� <��� ������� ���������>
    IN inName        TVarChar,      -- ������� �������� ������� ���������
    IN inGoodsKindId Integer,       -- ��������
    IN inGoodsKindWeighingGroupId Integer,       -- ��������
    IN inSession     TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighing());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_GoodsKindWeighing();
   ELSE
       Code_max := inCode;
   END IF;


   -- �������� ������������ ��� ��������
--   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsKindWeighing(), inName);
   -- �������� ������������ ��� ��������
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsKindWeighing(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsKindWeighing(), Code_max, inName);

   -- ��������� ����� � <���� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsKindWeighing_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� ����� � <������ ����� �������� ��� �����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup(), ioId, inGoodsKindWeighingGroupId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsKindWeighing (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.14                                                         *
 21.03.14                                                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsKindWeighing()