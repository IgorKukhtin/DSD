-- Function: gpUpdate_Object_isErased_DiscountTools (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_DiscountTools (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_DiscountTools(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID
  AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_DiscountTools());

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
16.02.17                                                          *
*/
