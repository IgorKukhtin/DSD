-- Function: gpSelect_Movement_Income_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_PrintSticker(
    IN inMovementId        Integer   ,   -- ключ Документа
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка - с каким статусом можно печатать
     PERFORM lfCheck_Movement_Print (inMovementDescId:= Movement.DescId, inMovementId:= Movement.Id, inStatusId:= Movement.StatusId) FROM Movement WHERE Id = inMovementId;

     -- Результат
     OPEN Cursor1 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId   AS GoodsId
                           , MovementItem.PartionId  AS PartionId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0) AS OperPriceList
                           , MovementItem.isErased
                      FROM MovementItem
                           LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                       ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                      AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     <> 0
                     )
        , tmpList AS (SELECT tmp.Amount, GENERATE_SERIES (1, tmp.Amount :: Integer) AS Ord
                      FROM (SELECT DISTINCT tmpMI.Amount FROM tmpMI) AS tmp
                     )
       -- Результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , (CASE WHEN Object_Composition.ValueData NOT IN ('-', '') THEN 'сост: ' || Object_Composition.ValueData ELSE '' END) :: TVarChar AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.ValueData     AS GoodsSizeName
           , Object_Brand.ValueData         AS BrandName
           , Object_CountryBrand.ValueData  AS CountryBrandName
           , zfFormat_BarCode (zc_BarCodePref_Object(), tmpMI.PartionId) AS IdBarCode

           , tmpMI.OperPriceList  :: TFloat AS OperPriceList

           , (SUBSTR ((Object_PartionGoods.PeriodYear :: Integer) :: TVarChar, 3, 1)
           || CASE WHEN Object_Period.ObjectCode = 1 THEN 'O' ELSE 'L' END
           || SUBSTR ((Object_PartionGoods.PeriodYear :: Integer) :: TVarChar, 4, 1)
             ) AS PeriodName

       FROM tmpMI
            LEFT JOIN tmpList ON tmpList.Amount = tmpMI.Amount
            
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = Object_PartionGoods.BrandId

            LEFT JOIN ObjectLink AS Object_Brand_CountryBrand
                                 ON Object_Brand_CountryBrand.ObjectId = Object_Brand.Id
                                AND Object_Brand_CountryBrand.DescId = zc_ObjectLink_Brand_CountryBrand()
            LEFT JOIN Object AS Object_CountryBrand ON Object_CountryBrand.Id = Object_Brand_CountryBrand.ChildObjectId

            LEFT JOIN Object AS Object_Period          ON Object_Period.Id     = Object_PartionGoods.PeriodId

       ORDER BY Object_Goods.ObjectCode, Object_GoodsSize.ValueData
       ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
24.05.17                                                          *
23.05.17                                                          *
15.05.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income_PrintSticker (inMovementId := 432692, inSession:= '5');
