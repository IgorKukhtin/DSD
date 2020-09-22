-- Function: gpInsert_Movement_LossAsset_Auto()

DROP FUNCTION IF EXISTS gpInsert_Movement_LossAsset_Auto (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_LossAsset_Auto(
    IN inStartDate           TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_Movement_LossAsset_auto());

     -- таблица остатков всех ОС на дату
      CREATE TEMP TABLE _tmpData (ContainerId Integer, LocationId Integer, GoodsId Integer, CountStart TFloat, Summ_service TFloat) ON COMMIT DROP;
      INSERT INTO _tmpData (ContainerId, LocationId, GoodsId, CountStart, Summ_service)
       SELECT tmp.ContainerId
            , tmp.LocationId
            , tmp.GoodsId
            , tmp.CountStart
            , 0 AS Summ_service
       FROM gpReport_Remains_Asset(inStartDate := inStartDate, inSession := inSession) as tmp
       --WHERE tmp.GoodsId = 3354331
      ;

      -- вторая часть: ОС-услуги
      INSERT INTO _tmpData (ContainerId, LocationId, GoodsId, CountStart, Summ_service)
       SELECT Container.Id, CLO_Unit.ObjectId, CLO_Goods.ObjectId, 0 AS CountStart
            , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Summ_service
       FROM Container
            INNER JOIN ContainerLinkObject AS CLO_Goods
                                           ON CLO_Goods.ContainerId = Container.Id
                                          AND CLO_Goods.DescId      = zc_ContainerLinkObject_Goods()
            INNER JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id     = CLO_Goods.ObjectId
                                                 AND Object_InfoMoney.DescId = zc_Object_InfoMoney()
            LEFT JOIN ContainerLinkObject AS CLO_Unit
                                          ON CLO_Unit.ContainerId = Container.Id
                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
            /*LEFT JOIN ContainerLinkObject AS CLO_Car
                                          ON CLO_Car.ContainerId = Container.Id
                                         AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
            LEFT JOIN ContainerLinkObject AS CLO_Member
                                          ON CLO_Member.ContainerId = Container.Id
                                         AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()*/
            INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                           ON CLO_PartionGoods.ContainerId = Container.Id
                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
            /*LEFT JOIN ContainerLinkObject AS CLO_Asset
                                          ON CLO_Asset.ContainerId = Container.Id
                                         AND CLO_Asset.DescId      = zc_ContainerLinkObject_AssetTo()*/
            LEFT JOIN MovementItemContainer AS MIContainer
                                            ON MIContainer.ContainerId = Container.Id
                                           AND MIContainer.OperDate >= inStartDate
       WHERE Container.Amount <> 0
         AND Container.DescId = zc_Container_Summ()
       GROUP BY Container.Id, CLO_Unit.ObjectId, CLO_Goods.ObjectId, Container.Amount
       HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
      ;

     -- сохранили <Документ>
     PERFORM lpInsertUpdate_Movement_LossAsset_auto (ioId               := COALESCE (tmpMovement.MovementId,0) :: Integer
                                                   , inInvNumber        := COALESCE (tmpMovement.InvNumber, CAST (NEXTVAL ('Movement_LossAsset_seq') AS TVarChar))  :: TVarChar
                                                   , inOperDate         := inStartDate ::TDateTime
                                                   , inFromId           := COALESCE (tmpMovement.FromId, tmp.LocationId) :: Integer
                                                   , inToId             := 0       :: Integer
                                                   , inArticleLossId    := 5670650 -- Расх ОС забаланс
                                                   , inComment          := ''      :: TVarChar
                                                   , inisAuto           := TRUE    :: Boolean
                                                   , inUserId           := vbUserId :: Integer
                                                    )
     FROM (SELECT DISTINCT _tmpData.LocationId FROM _tmpData) AS tmp
         -- если вдруг уже созданы были документы
         FULL JOIN (SELECT Movement.Id                      AS MovementId
                         , Movement.Invnumber               AS Invnumber
                         , MovementLinkObject_From.ObjectId AS FromId
                    FROM Movement
                         INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                                   AND COALESCE (MovementBoolean_isAuto.ValueData, FALSE) = TRUE
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    WHERE Movement.DescId = zc_Movement_LossAsset()
                      AND Movement.OperDate = inStartDate
                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                    ) AS tmpMovement ON tmpMovement.FromId = tmp.LocationId;

     -- выбираем все созданные документы
      CREATE TEMP TABLE _tmpMovement (MovementId Integer, FromId Integer) ON COMMIT DROP;
      INSERT INTO  _tmpMovement (MovementId, FromId)
      SELECT Movement.Id                      AS MovementId
           , MovementLinkObject_From.ObjectId AS FromId
      FROM Movement
           INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                     AND COALESCE (MovementBoolean_isAuto.ValueData, FALSE) = TRUE
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
      WHERE Movement.DescId = zc_Movement_LossAsset()
        AND Movement.OperDate = inStartDate
        AND Movement.StatusId <> zc_Enum_Status_Erased()
        ;

     -- сохраняем строки
     PERFORM lpInsertUpdate_MovementItem_LossAsset (ioId          := COALESCE (tmpMI.Id, 0)  ::Integer
                                                  , inMovementId  := _tmpMovement.MovementId ::Integer
                                                  , inGoodsId     := _tmpData.GoodsId        ::Integer
                                                  , inAmount      := _tmpData.CountStart     ::TFloat
                                                  , inSumm        := _tmpData.Summ_service   ::TFloat
                                                  , inContainerId := _tmpData.ContainerId    ::Integer
                                                  , inUserId      := vbUserId                ::Integer
                                                  )
     FROM _tmpMovement
          INNER JOIN _tmpData ON _tmpData.LocationId = _tmpMovement.FromId
          LEFT JOIN (SELECT MovementItem.MovementId
                          , MovementItem.Id
                          , MovementItem.ObjectId AS GoodsId
                          , MIFloat_ContainerId.ValueData :: Integer AS ContainerId
                     FROM _tmpMovement
                         INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement.MovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                     ) AS tmpMI ON tmpMI.GoodsId     = _tmpData.GoodsId
                               AND tmpMI.ContainerId = _tmpData.ContainerId
                               AND tmpMI.MovementId  = _tmpMovement.MovementId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.09.20         *
*/

-- тест