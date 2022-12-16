-- Function: lpCreateTempTable_OrderInternal()

DROP FUNCTION IF EXISTS lpCreateTempTable_OrderInternal (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCreateTempTable_OrderInternal(
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
  DECLARE vbAreaId_find Integer;
  DECLARE vbCostCredit TFloat;
BEGIN

     -- получаем значение константы
     vbCostCredit := COALESCE ((SELECT COALESCE (ObjectFloat_SiteDiscount.ValueData, 0)          :: TFloat    AS SiteDiscount
                                FROM Object AS Object_GlobalConst
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_SiteDiscount
                                                              ON ObjectBoolean_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                                             AND ObjectBoolean_SiteDiscount.DescId = zc_ObjectBoolean_GlobalConst_SiteDiscount()
                                                             AND ObjectBoolean_SiteDiscount.ValueData = TRUE
                                     INNER JOIN ObjectFloat AS ObjectFloat_SiteDiscount
                                                           ON ObjectFloat_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                                          AND ObjectFloat_SiteDiscount.DescId = zc_ObjectFloat_GlobalConst_SiteDiscount()
                                                          AND COALESCE (ObjectFloat_SiteDiscount.ValueData, 0) <> 0
                                WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
                                  AND Object_GlobalConst.Id =zc_Enum_GlobalConst_CostCredit()
                                )
                                , 0)  :: TFloat;

     -- ПАРАМЕТРЫ
     SELECT ObjectLink_Unit_Juridical.ChildObjectId, MovementLinkObject.ObjectId, COALESCE (ObjectLink_Unit_Area.ChildObjectId, zc_Area_Basis())
            INTO vbMainJuridicalId, vbUnitId, vbAreaId_find
         FROM MovementLinkObject
              --INNER JOIN Object_Unit_View ON Object_Unit_View.Id = MovementLinkObject.ObjectId
              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             
              LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                   ON ObjectLink_Unit_Area.ObjectId = MovementLinkObject.ObjectId
                                  AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
     WHERE MovementLinkObject.MovementId = inMovementId 
       AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();


     -- таблица Регион поставщика
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpJuridicalArea'))
     THEN
         CREATE TEMP TABLE tmpJuridicalArea (UnitId Integer, JuridicalId Integer, AreaId Integer, AreaName TVarChar, isDefault Boolean) ON COMMIT DROP;
         INSERT INTO tmpJuridicalArea (UnitId, JuridicalId, AreaId, AreaName, isDefault)
            SELECT DISTINCT 
                   tmp.UnitId                   AS UnitId            
                 , tmp.JuridicalId              AS JuridicalId
                 , tmp.AreaId_Juridical         AS AreaId
                 , tmp.AreaName_Juridical       AS AreaName
                 , tmp.isDefault_JuridicalArea  AS isDefault
            FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId, 0) AS tmp;
     END IF;

     ANALYSE tmpJuridicalArea;
	 
     -- ДАННЫЕ
     CREATE TEMP TABLE _tmpMI (Id integer
             , MovementItemId Integer
             , PriceListMovementItemId Integer
             , Price TFloat
             , PartionGoodsDate TDateTime
             , GoodsId Integer
             , GoodsCode TVarChar
             , GoodsName TVarChar
             , MainGoodsName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , MakerName TVarChar
             , ContractId Integer
             , ContractName TVarChar
             , AreaId Integer
             , AreaName TVarChar
             , isDefault Boolean
             , Deferment Integer
             , Bonus TFloat
             , Percent TFloat
             , SuperFinalPrice TFloat
             , SuperFinalPrice_Deferment TFloat) ON COMMIT DROP;


      -- Сохраниели данные
      INSERT INTO _tmpMI 

           WITH -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
                PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (inUserId::TVarChar))
              , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (inUserId::TVarChar))

              , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)
                -- элементы установок юр.лиц (границы цен для бонуса)
              , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                                  , tmp.Bonus
                                                  , tmp.PriceLimit_min
                                                  , tmp.PriceLimit
                                             FROM JuridicalSettings
                                                  INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inUserId::TVarChar) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                             WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                             )

              , JuridicalArea AS (SELECT DISTINCT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                                  FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                       INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                AND Object_JuridicalArea.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                             ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                            AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                            AND ObjectLink_JuridicalArea_Area.ChildObjectId = vbAreaId_find
                                       -- Уникальный код поставщика ТОЛЬКО для Региона
                                       INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                                ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id 
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                               AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                  WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                 ) 

              , MovementItemOrder AS (SELECT MovementItem.*
                                           , ObjectLink_Main.ChildObjectId AS GoodsMainId, ObjectLink_LinkGoods_Goods.ChildObjectId AS GoodsId
                                      FROM MovementItem    
                                       --  INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.ObjectId -- Связь товара сети с общим
                                       -- получаем GoodsMainId
                                           INNER JOIN  ObjectLink AS ObjectLink_Child 
                                                                  ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                         --  LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                         --                                  ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                           -- товары сети по главному GoodsMainId
                                           LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                                                                ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()  
                                                               AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_Main.ChildObjectId --Object_LinkGoods_View.GoodsMainId
                                      
                                           LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                                ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                               AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                                                ON ObjectLink_Goods_Area.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                                                ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                               AND ObjectLink_Goods_Object.DescId   = zc_ObjectLink_Goods_Object()
                                           LEFT JOIN JuridicalArea ON JuridicalArea.JuridicalId = ObjectLink_Goods_Object.ChildObjectId

                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND ((inGoodsId = 0) OR (inGoodsId = MovementItem.ObjectId))
                                        AND (ObjectLink_Goods_Area.ChildObjectId = vbAreaId_find OR JuridicalArea.JuridicalId IS NULL)
                                  )
                -- Маркетинговый контракт
              , tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- здесь товар "сети"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUnitId  := vbUnitId
                                                                                       , inUserId  := inUserId) AS tmp
                                      )
                -- Список цены + ТОП
              , GoodsPrice AS (SELECT MovementItemOrder.ObjectId AS GoodsId, ObjectBoolean_Top.ValueData AS isTOP
                               FROM MovementItemOrder
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                          ON ObjectLink_Price_Goods.ChildObjectId = MovementItemOrder.ObjectId
                                                         AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                          ON ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                                         AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                         AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Top
                                                             ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                            AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                            AND ObjectBoolean_Top.ValueData = TRUE
                              )

              , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceList.JuridicalId
                                          , LoadPriceList.ContractId
                                          , LoadPriceList.AreaId
                                     FROM LoadPriceList
                                     )

              -- данные по % кредитных средств из справочника
              , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := inObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inUserId :: TVarChar) AS tmp)
               -- Отказы поставщиков
              , tmpSupplierFailures AS (SELECT DISTINCT 
                                               SupplierFailures.GoodsId
                                             , SupplierFailures.JuridicalId
                                             , SupplierFailures.ContractId
                                         FROM lpSelect_PriceList_SupplierFailures(vbUnitId, inUserId) AS SupplierFailures
                                        )
              , tmpMovementItemLastPriceList_View AS (SELECT LastMovement.MovementId
                                                           , LastMovement.JuridicalId
                                                           , LastMovement.ContractId
                                                           , MovementItem.Id                    AS MovementItemId
                                                           , COALESCE(MIFloat_Price.ValueData, MovementItem.Amount)::TFloat  AS Price
                                                           , MILinkObject_Goods.ObjectId        AS GoodsId
                                                           , ObjectString_GoodsCode.ValueData   AS GoodsCode
                                                           , Object_Goods.ValueData             AS GoodsName
                                                           , ObjectString_Goods_Maker.ValueData AS MakerName
                                                           , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
                                                           , LastMovement.AreaId                AS AreaId
                                                      FROM
                                                          (
                                                              SELECT 
                                                                  PriceList.JuridicalId
                                                                , PriceList.ContractId
                                                                , PriceList.AreaId
                                                                , PriceList.MovementId 
                                                              FROM 
                                                                  (
                                                                      SELECT 
                                                                          MAX (Movement.OperDate) 
                                                                          OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId 
                                                                                           , COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                                                                           , COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                                                               ) AS Max_Date
                                                                        , Movement.OperDate                                  AS OperDate
                                                                        , Movement.Id                                        AS MovementId
                                                                        , MovementLinkObject_Juridical.ObjectId              AS JuridicalId 
                                                                        , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                                                        , COALESCE (MovementLinkObject_Area.ObjectId, 0)     AS AreaId
                                                                      FROM 
                                                                          Movement
                                                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                                                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                                                                       ON MovementLinkObject_Area.MovementId = Movement.Id
                                                                                                      AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area() 
                                                                          INNER JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementLinkObject_Juridical.ObjectId 
                                                                                                     AND tmpJuridicalArea.AreaId      = COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                                                      WHERE 
                                                                          Movement.DescId = zc_Movement_PriceList()
                                                                      AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                                  ) AS PriceList
                                                              WHERE PriceList.Max_Date = PriceList.OperDate 
                                                          ) AS LastMovement
                                                          INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                                                                                 AND MovementItem.DescId = zc_MI_Master()
                                                                                 AND MovementItem.isErased = False
                                                          INNER JOIN MovementItemLinkObject AS MILinkObject_Goods -- товары в прайс-листе
                                                                                            ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                                                           AND MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                          INNER JOIN MovementItemOrder ON MovementItemOrder.GoodsId =  MILinkObject_Goods.ObjectId 

                                                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                                      ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                                          LEFT OUTER JOIN Object AS Object_Goods
                                                                                 ON Object_Goods.Id = MILinkObject_Goods.ObjectId
                                                          LEFT JOIN ObjectString AS ObjectString_GoodsCode 
                                                                                 ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
                                                                                AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
                                                          LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                                                                 ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                                                                                AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()  
                                                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                                     ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                                                    AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id                                                                     
                                                          LEFT JOIN tmpSupplierFailures AS SupplierFailures 
                                                                                        ON SupplierFailures.GoodsId = MILinkObject_Goods.ObjectId
                                                                                       AND SupplierFailures.JuridicalId = LastMovement.JuridicalId
                                                                                       AND SupplierFailures.ContractId = LastMovement.ContractId
                                                      )


       -- Результат
       SELECT row_number() OVER ()
            , ddd.Id AS MovementItemId 
            , ddd.PriceListMovementItemId
            , ddd.Price  
            , ddd.PartionGoodsDate
            , ddd.GoodsId
            , ddd.GoodsCode
            , ddd.GoodsName
            , ddd.MainGoodsName 
            , ddd.JuridicalId
            , ddd.JuridicalName 
            , ddd.MakerName
            , ddd.ContractId
            , ddd.ContractName
            , ddd.AreaId
            , ddd.AreaName
            , ddd.isDefault
            , ddd.Deferment
            , ddd.Bonus 
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN COALESCE (PriceSettings.Percent, 0)
                   ELSE 0
              END :: TFloat AS Percent
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
                   ELSE FinalPrice
              END :: TFloat AS SuperFinalPrice   

              -- цена  с учетом стоимости кредитных ресурсов
            , (FinalPrice - FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit) ) / 100) :: TFloat AS SuperFinalPrice_Deferment
