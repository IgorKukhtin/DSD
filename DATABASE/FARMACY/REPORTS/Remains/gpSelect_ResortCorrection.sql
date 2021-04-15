-- Function:  gpSelect_ResortCorrection

DROP FUNCTION IF EXISTS gpSelect_ResortCorrection (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ResortCorrection (
  inContainerId  Integer,
  inContainerPDId  Integer,
  inSession TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbUnitId           Integer;
  DECLARE vbContainerRestId  Integer;
  DECLARE vbMICID            Integer;

  DECLARE vbAmount           TFloat;
  DECLARE vbAmountRest       TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Исправление пересортов по партии вам запрещено, обратитесь к системному администратору';
   END IF;
   
   IF COALESCE (inContainerId, 0) = 0 
   THEN
      RAISE EXCEPTION 'Не указан контейнер.';
   END IF;


   IF COALESCE (inContainerPDId, 0) <> 0 
   THEN
     PERFORM lpUpdate_Container_CountPartionDate(inContainerPDId := PD.ContainerPDId, inDelta := PD.Amount - PD.AmountPD)
     FROM (
      WITH tmpContainerPD AS (SELECT Container.ParentId,
                                     SUM(Container.Amount)   AS Amount,
                                     COUNT(*)::Integer       AS CountPD,
                                     Max(Container.Id)       AS ContainerId
                              FROM Container
                              WHERE Container.DescId = zc_Container_CountPartionDate()
                                AND Container.ParentId = inContainerId
                              GROUP BY Container.ParentId)
                       
      SELECT Container.Id                      AS ContainerId,
             Container.WhereObjectId           AS UnitID,
             Container.ObjectId                AS GoodsId,
             

             Container.Amount::TFloat          AS Amount,
             0::TFloat                         AS AmountRest,

             tmpContainerPD.Amount::TFloat      AS AmountPD,
             tmpContainerPD.CountPD             AS CountPD,
             tmpContainerPD.ContainerId         AS ContainerPDId 

      FROM Container

         INNER JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.Id

      WHERE Container.DescId = zc_Container_Count()
        AND Container.Amount <> tmpContainerPD.Amount
        AND Container.ID = inContainerId) AS PD
      ;
   
   ELSE

     SELECT Container.ObjectId, Container.WhereObjectId, Container.Amount
     INTO vbGoodsId, vbUnitId, vbAmount
     FROM Container
     WHERE Container.DescId = zc_Container_Count()
       AND Container.Id = inContainerId;

     IF COALESCE (vbAmount, 0) >= 0
     THEN
        RAISE EXCEPTION 'Ошибка. Остаток по партии должен быть меньше неля.';
     END IF;

     IF NOT EXISTS(SELECT Container.Id
                   FROM Container
                   WHERE Container.DescId = zc_Container_Count()
                     AND Container.ObjectId = vbGoodsId
                     AND Container.WhereObjectId = vbUnitId
                     AND Container.Amount > 0)
     THEN
        RAISE EXCEPTION 'Ошибка. Нет остатка для закрытия пересорта.';
     END IF;

       -- Если есть партия куда перебросить целеком берем ее
     IF EXISTS(SELECT 1 FROM Container
               WHERE Container.DescId = zc_Container_Count()
                 AND Container.ObjectId = vbGoodsId
                 AND Container.WhereObjectId = vbUnitId
                 AND (Container.Amount + vbAmount) >= 0)
     THEN

       SELECT MIN(Container.Id)
       INTO vbContainerRestId
       FROM Container
       WHERE Container.DescId = zc_Container_Count()
         AND Container.ObjectId = vbGoodsId
         AND Container.WhereObjectId = vbUnitId
         AND (Container.Amount + vbAmount) >= 0;

     ELSE

       -- Если нет партии куда перебросить целеком берем остаток по свмой старой партии

       SELECT Container.Id, - Container.Amount
       INTO vbContainerRestId, vbAmount
       FROM Container
       WHERE Container.DescId = zc_Container_Count()
         AND Container.ObjectId = vbGoodsId
         AND Container.WhereObjectId = vbUnitId
         AND Container.Amount > 0
       ORDER BY Container.Id
       LIMIT 1;

     END IF;

     IF COALESCE (vbContainerRestId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка. Нет остатка для закрытия пересорта.';
     END IF;


     IF EXISTS(SELECT 1 FROM MovementItemContainer
               WHERE MovementItemContainer.ContainerId = inContainerId
                 AND MovementItemContainer.Amount = vbAmount)
     THEN

       SELECT MovementItemContainer.Id
       INTO vbMICID
       FROM MovementItemContainer
       WHERE MovementItemContainer.ContainerId = inContainerId
         AND MovementItemContainer.Amount = vbAmount;


       UPDATE MovementItemContainer SET ContainerId = vbContainerRestId
       WHERE  MovementItemContainer.Id = vbMICID;

     ELSEIF EXISTS(SELECT 1 FROM MovementItemContainer
               WHERE MovementItemContainer.ContainerId = inContainerId
                 AND MovementItemContainer.Amount < 0
                 AND MovementItemContainer.Amount > vbAmount)
     THEN

       SELECT MAX(MovementItemContainer.Id)
       INTO vbMICID
       FROM MovementItemContainer
       WHERE MovementItemContainer.ContainerId = inContainerId
         AND MovementItemContainer.Amount < 0
         AND MovementItemContainer.Amount > vbAmount;


       UPDATE MovementItemContainer SET ContainerId = vbContainerRestId
       WHERE  MovementItemContainer.Id = vbMICID;

     ELSEIF EXISTS(SELECT 1 FROM MovementItemContainer
               WHERE MovementItemContainer.ContainerId = inContainerId
                 AND MovementItemContainer.Amount < vbAmount)
     THEN

       SELECT MAX(MovementItemContainer.Id)
       INTO vbMICID
       FROM MovementItemContainer
       WHERE MovementItemContainer.ContainerId = inContainerId
         AND MovementItemContainer.Amount < vbAmount;

       INSERT INTO MovementItemContainer (descid, movementid, containerid, amount, operdate, movementitemid, parentid,
              isactive, movementdescid, accountid, objectid_analyzer, whereobjectid_analyzer,
              containerid_analyzer, analyzerid, containerintid_analyzer,
              objectintid_analyzer, objectextid_analyzer, accountid_analyzer, price)
       SELECT descid, movementid, vbContainerRestId as containerid, vbAmount AS amount, operdate, movementitemid, parentid,
              isactive, movementdescid, accountid, objectid_analyzer, whereobjectid_analyzer,
              containerid_analyzer, analyzerid, containerintid_analyzer,
              objectintid_analyzer, objectextid_analyzer, accountid_analyzer, price
       FROM MovementItemContainer
       WHERE MovementItemContainer.ID = vbMICID;

       UPDATE MovementItemContainer SET Amount = Amount - vbAmount where MovementItemContainer.ID = vbMICID;

     ELSE
        RAISE EXCEPTION 'Ошибка. Нет вышло надо обратиться к программистам.';
     END IF;


     UPDATE Container SET Amount = COALESCE((SELECT Sum(MovementItemContainer.Amount)
                                             FROM MovementItemContainer
                                             WHERE MovementItemContainer.ContainerId = Container.Id ), 0)
     WHERE Container.Id in  (inContainerId, vbContainerRestId);
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.09.20                                                       *

*/

-- тест
-- select * from gpSelect_ResortCorrection(inContainerId := 7193395 ,  inSession := '3');