-- Function: gpUpdate_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_Send (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_Send(
    IN inId                    Integer    , -- ���� ������� <�������� ��� �������� � EDI>
    IN inComment               TVarChar   , --
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (inId, 0) = 0 THEN
         RAISE EXCEPTION '������.������� �������� inId  = <%>.', inId;
     END IF;



     IF inComment <> ''
     THEN
         -- ������� ������, �� �������� - ������ �� ���������
         UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Id = inId AND StatusId <> zc_Enum_Status_UnComplete();

         -- ��������� ��������
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId, inComment);
         

     ELSE
         -- ���������� ������, �������� - ������ ���������
         UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inId;

         -- ��������� �������� <����/����� ����� ���������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inId, CURRENT_TIMESTAMP);

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.02.18                                        *

*/
-- ����
-- SELECT * FROM gpUpdate_Movement_EDI_Send (inId:= 0, inComment:= '-1', inSession:= '2')
