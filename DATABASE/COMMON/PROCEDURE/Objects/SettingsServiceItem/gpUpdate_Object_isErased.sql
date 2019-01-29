-- Function: gpUpdate_Object_isErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdate_Object_isErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased(
    IN inObjectId Integer, 
    IN inSession    TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   UPDATE Object SET isErased = TRUE WHERE Id = inObjectId;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inObjectId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 29.01.19         *
*/
