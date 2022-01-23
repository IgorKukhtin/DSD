-- Function: gpReport_RemainsOverGoods()

DROP FUNCTION IF EXISTS gpReport_RemainsOverGoods (Integer, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_RemainsOverGoods (Integer, TDateTime, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_RemainsOverGoods (Integer, TDateTime, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_RemainsOverGoods (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_RemainsOverGoods (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_RemainsOverGoods (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RemainsOverGoods(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата остатка
    IN inPeriod           TFloat,     -- Кол-во дней для анализа НТЗ
    IN inDay              TFloat,     -- Страховой запас НТЗ для Х дней
    IN inDayIncome        TFloat,     -- Учитывать товар в затоварку, пришедший до X дней
    IN inAssortment       TFloat,     -- кол-во для ассортимента
    IN inSummSend         TFloat,     -- мин cумма товара для пермещения
    IN inisMCS            Boolean,    -- для аптеки-отправителя изпользовать НТЗ из справочника
    IN inisInMCS          Boolean,    -- для аптек-получателей изпользовать НТЗ из справочника
    IN inisRecal          Boolean,    -- Да / нет - "Временно исправлются ошибки с датами в ценах"
    IN inisAssortment     Boolean,    -- оставить кол-во для ассортимента Да / нет
    IN inIsReserve        Boolean  ,  -- Не учитывать отложенный товар (Да/Нет)
    IN inIsIncome         Boolean  ,  -- Не учитывать товар, пришедший за последние Х дней
    IN inIsSummSend       Boolean  ,  -- Учитывать товар в затоварку, пришедший до X дней Да/Нет
    IN inisMCS_0          Boolean  ,  -- Получать товар с НТЗ 0
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS  SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE Cursor3 refcursor;
   DECLARE Cursor4 refcursor;

   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbMovementItemChildId Integer;
   
   DECLARE vbIncomeDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- замена
    inStartDate := DATE_TRUNC ('DAY', inStartDate);

    -- определяем дату прихода после которой не учитываем товар для перемещения (Учитывать товар в затоварку)
    vbIncomeDate := inStartDate - (''||inDayIncome|| ' day') ::Interval;
    
    -- !!!только НЕ так определяется <Торговая сеть>!!!
    -- vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    -- !!!только так - определяется <Торговая сеть>!!!
    vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 );


    -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    -- !!!Временно исправлются ошибки с датами в ценах!!!
    -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    IF inisRecal = TRUE  -- inSession <> '3'
    THEN
    UPDATE  ObjectHistory set EndDate = coalesce (tmp.StartDate, zc_DateEnd())
    FROM (with tmp as (select ObjectHistory_Price.*
                            , Row_Number() OVER (PARTITION BY ObjectHistory_Price.ObjectId ORDER BY ObjectHistory_Price.StartDate Asc, ObjectHistory_Price.Id) AS Ord
                       from ObjectHistory AS ObjectHistory_Price
                       -- Where ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                      )
          select  tmp.Id, tmp.ObjectId, tmp.EndDate,  tmp2.StartDate, tmp2.Ord, ObjectHistoryDesc.Code
          from tmp
               left join tmp as tmp2 ON tmp2.ObjectId = tmp.ObjectId and tmp2.Ord = tmp.Ord + 1 and tmp2.DescId = tmp.DescId
               left join ObjectHistoryDesc ON ObjectHistoryDesc. Id = tmp.DescId
          where tmp.EndDate <> coalesce (tmp2.StartDate, zc_DateEnd())
          order by 3
         ) as tmp
    WHERE tmp.Id = ObjectHistory.Id;
    END IF;
    -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


    -- Таблицы
    CREATE TEMP TABLE tmpGoods_list (GoodsMainId Integer, GoodsId Integer, UnitId Integer, PriceId Integer, MCSValue TFloat, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;
    CREATE TEMP TABLE tmpRemains_1 (GoodsId Integer, UnitId Integer, RemainsStart TFloat, Amount_In TFloat, ContainerId Integer, PRIMARY KEY (UnitId, GoodsId,ContainerId)) ON COMMIT DROP;
    CREATE TEMP TABLE tmpRemains (GoodsId Integer, UnitId Integer, RemainsStart TFloat, RemainsStart_save TFloat, Amount_Reserve TFloat, Amount_In TFloat, MinExpirationDate TDateTime, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;
    CREATE TEMP TABLE tmpMCS (GoodsId Integer, UnitId Integer, MCSValue TFloat, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;
    CREATE TEMP TABLE tmpMIMaster (GoodsId Integer, Amount TFloat, Summa TFloat, InvNumber TVarChar, MovementId Integer, MIMaster_Id Integer, PRIMARY KEY (MovementId, MIMaster_Id, GoodsId)) ON COMMIT DROP;
    CREATE TEMP TABLE tmpMIChild (UnitId Integer, GoodsMainId Integer, GoodsId Integer, Amount TFloat, Summa TFloat, MIChild_Id Integer, PRIMARY KEY (MIChild_Id, UnitId,GoodsId)) ON COMMIT DROP;
    CREATE TEMP TABLE tmpUnit_list (UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpSend (GoodsId Integer, UnitId Integer, Amount TFloat) ON COMMIT DROP;      
    CREATE TEMP TABLE tmpPrice (PriceId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, MCSNotRecalc Boolean) ON COMMIT DROP;

    -- Таблица - Результат
    CREATE TEMP TABLE tmpData (GoodsMainId Integer, GoodsId Integer, UnitId Integer, MCSValue TFloat
                             , Price TFloat, StartDate TDateTime, EndDate TDateTime, MinExpirationDate TDateTime
                             , RemainsStart TFloat, SummaRemainsStart TFloat
                             , RemainsMCS_from TFloat, SummaRemainsMCS_from TFloat
                             , RemainsMCS_to TFloat, SummaRemainsMCS_to TFloat
                             , AmountSend TFloat, Amount_Reserve TFloat, Amount_In Tfloat
                             , PRIMARY KEY (UnitId, GoodsId)
                              ) ON COMMIT DROP;
    -- Таблица - Результат
    CREATE TEMP TABLE tmpDataTo (GoodsId Integer, GoodsMainId Integer, UnitId Integer, RemainsMCS_result TFloat, RemainsMCS_result_inf TFloat, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;


      -- ищем ИД документа Распределений остатков (ключ - дата, Подразделение) 
      vbMovementId:= (SELECT Movement.Id  
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.ID
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND MovementLinkObject_Unit.ObjectId = inUnitId
                      WHERE Movement.OperDate = inStartDate
                        AND Movement.DescId = zc_Movement_Over()
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     );


      -- Ищем cтроки мастера (ключ - ид документа, товар)
      INSERT INTO tmpMIMaster (GoodsId, Amount, Summa, InvNumber, MovementId, MIMaster_Id)
         SELECT  MovementItem.ObjectId             AS GoodsId
               , MovementItem.Amount               AS Amount
               , (MovementItem.Amount * COALESCE(MIFloat_Price.ValueData,0)) :: TFloat AS Summa
               , Movement.InvNumber
               , Movement.Id                       AS MovementId
               , MovementItem.Id                   AS MIMaster_Id
         FROM MovementItem 
              LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
         WHERE MovementItem.MovementId = vbMovementId 
           AND MovementItem.DescId = zc_MI_Master()
           AND MovementItem.isErased = FALSE;

      -- Ищем cтроки чайлда (ключ - ид документа, товар)
      INSERT INTO tmpMIChild (UnitId, GoodsMainId,  GoodsId, Amount, Summa, MIChild_Id)
      SELECT  MovementItem.ObjectId             AS UnitId
            , ObjectLink_Main.ChildObjectId     AS GoodsMainId
            , MI_Master.ObjectId                AS GoodsId
            , MovementItem.Amount               AS Amount
            , (MovementItem.Amount * COALESCE(MIFloat_Price.ValueData,0)) :: TFloat AS Summa
            , MovementItem.Id                   AS MIChild_Id
      FROM MovementItem 
           LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id = MovementItem.ParentId
           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
           -- получаем GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                 ON ObjectLink_Child.ChildObjectId = MI_Master.ObjectId
                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
      WHERE MovementItem.MovementId = vbMovementId 
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.isErased = FALSE;
------------------------------------------------
       -- определяем подразделения для распределения
       INSERT INTO tmpUnit_list (UnitId)
                           SELECT inUnitId  AS UnitId
                          UNION
                           SELECT ObjectBoolean_Over.ObjectId  AS UnitId
                           FROM ObjectBoolean AS ObjectBoolean_Over
                                /*
                                   INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                         ON ObjectLink_Unit_Juridical.ObjectId = ObjectBoolean_Over.ObjectId --Container.WhereObjectId
                                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                   INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                        AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                                */
                           WHERE ObjectBoolean_Over.DescId = zc_ObjectBoolean_Unit_Over()
                             AND ObjectBoolean_Over.ValueData = TRUE;
                             
                           
       -- Remains
       INSERT INTO tmpRemains_1 (GoodsId, UnitId, RemainsStart, Amount_In, ContainerId)
                   WITH
                   tmpContainer AS (SELECT Container.Objectid      AS GoodsId
                                         , Container.WhereObjectId AS UnitId
                                         , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                         , Container.Id  AS ContainerId
                                    FROM tmpUnit_list
                                         INNER JOIN Container ON Container.WhereObjectId = tmpUnit_list.UnitId
                                                             AND Container.DescId = zc_Container_Count()
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId = Container.Id
                                                                        AND MIContainer.OperDate >= inStartDate
                                    GROUP BY Container.Id, Container.Objectid, Container.WhereObjectId, Container.Amount
                                    HAVING  Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                    )
                  , tmp_In AS (SELECT tmpContainer.GoodsId
                                           , tmpContainer.UnitId
                                           , SUM (tmpContainer.RemainsStart) AS RemainsStart
                                           , SUM (CASE WHEN vbIncomeDate <= Movement_Income.OperDate THEN tmpContainer.RemainsStart ELSE 0 END) AS Amount_In
                                           , tmpContainer.ContainerId
                                      FROM tmpContainer
                                           -- находим партию
                                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                  ON ContainerLinkObject_MovementItem.Containerid = tmpContainer.ContainerId
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

                                           LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) 
                                      WHERE tmpContainer.UnitId = inUnitId
                                      GROUP BY tmpContainer.ContainerId, tmpContainer.GoodsId, tmpContainer.UnitId
                                      )
                   SELECT tmpContainer.GoodsId
                        , tmpContainer.UnitId
                        , SUM (tmpContainer.RemainsStart)     AS RemainsStart
                        , SUM (COALESCE(tmp_In.Amount_In,0))  AS Amount_In
                        , tmpContainer.ContainerId
                   FROM tmpContainer
                        LEFT JOIN tmp_In ON tmp_In.ContainerId = tmpContainer.ContainerId
                                        AND tmp_In.GoodsId = tmpContainer.GoodsId
                                        AND tmp_In.UnitId  = tmpContainer.UnitId
                   GROUP BY tmpContainer.ContainerId, tmpContainer.GoodsId, tmpContainer.UnitId
                   ;

         -- автоперемещения приход / расход
         INSERT INTO tmpSend  (GoodsId, UnitId, Amount) 
                        SELECT MI_Send.ObjectId                 AS GoodsId
                             , MovementLinkObject_Unit.ObjectId AS UnitId
                             , SUM (CASE WHEN Movement_Send.StatusId = zc_Enum_Status_UnComplete() OR Movement_Send.OperDate >= inStartDate
                                         THEN
                                             CASE WHEN MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From() AND MovementLinkObject_Unit.ObjectId = inUnitId
                                                  THEN -1 * MI_Send.Amount
                                                  WHEN MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To() AND MovementLinkObject_Unit.ObjectId <> inUnitId
                                                  THEN  1 * MI_Send.Amount
                                                  ELSE 0
                                             END
                                         ELSE 0
                                    END)                 ::TFloat  AS Amount--_From
                             --, SUM (CASE WHEN MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To() THEN (MI_Send.Amount) ELSE 0 END) ::TFloat    AS Amount_To

                        FROM Movement AS Movement_Send
                               INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                          ON MovementBoolean_isAuto.MovementId = Movement_Send.Id
                                                         AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                                         AND MovementBoolean_isAuto.ValueData = TRUE
                                                     
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Send.Id
                                                           AND MovementLinkObject_Unit.DescId in (zc_MovementLinkObject_To(), zc_MovementLinkObject_From())
                               INNER JOIN tmpUnit_list ON tmpUnit_list.UnitId = MovementLinkObject_Unit.ObjectId
                               
                               LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                         ON MovementBoolean_Deferred.MovementId = Movement_Send.Id
                                                        AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                        AND MovementLinkObject_Unit.ObjectId = inUnitId 
                                                        
                               INNER JOIN MovementItem AS MI_Send
                                                       ON MI_Send.MovementId = Movement_Send.Id
                                                      AND MI_Send.DescId = zc_MI_Master()
                                                      AND MI_Send.isErased = FALSE
                        WHERE Movement_Send.OperDate >= inStartDate - INTERVAL '30 DAY' AND Movement_Send.OperDate < inStartDate + INTERVAL '7 DAY'   -- 22,05,2020 Люба
                           -- Movement_Send.OperDate >= inStartDate - INTERVAL '1 DAY' AND Movement_Send.OperDate < inStartDate + INTERVAL '1 DAY'
                          AND Movement_Send.DescId = zc_Movement_Send()
                          AND Movement_Send.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                          AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                        GROUP BY MI_Send.ObjectId 
                               , MovementLinkObject_Unit.ObjectId 
                        HAVING SUM (MI_Send.Amount) <> 0 
                       ;

       -- остатки
       INSERT INTO tmpRemains (GoodsId, UnitId, RemainsStart, RemainsStart_save, Amount_Reserve, Amount_In, MinExpirationDate)                              
                         WITH tmp AS
                        (SELECT tmp.GoodsId
                              , tmp.UnitId
                              , SUM (tmp.RemainsStart) AS RemainsStart
                              , SUM (tmp.Amount_In)    AS Amount_In
                              , Null    ::TDateTime AS MinExpirationDate -- Срок годности
                          FROM tmpRemains_1 AS tmp 
                          --переносим при сохранении документа "излишки" - делать расчет Срока годности
                          GROUP BY tmp.GoodsId, tmp.UnitId
                          HAVING  SUM (tmp.RemainsStart) <> 0
                         )
                -- выбираем отложенные Чеки (как в кассе колонка VIP)
                , tmpMovementReserv AS (SELECT Movement.Id
                                             , MovementLinkObject_Unit.ObjectId AS UnitId
                                        FROM MovementBoolean AS MovementBoolean_Deferred
                                             INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                                AND Movement.DescId = zc_Movement_Check()
                                                                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                             --ограничиваем подразделениями
                                             INNER JOIN tmpUnit_list ON tmpUnit_list.UnitId = MovementLinkObject_Unit.ObjectId
                                        WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                          AND MovementBoolean_Deferred.ValueData = TRUE
                                       UNION
                                        SELECT Movement.Id
                                             , MovementLinkObject_Unit.ObjectId AS UnitId
                                        FROM MovementString AS MovementString_CommentError
                                             INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                                AND Movement.DescId = zc_Movement_Check()
                                                                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                             --ограничиваем подразделениями
                                             INNER JOIN tmpUnit_list ON tmpUnit_list.UnitId = MovementLinkObject_Unit.ObjectId
                                       WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                         AND MovementString_CommentError.ValueData <> ''
                                       )
                , tmpReserve AS (SELECT tmpMovementReserv.UnitId          AS UnitId
                                      , MovementItem.ObjectId             AS GoodsId
                                      , SUM (MovementItem.Amount)::TFloat AS Amount
                                 FROM tmpMovementReserv
                                      INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementReserv.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                 GROUP BY MovementItem.ObjectId
                                        , tmpMovementReserv.UnitId
                                 )

                         -- Результат        --
                         
                         SELECT tmp.GoodsId
                              , tmp.UnitId
                              --, tmp.RemainsStart + COALESCE (tmpSend.Amount, 0) AS RemainsStart
                              , tmp.RemainsStart + COALESCE (tmpSend.Amount, 0)
                              -- если признак оставить для ассортимента Да, тогда снимаем с остатка это кол-во 
                              - CASE WHEN inisAssortment = TRUE AND tmp.UnitId = inUnitId
                                          THEN inAssortment
                                     ELSE 0
                                END  
                              -- если признак Учитывать товар в затоварку Да, тогда снимаем с остатка это кол-во  (приходы за Х дней)
                              - CASE WHEN inIsIncome = TRUE AND tmp.UnitId = inUnitId
                                          THEN COALESCE (tmp.Amount_In, 0)
                                     ELSE 0
                                END
                              -- Если признак Не учитывать отл.товар Да, то снимаем с остатка это кол-во
                              - CASE WHEN inIsReserve = TRUE AND tmp.UnitId = inUnitId                              --- для подр. с которого переносим
                                          THEN COALESCE (tmpReserve.Amount, 0)
                                     ELSE 0
                                END                      AS RemainsStart
                              , tmp.RemainsStart         AS RemainsStart_save
                              , COALESCE (tmpReserve.Amount, 0) AS Amount_Reserve
                              , COALESCE (tmp.Amount_In, 0)     AS Amount_In
                              , tmp.MinExpirationDate
                         FROM tmp
                              LEFT JOIN tmpSend ON tmpSend.GoodsId = tmp.GoodsId AND tmpSend.UnitId = tmp.UnitId AND tmpSend.UnitId <> inUnitId
                              LEFT JOIN tmpReserve ON tmpReserve.GoodsId = tmp.GoodsId AND tmpReserve.UnitId = tmp.UnitId
                        UNION
                         SELECT tmpSend.GoodsId
                              , tmpSend.UnitId
                              , COALESCE (tmpSend.Amount, 0)
                              - CASE WHEN inisAssortment = TRUE AND tmpSend.UnitId = inUnitId
                                     THEN inAssortment 
                                     ELSE 0
                                END                          AS RemainsStart
                              , 0                            AS RemainsStart_save
                              , 0                            AS Amount_Reserve
                              , 0                            AS Amount_In
                              , NULL                         AS MinExpirationDate
                         FROM tmpSend
                              LEFT JOIN tmp ON tmp.GoodsId = tmpSend.GoodsId AND tmp.UnitId = tmpSend.UnitId
                         WHERE tmpSend.UnitId <> inUnitId
                           AND tmp.GoodsId IS NULL
                        ;

       -- MCS
       IF (inisMCS = FALSE AND inisInMCS = FALSE) OR (inisMCS = TRUE AND inisInMCS = FALSE)
          THEN 
              INSERT INTO tmpMCS (GoodsId, UnitId, MCSValue)
                   WITH 
                   tmp AS (SELECT tmp.GoodsId
                                , tmp.UnitId
                                , tmp.MCSValue
                           FROM gpSelect_RecalcMCS (-1 * inUnitId, 0, inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp
                           WHERE tmp.MCSValue > 0
                           )
                   SELECT tmp.GoodsId
                        , tmp.UnitId
                        , tmp.MCSValue
                   FROM tmpUnit_list
                        JOIN tmp ON tmp.UnitId = tmpUnit_list.UnitId;
       ELSEIF inisMCS = FALSE AND inisInMCS = TRUE
          THEN 
              INSERT INTO tmpMCS (GoodsId, UnitId, MCSValue)
                   SELECT tmp.GoodsId
                        , tmp.UnitId
                        , tmp.MCSValue
                   FROM gpSelect_RecalcMCS (inUnitId, 0, inPeriod::Integer, inDay::Integer, inStartDate, inSession) AS tmp
                   WHERE tmp.MCSValue > 0;
       END IF;
       
       -- tmpPrice
       INSERT INTO tmpPrice (PriceId, UnitId, GoodsId, MCSValue, MCSNotRecalc)   
                    SELECT ObjectLink_Price_Unit.ObjectId           AS PriceId
                         , ObjectLink_Price_Unit.ChildObjectId      AS UnitId
                         , Price_Goods.ChildObjectId                AS GoodsId
                         , COALESCE(MCS_Value.ValueData,0) ::Tfloat AS MCSValue 
                         , COALESCE(MCS_NotRecalc.ValueData, False) :: Boolean AS MCSNotRecalc       -- для товаров, на которых стоит спецконтроль (по подразделению с которого перемещаем), будем брать НТЗ из справочника всегда
                    FROM tmpUnit_list
                       LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                            ON ObjectLink_Price_Unit.ChildObjectId = tmpUnit_list.UnitId
                                           AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()  
                       LEFT JOIN ObjectLink AS Price_Goods
                                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       LEFT JOIN ObjectFloat AS MCS_Value
                                             ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                            AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                       LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                               ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc();

       -- Goods_list
       INSERT INTO tmpGoods_list (GoodsMainId, GoodsId, UnitId, PriceId, MCSValue)
               SELECT DISTINCT
                      ObjectLink_Main.ChildObjectId AS GoodsMainId
                    , tmp.GoodsId
                    , tmp.UnitId
                    , tmp.PriceId
                    , tmp.MCSValue 
               FROM (
                     SELECT tmpRemains.GoodsId, tmpRemains.UnitId, 0 AS PriceId, 0 :: TFloat AS MCSValue 
                     FROM tmpRemains
                    UNION 
                     SELECT tmpPrice.GoodsId, tmpPrice.UnitId, 0 AS PriceId, 0 :: TFloat AS MCSValue 
                     FROM tmpPrice
                     WHERE tmpPrice.MCSValue <> 0 AND inisInMCS = TRUE
                    UNION
                     SELECT tmpMCS.GoodsId, tmpMCS.UnitId, 0 AS PriceId, 0 :: TFloat AS MCSValue 
                     FROM tmpMCS
                     WHERE inisInMCS = FALSE
                    ) AS tmp
                    -- получаем GoodsMainId
                  LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                        ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                       AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                  LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                        ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                       AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain();


       -- Goods_list - PriceId
       UPDATE tmpGoods_list SET PriceId = tmpPrice.PriceId
       FROM tmpPrice
       WHERE tmpPrice.GoodsId = tmpGoods_list.GoodsId
         AND tmpPrice.UnitId = tmpGoods_list.UnitId;

         
       -- Goods_list - MCSValue
       UPDATE tmpGoods_list
              SET MCSValue = CASE WHEN (inisMCS = TRUE AND tmpGoods_list.UnitId = inUnitId) OR (tmpPrice.MCSNotRecalc = TRUE AND tmpGoods_list.UnitId = inUnitId) THEN COALESCE (tmpPrice.MCSValue, 0)
                                  WHEN (inisInMCS = TRUE AND tmpGoods_list.UnitId <> inUnitId) THEN COALESCE (tmpPrice.MCSValue, 0)
                                  ELSE COALESCE (tmpMCS.MCSValue, 0)
                             END
       FROM tmpGoods_list AS tmp
           LEFT JOIN tmpPrice ON tmpPrice.PriceId = tmp.PriceId
                             AND tmpPrice.UnitId  = tmp.UnitId
                             AND tmpPrice.GoodsId = tmp.GoodsId
           LEFT JOIN tmpMCS ON tmpMCS.UnitId = tmp.UnitId
                           AND tmpMCS.GoodsId = tmp.GoodsId
       WHERE tmp.PriceId = tmpGoods_list.PriceId
         AND tmp.UnitId  = tmpGoods_list.UnitId
         AND tmp.GoodsId = tmpGoods_list.GoodsId;

            
        -- Result
        INSERT INTO tmpData  (GoodsMainId, GoodsId, UnitId, MCSValue 
                            , Price, StartDate, EndDate, MinExpirationDate
                            , RemainsStart, SummaRemainsStart
                            , RemainsMCS_from, SummaRemainsMCS_from
                            , RemainsMCS_to, SummaRemainsMCS_to
                            , AmountSend, Amount_Reserve, Amount_In
                             )
         WITH 
          tmpOverSettings AS (SELECT *
                              FROM gpSelect_Object_OverSettings (inSession) AS tmp
                              WHERE tmp.isErased = FALSE AND tmp.MinPrice <> tmp.MinPriceEnd
                              ),
          tmpMCD_0 AS (SELECT tmpGoods_list.GoodsMainId
                            , count(*)                      AS CountMCD_0
                       FROM tmpGoods_list 
                            LEFT JOIN tmpRemains AS Object_Remains
                                                 ON Object_Remains.GoodsId = tmpGoods_list.GoodsId
                                                AND Object_Remains.UnitId  = tmpGoods_list.UnitId
                       WHERE tmpGoods_list.UnitId <> inUnitId
                         AND COALESCE(tmpGoods_list.MCSValue, 0) = 0
                         AND COALESCE(Object_Remains.RemainsStart, 0) = 0
                       GROUP BY tmpGoods_list.GoodsMainId)

             -- Результат
             SELECT
                 tmpGoods_list.GoodsMainId
               , tmpGoods_list.GoodsId
               , tmpGoods_list.UnitId
               , tmpGoods_list.MCSValue

               , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)  AS Price
               , COALESCE (ObjectHistory_Price.StartDate, NULL)    AS StartDate
               , COALESCE (ObjectHistory_Price.EndDate, NULL)      AS EndDate
               , Object_Remains.MinExpirationDate

               , Object_Remains.RemainsStart_save                       AS RemainsStart
               , (Object_Remains.RemainsStart_save * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) AS SummaRemainsStart
               
                 -- Излишки
               , CASE WHEN ObjectBoolean_Goods_Close.ValueData = TRUE
                           THEN 0
                      WHEN inisMCS_0 = TRUE AND tmpGoods_list.UnitId = inUnitId
                           THEN Object_Remains.RemainsStart
                      WHEN Object_Remains.RemainsStart > tmpGoods_list.MCSValue AND tmpGoods_list.MCSValue >= 0
                           THEN FLOOR ((Object_Remains.RemainsStart - tmpGoods_list.MCSValue) / COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1)))
                                --*** ((Object_Remains.RemainsStart - tmpGoods_list.MCSValue) / COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1)))
                              * COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1))
                      ELSE 0
                 END AS RemainsMCS_from
               , CASE WHEN ObjectBoolean_Goods_Close.ValueData = TRUE
                           THEN 0
                      WHEN inisMCS_0 = TRUE AND tmpGoods_list.UnitId = inUnitId
                           THEN Object_Remains.RemainsStart
                      WHEN Object_Remains.RemainsStart > tmpGoods_list.MCSValue AND tmpGoods_list.MCSValue >= 0
                          THEN FLOOR ((Object_Remains.RemainsStart - tmpGoods_list.MCSValue) / COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1)))
                               --*** ((Object_Remains.RemainsStart - tmpGoods_list.MCSValue) / COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1)))
                             * COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1))
                             * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)
                      ELSE 0
                 END AS RemainsMCS_from

                 -- Не хватает
               , CASE WHEN ObjectBoolean_Goods_Close.ValueData = TRUE OR inisMCS_0 = TRUE AND tmpGoods_list.UnitId <> inUnitId AND 
                           (COALESCE(tmpGoods_list.MCSValue, 0) <> 0 OR COALESCE(Object_Remains.RemainsStart, 0) <> 0 OR 
                           COALESCE(Object_Remains.Amount_Reserve, 0) <> 0  OR COALESCE(Object_Remains.Amount_In, 0) <> 0)
                           THEN 0
                      WHEN inisMCS_0 = TRUE AND tmpGoods_list.UnitId <> inUnitId AND
                           COALESCE(tmpGoods_list.MCSValue, 0) = 0 AND COALESCE(Object_Remains.RemainsStart, 0) = 0 AND 
                           COALESCE(Object_Remains.Amount_Reserve, 0) = 0 AND COALESCE(Object_Remains.Amount_In, 0) = 0
                           THEN ceil(Object_RemainsFrom.RemainsStart / COALESCE (tmpMCD_0.CountMCD_0, 1))
                      WHEN COALESCE (Object_Remains.RemainsStart, 0) < tmpGoods_list.MCSValue AND tmpGoods_list.MCSValue > 0
                           THEN CEIL ((tmpGoods_list.MCSValue - COALESCE (Object_Remains.RemainsStart, 0)) / COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1)))
                                --***((tmpGoods_list.MCSValue - COALESCE (Object_Remains.RemainsStart, 0)) / COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1)))
                              * COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1))
                      ELSE 0
                 END AS RemainsMCS_to
               , CASE WHEN ObjectBoolean_Goods_Close.ValueData = TRUE OR inisMCS_0 = TRUE AND tmpGoods_list.UnitId <> inUnitId AND 
                           (COALESCE(tmpGoods_list.MCSValue, 0) <> 0 OR COALESCE(Object_Remains.RemainsStart, 0) <> 0 OR 
                           COALESCE(Object_Remains.Amount_Reserve, 0) <> 0  OR COALESCE(Object_Remains.Amount_In, 0) <> 0)
                           THEN 0
                      WHEN inisMCS_0 = TRUE AND tmpGoods_list.UnitId <> inUnitId AND
                           COALESCE(tmpGoods_list.MCSValue, 0) = 0 AND COALESCE(Object_Remains.RemainsStart, 0) = 0 AND 
                           COALESCE(Object_Remains.Amount_Reserve, 0) = 0 AND COALESCE(Object_Remains.Amount_In, 0) = 0
                           THEN ceil(Object_RemainsFrom.RemainsStart / COALESCE (tmpMCD_0.CountMCD_0, 1))
                      WHEN COALESCE (Object_Remains.RemainsStart, 0) < tmpGoods_list.MCSValue AND tmpGoods_list.MCSValue > 0
                           THEN CEIL ((tmpGoods_list.MCSValue - COALESCE (Object_Remains.RemainsStart, 0)) / COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1)))
                                --***((tmpGoods_list.MCSValue - COALESCE (Object_Remains.RemainsStart, 0)) / COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1)))
                              * COALESCE (tmpOverSettings.MinimumLot, COALESCE (tmpOverSettings_all.MinimumLot, 1))
                              * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)
                      ELSE 0
                 END AS RemainsMCS_to

               , Object_Send.Amount                          AS AmountSend
               , COALESCE (Object_Remains.Amount_Reserve, 0) AS Amount_Reserve
               , COALESCE (Object_Remains.Amount_In, 0)      AS Amount_In
