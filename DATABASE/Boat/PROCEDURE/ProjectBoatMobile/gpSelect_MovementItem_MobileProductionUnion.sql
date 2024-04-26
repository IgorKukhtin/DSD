-- Function: gpSelect_MovementItem_MobileProductionUnion()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileProductionUnion (Boolean, Boolean, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_MobileProductionUnion(
    IN inIsOrderBy        Boolean      , --
    IN inIsAllUser        Boolean      , --
    IN inLimit            Integer      , -- 
    IN inFilter           TVarChar     , -- 
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar 
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar

             , Amount TFloat, TotalCount TFloat, AmountRemains TFloat
             
             , OperDate TDateTime, InvNumber TVarChar, InvNumberFull TVarChar, StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             
             , OrdUser Integer, OperDate_protocol TDateTime, UserName_protocol TVarChar
             , MovementId_OrderClient Integer, InvNumber_OrderClient TVarChar, InvNumberFull_OrderClient TVarChar, StatusCode_OrderClient Integer, StatusName_OrderClient TVarChar
             , OperDate_OrderInternal TDateTime, InvNumber_OrderInternal TVarChar, InvNumberFull_OrderInternal TVarChar, StatusCode_OrderInternal Integer, StatusName_OrderInternal TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbFilterArt TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     IF COALESCE(inLimit, 0) <= 0 THEN inLimit := 1000; END IF;

     vbFilterArt := REPLACE(REPLACE(REPLACE(inFilter, ' ', ''), '.', ''), '-', '');

     -- Результат такой
     RETURN QUERY
       WITH tmpMovement AS (SELECT Movement.Id
                                 , Movement.OperDate
                                 , Movement.InvNumber
                                 , Movement.StatusId
                                 , MLO_From.ObjectId      AS FromId
                                 , MLO_To.ObjectId        AS ToId
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MLO_From
                                                               ON MLO_From.MovementId = Movement.Id
                                                              AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                 INNER JOIN MovementLinkObject AS MLO_To
                                                               ON MLO_To.MovementId = Movement.Id
                                                              AND MLO_To.DescId     = zc_MovementLinkObject_To()
                            WHERE Movement.DescId   = zc_Movement_ProductionUnion()
                              AND (Movement.StatusId <> zc_Enum_Status_Erased() OR inisErased = TRUE)
                              AND Movement.OperDate = CURRENT_DATE) 
       
          , tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ParentId
                           , MovementItem.ObjectId                          AS GoodsId
                           , Movement.Id                                    AS MovementId
                           , Movement.OperDate
                           , Movement.InvNumber
                           , Movement.StatusId
                           , Movement.FromId
                           , Movement.ToId
                           , MovementItem.Amount
                           , MIFloat_MovementId.ValueData :: Integer        AS MovementId_OrderClient
                           , MovementItem.isErased
                      FROM tmpMovement AS Movement
                      

                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Scan()                                                  

                           LEFT JOIN MovementItem AS MI_Master
                                                  ON MI_Master.Id         = MovementItem.ParentId
                                                 AND MI_Master.MovementId = MovementItem.MovementId
                                                 AND MI_Master.DescId     = zc_MI_Master() 

                           LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                       ON MIFloat_MovementId.MovementItemId = MI_Master.Id
                                                      AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                                                                            
                     )

         , tmpOrderInternal AS (SELECT MovementItem.Id 
                                     , MI_Master.ObjectId                             AS GoodsId
                                     , OI.Id                                          AS MovementId
                                     , OI.OperDate
                                     , OI.InvNumber
                                     , OI.StatusId
                                     , MI_Master.Amount
                                     , MovementItem.isErased
                                FROM tmpMI AS MovementItem 

                                     INNER JOIN MovementItem AS MI_Master
                                                             ON MI_Master.Id         = MovementItem.ParentId
                                                            AND MI_Master.MovementId = MovementItem.MovementId
                                                            AND MI_Master.DescId     = zc_MI_Master() 
                                                            AND MI_Master.isErased   = FALSE

                                     INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                  ON MIFloat_MovementId.MovementItemId = MI_Master.Id
                                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                        
                                     INNER JOIN MovementItem AS MI_Master_OI
                                                             ON MI_Master_OI.ObjectId   = MI_Master.ObjectId
                                                            AND MI_Master_OI.DescId = zc_MI_Master() 
                                                            AND MI_Master_OI.isErased   = FALSE

                                     INNER JOIN MovementItemFloat AS MIFloat_OI
                                                                  ON MIFloat_OI.MovementItemId = MI_Master_OI.Id
                                                                 AND MIFloat_OI.DescId         = zc_MIFloat_MovementId()
                                                                 AND MIFloat_OI.valuedata      = MIFloat_MovementId.valuedata

                                     INNER JOIN Movement AS OI ON OI.Id = MI_Master_OI.MovementId 
                                                              AND OI.descid = zc_Movement_OrderInternal() 
                                                              AND OI.StatusId <> zc_Enum_Status_Erased()
                                                                                                        
                                )

         , tmpRemains AS (SELECT Container.ObjectId            AS GoodsId
                               , Container.WhereObjectId       AS UnitId
                               , Sum(Container.Amount)::TFloat AS Remains
                          FROM Container
                          WHERE Container.WhereObjectId IN (SELECT DISTINCT tmpMovement.ToId FROM tmpMovement)
                            AND Container.DescId        = zc_Container_Count()
                            AND Container.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                            AND Container.Amount <> 0
                          GROUP BY Container.WhereObjectId
                                 , Container.ObjectId
                          HAVING Sum(Container.Amount) <> 0
                         )
                         
         , tmpProtocol AS (SELECT MovementItemProtocol.*
                                  -- № п/п
                                , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate) AS Ord
                           FROM MovementItemProtocol
                           WHERE MovementItemProtocol.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                          )
                          
         , tmpDataAll AS (SELECT
                                 tmpMI.Id
                               , tmpMI.FromId
                               , tmpMI.GoodsId
                               , tmpMI.Amount
                               , tmpMI.isErased
                               , tmpProtocol.OperDate                AS OperDate_protocol
                               , tmpProtocol.UserId                  AS UserId_protocol
                               , ROW_NUMBER() OVER (PARTITION BY tmpProtocol.UserId  ORDER BY tmpProtocol.OperDate)       AS OrdUserDate
                               , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId ORDER BY tmpProtocol.OperDate)             AS OrdGoodsDate
                          FROM tmpMI 
                               INNER JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.Id
                                                     AND tmpProtocol.Ord            = 1 
                          )
         , tmpData AS (SELECT
                              tmpDataAll.Id
                            , tmpDataAll.FromId
                            , tmpDataAll.GoodsId
                            , tmpDataAll.OperDate_protocol
                            , tmpDataAll.UserId_protocol
                            , tmpDataAll.OrdUserDate
                            , SUM(tmpDataPrew.Amount) AS TotalCount
                       FROM tmpDataAll 
                       
                            LEFT JOIN tmpDataAll AS tmpDataPrew 
                                                 ON tmpDataPrew.FromId         = tmpDataAll.FromId
                                                AND tmpDataPrew.GoodsId        = tmpDataAll.GoodsId
                                                AND tmpDataPrew.OrdGoodsDate  <= tmpDataAll.OrdGoodsDate
                                                AND tmpDataPrew.isErased = False
                                                  
                       GROUP BY tmpDataAll.Id
                              , tmpDataAll.GoodsId
                              , tmpDataAll.FromId
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
           , tmpMI.MovementId  
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , ObjectString_EAN.ValueData          AS EAN
           , Object_GoodsGroup.Id                AS GoodsGroupId
           , Object_GoodsGroup.ValueData         AS GoodsGroupName
           , Object_Measure.ValueData            AS MeasureName
           
           , tmpMI.Amount                        AS Amount
           , tmpData.TotalCount ::TFloat         AS TotalCount
           , COALESCE(tmpRemains.Remains, 0) ::TFloat  AS AmountRemains

           , tmpMI.OperDate
           , tmpMI.InvNumber
           , zfCalc_InvNumber_isErased ('', tmpMI.InvNumber, tmpMI.OperDate, tmpMI.StatusId) AS InvNumberFull
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName
           
           , tmpMI.FromId
           , Object_From.ObjectCode                      AS FromCode
           , Object_From.ValueData                       AS FromName
           , tmpMI.ToId
           , Object_ToId.ObjectCode                      AS ToCode
           , Object_ToId.ValueData                       AS ToName

           , tmpData.OrdUserDate::Integer
           , tmpData.OperDate_protocol
           , Object_User.ValueData AS UserName_protocol

           , Movement_OrderClient.Id                     AS MovementId_OrderClient
           , Movement_OrderClient.InvNumber              AS InvNumber_OrderClient
           , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
           , Object_Status_OrderClient.ObjectCode      AS StatusCode_OrderInternal
           , Object_Status_OrderClient.ValueData       AS StatusName_OrderInternal

           , OrderInternal.OperDate                      AS OperDate_OrderInternal
           , OrderInternal.InvNumber                     AS InvNumber_OrderInternal
           , zfCalc_InvNumber_isErased ('', OrderInternal.InvNumber, OrderInternal.OperDate, OrderInternal.StatusId) AS InvNumberFull_OrderInternal
           , Object_Status_OrderInternal.ObjectCode      AS StatusCode_OrderInternal
           , Object_Status_OrderInternal.ValueData       AS StatusName_OrderInternal

           , tmpMI.isErased

       FROM tmpMI

            LEFT JOIN tmpOrderInternal AS OrderInternal ON OrderInternal.Id = tmpMI.Id

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMI.StatusId
            LEFT JOIN Object AS Object_Status_OrderInternal ON Object_Status_OrderInternal.Id = OrderInternal.StatusId
            
            LEFT JOIN tmpData ON tmpData.Id = tmpMI.Id
                              
            LEFT JOIN Object AS Object_User ON Object_User.Id = tmpData.UserId_protocol

            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMI.FromId
            LEFT JOIN Object AS Object_ToId ON Object_ToId.Id = tmpMI.ToId

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

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId    = tmpMI.GoodsId
                                AND tmpRemains.UnitId     = tmpMI.ToId

            LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = tmpMI.MovementId_OrderClient
            LEFT JOIN Object AS Object_Status_OrderClient ON Object_Status_OrderClient.Id = Movement_OrderClient.StatusId

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
 25.04.24                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_MobileProductionUnion (inIsOrderBy := 'False', inIsAllUser := 'True', inIsErased := 'True', inLimit := 100, inFilter := '', inSession := zfCalc_UserAdmin());