-- расчет цен для с/с из _tmpChild
with _tmpPrice_calc 
             AS (SELECT _tmpMaster.ContainerId
                      , _tmpMaster.AccountId
                      , _tmpMaster.UnitId
                      , _tmpMaster.GoodsId
                      , _tmpMaster.GoodsKindId
                      , _tmpMaster.JuridicalId_basis
                      , _tmpMaster.InfoMoneyId
                      , _tmpMaster.InfoMoneyId_Detail
                      , CASE WHEN _tmpMaster.isInfoMoney_80401 = TRUE
                                  THEN CASE WHEN (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) <> 0
                                                 THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                                            ELSE  0
                                       END
                             WHEN (((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) > 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) > 0)
                                OR ((_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount) < 0 AND (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) < 0))
                                 THEN (_tmpMaster.StartSumm + _tmpMaster.IncomeSumm + _tmpMaster.CalcSumm) / (_tmpMaster.StartCount + _tmpMaster.IncomeCount + _tmpMaster.calcCount)
                             ELSE 0
                        END AS OperPrice
, _tmpMaster.CalcSumm
                 FROM _tmpMaster_2024_07_b AS _tmpMaster
                 -- нет партий в расходе
                 -- WHERE _tmpMaster.ContainerId > 0
                )
, _tmpSumm_calc AS (SELECT tmpSumm_calc.ContainerId
                      --
                    , tmpSumm_calc.AccountId_master
                    , tmpSumm_calc.UnitId_master
                    , tmpSumm_calc.GoodsId_master
                    , tmpSumm_calc.GoodsKindId_master
                    , tmpSumm_calc.JuridicalId_basis_master
                    , tmpSumm_calc.InfoMoneyId_master
                    , tmpSumm_calc.InfoMoneyId_Detail_master

                    , CAST (SUM (tmpSumm_calc.CalcSumm) AS TFloat) AS CalcSumm
                    , CAST (SUM (tmpSumm_calc.CalcSumm_external) AS TFloat) AS CalcSumm_external

, OperPrice
, gr
, OperCount

               FROM (SELECT _tmpChild.MasterContainerId AS ContainerId
                            --
                          , _tmpChild.AccountId_master
                          , _tmpChild.UnitId_master
                          , _tmpChild.GoodsId_master
                          , _tmpChild.GoodsKindId_master
                          , _tmpChild.JuridicalId_basis_master
                          , _tmpChild.InfoMoneyId_master
                          , _tmpChild.InfoMoneyId_Detail_master
                            --
                          , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                          , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external
, _tmpPrice.OperPrice
, _tmpChild.ContainerId as gr
, _tmpChild.OperCount
                     FROM _tmpChild_2024_07 _tmpChild
                          -- Расчет цены
                          JOIN _tmpPrice_calc AS
                               _tmpPrice ON _tmpPrice.ContainerId = _tmpChild.ContainerId
                                        AND _tmpPrice.ContainerId > 0
                     -- !!!нет партий в приходе
                     -- WHERE _tmpChild.MasterContainerId > 0
                     --
                     -- Отбрасываем в том случае если сам в себя
                     -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

                     GROUP BY _tmpChild.MasterContainerId
                              --
                            , _tmpChild.AccountId_master
                            , _tmpChild.UnitId_master
                            , _tmpChild.GoodsId_master
                            , _tmpChild.GoodsKindId_master
                            , _tmpChild.JuridicalId_basis_master
                            , _tmpChild.InfoMoneyId_master
                            , _tmpChild.InfoMoneyId_Detail_master
, _tmpPrice.OperPrice
, _tmpChild.ContainerId
, _tmpChild.OperCount

                    UNION ALL
                     SELECT _tmpChild.MasterContainerId AS ContainerId
                            --
                          , _tmpChild.AccountId_master
                          , _tmpChild.UnitId_master
                          , _tmpChild.GoodsId_master
                          , _tmpChild.GoodsKindId_master
                          , _tmpChild.JuridicalId_basis_master
                          , _tmpChild.InfoMoneyId_master
                          , _tmpChild.InfoMoneyId_Detail_master
                            --
                          , CAST (SUM (_tmpChild.OperCount * _tmpPrice.OperPrice) AS TFloat) AS CalcSumm
                          , CAST (SUM (CASE WHEN _tmpChild.isExternal = TRUE THEN _tmpChild.OperCount * _tmpPrice.OperPrice ELSE 0 END) AS TFloat) AS CalcSumm_external

, _tmpPrice.OperPrice
, -1 * _tmpChild.GoodsId as gr
, _tmpChild.OperCount

                     FROM _tmpChild_2024_07 as _tmpChild
                          -- Расчет цены
                          JOIN _tmpPrice_calc AS
                              _tmpPrice ON _tmpPrice.AccountId          = _tmpChild.AccountId
                                        AND _tmpPrice.UnitId             = _tmpChild.UnitId
                                        AND _tmpPrice.GoodsId            = _tmpChild.GoodsId
                                        AND _tmpPrice.GoodsKindId        = _tmpChild.GoodsKindId
                                        AND _tmpPrice.JuridicalId_basis  = _tmpChild.JuridicalId_basis
                                        AND _tmpPrice.InfoMoneyId        = _tmpChild.InfoMoneyId
                                        AND _tmpPrice.InfoMoneyId_Detail = _tmpChild.InfoMoneyId_Detail
                                        AND _tmpPrice.ContainerId        = 0
and _tmpChild.ContainerId = 0
                     -- !!!нет партий в приходе
                     -- WHERE _tmpChild.MasterContainerId > 0
                     --
                     -- Отбрасываем в том случае если сам в себя
                     -- AND _tmpChild.MasterContainerId <> _tmpChild.ContainerId

                     GROUP BY _tmpChild.MasterContainerId
                              --
                            , _tmpChild.AccountId_master
                            , _tmpChild.UnitId_master
                            , _tmpChild.GoodsId_master
                            , _tmpChild.GoodsKindId_master
                            , _tmpChild.JuridicalId_basis_master
                            , _tmpChild.InfoMoneyId_master

                            , _tmpChild.InfoMoneyId_Detail_master

, _tmpPrice.OperPrice
, -1 * _tmpChild.GoodsId
, _tmpChild.OperCount

                    ) AS tmpSumm_calc
               GROUP BY tmpSumm_calc.ContainerId
                        --
                      , tmpSumm_calc.AccountId_master
                      , tmpSumm_calc.UnitId_master
                      , tmpSumm_calc.GoodsId_master
                      , tmpSumm_calc.GoodsKindId_master
                      , tmpSumm_calc.JuridicalId_basis_master
                      , tmpSumm_calc.InfoMoneyId_master
                      , tmpSumm_calc.InfoMoneyId_Detail_master

                      , tmpSumm_calc.OperPrice
                      , tmpSumm_calc.gr
                      , tmpSumm_calc.OperCount

              )

select * from _tmpSumm_calc where ContainerId = 2019143 
--  select * from _tmpPrice_calc where ContainerId = 2019143 
