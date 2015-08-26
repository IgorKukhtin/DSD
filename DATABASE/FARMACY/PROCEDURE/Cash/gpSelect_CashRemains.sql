-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_CashRemains (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains(
    IN inMovementId    Integer,    -- ������� ���������
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

     RETURN QUERY
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
                SUM(CASE 
                      WHEN MovementLinkObject_CheckMember.MovementId is null 
                        THEN MovementItem_Reserve.Amount
                    ELSE 0
                    END)::TFloat as Amount_Reserve,
                SUM(CASE 
                      WHEN MovementLinkObject_CheckMember.MovementId is not null 
                        THEN MovementItem_Reserve.Amount
                    ELSE 0
                    END)::TFloat as Amount_VIP
            FROM
                gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
                LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                             ON MovementLinkObject_CheckMember.MovementId = MovementItem_Reserve.MovementId
                                            AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
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

       SELECT Goods.Id,
              Goods.ValueData,
              Goods.ObjectCode,
              (GoodsRemains.Remains 
                - COALESCE(CurrentMovement.Amount,0) 
                - COALESCE(Reserve.Amount_VIP,0))::TFloat,
              object_Price_view.price,
              Reserve.Amount_Reserve::TFloat,
              object_Price_view.mcsvalue,
              Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId
       FROM GoodsRemains
       JOIN OBJECT AS Goods ON Goods.Id = GoodsRemains.ObjectId
       LEFT OUTER JOIN object_Price_view ON GoodsRemains.ObjectId = object_Price_view.goodsid
                                        AND object_Price_view.unitid = vbUnitId
       LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                  ON Goods.Id = Link_Goods_AlternativeGroup.ObjectId
                                 AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
       LEFT OUTER JOIN RESERVE ON GoodsRemains.ObjectId = RESERVE.GoodsId
       LEFT OUTER JOIN CurrentMovement ON GoodsRemains.ObjectId = CurrentMovement.ObjectId
     ORDER BY
       Goods.ValueData;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 22.08.15                                                                       *���������� ��� � ���������
 19.08.15                                                                       *CurrentMovement
 05.05.15                        *

*/

-- ����
-- SELECT * FROM gpSelect_CashRemains (inSession:= '308120')