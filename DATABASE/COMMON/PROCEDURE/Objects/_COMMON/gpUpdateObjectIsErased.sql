-- Function: gpUpdateObjectIsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdateObjectIsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObjectIsErased(
    IN inObjectId Integer, 
    IN Session    TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- ��� �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (Session);

   -- �������� ���� ������������
   IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId = zc_Object_ArticleLoss())
   THEN
       PERFORM lpCheckRight (Session, zc_Enum_Process_Update_Object_isErased_ArticleLoss());
   END IF;

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

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
