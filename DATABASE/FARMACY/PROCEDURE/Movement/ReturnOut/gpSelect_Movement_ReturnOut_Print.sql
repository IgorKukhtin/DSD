-- Function: gpSelect_Movement_ReturnOut_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnOut_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnOut_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReturnOut());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT
            Movement_ReturnOut.Id
          , Movement_ReturnOut.InvNumber
          , Movement_ReturnOut.OperDate
          , Movement_ReturnOut.ToName
          , Movement_ReturnOut.IncomeInvNumber
          , Movement_ReturnOut.IncomeOperDate
          , Movement_ReturnOut.JuridicalName
          , Movement_ReturnOut.FromName
          , Movement_ReturnOut.ReturnTypeName
          , Movement_ReturnOut.LegalAddressName
          , Movement_ReturnOut.ActualAddressName
          , Movement_ReturnOut.TotalSummMVAT
          , Movement_ReturnOut.TotalSumm
          , (Movement_ReturnOut.TotalSumm - Movement_ReturnOut.TotalSummMVAT) AS TotalSummVAT
          , Movement_ReturnOut.TotalCount
        FROM
            Movement_ReturnOut_View AS Movement_ReturnOut
        WHERE 
            Movement_ReturnOut.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    
        SELECT
            MI_ReturnOut.GoodsName
          , MI_ReturnOut.Amount
          , Object_Measure.ValueData AS MeasureName
          
          , MIDate_ExpirationDate.ValueData            AS ExpirationDate
          , MIString_PartionGoods.ValueData            AS PartionGoods
          , ObjectString_Goods_Maker.ValueData         AS MakerName
          
          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE 
                THEN MI_ReturnOut.Price
                ELSE ROUND(MI_ReturnOut.Price*(1+(ObjectFloat_NDSKind_NDS.ValueData/100)),2)
            END AS PriceWithVAT
          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE 
                THEN MI_ReturnOut.AmountSumm
                ELSE ROUND(MI_ReturnOut.AmountSumm*(1+(ObjectFloat_NDSKind_NDS.ValueData/100)),2)
            END AS SummaWithVAT
          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                THEN MI_ReturnOut.Price
                ELSE ROUND(MI_ReturnOut.Price/(1+(ObjectFloat_NDSKind_NDS.ValueData/100)),2)
            END AS Price
          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                THEN MI_ReturnOut.AmountSumm
                ELSE ROUND(MI_ReturnOut.AmountSumm/(1+(ObjectFloat_NDSKind_NDS.ValueData/100)),2)
            END AS Summa  

        FROM
            MovementItem_ReturnOut_View AS MI_ReturnOut
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_Measure
                                       ON ObjectLink_Goods_Measure.ObjectId = MI_ReturnOut.GoodsId
                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT OUTER JOIN Object AS Object_Measure
                                   ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  MI_ReturnOut.MovementId
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = MI_ReturnOut.MovementId
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
 
            -- данные из прихода 
            LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                       ON MIDate_ExpirationDate.MovementItemId = MI_ReturnOut.ParentId
                                      AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MI_ReturnOut.ParentId
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()  
                                        
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MI_ReturnOut.ParentId
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                  ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId 
                                 AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()
        WHERE
            MI_ReturnOut.MovementId = inMovementId
            AND
            MI_ReturnOut.isErased = FALSE;

    RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ReturnOut_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 14.04.16         *
 25.12.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_ReturnOut_Print (inMovementId := 570596, inSession:= '5');
