-- Function: gpSelect_MovementItem_MobileInventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileInventory (Integer, Boolean, Boolean, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_MobileInventory(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsOrderBy        Boolean      , --
    IN inIsAllUser        Boolean      , --
    IN inLimit            Integer      , -- 
    IN inFilter           TVarChar     , -- 
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar 
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar, PartNumber TVarChar
             , PartionCellId Integer, PartionCellName TVarChar
             , Amount TFloat, TotalCount TFloat, AmountRemains TFloat, AmountDiff TFloat, AmountRemains_curr TFloat
             , OrdUser Integer, OperDate_protocol TDateTime, UserName_protocol TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbUnitId    Integer;
  DECLARE vbStatusId  Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbFilterArt TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     IF COALESCE(inLimit, 0) <= 0 THEN inLimit := 1000; END IF;

     -- Данные для остатков
     SELECT Movement.OperDate, Movement.StatusId, MLO_Unit.ObjectId
            INTO vbOperDate, vbStatusId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = inMovementId
                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;
     
     vbFilterArt := REPLACE(REPLACE(REPLACE(inFilter, ' ', ''), '.', ''), '-', '');

     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
     SELECT MovementItem.Id
          , MovementItem.ObjectId AS GoodsId
          , MovementItem.PartionId
          , MovementItem.Amount
          , COALESCE (MIString_PartNumber.ValueData, '')::TVarChar  AS PartNumber
          , MILO_PartionCell.ObjectId                               AS PartionCellId
          , MovementItem.isErased
     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
          JOIN MovementItem ON MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Scan()
                   AND MovementItem.isErased   = tmpIsErased.isErased
          LEFT JOIN MovementItemString AS MIString_PartNumber
                                       ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                      AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

          LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                           ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                          AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell();     

     -- Результат такой
     RETURN QUERY
       WITH tmpRemains AS (SELECT Container.Id       AS ContainerId
                               , Container.ObjectId AS GoodsId
                               , Container.Amount
                               , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        WHEN MIContainer.OperDate > vbOperDate
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        ELSE 0
                                                                   END)
                                                            , 0) AS Remains
                               --, COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                          FROM Container
                               LEFT JOIN MovementItemString AS MIString_PartNumber
                                                            ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                           AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId =  Container.Id
                                                              AND MIContainer.OperDate    >= vbOperDate
                                                              AND vbStatusId              =  zc_Enum_Status_Complete()
                          WHERE Container.WhereObjectId = vbUnitId
                            AND Container.DescId        = zc_Container_Count()
                            AND Container.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                          GROUP BY Container.Id
                                 , Container.ObjectId
                                 , Container.Amount
                                 --, COALESCE (MIString_PartNumber.ValueData, '')
                          HAVING Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        WHEN MIContainer.OperDate > vbOperDate
                                                                             THEN COALESCE (MIContainer.Amount, 0)
                                                                        ELSE 0
                                                                   END)
                                                            , 0) <> 0
                              OR Container.Amount <> 0
                         )
         , tmpProtocol AS (SELECT MovementItemProtocol.*
                                  -- № п/п
                                , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate) AS Ord
                           FROM MovementItemProtocol
                           WHERE MovementItemProtocol.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                          )
         , tmpDataAll AS (SELECT
                                 tmpMI.Id
                               , tmpMI.GoodsId
                               , tmpMI.PartNumber
                               , tmpMI.Amount
                               , tmpMI.isErased
                               , tmpProtocol.OperDate                AS OperDate_protocol
                               , tmpProtocol.UserId                  AS UserId_protocol
                               , ROW_NUMBER() OVER (PARTITION BY tmpProtocol.UserId  ORDER BY tmpProtocol.OperDate)                AS OrdUserDate
                               , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.PartNumber ORDER BY tmpProtocol.OperDate)    AS OrdGoodsDate
                          FROM tmpMI 
                               INNER JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.Id
                                                     AND tmpProtocol.Ord            = 1 
                          )
         , tmpData AS (SELECT
                              tmpDataAll.Id
                            , tmpDataAll.GoodsId
                            , tmpDataAll.PartNumber
                            , tmpDataAll.OperDate_protocol
                            , tmpDataAll.UserId_protocol
                            , tmpDataAll.OrdUserDate
                            , SUM(tmpDataPrew.Amount) AS TotalCount
                       FROM tmpDataAll 
                       
                            LEFT JOIN tmpDataAll AS tmpDataPrew 
                                                 ON tmpDataPrew.GoodsId        = tmpDataAll.GoodsId
                                                AND tmpDataPrew.PartNumber     = tmpDataAll.PartNumber
                                                AND tmpDataPrew.OrdGoodsDate  <= tmpDataAll.OrdGoodsDate
                                                AND tmpDataPrew.isErased = False
                                                  
                       GROUP BY tmpDataAll.Id
                              , tmpDataAll.GoodsId
                              , tmpDataAll.PartNumber
                              , tmpDataAll.OperDate_protocol
                              , tmpDataAll.UserId_protocol
                              , tmpDataAll.OrdUserDate
                       )
         , tmpObjectString_Article AS (SELECT ObjectString_Article.*
                                            , REPLACE(REPLACE(REPLACE(ObjectString_Article.ValueData, ' ', ''), '.', ''), '-', '')::TVarChar AS ArticleFilter
                                       FROM ObjectString AS ObjectString_Article
                                       WHERE ObjectString_Article.DescId   = zc_ObjectString_Article()
                                         AND COALESCE(ObjectString_Article.ValueData, '') <> '')

       -- Результат
       SELECT
             tmpMI.Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , ObjectString_EAN.ValueData          AS EAN
           , Object_GoodsGroup.Id                AS GoodsGroupId
           , Object_GoodsGroup.ValueData         AS GoodsGroupName
           , Object_Measure.ValueData            AS MeasureName
           , tmpMI.PartNumber                    AS PartNumber
           
           , tmpMI.PartionCellId                 AS PartionCellId
           , Object_PartionCell.ValueData        AS PartionCellName

           , tmpMI.Amount                        AS Amount
           , tmpData.TotalCount ::TFloat         AS TotalCount
           , COALESCE(tmpRemains.Remains, 0)::TFloat      AS AmountRemains
           , (COALESCE (tmpData.TotalCount, 0) - COALESCE (tmpRemains.Remains, 0)) ::TFloat AS AmountDiff

           , tmpRemains.Amount                   AS AmountRemains_curr

           , tmpData.OrdUserDate::Integer
           , tmpData.OperDate_protocol
           , Object_User.ValueData AS UserName_protocol
           , tmpMI.isErased

       FROM tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpMI.PartionCellId

            LEFT JOIN tmpData ON tmpData.Id = tmpMI.Id
                              
            LEFT JOIN Object AS Object_User ON Object_User.Id = tmpData.UserId_protocol

            LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                 ON OL_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS OL_Goods_Measure
                                 ON OL_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Goods_Measure.ChildObjectId

            LEFT JOIN tmpObjectString_Article AS ObjectString_Article
                                              ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                             AND ObjectString_Article.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_EAN
                                   ON ObjectString_EAN.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()

            LEFT JOIN (SELECT tmpRemains.GoodsId/*, tmpRemains.PartNumber*/, SUM (tmpRemains.Amount)::TFloat AS Amount, SUM (tmpRemains.Remains)::TFloat AS Remains
                       FROM tmpRemains
                       GROUP BY tmpRemains.GoodsId --, tmpRemains.PartNumber
                      ) AS tmpRemains ON tmpRemains.GoodsId    = tmpMI.GoodsId
                                     --AND tmpRemains.PartNumber = tmpMI.PartNumber

       WHERE (tmpData.UserId_protocol = vbUserId OR inIsAllUser = TRUE)
         AND (COALESCE(inFilter, '') = '' OR Object_Goods.ValueData ILIKE '%'||COALESCE(inFilter, '')||'%' 
                                          OR ObjectString_Article.ValueData ILIKE '%'||COALESCE(inFilter, '')||'%' 
                                          OR ObjectString_Article.ArticleFilter ILIKE '%'||COALESCE(vbFilterArt, '')||'%'
                                          OR Object_Goods.ObjectCode::TVarChar ILIKE '%'||COALESCE(inFilter, '')||'%'  )
       ORDER BY CASE WHEN inIsOrderBy = TRUE THEN Object_Goods.ValueData ELSE Null END
              , CASE WHEN inIsOrderBy = FALSE THEN tmpData.OperDate_protocol ELSE Null END DESC
       LIMIT inLimit
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.24                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_MovementItem_MobileInventory (inMovementId := 5773 , inIsOrderBy := 'False', inIsAllUser := 'False', inIsErased := 'False', inLimit := 0, inFilter := '', inSession := '254935');