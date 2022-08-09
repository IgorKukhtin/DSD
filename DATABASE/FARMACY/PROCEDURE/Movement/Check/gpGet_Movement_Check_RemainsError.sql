-- Function: gpGet_Movement_Check_RemainsError()

--DROP FUNCTION IF EXISTS gpGet_Movement_Check_RemainsError (TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpGet_Movement_Check_RemainsError (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpGet_Movement_Check_RemainsError (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpGet_Movement_Check_RemainsError (Text, TVarChar);

DROP FUNCTION IF EXISTS gpGet_Movement_Check_RemainsError (Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_RemainsError(
    IN inSPKindId               Integer   , -- Сщц проект
    IN inJSON                   Text      , -- json     
   OUT outMessageText           Text      , -- вернули, если есть ошибка
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Text
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbIndex Integer;
   DECLARE vbPriceSamples TFloat;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);


    vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    vbUnitId  := CASE WHEN vbUnitKey = '' THEN '0' ELSE vbUnitKey END :: Integer;

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();
    
    IF inSPKindId = zc_Enum_SPKind_SP()
    THEN
      SELECT COALESCE(ObjectFloat_CashSettings_PriceSamples.ValueData, 0)                          AS PriceSamples
      INTO vbPriceSamples
      FROM Object AS Object_CashSettings

           LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceSamples
                                 ON ObjectFloat_CashSettings_PriceSamples.ObjectId = Object_CashSettings.Id 
                                AND ObjectFloat_CashSettings_PriceSamples.DescId = zc_ObjectFloat_CashSettings_PriceSamples()

      WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
      LIMIT 1;      
    ELSE
      vbPriceSamples := 0;
    END IF;

    -- таблица
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer
                               , Amount TFloat
                               , PartionDateKindId Integer
                               , NDSKindId Integer
                               , DivisionPartiesId Integer
                               , JuridicalId Integer) ON COMMIT DROP;

    INSERT INTO _tmpGoods
    SELECT *
    FROM json_populate_recordset(null::_tmpGoods, replace(replace(replace(inJSON, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);

    -- проверим что есть остатки
    outMessageText:= 'Ошибка.Товара'||CASE WHEN inSPKindId = zc_Enum_SPKind_SP() THEN ' для отпуска по СП' ELSE '' END||' нет в наличии:'||Chr(13)
                                || (WITH tmpFrom AS (SELECT _tmpGoods.GoodsId, _tmpGoods.NDSKindId, _tmpGoods.PartionDateKindId, _tmpGoods.DivisionPartiesId, SUM (_tmpGoods.Amount) AS Amount 
                                                     FROM _tmpGoods
                                                     GROUP BY _tmpGoods.GoodsId, _tmpGoods.NDSKindId, _tmpGoods.PartionDateKindId, _tmpGoods.DivisionPartiesId)
                                       , tmpFromJuridical AS (SELECT _tmpGoods.GoodsId, _tmpGoods.NDSKindId, _tmpGoods.PartionDateKindId, _tmpGoods.DivisionPartiesId, _tmpGoods.JuridicalId, SUM (_tmpGoods.Amount) AS Amount 
                                                              FROM _tmpGoods
                                                              WHERE COALESCE(_tmpGoods.JuridicalId, 0) <> 0
                                                              GROUP BY _tmpGoods.GoodsId, _tmpGoods.NDSKindId, _tmpGoods.PartionDateKindId, _tmpGoods.DivisionPartiesId, _tmpGoods.JuridicalId)
                                       , tmpContainerAll AS (SELECT tmpFrom.GoodsId, 
                                                                    Container.Id, 
                                                                    Container.Amount,
                                                                    COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)                      AS M_Income,
                                                                    COALESCE (MI_Income_find.Id,MI_Income.Id)                                      AS MI_Income
                                                              FROM (SELECT DISTINCT tmpFrom.GoodsId FROM tmpFrom) tmpFrom
                                                                   INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                                                       AND Container.WhereObjectId = vbUnitId
                                                                                       AND Container.ObjectId = tmpFrom.GoodsId
                                                                                       AND Container.Amount > 0

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
                                                              )
                                       , tmpContainer AS (SELECT Container.GoodsId, 
                                                                 Container.Id, 
                                                                 Container.Amount,
                                                                 CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                                                      THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId,
                                                                 ContainerLinkObject_DivisionParties.ObjectId                                   AS DivisionPartiesId,
                                                                 MovementLinkObject_From.ObjectId                                               AS JuridicalId,
                                                                 MIFloat_Price.ValueData                                                        AS Price
                                                           FROM tmpContainerAll AS Container
                                                           
                                                                LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.GoodsId
                                                                LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                                                                LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                                                ON MovementBoolean_UseNDSKind.MovementId = Container.M_Income
                                                                                               AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                                                LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                                             ON MovementLinkObject_NDSKind.MovementId = Container.M_Income
                                                                                            AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                                                                             
                                                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                                             ON MovementLinkObject_From.MovementId = Container.M_Income
                                                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                                                LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                                                              ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                                                             AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                                
                                                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                                            ON MIFloat_Price.MovementItemId =  Container.MI_Income
                                                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                                           
                                                                WHERE vbPriceSamples = 0 OR vbPriceSamples < COALESCE(MIFloat_Price.ValueData, vbPriceSamples + 0.01) 
                                                              )
                                       , tmpContainerPDAll AS  (SELECT Container.ParentId
                                                                     , Container.Amount
                                                                     , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                                                 COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                                                  THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                                                            ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                                                                FROM tmpContainer

                                                                     INNER JOIN Container ON Container.ParentId = tmpContainer.Id
                                                                                         AND Container.DescId  = zc_Container_CountPartionDate()
                                                                                         AND Container.Amount > 0

                                                                     LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                                                  AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                                                     LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                                                          ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                                                         AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                                                             ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                                                            AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                                                 )

                                       , tmpContainerPD AS (SELECT Container.ParentId
                                                                 , Container.PartionDateKindId
                                                                 , Sum(Container.Amount)          AS Amount
                                                            FROM tmpContainerPDAll AS Container
                                                            GROUP BY Container.ParentId
                                                                   , Container.PartionDateKindId
                                                             )
                                       , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                                             , ObjectFloat_NDSKind_NDS.ValueData
                                                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                                      )
                                       , tmpTo AS (SELECT tmpFrom.GoodsId, tmpFrom.NDSKindId, tmpFrom.PartionDateKindId, tmpFrom.DivisionPartiesId,  
                                                          SUM (COALESCE (tmpContainerPD.Amount, Container.Amount)) AS Amount
                                                   FROM tmpFrom

                                                        INNER JOIN tmpContainer AS Container
                                                                                ON Container.NDSKindId                      = tmpFrom.NDSKindId
                                                                               AND Container.GoodsId                        = tmpFrom.GoodsId
                                                                               AND COALESCE(Container.DivisionPartiesId, 0) = COALESCE(tmpFrom.DivisionPartiesId, 0)

                                                        LEFT OUTER JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.ID

                                                   WHERE COALESCE(tmpContainerPD.PartionDateKindId, 0) = COALESCE (tmpFrom.PartionDateKindId, 0)
                                                   GROUP BY tmpFrom.GoodsId
                                                          , tmpFrom.NDSKindId
                                                          , tmpFrom.PartionDateKindId
                                                          , tmpFrom.DivisionPartiesId
                                                  )
                                       , tmpToJuridical AS (SELECT tmpFrom.GoodsId, tmpFrom.NDSKindId, tmpFrom.PartionDateKindId, tmpFrom.DivisionPartiesId, tmpFrom.JuridicalId, 
                                                          SUM (COALESCE (tmpContainerPD.Amount, Container.Amount)) AS Amount
                                                   FROM tmpFromJuridical AS tmpFrom

                                                        INNER JOIN tmpContainer AS Container
                                                                                ON Container.NDSKindId                      = tmpFrom.NDSKindId
                                                                               AND Container.GoodsId                        = tmpFrom.GoodsId
                                                                               AND COALESCE(Container.DivisionPartiesId, 0) = COALESCE(tmpFrom.DivisionPartiesId, 0)
                                                                               AND COALESCE(Container.JuridicalId, 0)       = COALESCE(tmpFrom.JuridicalId, 0)

                                                        LEFT OUTER JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.ID

                                                   WHERE COALESCE(tmpContainerPD.PartionDateKindId, 0) = COALESCE (tmpFrom.PartionDateKindId, 0)
                                                   GROUP BY tmpFrom.GoodsId
                                                          , tmpFrom.NDSKindId
                                                          , tmpFrom.PartionDateKindId
                                                          , tmpFrom.DivisionPartiesId
                                                          , tmpFrom.JuridicalId
                                                  )
                                    SELECT STRING_AGG (tmp.Value, Chr(13))
                                    FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '')||
                                                     '; НДС ' || zfConvert_FloatToString(ObjectFloat_NDSKind_NDS.ValueData) ||
                                                     CASE WHEN COALESCE(Object_PartionDateKind.ID, 0) <> 0 THEN '; Тип срока : '||Object_PartionDateKind.ValueData  ELSE '' END ||
                                                     CASE WHEN COALESCE(Object_DivisionParties.ID, 0) <> 0 THEN '; Разделение партий : '||Object_DivisionParties.ValueData  ELSE '' END ||
                                                     ' в чеке : ' || zfConvert_FloatToString (AmountFrom) || COALESCE (Object_Measure.ValueData, '') ||
                                                     '; остаток: ' || zfConvert_FloatToString (AmountTo) || COALESCE (Object_Measure.ValueData, '') AS Value
                                          FROM (SELECT tmpFrom.GoodsId, tmpFrom.NDSKindId, tmpFrom.PartionDateKindId, tmpFrom.DivisionPartiesId, tmpFrom.Amount AS AmountFrom, COALESCE (tmpTo.Amount, 0) AS AmountTo
                                                FROM tmpFrom
                                                     LEFT JOIN tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId
                                                                    AND tmpTo.NDSKindId = tmpFrom.NDSKindId
                                                                    AND COALESCE(tmpTo.PartionDateKindId, 0) = COALESCE(tmpFrom.PartionDateKindId, 0)
                                                                    AND COALESCE(tmpTo.DivisionPartiesId, 0) = COALESCE(tmpFrom.DivisionPartiesId, 0)
                                                WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0)) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
                                               LEFT JOIN ObjectLink ON ObjectLink.ObjectId = tmp.GoodsId
                                                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                                               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                                               LEFT OUTER JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                          ON ObjectFloat_NDSKind_NDS.ObjectId = tmp.NDSKindId
                                               LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmp.PartionDateKindId
                                               LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = tmp.DivisionPartiesId
                                          UNION ALL 
                                          SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '')||
                                                     '; НДС ' || zfConvert_FloatToString(ObjectFloat_NDSKind_NDS.ValueData) ||
                                                     CASE WHEN COALESCE(Object_PartionDateKind.ID, 0) <> 0 THEN '; Тип срока : '||Object_PartionDateKind.ValueData  ELSE '' END ||
                                                     CASE WHEN COALESCE(Object_DivisionParties.ID, 0) <> 0 THEN '; Разделение партий : '||Object_DivisionParties.ValueData  ELSE '' END ||
                                                     CASE WHEN COALESCE(Object_Juridical.ID, 0) <> 0 THEN '; Поставщик : '||Object_Juridical.ValueData  ELSE '' END ||
                                                     ' в чеке : ' || zfConvert_FloatToString (AmountFrom) || COALESCE (Object_Measure.ValueData, '') ||
                                                     '; остаток: ' || zfConvert_FloatToString (AmountTo) || COALESCE (Object_Measure.ValueData, '') AS Value
                                          FROM (SELECT tmpFrom.GoodsId, tmpFrom.NDSKindId, tmpFrom.PartionDateKindId, tmpFrom.DivisionPartiesId, tmpFrom.JuridicalId, tmpFrom.Amount AS AmountFrom, COALESCE (tmpTo.Amount, 0) AS AmountTo
                                                FROM tmpFromJuridical AS tmpFrom
                                                     LEFT JOIN tmpToJuridical AS tmpTo 
                                                                     ON tmpTo.GoodsId = tmpFrom.GoodsId
                                                                    AND tmpTo.NDSKindId = tmpFrom.NDSKindId
                                                                    AND COALESCE(tmpTo.PartionDateKindId, 0) = COALESCE(tmpFrom.PartionDateKindId, 0)
                                                                    AND COALESCE(tmpTo.DivisionPartiesId, 0) = COALESCE(tmpFrom.DivisionPartiesId, 0)
                                                                    AND COALESCE(tmpTo.JuridicalId, 0)       = COALESCE(tmpFrom.JuridicalId, 0)
                                                WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0)) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
                                               LEFT JOIN ObjectLink ON ObjectLink.ObjectId = tmp.GoodsId
                                                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                                               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                                               LEFT OUTER JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                          ON ObjectFloat_NDSKind_NDS.ObjectId = tmp.NDSKindId
                                               LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmp.PartionDateKindId
                                               LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = tmp.DivisionPartiesId
                                               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmp.JuridicalId
                                         ) AS tmp
                                    );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.11.16                                        *
*/

-- тест

select * from gpGet_Movement_Check_RemainsError(inSPKindId := 4823010, inJSON := '[{"goodsid":15982622,"amount":1,"partiondatekindid":null,"ndskindid":9,"divisionpartiesid":null,"juridicalid":null}]' ,  inSession := '3');