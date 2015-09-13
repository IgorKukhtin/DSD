-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_CashRemains (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains(
    IN inMovementId    Integer,    -- ������� ���������
    IN inCashSessionId TVarChar,   -- ������ ��������� �����
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, Reserved TFloat, MCSValue TFloat,
               AlternativeGroupId Integer)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    --�������� ����� ������ ��������� ����� / �������� ���� ���������� ���������
    PERFORM lpInsertUpdate_CashSession(inCashSessionId := inCashSessionId,
                                        inDateConnect := CURRENT_TIMESTAMP::TDateTime);
    --�������� ���������� �������� ������
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;
                                        
    WITH GoodsRemains
    AS
    (
        SELECT 
            SUM(Amount) AS Remains, 
            container.objectid 
        FROM container
            INNER JOIN containerlinkobject AS CLO_Unit
                                           ON CLO_Unit.containerid = container.id 
                                          AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                          AND CLO_Unit.objectid = vbUnitId
        WHERE 
            container.descid = zc_container_count() 
            AND 
            Amount<>0
        GROUP BY 
            container.objectid
    ),
    RESERVE
    AS
    (
        SELECT
            MovementItem_Reserve.GoodsId,
            SUM(MovementItem_Reserve.Amount)::TFloat as Amount
        FROM
            gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
        WHERE
            MovementItem_Reserve.MovementId <> inMovementId
        Group By
            MovementItem_Reserve.GoodsId
    ),
    CurrentMovement
    AS
    (
        SELECT
            ObjectId,
            SUM(Amount)::TFloat as Amount
        FROM
            MovementItem
        WHERE
            MovementId = inMovementId
            AND
            Amount <> 0
        Group By
            ObjectId
    )   
--������ �������
    INSERT INTO CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved)
    SELECT 
        inCashSessionId                             AS CashSession
       ,GoodsRemains.ObjectId                       AS GoodsId
       ,COALESCE(Object_Price_View.Price,0)         AS Price
       ,(GoodsRemains.Remains 
            - COALESCE(CurrentMovement.Amount,0) 
            - COALESCE(Reserve.Amount,0))::TFloat   AS Remains
       ,Object_Price_View.MCSValue                  AS MCSValue
       ,Reserve.Amount::TFloat                      AS Reserved
    FROM
        GoodsRemains
        LEFT OUTER JOIN Object_Price_View ON GoodsRemains.ObjectId = Object_Price_View.GoodsId
                                         AND Object_Price_View.UnitId = vbUnitId
        LEFT OUTER JOIN RESERVE ON GoodsRemains.ObjectId = RESERVE.GoodsId
        LEFT OUTER JOIN CurrentMovement ON GoodsRemains.ObjectId = CurrentMovement.ObjectId;
            
    RETURN QUERY
        SELECT 
            Goods.Id,
            Goods.ValueData,
            Goods.ObjectCode,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.Price,
            CashSessionSnapShot.Reserved,
            CashSessionSnapShot.MCSValue,
            Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId
        FROM
            CashSessionSnapShot
            JOIN OBJECT AS Goods ON Goods.Id = CashSessionSnapShot.ObjectId
            LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                       ON Goods.Id = Link_Goods_AlternativeGroup.ObjectId
                                      AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
        ORDER BY
            Goods.Id;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 10.09.15                                                                       *CashSessionSnapShot
 22.08.15                                                                       *���������� ��� � ���������
 19.08.15                                                                       *CurrentMovement
 05.05.15                        *

*/

-- ����
-- SELECT * FROM gpSelect_CashRemains (inSession:= '308120')