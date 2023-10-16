-- Function: gpReport_OrderInternal_choice()

DROP FUNCTION IF EXISTS gpReport_OrderInternalPackRemains_deflection (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalPackRemains_deflection(
    IN inMovementId        Integer   , --
    IN inIsShowAll          Boolean   , -- свернуть и показать остатки  
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                   Integer
             , ContainerId          Integer
             , GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar
             , GoodsId_complete     Integer
             , GoodsCode_complete   Integer
             , GoodsName_complete   TVarChar
             , GoodsId_basis        Integer
             , GoodsCode_basis      Integer
             , GoodsName_basis      TVarChar
             , GoodsKindId          Integer
             , GoodsKindName        TVarChar
             , GoodsKindId_complete   Integer
             , GoodsKindName_complete TVarChar
             , MeasureName            TVarChar
             , MeasureName_complete   TVarChar
             , MeasureName_basis      TVarChar
             , GoodsGroupNameFull     TVarChar
             , isCheck_basis      Boolean
             , Remains_CEH        TFloat
             , Remains_CEH_Next   TFloat
             , Remains_CEH_all    TFloat
             , Remains_CEH_err    TFloat
             , Remains            TFloat
             , Remains_pack       TFloat
             , Remains_err        TFloat
             , RemainsRK          TFloat
             --
             , Remains_calc       TFloat
             , Remains_pack_calc  TFloat
             , Remains_CEH_calc   TFloat 
             , Remains_diff       TFloat
             , Remains_pack_diff  TFloat
             , Remains_CEH_diff   TFloat
             , RemainsAll_diff    TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbOperDate TDateTime;
   
BEGIN

    vbOperDate :=(SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);


     -- получааем  _Result_ChildTotal
     PERFORM lpSelect_MI_OrderInternalPackRemains (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inUserId:= vbUserId) ;


    -- остатки
    CREATE TEMP TABLE tmpContainer (ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, AmountRK_start TFloat, AmountPrIn TFloat, Amount_start_noUp TFloat) ON COMMIT DROP;
   
    -- Остатки кол-во для всех подразделений
    INSERT INTO tmpContainer (ContainerId, GoodsId, GoodsKindId, Amount_start, AmountRK_start, AmountPrIn, Amount_start_noUp)
       WITH -- хардкодим - ЦЕХ колбаса+дел-сы (производство)
            tmpUnit_CEH AS (SELECT UnitId, TRUE AS isContainer FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - Склады База + Склад Поклейки этикетки
          , tmpUnit_SKLAD   AS (SELECT lfSelect.UnitId, FALSE AS isContainer FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect
                                WHERE lfSelect.UnitId <> 9558031 -- Склад Неликвид
                               UNION
                                -- Склад Поклейки этикетки
                                SELECT 9073781 AS UnitId, FALSE AS isContainer
                               )
            -- Склад Реализации
          , tmpUnit_RK AS (SELECT 8459 AS UnitId)

            -- хардкодим - ВСЕ
          , tmpUnit_all   AS (SELECT UnitId, isContainer FROM tmpUnit_CEH UNION SELECT UnitId, isContainer FROM tmpUnit_SKLAD)
            -- хардкодим - товары ГП
          , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                              , Object_InfoMoney_View.InfoMoneyDestinationId
                              , Object_InfoMoney_View.InfoMoneyId
                         FROM Object_InfoMoney_View
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                         WHERE (Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция
                             OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30201()            -- Доходы + Мясное сырье + Мясное сырье
                             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                               )
                        )
       -- Результат - остатки товары ГП
       SELECT tmp.ContainerId
            , tmp.GoodsId
            , tmp.GoodsKindId
            , SUM (tmp.Amount_start + CASE WHEN tmp.ContainerId > 0 THEN tmp.Amount_next ELSE 0 END) AS Amount_start
            , SUM (tmp.AmountRK_start) AS AmountRK_start
            , SUM (tmp.AmountPrIn) AS AmountPrIn 
            
            , SUM (CASE WHEN tmp.GoodsKindId = zc_GoodsKind_Basis() AND COALESCE (tmp.Amount_start + CASE WHEN tmp.ContainerId > 0 THEN tmp.Amount_next ELSE 0 END,0) - COALESCE (tmp.AmountRK_start,0) >=0 
                        THEN COALESCE (tmp.Amount_start + CASE WHEN tmp.ContainerId > 0 THEN tmp.Amount_next ELSE 0 END,0) - COALESCE (tmp.AmountRK_start,0) 
                        ELSE 0 
                   END) AS  Amount_start_noUp
            
       FROM (SELECT CASE WHEN tmpUnit_all.isContainer = TRUE THEN Container.Id ELSE 0 END AS ContainerId
                  , Container.ObjectId                   AS GoodsId
                  , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                    -- 
                  , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_start
                    -- 
                  , CASE WHEN tmpUnit_RK.UnitId > 0 THEN Container.Amount ELSE 0 END - SUM (CASE WHEN tmpUnit_RK.UnitId > 0 THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS AmountRK_start
                    -- 
                  , SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount_next
                  , SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.isActive = TRUE
                               AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                               AND tmpUnit_CEH.UnitId > 0 AND tmpUnit_SKLAD.UnitId > 0
                                   THEN MIContainer.Amount
                              ELSE 0
                         END) AS AmountPrIn 
             FROM tmpGoods
                  INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                      AND Container.DescId   = zc_Container_Count()
                  INNER JOIN ContainerLinkObject AS CLO_Unit
                                                 ON CLO_Unit.ContainerId = Container.Id
                                                AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                  INNER JOIN tmpUnit_all ON tmpUnit_all.UnitId = CLO_Unit.ObjectId

                  LEFT JOIN ContainerLinkObject AS CLO_Account
                                                ON CLO_Account.ContainerId = Container.Id
                                               AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                  LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                ON CLO_GoodsKind.ContainerId = Container.Id
                                               AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()

                  LEFT JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.ContainerId = Container.Id
                                                 AND MIContainer.OperDate    >= vbOperDate

                  -- ЦЕХ колбаса+дел-сы
                  LEFT JOIN tmpUnit_CEH   ON tmpUnit_CEH.UnitId   = CLO_Unit.ObjectId
                  -- Склады База + Реализации
                  LEFT JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = CLO_Unit.ObjectId
                  -- Склад Реализации
                  LEFT JOIN tmpUnit_RK ON tmpUnit_RK.UnitId = CLO_Unit.ObjectId
                  

             WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
             GROUP BY CASE WHEN tmpUnit_all.isContainer = TRUE THEN Container.Id ELSE 0 END
                    , Container.ObjectId
                    , COALESCE (CLO_GoodsKind.ObjectId, 0)
                    , Container.Amount
                    , tmpUnit_RK.UnitId
             HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                 OR SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) <> 0
            ) AS tmp
       GROUP BY tmp.ContainerId
              , tmp.GoodsId
              , tmp.GoodsKindId
      ;


     RETURN QUERY
     WITH 
      --Данные из заявки
         tmpMI AS (SELECT _Result_ChildTotal.Id
                        , _Result_ChildTotal.ContainerId
                        , _Result_ChildTotal.GoodsId
                        , _Result_ChildTotal.GoodsCode
                        , _Result_ChildTotal.GoodsName
                        , _Result_ChildTotal.GoodsId_complete
                        , _Result_ChildTotal.GoodsCode_complete
                        , _Result_ChildTotal.GoodsName_complete
                        , _Result_ChildTotal.GoodsId_basis
                        , _Result_ChildTotal.GoodsCode_basis
                        , _Result_ChildTotal.GoodsName_basis
                        , _Result_ChildTotal.GoodsKindId
                        , _Result_ChildTotal.GoodsKindName
                        , _Result_ChildTotal.GoodsKindId_complete
                        , _Result_ChildTotal.GoodsKindName_complete
                        , _Result_ChildTotal.MeasureName
                        , _Result_ChildTotal.MeasureName_complete
                        , _Result_ChildTotal.MeasureName_basis
                        , _Result_ChildTotal.GoodsGroupNameFull
                        , _Result_ChildTotal.isCheck_basis
                        , _Result_ChildTotal.Remains_CEH
                        , _Result_ChildTotal.Remains_CEH_Next
                        , _Result_ChildTotal.Remains_CEH_err
                        , _Result_ChildTotal.Remains
                        , _Result_ChildTotal.Remains_pack
                        , _Result_ChildTotal.Remains_err
                        , _Result_ChildTotal.RemainsRK
                        , _Result_ChildTotal.ReceiptId
                        , _Result_ChildTotal.ReceiptCode
                        , _Result_ChildTotal.ReceiptName
                        , _Result_ChildTotal.ReceiptId_basis
                        , _Result_ChildTotal.ReceiptCode_basis
                        , _Result_ChildTotal.ReceiptName_basis
                        , _Result_ChildTotal.UnitId
                        , _Result_ChildTotal.UnitCode
                        , _Result_ChildTotal.UnitName
                        , _Result_ChildTotal.GoodsKindName_pf
                        , _Result_ChildTotal.GoodsKindCompleteName_pf
                        , _Result_ChildTotal.PartionDate_pf
                        , _Result_ChildTotal.PartionGoods_start
                        , _Result_ChildTotal.TermProduction
                   FROM _Result_ChildTotal
                   )

     , tmpData AS (SELECT *
                   FROM (-- результат - для SKLAD
                         SELECT tmp.MovementItemId
                              , tmp.ContainerId
                              , tmp.GoodsId
                              , tmp.GoodsKindId
                              , SUM (tmp.Remains_calc)      AS Remains_calc
                              , SUM (tmp.Remains_pack_calc) AS Remains_pack_calc
                              , SUM (tmp.Remains_CEH_calc)  AS Remains_CEH_calc
                             -- , SUM (tmp.Remains_calc_noUp) AS Remains_calc_noUp
                         FROM (SELECT COALESCE (tmpMI.Id, 0)                      AS MovementItemId
                                    , 0                                                       AS ContainerId
                                    , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                                    , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                                    --, COALESCE (tmpContainer.Amount_start, 0)                 AS Remains_calc
                                    , CASE WHEN COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) = zc_GoodsKind_Basis() 
                                           THEN CASE WHEN COALESCE (tmpContainer.Amount_start,0) - COALESCE (tmpContainer.AmountRK_start,0) >= 0 
                                                     THEN COALESCE (tmpContainer.Amount_start,0) - COALESCE (tmpContainer.AmountRK_start,0)
                                                     ELSE 0
                                                END                                             
                                           ELSE 0--COALESCE (tmpContainer.Amount_start, 0)
                                      END                                                     AS Remains_calc
                                    , CASE WHEN COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) <> zc_GoodsKind_Basis() 
                                           THEN COALESCE (tmpContainer.Amount_start, 0)                                            
                                           ELSE 0
                                      END                                                     AS Remains_pack_calc
                                    , 0                                                       AS Remains_CEH_calc
                                   -- , COALESCE (tmpContainer.Amount_start_noUp, 0)            AS Remains_calc_noUp
                               FROM (SELECT * FROM tmpContainer WHERE tmpContainer.ContainerId = 0
                                    ) AS tmpContainer
                                    FULL JOIN (SELECT * FROM tmpMI WHERE tmpMI.ContainerId = 0
                                              ) AS tmpMI ON tmpMI.GoodsId     = tmpContainer.GoodsId
                                                        AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
                              ) AS tmp
                         GROUP BY tmp.MovementItemId
                                , tmp.ContainerId
                                , tmp.GoodsId
                                , tmp.GoodsKindId
                        UNION ALL
                         -- результат - для CEH
                         SELECT tmpMI.Id
                              , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
                              , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                              , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId 
                              , 0                                                       AS Remains_calc
                              , 0                                                       AS Remains_pack_calc 
                              , COALESCE (tmpContainer.Amount_start, 0)                 AS Remains_CEH_calc
                              --, COALESCE (tmpContainer.Amount_start_noUp, 0)            AS Remains_calc_noUp
                         FROM (SELECT * FROM tmpContainer WHERE tmpContainer.ContainerId > 0
                              ) AS tmpContainer
                              FULL JOIN (SELECT * FROM tmpMI WHERE tmpMI.ContainerId > 0
                                        ) AS tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId
                                     ) AS tmp
                   WHERE tmp.MovementItemId > 0
                  )    

       -- Результат
       SELECT
             tmpMI.Id
           , tmpMI.ContainerId
           , tmpMI.GoodsId
           , tmpMI.GoodsCode
           , tmpMI.GoodsName
           , tmpMI.GoodsId_complete
           , tmpMI.GoodsCode_complete
           , tmpMI.GoodsName_complete
           , tmpMI.GoodsId_basis
           , tmpMI.GoodsCode_basis
           , tmpMI.GoodsName_basis
           , tmpMI.GoodsKindId
           , tmpMI.GoodsKindName
           , tmpMI.GoodsKindId_complete
           , tmpMI.GoodsKindName_complete
           , tmpMI.MeasureName
           , tmpMI.MeasureName_complete
           , tmpMI.MeasureName_basis
           , tmpMI.GoodsGroupNameFull
           , tmpMI.isCheck_basis
           , tmpMI.Remains_CEH
           , tmpMI.Remains_CEH_Next
           , (COALESCE (tmpMI.Remains_CEH,0) + COALESCE (tmpMI.Remains_CEH_Next,0)) ::TFloat AS Remains_CEH_all
           , tmpMI.Remains_CEH_err
           , tmpMI.Remains
           , tmpMI.Remains_pack
           , tmpMI.Remains_err
           , tmpMI.RemainsRK
           --
           , tmpData.Remains_calc             ::TFloat
           , tmpData.Remains_pack_calc        ::TFloat
           , tmpData.Remains_CEH_calc         ::TFloat
          -- , tmpData.Remains_next_calc        ::TFloat
           --, tmpData.Remains_calc_noUp        ::TFloat
           
           
           , (COALESCE (tmpMI.Remains,0) - COALESCE (tmpData.Remains_calc,0))             ::TFloat  AS Remains_diff
           , (COALESCE (tmpMI.Remains_pack,0) - COALESCE (tmpData.Remains_pack_calc,0))   ::TFloat  AS Remains_pack_diff
           , ((COALESCE (tmpMI.Remains_CEH,0)+ COALESCE (tmpMI.Remains_CEH_Next,0)) - COALESCE (tmpData.Remains_CEH_calc ,0))  ::TFloat  AS Remains_CEH_diff
           , ((COALESCE (tmpMI.Remains,0) + COALESCE (tmpMI.Remains_pack,0) + COALESCE (tmpMI.Remains_CEH,0)+ COALESCE (tmpMI.Remains_CEH_Next,0))
             -( COALESCE (tmpData.Remains_calc,0) + COALESCE (tmpData.Remains_pack_calc,0) + COALESCE (tmpData.Remains_CEH_calc ,0)))  ::TFloat  AS RemainsAll_diff

       FROM tmpData
          LEFT JOIN tmpMI ON tmpMI.Id = tmpData.MovementItemId 
       WHERE (COALESCE (tmpData.Remains_calc,0) <> COALESCE (tmpMI.Remains,0)
             OR COALESCE (tmpData.Remains_CEH_calc,0) <> COALESCE (tmpMI.Remains_CEH,0)
             )
            OR inisShowAll = TRUE
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.23         *
*/

-- тест
--SELECT * FROM gpReport_OrderInternalPackRemains_deflection (inMovementId:= 26428963::integer , inIsShowAll := true::boolean, inSession:= zfCalc_UserAdmin()::tvarchar)