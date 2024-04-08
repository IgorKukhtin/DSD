-- Function: gpReport_SupplyBalance()

DROP FUNCTION IF EXISTS gpReport_SupplyBalance (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SupplyBalance (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SupplyBalance(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    -- подразделение склад
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inJuridicalId        Integer,    -- поставщик
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar
             , MeasureName          TVarChar
             , GoodsGroupNameFull   TVarChar
             , GoodsGroupName       TVarChar
             , PartnerName          TVarChar
             , Comment              TVarChar
             , Comment_MI           TVarChar
             , MovementId_List      TVarChar
             , CountDays            Integer
             , RemainsStart         TFloat
             , RemainsEnd           TFloat
             , RemainsStart_Oth     TFloat
             , RemainsEnd_Oth       TFloat
             , CountIncome          TFloat
             , CountProductionOut   TFloat
             , CountIn_oth          TFloat
             , CountOut_oth         TFloat
             , CountOnDay           TFloat
             , RemainsDays          TFloat
             , ReserveDays          TFloat
             , PlanOrder            TFloat
             , CountOrder           TFloat
             , RemainsDaysWithOrder TFloat

             , CountIncome1 TFloat
             , CountIncome2 TFloat
             , CountIncome3 TFloat
             , CountIncome4 TFloat
             , CountIncome5 TFloat
             , CountIncome6 TFloat
             , CountIncome7 TFloat
             , CountProductionOut1 TFloat
             , CountProductionOut2 TFloat
             , CountProductionOut3 TFloat
             , CountProductionOut4 TFloat
             , CountProductionOut5 TFloat
             , CountProductionOut6 TFloat
             , CountProductionOut7 TFloat

             , CountIncome_1   TFloat
             , CountIncome_2   TFloat
             , CountIncome_3   TFloat
             , CountIncome_4   TFloat
             , CountIncome_5   TFloat
             , CountIncome_6   TFloat
             , CountIncome_7   TFloat
             , CountIncome_8   TFloat
             , CountIncome_9   TFloat
             , CountIncome_10  TFloat
             , CountIncome_11  TFloat
             , CountIncome_12  TFloat
             , CountIncome_13  TFloat
             , CountIncome_14  TFloat
             , CountIncome_15  TFloat
             , CountIncome_16  TFloat
             , CountIncome_17  TFloat
             , CountIncome_18  TFloat
             , CountIncome_19  TFloat
             , CountIncome_20  TFloat
             , CountIncome_21  TFloat
             , CountIncome_22  TFloat
             , CountIncome_23  TFloat
             , CountIncome_24  TFloat
             , CountIncome_25  TFloat
             , CountIncome_26  TFloat
             , CountIncome_27  TFloat
             , CountIncome_28  TFloat
             , CountIncome_29  TFloat
             , CountIncome_30  TFloat
             , CountIncome_31  TFloat

             , CountProductionOut_1   TFloat
             , CountProductionOut_2   TFloat
             , CountProductionOut_3   TFloat
             , CountProductionOut_4   TFloat
             , CountProductionOut_5   TFloat
             , CountProductionOut_6   TFloat
             , CountProductionOut_7   TFloat
             , CountProductionOut_8   TFloat
             , CountProductionOut_9   TFloat
             , CountProductionOut_10  TFloat
             , CountProductionOut_11  TFloat
             , CountProductionOut_12  TFloat
             , CountProductionOut_13  TFloat
             , CountProductionOut_14  TFloat
             , CountProductionOut_15  TFloat
             , CountProductionOut_16  TFloat
             , CountProductionOut_17  TFloat
             , CountProductionOut_18  TFloat
             , CountProductionOut_19  TFloat
             , CountProductionOut_20  TFloat
             , CountProductionOut_21  TFloat
             , CountProductionOut_22  TFloat
             , CountProductionOut_23  TFloat
             , CountProductionOut_24  TFloat
             , CountProductionOut_25  TFloat
             , CountProductionOut_26  TFloat
             , CountProductionOut_27  TFloat
             , CountProductionOut_28  TFloat
             , CountProductionOut_29  TFloat
             , CountProductionOut_30  TFloat
             , CountProductionOut_31  TFloat

             , Color_RemainsDays    Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCountDays Integer;
   DECLARE vbReserveDays Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbStartDate_Calc TDateTime;
   DECLARE vbEndDate_Calc TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect;
    ELSE
        -- ох и долго будет открываться в этом случае
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;


    -- на сколько дней считаем План. Заказ на месяц
    vbReserveDays:= 30;
    -- период ПРОГНОЗА = 4 недели
    vbCountDays := 4 * 7;
    -- определяются даты для расчета ПРОГНОЗ - ПОЛНЫЕ (с пон - по вск) - ЗАВЕРШЕННЫЕ 4 недели
    vbEndDate_Calc := CASE WHEN inEndDate > CURRENT_DATE 
                           THEN -- если Дата отчета БОЛЬШЕ сегодняшней
                                CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0
                                          THEN CURRENT_DATE -- Если СЕГОДНЯ = вскр.
                                     -- иначе находим ближайшее ПРОШЕДШЕЕ вскр. от СЕГОДНЯ
                                     ELSE (CURRENT_DATE - ((EXTRACT (DOW FROM CURRENT_DATE)) :: TVarChar || ' DAY') :: INTERVAL)
                                END
                           ELSE CASE WHEN EXTRACT (DOW FROM inEndDate) = 0
                                          THEN inEndDate -- Если ДАТА отчета = вскр.
                                     -- иначе находим ближайшее ПРОШЕДШЕЕ вскр. от ДАТЫ отчета
                                     ELSE (inEndDate - ((EXTRACT (DOW FROM inEndDate)) :: TVarChar || ' DAY') :: INTERVAL)
                                END
                      END;
    -- начальная будет пнд. - 4 недели НАЗАД
    vbStartDate_Calc := vbEndDate_Calc - ((vbCountDays - 1) :: TVarChar || ' DAY') :: INTERVAL;
    -- начальная - для ВСЕХ данных
    vbStartDate := (CASE WHEN vbStartDate_Calc < inStartDate THEN vbStartDate_Calc ELSE inStartDate END);
    

     RETURN QUERY
     WITH -- подразделения для "остатки в производстве"
          tmpUnit AS (SELECT 8448 AS UnitId       --цех деликатесов+
                     UNION
                      SELECT 8447 AS UnitId       -- колбасный+
                     UNION
                      SELECT 8449 AS UnitId       -- ЦЕХ с/к+
                     UNION
                      SELECT 8451 AS UnitId       -- упаковка+
                     UNION
                      SELECT 951601 AS UnitId     -- упаковка мясо+
                     UNION
                      SELECT 8006902 AS UnitId     -- ЦЕХ упаковки Тушенки+
                     UNION
                      SELECT 981821 AS UnitId     -- шприцевание
                     )
    -- заявки по Юр Лицам - !!!только если заявка НЕ закрыта!!! -- !!!вместо - только если под них еще нет прихода!!!
  , tmpOrderIncome_all AS (SELECT MILinkObject_Goods.ObjectId           AS GoodsId
                                , MovementLinkObject_Juridical.ObjectId AS JuridicalId -- на самом деле это Юр лицо, но его будем использовать если вдруг другой инфы не окажется
                                , MovementItem.Amount                   AS Amount
                                , COALESCE (MI_Income.Amount, 0)        AS Amount_Income
                                , ROW_NUMBER() OVER (PARTITION BY Movement.Id, MILinkObject_Goods.ObjectId) AS Ord
                                , COALESCE (MovementString_Comment.ValueData,'') AS Comment
                                , COALESCE (MIString_Comment.ValueData,'')       AS Comment_MI
                                , Movement.Id AS MovementId
                           FROM Movement
                                LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                                          ON MovementBoolean_Closed.MovementId = Movement.Id
                                                         AND MovementBoolean_Closed.DescId     = zc_MovementBoolean_Closed()
                                                         AND MovementBoolean_Closed.ValueData  = TRUE
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                              ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                             AND MovementLinkObject_Juridical.DescId     = zc_MovementLinkObject_Juridical()
                                                             -- !!!ограничили!!!
                                                             AND (MovementLinkObject_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             AND MovementLinkObject_Unit.ObjectId > 0 -- !!!значит это заявка "снабжения"!!!

                                LEFT JOIN MovementString AS MovementString_Comment
                                                         ON MovementString_Comment.MovementId = Movement.Id
                                                        AND MovementString_Comment.DescId = zc_MovementString_Comment()

                                INNER JOIN MovementItem ON MovementItem.MovementId  = Movement.Id
                                                       AND MovementItem.isErased    = FALSE
                                                       AND MovementItem.DescId      = zc_MI_Master()
                                                       AND MovementItem.Amount      <> 0
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                 ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MILinkObject_Goods.ObjectId

                                LEFT JOIN MovementItemString AS MIString_Comment
                                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                                            AND MIString_Comment.DescId = zc_MIString_Comment()

                                LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                                              ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_Close.DescId = zc_MIBoolean_Close()
                                                             AND MIBoolean_Close.ValueData  = TRUE
                                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Income
                                                               ON MovementLinkMovement_Income.MovementChildId = Movement.Id
                                                              AND MovementLinkMovement_Income.DescId = zc_MovementLinkMovement_Order()
                                LEFT JOIN Movement AS Movement_Income
                                                   ON Movement_Income.Id       = MovementLinkMovement_Income.MovementId
                                                  AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement_Income.DescId   IN (zc_Movement_Income(), zc_Movement_ProductionUnion())
                                LEFT JOIN MovementItem AS MI_Income
                                                       ON MI_Income.MovementId  = Movement_Income.Id
                                                      AND MI_Income.ObjectId    = MILinkObject_Goods.ObjectId
                                                      AND MI_Income.isErased    = FALSE
                                                      AND MI_Income.DescId      = zc_MI_Master()

                           WHERE Movement.DescId     = zc_Movement_OrderIncome()
                             AND Movement.StatusId   = zc_Enum_Status_Complete()
                             AND MovementBoolean_Closed.MovementId IS NULL -- т.е. заявка НЕ закрыта
                             AND MIBoolean_Close.MovementItemId IS NULL -- т.е. строка НЕ закрыта
                             -- AND Movement_Income.Id IS NULL -- т.е. у заявки еще нет ПРОВЕДЕННОГО прихода
                           )
        -- заявки по Юр Лицам - вычитаем: Заявка - Приход
   , tmpOrderIncome_gr AS (SELECT tmp.GoodsId
                                , STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName -- на самом деле это Юр лицо, но его будем использовать если вдруг другой инфі не окажется
                                , STRING_AGG (tmp.Comment :: TVarChar, '; ')      AS Comment
                                , STRING_AGG (tmp.Comment_MI :: TVarChar, '; ')   AS Comment_MI
                                , STRING_AGG (tmp.MovementId :: TVarChar, '; ')   AS MovementId_List
                           FROM (SELECT DISTINCT tmp.GoodsId, tmp.JuridicalId, tmp.Comment, tmp.Comment_MI, tmp.MovementId FROM tmpOrderIncome_all AS tmp) AS tmp
                                LEFT JOIN Object ON Object.Id = tmp.JuridicalId
                           GROUP BY tmp.GoodsId
                          )
        -- заявки по Юр Лицам - вычитаем: Заявка - Приход
      , tmpOrderIncome AS (SELECT tmp.GoodsId
                                , tmpOrderIncome_gr.PartnerName
                                , tmpOrderIncome_gr.Comment
                                , tmpOrderIncome_gr.Comment_MI
                                , tmpOrderIncome_gr.MovementId_List
                                , tmp.Amount - tmp.Amount_Income AS Amount
                           FROM (SELECT tmpOrderIncome_all.GoodsId
                                      -- , STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName -- на самом деле это Юр лицо, но его будем использовать если вдруг другой инфі не окажется
                                      -- , STRING_AGG (tmpOrderIncome_all.Comment :: TVarChar, '; ') AS Comment
                                      -- , STRING_AGG (tmpOrderIncome_all.MovementId :: TVarChar, '; ') AS MovementId_List
                                      , SUM (CASE WHEN tmpOrderIncome_all.Ord = 1 THEN tmpOrderIncome_all.Amount ELSE 0 END) AS Amount
                                      , SUM (tmpOrderIncome_all.Amount_Income) AS Amount_Income
                                 FROM tmpOrderIncome_all
                                      LEFT JOIN Object ON Object.Id = tmpOrderIncome_all.JuridicalId
                                 GROUP BY tmpOrderIncome_all.GoodsId
                                ) AS tmp
                                LEFT JOIN tmpOrderIncome_gr ON tmpOrderIncome_gr.GoodsId = tmp.GoodsId
                           WHERE tmp.Amount > tmp.Amount_Income
                          )
    -- список товаров по поставщикам из прихода (кол-во прихода возьмем из проводок - потом)
  , tmpContainerIncome AS (SELECT DISTINCT
                                  MIContainer.ObjectId_Analyzer    AS GoodsId
                                , MIContainer.ObjectExtId_Analyzer AS PartnerId
                           FROM MovementItemContainer AS MIContainer
                                INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ObjectId = MIContainer.ObjectExtId_Analyzer
                                                    AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                           WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                             AND MIContainer.WhereObjectId_Analyzer = inUnitId
                             AND MIContainer.MovementDescId         IN (zc_Movement_Income(), zc_Movement_ProductionUnion())
                             AND MIContainer.DescId                 = zc_MIContainer_Count()
                             -- !!!ограничили!!!
                             AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                          )
  -- список товаров по поставщикам из !!!последней!!! "привязки"
, tmpGoodsListIncome AS (SELECT DISTINCT
                                tmpGoods.GoodsId
                              , ObjectLink_GoodsListIncome_Partner.ChildObjectId AS PartnerId
                         FROM _tmpGoods AS tmpGoods
                              INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                                    ON ObjectLink_GoodsListIncome_Goods.ChildObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_GoodsListIncome_Goods.DescId        = zc_ObjectLink_GoodsListIncome_Goods()
                              INNER JOIN ObjectBoolean AS ObjectBoolean_GoodsListIncome_Last
                                                       ON ObjectBoolean_GoodsListIncome_Last.ObjectId  = ObjectLink_GoodsListIncome_Goods.ObjectId
                                                      AND ObjectBoolean_GoodsListIncome_Last.DescId    = zc_ObjectBoolean_GoodsListIncome_Last()
                                                      AND ObjectBoolean_GoodsListIncome_Last.ValueData = TRUE -- из последней
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                                                   ON ObjectLink_GoodsListIncome_Partner.ObjectId = ObjectLink_GoodsListIncome_Goods.ObjectId
                                                  AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
                              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                   ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_GoodsListIncome_Partner.ChildObjectId
                                                  AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                         -- !!!ограничили!!!
                         WHERE (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                        )
      -- !!!финальный!!! список товаров + он ПО поставщикам - и GoodsId в нем надеюсь уникальный
    , tmpGoodsList AS (SELECT tmp.GoodsId
                            , STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName -- на самом деле это Юр лицо, но его будем использовать если вдруг другой инфі не окажется
                       FROM (-- приоритет № 1
                             SELECT tmpContainerIncome.GoodsId
                                  , tmpContainerIncome.PartnerId
                             FROM tmpContainerIncome
                            UNION
                             -- еще добавим из списка - если нет в приходе
                             SELECT tmpGoodsListIncome.GoodsId
                                  , tmpGoodsListIncome.PartnerId
                             FROM tmpGoodsListIncome
                                  LEFT JOIN tmpContainerIncome ON tmpContainerIncome.GoodsId = tmpGoodsListIncome.GoodsId
                             WHERE tmpContainerIncome.GoodsId IS NULL
                            ) AS tmp
                            LEFT JOIN Object ON Object.Id = tmp.PartnerId
                       GROUP BY tmp.GoodsId
                      UNION
                       -- приоритет № 2 - еще добавим из заявок - если нет в предыдущем
                       SELECT tmpOrderIncome.GoodsId, tmpOrderIncome.PartnerName
                       FROM tmpOrderIncome
                            LEFT JOIN tmpContainerIncome ON tmpContainerIncome.GoodsId = tmpOrderIncome.GoodsId
                            LEFT JOIN tmpGoodsListIncome ON tmpGoodsListIncome.GoodsId = tmpOrderIncome.GoodsId
                       WHERE tmpContainerIncome.GoodsId IS NULL
                         AND tmpGoodsListIncome.GoodsId IS NULL
                      UNION
                       -- приоритет № 3 - еще остальные - НО если НЕТ inJuridicalId
                       SELECT _tmpGoods.GoodsId, '' AS PartnerName
                       FROM _tmpGoods
                            LEFT JOIN tmpContainerIncome ON tmpContainerIncome.GoodsId = _tmpGoods.GoodsId
                            LEFT JOIN tmpGoodsListIncome ON tmpGoodsListIncome.GoodsId = _tmpGoods.GoodsId
                            LEFT JOIN tmpOrderIncome     ON tmpOrderIncome.GoodsId     = _tmpGoods.GoodsId
                       WHERE inJuridicalId = 0
                         AND tmpContainerIncome.GoodsId IS NULL
                         AND tmpGoodsListIncome.GoodsId IS NULL
                         AND tmpOrderIncome.GoodsId     IS NULL
                      )

   -- контейнеры для движения - по !!!финальному!!! списку
 , tmpContainerAll AS (SELECT Container.Id         AS ContainerId
                            , CLO_Unit.ObjectId    AS UnitId
                            , Container.ObjectId   AS GoodsId
                            , Container.Amount
                       FROM ContainerLinkObject AS CLO_Unit
                            -- INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId
                            INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count()
                            INNER JOIN tmpGoodsList ON tmpGoodsList.GoodsId = Container.ObjectId
                       WHERE CLO_Unit.ObjectId = inUnitId
                         AND CLO_Unit.DescId   = zc_ContainerLinkObject_Unit()
                      )

     -- остатки
   , tmpMIContainerAll AS (SELECT CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MIContainer.ObjectExtId_Analyzer
                                       WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.isActive = TRUE THEN MIContainer.ObjectExtId_Analyzer
                                       ELSE 0
                                  END AS ObjectExtId_Analyzer
                                , tmpContainerAll.ContainerId
                                , tmpContainerAll.GoodsId
                                , tmpContainerAll.Amount
                                  -- для остатка на начало inStartDate
                                , SUM (CASE WHEN MIContainer.OperDate >= inStartDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END)  AS StartAmountSum
                                  -- для остатка на конец inEndDate
                                , SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmountSum

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut())
                                                 THEN COALESCE (MIContainer.Amount, 0)
                                            WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId in (zc_Movement_ProductionUnion())
                                             AND MIContainer.isActive = TRUE
                                                 THEN COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountIncome
                                , SUM (-- Перемещение
                                       CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                             -- AND MIContainer.isActive = FALSE
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                       -- еще добавляем остальные
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_Sale())
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate(), zc_Movement_Loss())
                                             AND MIContainer.isActive = FALSE
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                      ) AS CountSendOut

                                , SUM (-- Перемещение
                                       CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_Calc AND vbEndDate_Calc
                                             AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                             -- AND MIContainer.isActive = FALSE
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                       -- еще добавляем остальные
                                     + CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_Calc AND vbEndDate_Calc
                                             AND MIContainer.MovementDescId IN (zc_Movement_Sale())
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN vbStartDate_Calc AND vbEndDate_Calc
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate(), zc_Movement_Loss())
                                             AND MIContainer.isActive = FALSE
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                      ) AS CountSendOut_Calc

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_Inventory())
                                             AND MIContainer.Amount < 0
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountOut_oth

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ReturnIn())
                                            THEN 1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionSeparate(), zc_Movement_Loss())
                                             AND MIContainer.isActive = TRUE
                                            THEN 1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                             AND MIContainer.Amount > 0
                                            THEN 1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountIn_oth

                           FROM tmpContainerAll
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.Containerid = tmpContainerAll.ContainerId
                                                               AND MIContainer.OperDate >= vbStartDate
                                LEFT JOIN zfCalc_DayOfWeekName (MIContainer.OperDate) AS tmpWeekDay ON 1=1
                           GROUP BY CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MIContainer.ObjectExtId_Analyzer
                                         WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.isActive = TRUE THEN MIContainer.ObjectExtId_Analyzer
                                         ELSE 0
                                    END
                                  , tmpContainerAll.ContainerId, tmpContainerAll.GoodsId, tmpContainerAll.Amount
                          )
    -- движение + остатки
  , tmpContainer AS (SELECT tmp.GoodsId
                          , (tmp.StartAmount)        AS RemainsStart
                          , (tmp.EndAmount)          AS RemainsEnd
                          , (tmpIncome.CountIncome)  AS CountIncome
                          , (tmp.CountSendOut)       AS CountProductionOut
                          , (tmp.CountSendOut_Calc)  AS CountProductionOut_Calc
                          , (tmp.CountIn_oth   + COALESCE (tmpIncome.CountIn_oth, 0))  AS CountIn_oth
                          , (tmp.CountOut_oth  + COALESCE (tmpIncome.CountOut_oth, 0)) AS CountOut_oth

                     FROM (SELECT tmp.GoodsId
                                , SUM (tmp.StartAmount)       AS StartAmount
                                , SUM (tmp.EndAmount)         AS EndAmount
                                , SUM (tmp.CountSendOut)      AS CountSendOut
                                , SUM (tmp.CountSendOut_Calc) AS CountSendOut_Calc
                                , SUM (tmp.CountOut_oth)      AS CountOut_oth
                                , SUM (tmp.CountIn_oth)       AS CountIn_oth
                           FROM
                          (SELECT tmpMIContainerAll.GoodsId
                                , tmpMIContainerAll.Amount - SUM (tmpMIContainerAll.StartAmountSum)  AS StartAmount
                                , tmpMIContainerAll.Amount - SUM (tmpMIContainerAll.EndAmountSum)    AS EndAmount
                                , SUM (tmpMIContainerAll.CountSendOut)      AS CountSendOut
                                , SUM (tmpMIContainerAll.CountSendOut_Calc) AS CountSendOut_Calc
                                , SUM (tmpMIContainerAll.CountOut_oth)      AS CountOut_oth
                                , SUM (tmpMIContainerAll.CountIn_oth)       AS CountIn_oth
                           FROM tmpMIContainerAll
                           GROUP BY tmpMIContainerAll.ContainerId, tmpMIContainerAll.GoodsId, tmpMIContainerAll.Amount
                          ) AS tmp
                           GROUP BY tmp.GoodsId
                          ) AS tmp
                          LEFT JOIN (SELECT tmpMIContainerAll.GoodsId
                                          , SUM (CASE -- если надо по всем поставщикам - тогда весь приход
                                                      WHEN inJuridicalId = 0
                                                           THEN tmpMIContainerAll.CountIncome
                                                      -- если надо только по одному поставщику
                                                      WHEN ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId AND inJuridicalId > 0
                                                           THEN tmpMIContainerAll.CountIncome
                                                      -- иначе это "другой" приход/расход
                                                      ELSE 0
                                                END) AS CountIncome

                                          , SUM (CASE -- иначе это "другой" приход
                                                      WHEN COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0) <> inJuridicalId AND inJuridicalId > 0
                                                           AND tmpMIContainerAll.CountIncome > 0
                                                           THEN tmpMIContainerAll.CountIncome
                                                      ELSE 0
                                                END) AS CountIn_oth
                                          , SUM (CASE -- иначе это "другой" расход
                                                      WHEN COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0) <> inJuridicalId AND inJuridicalId > 0
                                                           AND tmpMIContainerAll.CountIncome < 0
                                                           THEN -1 * tmpMIContainerAll.CountIncome
                                                      ELSE 0
                                                END) AS CountOut_oth
                                     FROM tmpMIContainerAll
                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                               ON ObjectLink_Partner_Juridical.ObjectId = tmpMIContainerAll.ObjectExtId_Analyzer
                                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                     GROUP BY tmpMIContainerAll.GoodsId
                                    ) AS tmpIncome ON tmpIncome.GoodsId = tmp.GoodsId
                     )

          -- приход / расход по дням
        , tmpOnDaysAll AS (SELECT CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MIContainer.ObjectExtId_Analyzer
                                       WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.isActive = TRUE THEN MIContainer.ObjectExtId_Analyzer
                                       ELSE 0
                                  END AS ObjectExtId_Analyzer
                                , tmpContainerAll.GoodsId
                                , MIContainer.OperDate
                                , SUM (CASE WHEN MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut())
                                                 THEN COALESCE (MIContainer.Amount, 0)
                                            WHEN MIContainer.MovementDescId in (zc_Movement_ProductionUnion()) AND MIContainer.isActive = TRUE
                                                 THEN COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) CountIncome

                                , SUM (-- Перемещение
                                       CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                       -- еще добавляем остальные
                                     + CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale())
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate(), zc_Movement_Loss())
                                             AND MIContainer.isActive = FALSE
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                      ) AS CountProductionOut
                           FROM tmpContainerAll
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.Containerid = tmpContainerAll.ContainerId
                                                               AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                           GROUP BY CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MIContainer.ObjectExtId_Analyzer
                                         WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion()) AND MIContainer.isActive = TRUE THEN MIContainer.ObjectExtId_Analyzer
                                         ELSE 0
                                    END
                                  , tmpContainerAll.GoodsId, MIContainer.OperDate
                          )
             -- приход / расход по дням
           , tmpOnDays AS (SELECT tmp.GoodsId
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 1 THEN tmp.CountIncome ELSE 0 END) CountIncome1
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 2 THEN tmp.CountIncome ELSE 0 END) CountIncome2
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 3 THEN tmp.CountIncome ELSE 0 END) CountIncome3
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 4 THEN tmp.CountIncome ELSE 0 END) CountIncome4
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 5 THEN tmp.CountIncome ELSE 0 END) CountIncome5
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 6 THEN tmp.CountIncome ELSE 0 END) CountIncome6
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 7 THEN tmp.CountIncome ELSE 0 END) CountIncome7

                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 1 THEN tmp.CountProductionOut ELSE 0 END) CountProductionOut1
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 2 THEN tmp.CountProductionOut ELSE 0 END) CountProductionOut2
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 3 THEN tmp.CountProductionOut ELSE 0 END) CountProductionOut3
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 4 THEN tmp.CountProductionOut ELSE 0 END) CountProductionOut4
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 5 THEN tmp.CountProductionOut ELSE 0 END) CountProductionOut5
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 6 THEN tmp.CountProductionOut ELSE 0 END) CountProductionOut6
                                , SUM (CASE WHEN tmp.OperDate BETWEEN inEndDate - INTERVAL '6 DAY' AND inEndDate AND tmpWeekDay.Number = 7 THEN tmp.CountProductionOut ELSE 0 END) CountProductionOut7

                                , SUM (CASE WHEN tmp.NumDay = 1 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_1
                                , SUM (CASE WHEN tmp.NumDay = 2 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_2
                                , SUM (CASE WHEN tmp.NumDay = 3 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_3
                                , SUM (CASE WHEN tmp.NumDay = 4 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_4
                                , SUM (CASE WHEN tmp.NumDay = 5 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_5
                                , SUM (CASE WHEN tmp.NumDay = 6 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_6
                                , SUM (CASE WHEN tmp.NumDay = 7 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_7
                                , SUM (CASE WHEN tmp.NumDay = 8 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_8
                                , SUM (CASE WHEN tmp.NumDay = 9 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_9
                                , SUM (CASE WHEN tmp.NumDay = 10 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_10
                                , SUM (CASE WHEN tmp.NumDay = 11 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_11
                                , SUM (CASE WHEN tmp.NumDay = 12 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_12
                                , SUM (CASE WHEN tmp.NumDay = 13 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_13
                                , SUM (CASE WHEN tmp.NumDay = 14 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_14
                                , SUM (CASE WHEN tmp.NumDay = 15 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_15
                                , SUM (CASE WHEN tmp.NumDay = 16 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_16
                                , SUM (CASE WHEN tmp.NumDay = 17 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_17
                                , SUM (CASE WHEN tmp.NumDay = 18 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_18
                                , SUM (CASE WHEN tmp.NumDay = 19 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_19
                                , SUM (CASE WHEN tmp.NumDay = 20 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_20
                                , SUM (CASE WHEN tmp.NumDay = 21 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_21
                                , SUM (CASE WHEN tmp.NumDay = 22 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_22
                                , SUM (CASE WHEN tmp.NumDay = 23 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_23
                                , SUM (CASE WHEN tmp.NumDay = 24 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_24
                                , SUM (CASE WHEN tmp.NumDay = 25 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_25
                                , SUM (CASE WHEN tmp.NumDay = 26 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_26
                                , SUM (CASE WHEN tmp.NumDay = 27 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_27
                                , SUM (CASE WHEN tmp.NumDay = 28 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_28
                                , SUM (CASE WHEN tmp.NumDay = 29 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_29
                                , SUM (CASE WHEN tmp.NumDay = 30 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_30
                                , SUM (CASE WHEN tmp.NumDay = 31 THEN tmp.CountIncome ELSE 0 END) AS CountIncome_31

                                , SUM (CASE WHEN tmp.NumDay = 1 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_1
                                , SUM (CASE WHEN tmp.NumDay = 2 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_2
                                , SUM (CASE WHEN tmp.NumDay = 3 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_3
                                , SUM (CASE WHEN tmp.NumDay = 4 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_4
                                , SUM (CASE WHEN tmp.NumDay = 5 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_5
                                , SUM (CASE WHEN tmp.NumDay = 6 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_6
                                , SUM (CASE WHEN tmp.NumDay = 7 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_7
                                , SUM (CASE WHEN tmp.NumDay = 8 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_8
                                , SUM (CASE WHEN tmp.NumDay = 9 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_9
                                , SUM (CASE WHEN tmp.NumDay = 10 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_10
                                , SUM (CASE WHEN tmp.NumDay = 11 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_11
                                , SUM (CASE WHEN tmp.NumDay = 12 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_12
                                , SUM (CASE WHEN tmp.NumDay = 13 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_13
                                , SUM (CASE WHEN tmp.NumDay = 14 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_14
                                , SUM (CASE WHEN tmp.NumDay = 15 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_15
                                , SUM (CASE WHEN tmp.NumDay = 16 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_16
                                , SUM (CASE WHEN tmp.NumDay = 17 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_17
                                , SUM (CASE WHEN tmp.NumDay = 18 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_18
                                , SUM (CASE WHEN tmp.NumDay = 19 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_19
                                , SUM (CASE WHEN tmp.NumDay = 20 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_20
                                , SUM (CASE WHEN tmp.NumDay = 21 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_21
                                , SUM (CASE WHEN tmp.NumDay = 22 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_22
                                , SUM (CASE WHEN tmp.NumDay = 23 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_23
                                , SUM (CASE WHEN tmp.NumDay = 24 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_24
                                , SUM (CASE WHEN tmp.NumDay = 25 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_25
                                , SUM (CASE WHEN tmp.NumDay = 26 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_26
                                , SUM (CASE WHEN tmp.NumDay = 27 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_27
                                , SUM (CASE WHEN tmp.NumDay = 28 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_28
                                , SUM (CASE WHEN tmp.NumDay = 29 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_29
                                , SUM (CASE WHEN tmp.NumDay = 30 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_30
                                , SUM (CASE WHEN tmp.NumDay = 31 THEN tmp.CountProductionOut ELSE 0 END) AS CountProductionOut_31

                           FROM (SELECT tmpOnDaysAll.GoodsId
                                      , tmpOnDaysAll.OperDate
                                      , EXTRACT(DAY FROM tmpOnDaysAll.OperDate) AS NumDay
                                      , SUM (CASE -- если надо по всем поставщикам - тогда весь приход
                                                  WHEN inJuridicalId = 0
                                                  THEN tmpOnDaysAll.CountIncome
                                                  -- если надо только по одному поставщику
                                                  WHEN ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId AND inJuridicalId > 0
                                                  THEN tmpOnDaysAll.CountIncome
                                                  -- иначе это "другой" приход/расход
                                                  ELSE 0
                                              END) AS CountIncome
                                      , SUM (tmpOnDaysAll.CountProductionOut) AS CountProductionOut
                                 FROM tmpOnDaysAll
                                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = tmpOnDaysAll.ObjectExtId_Analyzer
                                                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                 GROUP BY tmpOnDaysAll.GoodsId
                                        , tmpOnDaysAll.OperDate
                                ) AS tmp
                                LEFT JOIN zfCalc_DayOfWeekName (tmp.OperDate) AS tmpWeekDay ON 1=1
                           GROUP BY tmp.GoodsId
                           )


   -- контейнеры - для "остатки в производстве"
 , tmpContainer_Oth AS (SELECT Container.Id       AS ContainerId
                             , Container.ObjectId AS GoodsId
                             , Container.Amount
                        FROM tmpUnit
                             INNER JOIN ContainerLinkObject AS CLO_Unit
                                                            ON CLO_Unit.ObjectId = tmpUnit.UnitId
                                                           AND CLO_Unit.DescId   = zc_ContainerLinkObject_Unit()
                             INNER JOIN Container ON Container.Id     = CLO_Unit.ContainerId
                                                 AND Container.DescId = zc_Container_Count()
                             INNER JOIN tmpGoodsList ON tmpGoodsList.GoodsId = Container.ObjectId
                       )
    --"остатки в производстве"
  , tmpRemains_Oth AS (SELECT tmp.GoodsId
                            , SUM (tmp.StartAmount) AS RemainsStart
                            , SUM (tmp.EndAmount)   AS RemainsEnd

                       FROM (SELECT tmpContainer_Oth.ContainerId
                                  , tmpContainer_Oth.GoodsId
                                  , tmpContainer_Oth.Amount - SUM (COALESCE (MIContainer.Amount, 0))  AS StartAmount
                                  , tmpContainer_Oth.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount
                             FROM tmpContainer_Oth
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.Containerid = tmpContainer_Oth.ContainerId
                                                                 AND MIContainer.OperDate    >= inStartDate
                             GROUP BY tmpContainer_Oth.ContainerId, tmpContainer_Oth.GoodsId, tmpContainer_Oth.Amount
                             HAVING tmpContainer_Oth.Amount - SUM (COALESCE (MIContainer.Amount, 0))  <> 0
                                 OR tmpContainer_Oth.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                            ) AS tmp
                       GROUP BY tmp.GoodsId
                      )
       -- Результат
       SELECT
             Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_Measure.ValueData                   AS MeasureName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                AS GoodsGroupName

           , tmpGoodsList.PartnerName       :: TVarChar AS PartnerName

           , tmpOrderIncome.Comment         :: TVarChar AS Comment
           , tmpOrderIncome.Comment_MI      :: TVarChar AS Comment_MI
           , tmpOrderIncome.MovementId_List :: TVarChar AS MovementId_List

             -- период ПРОГНОЗА = 4 недели
           , vbCountDays                        AS CountDays

           , tmpContainer.RemainsStart        :: TFloat AS RemainsStart
           , tmpContainer.RemainsEnd          :: TFloat AS RemainsEnd
           , tmpRemains_Oth.RemainsStart      :: TFloat AS RemainsStart_Oth
           , tmpRemains_Oth.RemainsEnd        :: TFloat AS RemainsEnd_Oth
           , tmpContainer.CountIncome         :: TFloat AS CountIncome
           , tmpContainer.CountProductionOut  :: TFloat AS CountProductionOut
           , tmpContainer.CountIn_oth         :: TFloat AS CountIn_oth
           , tmpContainer.CountOut_oth        :: TFloat AS CountOut_oth

             -- Средний расход в день
           , (CASE WHEN vbCountDays <> 0 THEN tmpContainer.CountProductionOut_Calc / vbCountDays ELSE 0 END) :: TFloat AS CountOnDay

             -- Кол. дней остатка
           , CASE WHEN tmpContainer.CountProductionOut_Calc <=0 AND  tmpContainer.RemainsEnd <> 0 THEN 365
                  WHEN tmpContainer.RemainsEnd <> 0 AND (tmpContainer.CountProductionOut_Calc/vbCountDays) <> 0
                  THEN tmpContainer.RemainsEnd / (tmpContainer.CountProductionOut_Calc/vbCountDays)
                  ELSE 0
             END :: TFloat AS RemainsDays

             -- на сколько дней считаем План. Заказ на месяц
           , vbReserveDays :: TFloat AS ReserveDays

             -- План. Заказ на месяц
           , CASE WHEN tmpContainer.CountProductionOut_Calc > 0 
                   AND tmpContainer.RemainsEnd <> 0
                   AND tmpContainer.RemainsEnd <> 0 
                   AND tmpContainer.RemainsEnd < (tmpContainer.CountProductionOut_Calc/vbCountDays) * vbReserveDays
                  THEN (tmpContainer.CountProductionOut_Calc/vbCountDays) * vbReserveDays - tmpContainer.RemainsEnd
                  ELSE 0
             END :: TFloat AS PlanOrder

             -- Заказ в пути
           , tmpOrderIncome.Amount  :: TFloat AS CountOrder

             -- Кол. дней ост. с учет. заказа
           , CASE WHEN tmpContainer.CountProductionOut_Calc <= 0 AND tmpContainer.RemainsEnd <> 0
                  THEN 365
                  WHEN (tmpContainer.CountProductionOut_Calc / vbCountDays) <> 0
                  THEN (COALESCE (tmpContainer.RemainsEnd, 0) + COALESCE (tmpOrderIncome.Amount, 0)) / (tmpContainer.CountProductionOut_Calc / vbCountDays)
                  ELSE 0
             END  :: TFloat AS RemainsDaysWithOrder

           , tmpOnDays.CountIncome1         :: TFloat
           , tmpOnDays.CountIncome2         :: TFloat
           , tmpOnDays.CountIncome3         :: TFloat
           , tmpOnDays.CountIncome4         :: TFloat
           , tmpOnDays.CountIncome5         :: TFloat
           , tmpOnDays.CountIncome6         :: TFloat
           , tmpOnDays.CountIncome7         :: TFloat

           , tmpOnDays.CountProductionOut1  :: TFloat
           , tmpOnDays.CountProductionOut2  :: TFloat
           , tmpOnDays.CountProductionOut3  :: TFloat
           , tmpOnDays.CountProductionOut4  :: TFloat
           , tmpOnDays.CountProductionOut5  :: TFloat
           , tmpOnDays.CountProductionOut6  :: TFloat
           , tmpOnDays.CountProductionOut7  :: TFloat

           , tmpOnDays.CountIncome_1          :: TFloat
           , tmpOnDays.CountIncome_2          :: TFloat
           , tmpOnDays.CountIncome_3          :: TFloat
           , tmpOnDays.CountIncome_4          :: TFloat
           , tmpOnDays.CountIncome_5          :: TFloat
           , tmpOnDays.CountIncome_6          :: TFloat
           , tmpOnDays.CountIncome_7          :: TFloat
           , tmpOnDays.CountIncome_8          :: TFloat
           , tmpOnDays.CountIncome_9          :: TFloat
           , tmpOnDays.CountIncome_10         :: TFloat
           , tmpOnDays.CountIncome_11         :: TFloat
           , tmpOnDays.CountIncome_12         :: TFloat
           , tmpOnDays.CountIncome_13         :: TFloat
           , tmpOnDays.CountIncome_14         :: TFloat
           , tmpOnDays.CountIncome_15         :: TFloat
           , tmpOnDays.CountIncome_16         :: TFloat
           , tmpOnDays.CountIncome_17         :: TFloat
           , tmpOnDays.CountIncome_18         :: TFloat
           , tmpOnDays.CountIncome_19         :: TFloat
           , tmpOnDays.CountIncome_20         :: TFloat
           , tmpOnDays.CountIncome_21         :: TFloat
           , tmpOnDays.CountIncome_22         :: TFloat
           , tmpOnDays.CountIncome_23         :: TFloat
           , tmpOnDays.CountIncome_24         :: TFloat
           , tmpOnDays.CountIncome_25         :: TFloat
           , tmpOnDays.CountIncome_26         :: TFloat
           , tmpOnDays.CountIncome_27         :: TFloat
           , tmpOnDays.CountIncome_28         :: TFloat
           , tmpOnDays.CountIncome_29         :: TFloat
           , tmpOnDays.CountIncome_30         :: TFloat
           , tmpOnDays.CountIncome_31         :: TFloat

           , tmpOnDays.CountProductionOut_1          :: TFloat
           , tmpOnDays.CountProductionOut_2          :: TFloat
           , tmpOnDays.CountProductionOut_3          :: TFloat
           , tmpOnDays.CountProductionOut_4          :: TFloat
           , tmpOnDays.CountProductionOut_5          :: TFloat
           , tmpOnDays.CountProductionOut_6          :: TFloat
           , tmpOnDays.CountProductionOut_7          :: TFloat
           , tmpOnDays.CountProductionOut_8          :: TFloat
           , tmpOnDays.CountProductionOut_9          :: TFloat
           , tmpOnDays.CountProductionOut_10         :: TFloat
           , tmpOnDays.CountProductionOut_11         :: TFloat
           , tmpOnDays.CountProductionOut_12         :: TFloat
           , tmpOnDays.CountProductionOut_13         :: TFloat
           , tmpOnDays.CountProductionOut_14         :: TFloat
           , tmpOnDays.CountProductionOut_15         :: TFloat
           , tmpOnDays.CountProductionOut_16         :: TFloat
           , tmpOnDays.CountProductionOut_17         :: TFloat
           , tmpOnDays.CountProductionOut_18         :: TFloat
           , tmpOnDays.CountProductionOut_19         :: TFloat
           , tmpOnDays.CountProductionOut_20         :: TFloat
           , tmpOnDays.CountProductionOut_21         :: TFloat
           , tmpOnDays.CountProductionOut_22         :: TFloat
           , tmpOnDays.CountProductionOut_23         :: TFloat
           , tmpOnDays.CountProductionOut_24         :: TFloat
           , tmpOnDays.CountProductionOut_25         :: TFloat
           , tmpOnDays.CountProductionOut_26         :: TFloat
           , tmpOnDays.CountProductionOut_27         :: TFloat
           , tmpOnDays.CountProductionOut_28         :: TFloat
           , tmpOnDays.CountProductionOut_29         :: TFloat
           , tmpOnDays.CountProductionOut_30         :: TFloat
           , tmpOnDays.CountProductionOut_31         :: TFloat

           , CASE WHEN COALESCE (tmpOrderIncome.Amount, 0) > 0 THEN 25088  -- зеленый
                  ELSE
                    CASE WHEN tmpContainer.CountProductionOut <= 0 AND tmpContainer.RemainsEnd <> 0
                              THEN zc_Color_Black()

                         WHEN COALESCE (tmpContainer.CountProductionOut, 0) <= 0 AND COALESCE (tmpContainer.RemainsEnd, 0) = 0
                              THEN zc_Color_Black()

                         WHEN 29.9 < CASE WHEN tmpContainer.RemainsEnd <> 0 AND (tmpContainer.CountProductionOut / vbCountDays) <> 0
                                               THEN COALESCE (tmpContainer.RemainsEnd, 0) / (tmpContainer.CountProductionOut / vbCountDays)
                                           ELSE 0
                                     END
                              THEN zc_Color_Black()

                         ELSE zc_Color_Red()
                    END
              END :: Integer AS Color_RemainsDays

       FROM tmpGoodsList
          LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpGoodsList.GoodsId
          LEFT JOIN tmpOrderIncome ON tmpOrderIncome.GoodsId = tmpGoodsList.GoodsId
          LEFT JOIN tmpRemains_Oth ON tmpRemains_Oth.GoodsId = tmpGoodsList.GoodsId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsList.GoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN tmpOnDays ON tmpOnDays.GoodsId = tmpGoodsList.GoodsId

       WHERE tmpContainer.RemainsStart   <> 0 OR tmpContainer.RemainsEnd         <> 0 OR tmpOrderIncome.Amount  <> 0
          OR tmpContainer.CountIncome    <> 0 OR tmpContainer.CountProductionOut <> 0
          OR tmpContainer.CountIn_oth    <> 0 OR tmpContainer.CountOut_oth       <> 0
          OR tmpRemains_Oth.RemainsStart <> 0
          OR tmpRemains_Oth.RemainsEnd   <> 0
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.04.20         * zc_Movement_SendAsset()
 31.05.17         *
 25.05.17         *
 16.05.17         *
 30.03.17         *
*/

-- тест
-- SELECT * FROM gpReport_SupplyBalance (inStartDate:= '01.05.2017', inEndDate:= '30.05.2017', inUnitId:= 8455, inGoodsGroupId:= 1941, inJuridicalId:= 0, inSession := '5'); -- Склад специй
