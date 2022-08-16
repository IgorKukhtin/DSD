-- Function: gpUnComplete_Movement_ServiceItem (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ServiceItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ServiceItem(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� - ���� ������������� ������������
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
     THEN
        RAISE EXCEPTION '������.������������� ������������.��������� ����������.';
     END IF;


    -- !!!����������� ��������� ����������!!!
    PERFORM lpUnComplete_Movement (inMovementId:= tmpMovement.MovementId_service
                                 , inUserId    := vbUserId
                                  )
    FROM -- ������ ����������
         (WITH tmpMI AS (SELECT DATE_TRUNC ('MONTH', Movement.OperDate) AS EndDate
                              , MovementItem.ObjectId                   AS UnitId
                              , MILinkObject_InfoMoney.ObjectId         AS InfoMoneyId
                              , MILinkObject_CommentInfoMoney.ObjectId  AS CommentInfoMoneyId
                              , MovementItem.Amount                     AS Amount
                         FROM Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                              INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                               ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_CommentInfoMoney.DescId = zc_MILinkObject_CommentInfoMoney()
                         WHERE Movement.Id = inMovementId
                        )                       
     , tmpMI_before AS (SELECT DATE_TRUNC ('MONTH', Movement.OperDate + INTERVAL '1 MONTH') AS StartDate
                        FROM tmpMI
                             INNER JOIN Movement ON Movement.OperDate < tmpMI.EndDate
                                                AND Movement.DescId = zc_Movement_ServiceItem()
                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                                    AND MovementItem.ObjectId   = tmpMI.UnitId
                             INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                               ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                              AND MILinkObject_InfoMoney.ObjectId       = tmpMI.InfoMoneyId
                        ORDER BY Movement.OperDate DESC
                        LIMIT 1
                       )
      , tmpListDate AS (SELECT GENERATE_SERIES (COALESCE ((SELECT tmpMI_before.StartDate FROM tmpMI_before), (SELECT tmpMI.EndDate FROM tmpMI))
                                              , (SELECT tmpMI.EndDate FROM tmpMI)
                                              , '1 MONTH' :: INTERVAL
                                               ) AS OperDate
                       )
       -- ������� ������������
     , tmpMovement_Service AS (SELECT Movement.Id                     AS MovementId
                                    , Movement.OperDate               AS OperDate
                                    , MovementItem.ObjectId           AS UnitId
                                    , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                               FROM Movement 
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                     ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                    INNER JOIN tmpMI ON tmpMI.UnitId      = MovementItem.ObjectId
                                                    AND tmpMI.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                              
                               WHERE Movement.DescId = zc_Movement_Service()
                                 AND Movement.OperDate BETWEEN (SELECT MIN (tmpListDate.OperDate) FROM tmpListDate)
                                                           AND (SELECT MAX (tmpListDate.OperDate) FROM tmpListDate)
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              )
          -- ������ ���������
          SELECT tmpMovement_Service.MovementId AS MovementId_service
          FROM tmpListDate
               INNER JOIN tmpMI ON 1=1
               INNER JOIN tmpMovement_Service ON tmpMovement_Service.OperDate    = tmpListDate.OperDate
                                             AND tmpMovement_Service.UnitId      = tmpMI.UnitId
                                             AND tmpMovement_Service.InfoMoneyId = tmpMI.InfoMoneyId
         ) AS tmpMovement
        ;

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
*/
