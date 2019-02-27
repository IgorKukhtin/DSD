-- Function: gpUpdate_Object_GoodsPropertyValue_Nom()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_Nom(Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsPropertyValue_Nom(
    IN inId                  Integer,    -- ���� ������� <�������� ������� ������� ��� ��������������>
    IN inGoodsId             Integer,    -- ������
    IN inGoodsKindId         Integer,    -- ���� ������
    IN inisGoodsTypeKind     Boolean,
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE vbisGoodsTypeKind  Boolean;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsPropertyValue_VMS());

   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ��������.';
   END IF;
  
   SELECT CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind
  INTO vbisGoodsTypeKind
   FROM Object_GoodsByGoodsKind_View
        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom
                             ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ObjectId = Object_GoodsByGoodsKind_View.Id
                            AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom()
   WHERE Object_GoodsByGoodsKind_View.GoodsId     = inGoodsId
     AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;

   ---
   IF inisGoodsTypeKind = TRUE AND vbisGoodsTypeKind = TRUE
   THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom(), inId, zc_Enum_GoodsTypeKind_Nom());
   ELSEIF inisGoodsTypeKind = TRUE AND vbisGoodsTypeKind = FALSE
   THEN
         RAISE EXCEPTION '������. � ��������� ������ <%> <%> �������� <%> ���.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), lfGet_Object_ValueData (zc_Enum_GoodsTypeKind_Nom());
   ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom(), inId, Null);
   END IF;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.02.19         *
*/

-- ����
-- 

