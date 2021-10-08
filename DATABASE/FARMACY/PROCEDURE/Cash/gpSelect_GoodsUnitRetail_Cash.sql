 -- Function: gpSelect_GoodsUnitRetail_Cash()

DROP FUNCTION IF EXISTS gpSelect_GoodsUnitRetail_Cash (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsUnitRetail_Cash(
    IN inGoodsId             Integer,       -- Товар
    IN inMedicalProgramSPId  Integer ,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId       Integer
             , UnitCode     Integer
             , UnitName     TVarChar
             , Price         TFloat
             , Amount        TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());


    RETURN QUERY
    WITH   tmpMedicalProgramSPUnit AS (SELECT ObjectLink_MedicalProgramSP.ChildObjectId         AS MedicalProgramSPId
                                            , ObjectLink_Unit.ChildObjectId                     AS UnitId
                                       FROM Object AS Object_MedicalProgramSPLink
                                            INNER JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                                                  ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                                            INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                  ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                        WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
                                          AND Object_MedicalProgramSPLink.isErased = False),
           tmpMovement AS (SELECT Movement.Id
                                , Movement.OperDate
                                , MLO_MedicalProgramSP.ObjectId    AS MedicalProgramSPID
                           FROM Movement

                                INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                        ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                       AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                       AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                                INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                        ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                       AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                       AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                               INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                             ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                            AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()

                           WHERE Movement.DescId = zc_Movement_GoodsSP()
                             AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                             AND (COALESCE (MLO_MedicalProgramSP.ObjectId, 0) = inMedicalProgramSPId OR COALESCE(inMedicalProgramSPId, 0) = 0)
                          ),
           tmpMovementItem AS (SELECT MovementItem.Id
                                    , Movement.MedicalProgramSPID
                                    , Object_Goods_Retail.Id       AS GoodsId
                                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                               FROM tmpMovement AS Movement

                                   INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.MovementId = Movement.ID
                                                          AND MovementItem.isErased = FALSE
                                                          
                                   LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                                                                       AND Object_Goods_Retail.RetailId = vbRetailId
                               WHERE Object_Goods_Retail.Id = inGoodsId
                               ),
           tmpMovementItemGroup AS (SELECT DISTINCT tmpMovementItem.GoodsId
                                         , tmpMedicalProgramSPUnit.UnitId
                                    FROM tmpMovementItem
                                         INNER JOIN tmpMedicalProgramSPUnit ON tmpMedicalProgramSPUnit.MedicalProgramSPID = tmpMovementItem.MedicalProgramSPID
                                   ),
           tmpContainer AS (SELECT Container.ObjectId
                               , Container.WhereObjectId
                               , SUM(Container.Amount)                                           AS Amount
                          FROM Container

                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.Amount <> 0
                            AND Container.ObjectId = inGoodsId
                            AND Container.WhereObjectId IN (SELECT DISTINCT tmpMovementItemGroup.UnitId FROM tmpMovementItemGroup)
                          GROUP BY Container.ObjectId, Container.WhereObjectId
                          HAVING SUM(Container.Amount) > 0
                         ),
           tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                            THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                            ELSE ROUND (Price_Value.ValueData, 2)
                                       END :: TFloat                           AS Price
                                     , MCS_Value.ValueData                     AS MCSValue
                                     , Price_Goods.ChildObjectId               AS GoodsId
                                     , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                                FROM ObjectLink AS Price_Goods
                                   LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                                        ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                                                       AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                                         ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                   LEFT JOIN ObjectFloat AS MCS_Value
                                                         ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                                   -- Фикс цена для всей Сети
                                   LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                          ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                         AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                           ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                          AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                                WHERE Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                  AND Price_Goods.ChildObjectId = inGoodsId
                                )


        SELECT Container.ObjectId                                    AS GoodsId
             , Object_Unit.ObjectCode                     ::Integer  AS GoodsCode
             , Object_Unit.ValueData                                 AS GoodsName

             , COALESCE(tmpObject_Price.Price,0)::TFloat             AS Price
             , Container.Amount::TFloat                              AS Amount

        FROM tmpContainer AS Container

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Container.WhereObjectId

            LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = Container.WhereObjectId

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 21.10.20                                                      *
*/

--ТЕСТ
-- 
SELECT * FROM gpSelect_GoodsUnitRetail_Cash (inGoodsId := 1267403, inMedicalProgramSPId := 18078228, inSession:= '3')