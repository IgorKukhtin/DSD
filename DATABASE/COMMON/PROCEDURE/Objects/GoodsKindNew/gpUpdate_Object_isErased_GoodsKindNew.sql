-- Function: gpUpdate_Object_isErased_GoodsKindNew (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_GoodsKindNew (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_GoodsKindNew(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_GoodsKindNew());

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Object_isErased_GoodsKindNew (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  20.12.22        *
*/
