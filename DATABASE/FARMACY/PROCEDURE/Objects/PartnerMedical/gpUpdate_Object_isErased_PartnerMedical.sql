-- Function: gpUpdate_Object_isErased_PartnerMedical (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_PartnerMedical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_PartnerMedical(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);
   
   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
  21.10.15        *
*/
