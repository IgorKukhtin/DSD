-- Function: gpGet_Scale_Movement_checkInvNumberPartner()

-- DROP FUNCTION IF EXISTS gpGet_Scale_Movement_checkInvNumberPartner (Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Movement_checkInvNumberPartner (Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Movement_checkInvNumberPartner(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPartnerId           Integer   , -- 
    IN inContractId          Integer   , -- 
    IN inInvNumberPartner    TVarChar  , -- ������ ������������
    IN inBranchCode          Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (isOk        Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (TRIM (inInvNumberPartner), '') = ''
     THEN
         RAISE EXCEPTION '������.�� ������ ����� ��������� ����������.';
     END IF;

     -- ����������
     vbOperDate:= COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), CURRENT_DATE);


     IF inBranchCode IN (301, 302, 303)
     OR EXISTS (SELECT Movement.Id
                FROM Movement
                     INNER JOIN MovementBoolean AS MovementBoolean_DocPartner
                                                ON MovementBoolean_DocPartner.MovementId = Movement.Id
                                               AND MovementBoolean_DocPartner.DescId     = zc_MovementBoolean_DocPartner()
                                             --AND MovementBoolean_DocPartner.ValueData  = TRUE
                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                  AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                  AND MovementLinkObject_From.ObjectId   = inPartnerId
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                  AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                  AND MovementLinkObject_Contract.ObjectId   = inContractId
                     INNER JOIN MovementString AS MovementString_InvNumberPartner
                                               ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                              AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                              AND MovementString_InvNumberPartner.ValueData  = inInvNumberPartner

                WHERE Movement.OperDate  BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate
                  AND Movement.DescId    = zc_Movement_WeighingPartner()
                  AND Movement.StatusId  = zc_Enum_Status_Complete()
               )
     THEN
         -- ���������
         RETURN QUERY
           SELECT TRUE;
     ELSE
         -- ���������
         RETURN QUERY
           SELECT FALSE;
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 03.02.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_Movement_checkInvNumberPartner (inMovementId:= 0, inPartnerId:= 0, inContractId:= 1, inInvNumberPartner:= '123', 1, inSession:= '5')
