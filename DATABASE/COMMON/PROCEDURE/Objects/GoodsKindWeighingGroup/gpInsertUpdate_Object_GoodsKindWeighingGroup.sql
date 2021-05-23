-- Function: gpInsertUpdate_Object_GoodsKindWeighingGroup()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsKindWeighingGroup();
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsKindWeighingGroup (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsKindWeighingGroup(
 INOUT ioId                  Integer   ,    -- ���� �������
    IN inCode                Integer   ,    -- ��� �������
    IN inName                TVarChar  ,    -- �������� �������
--    IN inParentId            Integer   ,    -- ������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighingGroup());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO vbCode FROM Object WHERE Object.DescId = zc_Object_GoodsKindWeighingGroup();
   ELSE
       vbCode := inCode;
   END IF;


   -- !!! �������� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsKindWeighingGroup(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsKindWeighingGroup(), vbCode);

   -- �������� ���� � ������
--   PERFORM lpCheck_Object_CycleLink (ioId, zc_ObjectLink_GoodsKindWeighingGroup_Parent(), inParentId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsKindWeighingGroup(), inCode, inName);
   -- ��������� ����� � <>
--   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsKindWeighingGroup_Parent(), ioId, inParentId);



   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsKindWeighingGroup (Integer, Integer, TVarChar, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsKindWeighingGroup()