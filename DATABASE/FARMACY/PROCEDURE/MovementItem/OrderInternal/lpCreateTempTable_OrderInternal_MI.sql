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
             , MovementItemId   Integer
             , GoodsId          Integer
             , PartnerGoodsId   Integer
             , JuridicalId      Integer
             , JuridicalName    TVarChar
             , ContractId       Integer
             , ContractName     TVarChar
             , MakerName        TVarChar
             , PartionGoodsDate TDateTime
             , Amount           TFloat
             , MinimumLot       TFloat
             , MCS              TFloat
             , Remains          TFloat
             , Reserved         TFloat
             , Income           TFloat
             , CheckAmount      TFloat
             , SendAmount       TFloat
             , AmountDeferred   TFloat
             , AmountSF         TFloat
             , ListDiffAmount   TFloat
             , SupplierFailuresAmount TFloat
             , AmountReal       TFloat
             , SendSUNAmount    TFloat
             , SendDefSUNAmount TFloat
             , RemainsSUN       TFloat
             , AmountSUA        TFloat
             , isClose          Boolean
             , isFirst          Boolean
             , isSecond         Boolean
             , isTOP            Boolean
             , isUnitTOP        Boolean
             , MCSNotRecalc     Boolean
             , MCSIsClose       Boolean
             , isErased         Boolean

) ON COMMIT DROP;

      -- Сохраниели данные
      INSERT INTO _tmpOrderInternal_MI 

      WITH      
          MovementItemOrder AS (SELECT MovementItem.Id, MovementItem.ObjectId, MovementItem.isErased, MovementItem.Movementid, MovementItem.Amount
                                FROM MovementItem    
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND ((inGoodsId = 0) OR (inGoodsId = MovementItem.ObjectId))
                            )
        ----
        , tmpMIB AS (SELECT MovementItemBoolean.*
                     FROM MovementItemBoolean 
                     WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT MovementItemOrder.Id FROM MovementItemOrder)
                    )

        , tmpMIB_MCSNotRecalc AS (SELECT tmpMIB.*
                                  FROM tmpMIB
                                  WHERE tmpMIB.DescId = zc_MIBoolean_MCSNotRecalc()
                                 )
          
        , tmpMIB_MCSIsClose AS (SELECT tmpMIB.*
                                  FROM tmpMIB
                                  WHERE tmpMIB.DescId = zc_MIBoolean_MCSIsClose()
                                )

        , tmpMIB_Close AS (SELECT tmpMIB.*
                                  FROM tmpMIB
                                  WHERE tmpMIB.DescId = zc_MIBoolean_Close()
                          )
        , tmpMIB_First AS (SELECT tmpMIB.*
                                  FROM tmpMIB
                                  WHERE tmpMIB.DescId = zc_MIBoolean_First()
                           )
        , tmpMIB_Second AS (SELECT tmpMIB.*
                                  FROM tmpMIB
                                  WHERE tmpMIB.DescId = zc_MIBoolean_Second()
                           )
        , tmpMIB_TOP AS (SELECT tmpMIB.*
                                  FROM tmpMIB
                                  WHERE tmpMIB.DescId = zc_MIBoolean_TOP()
                         )
        , tmpMIB_UnitTOP AS (SELECT tmpMIB.*
                                  FROM tmpMIB
                                  WHERE tmpMIB.DescId = zc_MIBoolean_UnitTOP()
                            )
        ----
        , tmpMIS_Maker AS (SELECT MIString_Maker.*
                           FROM MovementItemOrder
                                LEFT JOIN MovementItemString AS MIString_Maker 
                                       ON MIString_Maker.MovementItemId = MovementItemOrder.Id
                                      AND MIString_Maker.DescId = zc_MIString_Maker()
                          )
        ----
        , tmpMIF AS (SELECT MovementItemFloat.*
                     FROM MovementItemFloat
                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT MovementItemOrder.Id FROM MovementItemOrder)
                     )
                     
        , tmpMIF_MinimumLot AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_MinimumLot()
                                  AND tmpMIF.ValueData <> 0
                                )
  
        , tmpMIF_MCS AS (SELECT tmpMIF.*
                         FROM tmpMIF
                         WHERE tmpMIF.DescId = zc_MIFloat_MCS()
                         )
        , tmpMIF_Remains AS (SELECT tmpMIF.*
                             FROM tmpMIF
                             WHERE tmpMIF.DescId = zc_MIFloat_Remains()
                             )
        , tmpMIF_Reserve AS (SELECT tmpMIF.*
                             FROM tmpMIF
                             WHERE tmpMIF.DescId = zc_MIFloat_Reserved()
                             )
        , tmpMIF_Income AS (SELECT tmpMIF.*
                            FROM tmpMIF
                            WHERE tmpMIF.DescId = zc_MIFloat_Income()  
                            )
        , tmpMIF_Check AS (SELECT tmpMIF.*
                           FROM tmpMIF
                           WHERE tmpMIF.DescId = zc_MIFloat_Check() 
                           )
        , tmpMIF_Send AS (SELECT tmpMIF.*
                          FROM tmpMIF
                          WHERE tmpMIF.DescId = zc_MIFloat_Send()
                         )
        , tmpMIF_AmountDeferred AS (SELECT tmpMIF.*
                                    FROM tmpMIF
                                    WHERE tmpMIF.DescId = zc_MIFloat_AmountDeferred()
                                    )
        , tmpMIF_AmountSF AS (SELECT tmpMIF.*
                              FROM tmpMIF
                              WHERE tmpMIF.DescId = zc_MIFloat_AmountSF()
                              )
        , tmpMIF_ListDiff AS (SELECT tmpMIF.*
                              FROM tmpMIF
                              WHERE tmpMIF.DescId = zc_MIFloat_ListDiff()
                             )
        , tmpMIF_SupplierFailures AS (SELECT tmpMIF.*
                                      FROM tmpMIF
                                      WHERE tmpMIF.DescId = zc_MIFloat_SupplierFailures()
                                     )
        , tmpMIF_AmountSUA AS (SELECT tmpMIF.*
                               FROM tmpMIF
                               WHERE tmpMIF.DescId = zc_MIFloat_AmountSUA()
                             )
        , tmpMIF_AmountReal AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_AmountReal()
                               )
        , tmpMIF_SendSUN AS (SELECT tmpMIF.*
                             FROM tmpMIF
                             WHERE tmpMIF.DescId = zc_MIFloat_SendSUN()
                            )
        , tmpMIF_SendDefSUN AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_SendDefSUN()
                               )
        , tmpMIF_RemainsSUN AS (SELECT tmpMIF.*
                                FROM tmpMIF
                                WHERE tmpMIF.DescId = zc_MIFloat_RemainsSUN()
                               )

        , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT MovementItemOrder.Id FROM MovementItemOrder)
                         AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Contract()
                                                             , zc_MILinkObject_Juridical()
                                                             , zc_MILinkObject_Goods())
                       )
        , tmpMIDate AS (SELECT MovementItemDate.*
                        FROM MovementItemDate
                        WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT MovementItemOrder.Id FROM MovementItemOrder)
                          AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                        )

         SELECT row_number() OVER ()
            , MovementItem.Id                      AS MovementItemId
            , MovementItem.ObjectId                AS GoodsId
            --, Object_Goods.Id                      AS GoodsId
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
            , MIFloat_Reserved.ValueData           AS Reserved
            , MIFloat_Income.ValueData             AS Income
            , MIFloat_Check.ValueData              AS CheckAmount
            , MIFloat_Send.ValueData               AS SendAmount
            , MIFloat_AmountDeferred.ValueData     AS AmountDeferred
            , MIFloat_AmountSF.ValueData           AS AmountSF
            , MIFloat_ListDiff.ValueData           AS ListDiffAmount
            , MIFloat_SupplierFailures.ValueData   AS SupplierFailuresAmount

            , MIFloat_AmountReal.ValueData :: TFloat  AS AmountReal
            , MIFloat_SendSUN.ValueData    :: TFloat  AS SendSUNAmount
            , MIFloat_SendDefSUN.ValueData :: TFloat  AS SendDefSUNAmount
            , MIFloat_RemainsSUN.ValueData :: TFloat  AS RemainsSUN
            , MIFloat_AmountSUA.ValueData          AS AmountSUA

            , COALESCE(MIBoolean_Close.ValueData, False)              AS isClose
            , COALESCE(MIBoolean_First.ValueData, False)              AS isFirst
            , COALESCE(MIBoolean_Second.ValueData, False)             AS isSecond
            , COALESCE(MIBoolean_TOP.ValueData, False)                AS isTOP
            , COALESCE(MIBoolean_UnitTOP.ValueData, False)            AS isUnitTOP
            , COALESCE(MIBoolean_MCSNotRecalc.ValueData, FALSE)       AS MCSNotRecalc
            , COALESCE(MIBoolean_MCSIsClose.ValueData, FALSE)         AS MCSIsClose

            , MovementItem.isErased

         FROM MovementItemOrder AS MovementItem
              --LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

              LEFT JOIN tmpMI_LO AS MILinkObject_Juridical 
                                 ON MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                                AND MILinkObject_Juridical.MovementItemId = MovementItem.Id
              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId 
                                                  AND Object_Juridical.DescId = zc_Object_Juridical()
              
              LEFT JOIN tmpMI_LO AS MILinkObject_Contract 
                                 ON MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                AND MILinkObject_Contract.MovementItemId = MovementItem.Id
              LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId AND Object_Contract.DescId = zc_Object_Contract()
              
              LEFT JOIN tmpMI_LO AS MILinkObject_Goods 
                                 ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                AND MILinkObject_Goods.MovementItemId = MovementItem.Id
              LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId 
                                                     AND Object_PartnerGoods.DescId = zc_Object_Goods()

              LEFT JOIN tmpMIDate AS MIDate_PartionGoods                                        
                                  ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                 AND MIDate_PartionGoods.MovementItemId = MovementItem.Id

              LEFT JOIN tmpMIB_Close   AS MIBoolean_Close   ON MIBoolean_Close.MovementItemId   = MovementItem.Id
              LEFT JOIN tmpMIB_First   AS MIBoolean_First   ON MIBoolean_First.MovementItemId   = MovementItem.Id
              LEFT JOIN tmpMIB_Second  AS MIBoolean_Second  ON MIBoolean_Second.MovementItemId  = MovementItem.Id
              LEFT JOIN tmpMIB_TOP     AS MIBoolean_TOP     ON MIBoolean_TOP.MovementItemId     = MovementItem.Id
              LEFT JOIN tmpMIB_UnitTOP AS MIBoolean_UnitTOP ON MIBoolean_UnitTOP.MovementItemId = MovementItem.Id

              LEFT JOIN tmpMIB_MCSNotRecalc AS MIBoolean_MCSNotRecalc ON MIBoolean_MCSNotRecalc.MovementItemId = MovementItem.Id
              LEFT JOIN tmpMIB_MCSIsClose   AS MIBoolean_MCSIsClose   ON MIBoolean_MCSIsClose.MovementItemId   = MovementItem.Id
              LEFT JOIN tmpMIS_Maker        AS MIString_Maker         ON MIString_Maker.MovementItemId         = MovementItem.Id  
 
              LEFT JOIN tmpMIF_MinimumLot     AS MIFloat_MinimumLot     ON MIFloat_MinimumLot.MovementItemId     = MovementItem.Id
              LEFT JOIN tmpMIF_MCS            AS MIFloat_MCS            ON MIFloat_MCS.MovementItemId            = MovementItem.Id 
              LEFT JOIN tmpMIF_Remains        AS MIFloat_Remains        ON MIFloat_Remains.MovementItemId        = MovementItem.Id
              LEFT JOIN tmpMIF_Reserve        AS MIFloat_Reserved       ON MIFloat_Reserved.MovementItemId       = MovementItem.Id
              LEFT JOIN tmpMIF_Income         AS MIFloat_Income         ON MIFloat_Income.MovementItemId         = MovementItem.Id
              LEFT JOIN tmpMIF_Check          AS MIFloat_Check          ON MIFloat_Check.MovementItemId          = MovementItem.Id
              LEFT JOIN tmpMIF_Send           AS MIFloat_Send           ON MIFloat_Send.MovementItemId           = MovementItem.Id
              LEFT JOIN tmpMIF_AmountDeferred AS MIFloat_AmountDeferred ON MIFloat_AmountDeferred.MovementItemId = MovementItem.Id
              LEFT JOIN tmpMIF_AmountSF       AS MIFloat_AmountSF       ON MIFloat_AmountSF.MovementItemId       = MovementItem.Id
              LEFT JOIN tmpMIF_ListDiff       AS MIFloat_ListDiff       ON MIFloat_ListDiff.MovementItemId       = MovementItem.Id
              LEFT JOIN tmpMIF_SupplierFailures AS MIFloat_SupplierFailures ON MIFloat_SupplierFailures.MovementItemId = MovementItem.Id
              LEFT JOIN tmpMIF_AmountSUA      AS MIFloat_AmountSUA      ON MIFloat_AmountSUA.MovementItemId      = MovementItem.Id
              LEFT JOIN tmpMIF_AmountReal     AS MIFloat_AmountReal     ON MIFloat_AmountReal.MovementItemId     = MovementItem.Id
              LEFT JOIN tmpMIF_SendSUN        AS MIFloat_SendSUN        ON MIFloat_SendSUN.MovementItemId        = MovementItem.Id
              LEFT JOIN tmpMIF_SendDefSUN     AS MIFloat_SendDefSUN     ON MIFloat_SendDefSUN.MovementItemId     = MovementItem.Id
              LEFT JOIN tmpMIF_RemainsSUN     AS MIFloat_RemainsSUN     ON MIFloat_RemainsSUN.MovementItemId     = MovementItem.Id
    ;
	
	ANALYSE _tmpOrderInternal_MI;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 03.03.22                                                                     * add AmountSF
 22.03.21                                                                     *
 01.11.18         *
 31.08.18         *
 20.03.18         *
 09.04.17         * оптимизация
 22.12.16         * add AmountDeferred
 04.08.16         *  
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
-- SELECT lpCreateTempTable_OrderInternal_MI(inMovementId := 2158888, inObjectId := 4, inGoodsId := 0, inUserId := 3); SELECT * FROM _tmpMI;