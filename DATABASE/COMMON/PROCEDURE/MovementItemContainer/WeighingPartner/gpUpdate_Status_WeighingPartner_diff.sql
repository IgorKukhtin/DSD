-- Function: gpUpdate_Status_WeighingPartner_diff()

DROP FUNCTION IF EXISTS gpUpdate_Status_WeighingPartner_diff (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_WeighingPartner_diff(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ���������
     inMovementId:= (SELECT gpGet.Id
                     FROM gpGet_Movement_WeighingPartner (inMovementId:= inMovementId, inSession:= inSession
                                                          ) AS gpGet);


     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN

             --
             -- PERFORM gpUnComplete_Movement_WeighingPartner (inMovementId, inSession);
             -- ��������� �������� <�������� ���������� (��/���)>
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DocPartner(), inMovementId, FALSE);
             -- ��������� ��������
             PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

         WHEN zc_Enum_StatusCode_Complete() THEN
            --
            PERFORM gpComplete_Movement_WeighingPartner_diff (inMovementId, inSession);

         -- WHEN zc_Enum_StatusCode_Erased() THEN
         --    PERFORM gpSetErased_Movement_WeighingPartner (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ���� ������� ��������';
     END CASE;
     

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.ok';
END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.11.24                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_WeighingPartner_diff (ioId:= 0, inSession:= zfCalc_UserAdmin())
