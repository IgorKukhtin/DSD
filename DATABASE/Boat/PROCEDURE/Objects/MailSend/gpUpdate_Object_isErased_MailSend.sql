-- Function: gpUpdate_Object_isErased_MailSend (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_MailSend (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_MailSend(
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
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_MailSend());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inIsErased:=inIsErased, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
26.03.24          *
*/
