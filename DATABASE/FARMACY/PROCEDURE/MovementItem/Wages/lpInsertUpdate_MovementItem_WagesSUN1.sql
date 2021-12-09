-- Function: lpInsertUpdate_MovementItem_WagesSUN1 ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesSUN1 (TFloat, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesSUN1(
    IN inSummaSUN1           TFloat  ,   -- ����� ������
    IN inUnitID              Integer ,   -- ���� �������
    IN inInvNumber           TVarChar,   -- �������� ����������
    IN inUserId              Integer     -- ������������
 )
RETURNS VOID AS
$BODY$
   DECLARE vbId         Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbWeek       Integer;
   DECLARE vbSummaSUN1  TFloat;
   DECLARE vbInvNumber  Text;
BEGIN

    IF COALESCE(inSummaSUN1, 0) = 0
    THEN
      RETURN;
    END IF;

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE) AND Movement.DescId = zc_Movement_Wages())
    THEN
        SELECT Movement.ID
        INTO vbMovementId
        FROM Movement
        WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
          AND Movement.DescId = zc_Movement_Wages();
    ELSE
        vbMovementId := lpInsertUpdate_Movement_Wages (ioId          := 0
                                                     , inInvNumber       := CAST (NEXTVAL ('Movement_Wages_seq')  AS TVarChar)
                                                     , inOperDate        := date_trunc('month', CURRENT_DATE)
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

    vbWeek := date_part('DAY', CURRENT_DATE)::Integer / 7 + 1;

    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    IF vbIsInsert = TRUE
    THEN
         -- ��������� <������� ���������>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, COALESCE (inSummaSUN1, 0)::TFloat, 0);
    END IF;

     -- ��������� �������� <�� �������>
    IF vbWeek = 1
    THEN
      /*inSummaSUN1 := inSummaSUN1 + COALESCE((SELECT MovementItemFloat.ValueData FROM MovementItemFloat
                                             WHERE MovementItemFloat.MovementItemID = vbId
                                               AND MovementItemFloat.DescId = zc_MIFloat_SummaWeek1()), 0);
      vbInvNumber := COALESCE(';'||(SELECT MovementItemString.ValueData FROM MovementItemString
                                             WHERE MovementItemString.MovementItemID = vbId
                                               AND MovementItemString.DescId = zc_MIString_InvNumberWeek1()), '')||COALESCE (inInvNumber, '');*/
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek1(), vbId, inSummaSUN1);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumberWeek1(), vbId, inInvNumber);
    ELSEIF vbWeek = 2
    THEN
      /*inSummaSUN1 := inSummaSUN1 + COALESCE((SELECT MovementItemFloat.ValueData FROM MovementItemFloat
                                             WHERE MovementItemFloat.MovementItemID = vbId
                                               AND MovementItemFloat.DescId = zc_MIFloat_SummaWeek2()), 0);
      vbInvNumber := COALESCE(';'||(SELECT MovementItemString.ValueData FROM MovementItemString
                                             WHERE MovementItemString.MovementItemID = vbId
                                               AND MovementItemString.DescId = zc_MIString_InvNumberWeek2()), '')||COALESCE (inInvNumber, '');*/
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek2(), vbId, inSummaSUN1);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumberWeek2(), vbId, inInvNumber);
    ELSEIF vbWeek = 3
    THEN
      /*inSummaSUN1 := inSummaSUN1 + COALESCE((SELECT MovementItemFloat.ValueData FROM MovementItemFloat
                                             WHERE MovementItemFloat.MovementItemID = vbId
                                               AND MovementItemFloat.DescId = zc_MIFloat_SummaWeek3()), 0);
      vbInvNumber := COALESCE(';'||(SELECT MovementItemString.ValueData FROM MovementItemString
                                             WHERE MovementItemString.MovementItemID = vbId
                                               AND MovementItemString.DescId = zc_MIString_InvNumberWeek3()), '')||COALESCE (inInvNumber, '');*/
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek3(), vbId, inSummaSUN1);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumberWeek3(), vbId, inInvNumber);
    ELSEIF vbWeek = 4
    THEN
      /*inSummaSUN1 := inSummaSUN1 + COALESCE((SELECT MovementItemFloat.ValueData FROM MovementItemFloat
                                             WHERE MovementItemFloat.MovementItemID = vbId
                                               AND MovementItemFloat.DescId = zc_MIFloat_SummaWeek4()), 0);
      vbInvNumber := COALESCE(';'||(SELECT MovementItemString.ValueData FROM MovementItemString
                                             WHERE MovementItemString.MovementItemID = vbId
                                               AND MovementItemString.DescId = zc_MIString_InvNumberWeek4()), '')||COALESCE (inInvNumber, '');*/
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek4(), vbId, inSummaSUN1);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumberWeek4(), vbId, inInvNumber);
    ELSEIF vbWeek = 5
    THEN
      /*inSummaSUN1 := inSummaSUN1 + COALESCE((SELECT MovementItemFloat.ValueData FROM MovementItemFloat
                                             WHERE MovementItemFloat.MovementItemID = vbId
                                               AND MovementItemFloat.DescId = zc_MIFloat_SummaWeek5()), 0);
      vbInvNumber := COALESCE(';'||(SELECT MovementItemString.ValueData FROM MovementItemString
                                             WHERE MovementItemString.MovementItemID = vbId
                                               AND MovementItemString.DescId = zc_MIString_InvNumberWeek5()), '')||COALESCE (inInvNumber, '');*/
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek5(), vbId, inSummaSUN1);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_InvNumberWeek5(), vbId, inInvNumber);
    ELSE
      RAISE EXCEPTION '������.����������� ������ ��� %', vbWeek;
    END IF;

    vbSummaSUN1 := (SELECT SUM(MIFloat_SummaSUN1.ValueData)
                    FROM MovementItemFloat AS MIFloat_SummaSUN1
                    WHERE MIFloat_SummaSUN1.MovementItemId = vbId
                      AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaWeek1(), zc_MIFloat_SummaWeek2(), zc_MIFloat_SummaWeek3(),
                                                       zc_MIFloat_SummaWeek4(), zc_MIFloat_SummaWeek5()));
     -- ��������� �������� <���� �� ���1>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaSUN1(), vbId, vbSummaSUN1);


    IF vbIsInsert = FALSE
    THEN
         -- ��������� <������� ���������>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, lpGet_MovementItem_WagesAE_TotalSum (vbId, inUserId), 0);
    END IF;


    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, inUserId, vbIsInsert);

    -- raise notice '������. % % %', inSummaSUN1, inUnitID, (SELECT Object.ValueData FROM Object WHERE object.Id = inUnitID);

    -- RAISE EXCEPTION '������. % % % % % % %', CURRENT_DATE, vbMovementId, vbId, inSummaSUN1, vbSummaSUN1, vbWeek, vbInvNumber;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.20                                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_WagesSUN1 (inSummaSUN1 := 1, inUnitID := 183292 , inInvNumber := '1111,2222', inUserId := 3)