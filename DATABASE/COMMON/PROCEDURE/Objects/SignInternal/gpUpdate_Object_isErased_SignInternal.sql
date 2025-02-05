-- Function: gpUpdate_Object_isErased_SignInternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_SignInternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_SignInternal(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SignInternal());

   -- ��������
   PERFORM lp_Delete_Object (inObjectId, inSession) ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_SignInternal (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.08.16         *
*/
