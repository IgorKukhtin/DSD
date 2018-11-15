-- Function: gpUpdate_MI_OrderInternal_ListDiff()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternal_ListDiff (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternal_ListDiff(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- �������������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS               
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;

     -- ������ ������
     CREATE TEMP TABLE _tmp_MI (Id integer, GoodsId Integer, ListDiffAmount TFloat, AmountManual TFloat, Comment TVarChar) ON COMMIT DROP;
       INSERT INTO _tmp_MI (Id, GoodsId, ListDiffAmount, AmountManual, Comment)
             WITH
                  tmpMI AS (SELECT MovementItem.Id
                                 , MovementItem.ObjectId AS GoodsId
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            )
                  -- ����������� ������ ���-�� �����
                , tmpMIFloat_ListDiff AS (SELECT MovementItemFloat.*
                                          FROM MovementItemFloat
                                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                            AND MovementItemFloat.DescId = zc_MIFloat_ListDiff()
                                            AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                                          )
                  -- ����������� ������ <������ ����������>
                , tmpMIFloat_AmountManual AS (SELECT MovementItemFloat.*
                                              FROM MovementItemFloat
                                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                AND MovementItemFloat.DescId = zc_MIFloat_AmountManual()
                                                AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                                              )
                , tmpMI_String AS (SELECT MovementItemString.*
                                    FROM MovementItemString
                                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                      AND MovementItemString.DescId = zc_MIString_Comment()
                                  )
                
             SELECT tmpMI.Id
                  , tmpMI.GoodsId
                  , COALESCE (MIFloat_ListDiff.ValueData, 0)         AS ListDiffAmount
                  , COALESCE (MIFloat_AmountManual.ValueData, 0)     AS AmountManual
                  , COALESCE (tmpMI_String.ValueData, '') ::TVarChar AS Comment
             FROM tmpMI
                  LEFT JOIN tmpMIFloat_ListDiff     AS MIFloat_ListDiff     ON MIFloat_ListDiff.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMIFloat_AmountManual AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMI_String            AS tmpMI_String         ON tmpMI_String.MovementItemId = tmpMI.Id
                  ;

     -- ������ �� ���. �����
     CREATE TEMP TABLE _tmpListDiff_MI (Id integer, GoodsId Integer, Amount TFloat, Comment TVarChar) ON COMMIT DROP;
       INSERT INTO _tmpListDiff_MI (Id, GoodsId, Amount, Comment)
              WITH    
                  -- ��������� ������
                  tmpListDiff AS (SELECT Movement.*
                                       , MovementLinkObject_Unit.ObjectId AS UnitId
                                  FROM Movement
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                                                    AND MovementLinkObject_Unit.ObjectId = inUnitId
                                  WHERE Movement.DescId = zc_Movement_ListDiff() 
                                    AND Movement.StatusId <> zc_Enum_Status_Erased() --zc_Enum_Status_Complete()
                                    AND Movement.OperDate >= '07.11.2018'
                                 )
                  -- ������ ��������� �����
                , tmpListDiff_MI_All AS (SELECT MovementItem.*
                                         FROM tmpListDiff
                                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpListDiff.Id
                                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                                     AND MovementItem.isErased   = FALSE
                                              --������������ ������� ������
                                              --INNER JOIN _tmp_MI ON _tmp_MI.GoodsId = MovementItem.ObjectId
                                     )
                  -- �������� ����� <Id ���. ������>
                , tmpMI_MovementId AS (SELECT MovementItemFloat.*
                                       FROM MovementItemFloat
                                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpListDiff_MI_All.Id FROM tmpListDiff_MI_All)
                                         AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                                         AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                                      )
                , tmpMI_Comment AS (SELECT MovementItemString.*
                                    FROM MovementItemString
                                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpListDiff_MI_All.Id FROM tmpListDiff_MI_All)
                                      AND MovementItemString.DescId = zc_MIString_Comment()
                                    )
                                                 
                SELECT tmpListDiff_MI_All.Id
                     , tmpListDiff_MI_All.ObjectId     AS GoodsId
                     , tmpListDiff_MI_All.Amount       AS Amount
                     , COALESCE (tmpMI_Comment.ValueData, '') ::TVarChar AS Comment
                FROM tmpListDiff_MI_All
                     LEFT JOIN tmpMI_MovementId ON tmpMI_MovementId.MovementItemId = tmpListDiff_MI_All.Id
                     LEFT JOIN tmpMI_Comment    ON tmpMI_Comment.MovementItemId    = tmpListDiff_MI_All.Id
                WHERE tmpMI_MovementId.ValueData IS NULL;
           
     -- ��������� ��������, ���� ������ ������ ��� � ������ ����������
     PERFORM lpInsertUpdate_MI_OrderInternal_ListDiff (inId             := COALESCE (_tmp_MI.Id, 0)
                                                     , inMovementId     := inMovementId
                                                     , inGoodsId        := COALESCE ( _tmp_MI.GoodsId, tmpListDiff_MI.GoodsId)
                                                     , inAmountManual   := (COALESCE (_tmp_MI.AmountManual,0) + COALESCE (tmpListDiff_MI.Amount, 0) ) ::TFloat
                                                     , inListDiffAmount := (COALESCE (_tmp_MI.ListDiffAmount,0) + COALESCE (tmpListDiff_MI.Amount, 0) )::TFloat

                                                     , inComment        := CASE WHEN COALESCE (_tmp_MI.Comment, '') <> '' 
                                                                                THEN CASE WHEN COALESCE (tmpListDiff_MI.Comment, '') <> '' 
                                                                                          THEN COALESCE (_tmp_MI.Comment, '') ||', '||COALESCE (tmpListDiff_MI.Comment, '')
                                                                                          ELSE COALESCE (_tmp_MI.Comment, '')
                                                                                     END 
                                                                                ELSE COALESCE (tmpListDiff_MI.Comment, '')
                                                                           END :: TVarChar
                                                     , inUserId         := vbUserId
                                                     )
     FROM _tmp_MI
          FULL JOIN (SELECT _tmpListDiff_MI.GoodsId      AS GoodsId
                          , SUM (_tmpListDiff_MI.Amount) AS Amount 
                          , STRING_AGG (DISTINCT _tmpListDiff_MI.Comment, ';') :: TVarChar AS Comment
                     FROM _tmpListDiff_MI
                     GROUP BY _tmpListDiff_MI.GoodsId
                     ) AS tmpListDiff_MI ON tmpListDiff_MI.GoodsId = _tmp_MI.GoodsId
     ;
     
     --���������� �� ������ � ������ ���. ������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), tmp.Id, inMovementId)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_List(), tmp.Id, vbUserId)
           , lpInsertUpdate_MovementItemDate (zc_MIDate_List(), tmp.Id, CURRENT_TIMESTAMP)
           , lpInsert_MovementItemProtocol (tmp.Id, vbUserId, FALSE)
     FROM _tmpListDiff_MI AS tmp;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.11.18         *
 01.11.18         *
*/

-- ����
--

 /*lpInsertUpdate_MovementItemFloat (zc_MIFloat_ListDiff(), COALESCE (_tmp_MI.Id, 0), COALESCE (_tmp_MI.ListDiffAmount,0) + COALESCE (tmpListDiff_MI.Amount, 0) )   -- ��������� �������� ���-�� �����
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), COALESCE (_tmp_MI.Id, 0), COALESCE (_tmp_MI.AmountManual,0) + COALESCE (tmpListDiff_MI.Amount, 0) ) -- ��������� �������� <������ ����������>
           , lpInsert_MovementItemProtocol (_tmp_MI.Id, vbUserId, FALSE) 
           */