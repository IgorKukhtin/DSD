-- Function: gpUpdate_Object_isErased_Currency (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Currency (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Currency (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Currency(
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
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_Currency());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inIsErased:=inIsErased, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
04.05.17                                                          *
02.03.17                                                          *
19.02.17                                                          *
*/