--               , Object_Send.Amount_To     AS AmountSend_To

            FROM tmpGoods_list
                LEFT JOIN tmpRemains AS Object_Remains
                                     ON Object_Remains.GoodsId = tmpGoods_list.GoodsId
                                    AND Object_Remains.UnitId  = tmpGoods_list.UnitId
                LEFT JOIN tmpRemains AS Object_RemainsFrom
                                     ON Object_RemainsFrom.GoodsId = tmpGoods_list.GoodsId
                                    AND Object_RemainsFrom.UnitId  = inUnitId
                LEFT JOIN tmpSend AS Object_Send
                                  ON Object_Send.GoodsId = tmpGoods_list.GoodsId
                                 AND Object_Send.UnitId  = tmpGoods_list.UnitId
                                 
                LEFT JOIN tmpMCD_0 ON tmpMCD_0.GoodsMainId = tmpGoods_list.GoodsMainId

                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                        ON ObjectBoolean_Goods_Close.ObjectId = tmpGoods_list.GoodsId
                                       AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close() 

                -- получаем значения цены и НТЗ из истории значений на начало дня                                                          
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = tmpGoods_list.PriceId
                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                       AND inStartDate >= ObjectHistory_Price.StartDate AND inStartDate < ObjectHistory_Price.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                             ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()

                LEFT JOIN tmpOverSettings ON tmpOverSettings.UnitId = tmpGoods_list.UnitId
                                         AND COALESCE (ObjectHistoryFloat_Price.ValueData, 0) >= tmpOverSettings.MinPrice
                                         AND COALESCE (ObjectHistoryFloat_Price.ValueData, 0) < tmpOverSettings.MinPriceEnd
                LEFT JOIN tmpOverSettings AS tmpOverSettings_all
                                          ON tmpOverSettings_all.UnitId = 0
                                         AND COALESCE (ObjectHistoryFloat_Price.ValueData, 0) >= tmpOverSettings_all.MinPrice
                                         AND COALESCE (ObjectHistoryFloat_Price.ValueData, 0) < tmpOverSettings_all.MinPriceEnd
                                         AND tmpOverSettings.UnitId IS NULL
            ;
       

     -- !!!ResultTO!!!
  WITH tmpDataFrom AS (SELECT GoodsMainId, GoodsId, RemainsMCS_from -- количество "излишков" в одной аптеке
                       FROM tmpData
                       WHERE UnitId = inUnitId AND RemainsMCS_from > 0
                      )
       , tmpDataTo AS (SELECT UnitId, GoodsMainId, GoodsId, RemainsMCS_to -- количество "не хватает" в остальных аптеках
                       FROM tmpData
                       WHERE UnitId <> inUnitId AND RemainsMCS_to > 0
                      )
      , tmpDataAll AS (SELECT tmpDataTo.UnitId
                            , tmpDataTo.GoodsMainId
                            , tmpDataTo.GoodsId
                            , tmpDataTo.RemainsMCS_to
                            , tmpDataFrom.RemainsMCS_from
                              -- "накопительная" сумма "не хватает" = все предыдущие + текущая запись , !!!обязательно сортировка аналогичная с № п/п!!!
                            , SUM (tmpDataTo.RemainsMCS_to) OVER (PARTITION BY tmpDataTo.GoodsMainId ORDER BY tmpDataTo.RemainsMCS_to DESC, tmpDataTo.UnitId DESC) AS RemainsMCS_period
                              -- № п/п, начинаем с максимального количества "не хватает"
                            , ROW_NUMBER() OVER (PARTITION BY tmpDataTo.GoodsMainId ORDER BY tmpDataTo.RemainsMCS_to DESC, tmpDataTo.UnitId DESC) AS Ord
                       FROM tmpDataFrom
                            INNER JOIN tmpDataTo ON tmpDataTo.GoodsMainId = tmpDataFrom.GoodsMainId
                      )

   INSERT INTO tmpDataTo (GoodsId, GoodsMainId, UnitId, RemainsMCS_result, RemainsMCS_result_inf)
   WITH 
     tmpTo AS (SELECT tmpDataAll.GoodsId
                    , tmpDataAll.GoodsMainId
                    , tmpDataAll.UnitId
                    , CASE -- для первого - учитывается ТОЛЬКО "не хватает"
                           WHEN Ord = 1 THEN CASE WHEN RemainsMCS_to <= RemainsMCS_from THEN RemainsMCS_to ELSE RemainsMCS_from END
                           -- для остальных - учитывается "накопительная" сумма "не хватает" !!!минус!!! то что в текущей записи
                           WHEN RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to) > 0 -- сколько осталось "излишков" если всем предыдущим уже распределили
                                THEN CASE -- если "не хватает" меньше сколько осталось "излишков"
                                          WHEN RemainsMCS_to <= RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                                               THEN RemainsMCS_to
                                          ELSE -- иначе остаток "излишков"
                                               RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                                     END
                           ELSE 0
                      END AS RemainsMCS_result
               FROM tmpDataAll
               WHERE  CASE -- для первого - учитывается ТОЛЬКО "не хватает"
                           WHEN Ord = 1 THEN CASE WHEN RemainsMCS_to <= RemainsMCS_from THEN RemainsMCS_to ELSE RemainsMCS_from END
                           -- для остальных - учитывается "накопительная" сумма "не хватает" !!!минус!!! то что в текущей записи
                           WHEN RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to) > 0 -- сколько осталось "излишков" если всем предыдущим уже распределили
                                THEN CASE -- если "не хватает" меньше сколько осталось "излишков"
                                          WHEN RemainsMCS_to <= RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                                               THEN RemainsMCS_to
                                          ELSE -- иначе остаток "излишков"
                                               RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                                     END
                           ELSE 0
                      END <> 0
               )
         SELECT tmpTo.GoodsId
              , tmpTo.GoodsMainId
              , tmpTo.UnitId
              
              , CASE WHEN (inIsSummSend = TRUE AND (tmpTo.RemainsMCS_result * tmpData.Price) >= inSummSend) OR inIsSummSend = FALSE
                     THEN tmpTo.RemainsMCS_result 
                     ELSE 0
                END           :: TFloat AS RemainsMCS_result
              , tmpTo.RemainsMCS_result AS RemainsMCS_result_inf
         FROM tmpTo
              LEFT JOIN tmpData ON tmpData.GoodsId = tmpTo.GoodsId 
                               AND tmpData.UnitId  = tmpTo.UnitId
         ;


