-- Function:  gpReport_Upload_ADV()

DROP FUNCTION IF EXISTS gpReport_Upload_ADV (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_ADV(
    IN inDate         TDateTime,  -- Операционный день
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (retailName     TVarChar  --Торговая сеть
             , city           TVarChar  --Регион
             , address        TVarChar  --Адрес аптеки
             , checkID        TVarChar  --Номер документа
             , sale_date      TVarChar --Дата - дата операционного дня к которой относится произведенная операция
             , sale_time      TVarChar --Время покупки
             , itemBC         TVarChar  --Штрих код товара
             , couponBC       TVarChar  --Штрих код купона
             , nameBC         TVarChar  --Наименование товара - наименование товара в учетной системе компании Клиента
             , price          TFloat    --Цена с НДС
             , sum_price      TFloat    --Продано
             , sum_couponsale TFloat    --Продано по купону
             , discount       TFloat    --Сумма скидки на еденицу
             , discount_rel   TFloat    --Процент скидки
             , sum_discount   TFloat    --Сумма скидки с НДС
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
      vbUserId:= lpGetUserBySession (inSession);

      -- список аптек
      CREATE TEMP TABLE tmpUnit ON COMMIT DROP
      AS (SELECT ObjectLink_Juridical_Retail.ChildObjectId           AS RetailId
               , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS OKPO
               , ObjectLink_Unit_Juridical.ObjectId                  AS UnitId
               , Object_Unit.ValueData                               AS UnitName
               , ObjectString_Unit_Address.ValueData                 AS UnitAddress
          FROM ObjectLink AS ObjectLink_Unit_Juridical
               JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               JOIN ObjectLink AS ObjectLink_Unit_Parent
                               ON ObjectLink_Unit_Parent.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                              AND ObjectLink_Unit_Parent.ChildObjectId IS NOT NULL
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Juridical.ObjectId
               LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                      ON ObjectString_Unit_Address.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                     AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
               LEFT JOIN ObjectHistory AS ObjectHistory_JuridicalDetails
                                       ON ObjectHistory_JuridicalDetails.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                      AND ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
                                      AND ObjectHistory_JuridicalDetails.StartDate <= inDate
                                      AND ObjectHistory_JuridicalDetails.EndDate > inDate
               LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                             ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
          WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            AND ObjectLink_Unit_Parent.ChildObjectId not in (2141104, 3031071, 5603546, 377601, 5778621, 5062813)
         );
         
      ANALYSE tmpUnit;

      -- список товаров поставщика
      CREATE TEMP TABLE tmpGoods ON COMMIT DROP
      AS (WITH tmpGoodsBarCode AS (SELECT DISTINCT Object_LinkGoods_View.GoodsMainId AS GoodsMainId
                              , Object_BarCode.ValueData AS BarCode
                               FROM Object_LinkGoods_View

               JOIN ObjectLink AS ObjectLink_Main_BarCode
                               ON ObjectLink_Main_BarCode.ChildObjectId = Object_LinkGoods_View.GoodsMainId
                              AND ObjectLink_Main_BarCode.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

               JOIN ObjectLink AS ObjectLink_Child_BarCode
                                    ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                   AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()

               JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                    ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                   AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                   AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()

               JOIN Object AS Object_BarCode ON Object_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId

          WHERE Object_LinkGoods_View.goodsmaincode in (4718, 4719, 27953, 4800, 11826, 5181, 11776)
            AND TRIM (Object_BarCode.ValueData) <> ''
                              )

          SELECT DISTINCT Object_LinkGoods_View.GoodsId                   AS GoodsId
                        , Object_LinkGoods_View.GoodsMainName   AS GoodsName
                        , tmpGoodsBarCode.BarCode               AS BarCode
          FROM Object_LinkGoods_View

               LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_LinkGoods_View.GoodsMainId

          WHERE Object_LinkGoods_View.goodsmaincode in (4718, 4719, 27953, 4800, 11826, 5181, 11776)
         );
         
      ANALYSE tmpGoods;

      -- продажи за указанную дату
      CREATE TEMP TABLE tmpSales ON COMMIT DROP
      AS (SELECT Movement_Check.InvNumber                                 AS InvNumber
               , Movement_Check.OperDate                                  AS OperDate

               , MovementLinkObject_Unit.ObjectId                         AS UnitId
               , MI_Check.ObjectId                                        AS GoodsId
               , COALESCE (MIFloat_Price.ValueData, 0.0)::TFloat          AS Price
               , COALESCE (MIFloat_PriceSale.ValueData, 0.0)::TFloat      AS PriceSale
               , COALESCE (MIFloat_ChangePercent.ValueData, 0.0)::TFloat  AS ChangePercent
               , SUM (MI_Check.Amount)::TFloat                            AS Amount
               , SUM (COALESCE (MIFloat_Price.ValueData, 0.0) * MI_Check.Amount)::TFloat AS Summ
               , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0.0))::TFloat       AS SummChangePercent
          FROM Movement AS Movement_Check
               JOIN MovementItem AS MI_Check
                                 ON MI_Check.MovementId = Movement_Check.Id
                                AND MI_Check.DescId = zc_MI_Master()
                                AND MI_Check.isErased = FALSE
               JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = MI_Check.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
               LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                           ON MIFloat_PriceSale.MovementItemId = MI_Check.Id
                                          AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                           ON MIFloat_ChangePercent.MovementItemId = MI_Check.Id
                                          AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
               LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                           ON MIFloat_SummChangePercent.MovementItemId = MI_Check.Id
                                          AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
          WHERE Movement_Check.DescId IN (zc_Movement_Check(), zc_Movement_Sale())
            AND Movement_Check.OperDate >= DATE_TRUNC ('day', inDate) and Movement_Check.OperDate < DATE_TRUNC ('day', inDate) + INTERVAL '1 DAY'
            AND Movement_Check.StatusId = zc_Enum_Status_Complete()
          GROUP BY Movement_Check.InvNumber
                 , Movement_Check.OperDate
                 , MovementLinkObject_Unit.ObjectId
                 , MI_Check.ObjectId
                 , MIFloat_Price.ValueData
                 , MIFloat_PriceSale.ValueData
                 , MIFloat_ChangePercent.ValueData
         );
         
      ANALYSE tmpSales;

      -- Результат
      RETURN QUERY
        SELECT Object_Retal.ValueData
             , Object_Area.ValueData
             , tmpUnit.UnitAddress
             , tmpSales.InvNumber
             , to_char(tmpSales.OperDate, 'DD.MM.YYYY')::TVarChar
             , to_char(tmpSales.OperDate, 'HH24:MI:SS')::TVarChar
             , tmpGoods.BarCode
             , ''::TVarChar
             , tmpGoods.GoodsName
             , tmpSales.PriceSale
             , tmpSales.Amount
             , 0::TFloat
             , CASE WHEN COALESCE(tmpSales.ChangePercent, 0) = 0 THEN tmpSales.PriceSale - tmpSales.Price ELSE NULL END::TFloat
             , tmpSales.ChangePercent
             , tmpSales.SummChangePercent
        FROM tmpSales

             JOIN tmpUnit ON tmpUnit.UnitId = tmpSales.UnitId

             JOIN tmpGoods ON tmpGoods.GoodsId = tmpSales.GoodsId

             JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = tmpSales.UnitId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

             JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             JOIN Object AS Object_Retal ON Object_Retal.Id = ObjectLink_Juridical_Retail.ChildObjectId

             JOIN ObjectLink AS ObjectLink_Unit_Area
                             ON ObjectLink_Unit_Area.ObjectId = tmpSales.UnitId
                            AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
             JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId
        WHERE tmpSales.Amount > 0
        ORDER BY tmpSales.OperDate;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Шаблий о.В.
 18.04.19                                                                         *
 28.02.19                                                                         *

*/

-- тест
-- SELECT * FROM gpReport_Upload_ADV (inDate:= '26.02.2019'::TDateTime, inSession:= zfCalc_UserAdmin())