/**/
       FROM 
             (SELECT DISTINCT MovementItemOrder.Id
                  , MovementItemLastPriceList_View.Price AS Price
                  , MovementItemLastPriceList_View.MovementItemId AS PriceListMovementItemId
                  , MovementItemLastPriceList_View.PartionGoodsDate
                  , MIN (MovementItemLastPriceList_View.Price) OVER (PARTITION BY MovementItemOrder.Id ORDER BY MovementItemLastPriceList_View.PartionGoodsDate DESC) AS MinPrice
                  , CASE
                      -- -- если Цена поставщика не попадает в ценовые промежутки (до какой цены учитывать бонус при расчете миним. цены)
                      WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                           THEN MovementItemLastPriceList_View.Price
                               -- И учитывается % бонуса из Маркетинговый контракт
                             * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                      ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                           (MovementItemLastPriceList_View.Price * (100 - COALESCE(tmpJuridicalSettingsItem.Bonus, 0)) / 100) :: TFloat
                            -- И учитывается % бонуса из Маркетинговый контракт
                          * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                    END AS FinalPrice
                  , CASE WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL 
                              THEN 0
                         ELSE COALESCE(tmpJuridicalSettingsItem.Bonus, 0)
                    END :: TFloat AS Bonus
        
                  , MovementItemLastPriceList_View.GoodsId         
                  , MovementItemLastPriceList_View.GoodsCode
                  , MovementItemLastPriceList_View.GoodsName
                  , MovementItemLastPriceList_View.MakerName 
                  , MainGoods.valuedata                       AS MainGoodsName
                  , Juridical.ID                              AS JuridicalId
                  , Juridical.ValueData                       AS JuridicalName
                  , Contract.Id                               AS ContractId
                  , Contract.ValueData                        AS ContractName
                  , COALESCE (ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
                  , COALESCE (GoodsPrice.isTOP, COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) AS isTOP
            
                  , tmpJuridicalArea.AreaId
                  , tmpJuridicalArea.AreaName
                  , COALESCE (tmpJuridicalArea.isDefault, FALSE)  :: Boolean AS isDefault
                  
               FROM MovementItemOrder 
                    LEFT OUTER JOIN tmpMovementItemLastPriceList_View AS MovementItemLastPriceList_View 
                                                                      ON MovementItemLastPriceList_View.GoodsId = MovementItemOrder.GoodsId
                    
                    JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                         AND tmpJuridicalArea.AreaId      = MovementItemLastPriceList_View.AreaId

                    INNER JOIN tmpLoadPriceList ON tmpLoadPriceList.JuridicalId = MovementItemLastPriceList_View.JuridicalId
                                               AND tmpLoadPriceList.ContractId  = MovementItemLastPriceList_View.ContractId
                                               AND (tmpLoadPriceList.AreaId = MovementItemLastPriceList_View.AreaId OR COALESCE (tmpLoadPriceList.AreaId, 0) = 0)


                    LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = MovementItemLastPriceList_View.JuridicalId 
                                               AND JuridicalSettings.ContractId  = MovementItemLastPriceList_View.ContractId
                    LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                                      AND MovementItemLastPriceList_View.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                                      AND MovementItemLastPriceList_View.Price <= tmpJuridicalSettingsItem.PriceLimit
                    
                    JOIN OBJECT AS Juridical ON Juridical.Id = MovementItemLastPriceList_View.JuridicalId
                 
                    LEFT JOIN OBJECT AS Contract ON Contract.Id = MovementItemLastPriceList_View.ContractId
                 
                    LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                          ON ObjectFloat_Deferment.ObjectId = Contract.Id
                                         AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
                    
                    LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = MovementItemOrder.GoodsMainId 
          
                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                            ON ObjectBoolean_Goods_TOP.ObjectId = MovementItemOrder.ObjectId
                                           AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
                    LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = MovementItemOrder.ObjectId
                                  
                    --   LEFT JOIN Object_Goods_View AS Goods  -- Элемент документа заявка
                    --     ON Goods.Id = MovementItemOrder.ObjectId
                 
                    -- % бонуса из Маркетинговый контракт
                    LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                        AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId
        
               WHERE  COALESCE(JuridicalSettings.isPriceCloseOrder, FALSE) <> TRUE 
       ) AS ddd
   
       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
       LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice    AND tmpCostCredit.PriceLimit
  ;
  
  ANALYSE _tmpMI;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpCreateTempTable_OrderInternal (Integer, Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.04.19         * SuperFinalPrice_Deferment
 07.02.19         * если isBonusClose = true бонусы не учитываем
 14.01.19         *
 19.10.18         * isPriceClose заменила на isPriceCloseOrder
 23.03.15                         *  
 17.02.15                         *  JuridicalSettings с бонусом и закрытием прайсов
 21.01.15                         *  учитываем наше юрлицо в закрытии прайсов
 05.12.14                         *  чуть оптимизировал
 06.11.14                         *  add PartionGoodsDate
 22.10.14                         *  add inGoodsId
 22.10.14                         *  add MakerName
 13.10.14                         *
 15.07.14                                                       *
 15.07.14                                                       *
 03.07.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
-- 
SELECT lpCreateTempTable_OrderInternal(inMovementId := 22460334, inObjectId := 4, inGoodsId := 0, inUserId := 3); SELECT * FROM _tmpMI;