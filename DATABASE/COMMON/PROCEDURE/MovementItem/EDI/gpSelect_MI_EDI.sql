-- Function: gpSelect_MI_EDI()

DROP FUNCTION IF EXISTS gpSelect_MI_EDI (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_EDI(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, MovementItemId Integer, GLNCode TVarChar, GoodsNameEDI TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName  TVarChar
             , Price TFloat
             , AmountOrder TFloat
             , AmountPartnerEDI TFloat, SummPartnerEDI TFloat
             , AmountPartner TFloat, SummPartner TFloat
             , isCheck Boolean, isErased Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_EDI());

     RETURN QUERY 
       WITH tmpMovement AS (SELECT Movement.Id      AS MovementId
                                 , Movement_Sale.Id AS MovementId_Sale
                                 , MovementLinkObject_GoodsProperty.ObjectId AS GoodsPropertyId
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                                              ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                                             AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                                                ON MovementLinkMovement_Sale.MovementChildId = Movement.Id 
                                                               AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                                                ON MovementLinkMovement_MasterEDI.MovementChildId = Movement.Id 
                                                               AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
                                 LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = COALESCE (MovementLinkMovement_Sale.MovementId, MovementLinkMovement_MasterEDI.MovementId)
                                                                    --*** AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                            WHERE Movement.DescId = zc_Movement_EDI()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                           )
       SELECT
             tmpMI.MovementId
           , tmpMI.MovementItemId :: Integer AS MovementItemId
           , tmpMI.GLNCode :: TVarChar       AS GLNCode
           , MIString_GoodsName.ValueData    AS GoodsNameEDI

           , Object_Goods.ObjectCode         AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName
           , Object_GoodsKind.ValueData      AS GoodsKindName

           , tmpMI.Price :: TFloat AS Price
           , 0 :: TFloat AS AmountOrder
           , tmpMI.AmountPartnerEDI :: TFloat AS AmountPartnerEDI
           , tmpMI.SummPartnerEDI :: TFloat AS SummPartnerEDI
           , tmpMI.AmountPartner :: TFloat AS AmountPartner
           , tmpMI.SummPartner :: TFloat AS SummPartner
           , CASE WHEN tmpMI.AmountPartnerEDI <> tmpMI.AmountPartner OR tmpMI.SummPartnerEDI <> tmpMI.SummPartner THEN TRUE ELSE FALSE END :: Boolean AS isCheck

           , FALSE AS isErased

       FROM (SELECT tmpMI.MovementId
                  , MAX (tmpMI.MovementItemId) AS MovementItemId
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.GLNCode
                  , tmpMI.Price
                  , SUM (tmpMI.AmountPartnerEDI) AS AmountPartnerEDI
                  , SUM (tmpMI.SummPartnerEDI) AS SummPartnerEDI
                  , SUM (tmpMI.AmountPartner) AS AmountPartner
                  , SUM (tmpMI.SummPartner) AS SummPartner
             FROM (SELECT tmpMovement.MovementId
                        , MAX (MovementItem.Id)                               AS MovementItemId
                        , MovementItem.ObjectId                               AS GoodsId
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                        , COALESCE (MIString_GLNCode.ValueData, '')           AS GLNCode
                        , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                        , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartnerEDI
                        , SUM (COALESCE (MIFloat_SummPartner.ValueData, 0))   AS SummPartnerEDI
                        , 0 AS AmountPartner
                        , 0 AS SummPartner
                   FROM tmpMovement
                        INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                               AND MovementItem.DescId =  zc_MI_Master()
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                                    ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_SummPartner.DescId = zc_MIFloat_Summ()
                        LEFT JOIN MovementItemString AS MIString_GLNCode
                                                     ON MIString_GLNCode.MovementItemId = MovementItem.Id
                                                    AND MIString_GLNCode.DescId = zc_MIString_GLNCode()
                   GROUP BY tmpMovement.MovementId
                          , MovementItem.ObjectId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          , COALESCE (MIString_GLNCode.ValueData, '')
                          , COALESCE (MIFloat_Price.ValueData, 0)
                  UNION ALL
                   SELECT tmpMI_Sale.MovementId
                        , tmpMI_Sale.MovementItemId
                        , tmpMI_Sale.GoodsId
                        , tmpMI_Sale.GoodsKindId
                        , COALESCE (View_GoodsPropertyValue.ArticleGLN, '') AS GLNCode
                        , tmpMI_Sale.Price
                        , 0 AS AmountPartnerEDI
                        , 0 AS SummPartnerEDI
                        , tmpMI_Sale.AmountPartner
                        , CASE WHEN tmpMI_Sale.CountForPrice > 0
                                    THEN CAST (tmpMI_Sale.AmountPartner * tmpMI_Sale.Price / tmpMI_Sale.CountForPrice AS NUMERIC (16, 2))
                               ELSE CAST (tmpMI_Sale.AmountPartner * tmpMI_Sale.Price AS NUMERIC (16, 2))
                          END AS SummPartner
                   FROM (SELECT tmpMovement.MovementId
                              , tmpMovement.GoodsPropertyId
                              , MAX (MovementItem.Id)                               AS MovementItemId
                              , MovementItem.ObjectId                               AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                              , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                              , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE MIFloat_CountForPrice.ValueData END AS CountForPrice
                              , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                         FROM tmpMovement
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_Sale
                                                     AND MovementItem.DescId =  zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                          ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                         AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                         GROUP BY tmpMovement.MovementId
                                , tmpMovement.GoodsPropertyId
                                , MovementItem.ObjectId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , COALESCE (MIFloat_Price.ValueData, 0)
                                , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE MIFloat_CountForPrice.ValueData END
                        ) AS tmpMI_Sale
                        LEFT JOIN Object_GoodsPropertyValue_View AS View_GoodsPropertyValue
                                                                 ON View_GoodsPropertyValue.GoodsId = tmpMI_Sale.GoodsId
                                                                AND View_GoodsPropertyValue.GoodsKindId = tmpMI_Sale.GoodsKindId
                                                                AND View_GoodsPropertyValue.GoodsPropertyId = tmpMI_Sale.GoodsPropertyId
                  ) AS tmpMI
             GROUP BY tmpMI.MovementId
                    , tmpMI.GoodsId
                    , tmpMI.GoodsKindId
                    , tmpMI.GLNCode
                    , tmpMI.Price
            ) AS tmpMI

            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = tmpMI.MovementItemId
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
      ;
 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MI_EDI (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        * rem --***
 31.07.14                                        * add zc_MovementLinkMovement_MasterEDI
 19.07.14                                        * ALL
 15.05.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_EDI (inStartDate:= '01.07.2014', inEndDate:= '31.07.2014', inSession:= '2')
