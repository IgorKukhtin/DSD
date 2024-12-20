-- ����������

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Client (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Client (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Client(
    IN inObjectId Integer, 
    IN inIsErased Boolean,
    IN inSession  TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   IF inIsErased = FALSE
   THEN
       vbUserId:= lpGetUserBySession (inSession);
   ELSE 
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Client_isErased());
   END IF;

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inIsErased:=inIsErased, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
04.05.17                                                          *
28.02.17                                                          *
*/
