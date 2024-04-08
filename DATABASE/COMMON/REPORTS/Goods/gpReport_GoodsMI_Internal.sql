-- Function: gpReport_GoodsMI_Internal ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Internal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_Internal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_Internal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_Internal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_Internal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Internal (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,
    IN inFromId       Integer   ,
    IN inToId         Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inPriceListId  Integer   ,
    IN inIsMO_all     Boolean   ,
    IN inIsComment    Boolean   , --показывать примечание
    IN inIsSubjectDoc Boolean   , --показывать основания Да/Нет
    IN inIsDateDoc    Boolean   , --показывать Дата док-та (да/нет)
    IN inIsInvNumber  Boolean   , --показывать № док док-та (да/нет)
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Name_Scale TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , PartionGoods TVarChar
             , LocationId Integer, LocationCode Integer, LocationName TVarChar, LocationItemName TVarChar
             , LocationId_by Integer, LocationCode_by Integer, LocationName_by TVarChar, LocationItemName_by TVarChar
             , ArticleLossCode Integer, ArticleLossName TVarChar
             , AmountOut TFloat, AmountOut_Weight TFloat, AmountOut_Sh TFloat, SummOut_zavod TFloat, SummOut_branch TFloat, SummOut_60000 TFloat
             , AmountIn TFloat, AmountIn_Weight TFloat, AmountIn_Sh TFloat,  SummIn_zavod TFloat, SummIn_branch TFloat, SummIn_60000 TFloat
             , Amount_Send_pl TFloat, Summ_ProfitLoss TFloat, Summ_ProfitLoss_loss TFloat, Summ_ProfitLoss_send TFloat
             , PriceOut_zavod TFloat, PriceOut_branch TFloat, PriceIn_zavod TFloat, PriceIn_branch TFloat
             , Price_PriceList TFloat, SummOut_PriceList TFloat
             , ProfitLossCode Integer, ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName TVarChar
             , ProfitLossName_All TVarChar
             , Comment TVarChar
             , SubjectDocName  TVarChar
             , BranchCode_from Integer, BranchName_from TVarChar, UnitCode_from Integer, UnitName_from TVarChar, PositionName_from TVarChar
             , BranchCode_to Integer, BranchName_to TVarChar, UnitCode_to Integer, UnitName_to TVarChar, PositionName_to TVarChar
             , OperDate  TDateTime, DayOfWeekName TVarChar, InvNumber TVarChar
             , AssetId Integer, AssetCode Integer, AssetName TVarChar
             , AssetId_two Integer, AssetCode_two Integer, AssetName_two TVarChar
             , myCount     Integer
             , Date_Insert TDateTime
              )
AS
$BODY$
 DECLARE vbUserId    Integer;
 DECLARE vbIsGroup   Boolean;
 DECLARE vbIsBranch  Boolean;
 DECLARE vbIsSummIn  Boolean;
