-- Function: lpCreateTempTable_OrderInternal_MI()

DROP FUNCTION IF EXISTS lpCreateTempTable_OrderInternal_MI (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCreateTempTable_OrderInternal_MI(
    IN inMovementId  Integer      , -- ключ Документа
    IN inObjectId    Integer      , 
    IN inGoodsId     Integer      , 
    IN inUserId      Integer        -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
  DECLARE vbUnitId Integer;
BEGIN

     SELECT Object_Unit_View.JuridicalId, MovementLinkObject.ObjectId
            INTO vbMainJuridicalId, vbUnitId
         FROM Object_Unit_View 
               JOIN  MovementLinkObject ON MovementLinkObject.ObjectId = Object_Unit_View.Id 
                AND  MovementLinkObject.MovementId = inMovementId 
                AND  MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

     CREATE TEMP TABLE _tmpOrderInternal_MI (Id integer
             , MovementItemId Integer
             , GoodsId Integer
             , PartnerGoodsId Integer
             , JuridicalId Integer
             , JuridicalName TVarChar
             , ContractId Integer
             , ContractName TVarChar
             , MakerName TVarChar
             , PartionGoodsDate TDateTime
             , Amount TFloat
             , MinimumLot TFloat
             , MCS TFloat
             , Remains TFloat
             , Income TFloat
             , CheckAmount TFloat
             , isClose Boolean
             , isFirst Boolean
             , isSecond Boolean
             , isTOP Boolean
             , isUnitTOP Boolean
             , MCSNotRecalc Boolean
             , MCSIsClose Boolean
             , isErased Boolean

) ON COMMIT DROP;

      -- Сохраниели данные
      INSERT INTO _tmpOrderInternal_MI 

           WITH MovementItemOrder AS (SELECT MovementItem.Id, MovementItem.ObjectId, MovementItem.isErased, MovementItem.Movementid, MovementItem.Amount
                                      FROM MovementItem    
                
                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND ((inGoodsId = 0) OR (inGoodsId = MovementItem.ObjectId))
                                  )
       SELECT row_number() OVER ()
            , MovementItem.Id                      AS MovementItemId
            , Object_Goods.Id                      AS GoodsId
            , Object_PartnerGoods.Id               AS PartnerGoodsId
            
            , Object_Juridical.Id                  AS JuridicalId
            , Object_Juridical.ValueData           AS JuridicalName
            , Object_Contract.Id                   AS ContractId
            , Object_Contract.ValueData            AS ContractName
            , MIString_Maker.ValueData             AS MakerName

            , MIDate_PartionGoods.ValueData        AS PartionGoodsDate
            , COALESCE(MovementItem.Amount,0)      AS Amount
            , MIFloat_MinimumLot.ValueData         AS MinimumLot
            , MIFloat_MCS.ValueData                AS MCS
            , MIFloat_Remains.ValueData            AS Remains
            , MIFloat_Income.ValueData             AS Income
            , MIFloat_Check.ValueData              AS CheckAmount

            , COALESCE(MIBoolean_Close.ValueData, False)              AS isClose
            , COALESCE(MIBoolean_First.ValueData, False)              AS isFirst
            , COALESCE(MIBoolean_Second.ValueData, False)             AS isSecond
            , COALESCE(MIBoolean_TOP.ValueData, False)                AS isTOP
            , COALESCE(MIBoolean_UnitTOP.ValueData, False)            AS isUnitTOP
            , COALESCE(MIBoolean_MCSNotRecalc.ValueData, FALSE)       AS MCSNotRecalc
            , COALESCE(MIBoolean_MCSIsClose.ValueData, FALSE)         AS MCSIsClose

            , MovementItem.isErased

         FROM MovementItemOrder AS MovementItem
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
              LEFT JOIN MovementItemFloat AS MIFloat_MinimumLot                                             
                     ON MIFloat_MinimumLot.DescId = zc_MIFloat_MinimumLot()
                    AND MIFloat_MinimumLot.MovementItemId = MovementItem.Id
              LEFT JOIN MovementItemFloat AS MIFloat_MCS                                           
                     ON MIFloat_MCS.DescId = zc_MIFloat_MCS()
                    AND MIFloat_MCS.MovementItemId = MovementItem.Id 
              LEFT JOIN MovementItemFloat AS MIFloat_Remains
                     ON MIFloat_Remains.MovementItemId = MovementItem.Id
                    AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
              LEFT JOIN MovementItemFloat AS MIFloat_Income
                     ON MIFloat_Income.MovementItemId = MovementItem.Id
                    AND MIFloat_Income.DescId = zc_MIFloat_Income()  
              LEFT JOIN MovementItemFloat AS MIFloat_Check
                     ON MIFloat_Check.MovementItemId = MovementItem.Id
                    AND MIFloat_Check.DescId = zc_MIFloat_Check() 

              LEFT JOIN MovementItemDate AS MIDate_PartionGoods                                           
                     ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                    AND MIDate_PartionGoods.MovementItemId = MovementItem.Id

              LEFT JOIN MovementItemBoolean AS MIBoolean_Close 
                     ON MIBoolean_Close.DescId = zc_MIBoolean_Close()
                    AND MIBoolean_Close.MovementItemId = MovementItem.Id
              LEFT JOIN MovementItemBoolean AS MIBoolean_First
                     ON MIBoolean_First.DescId = zc_MIBoolean_First()
                    AND MIBoolean_First.MovementItemId = MovementItem.Id
              LEFT JOIN MovementItemBoolean AS MIBoolean_Second
                     ON MIBoolean_Second.DescId = zc_MIBoolean_Second()
                    AND MIBoolean_Second.MovementItemId = MovementItem.Id
              LEFT JOIN MovementItemBoolean AS MIBoolean_TOP
                     ON MIBoolean_TOP.DescId = zc_MIBoolean_TOP()
                    AND MIBoolean_TOP.MovementItemId = MovementItem.Id
              LEFT JOIN MovementItemBoolean AS MIBoolean_UnitTOP
                     ON MIBoolean_UnitTOP.DescId = zc_MIBoolean_UnitTOP()
                    AND MIBoolean_UnitTOP.MovementItemId = MovementItem.Id
              LEFT JOIN MovementItemBoolean AS MIBoolean_MCSNotRecalc
                     ON MIBoolean_MCSNotRecalc.DescId = zc_MIBoolean_MCSNotRecalc()
                    AND MIBoolean_MCSNotRecalc.MovementItemId = MovementItem.Id
              LEFT JOIN MovementItemBoolean AS MIBoolean_MCSIsClose
                     ON MIBoolean_MCSIsClose.DescId = zc_MIBoolean_MCSIsClose()
                    AND MIBoolean_MCSIsClose.MovementItemId = MovementItem.Id

             LEFT JOIN MovementItemString AS MIString_Maker 
                    ON MIString_Maker.DescId = zc_MIString_Maker()
                   AND MIString_Maker.MovementItemId = MovementItem.Id  
 
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical 
                    ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                   AND MILinkObject_Juridical.MovementItemId = MovementItem.Id
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract 
                    ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                   AND MILinkObject_Contract.MovementItemId = MovementItem.Id
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods 
                    ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                   AND MILinkObject_Goods.MovementItemId = MovementItem.Id
             LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId

;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.08.16         *  
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
-- SELECT lpCreateTempTable_OrderInternal_MI(inMovementId := 2158888, inObjectId := 4, inGoodsId := 0, inUserId := 3); SELECT * FROM _tmpMI;
