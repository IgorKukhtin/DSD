-- Function: gpUpdate_Movement_ProductionUnionTech_OperDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnionTech_OperDate(Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnionTech_OperDate(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnionTech_OperDate());

    -- vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_Update_Movement_ProductionUnionTech_OperDate());


    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;

    IF inOperDate IS NOT NULL
    THEN
        vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

        IF vbStatusId = zc_Enum_Status_Complete()
        THEN
            -- �����������
            PERFORM gpUnComplete_Movement_ProductionUnion (inMovementId:= inMovementId, inSession:= inSession);
        END IF;

        -- ��������� <��������> c ����� �����
        PERFORM lpInsertUpdate_Movement (inMovementId, Movement.DescId, Movement.InvNumber, inOperDate, NULL, Movement.AccessKeyId)
        FROM Movement
        WHERE Movement.Id = inMovementId;


        IF vbStatusId = zc_Enum_Status_Complete()
        THEN
            --���� �������� ��� �������� ����� ��������
            PERFORM gpComplete_Movement_ProductionUnion (inMovementId:= inMovementId, inIsLastComplete:= FALSE, inSession:= inSession);
        END IF;

        -- ��������� ��������
        PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

    END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.04.20         *

*/