BEGIN
      -- vbUserId:= CASE WHEN inSession = '' THEN 5 ELSE lpGetUserBySession (inSession) END;
      vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

      vbIsGroup:= (inSession = '');

      -- определяется уровень доступа
      vbIsBranch:= COALESCE (0 < (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), FALSE)
               -- Руководитель склад ГП Днепр
               AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 428386 )
      ;

      -- !!!определяется!!!
      vbIsSummIn:= -- Ограничение просмотра с/с
                   NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE AccessKeyId = zc_Enum_Process_AccessKey_NotCost() AND UserId = vbUserId)
                  ;

      -- Маховская М.В.
      IF vbUserId IN (439917)
         AND (inFromId <> 8451 -- ЦЕХ упаковки
           OR inToId   <> 8459 -- Розподільчий комплекс
             )
      THEN
          RAISE EXCEPTION 'Ошибка.В параметрах отчета может быть выбрано только От кого = <%> и Кому = <%>'
                         , lfGet_Object_ValueData_sh (8451)
                         , lfGet_Object_ValueData_sh (8459)
                          ;
      END IF;



     /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица -
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;
     END IF;*/


    -- Результат
    RETURN QUERY

     WITH tmpPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.UnitId
                               , lfSelect.PositionId
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                         )
          -- Ограничения по товару
        , _tmpGoods AS -- (GoodsId, MeasureId, Weight)
          (SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE inGoodsGroupId <> 0
          UNION
           SELECT Object.Id AS GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
             AND COALESCE (inGoodsGroupId, 0) = 0
          UNION
           SELECT Object.Id, 0 AS MeasureId, 0 AS Weight FROM Object
           WHERE Object.DescId = zc_Object_Fuel()
             AND COALESCE (inGoodsGroupId, 0) = 0
          )

        -- группа подразделений или подразделение или место учета (МО, Авто)
      , tmpFrom AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect WHERE inFromId > 0
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit() AND inFromId = 0 AND vbIsBranch = FALSE -- AND vbIsGroup = TRUE
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Member() AND vbIsBranch = FALSE AND (inIsMO_all = TRUE OR Id = inFromId) AND inDescId IN (zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_SendAsset())
                    UNION
                     SELECT Id AS UnitId FROM Object  WHERE DescId = zc_Object_Car() AND vbIsBranch = FALSE AND (inIsMO_all = TRUE OR Id = inFromId) AND inDescId IN (zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_SendAsset())
                    )
         , tmpTo AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect WHERE inToId > 0
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit() AND inToId = 0 AND inDescId <> zc_Movement_Loss() -- AND (vbIsGroup = TRUE OR inDescId = zc_Movement_Loss())
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Member() AND (inIsMO_all = TRUE OR Id = inToId) AND inDescId IN (/*zc_Movement_Loss(),*/ zc_Movement_Send(), zc_Movement_SendAsset())
                    UNION
                     SELECT Id AS UnitId FROM Object  WHERE DescId = zc_Object_Car() AND (inIsMO_all = TRUE OR Id = inToId) AND inDescId IN (/*zc_Movement_Loss(),*/ zc_Movement_Send(), zc_Movement_SendAsset())
                   )
     , _tmpUnit AS (SELECT tmpFrom.UnitId, COALESCE (tmpTo.UnitId, 0) AS UnitId_by, FALSE AS isActive FROM tmpFrom LEFT JOIN tmpTo ON tmpTo.UnitId > 0
                   UNION
                    SELECT tmpTo.UnitId, COALESCE (tmpFrom.UnitId, 0) AS UnitId_by, TRUE  AS isActive FROM tmpTo LEFT JOIN tmpFrom ON tmpFrom.UnitId > 0 WHERE vbIsBranch = FALSE
                   )

       -- Цены из прайса
     , tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                             , lfSelect.GoodsKindId AS GoodsKindId
                             , CASE WHEN TRUE = COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = inPriceListId AND OB.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()), FALSE)
                                      OR 0    = COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPriceListId AND ObjectFloat.DescId = zc_ObjectFloat_PriceList_VATPercent()), 0)
                                         THEN lfSelect.ValuePrice
                                    ELSE lfSelect.ValuePrice * (1 + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPriceListId AND ObjectFloat.DescId = zc_ObjectFloat_PriceList_VATPercent()), 0) / 100)
                               END AS Price_vat
                        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inEndDate) AS lfSelect
                       )
     , tmpSend_ProfitLoss AS (SELECT MIContainer.Id
                                   , MIContainer.MovementId
                                   , MIContainer.DescId
                                   , MIContainer.MovementItemId
                                   , MIContainer.ContainerId
                                   , MIContainer.isActive, MIContainer.WhereObjectId_analyzer, MIContainer.ObjectExtId_Analyzer
                                   , MIContainer.ObjectId_analyzer
                                   , MIContainer.ObjectIntId_Analyzer
                                   , MIContainer.AccountId
                                   , MIContainer.ContainerId_Analyzer

                                   , MIContainer.Amount
                                   , MIContainer.AnalyzerId

                              FROM MovementItemContainer AS MIContainer
                                   INNER JOIN _tmpUnit ON _tmpUnit.UnitId   = MIContainer.WhereObjectId_analyzer
                                                      AND _tmpUnit.isActive = MIContainer.isActive
                              WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                                AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                                AND MIContainer.isActive = FALSE
                                AND MIContainer.ParentId IS NULL
                                AND inDescId = zc_Movement_Loss()
                                AND COALESCE (MIContainer.AccountId, 0) NOT IN (12102, zc_Enum_Account_100301()) -- Прибыль текущего периода
                             )
  , tmpSend_ProfitLoss_mi AS (SELECT tmp.Id
                                   , MovementItem.Amount
                                   , MILinkObject_Asset.ObjectId     AS AssetId
                                   , 0 AS AssetId_two
                                   --, MILinkObject_Asset_two.ObjectId AS AssetId_two
                              FROM (SELECT MAX(tmpSend_ProfitLoss.Id) AS Id, tmpSend_ProfitLoss.MovementItemId, tmpSend_ProfitLoss.MovementId FROM tmpSend_ProfitLoss GROUP BY tmpSend_ProfitLoss.MovementItemId, tmpSend_ProfitLoss.MovementId
                                   ) AS tmp
                                   LEFT JOIN MovementItem ON MovementItem.Id         = tmp.MovementItemId
                                                         AND MovementItem.MovementId = tmp.MovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                    ON MILinkObject_Asset.MovementItemId = tmp.MovementItemId
                                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                   /*LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                                    ON MILinkObject_Asset_two.MovementItemId = tmp.MovementItemId
                                                                   AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two() */
                             )

     , tmpCont AS (SELECT CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END AS ContainerId
                        , MIContainer.MovementId
                        , CASE WHEN MIContainer.isActive = FALSE THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END AS UnitId
                        , CASE WHEN MIContainer.isActive = TRUE  THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END AS UnitId_by
                        , MIContainer.ObjectId_analyzer                                               AS GoodsId
                        , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                        , COALESCE (MIContainer.AccountId, 0)                                         AS AccountId
                        , CASE WHEN inDescId = zc_Movement_Loss() THEN COALESCE (MIContainer.AnalyzerId, 0) ELSE 0 END AS ArticleLossId
                        , COALESCE (MIContainer.ContainerId_Analyzer, 0) AS ContainerId_Analyzer -- !!!для ОПиУ!!!

                        , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Count() THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut
                        , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Summ()  THEN -1 * MIContainer.Amount ELSE 0 END) AS SummOut

                        , SUM (CASE WHEN MIContainer.isActive = TRUE AND MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS AmountIn
                        , SUM (CASE WHEN MIContainer.isActive = TRUE AND MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END) AS SummIn

                        , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND (inDescId = zc_Movement_Loss() OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()) THEN CASE WHEN inDescId IN(zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_SendAsset()) THEN -1 ELSE 1 END * MIContainer.Amount ELSE 0 END) AS Summ_ProfitLoss
                        , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND (inDescId = zc_Movement_Loss() OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()) THEN CASE WHEN inDescId IN(zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_SendAsset()) THEN -1 ELSE 1 END * MIContainer.Amount ELSE 0 END) AS Summ_ProfitLoss_loss
                        , 0 AS Summ_ProfitLoss_send

                        , 0 AS Amount_Send_pl

                        , MILinkObject_Asset.ObjectId     AS AssetId
                        , MILinkObject_Asset_two.ObjectId AS AssetId_two

                   FROM MovementItemContainer AS MIContainer
                        INNER JOIN _tmpUnit ON _tmpUnit.UnitId    = MIContainer.WhereObjectId_analyzer
                                           AND (_tmpUnit.UnitId_by = COALESCE (MIContainer.ObjectExtId_Analyzer, 0) OR _tmpUnit.UnitId_by = 0)
                                           AND _tmpUnit.isActive  = MIContainer.isActive
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                         ON MILinkObject_Asset.MovementItemId = MIContainer.MovementItemId
                                                        AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                        --LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                         ON MILinkObject_Asset_two.MovementItemId = MIContainer.MovementItemId
                                                        AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
                        --LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = MILinkObject_Asset_two.ObjectId
                   WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                     AND MIContainer.MovementDescId = inDescId
                     AND COALESCE (MIContainer.AccountId,0) NOT IN (12102, zc_Enum_Account_100301 ()) -- Прибыль текущего периода
                   GROUP BY CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END
                          , CASE WHEN MIContainer.isActive = FALSE THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                          , CASE WHEN MIContainer.isActive = TRUE  THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                          , MIContainer.ObjectId_analyzer
                          , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END
                          , COALESCE (MIContainer.AccountId, 0)
                          , CASE WHEN inDescId = zc_Movement_Loss() THEN COALESCE (MIContainer.AnalyzerId, 0) ELSE 0 END
                          , MIContainer.ContainerId_Analyzer
                          , MIContainer.MovementId
                          , MILinkObject_Asset.ObjectId
                          , MILinkObject_Asset_two.ObjectId
                  UNION ALL
                   SELECT CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END AS ContainerId
                        , MIContainer.MovementId
                        , CASE WHEN MIContainer.isActive = FALSE THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END AS UnitId
                        , CASE WHEN MIContainer.isActive = TRUE  THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END AS UnitId_by
                        , MIContainer.ObjectId_analyzer AS GoodsId
                        , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                        , COALESCE (MIContainer.AccountId, 0)  AS AccountId
                        , 0 AS ArticleLossId
                        , COALESCE (MIContainer.ContainerId_Analyzer, 0) AS ContainerId_Analyzer -- !!!для ОПиУ!!!

                        , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Count() THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut
                        , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Summ()  THEN -1 * MIContainer.Amount ELSE 0 END) AS SummOut

                        , SUM (CASE WHEN MIContainer.isActive = TRUE AND MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS AmountIn
                        , SUM (CASE WHEN MIContainer.isActive = TRUE AND MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END) AS SummIn

                        , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND (inDescId = zc_Movement_Loss() OR MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()) THEN CASE WHEN inDescId IN (zc_Movement_Loss(), zc_Movement_Send(), zc_Movement_SendAsset()) THEN -1 ELSE 1 END * MIContainer.Amount ELSE 0 END) AS Summ_ProfitLoss
                        , 0 AS Summ_ProfitLoss_loss
                        , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss() THEN -1 * MIContainer.Amount ELSE 0 END) AS Summ_ProfitLoss_send

                        , SUM (COALESCE (tmpSend_ProfitLoss_mi.Amount, 0)) AS Amount_Send_pl

                        , tmpSend_ProfitLoss_mi.AssetId
                        , tmpSend_ProfitLoss_mi.AssetId_two
                   FROM tmpSend_ProfitLoss AS MIContainer
                        LEFT JOIN tmpSend_ProfitLoss_mi ON tmpSend_ProfitLoss_mi.Id = MIContainer.Id
                   GROUP BY CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END
                          , CASE WHEN MIContainer.isActive = FALSE THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                          , CASE WHEN MIContainer.isActive = TRUE  THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                          , MIContainer.ObjectId_analyzer
                          , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END
                          , COALESCE (MIContainer.AccountId, 0)
                          , CASE WHEN inDescId = zc_Movement_Loss() THEN COALESCE (MIContainer.AnalyzerId, 0) ELSE 0 END
                          , MIContainer.ContainerId_Analyzer
                          , MIContainer.MovementId
                          , tmpSend_ProfitLoss_mi.AssetId
                          , tmpSend_ProfitLoss_mi.AssetId_two
                   )

     , tmpMovementString AS (SELECT MovementString.*
                             FROM MovementString
                             WHERE MovementString.DescId = zc_MovementString_Comment()
                               AND MovementString.MovementId IN (SELECT DISTINCT tmpCont.MovementId FROM tmpCont)
                               AND inIsComment = TRUE
                             )

     , tmpSubjectDoc AS (SELECT MovementLinkObject_SubjectDoc.MovementId
                              , COALESCE (Object_SubjectDoc.ValueData,'') ::TVarChar AS SubjectDocName
                         FROM MovementLinkObject AS MovementLinkObject_SubjectDoc
                              LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId
                         WHERE MovementLinkObject_SubjectDoc.MovementId IN (SELECT DISTINCT tmpCont.MovementId FROM tmpCont)
                           AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
                           AND COALESCE (Object_SubjectDoc.ValueData,'') <> ''
                         )

     , tmpMI AS (SELECT tmpCont.ContainerId
                      , COALESCE (MovementString_Comment.ValueData, '') AS Comment
                      , tmpSubjectDoc.SubjectDocName
                      , tmpCont.UnitId
                      , tmpCont.UnitId_by
                      , tmpCont.GoodsId
                      , tmpCont.GoodsKindId
                      , tmpCont.AccountId
                      , tmpCont.ArticleLossId
                      , tmpCont.ContainerId_Analyzer

                      , CASE WHEN inIsDateDoc   = TRUE OR inIsInvNumber = TRUE THEN Movement.OperDate  ELSE NULL END ::TDateTime AS OperDate
                      , CASE WHEN inIsInvNumber = TRUE THEN Movement.InvNumber ELSE ''   END ::TVarChar  AS InvNumber
                      , CASE WHEN inIsInvNumber = TRUE THEN Movement.Id        ELSE 0    END ::Integer   AS MovementId

                      , tmpCont.AssetId
                      , tmpCont.AssetId_two

                      , SUM (tmpCont.AmountOut) AS AmountOut
                      , SUM (tmpCont.SummOut) AS SummOut

                      , SUM (tmpCont.AmountIn) AS AmountIn
                      , SUM (tmpCont.SummIn) AS SummIn

                      , SUM (tmpCont.Summ_ProfitLoss)      AS Summ_ProfitLoss
                      , SUM (tmpCont.Summ_ProfitLoss_loss) AS Summ_ProfitLoss_loss
                      , SUM (tmpCont.Summ_ProfitLoss_send) AS Summ_ProfitLoss_send

                      , SUM (tmpCont.Amount_Send_pl) AS Amount_Send_pl

                 FROM tmpCont
                      LEFT JOIN Movement ON Movement.Id = tmpCont.MovementId

                      LEFT JOIN tmpMovementString AS MovementString_Comment
                                                  ON MovementString_Comment.MovementId = tmpCont.MovementId
                      LEFT JOIN tmpSubjectDoc ON tmpSubjectDoc.MovementId = tmpCont.MovementId

                 GROUP BY tmpCont.ContainerId
                        , COALESCE (MovementString_Comment.ValueData, '')
                        , tmpCont.UnitId
                        , tmpCont.UnitId_by
                        , tmpCont.GoodsId
                        , tmpCont.GoodsKindId
                        , tmpCont.AccountId
                        , tmpCont.ArticleLossId
                        , tmpCont.ContainerId_Analyzer
                        , tmpSubjectDoc.SubjectDocName
                        , CASE WHEN inIsDateDoc   = TRUE OR inIsInvNumber = TRUE THEN Movement.OperDate  ELSE NULL END ::TDateTime
                        , CASE WHEN inIsInvNumber = TRUE THEN Movement.InvNumber ELSE ''   END ::TVarChar
                        , CASE WHEN inIsInvNumber = TRUE THEN Movement.Id        ELSE 0    END ::Integer
                        , tmpCont.AssetId
                        , tmpCont.AssetId_two
                )

 , tmpOperationGroup AS (SELECT tmpContainer.MovementId
                              , tmpContainer.ArticleLossId
                              , tmpContainer.ContainerId_Analyzer
                              , tmpContainer.UnitId
                              , tmpContainer.UnitId_by
                              , tmpContainer.GoodsId
                              , tmpContainer.GoodsKindId
                              , CLO_PartionGoods.ObjectId AS PartionGoodsId
                              , tmpContainer.OperDate
                              , tmpContainer.InvNumber
                              , tmpContainer.Comment
              
                              , tmpContainer.AssetId
                              , tmpContainer.AssetId_two
              
                              , STRING_AGG (DISTINCT tmpContainer.SubjectDocName, '; ') AS SubjectDocName
                              --, tmpContainer.SubjectDocName          AS SubjectDocName
              
                              , SUM (tmpContainer.AmountOut)         AS AmountOut
                              , SUM (tmpContainer.AmountOut_Weight)  AS AmountOut_Weight
                              , SUM (tmpContainer.AmountOut_sh)      AS AmountOut_sh
                              , SUM (tmpContainer.SummOut)           AS SummOut_zavod
                              , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) AS SummOut_branch
                              , SUM (CASE WHEN Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END)                AS SummOut_60000
              
                              , SUM (tmpContainer.AmountIn)          AS AmountIn
                              , SUM (tmpContainer.AmountIn_Weight)   AS AmountIn_Weight
                              , SUM (tmpContainer.AmountIn_sh)       AS AmountIn_sh
                              , SUM (tmpContainer.SummIn)            AS SummIn_zavod
                              , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_branch
                              , SUM (CASE WHEN Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn ELSE 0 END)                AS SummIn_60000
              
                              , SUM (tmpContainer.Summ_ProfitLoss)      AS Summ_ProfitLoss
                              , SUM (tmpContainer.Summ_ProfitLoss_loss) AS Summ_ProfitLoss_loss
                              , SUM (tmpContainer.Summ_ProfitLoss_send) AS Summ_ProfitLoss_send
              
                              , SUM (tmpContainer.Amount_Send_pl)       AS Amount_Send_pl
              
                         FROM (SELECT tmpMI.MovementId
                                    , tmpMI.ContainerId
                                    , tmpMI.UnitId
                                    , tmpMI.UnitId_by
                                    , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpMI.GoodsId END AS GoodsId
                                    , tmpMI.GoodsKindId
                                    , tmpMI.AccountId
                                    , tmpMI.ArticleLossId
                                    , tmpMI.ContainerId_Analyzer
                                    , tmpMI.Comment
                                    , tmpMI.SubjectDocName
                                    , tmpMI.AmountOut
                                    , tmpMI.AmountOut * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END AS AmountOut_Weight
                                    , CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpMI.AmountOut ELSE 0 END AS AmountOut_sh
                                    , tmpMI.SummOut
              
                                    , tmpMI.AmountIn
                                    , tmpMI.AmountIn * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END AS AmountIn_Weight
                                    , CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpMI.AmountIn ELSE 0 END AS AmountIn_sh
                                    , tmpMI.SummIn
              
                                    , tmpMI.Summ_ProfitLoss
                                    , tmpMI.Summ_ProfitLoss_loss
                                    , tmpMI.Summ_ProfitLoss_send
                                    , tmpMI.Amount_Send_pl
              
                                    , tmpMI.OperDate
                                    , tmpMI.InvNumber
              
                                    , tmpMI.AssetId
                                    , tmpMI.AssetId_two
              
                               FROM tmpMI
                                    INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI.GoodsId
                               ) AS tmpContainer
                               LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpContainer.AccountId
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                                            AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
              
                         GROUP BY tmpContainer.MovementId
                                , tmpContainer.ArticleLossId
                                , tmpContainer.ContainerId_Analyzer
                                , tmpContainer.UnitId
                                , tmpContainer.UnitId_by
                                , tmpContainer.GoodsId
                                , tmpContainer.GoodsKindId
                                , CLO_PartionGoods.ObjectId
                                , tmpContainer.Comment
                                , tmpContainer.OperDate
                                , tmpContainer.InvNumber
                                , CASE WHEN inIsSubjectDoc = TRUE THEN tmpContainer.SubjectDocName ELSE '' END
                                , tmpContainer.AssetId
                                , tmpContainer.AssetId_two
                        )

    -- !!!!!!!!!!!!!!!!!!!!!!!
    -- ANALYZE _tmpGoods;
    -- ANALYZE _tmpUnit;

    -- Результат
    SELECT Object_GoodsGroup.Id                       AS GoodsGroupId
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName 
         , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
         , Object_GoodsKind.Id                        AS GoodsKindId
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , Object_TradeMark.ValueData                 AS TradeMarkName
         , Object_PartionGoods.ValueData              AS PartionGoods

         , Object_Location.Id               AS LocationId
         , Object_Location.ObjectCode       AS LocationCode
         , Object_Location.ValueData        AS LocationName
         , ObjectDesc_Location.ItemName     AS LocationItemName
         , Object_Location_by.Id            AS LocationId_by
         , Object_Location_by.ObjectCode    AS LocationCode_by
         , Object_Location_by.ValueData     AS LocationName_by
         , ObjectDesc_Location_by.ItemName  AS LocationItemName_by
         , Object_ArticleLoss.ObjectCode    AS ArticleLossCode
         , Object_ArticleLoss.ValueData     AS ArticleLossName

         , tmpOperationGroup.AmountOut        :: TFloat AS AmountOut
         , tmpOperationGroup.AmountOut_Weight :: TFloat AS AmountOut_Weight
         , tmpOperationGroup.AmountOut_Sh     :: TFloat AS AmountOut_Sh
         , CASE WHEN vbIsBranch = TRUE THEN 0 ELSE tmpOperationGroup.SummOut_zavod END :: TFloat AS SummOut_zavod
         , tmpOperationGroup.SummOut_branch   :: TFloat AS SummOut_branch
         , CASE WHEN vbIsBranch = TRUE THEN 0 ELSE tmpOperationGroup.SummOut_60000 END :: TFloat AS SummOut_60000

         , tmpOperationGroup.AmountIn        :: TFloat AS AmountIn
         , tmpOperationGroup.AmountIn_Weight :: TFloat AS AmountIn_Weight
         , tmpOperationGroup.AmountIn_Sh     :: TFloat AS AmountIn_Sh
         , CASE WHEN vbIsBranch = TRUE OR vbIsSummIn = FALSE THEN 0 ELSE tmpOperationGroup.SummIn_zavod END :: TFloat AS SummIn_zavod
         , CASE WHEN vbIsSummIn = TRUE THEN tmpOperationGroup.SummIn_branch ELSE 0 END                      :: TFloat AS SummIn_branch
         , CASE WHEN vbIsBranch = TRUE OR vbIsSummIn = FALSE THEN 0 ELSE tmpOperationGroup.SummIn_60000 END :: TFloat AS SummIn_60000

         , tmpOperationGroup.Amount_Send_pl       :: TFloat AS Amount_Send_pl
         , tmpOperationGroup.Summ_ProfitLoss      :: TFloat AS Summ_ProfitLoss
         , tmpOperationGroup.Summ_ProfitLoss_loss :: TFloat AS Summ_ProfitLoss_loss
         , tmpOperationGroup.Summ_ProfitLoss_send :: TFloat AS Summ_ProfitLoss_send

         , CASE WHEN tmpOperationGroup.AmountOut <> 0 THEN tmpOperationGroup.SummOut_zavod  / tmpOperationGroup.AmountOut ELSE 0 END :: TFloat AS PriceOut_zavod
         , CASE WHEN tmpOperationGroup.AmountOut <> 0 THEN tmpOperationGroup.SummOut_branch / tmpOperationGroup.AmountOut ELSE 0 END :: TFloat AS PriceOut_branch
         , CASE WHEN tmpOperationGroup.AmountIn  <> 0 AND  vbIsSummIn = TRUE THEN tmpOperationGroup.SummIn_zavod   / tmpOperationGroup.AmountIn  ELSE 0 END :: TFloat AS PriceIn_zavod
         , CASE WHEN tmpOperationGroup.AmountIn  <> 0 AND  vbIsSummIn = TRUE THEN tmpOperationGroup.SummIn_branch  / tmpOperationGroup.AmountIn  ELSE 0 END :: TFloat AS PriceIn_branch

         , COALESCE (tmpPriceList_kind.Price_vat, tmpPriceList.Price_vat) ::TFloat AS Price_PriceList
         , (tmpOperationGroup.AmountOut * COALESCE (tmpPriceList_kind.Price_vat, tmpPriceList.Price_vat) ) :: TFloat AS SummOut_PriceList

         , View_ProfitLoss.ProfitLossCode, View_ProfitLoss.ProfitLossGroupName, View_ProfitLoss.ProfitLossDirectionName, View_ProfitLoss.ProfitLossName
         , View_ProfitLoss.ProfitLossName_all
         , tmpOperationGroup.Comment        :: TVarChar
         , tmpOperationGroup.SubjectDocName :: TVarChar

         , Object_Branch_from.ObjectCode  AS BranchCode_from
         , Object_Branch_from.ValueData   AS BranchName_from
         , Object_Unit_from.ObjectCode    AS UnitCode_from
         , Object_Unit_from.ValueData     AS UnitName_from
         , Object_Position_from.ValueData AS PositionName_from

         , Object_Branch_to.ObjectCode  AS BranchCode_to
         , Object_Branch_to.ValueData   AS BranchName_to
         , Object_Unit_to.ObjectCode    AS UnitCode_to
         , Object_Unit_to.ValueData     AS UnitName_to
         , Object_Position_to.ValueData AS PositionName_to

         , tmpOperationGroup.OperDate    ::TDateTime
         , tmpWeekDay.DayOfWeekName_Full ::TVarChar  AS DayOfWeekName
         , tmpOperationGroup.InvNumber   ::TVarChar

         , Object_Asset.Id                       AS AssetId
         , Object_Asset.ObjectCode               AS AssetCode
         , Object_Asset.ValueData                AS AssetName

         , Object_Asset_two.Id                   AS AssetId_two
         , Object_Asset_two.ObjectCode           AS AssetCode_two
         , Object_Asset_two.ValueData            AS AssetName_two

         , CASE WHEN vbIsGroup = TRUE
                THEN 0
                ELSE (SELECT COUNT(*)
                      FROM tmpOperationGroup AS find
                      WHERE find.GoodsId     = tmpOperationGroup.GoodsId
                        AND find.GoodsKindId = tmpOperationGroup.GoodsKindId
                        AND find.OperDate    = tmpOperationGroup.OperDate
                     )
           END :: Integer AS myCount
         , MovementDate_Insert.ValueData AS Date_Insert

     FROM tmpOperationGroup

          LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpOperationGroup.GoodsId
                                AND tmpPriceList.GoodsKindId Is NULL
          LEFT JOIN tmpPriceList AS tmpPriceList_kind
                                 ON tmpPriceList_kind.GoodsId = tmpOperationGroup.GoodsId
                                AND COALESCE (tmpPriceList_kind.GoodsKindId,0) = COALESCE (tmpOperationGroup.GoodsKindId,0)

          LEFT JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                        ON ContainerLO_ProfitLoss.ContainerId = tmpOperationGroup.ContainerId_analyzer
                                       AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
          LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = ContainerLO_ProfitLoss.ObjectId

          LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = tmpOperationGroup.ArticleLossId
          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.UnitId
          LEFT JOIN ObjectDesc AS ObjectDesc_Location ON ObjectDesc_Location.Id = Object_Location.DescId
          LEFT JOIN Object AS Object_Location_by ON Object_Location_by.Id = tmpOperationGroup.UnitId_by
          LEFT JOIN ObjectDesc AS ObjectDesc_Location_by ON ObjectDesc_Location_by.Id = Object_Location_by.DescId

          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                 ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()

          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_from
                               ON ObjectLink_Personal_Member_from.ObjectId = tmpOperationGroup.UnitId
                              AND ObjectLink_Personal_Member_from.DescId   = zc_ObjectLink_Personal_Member()
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_to
                               ON ObjectLink_Personal_Member_to.ObjectId = tmpOperationGroup.UnitId_by
                              AND ObjectLink_Personal_Member_to.DescId   = zc_ObjectLink_Personal_Member()

          LEFT JOIN tmpPersonal AS tmpPersonal_from ON tmpPersonal_from.MemberId = COALESCE (ObjectLink_Personal_Member_from.ChildObjectId, tmpOperationGroup.UnitId)
          LEFT JOIN tmpPersonal AS tmpPersonal_to   ON tmpPersonal_to.MemberId   = COALESCE (ObjectLink_Personal_Member_to.ChildObjectId,   tmpOperationGroup.UnitId_by)
          LEFT JOIN Object AS Object_Position_from ON Object_Position_from.Id = tmpPersonal_from.PositionId
          LEFT JOIN Object AS Object_Unit_from     ON Object_Unit_from.Id     = tmpPersonal_from.UnitId
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_from
                               ON ObjectLink_Unit_Branch_from.ObjectId = Object_Unit_from.Id
                              AND ObjectLink_Unit_Branch_from.DescId   = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_Branch_from ON Object_Branch_from.Id = ObjectLink_Unit_Branch_from.ChildObjectId

          LEFT JOIN Object AS Object_Position_to ON Object_Position_to.Id = tmpPersonal_to.PositionId
          LEFT JOIN Object AS Object_Unit_to     ON Object_Unit_to.Id     = tmpPersonal_to.UnitId
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_to
                               ON ObjectLink_Unit_Branch_to.ObjectId = Object_Unit_to.Id
                              AND ObjectLink_Unit_Branch_to.DescId   = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_Branch_to ON Object_Branch_to.Id = ObjectLink_Unit_Branch_to.ChildObjectId

          LEFT JOIN zfCalc_DayOfWeekName (tmpOperationGroup.OperDate) AS tmpWeekDay ON tmpOperationGroup.OperDate IS NOT NULL --1=1

          LEFT JOIN Object AS Object_Asset     ON Object_Asset.Id     = tmpOperationGroup.AssetId
          LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = tmpOperationGroup.AssetId_two

          LEFT JOIN MovementDate AS MovementDate_Insert ON MovementDate_Insert.MovementId = tmpOperationGroup.MovementId
                                                       AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
         ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.22         * AssetId, AssetId_two
 17.12.21         *
 29.04.20         * zc_Movement_SendAsset()
 13.02.20         *
 18.12.19         * add цена по виду
 30.01.19         * add Comment
 12.08.15                                        * all
 19.07.15         *
*/

-- тест
--
/*
 SELECT * FROM gpReport_GoodsMI_Internal (
  inStartDate:= '12.02.2020'::TDateTime
, inEndDate:= '12.02.2020'::TDateTime
, inDescId:= zc_Movement_Send()
, inFromId:= 0, inToId:= 0
, inGoodsGroupId:= 0
, inPriceListId:= 0
, inIsMO_all:= FALSE
, inIsComment:= true
, inIsSubjectDoc:= FALSE
, inIsDateDoc:= true
, inIsInvNumber:= true
, inSession := zfCalc_UserAdmin()); -- Склад Реализации

*/