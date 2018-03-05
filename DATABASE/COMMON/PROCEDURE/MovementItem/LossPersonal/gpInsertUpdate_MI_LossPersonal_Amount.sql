-- Function: gpInsertUpdate_MI_LossPersonal_Amount ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_LossPersonal_Amount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_LossPersonal_Amount(
    IN inMovementId             Integer   , -- ключ Документа
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceDateId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossPersonal());

     -- определяем <Месяц начислений>
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));

     CREATE TEMP TABLE _tmpMI (MI_Id Integer, PersonalId Integer, InfoMoneyId Integer, UnitId Integer, BranchId Integer, PositionId Integer, PersonalServiceListId Integer, Amount TFloat, Comment TVarChar) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpContainer (PersonalId Integer, InfoMoneyId Integer, UnitId Integer, BranchId Integer, PositionId Integer, PersonalServiceListId Integer, Amount TFloat) ON COMMIT DROP;

          -- сохраненные строки документа
          INSERT INTO _tmpMI (MI_Id, PersonalId, InfoMoneyId, UnitId, BranchId, PositionId, PersonalServiceListId, Amount, Comment)
                        SELECT MovementItem.Id                                          AS MI_Id
                             , MovementItem.ObjectId                                    AS PersonalId
                             , COALESCE (MILinkObject_InfoMoney.ObjectId, 0)            AS InfoMoneyId
                             , COALESCE (MILinkObject_Unit.ObjectId, 0)                 AS UnitId
                             , COALESCE (MILinkObject_Branch.ObjectId, 0)               AS BranchId
                             , COALESCE (MILinkObject_Position.ObjectId, 0)             AS PositionId
                             , COALESCE (MILinkObject_PersonalServiceList.ObjectId, 0)  AS PersonalServiceListId
                             , MovementItem.Amount                                      AS Amount
                             , MIString_Comment.ValueData                               AS Comment
                        FROM MovementItem
                             LEFT JOIN MovementItemString AS MIString_Comment
                                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                                         AND MIString_Comment.DescId = zc_MIString_Comment()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                              ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                              ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                              ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                         ;

          -- Данные из Container
          INSERT INTO _tmpContainer (PersonalId, InfoMoneyId, UnitId, BranchId, PositionId, PersonalServiceListId, Amount)
            SELECT COALESCE (CLO_Personal.ObjectId, 0)            AS PersonalId
                 , COALESCE (CLO_InfoMoney.ObjectId, 0)           AS InfoMoneyId
                 , COALESCE (CLO_Unit.ObjectId, 0)                AS UnitId
                 , COALESCE (CLO_Branch.ObjectId, 0)              AS BranchId
                 , COALESCE (CLO_Position.ObjectId, 0)            AS PositionId
                 , COALESCE (CLO_PersonalServiceList.ObjectId, 0) AS PersonalServiceListId
                 , Container.Amount
            FROM Container
                 INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                ON CLO_ServiceDate.ContainerId = Container.Id
                                               AND CLO_ServiceDate.DescId   = zc_ContainerLinkObject_ServiceDate()
                                               AND CLO_ServiceDate.ObjectId = vbServiceDateId            --878019 --
                 INNER JOIN ContainerLinkObject AS CLO_Personal
                                                ON CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                               AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                               -- AND COALESCE (CLO_Personal.ObjectId, 0) <> 0

                 INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                ON CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                               AND CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                               -- AND COALESCE (CLO_InfoMoney.ObjectId, 0) <> 0
                 INNER JOIN ContainerLinkObject AS CLO_Unit
                                                ON CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                               AND CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                               -- AND COALESCE (CLO_Unit.ObjectId, 0) <> 0
                 INNER JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.DescId      = zc_ContainerLinkObject_Branch()
                                               AND CLO_Branch.ContainerId = CLO_ServiceDate.ContainerId
                                               -- AND COALESCE (CLO_Branch.ObjectId, 0) <> 0
                 INNER JOIN ContainerLinkObject AS CLO_Position
                                                ON CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                               AND CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                               -- AND COALESCE (CLO_Position.ObjectId, 0) <> 0
                 INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                ON CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                               AND CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                                               -- AND COALESCE (CLO_PersonalServiceList.ObjectId, 0) <> 0
            WHERE Container.Amount <> 0
              AND Container.DescId = zc_Container_Summ()
             ;


    -- сохранили <Элемент документа>
    PERFORM lpInsertUpdate_MovementItem_LossPersonal (ioId                    := COALESCE (_tmpMI.MI_Id, 0)
                                                    , inMovementId            := inMovementId
                                                    , inPersonalId            := COALESCE (_tmpMI.PersonalId,  _tmpContainer.PersonalId)
                                                    , inAmount                := COALESCE (_tmpContainer.Amount, _tmpMI.Amount)
                                                    , inBranchId              := COALESCE (_tmpMI.BranchId,    _tmpContainer.BranchId)
                                                    , inInfoMoneyId           := COALESCE (_tmpMI.InfoMoneyId, _tmpContainer.InfoMoneyId)
                                                    , inPositionId            := COALESCE (_tmpMI.PositionId,  _tmpContainer.PositionId)
                                                    , inPersonalServiceListId := COALESCE (_tmpMI.PersonalServiceListId, _tmpContainer.PersonalServiceListId)
                                                    , inUnitId                := COALESCE (_tmpMI.UnitId,     _tmpContainer.UnitId)
                                                    , inComment               := COALESCE (_tmpMI.Comment, '') ::TVarChar
                                                    , inUserId                := vbUserId
                                                     )
    FROM _tmpMI
        FULL JOIN _tmpContainer ON _tmpContainer.PersonalId            = _tmpMI.PersonalId
                               AND _tmpContainer.BranchId              = _tmpMI.BranchId
                               AND _tmpContainer.UnitId                = _tmpMI.UnitId
                               AND _tmpContainer.InfoMoneyId           = _tmpMI.InfoMoneyId
                               AND _tmpContainer.PositionId            = _tmpMI.PositionId
                               AND _tmpContainer.PersonalServiceListId = _tmpMI.PersonalServiceListId
                              ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.02.18         *
*/

-- тест
--