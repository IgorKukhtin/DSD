-- Function: lpUpdate_Object_isErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpUpdate_Object_isErased (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_isErased(
    IN inObjectId    Integer, 
    IN inUserId      Integer
)
RETURNS VOID AS
$BODY$
   DECLARE vbIsErased Boolean;
BEGIN

   -- ��������
   UPDATE Object SET isErased = NOT isErased WHERE Id = inObjectId  RETURNING isErased INTO vbIsErased;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inObjectId, inUserId:= inUserId, inIsUpdate:= TRUE, inIsErased:= vbIsErased);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUpdate_Object_isErased (Integer, Integer) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.05.14                                        *
*/
