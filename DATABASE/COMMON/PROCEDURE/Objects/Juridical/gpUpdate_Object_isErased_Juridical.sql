-- Function: gpUpdate_Object_isErased_Juridical (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Juridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Juridical(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   vbUserId:= lpGetUserBySession (inSession);


   IF vbUserId = 2731040 -- ������ �.�.
      AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.isErased = TRUE)
   THEN
       -- ��� �������� ���� ������������ �� ����� ���������
       vbUserId:= lpGetUserBySession (inSession);
   ELSE
       -- �������� ���� ������������ �� ����� ���������
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_Juridical());
   END IF;

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.04.20         *
*/
