-- Function: gpUpdate_Scale_Movement()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inMovementDescId       Integer   , -- ��� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF NOT EXISTS (SELECT 1 FROM gpGet_Movement_WeighingPartner (inMovementId:= inId, inSession:= inSession) AS tmp WHERE tmp.MovementDescId = inMovementDescId)
     THEN
         RAISE EXCEPTION '������. �������� �� ������ <%>', inId;
     END IF;


     -- ��������� - ������ �����
     IF inMovementDescId = zc_Movement_Sale()
     THEN
         -- ��������� ����� � <�� ���� (� ���������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     ELSEIF inMovementDescId = zc_Movement_ReturnIn()
     THEN
          -- ��������� ����� � <���� (� ���������)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);
     ELSE
         RAISE EXCEPTION '������. ��� ��������� <%> �� ����� ���� �������', inMovementDescId;
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 23.08.16                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_Movement (inId:= 0, inAssetId:= 0, inSession:= '2')
