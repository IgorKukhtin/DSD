-- Function: gpUpdate_Scale_MovementDate()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MovementDate (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MovementDate(
    IN inMovementId        Integer   , -- ���� ������� <������� ���������>
    IN inDescCode          TVarChar  , -- 
    IN inValueData         TDateTime  , -- 
    IN inSession           TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);


     IF NOT EXISTS (SELECT 1 FROM MovementDateDesc WHERE MovementDateDesc.Code ILIKE TRIM (inDescCode) AND TRIM (inDescCode) <> '')
     THEN
         -- ��������
         IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_UnComplete())
         THEN
             RAISE EXCEPTION '������.�������� � ������� <%>.��������� ����������.', lfGet_Object_ValueData_sh ((SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId));
         END IF;
         -- ��������� 
         UPDATE Movement SET OperDate = inValueData WHERE Movement.Id = inMovementId;

     ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (MovementDateDesc.Id, inMovementId, inValueData)
         FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
              LEFT JOIN MovementDateDesc ON MovementDateDesc.Code ILIKE tmp.DescCode;
     END IF;
          
     IF EXISTS (SELECT 1 FROM MovementDateDesc WHERE MovementDateDesc.Code ILIKE inDescCode AND MovementDateDesc.Id = zc_MovementDate_OperDatePartner())
        AND EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.MovementChildId > 0 AND MLM.DescId = zc_MovementLinkMovement_Master())
     THEN
         -- ��������� ��� ���������
         UPDATE Movement SET OperDate = inValueData
         WHERE Movement.Id = (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Master())
           AND Movement.DescId = zc_Movement_Tax();

         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol ((SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Master())
                                          , vbUserId
                                          , FALSE
                                           );

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     
     -- ��������� �������� <>
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Sale())
     THEN
         -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
         PERFORM lpComplete_Movement_Sale_CreateTemp();

         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId
                                       );
         -- �������� ��������
         PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                         , inUserId         := vbUserId
                                         , inIsLastComplete := TRUE
                                          );
     END IF;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.08.22                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MovementDate (inMovementId:= 0, inDescCode:= 'zc_MovementDate_OperDatePartner', inValueData:= CURRENT_TIMESTAMP, inSession:= '5')
