-- Function: gpSelectGoods_Movement()
DROP FUNCTION IF EXISTS gpSelectGoods_Movement (TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelectGoods_Movement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectGoods_Movement(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inGoodsKindId        Integer   ,
    IN inGoodsId            Integer   ,

    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    --
    IN inLocationId         Integer,    --
    IN inInfoMoneyId        Integer,    --
    IN inPartionGoodsId     Integer,    --

    IN inDescSet            TVarChar  ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, DescId Integer, DescName TVarChar
             , AmountSumm TFloat
             , Comment TVarChar
             , PartnerCode Integer, PartnerName TVarChar

/*
             , JuridicalCode Integer, JuridicalName TVarChar, OKPO TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , ContractCode Integer, ContractNumber TVarChar
             , ContractTagName TVarChar, ContractStateKindCode Integer
             , PaidKindName TVarChar, AccountName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
*/
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDescId Integer;
   DECLARE vbIndex  Integer;
   DECLARE vbIsSaleRealDesc    Boolean;
   DECLARE vbIsServiceRealDesc Boolean;

   DECLARE vbObjectId_Constraint Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется уровень доступа
--     vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
     -- !!!меняется параметр!!!
--     IF vbObjectId_Constraint > 0 THEN inBranchId:= vbObjectId_Constraint; END IF;


     --
     vbIsSaleRealDesc:= FALSE;
     vbIsServiceRealDesc:= FALSE;

     -- таблица - MovementDesc - типы документов
     CREATE TEMP TABLE _tmpMovementDesc (DescId Integer) ON COMMIT DROP;
     -- парсим типы документов
     vbIndex := 1;
     WHILE split_part (inDescSet, ';', vbIndex) <> '' LOOP
         IF split_part (inDescSet, ';', vbIndex) = 'SaleRealDesc'
         THEN vbIsSaleRealDesc = TRUE;
         ELSE
             IF split_part (inDescSet, ';', vbIndex) = 'ServiceRealDesc'
             THEN vbIsServiceRealDesc = TRUE;
             ELSE
                 -- парсим
                 EXECUTE 'SELECT ' || split_part (inDescSet, ';', vbIndex) INTO vbDescId;
                 -- добавляем то что нашли
                 INSERT INTO _tmpMovementDesc SELECT vbDescId;
             END IF;
         END IF;
         -- теперь следуюющий
         vbIndex := vbIndex + 1;
     END LOOP;


     -- Результат
     RETURN QUERY
       SELECT
             tmpMIContainer.MovementId      AS Id
           , tmpMIContainer.InvNumber
           , tmpMIContainer.OperDate
           , tmpMIContainer.MovementDescId  AS DescId
           , MovementDesc.ItemName
           , CAST(tmpMIContainer.AmountSumm AS TFloat) AS AmountSumm
           , MIString_Comment.ValueData     AS Comment

           , Object_Partner.ObjectCode      AS PartnerCode
           , Object_Partner.ValueData       AS PartnerName

       FROM (SELECT Movement.Id                         AS MovementId
                  , Movement.InvNumber
                  , Movement.OperDate
                  , Movement.DescId                     AS MovementDescId
                  , tmpContainer.ContainerId
                  , tmpContainer.GoodsId
                  , MAX (MIContainer.MovementItemId)    AS MovementItemId
                  , SUM (MIContainer.Amount)            AS AmountSumm
             FROM
            (SELECT Container.Id                              AS ContainerId
                  , Container.ObjectId                        AS GoodsId
             FROM Container
             WHERE Container.DescId = zc_Container_Count()
               AND (Container.ObjectId = inGoodsId OR COALESCE (inGoodsId, 0) = 0)
            ) AS tmpContainer

             INNER JOIN MovementItemContainer AS MIContainer
                                              ON MIContainer.ContainerId = tmpContainer.ContainerId
                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate

             INNER JOIN Movement ON Movement.Id = MIContainer.MovementId
             INNER JOIN _tmpMovementDesc ON _tmpMovementDesc.DescId = Movement.DescId
             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                              ON MILO_GoodsKind.MovementItemId = MIContainer.MovementItemId
                                             AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
--            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             --LEFT JOIN _tmpMovementDesc ON _tmpMovementDesc.DescId = Movement.DescId
             WHERE (MILO_GoodsKind.ObjectId = inGoodsKindId OR COALESCE (inGoodsKindId, 0) = 0)

             GROUP BY Movement.Id
                    , Movement.InvNumber
                    , Movement.OperDate
                    , Movement.DescId
                    , tmpContainer.ContainerId
                    , tmpContainer.GoodsId
            ) AS tmpMIContainer

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = tmpMIContainer.MovementId
                                        AND MovementLinkObject_Partner.DescId = CASE WHEN tmpMIContainer.MovementDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() WHEN tmpMIContainer.MovementDescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_Partner() END
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMIContainer.MovementDescId
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpMIContainer.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
      ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelectGoods_Movement (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.02.15                                                       *
 30.01.15                                                       *
*/

-- тест
-- SELECT * FROM gpSelectGoods_Movement (inStartDate:= '01.06.2014', inEndDate:= '06.06.2014', inGoodsKindId:= 0, inGoodsId:= 0, inDescSet:='', inSession:= zfCalc_UserAdmin())