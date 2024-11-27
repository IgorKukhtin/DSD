-- Function: gpSelect_Movement_WeighingPartner_Print()

--DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner_Print (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner_Print (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingPartner_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inisShowAll                  Boolean  , -- 2 печати показываем все или  "Отклонение по цене
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbDescId              Integer;
    DECLARE vbStatusId            Integer;
    DECLARE vbPriceWithVAT        Boolean;
    DECLARE vbVATPercent          TFloat;
    DECLARE vbOperDate            TDateTime;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingPartner_Print());
     vbUserId:= lpGetUserBySession (inSession);

     
     --Данные из шапки документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData             AS VATPercent

       INTO vbDescId, vbStatusId, vbOperDate, vbPriceWithVAT, vbVATPercent
     FROM Movement
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
     WHERE Movement.Id = inMovementId
     ;



    OPEN Cursor1 FOR
       SELECT  zfConvert_StringToNumber (Movement.InvNumber)        AS InvNumber
             , MovementString_InvNumberPartner.ValueData ::TVarChar AS InvNumberPartner
             , Movement.OperDate
             , MovementDate_OperDatePartner.ValueData    ::TDateTime AS OperDatePartner

             , Object_From.ValueData                AS FromName
             , Object_To.ValueData       ::TVarChar AS ToName

             , Object_Contract.ValueData ::TVarChar AS ContractName
             , ObjectDate_Signing.ValueData         AS ContractSigningDate
       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = Object_Contract.Id
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND Object_Contract.ValueData <> '-'

       WHERE Movement.DescId = zc_Movement_WeighingPartner()
         AND Movement.Id = inMovementId
       ;

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH
    tmpMI AS (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   --, MovementItem.Amount

                   , SUM (COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0)) AS AmountPartnerSecond

                   , COALESCE (MIFloat_Price.ValueData, 0)                 AS Price
                   , COALESCE (MIFloat_PricePartner.ValueData, 0)          AS PricePartner     
                                                                                           
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

                   , SUM (COALESCE (MIFloat_SummPartner.ValueData,0))                ::TFloat    AS SummPartner

                     --  цена без НДС, до 4 знаков
                   , SUM (CASE WHEN COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) = TRUE
                               THEN CAST (COALESCE (MIFloat_SummPartner.ValueData, 0) - COALESCE (MIFloat_SummPartner.ValueData, 0) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                               ELSE COALESCE (MIFloat_SummPartner.ValueData, 0)
                          END)            AS SummPartnerNoVAT

                     --  цена с НДС, до 4 знаков
                   , SUM (CASE WHEN COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) <> TRUE
                               THEN CAST ((COALESCE (MIFloat_SummPartner.ValueData, 0) + COALESCE (MIFloat_SummPartner.ValueData, 0) * (vbVATPercent / 100))
                                          AS NUMERIC (16, 4))
                               ELSE CAST (COALESCE (MIFloat_SummPartner.ValueData, 0) 
                                          AS NUMERIC (16, 4))
                          END)            AS SummPartnerWVAT
                   
                   --, COALESCE (MIBoolean_PriceWithVAT.ValueData, true)         :: Boolean  AS isPriceWithVAT 
                   
              FROM MovementItem
                   LEFT JOIN MovementItemBoolean AS MIBoolean_PriceWithVAT
                                                 ON MIBoolean_PriceWithVAT.MovementItemId = MovementItem.Id
                                                AND MIBoolean_PriceWithVAT.DescId = zc_MIBoolean_PriceWithVAT()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                              ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummPartner.DescId = zc_MIFloat_SummPartner()

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                              ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                  LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                              ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
                AND (inisShowAll = TRUE OR COALESCE (MIFloat_Price.ValueData, 0) <> COALESCE (MIFloat_PricePartner.ValueData, 0)) 
              GROUP BY MovementItem.ObjectId
                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                     , COALESCE (MIFloat_Price.ValueData, 0)
                     , COALESCE (MIFloat_PricePartner.ValueData, 0)   
                                                                                             
                       --  цена без НДС, до 4 знаков
                     , CASE WHEN COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) = TRUE
                            THEN CAST (COALESCE (MIFloat_PricePartner.ValueData, 0) - COALESCE (MIFloat_PricePartner.ValueData, 0) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                            ELSE COALESCE (MIFloat_PricePartner.ValueData, 0)
                       END
   
                       --  цена с НДС, до 4 знаков
                     , CASE WHEN COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE) <> TRUE
                            THEN CAST ((COALESCE (MIFloat_PricePartner.ValueData, 0) + COALESCE (MIFloat_PricePartner.ValueData, 0) * (vbVATPercent / 100))
                                       AS NUMERIC (16, 4))
                            ELSE CAST (COALESCE (MIFloat_PricePartner.ValueData, 0) 
                                       AS NUMERIC (16, 4))
                       END 
              )

       --результат
       SELECT
             Object_Goods.Id                    AS GoodsId
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Object_Measure.ValueData           AS MeasureName
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
   
           , tmpMI.AmountPartnerSecond
           , tmpMI.Price
           , tmpMI.PricePartner
           , tmpMI.PricePartnerNoVAT
           , tmpMI.PricePartnerWVAT
           , tmpMI.SummPartner
           , CASE WHEN COALESCE (tmpMI.SummPartner,0) <> 0 THEN tmpMI.SummPartnerNoVAT ELSE tmpMI.AmountPartnerSecond * tmpMI.PricePartnerNoVAT END AS SummPartnerNoVAT
           , CASE WHEN COALESCE (tmpMI.SummPartner,0) <> 0 THEN tmpMI.SummPartnerWVAT  ELSE tmpMI.AmountPartnerSecond * tmpMI.PricePartnerWVAT  END AS SummPartnerWVAT
       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                   ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

       ORDER BY ObjectString_Goods_GroupNameFull.ValueData
              , Object_GoodsGroup.ValueData
              , Object_Goods.ValueData
              , Object_GoodsKind.ValueData
        ;


    RETURN NEXT Cursor2;  
    
    END IF;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.11.24         *
*/

-- select * from gpSelect_Movement_WeighingPartner_Print (inMovementId := 29774297  , inisShowAll := 'True' ,  inSession := '9457');   FETCH ALL "<unnamed portal 5>";