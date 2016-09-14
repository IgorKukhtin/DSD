-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_ver2(
    IN inMovementId    Integer,    -- Текущая накладная
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, Reserved TFloat, MCSValue TFloat,
               AlternativeGroupId Integer, NDS TFloat,
               isFirst boolean, isSecond boolean, Color_calc Integer,
               isPromo boolean,
               MinExpirationDate TDateTime,
               Color_ExpirationDate Integer
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

    --Объявили новую сессию кассового места / обновили дату последнего обращения
    PERFORM lpInsertUpdate_CashSession(inCashSessionId := inCashSessionId,
                                       inDateConnect   := CURRENT_TIMESTAMP::TDateTime);
    --Очистили содержимое снапшета сессии
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;
                                        
    WITH GoodsRemains
    AS
    (
        SELECT 
            SUM(container.Amount) AS Remains, 
            container.objectid, 
            MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
        FROM container
          -- находим партию
          LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                        ON ContainerLinkObject_MovementItem.Containerid =  Container.Id
                                       AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
          -- элемент прихода
          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
          -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
          -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                     
          LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
        WHERE 
            container.descid = zc_container_count() 
            AND 
            Container. WhereObjectId = vbUnitId
            AND
            container.Amount<>0
        GROUP BY 
            container.objectid
    ),
    RESERVE
    AS
    (
        SELECT
            MovementItem_Reserve.GoodsId,
            SUM(MovementItem_Reserve.Amount)::TFloat as Amount
        FROM
            gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
        WHERE
            MovementItem_Reserve.MovementId <> inMovementId
        Group By
            MovementItem_Reserve.GoodsId
    )   

      

    --залили снапшот
    INSERT INTO CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved,MinExpirationDate)
    SELECT 
        inCashSessionId                             AS CashSession
       ,GoodsRemains.ObjectId                       AS GoodsId
       ,COALESCE(Object_Price_View.Price,0)         AS Price
       ,(GoodsRemains.Remains 
            - COALESCE(Reserve.Amount,0))::TFloat   AS Remains
       ,Object_Price_View.MCSValue                  AS MCSValue
       ,Reserve.Amount::TFloat                      AS Reserved
       ,GoodsRemains.MinExpirationDate              AS MinExpirationDate
      
    FROM
        GoodsRemains
        LEFT OUTER JOIN Object_Price_View ON GoodsRemains.ObjectId = Object_Price_View.GoodsId
                                         AND Object_Price_View.UnitId = vbUnitId
        LEFT OUTER JOIN RESERVE ON GoodsRemains.ObjectId = RESERVE.GoodsId;
            
    RETURN QUERY
      -- Маркетинговый контракт
    WITH  GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                         --   , tmp.ChangePercent
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                       )
        SELECT 
            Goods.Id,
            Goods.ValueData,
            Goods.ObjectCode,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.Price,
            NULLIF (CashSessionSnapShot.Reserved, 0) :: TFloat AS Reserved,
            CashSessionSnapShot.MCSValue,
            Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId,
            ObjectFloat_NDSKind_NDS.ValueData AS NDS,
            COALESCE(ObjectBoolean_First.ValueData, False)          AS isFirst,
            COALESCE(ObjectBoolean_Second.ValueData, False)         AS isSecond,
            CASE WHEN COALESCE(ObjectBoolean_Second.ValueData, False) = TRUE THEN 16440317 WHEN COALESCE(ObjectBoolean_First.ValueData, False) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc,
            CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo,
            CashSessionSnapShot.MinExpirationDate, 
            CASE WHEN CashSessionSnapShot.MinExpirationDate < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Blue() ELSE zc_Color_Black() END AS Color_ExpirationDate                --vbAVGDateEnd
 
         FROM
            CashSessionSnapShot
            JOIN OBJECT AS Goods ON Goods.Id = CashSessionSnapShot.ObjectId
            LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                       ON Goods.Id = Link_Goods_AlternativeGroup.ObjectId
                                      AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                       ON ObjectLink_Goods_NDSKind.ObjectId = Goods.Id
                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
            LEFT OUTER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 

            LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                    ON ObjectBoolean_First.ObjectId = Goods.Id
                                   AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                    ON ObjectBoolean_Second.ObjectId = Goods.Id
                                   AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()  

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Goods.Id  
         
        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
        ORDER BY
            Goods.Id;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_ver2 (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 06.09.16         *
 12.04.16         *
 02.11.15                                                                       *NDS
 10.09.15                                                                       *CashSessionSnapShot
 22.08.15                                                                       *разделение вип и отложеных
 19.08.15                                                                       *CurrentMovement
 05.05.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '308120')

--select * from gpSelect_CashRemains_ver2(inMovementId := 0 , inCashSessionId := '{1590AD6F-681A-4B34-992A-87AEABB4D33F}' ,  inSession := '3');