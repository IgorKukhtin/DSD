-- Function: gpUpdate_Object_isErased_Goods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Sticker (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Sticker(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Sticker());  --zc_Enum_Process_Update_Object_isErased_Sticker

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_Sticker (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
  01.12.15        *
*/
