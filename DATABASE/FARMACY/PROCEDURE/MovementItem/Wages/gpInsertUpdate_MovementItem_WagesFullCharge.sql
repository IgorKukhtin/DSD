-- Function: gpInsertUpdate_MovementItem_WagesFullCharge()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesFullCharge(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesFullCharge(
    IN inUnitID                     Integer   , -- �������������
    IN inOperDate                   TDateTime , --
   OUT outSummaFullCharge           TFloat    , -- �����
    IN inSession                    TVarChar    -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbId         Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbSumma      TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

     -- ��������� ������ ����������� � ������� ������
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager()))
    THEN
      RAISE EXCEPTION '��������� ������ ���������� ��������������';
    END IF;

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = date_trunc('month', inOperDate) AND Movement.DescId = zc_Movement_Wages())
    THEN
        SELECT Movement.ID
        INTO vbMovementId
        FROM Movement
        WHERE Movement.OperDate = date_trunc('month', inOperDate)
          AND Movement.DescId = zc_Movement_Wages();
    ELSE
        vbMovementId := lpInsertUpdate_Movement_Wages (ioId              := 0
                                                     , inInvNumber       := CAST (NEXTVAL ('Movement_Wages_seq')  AS TVarChar)
                                                     , inOperDate        := date_trunc('month', inOperDate)
                                                     , inUserId          := vbUserId
                                                       );

    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.DescId = zc_MI_Sign()
                                           AND MovementItem.MovementId = vbMovementId
                                           AND MovementItem.ObjectId = inUnitID)
    THEN
        SELECT MovementItem.id
        INTO vbId
        FROM MovementItem
        WHERE MovementItem.DescId = zc_MI_Sign()
          AND MovementItem.MovementId = vbMovementId
          AND MovementItem.ObjectId = inUnitID;
    ELSE
        vbId := 0;
    END IF;

    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    IF vbIsInsert = TRUE
    THEN
         -- ��������� <������� ���������>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, 0, 0);
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
                                                                     
                    LEFT JOIN MovementItemFloat AS MIFloat_SummaFullCharge
                                                ON MIFloat_SummaFullCharge.MovementItemId = MovementItem.Id
                                               AND MIFloat_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()
                                               
              WHERE MovementItem.Id = vbId
                AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = True
                AND COALESCE(MIFloat_SummaFullCharge.ValueData, 0) <> 0)
    THEN
      RAISE EXCEPTION '������. �������������� ������� ������. ��������� ���� ���������.';
    END IF;

    vbSumma := COALESCE(Round((
                         SELECT SUM (CASE WHEN MovementLinkObject_ArticleLoss.ObjectId = 23653195
                                          THEN COALESCE (Round(MovementFloat_TotalSummSale.ValueData, 2), 0)
                                          ELSE COALESCE (Round(MovementFloat_TotalSumm.ValueData, 2), 0) - COALESCE(MovementFloat_SummaFund.ValueData, 0) END)
                         FROM Movement

                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  = inUnitID

                              INNER JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                            ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                           AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()

                              LEFT JOIN MovementFloat AS MovementFloat_SummaFund
                                                      ON MovementFloat_SummaFund.MovementId =  Movement.Id
                                                     AND MovementFloat_SummaFund.DescId = zc_MovementFloat_SummaFund()
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                                      ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()
                         WHERE Movement.OperDate BETWEEN date_trunc('month', inOperDate) AND date_trunc('month', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_Loss()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND MovementLinkObject_ArticleLoss.ObjectId IN (13892113, 23653195)), 2), 0);

     -- ��������� �������� <������ ��������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFullChargeMonth(), vbId, - vbSumma);

     -- ��������� <������� ���������>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, lpGet_MovementItem_WagesAE_TotalSum (vbId, vbUserId), 0);

    outSummaFullCharge := COALESCE((SELECT SUM(MIFloat_SummaFullCharge.ValueData)
                                    FROM MovementItemFloat AS MIFloat_SummaFullCharge
                                    WHERE MIFloat_SummaFullCharge.MovementItemId = vbId
                                      AND MIFloat_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()), 0);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.03.20                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesFullCharge (inUnitID := 183289, inOperDate := '01.10.2021', inSession := '3')

 