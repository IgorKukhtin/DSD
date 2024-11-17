-- Function: gpSelect_MI_WeighingPartner_diff()

DROP FUNCTION IF EXISTS gpSelect_MI_WeighingPartner_diff (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_WeighingPartner_diff(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Ord Integer, Id Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsKindName TVarChar, MeasureName TVarChar
             , AmountPartner TFloat, AmountPartnerSecond TFloat 
             , ChangePercentAmount TFloat
             , PricePartnerNoVAT TFloat, PricePartnerWVAT TFloat
             , SummPartnerNoVAT TFloat, SummPartnerWVAT TFloat
             
             , AmountPartner_income TFloat, PricePartner_Income TFloat, SummPartner_income TFloat
             , Amount_diff TFloat, Price_diff TFloat 
             , isAmountPartnerSecond Boolean
             , isReturnOut Boolean
             , Comment TVarChar
             , isErased Boolean 
             
              )
AS
$BODY$
   DECLARE vbVATPercent TFloat;
   DECLARE vbInvNumberPartner TVarChar; 
   DECLARE vbOperDate TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());

     -- параметры из документа
     SELECT Movement.OperDate
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , COALESCE (MovementString_InvNumberPartner.ValueData,'') ::TVarChar AS InvNumberPartner
            INTO vbOperDate, vbVATPercent, vbInvNumberPartner
     FROM Movement
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
     WHERE Movement.Id = inMovementId
    ;


     -- inShowAll:= TRUE;
     RETURN QUERY 

   WITH tmpMIList AS (SELECT MovementItem.Id AS MovementItemId
                           , MovementItem.*
                           , MovementItem.isErased AS isErasedMI
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                     )

      , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                              FROM MovementItemLinkObject
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIList.MovementItemId FROM tmpMIList)
                                AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                             )

      , tmpMI_Float AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIList.MovementItemId FROM tmpMIList)
                               -- AND MovementItemFloat.DescId = zc_MILinkObject_GoodsKind()
                             )

      , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                          FROM MovementItemBoolean
                          WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMIList.MovementItemId FROM tmpMIList)
                            AND MovementItemBoolean.DescId IN (zc_MIBoolean_AmountPartnerSecond()
                                                             , zc_MIBoolean_PriceWithVAT()
                                                             , zc_MIBoolean_ReturnOut()
                                                             )
                         )

      , tmpMI_String AS (SELECT MovementItemString.*
                         FROM MovementItemString
                         WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMIList.MovementItemId FROM tmpMIList)
                           AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                            )
                         )

      , tmpMI AS (
             SELECT tmp.*
                  , SUM (COALESCE (tmp.AmountPartner, 0)) OVER (PARTITION BY tmp.GoodsId, tmp.GoodsKindId) AS AmountPartner_total
                  , SUM (COALESCE (tmp.AmountPartnerSecond, 0)) OVER (PARTITION BY tmp.GoodsId, tmp.GoodsKindId) AS AmountPartnerSecond_total
                  , ROW_NUMBER () OVER (PARTITION BY tmp.GoodsId, tmp.GoodsKindId ORDER BY tmp.AmountPartnerSecond desc) AS ord
             FROM (     
                   SELECT MovementItem.Id :: Integer                   AS MovementItemId
                        , MovementItem.ObjectId                         AS GoodsId  
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
      
                        --, MovementItem.Amount
                        , COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0) AS AmountPartnerSecond
                        , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                        
                        , COALESCE (MIFloat_AmountPartner.ValueData, 0)       AS AmountPartner   
                        
                          --  цена без НДС, до 4 знаков
                        , CASE WHEN COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) = TRUE
                               THEN CAST (COALESCE (MIFloat_PricePartner.ValueData, 0) - COALESCE (MIFloat_PricePartner.ValueData, 0) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                               ELSE COALESCE (MIFloat_PricePartner.ValueData, 0)
                          END            AS PricePartnerNoVAT
      
                          --  цена с НДС, до 4 знаков
                        , CASE WHEN COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) <> TRUE
                               THEN CAST ((COALESCE (MIFloat_PricePartner.ValueData, 0) + COALESCE (MIFloat_PricePartner.ValueData, 0) * (vbVATPercent / 100))
                                          AS NUMERIC (16, 4))
                               ELSE CAST (COALESCE (MIFloat_PricePartner.ValueData, 0) 
                                          AS NUMERIC (16, 4))
                          END            AS PricePartnerWVAT
      
                          --  сумма без НДС, до 4 знаков
                        , COALESCE (MIFloat_AmountPartner.ValueData, 0) *
                          CASE WHEN COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) = TRUE
                               THEN CAST (COALESCE (MIFloat_PricePartner.ValueData, 0) - COALESCE (MIFloat_PricePartner.ValueData, 0) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                               ELSE COALESCE (MIFloat_PricePartner.ValueData, 0)
                          END            AS SummPartnerNoVAT
      
                          -- сумма с НДС, до 4 знаков
                        , COALESCE (MIFloat_AmountPartner.ValueData, 0) *
                          CASE WHEN COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) <> TRUE
                               THEN CAST ((COALESCE (MIFloat_PricePartner.ValueData, 0) + COALESCE (MIFloat_PricePartner.ValueData, 0) * (vbVATPercent / 100))
                                          AS NUMERIC (16, 4))
                               ELSE CAST (COALESCE (MIFloat_PricePartner.ValueData, 0) 
                                          AS NUMERIC (16, 4))
                          END            AS SummPartnerWVAT
      
                        , COALESCE (MIBoolean_AmountPartnerSecond.ValueData, FALSE) :: Boolean AS isAmountPartnerSecond
                        , COALESCE (MIBoolean_ReturnOut.ValueData, FALSE)           :: Boolean  AS isReturnOut
                        , COALESCE (MIString_Comment.ValueData,'')                  :: TVarChar AS Comment
      
                        , MovementItem.isErased
                        
                   FROM tmpMIList AS MovementItem 
                        LEFT JOIN tmpMI_Boolean AS MIBoolean_AmountPartnerSecond
                                                ON MIBoolean_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                               AND MIBoolean_AmountPartnerSecond.DescId = zc_MIBoolean_AmountPartnerSecond()
                        LEFT JOIN tmpMI_Boolean AS MIBoolean_PriceWithVAT
                                                ON MIBoolean_PriceWithVAT.MovementItemId = MovementItem.Id
                                               AND MIBoolean_PriceWithVAT.DescId = zc_MIBoolean_PriceWithVAT()
                        LEFT JOIN tmpMI_Boolean AS MIBoolean_ReturnOut
                                                ON MIBoolean_ReturnOut.MovementItemId = MovementItem.Id
                                               AND MIBoolean_ReturnOut.DescId = zc_MIBoolean_ReturnOut()
      
                        LEFT JOIN tmpMI_String AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                              AND MIString_Comment.DescId = zc_MIString_Comment()
      
                        LEFT JOIN tmpMI_Float AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
      
                        LEFT JOIN tmpMI_Float AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        LEFT JOIN tmpMI_Float AS MIFloat_AmountPartnerSecond
                                                    ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
      
                        LEFT JOIN tmpMI_Float AS MIFloat_PricePartner
                                                    ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()
      
                        /*LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                                    ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_SummPartner.DescId = zc_MIFloat_SummPartner()*/
      
                        LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   --WHERE COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0) <> 0 
                   ) AS tmp
              )

      , tmpMI_Income AS(WITH
                        --выбираем приходы, нужно выбрать все накл с одинаковым InvNumberPartner для Акта Разногласий
                        tmpMovement AS (SELECT Movement.Id
                                        FROM Movement  
                                             INNER JOIN MovementString AS MovementString_InvNumberPartner
                                                                       ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                                      AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                                                      AND MovementString_InvNumberPartner.ValueData = vbInvNumberPartner 
                                                                      AND vbInvNumberPartner <> ''                         
                                        WHERE Movement.OperDate = vbOperDate
                                          AND Movement.DescId = zc_Movement_Income()
                                          AND Movement.StatusId = zc_Enum_Status_Complete()
                                        )
                          
                      , tmpMF_ChangePercent AS (SELECT MovementFloat_ChangePercent.*
                                                FROM MovementFloat AS MovementFloat_ChangePercent
                                                WHERE MovementFloat_ChangePercent.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent() 
                                                )  
                      , tmpMF_VATPercent AS (SELECT MovementFloat_ChangePercent.*
                                             FROM MovementFloat AS MovementFloat_ChangePercent
                                             WHERE MovementFloat_ChangePercent.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_VATPercent() 
                                             )
                      , tmpMB_PriceWithVAT AS (SELECT MovementBoolean.*
                                               FROM MovementBoolean
                                               WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                 AND MovementBoolean.DescId = zc_MovementBoolean_PriceWithVAT() 
                                               )
                      , tmpMIList AS (SELECT MovementItem.*
                                      FROM MovementItem
                                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                                      )
                     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                                             FROM MovementItemLinkObject
                                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIList.Id FROM tmpMIList)
                                               AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                             )

                     , tmpMI_Float AS (SELECT MovementItemFloat.*
                                       FROM MovementItemFloat
                                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIList.Id FROM tmpMIList)
                                         AND MovementItemFloat.DescId IN (zc_MIFloat_PricePartner()
                                                                        , zc_MIFloat_Price()
                                                                        )
                                       )
     
                     , tmpMI_All AS (SELECT MovementItem.ObjectId AS GoodsId
                                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                          , CASE WHEN MovementLinkObject_PaidKind.ObjectId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                      THEN CAST ( (1 +  COALESCE (MovementFloat_ChangePercent.ValueData, 0) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                                 ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                            END AS Price
                                          , SUM (MovementItem.Amount) AS Amount
                                          --, SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                                          --, COALESCE (MIFloat_PricePartner.ValueData,0)         AS PricePartner
                                            , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
                                            , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
                                     FROM tmpMIList AS MovementItem
                                          LEFT JOIN tmpMF_ChangePercent AS MovementFloat_ChangePercent
                                                                        ON MovementFloat_ChangePercent.MovementId = MovementItem.MovementId
                        
                                          LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                      -- AND MIFloat_Price.ValueData <> 0
                         
                                          LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        
                                          LEFT JOIN tmpMB_PriceWithVAT AS MovementBoolean_PriceWithVAT
                                                                       ON MovementBoolean_PriceWithVAT.MovementId = MovementItem.MovementId
                                          LEFT JOIN tmpMF_VATPercent AS MovementFloat_VATPercent
                                                                     ON MovementFloat_VATPercent.MovementId = MovementItem.MovementId
 
                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                       ON MovementLinkObject_PaidKind.MovementId = MovementItem.MovementId
                                                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind())
                                     GROUP BY MovementItem.ObjectId
                                            , MILinkObject_GoodsKind.ObjectId
                                            , MIFloat_Price.ValueData
                                            , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
                                            , COALESCE (MovementFloat_VATPercent.ValueData, 0) 
                                            , MovementLinkObject_PaidKind.ObjectId   
                                            ,  COALESCE (MovementFloat_ChangePercent.ValueData, 0)
                                    )
                     SELECT tmp.GoodsId
                          , tmp.GoodsKindId
                          , SUM (tmp.Amount) AS Amount
                            --  цена без НДС, до 4 знаков
                          , CASE WHEN COALESCE (tmp.PriceWithVAT, FALSE) = TRUE
                                 THEN CAST (COALESCE (tmp.Price, 0) - COALESCE (tmp.Price, 0) * (tmp.VATPercent / (tmp.VATPercent + 100)) AS NUMERIC (16, 2))
                                 ELSE COALESCE (tmp.Price, 0)
                            END            AS PriceNoVAT

                            --  цена с НДС, до 4 знаков
                          , CASE WHEN COALESCE (tmp.PriceWithVAT, FALSE) <> TRUE
                                 THEN CAST ((COALESCE (tmp.Price, 0) + COALESCE (tmp.Price, 0) * (tmp.VATPercent / 100))
                                            AS NUMERIC (16, 4))
                                 ELSE CAST (COALESCE (tmp.Price, 0) 
                                            AS NUMERIC (16, 4))
                            END            AS PriceWVAT

                            --  сумма без НДС, до 4 знаков
                          , SUM (tmp.Amount *
                                 CASE WHEN COALESCE (tmp.PriceWithVAT, FALSE) = TRUE
                                      THEN CAST (COALESCE (tmp.Price, 0) - COALESCE (tmp.Price, 0) * (tmp.VATPercent / (tmp.VATPercent + 100)) AS NUMERIC (16, 2))
                                      ELSE COALESCE (tmp.Price, 0)
                                 END)            AS SummNoVAT
        
                            -- сумма с НДС, до 4 знаков
                          , SUM (tmp.Amount *
                                 CASE WHEN COALESCE (tmp.PriceWithVAT, FALSE) <> TRUE
                                      THEN CAST ((COALESCE (tmp.Price, 0) + COALESCE (tmp.Price, 0) * (tmp.VATPercent / 100))
                                                 AS NUMERIC (16, 4))
                                      ELSE CAST (COALESCE (tmp.Price, 0) 
                                                 AS NUMERIC (16, 4))
                                 END)            AS SummWVAT                          
                     FROM tmpMI_All AS tmp 
                     GROUP BY tmp.GoodsId
                          , tmp.GoodsKindId 
                          , CASE WHEN COALESCE (tmp.PriceWithVAT, FALSE) = TRUE
                                 THEN CAST (COALESCE (tmp.Price, 0) - COALESCE (tmp.Price, 0) * (tmp.VATPercent / (tmp.VATPercent + 100)) AS NUMERIC (16, 2))
                                 ELSE COALESCE (tmp.Price, 0)
                            END
                            --  цена с НДС, до 4 знаков
                          , CASE WHEN COALESCE (tmp.PriceWithVAT, FALSE) <> TRUE
                                 THEN CAST ((COALESCE (tmp.Price, 0) + COALESCE (tmp.Price, 0) * (tmp.VATPercent / 100))
                                            AS NUMERIC (16, 4))
                                 ELSE CAST (COALESCE (tmp.Price, 0) 
                                            AS NUMERIC (16, 4))
                            END 
                     
            )



       -- Результат     
       SELECT ROW_NUMBER() OVER (ORDER BY tmpMI.MovementItemId) ::Integer AS Ord
           , tmpMI.MovementItemId :: Integer  AS Id
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.AmountPartner_total        :: TFloat AS AmountPartner
           , tmpMI.AmountPartnerSecond  :: TFloat AS AmountPartnerSecond

           , tmpMI.ChangePercentAmount  :: TFloat
 
             --  цена без НДС, до 4 знаков
           , tmpMI.PricePartnerNoVAT ::TFloat
             --  цена с НДС, до 4 знаков
           , tmpMI.PricePartnerWVAT ::TFloat
             --  сумма без НДС, до 4 знаков
           , tmpMI.SummPartnerNoVAT ::TFloat AS SummPartnerNoVAT
             -- сумма с НДС, до 4 знаков
           , tmpMI.SummPartnerWVAT  ::TFloat AS SummPartnerWVAT

           , tmpMI_Income.Amount    ::TFloat AS AmountPartner_income
           , tmpMI_Income.PriceWVAT ::TFloat AS PricePartner_Income
           , tmpMI_Income.SummWVAT  ::TFloat AS SummPartner_income

           , (COALESCE (tmpMI.AmountPartnerSecond,0) - COALESCE (tmpMI_Income.Amount,0)) ::TFloat   AS Amount_diff
           , (COALESCE (tmpMI.PricePartnerNoVAT,0) - COALESCE (tmpMI_Income.PriceNoVAT,0)) ::TFloat AS Price_diff

           , tmpMI.isAmountPartnerSecond ::Boolean
           , tmpMI.isReturnOut           ::Boolean
           , tmpMI.Comment        ::TVarChar
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
  
            LEFT JOIN tmpMI_Income ON tmpMI_Income.GoodsId  = Object_Goods.Id
                                  AND COALESCE (tmpMI_Income.GoodsKindId,0) = COALESCE (tmpMI.GoodsKindId,0)
                                  AND tmpMI.ord = 1
       WHERE tmpMI.ord = 1
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.24         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_WeighingPartner_diff (inMovementId:= 29774297  , inIsErased:= TRUE, inSession:= '2')
