-- Function: gpUpdate_Object_isErased_ReceiptChild (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_ReceiptChild (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_ReceiptChild(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptChild());

   -- ��������
   -- PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);
   PERFORM lpDelete_Object (inObjectId, inSession) ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_ReceiptChild (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.11.15         *
*/
