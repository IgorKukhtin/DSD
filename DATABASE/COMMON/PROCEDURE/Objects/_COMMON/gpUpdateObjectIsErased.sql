-- Function: gpUpdateObjectIsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdateObjectIsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObjectIsErased(
    IN inObjectId Integer, 
    IN Session    TVarChar
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (Session);

   UPDATE Object SET isErased = NOT isErased WHERE Id = inObjectId;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inObjectId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdateObjectIsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 25.02.14                                        *
*/
