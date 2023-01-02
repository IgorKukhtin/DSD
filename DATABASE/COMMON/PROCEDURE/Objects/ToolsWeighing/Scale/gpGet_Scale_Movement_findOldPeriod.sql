-- Function: gpGet_Scale_Movement_findOldPeriod()

DROP FUNCTION IF EXISTS gpGet_Scale_Movement_findOldPeriod (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Movement_findOldPeriod(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementDescId      Integer   , -- 
    IN inBranchCode          Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (isFind     Boolean
             , OperDate   TDateTime
             , InvNumber  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);
     
     --
     IF inMovementDescId <> zc_Movement_Sale() THEN RETURN; END IF;
     
     --
     vbOperDate:= gpGet_Scale_OperDate (FALSE, inBranchCode, inSession);

     IF EXISTS (SELECT 1
                FROM MovementLinkMovement
                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                     ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                     INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                        AND Movement.DescId = zc_Movement_Sale()
                                        AND Movement.OperDate = vbOperDate
                                        AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                WHERE MovementLinkMovement.MovementId = inMovementId
                  AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
               )
     THEN
         -- ��������� - ��� ��
         RETURN QUERY
            SELECT FALSE
                 , vbOperDate :: TDateTime AS vbOperDate
                 , '' :: TVarChar AS InvNumber
                  ;
     ELSE
         -- ��������� - ��� ��
         RETURN QUERY
            -- ����� ������������� ��������� <������� ����������> �� ������
            SELECT TRUE AS isFind
                 , Movement.OperDate
                 , Movement.InvNumber
            FROM MovementLinkMovement
                 INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                 ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                 INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                    AND Movement.DescId = zc_Movement_Sale()
                                    AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '3 DAY' AND vbOperDate - INTERVAL '1 DAY'
                                    AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
            WHERE MovementLinkMovement.MovementId = inMovementId
              AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
              -- AND inSession <> '5'
            ORDER BY Movement.OperDate ASC, Movement.Id ASC
            LIMIT 1
           ;
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.06.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_Movement_findOldPeriod (inMovementId:= 24209595, inMovementDescId:= zc_Movement_Sale(), inBranchCode:= 1, inSession:= '5')
