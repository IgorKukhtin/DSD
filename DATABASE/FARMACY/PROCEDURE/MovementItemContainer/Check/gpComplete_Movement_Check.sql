-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check_ver2 (Integer,Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Check_ver2(
    IN inMovementId        Integer              , -- ���� ���������
    IN inPaidType          Integer              , --��� ������ 0-������, 1-�����
    IN inCashRegister      TVarChar             , --� ��������� ��������
    IN inCashSessionId     TVarChar             , --������ ���������
    IN inSession           TVarChar DEFAULT ''    -- ������ ������������
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
  DECLARE vbCashRegisterId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
    vbUserId:= inSession;
    IF EXISTS(SELECT 1 
              FROM 
                  Movement
              WHERE
                  Movement.ID = inMovementId
                  AND
                  Movement.DescId = zc_Movement_Check()
                  AND
                  Movement.StatusId <> zc_Enum_Status_Complete()
             )
    THEN
      --  --�������� ���� ���������
      --  UPDATE Movement SET OperDate = CURRENT_TIMESTAMP WHERE Movement.Id = inMovementId; /*���� ���������� �������� � ��������� ���� � �� ������ ������������*/

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
        --���������� �� ��������� ��������
        IF COALESCE(inCashRegister,'') <> ''
        THEN
            vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister,      --�������� ����� ��������
                                                                    inSession := inSession);
        ELSE
            vbCashRegisterId := 0;
        END IF;
        --��������� ����� � �������� ���������
        IF vbCashRegisterId <> 0 THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),inMovementId,vbCashRegisterId);
        END IF;
        -- ����������� �������� �����
        PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

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
            HAVING
                SUM(MovementItem_Reserve.Amount) <> 0
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
            COALESCE(GoodsRemains.ObjectId,SESSIONDATA.ObjectId)        AS ObjectId
           ,Object_Goods.ObjectCode::Integer                            AS GoodsCode
           ,Object_Goods.ValueData                                      AS GoodsName
           ,ROUND(COALESCE(Object_Price_View.Price,0),2)                AS Price
           ,COALESCE(GoodsRemains.Remains,0)-COALESCE(Reserve.Amount,0) AS Remains
           ,Object_Price_View.MCSValue                                  AS MCSValue
           ,Reserve.Amount::TFloat                                      AS Reserved
           ,CASE 
              WHEN SESSIONDATA.ObjectId Is Null 
                THEN TRUE 
            ELSE FALSE 
            END                                                         AS NewRow
        FROM
            GoodsRemains
            FULL OUTER JOIN SESSIONDATA ON GoodsRemains.ObjectId = SESSIONDATA.ObjectId
            INNER JOIN Object AS Object_Goods
                              ON COALESCE(GoodsRemains.ObjectId,SESSIONDATA.ObjectId) = Object_Goods.Id
            LEFT OUTER JOIN Object_Price_View ON Object_Goods.Id = Object_Price_View.GoodsId
                                             AND Object_Price_View.UnitId = vbUnitId
            LEFT OUTER JOIN RESERVE ON Object_Goods.Id = RESERVE.GoodsId                  
        WHERE
            ROUND(COALESCE(Object_Price_View.Price,0),2) <> COALESCE(SESSIONDATA.Price,0)
            OR
            COALESCE(GoodsRemains.Remains,0)-COALESCE(Reserve.Amount,0) <> COALESCE(SESSIONDATA.Remains,0)
            OR
            COALESCE(Object_Price_View.MCSValue,0) <> COALESCE(SESSIONDATA.MCSValue,0)
            OR
            COALESCE(Reserve.Amount,0) <> COALESCE(SESSIONDATA.Reserved,0);
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
            CashSessionSnapShot.ObjectId = _DIFF.ObjectId
            AND
            (
                COALESCE(CashSessionSnapShot.Price,0) <> COALESCE(_DIFF.Price)
                or
                COALESCE(CashSessionSnapShot.Remains,0) <> COALESCE(_DIFF.Remains)
                or
                COALESCE(CashSessionSnapShot.MCSValue,0) <> COALESCE(_DIFF.MCSValue)
                or
                COALESCE(CashSessionSnapShot.Reserved,0) <> COALESCE(_DIFF.Reserved)
            );
        
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
    ELSE
        RETURN QUERY
            SELECT
                Null::Integer  AS ObjectId,
                NULL::Integer  AS GoodsCode,
                NULL::TVarChar AS GoodsName,
                NULL::TFloat   AS Price,
                NULL::TFloat   AS Remains,
                NULL::TFloat   AS MCSValue,
                NULL::TFloat   AS Reserved,
                NULL::Boolean  AS NewRow
            WHERE
                1 = 0;
    END IF;
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