--  RAISE EXCEPTION '<%>  <%>  <%>  <%>', (select Count (*) from tmpGoods_list), (select Count (*) from tmpDataTo), (select Count (*) from tmpData where UnitId = inUnitId), (select Count (*) from tmpData where UnitId <> inUnitId);


     OPEN Cursor1 FOR
     
     WITH tmpChild AS (SELECT  tmpData.GoodsMainId  -- tmpData.GoodsId,
                            , SUM (tmpData.RemainsMCS_from) AS RemainsMCS_from, SUM (tmpData.SummaRemainsMCS_from) AS SummaRemainsMCS_from
                            , SUM (tmpData.RemainsMCS_to)   AS RemainsMCS_to,   SUM (tmpData.SummaRemainsMCS_to)   AS SummaRemainsMCS_to
                            , SUM (tmpData.MCSValue)                 AS MCSValue
                            , SUM (tmpData.MCSValue * tmpData.Price) AS SummaMCSValue
                       FROM tmpData
                       WHERE tmpData.UnitId <> inUnitId
                       GROUP BY tmpData.GoodsMainId  --tmpData.GoodsId, 
                      )
      , tmpChildTo AS (SELECT tmpDataTo.GoodsMainId   --tmpDataTo.GoodsId, 
                            , SUM (tmpDataTo.RemainsMCS_result)     AS RemainsMCS_result
                            , SUM (tmpDataTo.RemainsMCS_result_inf) AS RemainsMCS_result_inf
                       FROM tmpDataTo
                       GROUP BY tmpDataTo.GoodsMainId  -- tmpDataTo.GoodsId,
                      )
          SELECT tmpData.StartDate
               , tmpData.EndDate
               , tmpData.Price

               , tmpData.MCSValue
               , (tmpData.MCSValue * tmpData.Price) :: TFloat AS SummaMCSValue

               , tmpData.RemainsStart
               , tmpData.SummaRemainsStart
               , tmpData.RemainsMCS_from
               , tmpData.SummaRemainsMCS_from
               , tmpData.RemainsMCS_to
               , tmpData.SummaRemainsMCS_to

               , tmpChild.MCSValue             :: TFloat  AS MCSValue_Child
               , tmpChild.SummaMCSValue        :: TFloat  AS SummaMCSValue_Child
               , tmpChild.RemainsMCS_from      :: TFloat  AS RemainsMCS_from_Child
               , tmpChild.SummaRemainsMCS_from :: TFloat  AS SummaRemainsMCS_from_Child
               , tmpChild.RemainsMCS_to        :: TFloat  AS RemainsMCS_to_Child
               , tmpChild.SummaRemainsMCS_to   :: TFloat  AS SummaRemainsMCS_to_Child
               
               , tmpChildTo.RemainsMCS_result                   :: TFloat AS RemainsMCS_result
               , (tmpChildTo.RemainsMCS_result * tmpData.Price) :: TFloat AS SummaRemainsMCS_result

               , tmpChildTo.RemainsMCS_result_inf                 :: TFloat AS RemainsMCS_result_inf
               , tmpChildTo.RemainsMCS_result_inf * tmpData.Price :: TFloat AS SummaRemainsMCS_result_inf

               , tmpData.AmountSend            :: TFloat  AS AmountSend
               , tmpData.Amount_Reserve        :: TFloat  AS Amount_Reserve
               , tmpData.Amount_In             :: TFloat  AS Amount_In
 
               , tmpData.GoodsId
               , tmpData.GoodsMainId

               , Object_Goods.ObjectCode                      AS GoodsCode
               , Object_Goods.ValueData                       AS GoodsName
               , Object_Goods.isErased                        AS isErased
               , Object_Measure.ValueData                     AS MeasureName
               , tmpData.MinExpirationDate

               , tmpMIMaster.InvNumber                        AS InvNumber_Over
               , tmpMIMaster.MovementId                       AS MovementId_Over
               , tmpMIMaster.MIMaster_Id                      AS MIMaster_Id_Over
               , COALESCE (tmpMIMaster.Amount, 0) :: TFloat   AS Amount_Over
               , COALESCE (tmpMIMaster.Summa, 0)  :: TFloat   AS Summa_Over
               , (COALESCE (tmpChildTo.RemainsMCS_result, 0) - COALESCE (tmpMIMaster.Amount, 0)) :: TFloat AS Amount_OverDiff
               
               , CASE WHEN COALESCE (tmpMIMaster.Amount, 0) > tmpData.RemainsStart THEN TRUE ELSE FALSE END ::Boolean AS isError
               
               , FALSE :: Boolean AS isChoice
             
     FROM tmpData
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId     

                LEFT JOIN tmpChild ON tmpChild.GoodsMainId = tmpData.GoodsMainId
                LEFT JOIN tmpChildTo ON tmpChildTo.GoodsMainId = tmpData.GoodsMainId

                LEFT JOIN tmpMIMaster ON tmpMIMaster.GoodsId = tmpData.GoodsId
     WHERE tmpData.UnitId = inUnitId;

     RETURN NEXT Cursor1;


    -- Результат 2

     OPEN Cursor2 FOR

       SELECT    Object_Unit.Id        AS UnitId
               , Object_Unit.ValueDAta AS UnitName 
               , tmpData.GoodsId
               , tmpData.GoodsMainId
               , Object_Goods.ObjectCode AS GoodsCode
               , tmpData.MCSValue
               , (tmpData.MCSValue * tmpData.Price) :: TFloat AS SummaMCSValue

               , tmpData.StartDate
               , tmpData.EndDate
               , tmpData.Price
               , tmpDataFrom.Price  :: TFloat  AS PriceFrom 

               , tmpData.RemainsStart
               , tmpData.SummaRemainsStart
               , tmpData.RemainsMCS_from
               , tmpData.SummaRemainsMCS_from
               , tmpData.RemainsMCS_to
               , tmpData.SummaRemainsMCS_to

               , tmpDataTo.RemainsMCS_result
               , (tmpDataTo.RemainsMCS_result * tmpData.Price) :: TFloat AS SummaRemainsMCS_result

               , tmpDataTo.RemainsMCS_result_inf                 :: TFloat AS RemainsMCS_result_inf
               , tmpDataTo.RemainsMCS_result_inf * tmpData.Price :: TFloat AS SummaRemainsMCS_result_inf

               , tmpData.MinExpirationDate

               , tmpMIChild.MIChild_Id                      AS MIChild_Id_Over
               , COALESCE (tmpMIChild.Amount, 0) :: TFloat  AS Amount_Over
               , COALESCE (tmpMIChild.Summa, 0)  :: TFloat  AS Summa_Over
               , (COALESCE (tmpDataTo.RemainsMCS_result, 0) - COALESCE (tmpMIChild.Amount, 0)) :: TFloat AS Amount_OverDiff
               , tmpData.AmountSend            :: TFloat    AS AmountSend
               , tmpData.Amount_Reserve        :: TFloat    AS Amount_Reserve
     FROM tmpData
          LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id = tmpData.UnitId
          LEFT JOIN Object AS Object_Goods  ON Object_Goods.Id = tmpData.GoodsId
          LEFT JOIN tmpDataTo ON tmpDataTo.GoodsId = tmpData.GoodsId AND tmpDataTo.UnitId = tmpData.UnitId
          LEFT JOIN tmpData AS tmpDataFrom ON tmpDataFrom.GoodsId = tmpData.GoodsId AND tmpDataFrom.UnitId = inUnitId

          LEFT JOIN tmpMIChild ON tmpMIChild.GoodsMainId = tmpData.GoodsMainId
                              AND tmpMIChild.UnitId = tmpData.UnitId
     WHERE tmpData.UnitId <> inUnitId
       AND tmpDataTo.RemainsMCS_result_inf > 0
    ;
     
     RETURN NEXT Cursor2;

     -- Результат 3
     -- !!!дублируем Cursor2!!!
     OPEN Cursor3 FOR
       SELECT    Object_Unit.Id        AS UnitId
               , Object_Unit.ValueDAta AS UnitName 
               , tmpData.GoodsId
               , tmpData.GoodsMainId
               , Object_Goods.ObjectCode AS GoodsCode
               , tmpData.MCSValue
               , (tmpData.MCSValue * tmpData.Price) :: TFloat AS SummaMCSValue

               , tmpData.StartDate
               , tmpData.EndDate
               , tmpData.Price
               , tmpDataFrom.Price  :: TFloat  AS PriceFrom 

               , tmpData.RemainsStart
               , tmpData.SummaRemainsStart
               , tmpData.RemainsMCS_from
               , tmpData.SummaRemainsMCS_from
               , tmpData.RemainsMCS_to
               , tmpData.SummaRemainsMCS_to

               , tmpDataTo.RemainsMCS_result
               , (tmpDataTo.RemainsMCS_result * tmpData.Price) :: TFloat AS SummaRemainsMCS_result
               , tmpData.MinExpirationDate
                  
     FROM tmpData
          LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = tmpData.UnitId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
          
          LEFT JOIN tmpDataTo ON tmpDataTo.GoodsId = tmpData.GoodsId 
                             AND tmpDataTo.UnitId  = tmpData.UnitId
                             
          LEFT JOIN tmpData AS tmpDataFrom ON tmpDataFrom.GoodsId = tmpData.GoodsId
                                          AND tmpDataFrom.UnitId  = inUnitId
     WHERE tmpData.UnitId <> inUnitId
       AND tmpDataTo.RemainsMCS_result > 0
       -- AND (tmpDataTo.RemainsMCS_result > 0 OR tmpDataFrom.RemainsMCS_to > 0)
       -- AND 1=0
       -- LIMIT 50000
    ;
     RETURN NEXT Cursor3;
     -- Результат 4 итоги
     -- !!!дублируем Cursor2!!!
     OPEN Cursor4 FOR
     SELECT      Object_Unit.Id                                   AS UnitId
               , Object_Unit.ValueDAta                            AS UnitName 
               , SUM(tmpData.MCSValue)                 :: TFloat  AS MCSValue
               , SUM(tmpData.MCSValue * tmpData.Price) :: TFloat  AS SummaMCSValue

               , SUM(tmpData.RemainsStart)             :: TFloat  AS RemainsStart
               , SUM(tmpData.SummaRemainsStart)        :: TFloat  AS SummaRemainsStart
               , SUM(tmpData.RemainsMCS_from)          :: TFloat  AS RemainsMCS_from
               , SUM(tmpData.SummaRemainsMCS_from)     :: TFloat  AS SummaRemainsMCS_from
               , SUM(tmpData.RemainsMCS_to)            :: TFloat  AS RemainsMCS_to
               , SUM(tmpData.SummaRemainsMCS_to)       :: TFloat  AS SummaRemainsMCS_to

               , SUM(tmpDataTo.RemainsMCS_result )                :: TFloat AS RemainsMCS_result
               , SUM(tmpDataTo.RemainsMCS_result * tmpData.Price) :: TFloat AS SummaRemainsMCS_result

               , SUM(tmpDataTo.RemainsMCS_result_inf )                :: TFloat AS RemainsMCS_result_inf
               , SUM(tmpDataTo.RemainsMCS_result_inf * tmpData.Price) :: TFloat AS SummaRemainsMCS_result_inf

               , SUM(COALESCE (tmpMIChild.Amount, 0))  :: TFloat  AS Amount_Over
               , SUM(COALESCE (tmpMIChild.Summa, 0))   :: TFloat  AS Summa_Over
               , SUM(COALESCE (tmpDataTo.RemainsMCS_result, 0) - COALESCE (tmpMIChild.Amount, 0)) :: TFloat AS Amount_OverDiff

               , (CASE WHEN SUM(COALESCE(tmpData.SummaRemainsStart,0)) <>0 THEN (SUM(tmpData.SummaRemainsMCS_to) * 100 / SUM(tmpData.SummaRemainsStart)) ELSE  0 END)    :: TFloat  AS Rersent_to
               , (CASE WHEN SUM(COALESCE(tmpData.SummaRemainsStart,0)) <>0 THEN (SUM(tmpData.SummaRemainsMCS_from) * 100 / SUM(tmpData.SummaRemainsStart)) ELSE  0 END)  :: TFloat  AS Rersent_from
               , SUM(tmpData.Amount_Reserve)        :: TFloat  AS Amount_Reserve
               , SUM(tmpData.Amount_In)             :: TFloat  AS Amount_In
               
     FROM tmpData
          LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id = tmpData.UnitId
          
          LEFT JOIN tmpDataTo ON tmpDataTo.GoodsId = tmpData.GoodsId
                             AND tmpDataTo.UnitId  = tmpData.UnitId
                             
          LEFT JOIN tmpData AS tmpDataFrom ON tmpDataFrom.GoodsId = tmpData.GoodsId
                                          AND tmpDataFrom.UnitId = inUnitId

          LEFT JOIN tmpMIChild ON tmpMIChild.GoodsMainId = tmpData.GoodsMainId
                              AND tmpMIChild.UnitId  = tmpData.UnitId
 
     GROUP BY Object_Unit.Id, Object_Unit.ValueDAta

       ;
       
     RETURN NEXT Cursor4;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.11.18         *
 23.11.18         *
 20.01.17         *
 01.11.16         * add inisRecal, rename inisOutMCS -> inisInMCS
 30.10.16         *
 19.10.16         *
 14.07.16         *
 05.07.16         *
 09.06.16         *
*/

-- тест
/*
SELECT * FROM gpReport_RemainsOverGoods(inUnitId := 183288 , inStartDate := ('23.02.2017')::TDateTime , inPeriod := 30 , inDay := 30 , inAssortment := 1 , inisMCS := 'False' , inisInMCS := 'True' , inisRecal := 'False' , inisAssortment := 'False' , inIsReserve:='False' ,  inSession := '3')
FETCH ALL "<unnamed portal 1>";
*/

select * from gpReport_RemainsOverGoods(inUnitId := 7117700 , inStartDate := ('18.01.2022')::TDateTime , inPeriod := 30 , inDay := 12 , inDayIncome := 15 , inAssortment := 1 , inSummSend := 100 , inisMCS := 'False' , inisInMCS := 'False' , inisRecal := 'False' , inisAssortment := 'True' , inIsReserve := 'False' , inIsIncome := 'False' , inisSummSend := 'False' , inisMCS_0 := 'True' ,  inSession := '3');