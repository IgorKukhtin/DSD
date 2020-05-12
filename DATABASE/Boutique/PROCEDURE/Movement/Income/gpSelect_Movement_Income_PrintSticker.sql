-- Function: gpSelect_Movement_Income_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Send_PrintSticker (Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_PrintSticker(
    IN inMovementId        Integer   ,   -- ���� ���������
    IN inUserId            Integer   ,   -- ������������ GoodsPrint
    IN inGoodsPrintId      Integer   ,   -- ������ GoodsPrint
    IN inIsGoodsPrint      Boolean   ,   -- �������� �� ������ � Object_GoodsPrint - ��� �����. ������ + ������������
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbPriceListId_to Integer;
    DECLARE vbMovementDescId Integer;

    DECLARE Cursor1 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     -- vbUserId:= lpGetUserBySession (inSession);
     
     
     --
     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

     -- ���� �� �� ������
     IF inIsGoodsPrint = FALSE
     THEN

         -- �������� - � ����� �������� ����� ��������
         PERFORM lfCheck_Movement_Print (inMovementDescId:= Movement.DescId, inMovementId:= Movement.Id, inStatusId:= Movement.StatusId) FROM Movement WHERE Id = inMovementId;

         -- ������ �����-����
         vbPriceListId_to:= (SELECT COALESCE (ObjectLink_Unit_PriceList.ChildObjectId, zc_PriceList_Basis()) AS PriceListId_to
                             FROM Movement
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                  LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                                       ON ObjectLink_Unit_PriceList.ObjectId = MovementLinkObject_To.ObjectId
                                                      AND ObjectLink_Unit_PriceList.DescId   = zc_ObjectLink_Unit_PriceList()
                             WHERE Movement.Id     = inMovementId
                             --AND Movement.DescId = zc_Movement_Send()
                            );

         -- ���������
         OPEN Cursor1 FOR
           WITH tmpMI AS (SELECT MovementItem.Id
                               , MovementItem.ObjectId   AS GoodsId
                               , MovementItem.PartionId  AS PartionId
                               , MovementItem.Amount
                               , COALESCE (MIFloat_OperPriceList.ValueData, 0) AS OperPriceList
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
              , tmpPriceList AS (SELECT DISTINCT
                                        tmpGoodsPrint.GoodsId
                                      , ObjectHistoryFloat_PriceListItem_Value.ValueData AS Price
                                      , OL_currency.ChildObjectId                        AS CurrencyId
                                 FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoodsPrint
                                      LEFT JOIN ObjectLink AS OL_currency ON OL_currency.ObjectId = vbPriceListId_to
                                                                         AND OL_currency.DescId   = zc_ObjectLink_PriceList_Currency()
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                            ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpGoodsPrint.GoodsId
                                                           AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                            ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                           AND ObjectLink_PriceListItem_PriceList.ChildObjectId = vbPriceListId_to
                                                           AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                                      LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                              ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                             AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                             AND ((ObjectHistory_PriceListItem.EndDate   = zc_DateEnd()   AND (vbMovementDescId <> zc_Movement_Send() OR  zc_Enum_GlobalConst_isTerry() = TRUE))
                                                               OR (ObjectHistory_PriceListItem.StartDate = zc_DateStart() AND  vbMovementDescId =  zc_Movement_Send() AND zc_Enum_GlobalConst_isTerry() = FALSE)
                                                                 )
                                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                   ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                  AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                )
           -- ���������
           SELECT
                 tmpMI.Id
               , tmpMI.PartionId
               , Object_Goods.Id                AS GoodsId
               , Object_Goods.ObjectCode        AS GoodsCode
               , Object_Goods.ValueData         AS GoodsName
               , (CASE WHEN Object_Composition.ValueData NOT IN ('-', '') THEN CASE WHEN LENGTH (Object_Composition.ValueData) <= 25 AND zc_Enum_GlobalConst_isTerry() = TRUE THEN '����: ' ELSE '' END || Object_Composition.ValueData ELSE '' END) :: TVarChar AS CompositionName
               , Object_GoodsInfo.ValueData     AS GoodsInfoName
               , Object_LineFabrica.ValueData   AS LineFabricaName
               , Object_Label.ValueData         AS LabelName
               , Object_GoodsSize.ValueData     AS GoodsSizeName
               , Object_Brand.ValueData         AS BrandName
               , Object_CountryBrand.ValueData  AS CountryBrandName
               , zfFormat_BarCode (zc_BarCodePref_Object(), tmpMI.PartionId) AS IdBarCode

               , COALESCE (tmpPriceList.Price, tmpMI.OperPriceList) :: TFloat AS OperPriceList

               , (SUBSTR ((Object_PartionGoods.PeriodYear :: Integer) :: TVarChar, 3, 1)
               || CASE WHEN Object_Period.ObjectCode = 1 THEN 'L' ELSE 'Z' END
               || SUBSTR ((Object_PartionGoods.PeriodYear :: Integer) :: TVarChar, 4, 1)
                 ) AS PeriodName

               , CASE WHEN COALESCE (tmpPriceList.CurrencyId, zc_Currency_GRN()) = zc_Currency_GRN()
                           THEN '��� '
                      ELSE '-���. '
                 END :: TVarChar AS ValutaName

           FROM tmpMI
                LEFT JOIN tmpList ON tmpList.Amount = tmpMI.Amount

                LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpMI.GoodsId

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
     ELSE

         -- ������ �� ������ Object_GoodsPrint - ��� �����. ������ � ������������
         OPEN Cursor1 FOR
           WITH
               tmpGoodsPrint AS (SELECT Object_GoodsPrint.Id
                                      , Object_GoodsPrint.UnitId
                                      , Object_GoodsPrint.PartionId
                                      , Object_GoodsPrint.Amount
                                 FROM  (SELECT Object_GoodsPrint.InsertDate
                                             , ROW_NUMBER() OVER( PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate)  AS ord
                                        FROM Object_GoodsPrint
                                        WHERE Object_GoodsPrint.UserId = inUserId
                                        GROUP BY Object_GoodsPrint.UserId
                                               , Object_GoodsPrint.InsertDate
                                               , Object_GoodsPrint.UnitId
                                               , Object_GoodsPrint.isReprice
                                        ) AS tmp
                                       LEFT JOIN Object_GoodsPrint ON Object_GoodsPrint.InsertDate = tmp.InsertDate
                                                                  AND Object_GoodsPrint.UserId     = inUserId
                                  WHERE tmp.Ord = inGoodsPrintId AND inGoodsPrintId <> 0
                                 )
             , tmpList AS (SELECT tmp.Amount, GENERATE_SERIES (1, tmp.Amount :: Integer) AS Ord
                           FROM (SELECT DISTINCT tmpGoodsPrint.Amount FROM tmpGoodsPrint) AS tmp
                          )
              , tmpPriceList AS (SELECT DISTINCT
                                        tmpGoodsPrint.UnitId
                                      , tmpGoodsPrint.PartionId
                                      , ObjectHistoryFloat_PriceListItem_Value.ValueData AS Price
                                      , OL_currency.ChildObjectId                        AS CurrencyId
                                 FROM tmpGoodsPrint
                                      LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                                           ON ObjectLink_Unit_PriceList.ObjectId = tmpGoodsPrint.UnitId
                                                          AND ObjectLink_Unit_PriceList.DescId   = zc_ObjectLink_Unit_PriceList()
                                      LEFT JOIN ObjectLink AS OL_currency ON OL_currency.ObjectId = ObjectLink_Unit_PriceList.ChildObjectId
                                                                         AND OL_currency.DescId   = zc_ObjectLink_PriceList_Currency()

                                      LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpGoodsPrint.PartionId

                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                            ON ObjectLink_PriceListItem_Goods.ChildObjectId = Object_PartionGoods.GoodsId
                                                           AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                            ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                           AND ObjectLink_PriceListItem_PriceList.ChildObjectId = COALESCE (ObjectLink_Unit_PriceList.ChildObjectId, zc_PriceList_Basis())
                                                           AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                                      LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                              ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                             AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                             AND ((ObjectHistory_PriceListItem.EndDate   = zc_DateEnd()   AND (vbMovementDescId <> zc_Movement_Send() OR  zc_Enum_GlobalConst_isTerry() = TRUE))
                                                               OR (ObjectHistory_PriceListItem.StartDate = zc_DateStart() AND  vbMovementDescId =  zc_Movement_Send() AND zc_Enum_GlobalConst_isTerry() = FALSE)
                                                                 )
                                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                   ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                  AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                )
           -- ���������
           SELECT
                 tmpGoodsPrint.PartionId
               , Object_Goods.Id                AS GoodsId
               , Object_Goods.ObjectCode        AS GoodsCode
               , Object_Goods.ValueData         AS GoodsName
               , (CASE WHEN Object_Composition.ValueData NOT IN ('-', '') THEN CASE WHEN LENGTH (Object_Composition.ValueData) <= 25 THEN '����: ' ELSE '' END || Object_Composition.ValueData ELSE '' END) :: TVarChar AS CompositionName
               , Object_GoodsInfo.ValueData     AS GoodsInfoName
               , Object_LineFabrica.ValueData   AS LineFabricaName
               , Object_Label.ValueData         AS LabelName
               , Object_GoodsSize.ValueData     AS GoodsSizeName
               , Object_Brand.ValueData         AS BrandName
               , Object_CountryBrand.ValueData  AS CountryBrandName
               , zfFormat_BarCode (zc_BarCodePref_Object(), tmpGoodsPrint.PartionId) AS IdBarCode

               , COALESCE (tmpPriceList.Price, Object_PartionGoods.OperPriceList) :: TFloat AS OperPriceList

               , (SUBSTR ((Object_PartionGoods.PeriodYear :: Integer) :: TVarChar, 3, 1)
               || CASE WHEN Object_Period.ObjectCode = 1 THEN 'L' ELSE 'Z' END
               || SUBSTR ((Object_PartionGoods.PeriodYear :: Integer) :: TVarChar, 4, 1)
                 ) AS PeriodName

               , CASE WHEN COALESCE (tmpPriceList.CurrencyId, zc_Currency_GRN()) = zc_Currency_GRN()
                           THEN '��� '
                      ELSE '-���. '
                 END :: TVarChar AS ValutaName

           FROM tmpGoodsPrint
                LEFT JOIN tmpList ON tmpList.Amount = tmpGoodsPrint.Amount
                LEFT JOIN tmpPriceList ON tmpPriceList.UnitId    = tmpGoodsPrint.UnitId
                                      AND tmpPriceList.PartionId = tmpGoodsPrint.PartionId

                LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpGoodsPrint.PartionId

                LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = Object_PartionGoods.GoodsId
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

           ORDER BY tmpGoodsPrint.Id, Object_Goods.ObjectCode, Object_GoodsSize.ValueData
           ;

         RETURN NEXT Cursor1;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
24.05.17                                                          *
23.05.17                                                          *
15.05.17                                                          *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Income_PrintSticker (inMovementId := 432692, inUserId:= 2, inGoodsPrintId:= 0, inIsGoodsPrint:= FALSE, inSession:= '2'); -- FETCH ALL "<unnamed portal 1>";
