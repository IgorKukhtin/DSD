-- Function: gpUpdateObjectIsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdateObjectIsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObjectIsErased(
    IN inObjectId Integer, 
    IN Session    TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisErased Boolean;
BEGIN
   -- ��� �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (Session);

   vbisErased := NOT (SELECT Object.isErased FROM Object WHERE Object.Id = inObjectId);
   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inIsErased:= vbisErased, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdateObjectIsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.05.14                                        * add lpUpdate_Object_isErased
 25.02.14                                        *
*/
