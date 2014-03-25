-- Function: gpInsertUpdate_GoodsKindWeighing_GoodsKind()

-- DROP FUNCTION gpInsertUpdate_GoodsKindWeighing_GoodsKind();

CREATE OR REPLACE FUNCTION gpInsertUpdate_GoodsKindWeighing_GoodsKind(
    IN inIdKindWeighing Integer,
    IN inIdGoodsKind    Integer,
    IN inSession        TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;


BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighing());
   UserId := inSession;

   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsKindWeighing_GoodsKind(), inIdGoodsKind, inIdKindWeighing);
   RETURN 0;
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_GoodsKindWeighing_GoodsKind (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.14                                                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_GoodsKindWeighing_GoodsKind(89168, 8335, '5')
-- SELECT * FROM gpInsertUpdate_GoodsKindWeighing_GoodsKind(89168, 8336, '5')
-- SELECT * FROM gpInsertUpdate_GoodsKindWeighing_GoodsKind(89168, 8328, '5')
-- SELECT * FROM gpInsertUpdate_GoodsKindWeighing_GoodsKind(89168, 8346, '5')

-- SELECT * FROM gpInsertUpdate_GoodsKindWeighing_GoodsKind(89169 , 8335, '5')
-- SELECT * FROM gpInsertUpdate_GoodsKindWeighing_GoodsKind(89169 , 8333, '5')
-- SELECT * FROM gpInsertUpdate_GoodsKindWeighing_GoodsKind(89169 , 8347, '5')



                            