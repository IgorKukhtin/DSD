-- Function: gpReport_SaleTare_Gofro()

DROP FUNCTION IF EXISTS gpReport_SaleTare_Gofro (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleTare_Gofro(
    IN inStartDate      TDateTime, -- дата начала периода
    IN inEndDate        TDateTime, -- дата окончания периода
    IN inUnitId         Integer  , -- подразделение
    IN inGoodsGroupId   Integer  , -- гофротара
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE(OperDate TDateTime, OperDatePartner TDateTime
            , FromId Integer, FromCode Integer, FromName TVarChar
            , ToId Integer, ToCode Integer, ToName TVarChar
            , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
            , GoodsGroupNameFull TVarChar
			, Amount TFloat, BoxCount TFloat 
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    --данные продаж по товарам       
    WITH 
      -- товары из группы Гофротара
      tmpGoods AS (SELECT ObjectLink_Goods_GoodsGroup.ObjectId AS GoodsId
                   FROM ObjectLink AS ObjectLink_Goods_GoodsGroup
                   WHERE ChildObjectId = inGoodsGroupId
                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                   )
    , tmpMovement AS (SELECT Movement.*
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                        AND (MovementLinkObject_From.ObjectId  = inUnitId OR inUnitId = 0) 
                      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.DescId = zc_Movement_Sale()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                     )
    
   --все строки док. продаж
   , tmpMI_All AS (SELECT MovementItem.*
                   FROM MovementItem
                   WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.isErased = FALSE 
                  )

    -- zc_MILinkObject_Box.ObjectId     
   , tmpMILO_Box AS (SELECT MovementItemLinkObject.*
                     FROM MovementItemLinkObject
                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                       AND MovementItemLinkObject.DescId = zc_MILinkObject_Box()
                     )
   , tmpMIF_Box AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                      AND MovementItemFloat.DescId = zc_MIFloat_BoxCount()
                    )
                     
   , tmpMI AS (SELECT MovementItem.MovementId
                    , MovementItem.Id
                    , MovementItem.ObjectId AS GoodsId
                    , MovementItem.Amount   AS Amount
                    , 0                     AS BoxCount
               FROM tmpMI_All AS MovementItem  
                    INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
              UNION
               SELECT MovementItem.MovementId
                    , MovementItem.Id
                    , MILinkObject_Box.ObjectId  AS GoodsId
                    , 0        AS Amount
                    , MIFloat_BoxCount.ValueData AS BoxCount
               FROM tmpMI_All AS MovementItem
                    INNER JOIN tmpMILO_Box AS MILinkObject_Box
                                           ON MILinkObject_Box.MovementItemId = MovementItem.Id
                    LEFT JOIN tmpMIF_Box AS MIFloat_BoxCount
                                         ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
               )
   , tmpMovementDate AS (SELECT MovementDate.*
                         FROM MovementDate
                         WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                           AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                         )

   , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                               FROM MovementLinkObject
                               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                                 AND MovementLinkObject.DescId IN (zc_MovementLinkObject_To(), zc_MovementLinkObject_From())
                               )

           --
           SELECT Movement.OperDate   ::TDateTime        AS OperDate
                , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                , Object_From.Id                      AS FromId
                , Object_From.ObjectCode              AS FromCode
                , Object_From.ValueData               AS FromName
                , Object_To.Id                        AS ToId
                , Object_To.ObjectCode                AS ToCode
                , Object_To.ValueData                 AS ToName 

                , Object_Goods.Id                     AS GoodsId
                , Object_Goods.ObjectCode             AS GoodsCode
                , Object_Goods.ValueData              AS GoodsName
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

                , SUM (tmpMI.Amount)     :: TFloat    AS Amount
                , SUM (tmpMI.BoxCount)   :: TFloat    AS BoxCount
           FROM tmpMI
                LEFT JOIN tmpMovement AS Movement ON Movement.Id = tmpMI.MovementId

                LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId =  Movement.Id

                LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId  

                LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
           GROUP BY  Movement.OperDate
                , MovementDate_OperDatePartner.ValueData
                , Object_From.Id
                , Object_From.ObjectCode
                , Object_From.ValueData
                , Object_To.Id
                , Object_To.ObjectCode
                , Object_To.ValueData
                , Object_Goods.Id
                , Object_Goods.ObjectCode
                , Object_Goods.ValueData
                , ObjectString_Goods_GoodsGroupFull.ValueData

           ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
08.07.22         *
*/

-- тест
-- SELECT * FROM gpReport_SaleTare_Gofro (inStartDate := '08.04.2022'::TDatetime, inEndDate := '08.04.2022'::TDatetime, inUnitId:=0, inGoodsGroupId:= 1960, inSession:='5'::TVarChar);