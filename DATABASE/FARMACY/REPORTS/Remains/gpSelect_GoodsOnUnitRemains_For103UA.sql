-- Function: gpSelect_GoodsOnUnitRemains_For103UA

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_For103UA (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_For103UA(
    IN inUnitId  Integer,   -- �������������
    IN inSession TVarChar   -- ������ ������������
)
RETURNS TABLE (Store          TVarChar
             , Name           TVarChar
             , Producer       TVarChar
             , Quantity       TFloat
             , Price          TFloat
             , BarCode        TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
    -- ����� ��������� ����� ������ ���������� ����.
    vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    WITH
     tmpContainer AS
                   (SELECT Container.ObjectId
                         , Container.Id
                         , Container.Amount
                    FROM
                        Container
                    WHERE Container.DescId        = zc_Container_Count()
                      AND Container.WhereObjectId = inUnitId
                      AND Container.Amount        <> 0
                   )
   , tmpPartionMI AS
                   (SELECT CLO.ContainerId
                         , MILinkObject_Goods.ObjectId AS GoodsId_find
                    FROM ContainerLinkObject AS CLO
                        LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO.ObjectId
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId      = zc_ContainerLinkObject_PartionMovementItem()
                   )
   , tmpRemains AS (SELECT Container.ObjectId
                         , tmpPartionMI.GoodsId_find
                         , SUM (Container.Amount)  AS Amount
                    FROM tmpContainer AS Container
                        LEFT JOIN tmpPartionMI ON tmpPartionMI.ContainerId = Container.Id
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                                ON ObjectBoolean_isNotUploadSites.ObjectId = Container.ObjectId
                                               AND ObjectBoolean_isNotUploadSites.DescId   = zc_ObjectBoolean_Goods_isNotUploadSites()

                    WHERE COALESCE (ObjectBoolean_isNotUploadSites.ValueData, FALSE) = FALSE
                    GROUP BY Container.ObjectId
                           , tmpPartionMI.GoodsId_find
                   )
   , tmpGoods AS (SELECT ObjectString.ObjectId AS GoodsId_find, ObjectString.ValueData AS MakerName
                    FROM ObjectString
                    WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpRemains.GoodsId_find FROM tmpRemains)
                      AND ObjectString.DescId   = zc_ObjectString_Goods_Maker()
                   )
   , Remains AS (SELECT
                         tmpRemains.ObjectId
                       , MAX (tmpGoods.MakerName) AS MakerName
                       , SUM (tmpRemains.Amount) AS Amount
                    FROM
                        tmpRemains
                        LEFT JOIN tmpGoods ON tmpGoods.GoodsId_find = tmpRemains.GoodsId_find
                    GROUP BY tmpRemains.ObjectId
                    HAVING SUM (tmpRemains.Amount) > 0
                   )

   -- �������� ���������� ���� (��� � ����� ������� VIP)
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        )
       , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS ReserveAmount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.ObjectId
                    )
       , T1 AS (SELECT MIN (Remains.ObjectId) AS ObjectId
                FROM Remains
                     INNER JOIN Object AS Object_Goods ON Object_Goods.Id = Remains.ObjectId
                GROUP BY Object_Goods.ObjectCode
               )
      ,  tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                           , Price_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                           )

      , tmpPrice_View AS (SELECT tmpPrice.GoodsId
                               , ROUND(Price_Value.ValueData,2)::TFloat AS Price
                          FROM tmpPrice
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = tmpPrice.Id
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                          )
        -- �����-���� �������������
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
                                 , string_agg(Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc)           AS BarCode
                            FROM ObjectLink AS ObjectLink_Main_BarCode
                                 JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                 ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                 ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                 LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                            WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              AND ObjectLink_Main_BarCode.ChildObjectId > 0
                              AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                            GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                           )

      SELECT Object_Unit.ValueData                                                 AS Store
           , Object_Goods.ValueData                                                AS Name
           , Remains.MakerName::TVarChar                                           AS Producer
           , (Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0))::TFloat   AS Quantity
           , Object_Price.Price                                                    AS Price
           , COALESCE (tmpGoodsBarCode.BarCode, '')::TVarChar                      AS BarCode

      FROM Remains
           INNER JOIN T1 ON T1.ObjectId = Remains.ObjectId

           INNER JOIN Object AS Object_Unit ON Object_Unit.Id = inUnitId

           INNER JOIN Object AS Object_Goods ON Object_Goods.Id = Remains.ObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                   ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                   ON ObjectBoolean_First.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()

           LEFT OUTER JOIN tmpPrice_View AS Object_Price ON Object_Price.GoodsId = Remains.ObjectId

           LEFT OUTER JOIN tmpReserve AS Reserve_Goods ON Reserve_Goods.GoodsId = Remains.ObjectId

            -- ���������� GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
           -- �����-��� �������������
           LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Remains.ObjectId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

      WHERE (Remains.Amount - COALESCE (Reserve_Goods.ReserveAmount, 0)) > 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_For103UA (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 24.03.20                                                                     *
*/

-- ����
-- SELECT * FROM gpSelect_GoodsOnUnitRemains_For103UA (inUnitId := 377606, inSession:= '3')
