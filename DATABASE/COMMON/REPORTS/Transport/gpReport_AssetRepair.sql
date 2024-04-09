-- Function: gpReport_AssetRepair ()  Ремонт оборудования

DROP FUNCTION IF EXISTS gpReport_AssetRepair (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_AssetRepair(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   , -- подразделение
    IN inAssetId       Integer   , --
    IN inIsMovement    Boolean   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, MovementDescName TVarChar
             , AssetId Integer, AssetCode Integer, AssetName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, DescName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , UnitId Integer, UnitName TVarChar
             , BranchId Integer, BranchName TVarChar
             , Amount TFloat, Price TFloat, Summa TFloat, SummaLoss TFloat, SummaService TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

-- zc_Movement_Loss - zc_MovementLinkObject_To + zc_Movement_Service - zc_MILinkObject_Asset - zc_ObjectLink_Asset_Car

/*
такие колонки обязательно:
- Дата документа;
- Вид документа;
- Номер документа;
- Примечание (из документа);
- Подразделение - поле "Подразделение" (Начисление услуг) или "Подразделение" со справочника "Физ лиц" по физ. лицу указанному в поле "Кому" док списания;
- Код/Наименование оборудования - "ОС/МНМА" (Списание) или "для Основного средства" (Начисление услуг);
- Товар/Наименование товара/Группа (все)/Группа товара - запчасти с документа списание
- Количество/Сумма (для Начисления услуг, Количество = 1)

*/
   RETURN QUERY
   WITH
   tmpPersonal AS (SELECT lfSelect.MemberId
                        , lfSelect.PersonalId
                        , lfSelect.UnitId
                    FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                   WHERE lfSelect.Ord = 1
                  )

 , tmpMovLoss AS (SELECT Movement.Id AS MovementId
                     , Movement.OperDate
                     , Movement.InvNumber
                     , Movement.DescId   AS MovementDescId
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                  AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                WHERE Movement.DescId = zc_Movement_Loss()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                )

 , tmpMI AS (SELECT MovementItem.*
                  , MILinkObject_Asset.ObjectId AS AssetId
             FROM MovementItem
                 INNER JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                                  AND (MILinkObject_Asset.ObjectId = inAssetId OR inAssetId = 0)
             WHERE MovementItem.MovementId IN (SELECT DISTINCT  tmpMovLoss.MovementId FROM tmpMovLoss)
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.isErased = FALSE
               AND COALESCE (MovementItem.Amount,0) <> 0
             )

 , tmpContainerLoss AS (SELECT MIContainer.MovementId               AS MovementId
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END) AS Amount
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END)  AS Summa
                             , ObjectFloat_Price.ValueData          AS Price
                             , MIContainer.WhereObjectId_Analyzer   AS CarId
                             , MIContainer.ObjectIntId_Analyzer     AS UnitId
                             , MIContainer.ObjectExtId_Analyzer     AS BranchId
                             , MIContainer.ObjectId_Analyzer        AS ObjectId
                        FROM MovementItemContainer AS MIContainer
                             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                           AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId

                             LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                   ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id
                                                  AND ObjectFloat_Price.DescId   = zc_ObjectFloat_PartionGoods_Price()
                        WHERE /*MIContainer.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                          AND */MIContainer.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          AND MIContainer.MovementDescId IN (zc_Movement_Loss())
                          AND MIContainer.ContainerId_analyzer IS NOT NULL
                        GROUP BY MIContainer.MovementId, MIContainer.MovementDescId
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.WhereObjectId_Analyzer 
                               , MIContainer.ObjectIntId_Analyzer 
                               , MIContainer.ObjectExtId_Analyzer
                               , MIContainer.ObjectId_Analyzer
                               , ObjectFloat_Price.ValueData
                       )

 , tmpMILos AS (SELECT CASE WHEN inIsMovement = TRUE THEN tmpMovLoss.MovementId ELSE 0    END AS MovementId
                     , CASE WHEN inIsMovement = TRUE THEN tmpMovLoss.OperDate   ELSE NULL END AS OperDate
                     , CASE WHEN inIsMovement = TRUE THEN tmpMovLoss.InvNumber  ELSE ''   END AS InvNumber
                     , CASE WHEN inIsMovement = TRUE THEN tmpMovLoss.MovementDescId ELSE 0 END AS MovementDescId
                     , COALESCE (ObjectLink_Car_Unit.ChildObjectId, tmpPersonal.UnitId)     AS UnitId  --для  авто или физ.лица
                     --, CASE WHEN inIsMovement = TRUE THEN MovementItem.ObjectId ELSE 0 END     AS ObjectId
                     , MovementItem.ObjectId     AS ObjectId
                     , MovementItem.AssetId
                     , COALESCE (tmpContainerLoss.Amount,0)      AS Amount
                     , tmpContainerLoss.Summa                    AS Summa
                     , MovementString_Comment.ValueData          AS Comment
                FROM tmpMovLoss
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = tmpMovLoss.MovementId
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                     LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                          ON ObjectLink_Car_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                         AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                     LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = MovementLinkObject_To.ObjectId

                     INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = tmpMovLoss.MovementId

                     LEFT JOIN tmpContainerLoss ON tmpContainerLoss.MovementId = tmpMovLoss.MovementId
                                               AND tmpContainerLoss.ObjectId = MovementItem.ObjectId

                     LEFT JOIN MovementString AS MovementString_Comment
                                              ON MovementString_Comment.MovementId = tmpMovLoss.MovementId
                                             AND MovementString_Comment.DescId = zc_MovementString_Comment()
                )

 , tmpMIService AS (SELECT CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END          AS MovementId
                         , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE NULL END AS OperDate
                         , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END  AS InvNumber
                         , CASE WHEN inIsMovement = TRUE THEN Movement.DescId ELSE 0 END      AS MovementDescId
                         , MILinkObject_Unit.ObjectId         AS UnitId
                         --, CASE WHEN inIsMovement = TRUE THEN MILinkObject_InfoMoney.ObjectId ELSE 0 END AS ObjectId
                         , MILinkObject_InfoMoney.ObjectId AS ObjectId
                         , MILinkObject_Asset.ObjectId     AS AssetId
                         , COALESCE (MovementItem.Amount,0)*(-1) AS Summa
                         --, MIFloat_Price.ValueData         AS Price
                         , COALESCE (MIFloat_Count.ValueData,-1)*(-1) AS Amount -- количество
                         , MIString_Comment.ValueData        AS Comment
                    FROM Movement
                         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                         INNER JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                           ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                                          AND (MILinkObject_Asset.ObjectId = inAssetId OR inAssetId = 0)

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                          ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                          ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

                         LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                     ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Count.DescId = zc_MIFloat_Count()

                         LEFT JOIN MovementItemString AS MIString_Comment 
                                                      ON MIString_Comment.MovementItemId = MovementItem.Id
                                                     AND MIString_Comment.DescId = zc_MIString_Comment()

                    WHERE Movement.DescId = zc_Movement_Service()
                      AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
 
 -- 
 , tmpData AS (SELECT tmp.MovementId
                    , tmp.OperDate
                    , tmp.InvNumber
                    , tmp.MovementDescId
                    , tmp.UnitId
                    , tmp.ObjectId
                    , tmp.AssetId
                    , SUM (COALESCE (tmp.Amount,0))        AS Amount
                    , SUM (COALESCE (tmp.SummaLoss,0))     AS SummaLoss
                    , SUM (COALESCE (tmp.SummaService,0))  AS SummaService
                    , SUM (COALESCE (tmp.SummaLoss,0) + COALESCE (tmp.SummaService,0))  AS Summa
                    , STRING_AGG (tmp.Comment, ';') ::TVarChar AS Comment
               FROM (SELECT tmp.MovementId
                          , tmp.OperDate
                          , tmp.InvNumber
                          , tmp.MovementDescId
                          , tmp.UnitId
                          , tmp.ObjectId
                          , tmp.AssetId
                          , tmp.Comment
                          , tmp.Amount AS Amount
                          , tmp.Summa  AS SummaLoss
                          , 0          AS SummaService
                     FROM tmpMILos AS tmp
                    UNION ALL
                     SELECT tmp.MovementId
                          , tmp.OperDate
                          , tmp.InvNumber
                          , tmp.MovementDescId
                          , tmp.UnitId
                          , tmp.ObjectId
                          , tmp.AssetId
                          , tmp.Comment
                          , tmp.Amount AS Amount
                          , 0          AS SummaLoss
                          , tmp.Summa  AS SummaService
                     FROM tmpMIService AS tmp
                    ) AS tmp
               GROUP BY tmp.MovementId
                      , tmp.OperDate
                      , tmp.InvNumber
                      , tmp.MovementDescId
                      , tmp.UnitId
                      , tmp.ObjectId
                      , tmp.AssetId
               )

        --Результат
        SELECT tmpData.MovementId ::Integer
             , tmpData.OperDate   ::TDateTime
             , tmpData.InvNumber ::TVarChar
             , MovementDesc.ItemName ::TVarChar AS MovementDescName
             , Object_Asset.Id         AS AssetId
             , Object_Asset.ObjectCode AS AssetCode
             , Object_Asset.ValueData  AS AssetName

             , Object_Car.Id               AS CarId
             , Object_Car.ObjectCode       AS CarCode
             , Object_Car.ValueData        AS CarName
 
             , Object.Id               AS ObjectId
             , Object.ObjectCode       AS ObjectCode
             , Object.ValueData        AS ObjectName
             , ObjectDesc.ItemName     AS DescName

             , Object_GoodsGroup.Id           AS GoodsGroupId
             , Object_GoodsGroup.ValueData    AS GoodsGroupName
             , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

             , Object_Unit.Id           AS UnitId
             , Object_Unit.ValueData    AS UnitName
             , Object_Branch.Id         AS BranchId
             , Object_Branch.ValueData  AS BranchName
             , tmpData.Amount ::TFloat
             , CASE WHEN COALESCE (tmpData.Amount,0) <> 0 THEN tmpData.Summa / tmpData.Amount ELSE 0 END ::TFloat AS Price
             , tmpData.Summa        ::TFloat
             , tmpData.SummaLoss    ::TFloat
             , tmpData.SummaService ::TFloat
        FROM tmpData
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
     
            LEFT JOIN Object AS Object_Asset ON Object_Asset .Id = tmpData.AssetId
            LEFT JOIN Object ON Object.Id = tmpData.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData.ObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                   ON ObjectString_Goods_GroupNameFull.ObjectId = tmpData.ObjectId
                                  AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                                 ON ObjectLink_Asset_Car.ObjectId = tmpData.AssetId
                                AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_Asset_Car.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.21         *
*/

-- тест
-- SELECT * FROM gpReport_AssetRepair (inStartDate:= '01.01.2022', inEndDate:= '01.03.2022', inUnitId:=0, inAssetId:= 0, inIsMovement:= true, inSession:= zfCalc_UserAdmin());
