-- Function: gpUpdate_Object_JuridicalPriorities_IsErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_JuridicalPriorities_IsErased (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_JuridicalPriorities_IsErased(
    IN inObjectId      Integer, 
    IN inIsSetErased   Boolean, 
    IN inIsErased      Boolean, 
    IN Session         TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- ��� �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (Session);

   -- ��������
   IF inIsSetErased <> inIsErased
   THEN
     PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_JuridicalPriorities_IsErased (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ������ �.�.
 12.06.22                                                                   *
*/