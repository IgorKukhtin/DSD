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
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

     -- ��������� ������ ����������� � ������� ������
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
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
              WHERE MovementItem.Id = vbId
                AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = True)
    THEN
      RAISE EXCEPTION '������. �������������� ������� ������. ��������� ���� ���������.';
    END IF;

    vbSumma := COALESCE(Round((
                         WITH CurrPRICE AS (SELECT Price_Goods.ChildObjectId              AS GoodsId
                                                 , ObjectLink_Price_Unit.ChildObjectId    AS UnitId
                                                 , ROUND(Price_Value.ValueData,2)::TFloat AS Price
                                            FROM ObjectLink AS ObjectLink_Price_Unit
                                               LEFT JOIN ObjectLink AS Price_Goods
                                                      ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                               LEFT JOIN ObjectFloat AS Price_Value
                                                      ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                                            WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                              AND ObjectLink_Price_Unit.ChildObjectId = inUnitID
                                           )

                         SELECT SUM (MovementItem.Amount * COALESCE(MIFloat_Price.ValueData, CurrPRICE.Price))
                         FROM Movement

                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  = inUnitID

                              JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId = zc_MI_Master()
                                               AND MovementItem.isErased = FALSE

                              LEFT JOIN CurrPRICE ON CurrPRICE.GoodsId = MovementItem.ObjectId

                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

                              INNER JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                            ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                           AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()

                         WHERE Movement.OperDate BETWEEN date_trunc('month', inOperDate) AND date_trunc('month', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_Loss()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND MovementLinkObject_ArticleLoss.ObjectId = 13892113), 2), 0);

     -- ��������� �������� <������ ��������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFullCharge(), vbId, - vbSumma);

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
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesFullCharge (, inSession:= '2')
