-- Function: gpSelect_Calculation_SAUA()

--DROP FUNCTION IF EXISTS gpSelect_Calculation_SAUA (TDateTime, TDateTime, Text, Text, TFloat, Integer, Integer, TFloat, boolean, boolean, boolean, boolean, boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Calculation_SAUA (TDateTime, TDateTime, Text, Text, TFloat, Integer, Integer, boolean, boolean, boolean, boolean, TFloat, TFloat, boolean, TFloat, TFloat, boolean, boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Calculation_SAUA (TDateTime, TDateTime, Text, Text, TFloat, Integer, Integer, boolean, boolean, boolean, boolean, TFloat, TFloat, boolean, TFloat, TFloat, boolean, boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_SAUA(
    IN inDateStart           TDateTime , -- Начало периода
    IN inDateEnd             TDateTime , -- Окончание периода
    IN inRecipientList       Text      , -- Аптеки получатели
    IN inAssortmentList      Text      , -- Аптеки ассортимента
    IN inThreshold           TFloat    , -- Порог минимальных продаж
    IN inDaysStock           Integer   , -- Дней запаса у получателя
    IN inCountPharmacies     Integer   , -- Мин. кол-во аптек ассортимента
--    IN inResolutionParameter TFloat    , -- Гранич. параметр разрешения
    IN inisGoodsClose        boolean   , -- Не показывать Закрыт код
    IN inisMCSIsClose        boolean   , -- Не показывать Убит код 
    IN inisNotCheckNoMCS     boolean   , -- Не показывать Продажи не для НТЗ

    IN inisMCSValue          boolean   , -- Учитывать товар с НТЗ
    IN inThresholdMCS        TFloat    , -- Порог минимального НТЗ
    IN inThresholdMCSLarge   TFloat    , -- Порог минимального НТЗ верхний

    IN inisRemains             boolean   , -- Остаток получателя
    IN inThresholdRemains      TFloat    , -- Порог остатка
    IN inThresholdRemainsLarge TFloat    , -- Порог остатка верхний

    IN inisAssortmentRound     boolean   , -- Ассортимент округлять по мат принципу
    IN inisNeedRound           boolean   , -- Потребность округлять по мат принципу
    IN inUnitFromId            Integer   , -- Аптека отдачи
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Remains TFloat
             , Assortment TFloat
             , Need TFloat
             , AmountCheck TFloat
             , AmountFrom TFloat
             , CountUnit Integer)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

    -- Аптеки получатели
    CREATE TEMP TABLE _tmpUnitRecipient ON COMMIT DROP AS
       (SELECT Object_Unit.Id          AS Id
             , Object_Unit.ObjectCode  AS Code
             , Object_Unit.ValueData   AS Name
        FROM Object AS Object_Unit

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) = 4
          AND ','||inRecipientList||',' LIKE '%,'||Object_Unit.Id::TEXT||',%'
        ORDER BY Object_Unit.Id);
		
	ANALYSE _tmpUnitRecipient;

    -- Аптеки ассортимента
    CREATE TEMP TABLE _tmpUnitAssortment ON COMMIT DROP AS
       (SELECT Object_Unit.Id          AS Id
             , Object_Unit.ObjectCode  AS Code
             , Object_Unit.ValueData   AS Name
        FROM Object AS Object_Unit

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) = 4
          AND ','||inAssortmentList||',' LIKE '%,'||Object_Unit.Id::TEXT||',%'
        ORDER BY Object_Unit.Id);
		
	ANALYSE _tmpUnitAssortment;

     -- Получили все продажи по аптекам ассортимента
    CREATE TEMP TABLE _tmpSale_Assortment ON COMMIT DROP AS
       (SELECT AnalysisContainerItem.GoodsId                          AS GoodsId
             , SUM(AnalysisContainerItem.AmountCheck)::TFloat         AS AmountCheck
             , COUNT(DISTINCT AnalysisContainerItem.UnitID)::Integer  AS CountUnit
             , CASE WHEN COALESCE (inisAssortmentRound, False) = True
                    THEN ROUND(SUM(AnalysisContainerItem.AmountCheck) / COUNT(DISTINCT AnalysisContainerItem.UnitID) / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock)
                    ELSE CEIL(SUM(AnalysisContainerItem.AmountCheck) / COUNT(DISTINCT AnalysisContainerItem.UnitID) / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock) END::TFloat         AS Assortment
        FROM AnalysisContainerItem AS AnalysisContainerItem
        WHERE AnalysisContainerItem.Operdate >= inDateStart
          AND AnalysisContainerItem.Operdate < inDateEnd + INTERVAL '1 DAY'
          AND AnalysisContainerItem.AmountCheck > 0
          AND AnalysisContainerItem.UnitID IN (SELECT DISTINCT _tmpUnitAssortment.Id FROM _tmpUnitAssortment)
        GROUP BY AnalysisContainerItem.GoodsId
        HAVING SUM(AnalysisContainerItem.AmountCheck) / COUNT(DISTINCT AnalysisContainerItem.UnitID) >= inThreshold
           AND COUNT(DISTINCT AnalysisContainerItem.UnitID) >= inCountPharmacies);
		   
	ANALYSE _tmpSale_Assortment;

     -- Вычитаем все продажи не для НТЗ
    IF inisNotCheckNoMCS = TRUE
    THEN

      raise notice 'Value 01: %', timeofday();
      CREATE TEMP TABLE _tmpSale_CheckNoMCS ON COMMIT DROP AS
           (WITH  tmpMovement AS (
                       SELECT *
                       FROM MovementBoolean AS MovementBoolean_NotMCS

                            INNER JOIN Movement ON Movement.ID = MovementBoolean_NotMCS.MovementId
                                               AND Movement.OperDate >= inDateStart
                                               AND Movement.OperDate < inDateEnd + INTERVAL '1 DAY'
                                               AND Movement.StatusId = zc_Enum_Status_Complete()

                       WHERE MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()
                         AND MovementBoolean_NotMCS.ValueData = TRUE),
                  tmpMovementUnit AS (
                       SELECT Movement.Id
                       FROM tmpMovement AS Movement

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                       WHERE MovementLinkObject_Unit.ObjectId IN (SELECT DISTINCT _tmpUnitAssortment.Id FROM _tmpUnitAssortment)

                       )

                      SELECT MovementItem.ObjectId      AS GoodsID
               , SUM(MovementItem.Amount)   AS Amount
          FROM MovementItem
          WHERE MovementItem.MovementID IN (SELECT Movement.ID FROM tmpMovementUnit AS Movement)
            AND MovementItem.isErased = False
            AND MovementItem.Amount > 0

          GROUP BY MovementItem.ObjectId );
		  
	  ANALYSE _tmpSale_CheckNoMCS;

      raise notice 'Value 02: %', timeofday();

      UPDATE _tmpSale_Assortment SET AmountCheck = _tmpSale_Assortment.AmountCheck - T1.Amount
                                   , Assortment = CASE WHEN COALESCE (inisAssortmentRound, False) = True
                                                       THEN ROUND((_tmpSale_Assortment.AmountCheck - T1.Amount) / _tmpSale_Assortment.CountUnit / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock)
                                                       ELSE CEIL((_tmpSale_Assortment.AmountCheck - T1.Amount) / _tmpSale_Assortment.CountUnit / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock) END::TFloat
      FROM (SELECT * FROM _tmpSale_CheckNoMCS) AS T1
      WHERE _tmpSale_Assortment.GoodsId = T1.GoodsId;

    END IF;

     -- Получили все остатки по аптекам
    CREATE TEMP TABLE _tmpRemains_All ON COMMIT DROP AS
       (SELECT Container.WhereObjectId          AS UnitId
             , Container.ObjectId               AS GoodsId
             , SUM(Container.Amount)::TFloat    AS Amount
        FROM Container
        WHERE Container.DescId = zc_Container_Count()
          AND Container.Amount <> 0
          AND Container.WhereObjectId in (SELECT DISTINCT _tmpUnitAssortment.Id FROM _tmpUnitAssortment
                                          UNION ALL
                                          SELECT DISTINCT _tmpUnitRecipient.Id FROM _tmpUnitRecipient)
        GROUP BY Container.WhereObjectId, Container.ObjectId
        HAVING SUM(Container.Amount) > 0);
		
	ANALYSE _tmpRemains_All;
        
    CREATE TEMP TABLE _tmpSendFrom (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

    IF COALESCE(inUnitFromId, 0) > 0
    THEN

      CREATE TEMP TABLE _tmpRemainsFrom ON COMMIT DROP AS
      (
        WITH
         tmpContainer AS
                       (SELECT Container.ObjectId
                             , Container.Id
                             , Container.Amount
                        FROM
                            Container
                        WHERE Container.DescId        = zc_Container_Count()
                          AND Container.WhereObjectId = inUnitFromId
                          AND Container.Amount        <> 0
                       )
       , tmpRemains AS (SELECT Container.ObjectId
                             , SUM (Container.Amount)  AS Amount
                        FROM tmpContainer AS Container
                        GROUP BY Container.ObjectId
                       )

       -- выбираем отложенные Чеки (как в кассе колонка VIP)
       , tmpMovementChek AS (SELECT Movement.Id
                             FROM MovementBoolean AS MovementBoolean_Deferred
                                  INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                     AND Movement.DescId = zc_Movement_Check()
                                                     AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                               AND MovementLinkObject_Unit.ObjectId = inUnitFromId
                             WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                               AND MovementBoolean_Deferred.ValueData = TRUE
                            UNION
                             SELECT Movement.Id
                             FROM MovementString AS MovementString_CommentError
                                  INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                     AND Movement.DescId = zc_Movement_Check()
                                                     AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                               AND MovementLinkObject_Unit.ObjectId = inUnitFromId
                            WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                              AND MovementString_CommentError.ValueData <> ''
                            )
           , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                             , SUM (MovementItem.Amount)::TFloat AS ReserveAmount
                        FROM tmpMovementChek
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                        GROUP BY MovementItem.ObjectId
                        )
           -- Отложенные технические переучеты
           , tmpMovementTP AS (SELECT MovementItemMaster.ObjectId      AS GoodsId
                                    , SUM(-MovementItemMaster.Amount)  AS Amount
                               FROM Movement AS Movement

                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                 AND MovementLinkObject_Unit.ObjectId = inUnitFromId
                                                                   
                                    INNER JOIN MovementItem AS MovementItemMaster
                                                            ON MovementItemMaster.MovementId = Movement.Id
                                                           AND MovementItemMaster.DescId     = zc_MI_Master()
                                                           AND MovementItemMaster.isErased   = FALSE
                                                           AND MovementItemMaster.Amount     < 0
                                                             
                                    INNER JOIN MovementItemBoolean AS MIBoolean_Deferred
                                                                   ON MIBoolean_Deferred.MovementItemId = MovementItemMaster.Id
                                                                  AND MIBoolean_Deferred.DescId         = zc_MIBoolean_Deferred()
                                                                  AND MIBoolean_Deferred.ValueData      = TRUE
                                                                   
                               WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                               GROUP BY MovementItemMaster.ObjectId)

          
          SELECT Remains.ObjectId                                                                                    AS GoodsId
               , Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0) - COALESCE (Reserve_TP.Amount, 0)::TFloat AS Remains
          FROM tmpRemains AS Remains

               LEFT OUTER JOIN tmpReserve AS Reserve_Goods ON Reserve_Goods.GoodsId = Remains.ObjectId
                             
               LEFT OUTER JOIN tmpMovementTP AS Reserve_TP ON Reserve_TP.GoodsId = Remains.ObjectId

           WHERE (Remains.Amount - COALESCE (Reserve_Goods.ReserveAmount, 0) - COALESCE (Reserve_TP.Amount, 0)) > 0);
		   
		  ANALYSE _tmpRemainsFrom;

      -- А сюда товары
      WITH
           tmpObject_Price AS (
                        SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , COALESCE (ObjectBoolean_Price_MCSIsClose.ValueData, False) AS MCSIsClose
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Price_MCSIsClose
                                                   ON ObjectBoolean_Price_MCSIsClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND ObjectBoolean_Price_MCSIsClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId IN (SELECT _tmpUnitRecipient.Id FROM _tmpUnitRecipient)
                        ),
      
          tmpNeed AS(SELECT _tmpUnitRecipient.Id         AS UnitId
                          , _tmpSale_Assortment.GoodsId                                                                      
                          , CASE WHEN COALESCE (inisNeedRound, False) = True
                                 THEN ROUND(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0))
                                 ELSE CEIL(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0)) END::TFloat  AS Amount
                     FROM _tmpUnitRecipient

                          LEFT JOIN _tmpSale_Assortment ON _tmpSale_Assortment.Assortment > 0

                          LEFT JOIN _tmpRemains_All ON _tmpRemains_All.UnitId = _tmpUnitRecipient.Id
                                                   AND _tmpRemains_All.GoodsId = _tmpSale_Assortment.GoodsId

                          LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = _tmpUnitRecipient.Id
                                                   AND tmpObject_Price.GoodsId = _tmpSale_Assortment.GoodsId

                          LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = _tmpSale_Assortment.GoodsId
                          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

                     WHERE CASE WHEN COALESCE (inisNeedRound, False) = True
                                THEN ROUND(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0))
                                ELSE CEIL(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0)) END > 0
                       AND (Object_Goods_Main.isClose = False OR inisGoodsClose = False)
                       AND (tmpObject_Price.MCSIsClose = False OR inisMCSIsClose = False)
                       AND (inisMCSValue = False AND COALESCE (tmpObject_Price.MCSValue , 0) = 0 
                         OR inisMCSValue = TRUE AND COALESCE (tmpObject_Price.MCSValue , 0) >= COALESCE (inThresholdMCS, 0) AND COALESCE (tmpObject_Price.MCSValue , 0) <= COALESCE (inThresholdMCSLarge, 0))
                       AND (inisRemains = False AND COALESCE (_tmpRemains_All.Amount, 0) = 0 
                         OR inisRemains = TRUE AND COALESCE (_tmpRemains_All.Amount, 0) >= COALESCE (inThresholdRemains, 0) AND COALESCE (_tmpRemains_All.Amount, 0) <= COALESCE (inThresholdRemainsLarge, 0))
                  ),
          DD AS  (  -- строки документа продажи размазанные по текущему остатку(Контейнерам) на подразделении
                      SELECT
                          tmpNeed.UnitId
                        , tmpNeed.GoodsId
                        , tmpNeed.Amount
                        , Container.Remains AS ContainerAmount
                        , SUM(tmpNeed.Amount) OVER (PARTITION BY Container.GoodsId ORDER BY tmpNeed.Amount DESC, tmpNeed.UnitId)
                      FROM _tmpRemainsFrom AS Container

                          JOIN tmpNeed ON tmpNeed.GoodsId = Container.GoodsId
                  ),

          tmpItem AS ( -- контейнеры и кол-во(Сумма), которое с них будет списано (с подразделения)
                          SELECT
                              DD.UnitId
                            , DD.GoodsId
                            , CASE
                                WHEN DD.Amount < (DD.ContainerAmount - DD.SUM + DD.Amount) THEN DD.Amount
                                ELSE floor(DD.ContainerAmount - DD.SUM + DD.Amount)
                              END AS Amount
                          FROM DD
                          WHERE floor(DD.ContainerAmount - DD.SUM + DD.Amount) > 0
                      )

      INSERT INTO _tmpSendFrom(UnitId, GoodsId, Amount)
      SELECT --контейнеры по количество
          tmpItem.UnitId
        , tmpItem.GoodsId
        , tmpItem.Amount
      FROM tmpItem
      ;

      ANALYSE _tmpSendFrom;
	  
    END IF;

    RETURN QUERY
    WITH tmpObject_Price AS (
                        SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , COALESCE (ObjectBoolean_Price_MCSIsClose.ValueData, False) AS MCSIsClose
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Price_MCSIsClose
                                                   ON ObjectBoolean_Price_MCSIsClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND ObjectBoolean_Price_MCSIsClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId IN (SELECT _tmpUnitRecipient.Id FROM _tmpUnitRecipient)
                        )



    SELECT _tmpUnitRecipient.*
         , Object_Goods_Retail.Id
         , Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name
         , _tmpRemains_All.Amount
         , _tmpSale_Assortment.Assortment
         , CASE WHEN COALESCE (inisNeedRound, False) = True
                THEN ROUND(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0))
                ELSE CEIL(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0)) END::TFloat
         , _tmpSale_Assortment.AmountCheck
         , _tmpSendFrom.Amount  AS AmountFrom
         , _tmpSale_Assortment.CountUnit
    FROM _tmpUnitRecipient

         LEFT JOIN _tmpSale_Assortment ON _tmpSale_Assortment.Assortment > 0

         LEFT JOIN _tmpRemains_All ON _tmpRemains_All.UnitId = _tmpUnitRecipient.Id
                                  AND _tmpRemains_All.GoodsId = _tmpSale_Assortment.GoodsId

         LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = _tmpUnitRecipient.Id
                                  AND tmpObject_Price.GoodsId = _tmpSale_Assortment.GoodsId

         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = _tmpSale_Assortment.GoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
         
         LEFT JOIN _tmpSendFrom ON _tmpSendFrom.UnitId = _tmpUnitRecipient.Id
                               AND _tmpSendFrom.GoodsId = _tmpSale_Assortment.GoodsId

    WHERE CASE WHEN COALESCE (inisNeedRound, False) = True
               THEN ROUND(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0))
               ELSE CEIL(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0)) END > 0
     -- AND (COALESCE(_tmpRemains_All.Amount, 0) < inResolutionParameter OR inResolutionParameter = 0)
      AND (Object_Goods_Main.isClose = False OR inisGoodsClose = False)
      AND (tmpObject_Price.MCSIsClose = False OR inisMCSIsClose = False)
      AND (inisMCSValue = False AND COALESCE (tmpObject_Price.MCSValue , 0) = 0 
        OR inisMCSValue = TRUE AND COALESCE (tmpObject_Price.MCSValue , 0) >= COALESCE (inThresholdMCS, 0) AND COALESCE (tmpObject_Price.MCSValue , 0) <= COALESCE (inThresholdMCSLarge, 0))
      AND (inisRemains = False AND COALESCE (_tmpRemains_All.Amount, 0) = 0 
        OR inisRemains = TRUE AND COALESCE (_tmpRemains_All.Amount, 0) >= COALESCE (inThresholdRemains, 0) AND COALESCE (_tmpRemains_All.Amount, 0) <= COALESCE (inThresholdRemainsLarge, 0))

    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.11.20                                                       *
*/

-- 
select * from gpSelect_Calculation_SAUA(inDateStart := ('18.11.2021')::TDateTime , inDateEnd := ('18.01.2022')::TDateTime , inRecipientList := '394426,11769526' , inAssortmentList := '494882,10779386,8393158' , inThreshold := 1 , inDaysStock := 7 , inCountPharmacies := 3 , inisGoodsClose := 'False' , inisMCSIsClose := 'True' , inisNotCheckNoMCS := 'True' , inisMCSValue := 'False' , inThresholdMCS := 0 , inThresholdMCSLarge := 0 , inisRemains := 'False' , inThresholdRemains := 0 , inThresholdRemainsLarge := 0 , inisAssortmentRound := 'False' , inisNeedRound := 'False' , inUnitFromId := 7117700 , inSession := '3');