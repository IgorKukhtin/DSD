-- Function:  gpReport_Upload_Teva()

DROP FUNCTION IF EXISTS gpReport_Upload_Teva (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_Teva(
    IN inDate         TDateTime,  -- Операционный день
    IN inObjectId     Integer,    -- Поставщик
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate      TDateTime --Дата - дата операционного дня к которой относится произведенная операция 
             , OKPO          TVarChar  --ЕДРПОУ юр.лица, к которому принадлежит аптека
             , UnitName      TVarChar  --Наименование склада - наименование аптеки в учетной системе компании Клиента
             , UnitAddress   TVarChar  --Адрес аптеки
             , GoodsName     TVarChar  --Наименование товара - наименование товара в учетной системе компании Клиента
             , Amount        TFloat    --Значение - числовое значение для результата операции. Например, для продажи это кол-во проданных упаковок - 3 шт.
             , Summ          TFloat    --Сумма с НДС
             , Price         TFloat    --Цена с НДС
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
      AS (SELECT DISTINCT LinkGoods_Main_Retail.GoodsId AS GoodsId
                        , Object_Goods_View.GoodsName   AS GoodsName
          FROM Object_Goods_View
               JOIN Object_LinkGoods_View AS LinkGoods_Partner_Main
                                          ON LinkGoods_Partner_Main.GoodsId = Object_Goods_View.id -- Связь товара поставщика с общим
               JOIN Object_LinkGoods_View AS LinkGoods_Main_Retail -- связь товара сети с главным товаром
                                          ON LinkGoods_Main_Retail.GoodsMainId = LinkGoods_Partner_Main.GoodsMainId
               JOIN Object AS Object_Retail
                           ON Object_Retail.Id = LinkGoods_Main_Retail.ObjectId
                          AND Object_Retail.DescId = zc_Object_Retail() 
               JOIN ObjectBoolean AS ObjectBoolean_Goods_UploadTeva 
                                  ON ObjectBoolean_Goods_UploadTeva.ObjectId = Object_Goods_View.id
                                 AND ObjectBoolean_Goods_UploadTeva.DescId = zc_ObjectBoolean_Goods_UploadTeva()
                                 AND ObjectBoolean_Goods_UploadTeva.ValueData
          WHERE Object_Goods_View.ObjectId = inObjectId
         ); 
         
      ANALYSE tmpGoods;

      -- продажи за указанную дату
      CREATE TEMP TABLE tmpMovement ON COMMIT DROP
      AS (SELECT Movement_Check.*
               , MovementLinkObject_Unit.ObjectId                       AS UnitId 
          FROM Movement AS Movement_Check
               JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
               JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId 
          WHERE Movement_Check.DescId IN (zc_Movement_Check(), zc_Movement_Sale())
            AND Movement_Check.OperDate  >= DATE_TRUNC ('day', inDate)
            AND Movement_Check.OperDate  < DATE_TRUNC ('day', inDate) + INTERVAL '1 DAY'
            /*AND Movement_Check.OperDate  >= DATE_TRUNC ('month', inDate)
            AND Movement_Check.OperDate  < DATE_TRUNC ('month', inDate) + INTERVAL '1 MONTH'*/
            AND Movement_Check.StatusId = zc_Enum_Status_Complete()
         );
         
      ANALYSE tmpMovement;

      -- продажи за указанную дату
      CREATE TEMP TABLE tmpMI ON COMMIT DROP
      AS (SELECT DATE_TRUNC ('day', Movement_Check.OperDate)::TDateTime AS OperDate
               , Movement_Check.UnitId                                  AS UnitId
               , MI_Check.Id                                            AS Id
               , MI_Check.ObjectId                                      AS GoodsId
               , MI_Check.Amount                                        AS Amount
          FROM tmpMovement AS Movement_Check
               JOIN MovementItem AS MI_Check
                                 ON MI_Check.MovementId = Movement_Check.Id
                                AND MI_Check.DescId = zc_MI_Master()
                                AND MI_Check.isErased = FALSE
         );
         
      ANALYSE tmpMI;
            
      -- продажи за указанную дату
      CREATE TEMP TABLE tmpSales ON COMMIT DROP
      AS (SELECT Movement_Check.OperDate                                AS OperDate
               , Movement_Check.UnitId                                  AS UnitId
               , Movement_Check.GoodsId                                 AS GoodsId
               , COALESCE (MIFloat_Price.ValueData, 0.0)::TFloat        AS Price
               , SUM (Movement_Check.Amount)::TFloat                    AS Amount
               , SUM (COALESCE (MIFloat_Price.ValueData, 0.0) * Movement_Check.Amount)::TFloat AS Summ
          FROM tmpMI AS Movement_Check

               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = Movement_Check.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price() 

          GROUP BY Movement_Check.OperDate
                 , Movement_Check.UnitId
                 , Movement_Check.GoodsId
                 , MIFloat_Price.ValueData
         );
         
      ANALYSE tmpSales;

      -- Результат
      RETURN QUERY
        SELECT tmpSales.OperDate
             , tmpUnit.OKPO
             , tmpUnit.UnitName
             , tmpUnit.UnitAddress
             , tmpGoods.GoodsName
             , tmpSales.Amount
             , tmpSales.Summ
             , tmpSales.Price   
        FROM tmpSales
             JOIN tmpUnit ON tmpUnit.UnitId = tmpSales.UnitId
             JOIN tmpGoods ON tmpGoods.GoodsId = tmpSales.GoodsId
        ORDER BY tmpSales.OperDate, tmpGoods.GoodsName, tmpSales.Price ;
                          
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.  Ярошенко Р.Ф.   Шаблий О.В.
 18.04.19                                                                                       *
 29.03.17                                                                         *

*/

-- тест
-- 
SELECT * FROM gpReport_Upload_Teva (inDate:= '09.03.2023'::TDateTime, inObjectId:= 59610, inSession:= zfCalc_UserAdmin())
