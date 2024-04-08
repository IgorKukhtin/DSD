-- Function: gpReport_Remains_Asset()

DROP FUNCTION IF EXISTS gpReport_Remains_Asset (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Remains_Asset(
    IN inStartDate          TDateTime , --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE  (AccountId Integer
             , ContainerId_count Integer
             , ContainerId Integer
             , LocationId Integer
             , GoodsId Integer
             , PartionGoodsId Integer
             , CountStart     TFloat
              )
AS
$BODY$
   DECLARE vbIsAssetTo Boolean;
   DECLARE vbIsCLO_Member Boolean;
   DECLARE vbIsSummIn Boolean;
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inStartDate, NULL, NULL, NULL, vbUserId);

    -- таблица -
    CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;

    -- группа подразделений или подразделение или место учета (МО, Авто)
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
              SELECT tmp.LocationId, tmp.DescId, tmpDesc.ContainerDescId
              FROM (SELECT zc_Juridical_Basis() AS LocationId, zc_ContainerLinkObject_Unit() AS DescId
                   UNION ALL
                    SELECT Object.Id AS LocationId, zc_ContainerLinkObject_Unit() AS DescId FROM Object WHERE Object.DescId = zc_Object_Unit()
                   UNION ALL
                    SELECT Object.Id, zc_ContainerLinkObject_Member() AS DescId FROM Object WHERE Object.DescId = zc_Object_Member()
                   ) AS tmp
                   LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId) AS tmpDesc ON 1 = 1
             ;
    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpLocation;

    vbIsCLO_Member:= EXISTS (SELECT 1 FROM _tmpLocation WHERE DescId <> zc_ContainerLinkObject_Unit());

    vbIsAssetTo:= TRUE;
    
       -- таблица -
    CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, GoodsId Integer, PartionGoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;

             WITH tmpAccount AS (/*SELECT View_Account.AccountGroupId, View_Account.AccountId
                                 FROM (SELECT zc_Enum_AccountGroup_10000()  AS AccountGroupId
                                      ) AS tmp
                                      INNER JOIN Object_Account_View AS View_Account ON View_Account.AccountGroupId = tmp.AccountGroupId
                              */SELECT View_Account.AccountGroupId, View_Account.AccountId
                                 FROM Object_Account_View AS View_Account
                                 WHERE View_Account.AccountId IN (zc_Enum_Account_10101(), zc_Enum_Account_10201())
                                 )
             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT tmp.LocationId, tmp.ContainerDescId, tmp.ContainerId_count, tmp.ContainerId_begin, tmp.GoodsId, tmp.AccountId, tmp.AccountGroupId, tmp.Amount
                FROM
               (SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN ContainerLinkObject.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , ContainerLinkObject.ContainerId AS ContainerId_begin
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN COALESCE (Container.ObjectId, 0) ELSE COALESCE (CLO_Goods.ObjectId, 0) END AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                                 THEN zc_Enum_AccountGroup_110000() -- Транзит
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , Container.Amount 
                     , _tmpLocation.DescId    AS Value1_ch
                     , CLO_Member.ContainerId AS Value2_ch
                FROM _tmpLocation
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                   AND ContainerLinkObject.DescId = _tmpLocation.DescId
                     INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                               AND _tmpLocation.ContainerDescId IN (zc_Container_Summ(), zc_Container_SummAsset())
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset())
                     LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = CASE WHEN vbIsCLO_Member = TRUE THEN Container.Id ELSE NULL END
                                                                AND CLO_Member.DescId = zc_ContainerLinkObject_Member()

                     LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = ContainerLinkObject.ContainerId
                                                                 AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = ContainerLinkObject.ContainerId
                                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                     LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                WHERE (Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR tmpAccount.AccountGroupId = zc_Enum_AccountGroup_10000())

               ) AS tmp
                WHERE ((tmp.Value1_ch <> zc_ContainerLinkObject_Member() AND tmp.Value2_ch IS NULL)
                    OR tmp.Value1_ch = zc_ContainerLinkObject_Member())
               ;


    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListContainer;

    -- все ContainerId
    INSERT INTO _tmpContainer (ContainerDescId, ContainerId_count, ContainerId_begin, LocationId, GoodsId, PartionGoodsId, AccountId, AccountGroupId, Amount)
       SELECT _tmpListContainer.ContainerDescId
            , _tmpListContainer.ContainerId_count
            , _tmpListContainer.ContainerId_begin
            , CASE WHEN _tmpListContainer.LocationId = 0 THEN COALESCE (CLO_Unit.ObjectId, 0) ELSE _tmpListContainer.LocationId END AS LocationId
            , _tmpListContainer.GoodsId
            , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
            , _tmpListContainer.AccountId
            , _tmpListContainer.AccountGroupId
            , _tmpListContainer.Amount
       FROM _tmpListContainer

            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpListContainer.ContainerId_begin
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

            LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpListContainer.ContainerId_begin
                                                     AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
       ;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpContainer;
   -- Результат
    RETURN QUERY
          WITH 

              tmpMIContainer AS (SELECT _tmpContainer.ContainerDescId
                                       , CASE WHEN TRUE /*inIsInfoMoney*/ = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN TRUE /*inIsInfoMoney*/ = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , _tmpContainer.LocationId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                         -- ***REMAINS***
                                       , -1 * SUM (MIContainer.Amount) AS RemainsStart

                                  FROM _tmpContainer
                                       INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                      AND MIContainer.OperDate >= inStartDate

                                       LEFT JOIN MovementBoolean AS MovementBoolean_HistoryCost
                                                                 ON MovementBoolean_HistoryCost.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_HistoryCost.DescId = zc_MovementBoolean_HistoryCost()
                                       LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                                 ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                                AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()

                                  GROUP BY _tmpContainer.ContainerDescId
                                         , CASE WHEN TRUE /*inIsInfoMoney*/ = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END
                                         , CASE WHEN TRUE /*inIsInfoMoney*/ = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                  HAVING                                             
                                         -- ***REMAINS***
                                       SUM (MIContainer.Amount) <> 0 -- AS RemainsStart

                                 UNION ALL
                                  SELECT _tmpContainer.ContainerDescId
                                       , CASE WHEN TRUE /*inIsInfoMoney*/ = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN TRUE /*inIsInfoMoney*/ = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , _tmpContainer.LocationId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                         -- ***REMAINS***
                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                  FROM _tmpContainer AS _tmpContainer
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                     AND MIContainer.OperDate > inStartDate

                                  GROUP BY _tmpContainer.ContainerDescId
                                         , _tmpContainer.ContainerId_count
                                         , _tmpContainer.ContainerId_begin
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                         , _tmpContainer.Amount
                                  HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                 )

         -- Результат
         SELECT (tmpMIContainer_all.AccountId)       AS AccountId
              , tmpMIContainer_all.ContainerId_count AS ContainerId_count
              , tmpMIContainer_all.ContainerId_begin AS ContainerId
              , tmpMIContainer_all.LocationId
              , tmpMIContainer_all.GoodsId
              , tmpMIContainer_all.PartionGoodsId

              , SUM (CASE WHEN tmpMIContainer_all.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN tmpMIContainer_all.RemainsStart ELSE 0 END) :: TFloat AS CountStart

         FROM tmpMIContainer AS tmpMIContainer_all
         GROUP BY tmpMIContainer_all.AccountId 
                , tmpMIContainer_all.ContainerId_count
                , tmpMIContainer_all.ContainerId_begin
                , tmpMIContainer_all.LocationId
                , tmpMIContainer_all.GoodsId
                , tmpMIContainer_all.PartionGoodsId
         HAVING SUM (CASE WHEN tmpMIContainer_all.ContainerDescId IN (zc_Container_Count(), zc_Container_CountAsset()) THEN tmpMIContainer_all.RemainsStart ELSE 0 END) > 0
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.09.20         *
*/

/*
SELECT * FROM gpReport_Remains_Asset(inStartDate := '01.09.2020':: TDateTime, inSession := zfCalc_UserAdmin():: TVarChar ) as tmp
LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = tmp.LocationId
--LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = tmp.AssetToId
order by 4,5
*/