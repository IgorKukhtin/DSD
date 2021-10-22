-- Function: gpSelect_Goods_LikiDnipro1303()

DROP FUNCTION IF EXISTS gpSelect_Goods_LikiDnipro1303 (Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Goods_LikiDnipro1303(
    IN inGoodsId          Integer    , --
    IN inAmount           TFloat     , --
    IN inPrice            TFloat     , --
    IN inPriceSale        TFloat     , --
    IN inSumm             TFloat     , --
    IN inBught_Int        Integer    , --
    IN inMorion           TVarChar   , --
    IN inqpack_int        TVarChar   , --
    IN inSession          TVarChar     --
)
RETURNS TABLE (Id Integer
             , MorionCode Integer
             , count Integer
             , retail_price_without_vat TFloat
             , retail_price_with_vat TFloat
             , price_without_vat TFloat
             , price_with_vat TFloat
             , amount_without_vat TFloat
             , amount_with_vat TFloat
             , drug_series  TVarChar
             , series_expiration_date TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbIndex Integer;
   DECLARE vbMorion Integer;   
   DECLARE vbQpack Integer;   
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    SELECT Object_Goods_Main.MorionCode
    INTO vbMorion
    FROM Object_Goods_Retail 
         INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainID
    WHERE Object_Goods_Retail.ID = inGoodsId;
    
    IF COALESCE (vbMorion, 0) = 0
    THEN
      RAISE EXCEPTION 'Не найден код мориона товара.';
    END IF;

    -- парсим коды мориона
    vbIndex := 1;
    WHILE SPLIT_PART (inMorion, ',', vbIndex) <> '' LOOP
        -- Сравниваем
        IF SPLIT_PART (inMorion, ',', vbIndex)::Integer = vbMorion
        THEN
          vbQpack := SPLIT_PART (inqpack_int, ',', vbIndex)::Integer;
          EXIT;
        END IF;
          
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;    
        
    IF COALESCE (vbQpack, 0) = 0
    THEN
      RAISE EXCEPTION 'Не найдено количество в упакоаке товара.';
    END IF;

    IF COALESCE (inBught_Int, 1) <> ROUND(inAmount * vbQpack::TFloat)
    THEN
      RAISE EXCEPTION 'Проверьте количество выписанного товара.%Выписано: %.%В чеке: %', CHR (13), inBught_Int, CHR (13), ROUND(inAmount * vbQpack::TFloat);
    END IF;

    -- RAISE EXCEPTION 'Получили: % % ', vbMorion, vbQpack;

    RETURN QUERY
    WITH
         tmpContainerGoods AS (SELECT Container.Id
                                    , Container.Amount AS Amount
                               FROM Container
                               WHERE Container.DescId = zc_Container_Count()
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.ObjectId = inGoodsId
                                 AND Container.Amount > 0
                                )
       , tmpContainerPD AS (SELECT Container.ParentId                                                  AS Id
                                 , MAX (COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate
                            FROM Container
                            
                                 LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                              
                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                              
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.WhereObjectId = vbUnitId
                              AND Container.ObjectId = inGoodsId
                              AND Container.Amount > 0
                            GROUP BY Container.ParentId 
                             )

       , tmpContainerAll AS (SELECT Container.Id                                                AS Id
                                  , Container.Amount                                            AS Amount
                                  , COALESCE (MI_Income_find.Id ,MI_Income.Id)                  AS MIIncomeId
                                  , COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)  AS MIncomeId
                             FROM tmpContainerGoods AS Container
                                   LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                 ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                   LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                   -- элемент прихода
                                   LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                   -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                               ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                   -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                   LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                        -- AND 1=0

                              )
       , tmpContainer AS (SELECT Container.Id
                               , Container.MIIncomeId
                               , Container.MIncomeId
                               , inAmount                AS SaleAmount
                               , Container.Amount        AS ContainerAmount
                               , SUM (Container.Amount) OVER (ORDER BY Movement_Income.OperDate, Container.Id) AS ContainerAmountSUM
                               , ROW_NUMBER() OVER (ORDER BY Movement_Income.OperDate DESC, Container.Id DESC) AS DOrd
                          FROM tmpContainerAll AS Container

                               LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = Container.MIncomeId
                          )
       , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                             , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                       )

    -- Результат
    SELECT Min(tmpItem.Id)                                                                                     AS ID
         , vbMorion                                                                                            AS MorionCode
         , ROUND(Sum(tmpItem.Amount) * vbQpack::TFloat)::Integer                                               AS count
         , Round(inPriceSale * 100 / (100 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)), 2)::TFloat       AS retail_price_without_vat
         , inPriceSale::TFloat                                                                                 AS retail_price_with_vat
         , Round(inPrice * 100 / (100 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)), 2)::TFloat           AS price_without_vat
         , inPrice::TFloat                                                                                     AS price_with_vat
         , Round((inSumm * ROUND(Sum(tmpItem.Amount) * vbQpack::TFloat)::Integer / inBught_Int) * 
                 100 / (100 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)), 2)::TFloat                     AS amount_without_vat
         , Round(inSumm * ROUND(Sum(tmpItem.Amount) * vbQpack::TFloat)::Integer / inBught_Int, 2) ::TFloat     AS amount_with_vat
         , COALESCE(MIString_PartionGoods.ValueData, '') ::TVarChar                                            AS drug_series
         , COALESCE (tmpContainerPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd())::TDateTime  AS series_expiration_date
       FROM (SELECT DD.Id
                  , DD.MIIncomeId
                  , DD.MIncomeId
                  , CASE WHEN DD.SaleAmount - DD.ContainerAmountSUM > 0 AND DD.DOrd <> 1
                              THEN DD.ContainerAmount
                         ELSE DD.SaleAmount - DD.ContainerAmountSUM + DD.ContainerAmount
                    END AS Amount
             FROM (SELECT * FROM tmpContainer) AS DD
             WHERE DD.SaleAmount - (DD.ContainerAmountSUM - DD.ContainerAmount) > 0
            ) AS tmpItem
            
            INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = inGoodsId 
            INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainID

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = tmpItem.MIIncomeId
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                       ON MIDate_ExpirationDate.MovementItemId = tmpItem.MIIncomeId
                                      AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                      
            LEFT JOIN tmpContainerPD ON tmpContainerPD.ID = tmpItem.Id 

            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                            ON MovementBoolean_UseNDSKind.MovementId = tmpItem.MIncomeId
                                           AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = tmpItem.MIncomeId
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                        
            LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                 ON ObjectFloat_NDSKind_NDS.ObjectId = CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                                                              OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                                                            THEN Object_Goods_Main.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END
       GROUP BY ObjectFloat_NDSKind_NDS.ValueData
              , MIString_PartionGoods.ValueData 
              , COALESCE (tmpContainerPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd())
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.10.21                                                       *
*/

-- тест
select * from gpSelect_Goods_LikiDnipro1303(inGoodsId := 42121 , inAmount := 1 , inPrice := 0 , inPriceSale := 122.5 , inSumm := 0 , inBught_Int := 30 , inMorion := '161433,303885' , inqpack_int := '30,60' ,  inSession := '3');