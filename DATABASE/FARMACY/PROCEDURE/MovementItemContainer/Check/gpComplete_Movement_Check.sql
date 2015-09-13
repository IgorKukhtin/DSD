-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer,Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer,Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Check(
    IN inMovementId        Integer              , -- ���� ���������
    IN inPaidType          Integer              , --��� ������ 0-������, 1-�����
    IN inCashRegisterId    Integer              , --� ��������� ��������
    IN inCashSessionId     TVarChar             , --������ ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS TABLE (
    Id Integer,
    GoodsCode Integer,
    GoodsName TVarChar,
    Price TFloat,
    Remains TFloat,
    MCSValue TFloat,
    Reserved TFloat,
    NewRow Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
  DECLARE vbUnitId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
    vbUserId:= inSession;

    --�������� ���� ���������
    UPDATE Movement SET OperDate = CURRENT_TIMESTAMP WHERE Movement.Id = inMovementId;

    SELECT MLO_Unit.ObjectId
    INTO vbUnitId
    FROM MovementLinkObject AS MLO_Unit 
    WHERE MLO_Unit.MovementId = inMovementId
      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit();
    
    --��������� ��� ������
    if inPaidType = 0 then
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Cash());
    ELSEIF inPaidType = 1 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Card());
    ELSE
        RAISE EXCEPTION '������.�� ��������� ��� ������';
    END IF;
    --��������� ����� � �������� ���������
    IF inCashRegisterId <> 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),inMovementId,inCashRegisterId);
    END IF;
    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    -- ���������� ��������
    PERFORM lpComplete_Movement_Check(inMovementId, -- ���� ���������
                                      vbUserId);    -- ������������
    --������� ������� �� �������� ��������� �� �������
    UPDATE CashSessionSnapShot SET
        Remains = CashSessionSnapShot.Remains - MovementItem.Amount
    FROM
        MovementItem
    WHERE
        CashSessionSnapShot.CashSessionId = inCashSessionId
        AND
        CashSessionSnapShot.ObjectId = MovementItem.ObjectId
        AND
        MovementItem.MovementId = inMovementId
        AND
        MovementItem.DescId = zc_MI_Master()
        AND
        MovementItem.isErased = FALSE
        AND
        MovementItem.Amount > 0;
        
    --���������� ������� � �������� �������� � ����������
    CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , GoodsCode Integer
                           , GoodsName TVarChar
                           , Price     TFloat
                           , Remains   TFloat
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , NewRow    Boolean) ON COMMIT DROP;
    
    WITH GoodsRemains --������� �������
    AS
    (
        SELECT 
            SUM(Amount) AS Remains, 
            container.objectid 
        FROM container
            -- INNER JOIN containerlinkobject AS CLO_Unit
                                           -- ON CLO_Unit.containerid = container.id 
                                          -- AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                          -- AND CLO_Unit.objectid = vbUnitId
        WHERE 
            container.descid = zc_container_count() 
            AND
            container.WhereObjectId = vbUnitId
            AND 
            Amount<>0
        GROUP BY 
            container.objectid
    ),
    RESERVE --������
    AS
    (
        SELECT
            MovementItem_Reserve.GoodsId,
            SUM(MovementItem_Reserve.Amount)::TFloat as Amount
        FROM
            gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
        Group By
            MovementItem_Reserve.GoodsId
    ),
    REALDATA --�������� ��������� ������
    AS
    (
        SELECT 
            GoodsRemains.ObjectId                             AS ObjectId
           ,COALESCE(Object_Price_View.Price,0)               AS Price
           ,(GoodsRemains.Remains 
                - COALESCE(RESERVE.Amount,0))::TFloat         AS Remains
           ,Object_Price_View.MCSValue                        AS MCSValue
           ,Reserve.Amount::TFloat                            AS Reserved
        FROM
            GoodsRemains
            LEFT OUTER JOIN Object_Price_View ON GoodsRemains.ObjectId = Object_Price_View.GoodsId
                                             AND Object_Price_View.UnitId = vbUnitId
            LEFT OUTER JOIN RESERVE ON GoodsRemains.ObjectId = RESERVE.GoodsId
    ),
    SESSIONDATA --��������� � ������
    AS
    (
        SELECT 
            CashSessionSnapShot.ObjectId,
            CashSessionSnapShot.Price,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.MCSValue,
            CashSessionSnapShot.Reserved
        FROM
            CashSessionSnapShot
        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
    )
    --�������� �������
    INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MCSValue, Reserved, NewRow)
    SELECT
        COALESCE(REALDATA.ObjectId,SESSIONDATA.ObjectId) AS ObjectId
       ,Object_Goods.ObjectCode::Integer                 AS GoodsCode
       ,Object_Goods.ValueData                           AS GoodsName
       ,COALESCE(REALDATA.Price,0)                       AS Price
       ,COALESCE(REALDATA.Remains,0)                     AS Remains
       ,REALDATA.MCSValue                                AS MCSValue
       ,REALDATA.Reserved                                AS Reserved
       ,CASE 
          WHEN SESSIONDATA.ObjectId Is Null 
            THEN TRUE 
        ELSE FALSE 
        END                                              AS NewRow
    FROM
        REALDATA
        FULL OUTER JOIN SESSIONDATA ON REALDATA.ObjectId = SESSIONDATA.ObjectId
        INNER JOIN Object AS Object_Goods
                          ON COALESCE(REALDATA.ObjectId,SESSIONDATA.ObjectId) = Object_Goods.Id
    WHERE
        COALESCE(REALDATA.Price,0) <> COALESCE(SESSIONDATA.Price,0)
        OR
        COALESCE(REALDATA.Remains,0) <> COALESCE(SESSIONDATA.Remains,0)
        OR
        COALESCE(REALDATA.MCSValue,0) <> COALESCE(SESSIONDATA.MCSValue,0)
        OR
        COALESCE(REALDATA.Reserved,0) <> COALESCE(SESSIONDATA.Reserved,0);
    --��������� ������ � ������
    UPDATE CashSessionSnapShot SET
        Price = _DIFF.Price,
        Remains = _DIFF.Remains,
        MCSValue = _DIFF.MCSValue,
        Reserved = _DIFF.Reserved
    FROM
        _DIFF
    WHERE
        CashSessionSnapShot.CashSessionId = inCashSessionId
        AND
        CashSessionSnapShot.ObjectId = _DIFF.ObjectId;
    
    --�������� ��, ��� ���������
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
       ,_DIFF.Price
       ,_DIFF.Remains
       ,_DIFF.MCSValue
       ,_DIFF.Reserved
    FROM
        _DIFF
    WHERE
        _DIFF.NewRow = TRUE;
    --���������� ������� � �������
    RETURN QUERY
        SELECT
            _DIFF.ObjectId,
            _DIFF.GoodsCode,
            _DIFF.GoodsName,
            _DIFF.Price,
            _DIFF.Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.NewRow
        FROM
            _DIFF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 10.09.15                                                                       *  CashSession
 06.07.15                                                                       *  �������� ��� ������
 05.02.15                         *

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
