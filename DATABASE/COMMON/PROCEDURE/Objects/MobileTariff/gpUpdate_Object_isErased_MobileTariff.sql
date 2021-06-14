-- Function: gpUpdate_Object_isErased_MobileTariff (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_MobileTariff (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_MobileTariff(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MobileTariff());

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.06.21         *
*/
