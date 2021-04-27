-- Function: gpInsertUpdate_MovementItem_WagesIlliquidAssetsRepayment()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesIlliquidAssetsRepayment(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesIlliquidAssetsRepayment(
    IN inMovementID                 Integer   , -- ��������
    IN inSession                    TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbUserChechId Integer;
   DECLARE vbOperDate    TDateTime;
   DECLARE vbId          Integer;
   DECLARE vbMovementId  Integer;
   DECLARE vbStatusId    Integer;
   DECLARE vbSumma       TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
    vbUserId:= lpGetUserBySession (inSession);
    
    SELECT Movement.OperDate, MLO_Insert.ObjectId
    INTO vbOperDate, vbUserChechId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Insert
                                       ON MLO_Insert.MovementId = Movement.Id
                                      AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
    WHERE Movement.Id = inMovementID;



    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = date_trunc('month', vbOperDate) AND Movement.DescId = zc_Movement_Wages())
    THEN
        SELECT Movement.ID
        INTO vbMovementId
        FROM Movement
        WHERE Movement.OperDate = date_trunc('month', vbOperDate)
          AND Movement.DescId = zc_Movement_Wages();
    ELSE
        RAISE EXCEPTION '������.�� �� <%> �� �������.', zfCalc_MonthYearName(vbOperDate);
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.DescId = zc_MI_Master()
                                           AND MovementItem.MovementId = vbMovementId
                                           AND MovementItem.ObjectId = vbUserChechId)
    THEN
        SELECT MovementItem.id
        INTO vbId
        FROM MovementItem
        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = vbMovementId
          AND MovementItem.ObjectId = vbUserChechId;
    ELSE
        RAISE EXCEPTION '������.������ �� ���������� <%> � �� �� �������.', lfGet_Object_ValueData (inUserID);
    END IF;

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF EXISTS(SELECT 1
              FROM  MovementItem

                    LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                                  ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                                 AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()
              WHERE MovementItem.Id = vbId
                AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = True)
    THEN
      RAISE EXCEPTION '������. �� ������. ��������� ���� ���������.';
    END IF;

    vbSumma := COALESCE((SELECT  Sum(MovementFloat_TotalSumm.ValueData)
                         FROM Movement

                              INNER JOIN MovementBoolean AS MovementBoolean_CorrectIlliquidAssets
                                                        ON MovementBoolean_CorrectIlliquidAssets.MovementId = Movement.Id
                                                       AND MovementBoolean_CorrectIlliquidAssets.DescId = zc_MovementBoolean_CorrectIlliquidMarketing()
                                                       AND MovementBoolean_CorrectIlliquidAssets.ValueData = True
                              INNER JOIN MovementLinkObject AS MLO_Insert
                                                            ON MLO_Insert.MovementId = Movement.Id
                                                           AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                                           AND MLO_Insert.ObjectId = vbUserChechId

                              LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalSumm
                                                            ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()


                         WHERE Movement.OperDate >= date_trunc('month', vbOperDate) 
                           AND Movement.OperDate < date_trunc('month', vbOperDate) + INTERVAL '1 MONTH'
                           AND Movement.DescId = zc_Movement_Check()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         ), 0);
                           
     -- RAISE EXCEPTION '������. % %.', vbId, vbSumma;                           

     -- ��������� �������� <��������� ��������� �����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_IlliquidAssetsRepayment(), vbId, vbSumma);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.03.21                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesIlliquidAssetsRepayment (inMovementID := 22754189  ,  inSession:= zfCalc_UserAdmin())