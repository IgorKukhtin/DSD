-- Function: gpUpdate_MI_OrderInternal_ZeroingSUA()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternal_ZeroingSUA (Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternal_ZeroingSUA(
    IN inMovementId  Integer      , -- ���� ���������
    IN inJSON        Text      , -- json 
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsName TVarChar;
    DECLARE vbUnitName TVarChar;
    DECLARE vbAmountSend TFloat;
    DECLARE vbRemains TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);
  
    --DROP TABLE IF EXISTS tblZeroingSUAJSON;
    
    -- �� JSON � �������
    CREATE TEMP TABLE tblZeroingSUAJSON
    (
     NeedReorder           Boolean   ,
     GoodsId			   Integer   ,
     Amount                TFloat
    ) ON COMMIT DROP;

    INSERT INTO tblZeroingSUAJSON
    SELECT *
    FROM json_populate_recordset(null::tblZeroingSUAJSON, replace(replace(replace(inJSON, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    
    --raise notice 'Value 05: %', (select Count(*) from tblZeroingSUAJSON);      

     -- ������ ������
     CREATE TEMP TABLE _tmp_MI (Id integer, GoodsId Integer, AmountSUA TFloat, AmountManual TFloat, Comment TVarChar) ON COMMIT DROP;
       INSERT INTO _tmp_MI (Id, GoodsId, AmountSUA, AmountManual, Comment)
             WITH
                  tmpMI AS (SELECT MovementItem.Id
                                 , MovementItem.ObjectId AS GoodsId
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            )
                  -- ����������� ������ ���-�� ���
                , tmpMIFloat_AmountSUA AS (SELECT MovementItemFloat.*
                                           FROM MovementItemFloat
                                           WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                             AND MovementItemFloat.DescId = zc_MIFloat_AmountSUA()
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
                  , COALESCE (MIFloat_AmountSUA.ValueData, 0)        AS AmountSUA
                  , COALESCE (MIFloat_AmountManual.ValueData, 0)     AS AmountManual
                  , COALESCE (tmpMI_String.ValueData, '') ::TVarChar AS Comment
             FROM tmpMI
                  LEFT JOIN tmpMIFloat_AmountSUA    AS MIFloat_AmountSUA    ON MIFloat_AmountSUA.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMIFloat_AmountManual AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMI_String            AS tmpMI_String         ON tmpMI_String.MovementItemId = tmpMI.Id
                  ;
                  
             
     -- ������ �� ���. �����
     CREATE TEMP TABLE _tmpZeroingSUA_MI (GoodsId Integer, Amount TFloat) ON COMMIT DROP;
       INSERT INTO _tmpZeroingSUA_MI (GoodsId, Amount)
       SELECT tblZeroingSUAJSON.GoodsId
            , tblZeroingSUAJSON.Amount
       FROM tblZeroingSUAJSON
       WHERE NeedReorder = True;
                
     IF NOT EXISTS(SELECT * FROM _tmpZeroingSUA_MI)
     THEN
       RAISE EXCEPTION '������. �������� ��� ��� ������������� �� ������.';
     END IF;
     
           
     -- ��������� ��������, ���� ������ ������ ��� � ������ ����������
     PERFORM lpInsertUpdate_MI_OrderInternal_FinalSUA (inId             := COALESCE (_tmp_MI.Id, 0)
                                                     , inMovementId     := inMovementId
                                                     , inGoodsId        := COALESCE ( _tmp_MI.GoodsId, tmpFinalSUA_MI.GoodsId)
                                                     , inAmountManual   := CASE WHEN COALESCE (_tmp_MI.AmountManual,0) >= COALESCE (tmpFinalSUA_MI.Amount, 0)    -- ����� ���� ����� ���� ��������
                                                                                THEN COALESCE (_tmp_MI.AmountManual,0)
                                                                                ELSE COALESCE (tmpFinalSUA_MI.Amount, 0)
                                                                           END ::TFloat
                                                     , inAmountSUA      := COALESCE (tmpFinalSUA_MI.Amount, 0)::TFloat

                                                     , inUserId         := vbUserId
                                                     )
     FROM _tmp_MI
          FULL JOIN (SELECT _tmpZeroingSUA_MI.GoodsId      AS GoodsId
                          , _tmpZeroingSUA_MI.Amount       AS Amount
                     FROM _tmpZeroingSUA_MI
                     ) AS tmpFinalSUA_MI ON tmpFinalSUA_MI.GoodsId = _tmp_MI.GoodsId
     WHERE COALESCE (_tmp_MI.AmountSUA,0) <> COALESCE (tmpFinalSUA_MI.Amount, 0)
     ;
     
     
     -- ������ ������
     DELETE FROM _tmp_MI;
       INSERT INTO _tmp_MI (Id, GoodsId, AmountSUA, AmountManual, Comment)
             WITH
                  tmpMI AS (SELECT MovementItem.Id
                                 , MovementItem.ObjectId AS GoodsId
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            )
                  -- ����������� ������ ���-�� ���
                , tmpMIFloat_AmountSUA AS (SELECT MovementItemFloat.*
                                           FROM MovementItemFloat
                                           WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                             AND MovementItemFloat.DescId = zc_MIFloat_AmountSUA()
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
                  , COALESCE (MIFloat_AmountSUA.ValueData, 0)        AS AmountSUA
                  , COALESCE (MIFloat_AmountManual.ValueData, 0)     AS AmountManual
                  , COALESCE (tmpMI_String.ValueData, '') ::TVarChar AS Comment
             FROM tmpMI
                  LEFT JOIN tmpMIFloat_AmountSUA    AS MIFloat_AmountSUA    ON MIFloat_AmountSUA.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMIFloat_AmountManual AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = tmpMI.Id
                  LEFT JOIN tmpMI_String            AS tmpMI_String         ON tmpMI_String.MovementItemId = tmpMI.Id
                  ;
                  
             
     -- ������ �� ����� ��������
     PERFORM lpInsertUpdate_MI_OrderInternal_FinalSUA (inId             := tmpOrderInternalAll.Id
                                                     , inMovementId     := inMovementId
                                                     , inGoodsId        := tmpOrderInternalAll.GoodsId
                                                     , inAmountManual   := CASE WHEN COALESCE (MovementItemFloat.ValueData,0) >= COALESCE (tmpOrderInternalAll.AmountSUA, 0)    -- ����� ���� ����� ���� ��������
                                                                                THEN COALESCE (MovementItemFloat.ValueData,0) - COALESCE (tmpOrderInternalAll.AmountSUA, 0)
                                                                                ELSE 0
                                                                           END ::TFloat
                                                     , inAmountSUA      := COALESCE (tmpOrderInternalAll.AmountSUA, 0)::TFloat

                                                     , inUserId         := vbUserId
                                                     )
     FROM (SELECT * FROM gpSelect_MovementItem_OrderInternal_Master(inMovementId := inMovementId 
                                                                  , inShowAll    := False 
                                                                  , inIsErased   := False 
                                                                  , inIsLink     := False
                                                                  , inSession    := inSession)) AS tmpOrderInternalAll
                  -- ����������� ������ <������ ����������>
          LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = tmpOrderInternalAll.Id
                                     AND MovementItemFloat.DescId = zc_MIFloat_AmountManual()

     WHERE COALESCE (tmpOrderInternalAll.AmountSUA, 0) > 0
       AND (COALESCE(tmpOrderInternalAll.ContractId, 0) = 0
        OR COALESCE(tmpOrderInternalAll.PartionGoodsDate, zc_DateEnd()) <= CURRENT_DATE + INTERVAL '1 YEAR')
     ;     

    
    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%>', inSession;
    END IF;    

    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 28.07.21                                                      *
*/  
  
-- select * from gpUpdate_MI_OrderInternal_ZeroingSUA(inMovementId := 24637173 , inJson := '[{"needreorder":"True","goodsid":1249,"amount":1},{"needreorder":"True","goodsid":17302,"amount":1}]' ,  inSession := '3');