-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat
             , isErased Boolean
             , Remains_Amount TFloat, Remains_Summ TFloat
             , Deficit TFloat, DeficitSumm TFloat
             , Proficit TFloat, ProficitSumm TFloat, Diff TFloat, DiffSumm TFloat
             , MIComment TVarChar      
             , isAuto Boolean      
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;

  vbUnitId Integer;
  vbOperDate TDateTime;
  vbIsFullInvent Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
    -- inShowAll:= TRUE;
    vbUserId:= lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    -- ���������� ���� � ������������� � ...
    SELECT DATE_TRUNC ('DAY', Movement.OperDate) + INTERVAL '1 DAY' AS OperDate     -- ��� �������� ������� ������� 1 ���� ��� ������� >=
         , MLO_Unit.ObjectId                                        AS UnitId
         , COALESCE (MB_FullInvent.ValueData, FALSE)                AS isFullInvent
           INTO vbOperDate
              , vbUnitId
              , vbIsFullInvent
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT OUTER JOIN MovementBoolean AS MB_FullInvent
                                         ON MB_FullInvent.MovementId = Movement.Id
                                        AND MB_FullInvent.DescId = zc_MovementBoolean_FullInvent()
    WHERE Movement.Id = inMovementId;
    


    IF inShowAll = FALSE AND vbIsFullInvent = TRUE
    THEN
        -- ���������
        RETURN QUERY
            WITH tmpPrice AS (SELECT Object_Price_View.GoodsId
                                   , Object_Price_View.Price
                              FROM Object_Price_View
                              WHERE  Object_Price_View.UnitId = vbUnitId
                             )
               , REMAINS AS (   -- ������� �� ������ ���������� ���
                                SELECT 
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        -- �������
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- �����
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            /*JOIN ContainerLinkObject AS CLI_Unit 
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId*/
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                       UNION ALL
                                        -- ���� ��������� �� ��� � ��������� (����� ������� ��������� �������, ��� ���� ����������� - ��� ��� ��� ������ ������������)
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- �����
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = inMovementId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP BY ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            )
               , tmpMI AS (SELECT MovementItem.Id            AS Id
                                , MovementItem.ObjectId      AS ObjectId
                                , MovementItem.Amount        AS Amount
                                , MIFloat_Price.ValueData    AS Price
                                , MIFloat_Summ.ValueData     AS Summ
                                , MovementItem.isErased      AS isErased
                                , MIString_Comment.ValueData AS MIComment
                                , MIBoolean_isAuto.ValueData AS isAuto

                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                             ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                 LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                                    ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                   AND MIString_Comment.DescId = zc_MIString_Comment()
                                 LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                               ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                              AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND (MovementItem.isErased  = FALSE
                                OR inIsErased             = TRUE
                                  )
                           )
            -- ���������
            SELECT
                MovementItem.Id                                                     AS Id
              , Object_Goods.Id                                                     AS GoodsId
              , Object_Goods.ObjectCode                                             AS GoodsCode
              , (CASE WHEN MovementItem.ObjectId > 0 THEN '' ELSE '***' END || Object_Goods.ValueData) :: TVarChar AS GoodsName
              , MovementItem.Amount                                                 AS Amount
              , COALESCE (MovementItem.Price, tmpPrice.Price) :: TFloat             AS Price
              , MovementItem.Summ                                                   AS Summ
              , COALESCE (MovementItem.isErased, FALSE) :: Boolean                  AS isErased
              , REMAINS.Amount                                                      AS Remains_Amount

              , (COALESCE (REMAINS.Amount,0) * COALESCE (MovementItem.Price, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                     THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit
              , (CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                      THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MovementItem.Price, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                     THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                      THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                 END * COALESCE (MovementItem.Price, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

              , (COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)) :: TFloat AS DIff

              , ((COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MovementItem.Price, tmpPrice.Price)
                ) :: TFloat                                                         AS DiffSumm

              , MovementItem.MIComment                                              AS MIComment
              , CASE WHEN MovementItem.ObjectId > 0 THEN COALESCE (MovementItem.isAuto, FALSE) ELSE TRUE END :: Boolean AS isAuto

            FROM REMAINS
                FULL JOIN tmpMI AS MovementItem ON MovementItem.ObjectId = REMAINS.ObjectId

                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (MovementItem.ObjectId, REMAINS.ObjectId)

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MovementItem.ObjectId, REMAINS.ObjectId)
            ;

    ELSEIF inShowAll = FALSE 
    THEN
        -- ���������
        RETURN QUERY
            WITH tmpPrice AS (SELECT Object_Price_View.GoodsId
                                   , Object_Price_View.Price
                              FROM Object_Price_View
                              WHERE  Object_Price_View.UnitId = vbUnitId
                             )
               , REMAINS AS (   -- ������� �� ������ ���������� ���
                                SELECT 
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        -- �������
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- �����
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            /*JOIN ContainerLinkObject AS CLI_Unit 
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId*/
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                       UNION ALL
                                        -- ���� ��������� �� ��� � ��������� (����� ������� ��������� �������, ��� ���� ����������� - ��� ��� ��� ������ ������������)
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- �����
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = inMovementId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP BY ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            )
            SELECT
                MovementItem.Id                                                     AS Id
              , Object_Goods.Id                                                     AS GoodsId
              , Object_Goods.ObjectCode                                             AS GoodsCode
              , Object_Goods.ValueData                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount
              , COALESCE (MIFloat_Price.ValueData, tmpPrice.Price) :: TFloat        AS Price
              , MIFloat_Summ.ValueData                                              AS Summ
              , COALESCE (MovementItem.isErased, FALSE) :: Boolean                  AS isErased
              , REMAINS.Amount                                                      AS Remains_Amount

              , (COALESCE (REMAINS.Amount,0) * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                     THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit
              , (CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                      THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                     THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                      THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

              , (COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)) :: TFloat AS DIff

              , ((COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DiffSumm

              , MIString_Comment.ValueData                                          AS MIComment
              , CASE WHEN MovementItem.ObjectId > 0 THEN COALESCE (MIBoolean_isAuto.ValueData, FALSE) ELSE TRUE END :: Boolean AS isAuto

            FROM MovementItem
                LEFT JOIN REMAINS ON REMAINS.ObjectId = MovementItem.ObjectId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = REMAINS.ObjectId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MovementItem.ObjectId, REMAINS.ObjectId)
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                            ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()
                LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                              ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                             AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND (MovementItem.isErased  = FALSE
                   OR inIsErased          = TRUE
                  );

    ELSE
        -- ���������
        RETURN QUERY
            WITH tmpPrice AS (SELECT Object_Price_View.GoodsId
                                   , Object_Price_View.Price
                              FROM Object_Price_View
                              WHERE  Object_Price_View.UnitId = vbUnitId
                             )
               , REMAINS AS (   -- ������� �� ������ ���������� ���
                                SELECT 
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        -- �������
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- �����
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            /*JOIN ContainerLinkObject AS CLI_Unit 
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId*/
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                       UNION ALL
                                        -- ���� ��������� �� ��� � ��������� (����� ������� ��������� �������, ��� ���� ����������� - ��� ��� ��� ������ ������������)
                                        SELECT 
                                             Container.Id 
                                           , Container.ObjectId  -- �����
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = inMovementId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP BY ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            )
            SELECT
                MovementItem.Id                                                     AS Id
              , Object_Goods.Id                                                     AS GoodsId
              , Object_Goods.GoodsCodeInt                                           AS GoodsCode
              , Object_Goods.GoodsName                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount
              , COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)                  AS Price
              , MIFloat_Summ.ValueData                                              AS Summ
              , MovementItem.isErased                                               AS isErased
              , REMAINS.Amount                                                      AS Remains_Amount

              , (COALESCE (REMAINS.Amount, 0) * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                     THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit

              , (CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                      THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                     THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                      THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

              , (COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)) :: TFloat AS DIff

              , ((COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DiffSumm

              , MIString_Comment.ValueData                                          AS MIComment
              , CASE WHEN MovementItem.ObjectId > 0 THEN COALESCE (MIBoolean_isAuto.ValueData, FALSE) WHEN REMAINS.Amount <> 0 THEN TRUE ELSE FALSE END :: Boolean AS isAuto

           FROM Object_Goods_View AS Object_Goods 
                LEFT JOIN REMAINS  ON REMAINS.ObjectId = Object_Goods.Id
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = Object_Goods.Id

                LEFT JOIN MovementItem ON MovementItem.ObjectId   = Object_Goods.Id
                                      AND MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND (MovementItem.isErased  = FALSE
                                        OR inIsErased             = TRUE
                                          )
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                            ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()
                LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                              ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                             AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

            WHERE Object_Goods.ObjectId  = vbObjectId
              AND (Object_Goods.IsErased = FALSE
                OR MovementItem.Id       > 0
                  );

    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.   ��������� �.�.
 29.06.16         *
 11.07.15                                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
