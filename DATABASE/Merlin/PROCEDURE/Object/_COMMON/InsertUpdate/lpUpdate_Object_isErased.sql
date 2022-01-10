-- Function: lpUpdate_Object_isErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpUpdate_Object_isErased (Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_isErased (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_isErased(
    IN inObjectId    Integer,
    IN inIsErased    Boolean, 
    IN inUserId      Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsErased Boolean;
BEGIN

   -- ��������
   UPDATE Object SET isErased = inIsErased WHERE Id = inObjectId  RETURNING DescId, isErased INTO vbDescId, vbIsErased;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inObjectId, inUserId:= inUserId, inIsUpdate:= TRUE, inIsErased:= TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.09.14                                        * add �������������� ��������
 08.05.14                                        *
*/
