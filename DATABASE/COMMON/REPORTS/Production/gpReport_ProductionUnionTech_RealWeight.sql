-- Function: gpReport_ProductionUnionTech_RealWeight()

DROP FUNCTION IF EXISTS gpReport_ProductionUnionTech_RealWeight (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionUnionTech_RealWeight(
    IN inMovementItemId    Integer,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , MovementItemId        Integer
             , InvNumber             TVarChar
             , OperDate              TDateTime --TDateTime 
             , StatusCode            Integer

             , GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar 
             , GoodsKindId         Integer
             , GoodsKindName       TVarChar
             
             , Amount       TFloat --Кол-во
             , RealWeight   TFloat --Реал. вес
             , WeightTare   TFloat --Вес тары
             , HeadCount    TFloat --Кол. голов
  )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbFromId_group Integer;
  DECLARE vbIsOrder Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Select_Movement_ProductionUnionTech());
     vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY   
    WITH
    --строки док. взвешивания, для кот inMovementItemId док. произв. смеш. является партией 
         tmpPartionAll AS (SELECT DISTINCT 
                                  MIFloat_MovementItemId.MovementItemId     AS MovementItemId
                           FROM MovementItemFloat AS MIFloat_MovementItemId
                           WHERE MIFloat_MovementItemId.ValueData = inMovementItemId 
                             AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                           )
         --получаем информацию по док взвещивания.
         , tmpWeighingProduction AS (SELECT tmpPartionAll.MovementItemId
                                          , Movement.Id  AS MovementId
                                          , Movement.OperDate
                                          , Movement.InvNumber 
                                          , Movement.StatusId
                                          , MovementLinkObject_DocumentKind.ObjectId AS DocumentKindId
                                          , MovementItem.ObjectId AS GoodsId
                                          , MovementItem.Amount
                                     FROM tmpPartionAll
                                          INNER JOIN MovementItem ON MovementItem.Id = tmpPartionAll.MovementItemId
                                                                 AND MovementItem.DescId = zc_MI_Master()
                                                                 AND MovementItem.isErased = False
                                          INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                             AND Movement.DescId = zc_Movement_WeighingProduction()
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                                                        ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                                                       AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
                                                                       AND MovementLinkObject_DocumentKind.ObjectId IN (zc_Enum_DocumentKind_RealWeight())
                                     )

    SELECT tmpData.MovementId
         , tmpData.MovementItemId
         , tmpData.InvNumber           ::TVarChar
         , tmpData.OperDate            ::TDateTime
         , Object_Status.ObjectCode    ::Integer  AS StatusCode 
         , Object_Goods.Id             ::Integer  AS GoodsId
         , Object_Goods.ObjectCode     ::Integer  AS GoodsCode
         , Object_Goods.ValueData      ::TVarChar AS GoodsName
         , Object_GoodsKind.Id         ::Integer  AS GoodsKindId
         , Object_GoodsKind.ValueData  ::TVarChar AS GoodsKindName
           --
         , tmpData.Amount                ::TFloat AS Amount     --Кол-во
         , MIFloat_RealWeight.ValueData  ::TFloat AS RealWeight --Реал. вес
         , MIFloat_WeightTare.ValueData  ::TFloat AS WeightTare --Вес тары
         , MIFloat_HeadCount.ValueData   ::TFloat AS HeadCount  --Кол. голов

    FROM tmpWeighingProduction AS tmpData
     LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId
     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

     LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                 ON MIFloat_RealWeight.MovementItemId = tmpData.MovementItemId
                                AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

     LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                 ON MIFloat_HeadCount.MovementItemId = tmpData.MovementItemId
                                AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                
     LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                 ON MIFloat_WeightTare.MovementItemId = tmpData.MovementItemId
                                AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

     LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                      ON MILO_GoodsKind.MovementItemId = tmpData.MovementItemId
                                     AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind() and  1 = 0 
     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР

               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.26         *
*/

-- тест
-- select * from gpReport_ProductionUnionTech_RealWeight(inMovementItemId := 355967920 , inSession := '5')
